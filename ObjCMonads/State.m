//
//  State.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "State.h"


@interface State ()
@property (nonatomic, copy, readwrite) Transition transition;
- (instancetype)initWithTransition:(Transition)trans;
@end


State* MkState(Transition trans) {
    return [[State alloc] initWithTransition:trans];
}

Tuple* RunState(State* m, TState state) {
    return m.transition(state);
}

State* Get() {
    return MkState(^Tuple*(TState state) {
        return MkPair(state, state);
    });
}

State* Put(id newState) {
    return MkState(^Tuple*(TState state) {
        return MkPair(MkUnit(), newState);
    });
}

State* Modify(StateModifier mod) {
    return MkState(^Tuple*(TState state) {
        return MkPair(MkUnit(), mod(state));
    });
}

State* GetS(StateSelector sel) {
    return MkState(^Tuple*(TState state) {
        return MkPair(sel(state), state);
    });
}


@implementation State

- (instancetype)initWithTransition:(Transition)trans {
    self = [super init];
    if (self) {
        self.transition = trans;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

#pragma mark - Functor:

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^State*(Mapping map, State* ftor) {
        return MkState(^Tuple*(TState state0) {
            Tuple* pair = RunState(ftor, state0);
            id a = pair[0];
            TState state1 = pair[1];
            return MkPair(map(a), state1);
        });
    };
}

#pragma mark - Monad:

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^MonadicValue(State* mvalue, Continuation cont) {
        return MkState(^Tuple*(TState state0) {
            //    m >>= cont  = StateT $ \s -> do
            //        (a, s') <- runStateT m s
            //        runStateT (cont a) s'
            Tuple* pair = RunState(mvalue, state0);
            id a = pair[0];
            TState state1 = pair[1];
            return RunState((State*)cont(a), state1);
        });
    };
}

+ (MonadicValue(^)(id))unit {
    return ^State*(id value) {
        return MkState(^Tuple*(TState state) {
            return MkPair(value, state);
        });
    };
}


@end
