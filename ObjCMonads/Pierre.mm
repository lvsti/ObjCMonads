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


Maybe(Pole) LandLeft(Birds n, Pole pole) {
    int newLeft = [Fst(pole) intValue] + [n intValue];
    int right = [Snd(pole) intValue];

    return abs(newLeft - right) < 4? Just(MkPole(newLeft, right)): Nothing();
}

Maybe(Pole) LandRight(Birds n, Pole pole) {
    int left = [Fst(pole) intValue];
    int newRight = [Snd(pole) intValue] + [n intValue];
    return abs(left - newRight) < 4? Just(MkPole(left, newRight)): Nothing();
}

Maybe(Pole) Banana(Pole pole) {
    return Nothing();
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


