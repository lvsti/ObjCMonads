//
//  Prelude.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Prelude.h"


HOF(Fst, Tuple* pair, {
    return pair[0];
});

HOF(Snd, Tuple* pair, {
    return pair[1];
});

HOF(Pair, id a, id b, {
    return MkPair(a, b);
});

// curry :: ((a, b) -> c) -> a -> b -> c
HOF(Curry, id fnOnPairs, id a, id b, {
    return ((Function)fnOnPairs)(MkPair(a, b));
});

// uncurry :: (a -> b -> c) -> (a, b) -> c
HOF(Uncurry, id curriedFn, Tuple* pair, {
    return ((id(^)(id, id))curriedFn)(pair[0], pair[1]);
});

