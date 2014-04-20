//
//  Control.Monad.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.09..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#ifndef CONTROL_MONAD_H
#define CONTROL_MONAD_H

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "List.h"
#import "Maybe.h"
#import "Monad.h"
#import "Tuple.h"


@protocol MonadPlus <Monad>
@required

// mzero :: m a
+ (id<MonadPlus>(^)())mzero;

// mplus :: m a -> m a -> m a
+ (id<MonadPlus>(^)(id<MonadPlus>, id<MonadPlus>))mplus;

@end


@interface List (MonadPlus) <MonadPlus>
@end


@interface Maybe (MonadPlus) <MonadPlus>
@end


#ifdef __cplusplus
extern "C" {
#endif

// Prelude monad functions
    
    // (=<<) :: Monad m => (a -> m b) -> m a -> m b
    MonadicValue BindR(Continuation cont, MonadicValue mvalue);

    // sequence :: Monad m => [m a] -> m [a]
    MonadicValue Sequence(List* mvalues, Class<Monad> m);
    
    // sequence_ :: Monad m => [m a] -> m ()
    MonadicValue Sequence_(List* mvalues, Class<Monad> m);
    
    // mapM :: Monad m => (a -> m b) -> [a] -> m [b]
    MonadicValue MapM(Continuation cont, List* values, Class<Monad> m);

    // mapM_ :: Monad m => (a -> m b) -> [a] -> m ()
    MonadicValue MapM_(Continuation cont, List* values, Class<Monad> m);
    
// Functions mandated by the Prelude

    // guard :: (MonadPlus m) => Bool -> m ()
    MonadicValue Guard(BOOL value, Class<MonadPlus> m);

    // filterM :: (Monad m) => (a -> m Bool) -> [a] -> m [a]
    MonadicValue FilterM(Continuation cont, List* values, Class<Monad> m);
    
    // forM :: Monad m => [a] -> (a -> m b) -> m [b]
    MonadicValue ForM(List* values, Continuation cont, Class<Monad> m);
    
    // forM_ :: Monad m => [a] -> (a -> m b) -> m ()
    MonadicValue ForM_(List* values, Continuation cont, Class<Monad> m);
    
    // msum :: MonadPlus m => [m a] -> m a
    MonadicValue MSum(List* mvalues, Class<MonadPlus> m);
    
    // (>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
    Continuation MComposeL(Continuation contAB, Continuation contBC, Class<Monad> m);
    
    // (<=<) :: Monad m => (b -> m c) -> (a -> m b) -> (a -> m c)
    Continuation MComposeR(Continuation contBC, Continuation contAB, Class<Monad> m);
    
    // forever :: (Monad m) => m a -> m b
    MonadicValue Forever(MonadicValue mvalue);
    
    // void :: Functor f => f a -> f ()
    id<Functor> Void(id<Functor> ftor);
    

// Other monad functions
    
    // join :: (Monad m) => m (m a) -> m a
    MonadicValue Join(MonadicValue mmvalue);
    
    // mapAndUnzipM :: (Monad m) => (a -> m (b,c)) -> [a] -> m ([b], [c])
    MonadicValue MapAndUnzipM(Continuation cont, List* values, Class<Monad> m);
    
    // zipWithM :: (Monad m) => (a -> b -> m c) -> [a] -> [b] -> m [c]
    MonadicValue ZipWithM(MonadicValue(^zipper)(id, id), List* as, List* bs, Class<Monad> m);
    
    // zipWithM_ :: (Monad m) => (a -> b -> m c) -> [a] -> [b] -> m ()
    MonadicValue ZipWithM_(MonadicValue(^zipper)(id, id), List* as, List* bs, Class<Monad> m);
    

    typedef MonadicValue (^MReduceStepL)(id accum, id obj);
    
    // foldM :: (Monad m) => (a -> b -> m a) -> a -> [b] -> m a
    MonadicValue FoldM(MReduceStepL step, id zero, List* values, Class<Monad> m);
    
    // foldM_ :: (Monad m) => (a -> b -> m a) -> a -> [b] -> m ()
    MonadicValue FoldM_(MReduceStepL step, id zero, List* values, Class<Monad> m);

    // replicateM :: (Monad m) => Int -> m a -> m [a]
    MonadicValue ReplicateM(int count, MonadicValue mvalue, Class<Monad> m);

    // replicateM_ :: (Monad m) => Int -> m a -> m ()
    MonadicValue ReplicateM_(int count, MonadicValue mvalue, Class<Monad> m);

    // when :: (Monad m) => Bool -> m () -> m ()
    MonadicValue When(BOOL cond, MonadicValue mvalue, Class<Monad> m);

    // unless :: (Monad m) => Bool -> m () -> m ()
    MonadicValue Unless(BOOL cond, MonadicValue mvalue, Class<Monad> m);

    // liftM :: (Monad m) => (a1 -> r) -> m a1 -> m r
    MonadicValue LiftM(id(^func)(id), MonadicValue mvalue, Class<Monad> m);
    
    // liftM2 :: (Monad m) => (a1 -> a2 -> r) -> m a1 -> m a2 -> m r
    MonadicValue LiftM2(id(^func)(id, id), MonadicValue mvalue1, MonadicValue mvalue2, Class<Monad> m);

    // liftM3 :: (Monad m) => (a1 -> a2 -> a3 -> r) -> m a1 -> m a2 -> m a3 -> m r
    MonadicValue LiftM3(id(^func)(id, id, id),
                        MonadicValue mvalue1,
                        MonadicValue mvalue2,
                        MonadicValue mvalue3,
                        Class<Monad> m);

    // liftM4 :: (Monad m) => (a1 -> a2 -> a3 -> a4 -> r) -> m a1 -> m a2 -> m a3 -> m a4 -> m r
    MonadicValue LiftM4(id(^func)(id, id, id, id),
                        MonadicValue mvalue1,
                        MonadicValue mvalue2,
                        MonadicValue mvalue3,
                        MonadicValue mvalue4,
                        Class<Monad> m);

    // liftM5 :: (Monad m) => (a1 -> a2 -> a3 -> a4 -> a5 -> r) -> m a1 -> m a2 -> m a3 -> m a4 -> m a5 -> m r
    MonadicValue LiftM5(id(^func)(id, id, id, id, id),
                        MonadicValue mvalue1,
                        MonadicValue mvalue2,
                        MonadicValue mvalue3,
                        MonadicValue mvalue4,
                        MonadicValue mvalue5,
                        Class<Monad> m);

    // ap :: (Monad m) => m (a -> b) -> m a -> m b
    MonadicValue Ap(MonadicValue mfunc, MonadicValue mvalue, Class<Monad> m);

// Other MonadPlus functions

    MonadicValue MFilter(BOOL(^pred)(id), MonadicValue mvalue, Class<MonadPlus> m);

    
#ifdef __cplusplus
}
#endif


#endif
