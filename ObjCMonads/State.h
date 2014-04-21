//
//  State.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "Monad.h"
#import "Data.Tuple.h"

typedef id TState;
typedef Tuple*(^Transition)(TState);
typedef TState(^StateModifier)(TState);
typedef id(^StateSelector)(TState);


@interface State : NSObject<Monad, Functor, NSCopying>

@end

#ifdef __cplusplus
extern "C" {
#endif

    State* MkState(Transition trans);
    Tuple* RunState(State* m, TState state);
    State* Get();
    State* Put(TState state);
    State* Modify(StateModifier mod);
    State* GetS(StateSelector sel);

#ifdef __cplusplus
}
#endif

