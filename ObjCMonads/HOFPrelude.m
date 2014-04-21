//
//  Prelude.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "HOFPrelude.h"

#define HOF_APPLY_CAST(idx, arg)    (( metamacro_if_eq(0, idx)(id)(metamacro_if_eq(1, idx)(Function)(HOFunction)) )(
#define HOF_APPLY_CASTS(...)        metamacro_foreach(HOF_APPLY_CAST, , __VA_ARGS__)

#define HOF_APPLY_ARG(idx, arg)     ))(arg)
#define HOF_APPLY_ARGS(...)         metamacro_foreach(HOF_APPLY_ARG, , __VA_ARGS__)

#define HOF_APPLY(fname, ...) \
    HOF_APPLY_CASTS(__VA_ARGS__) \
    fname() \
    HOF_APPLY_ARGS(__VA_ARGS__)

//IncPair a b c d
//
// ((id)( ((Function)( ((HOFunction)( ((HOFunction)( IncPair() ))(a) ))(b) ))(c) ))(d)

HOF_DEFINE(IncPair, NSNumber* deltaFst, NSNumber* deltaSnd, Tuple* pair, {
    return MkPair(@([_Fst()(pair) intValue] + [deltaFst intValue]),
                  @([_Snd()(pair) intValue] + [deltaSnd intValue]));
});

void aasd() {
    // HOF_APPLY(IncPair, @1, @2);
}

HOF_DEFINE(_Fst, Tuple* pair, {
    return pair[0];
});

HOF_DEFINE(_Snd, Tuple* pair, {
    return pair[1];
});

HOF_DEFINE(_Pair, id a, id b, {
    return MkPair(a, b);
});

// curry :: ((a, b) -> c) -> a -> b -> c
HOF_DEFINE(_Curry, id fnOnPairs, id a, id b, {
    return ((Function)fnOnPairs)(MkPair(a, b));
});

// uncurry :: (a -> b -> c) -> (a, b) -> c
HOF_DEFINE(_Uncurry, id curriedFn, Tuple* pair, {
    return ((id(^)(id, id))curriedFn)(pair[0], pair[1]);
});

