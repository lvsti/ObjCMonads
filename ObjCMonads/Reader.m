//
//  Reader.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Reader.h"


@interface Reader ()

@property (nonatomic, copy, readwrite) Computation computation;
- (instancetype)initWithComputation:(Computation)comp;

@end


Reader* MkReader(Computation comp) {
    return [[Reader alloc] initWithComputation:comp];
}

id RunReader(Reader* m, Environment env) {
    return m.computation(env);
}

Reader* Ask() {
    return MkReader(^id(Environment env) {
        return env;
    });
}

Reader* AskS(EnvironmentSelector sel) {
    return MkReader(^id(Environment env) {
        return sel(env);
    });
}

Reader* Local(EnvironmentModifier mod, Reader* m) {
    return MkReader(^id(Environment env) {
        return m.computation(mod(env));
    });
}


@implementation Reader

- (instancetype)initWithComputation:(Computation)comp {
    self = [super init];
    if (self) {
        self.computation = comp;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

#pragma mark - Functor:

+ (Function*)fmap {
    return [Function fromBlock:^Reader*(Function* func, Reader* ftor) {
        return MkReader(^id(Environment env) {
            return [func :RunReader(ftor, env)];
        });
    }];
}

#pragma mark - Monad:

+ (Function*)bind {
    return [Function fromBlock:^Reader*(Reader* mvalue, FunctionM* cont) {
        return MkReader(^id(Environment env) {
            return RunReader([[cont :mvalue.computation(env)] :self], env);
        });
    }];
}

+ (Function*)unit {
    return [Function fromBlock:^Reader*(id value) {
        return MkReader(^id(Environment env) {
            return value;
        });
    }];
}


@end
