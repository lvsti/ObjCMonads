//
//  Monad.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Monad.h"
#import "EXTScope.h"

@concreteprotocol(Monad)

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    assert(NO);
    return nil;
}

+ (MonadicValue(^)(id))unit {
    assert(NO);
    return nil;
}

+ (MonadicValue(^)(MonadicValue, MonadicValue))bind_ {
    return ^MonadicValue(MonadicValue mvalue0, MonadicValue mvalue1) {
        return [self bind](mvalue0, ^MonadicValue(id x, Class m) { return mvalue1; });
    };
}

- (MonadicValue(^)(Continuation))bind {
    @weakify(self);
    return ^MonadicValue(Continuation cont) {
        @strongify(self);
        return [[self class] bind](self, cont);
    };
}

- (MonadicValue(^)(MonadicValue))bind_ {
    @weakify(self);
    return ^MonadicValue(MonadicValue mvalue) {
        @strongify(self);
        return [[self class] bind](self, ^MonadicValue(id x, Class m) { return mvalue; });
    };
}


@end
