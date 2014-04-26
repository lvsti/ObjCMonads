//
//  NSSet+Functor.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.26..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSSet+Functor.h"

@implementation NSSet (Functor)

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^NSSet*(Mapping func, NSSet* ftor) {
        assert(func);
        assert(ftor);
        NSMutableSet* result = [NSMutableSet setWithCapacity:[ftor count]];
        
        [ftor enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            [result addObject:func(obj)];
        }];
        
        return [result copy];
    };
}

@end
