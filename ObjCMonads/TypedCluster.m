//
//  TypedCluster.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.20..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "TypedCluster.h"
#import <objc/runtime.h>

static const char* kClusterClassKey = "TypedCluster.clusterClass";
static const char* kTypeParametersKey = "TypedCluster.typeParameters";


struct BlockDescriptor {
    unsigned long _reserved;
    unsigned long _size;
    void* _rest[1];
};

struct Block {
    void* _isa;
    int _flags;
    int _reserved;
    void (*_invoke)(void*, ...);
    struct BlockDescriptor* _descriptor;
};

static const char* SignatureForBlock(id blockObj) {
    struct Block* block = (__bridge void*)blockObj;
    struct BlockDescriptor* descriptor = block->_descriptor;
    
    int copyDisposeFlag = 1 << 25;
    int signatureFlag = 1 << 30;
    
    assert(block->_flags & signatureFlag);
    
    int index = 0;
    if (block->_flags & copyDisposeFlag) {
        index += 2;
    }
    
    return descriptor->_rest[index];
}

NSString* StringFromBlockSignature(const char* rawsig) {
    assert(rawsig);
    NSString* sigstr = [NSString stringWithUTF8String:rawsig];
    NSArray* components = [sigstr componentsSeparatedByCharactersInSet:
                           [NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
    sigstr = [components componentsJoinedByString:@""];
    
    const char* sig = [sigstr UTF8String];
    long len = strlen(sig);
    assert(len >= 3);
    
    // return value
    NSMutableString* str = [NSMutableString string];
    if (sig[0] == '@') {
        [str appendString:@"id"];
    } else {
        [str appendString:@"(id(^)(?))"];
    }

    // skip "@?"
    [str appendString:@"(^)("];
    for (int i = 3; i < len; ++i) {
        if (sig[i] == '@') {
            [str appendString:@"id"];
        } else if (sig[i] == '?') {
            [str appendString:@"(id(^)(?))"];
        }
        
        if (i < len - 1) {
            [str appendString:@","];
        }
    }
    [str appendString:@")"];
    
    return [str copy];
}


@implementation TypedCluster

- (instancetype)initWithClusterClass:(Class)clusterClass
                          parameters:(NSArray*)params {
    assert(clusterClass);
    assert(params);

    NSMutableArray* typeParams = [NSMutableArray arrayWithCapacity:[params count]];
    NSMutableString* typeSpec = [NSMutableString string];
    [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [typeSpec appendString:@"_("];

        // make some foundation class clusters decay into the abstract type
        if ([obj isKindOfClass:[NSString class]]) {
            [typeSpec appendString:@"NSString"];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            [typeSpec appendString:@"NSNumber"];
        } else if ([obj isKindOfClass:[NSClassFromString(@"NSBlock") class]]) {
            [typeSpec appendFormat:@"%@", StringFromBlockSignature(SignatureForBlock(obj))];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [typeSpec appendString:@"NSDictionary"];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [typeSpec appendString:@"NSArray"];
        } else if ([obj isKindOfClass:[NSSet class]]) {
            [typeSpec appendString:@"NSSet"];
        } else {
            [typeSpec appendFormat:@"%@", NSStringFromClass([obj class])];
        }

        [typeSpec appendString:@")"];
        [typeParams addObject:[obj class]];
    }];
    
    NSString* clusterName = NSStringFromClass(clusterClass);
    NSString* subclassName = [typeSpec length] > 0? [NSString stringWithFormat:@"%@%@", clusterName, typeSpec]: clusterName;

    Class subclass = NSClassFromString(subclassName);
    if (!subclass) {
        subclass = objc_allocateClassPair(clusterClass, [subclassName UTF8String], 0);
        assert(subclass);
        objc_registerClassPair(subclass);
        
        objc_setAssociatedObject((id)subclass, kClusterClassKey, clusterClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject((id)subclass, kTypeParametersKey, typeParams, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    self = [[subclass alloc] init];
    return self;
}

+ (Class)clusterClass {
    return objc_getAssociatedObject(self, kClusterClassKey);
}

+ (NSArray*)typeParameters {
    return objc_getAssociatedObject(self, kTypeParametersKey);
}

@end

