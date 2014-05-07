//
//  NSInvocation+Function.m
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.29..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSInvocation+Function.h"
#import "Function.h"


@implementation NSInvocation (Function)

- (void)setArgumentsWithArray:(NSArray*)args
              startingAtIndex:(NSInteger)startIndex {
    return [self setArgumentsWithArray:args
                       startingAtIndex:startIndex
                        usingSignature:[self methodSignature]];
}

- (void)setArgumentsWithArray:(NSArray*)args
              startingAtIndex:(NSInteger)startIndex
               usingSignature:(NSMethodSignature*)signature {
    [args enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        const char* argType = [signature getArgumentTypeAtIndex:startIndex + idx];
        
        if (argType[0] == '@' || argType[0] == '^') {
            if (obj == [Function nullArg]) {
                obj = nil;
            }
            [self setArgument:&obj atIndex:startIndex + idx];
        } else {
            // it's not NSObject, assuming an NSValue of the same kind
            assert([obj isKindOfClass:[NSValue class]]);

            // don't require strict type equivalence for NSNumbers
            if (![obj isKindOfClass:[NSNumber class]]) {
                assert(!strcmp([obj objCType], argType));
            }
            
            NSUInteger size = 0;
            NSGetSizeAndAlignment(argType, &size, NULL);
            void* buf = malloc(size);
            [(NSValue*)obj getValue:buf];
            [self setArgument:buf atIndex:startIndex + idx];
            free(buf);
        }
    }];
}

@end
