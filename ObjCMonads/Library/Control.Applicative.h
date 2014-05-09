//
//  Control.Applicative.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.26..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Either.h"
#import "EXTConcreteProtocol.h"
#import "Functor.h"
#import "List.h"
#import "Maybe.h"


@protocol Applicative <Functor>
@required

// pure :: a -> f a
+ (Function*)pure;

// (<*>) :: f (a -> b) -> f a -> f b
+ (Function*)ap;

@concrete

// (*>) :: f a -> f b -> f b
+ (Function*)apR;

// (<*) :: f a -> f b -> f a
+ (Function*)apL;

@property (nonatomic, copy, readonly) id<Applicative>(^ap)(id<Applicative>);
@property (nonatomic, copy, readonly) id<Applicative>(^apR)(id<Applicative>);
@property (nonatomic, copy, readonly) id<Applicative>(^apL)(id<Applicative>);

@end


@protocol Alternative <Applicative>
@required

// empty :: f a
+ (id<Alternative>)empty;

// (<|>) :: f a -> f a -> f a
+ (Function*)or;

@concrete

// some :: f a -> f [a]
+ (Function*)some;

// many :: f a -> f [a]
+ (Function*)many;

@property (nonatomic, copy, readonly) id<Alternative>(^or)(id<Alternative>);

@end



@interface Maybe (Applicative) <Applicative>
@end

@interface Maybe (Alternative) <Alternative>
@end

@interface List (Applicative) <Applicative>
@end

@interface List (Alternative) <Alternative>
@end

//instance Applicative IO where
//    pure = return
//    (<*>) = ap


//instance Applicative ((->) a) where
//    pure = const
//    (<*>) f g x = f x (g x)

//instance Monoid a => Applicative ((,) a) where
//    pure x = (mempty, x)
//    (u, f) <*> (v, x) = (u `mappend` v, f x)

@interface Either (Applicative)
@end


@interface ZipList : NSObject

@property (nonatomic, copy, readonly) List* list;

+ (instancetype)zipListWithList:(List*)aList;

@end


@interface ZipList (Functor) <Functor>
@end

@interface ZipList (Applicative) <Applicative>
@end



#ifdef __cplusplus
extern "C" {
#endif

    // (<**>) :: Applicative f => f a -> f (a -> b) -> f b
    id<Applicative> RevAp(id<Applicative> avalue, id<Applicative> afunc);
    
    // liftA :: Applicative f => (a -> b) -> f a -> f b
    id<Applicative> LiftA(Function* func, id<Applicative> avalue);
    
    // liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
    id<Applicative> LiftA2(Function* func, id<Applicative> avalue1, id<Applicative> avalue2);
    
    // liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
    id<Applicative> LiftA3(Function* func, id<Applicative> avalue1, id<Applicative> avalue2, id<Applicative> avalue3);
    
    // optional :: Alternative f => f a -> f (Maybe a)
    id<Alternative> Optional(id<Alternative> avalue);

#ifdef __cplusplus
}
#endif
