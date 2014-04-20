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


@implementation TypedCluster

- (instancetype)initWithClusterClass:(Class)clusterClass
                      typeParameters:(NSArray*)typeParams {
    assert(clusterClass);
    assert(typeParams);

    NSMutableString* typeSpec = [NSMutableString string];
    [typeParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [typeSpec appendString:@"_"];
        [typeSpec appendString:NSStringFromClass(obj)];
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

