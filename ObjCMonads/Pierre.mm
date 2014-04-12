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


@interface Pole : NSObject
@property int left;
@property int right;
@end

@implementation Pole
@end


Pole* MkPole(int left, int right) {
    Pole* pole = [Pole new];
    pole.left = left;
    pole.right = right;
    return pole;
}

Pole* EmptyPole() {
    return MkPole(0, 0);
}


Continuation LandLeft(int birds) {
    return ^MonadicValue(Pole* pole, Class m) {
        int newLeft = pole.left + birds;
        int right = pole.right;
        
        return abs(newLeft - right) < 4? Just(MkPole(newLeft, right)): Nothing();
    };
}

Continuation LandRight(int birds) {
    return ^MonadicValue(Pole* pole, Class m) {
        int left = pole.left;
        int newRight = pole.right + birds;

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
        bind(LandLeft(1)).
        bind(LandRight(3)).
        bind(LandLeft(1)).
        bind(LandRight(2)).
        bind(Banana()).
        bind(LandLeft(1)).
        bind(LandLeft(3));
    
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


// _LandLeft :: int -> Pole -> Maybe Pole
// _LandLeft 42 :: Pole -> Maybe Pole   ~   a -> m b
Maybe OF(Pole*)* _LandLeft(int birds, Pole* pole) {
    int newLeft = pole.left + birds;
    int right = pole.right;

    return abs(newLeft - right) < 4? Just(MkPole(newLeft, right)): Nothing();
}

Maybe OF(Pole*)* _LandRight(int birds, Pole* pole) {
    int left = pole.left;
    int newRight = pole.right + birds;
    return abs(left - newRight) < 4? Just(MkPole(left, newRight)): Nothing();
}

Maybe OF(Pole*)* _Banana(Pole* pole) {
    return Nothing();
}


void Pierre2a() {
    id result =
        Just(EmptyPole()).
        bind(MCONT(_LandLeft, 1)).
        bind(MCONT(_LandRight, 3)).
        bind(MCONT(_LandLeft, 1)).
        bind(MCONT(_LandRight, 2)).
        bind(MCONT(_Banana)).
        bind(MCONT(_LandLeft, 1)).
        bind(MCONT(_LandLeft, 3));
    
    NSLog(@"pierre: %@", result);
}






#define MCONT_BEGIN(monad, type, fname, ...) \
    Continuation fname(__VA_ARGS__) { \
        return ^MonadicValue(type value, Class m )
#define MCONT_END ; }


MCONT_BEGIN(Maybe*, Pole*, __LandLeft, int birds) {
    int newLeft = value.left + birds;
    int right = value.right;

    return abs(newLeft - right) < 4? Just(MkPole(newLeft, right)): Nothing();
}
MCONT_END;

MCONT_BEGIN(Maybe*, Pole*, __LandRight, int birds) {
    int left = value.left;
    int newRight = value.right + birds;
    
    return abs(left - newRight) < 4? Just(MkPole(left, newRight)): Nothing();
}
MCONT_END;

MCONT_BEGIN(Maybe*, Pole*, __Banana) {
    return Nothing();
}
MCONT_END;




void Pierre2b() {
    id result =
        Just(EmptyPole()).
        bind(__LandLeft(1)).
        bind(__LandRight(3)).
        bind(__LandLeft(1)).
        bind(__LandRight(2)).
        bind(__Banana()).
        bind(__LandLeft(1)).
        bind(__LandLeft(3));
    
    NSLog(@"pierre: %@", result);
}





// -----------------------------------------------------------------------------



#import "ObjCObject+Monad.h"



void Pierre3() {
    id result = (ObjCObject(Just(EmptyPole())) >=
        LandLeft(1) >=
        LandRight(3) >=
        LandLeft(1) >=
        LandRight(2) >=
        Banana() >=
        LandLeft(1) >=
        LandLeft(3)
    )._object;

    NSLog(@"pierre: %@", result);
}









void Pierre4() {
    id result =
        MBEGIN(Just(EmptyPole())) >=
        __LandLeft(1) >=
        __LandRight(3) >=
        __LandLeft(1) >=
        __LandRight(2) >=
        __Banana() >=
        __LandLeft(1) >=
        __LandLeft(3)
        MEND;
    
    NSLog(@"pierre: %@", result);
}



