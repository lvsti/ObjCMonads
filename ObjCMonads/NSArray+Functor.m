//
//  NSArray+Functor.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.26..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSArray+Functor.h"

@implementation NSArray (Functor)

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^NSArray*(Mapping func, NSArray* ftor) {
        assert(func);
        assert(ftor);
        NSMutableArray* result = [NSMutableArray arrayWithCapacity:[ftor count]];

        [ftor enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [result addObject:func(obj)];
        }];
        
        return [result copy];
    };
}

@end
