//
//  Pierre.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.07..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Pierre.h"
#import "Maybe.h"
#import "ObjCObject+Monad.h"
#import "Tuple.h"



typedef NSNumber* Birds;
typedef Pair(Birds, Birds) Pole;

Pole MkPole(int left, int right) {
    return MkPair(@(left), @(right));
}

Pole EmptyPole() {
    return MkPole(0, 0);
}


Maybe OF(Pole)* LandLeft(Birds n, Pole pole) {
    int newLeft = [Fst(pole) intValue] + [n intValue];
    int right = [Snd(pole) intValue];

    return abs(newLeft - right) < 4? Just(MkPole(newLeft, right)): Nothing();
}

Maybe OF(Pole)* LandRight(Birds n, Pole pole) {
    int left = [Fst(pole) intValue];
    int newRight = [Snd(pole) intValue] + [n intValue];
    return abs(left - newRight) < 4? Just(MkPole(left, newRight)): Nothing();
}

Maybe OF(Pole)* Banana(Pole pole) {
    return Nothing();
}


Continuation _LandLeft(Birds n) {
    return MCONT(LandLeft, n);
}

Continuation _LandRight(Birds n) {
    return MCONT(LandRight, n);
}

Continuation _Banana() {
    return MCONT(Banana);
}


void Pierre() {
    id result =
        MBEGIN(Just(EmptyPole())) >=
        MCONT(LandLeft, @1) >=
        MCONT(LandRight, @3) >=
        MCONT(LandLeft, @1) >=
        MCONT(LandRight, @2) >=
        MCONT(Banana) >=
        MCONT(LandLeft, @1) >=
        MCONT(LandLeft, @3)
        MEND;
    
    NSLog(@"pierre: %@", result);
}


void Pierre2() {
    id result =
        Just(EmptyPole()).
        bind(MCONT(LandLeft, @1)).
        bind(MCONT(LandRight, @3)).
        bind(MCONT(LandLeft, @1)).
        bind(MCONT(LandRight, @2)).
        bind(MCONT(Banana)).
        bind(MCONT(LandLeft, @1)).
        bind(MCONT(LandLeft, @3));
    
    NSLog(@"pierre: %@", result);
}

void Pierre3() {
    id result =
        Just(EmptyPole()).
        bind(_LandLeft(@1)).
        bind(_LandRight(@3)).
        bind(_LandLeft(@1)).
        bind(_LandRight(@2)).
        bind(_Banana()).
        bind(_LandLeft(@1)).
        bind(_LandLeft(@3));
    
    NSLog(@"pierre: %@", result);
}


