//
//  Functor.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Functor.h"

@concreteprotocol(Functor)

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    assert(NO);
    return nil;
}

+ (id<Functor>(^)(id, id<Functor>))freplace {
    return ^id<Functor>(id value, id<Functor> ftor) {
        Mapping m = ^id(id x) { return value; };
        return [self fmap](m, ftor);
    };
}

@end
