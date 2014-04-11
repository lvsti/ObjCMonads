//
//  Pierre.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.07..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Pierre.h"
#import "Maybe.h"
#import "Tuple.h"


typedef NSNumber* Birds;
typedef Pair(Birds, Birds) Pole;

Pole MkPole(int left, int right) {
    return MkPair(@(left), @(right));
}

Pole EmptyPole() {
    return MkPole(0, 0);
}


Continuation LandLeft(Birds n) {
    return ^MonadicValue(Pole pole, Class m) {
        int newLeft = [Fst(pole) intValue] + [n intValue];
        int right = [Snd(pole) intValue];
        
        return abs(newLeft - right) < 4? Just(MkPole(newLeft, right)): Nothing();
    };
}

Continuation LandRight(Birds n) {
    return ^MonadicValue(Pole pole, Class m) {
        int left = [Fst(pole) intValue];
        int newRight = [Snd(pole) intValue] + [n intValue];

        return abs(left - newRight) < 4? Just(MkPole(left, newRight)): Nothing();
    };
}

Continuation Banana() {
    return ^MonadicValue(id value, Class m) {
        return Nothing();
    };
}


void Pierre1() {
    id result =
        Just(EmptyPole()).
        bind(LandLeft(@1)).
        bind(LandRight(@3)).
        bind(LandLeft(@1)).
        bind(LandRight(@2)).
        bind(Banana()).
        bind(LandLeft(@1)).
        bind(LandLeft(@3));
    
    NSLog(@"pierre: %@", result);
}



// -----------------------------------------------------------------------------



#import "metamacros.h"

#define metamacro_argcount0(...) metamacro_if_eq( metamacro_argcount(__VA_ARGS__), metamacro_argcount( foo, ## __VA_ARGS__) )( metamacro_dec(metamacro_argcount(__VA_ARGS__)) )(metamacro_argcount(__VA_ARGS__))

#define MCONT_SEP(...) metamacro_if_eq(0, metamacro_argcount0(__VA_ARGS__))()(,)
#define MCONT(fname, ...) \
    ^MonadicValue(id value, Class m) { \
        return (MonadicValue)fname( \
            __VA_ARGS__ \
            MCONT_SEP(__VA_ARGS__) \
            value ); \
    }

#define OF(...)


// _LandLeft :: NSNumber* -> Pole -> Maybe Pole
// _LandLeft @42 :: Pole -> Maybe Pole   ~   a -> m b
Maybe OF(Pole)* _LandLeft(Birds n, Pole pole) {
    int newLeft = [Fst(pole) intValue] + [n intValue];
    int right = [Snd(pole) intValue];

    return abs(newLeft - right) < 4? Just(MkPole(newLeft, right)): Nothing();
}

Maybe OF(Pole)* _LandRight(Birds n, Pole pole) {
    int left = [Fst(pole) intValue];
    int newRight = [Snd(pole) intValue] + [n intValue];
    return abs(left - newRight) < 4? Just(MkPole(left, newRight)): Nothing();
}

Maybe OF(Pole)* _Banana(Pole pole) {
    return Nothing();
}


void Pierre2() {
    id result =
        Just(EmptyPole()).
        bind(MCONT(_LandLeft, @1)).
        bind(MCONT(_LandRight, @3)).
        bind(MCONT(_LandLeft, @1)).
        bind(MCONT(_LandRight, @2)).
        bind(MCONT(_Banana)).
        bind(MCONT(_LandLeft, @1)).
        bind(MCONT(_LandLeft, @3));
    
    NSLog(@"pierre: %@", result);
}



// -----------------------------------------------------------------------------



#import "ObjCObject+Monad.h"



void Pierre3() {
    id result = (ObjCObject(Just(EmptyPole())) >=
        LandLeft(@1) >=
        LandRight(@3) >=
        LandLeft(@1) >=
        LandRight(@2) >=
        Banana() >=
        LandLeft(@1) >=
        LandLeft(@3)
    )._object;

    NSLog(@"pierre: %@", result);
}



















void Pierre4() {
    id result =
        MBEGIN(Just(EmptyPole())) >=
        MCONT(_LandLeft, @1) >=
        MCONT(_LandRight, @3) >=
        MCONT(_LandLeft, @1) >=
        MCONT(_LandRight, @2) >=
        MCONT(_Banana) >=
        MCONT(_LandLeft, @1) >=
        MCONT(_LandLeft, @3)
        MEND;
    
    NSLog(@"pierre: %@", result);
}



