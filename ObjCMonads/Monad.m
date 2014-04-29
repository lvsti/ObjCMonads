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

+ (Function*)bind {
    assert(NO);
    return nil;
}

+ (Function*)unit {
    assert(NO);
    return nil;
}

+ (Function*)bind_ {
    return [Function fromBlock:^MonadicValue(MonadicValue mvalue0, MonadicValue mvalue1) {
        return [[[self bind] :mvalue0] :[Function fromBlock:^MonadicValue(id x, Class m) { return mvalue1; }]];
    }];
}

- (MonadicValue(^)(FunctionM*))bind {
    @weakify(self);
    return ^MonadicValue(FunctionM* cont) {
        @strongify(self);
        return [[[[self class] bind] :self] :cont];
    };
}

- (MonadicValue(^)(MonadicValue))bind_ {
    @weakify(self);
    return ^MonadicValue(MonadicValue mvalue) {
        @strongify(self);
        return [[[[self class] bind] :self] :[Function fromBlock:^MonadicValue(id x, Class m) { return mvalue; }]];
    };
}


@end
