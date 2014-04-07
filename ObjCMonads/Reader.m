//
//  Reader.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Reader.h"
#undef Reader


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

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^Reader*(Mapping map, Reader* ftor) {
        return MkReader(^id(Environment env) {
            return map(RunReader(ftor, env));
        });
    };
}

#pragma mark - Monad:

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^Reader*(Reader* mvalue, Continuation cont) {
        return MkReader(^id(Environment env) {
            return RunReader((Reader*)cont(mvalue.computation(env)), env);
        });
    };
}

+ (MonadicValue(^)(id))unit {
    return ^Reader*(id value) {
        return MkReader(^id(Environment env) {
            return value;
        });
    };
}


@end
