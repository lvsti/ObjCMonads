//
//  NSDictionary+Functor.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.26..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSDictionary+Functor.h"

@implementation NSDictionary (Functor)

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^NSDictionary*(Mapping func, NSDictionary* ftor) {
        assert(func);
        assert(ftor);
        NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:[ftor count]];
        
        [ftor enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:func(obj) forKey:key];
        }];
        
        return [result copy];
    };
}

@end
