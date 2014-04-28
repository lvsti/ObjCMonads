//
//  NSInvocation+Extensions.m
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.29..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSInvocation+Extensions.h"


@implementation NSInvocation (Extensions)

- (id)returnedObject {
    NSMethodSignature* ms = [self methodSignature];
    const char* retType = [ms methodReturnType];
    return [self returnedObjectWithObjCType:retType];
}

- (id)returnedObjectWithObjCType:(const char*)retType {
    assert(retType[0] != 'v');

    id retval = nil;
    
    if (retType[0] == '@') {
        CFTypeRef ref;
        [self getReturnValue:&ref];
        if (ref) {
            CFRetain(ref);
        }
        retval = (__bridge_transfer id)ref;
    } else {
        NSUInteger size = 0;
        NSGetSizeAndAlignment(retType, &size, NULL);
        void* buf = malloc(size);
        [self getReturnValue:buf];
        
        const char* numberTypes = "cCsSiIlLqQfd";
        char* numType = strchr(numberTypes, retType[0]);
        
        if (numType) {
            SEL constructors[] = {
                @selector(numberWithChar:),
                @selector(numberWithUnsignedChar:),
                @selector(numberWithShort:),
                @selector(numberWithUnsignedShort:),
                @selector(numberWithInt:),
                @selector(numberWithUnsignedInt:),
                @selector(numberWithLong:),
                @selector(numberWithUnsignedLong:),
                @selector(numberWithFloat:),
                @selector(numberWithDouble:)
            };

            char numSig[] = "@@:X\0";
            numSig[3] = retType[0];
            
            NSInvocation* inv = [NSInvocation invocationWithMethodSignature:
                                 [NSMethodSignature signatureWithObjCTypes:numSig]];
            [inv setTarget:(id)[NSNumber class]];
            [inv setSelector:constructors[numType - numberTypes]];
            [inv setArgument:buf atIndex:2];
            [inv invoke];
            
            CFTypeRef ref;
            [inv getReturnValue:&ref];
            if (ref) {
                CFRetain(ref);
            }
            retval = (__bridge_transfer id)ref;
        } else {
            retval = [NSValue valueWithBytes:buf objCType:retType];
        }
        
        free(buf);
    }
    
    return retval;
}


@end
