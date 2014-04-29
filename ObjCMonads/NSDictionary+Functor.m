//
//  NSDictionary+Functor.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.26..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSDictionary+Functor.h"

@implementation NSDictionary (Functor)

+ (Function*)fmap {
    return [Function fromBlock:^NSArray*(Function* func, NSDictionary* ftor) {
        assert(func);
        assert(ftor);
        NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:[ftor count]];
        
        [ftor enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [result setObject:[func :obj] forKey:key];
        }];
        
        return [result copy];
    }];
}

@end
