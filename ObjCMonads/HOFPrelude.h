//
//  Prelude.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "metamacros.h"
#import "Tuple.h"


#define HOF_KIND(idx, argc)                 metamacro_if_eq(0, idx)(metamacro_if_eq(1, argc)(Function)(HOFunction))(Function)
#define HOF_HEAD(fname, argc)               HOF_KIND(0, argc) fname()
#define HOF_DEF_PARAM_COUNT(...)            metamacro_dec(metamacro_argcount(__VA_ARGS__))
#define HOF_DEF_PARAMS(...)                 metamacro_take(HOF_DEF_PARAM_COUNT(__VA_ARGS__), __VA_ARGS__)
#define HOF_DEF_BODY(...)                   metamacro_drop(HOF_DEF_PARAM_COUNT(__VA_ARGS__), __VA_ARGS__)
#define HOF_DEF_LAYER_BEGIN(idx, ctx, arg)  { return (HOF_KIND(idx, ctx))^id(arg)
#define HOF_DEF_LAYER_END(idx, arg)         ; }
#define HOF_DECL_PARAM_COUNT(...)           metamacro_argcount(__VA_ARGS__)

#define HOF_DEFINE(fname, ...) \
    HOF_HEAD(fname, HOF_DEF_PARAM_COUNT(__VA_ARGS__)) \
    metamacro_foreach_cxt(HOF_DEF_LAYER_BEGIN,  , HOF_DEF_PARAM_COUNT(__VA_ARGS__), HOF_DEF_PARAMS(__VA_ARGS__)) \
    HOF_DEF_BODY(__VA_ARGS__) \
    metamacro_foreach(HOF_DEF_LAYER_END, , HOF_DEF_PARAMS(__VA_ARGS__))

#define HOF_DECLARE(fname, ...) \
    HOF_HEAD(fname, HOF_DECL_PARAM_COUNT(__VA_ARGS__));


typedef id(^Function)(id);
typedef Function(^HOFunction)(id);

#ifdef __cplusplus
extern "C" {
#endif

    // fst :: (a, b) -> a
    HOF_DECLARE(_Fst, Tuple* pair);
    
    // snd :: (a, b) -> b
    HOF_DECLARE(_Snd, Tuple* pair);
    
    // (,) :: a -> b -> (a, b)
    HOF_DECLARE(_Pair, id a, id b);
    
    // curry :: ((a, b) -> c) -> a -> b -> c
    HOF_DECLARE(_Curry, id pairFn, id a, id b);
    
    // uncurry :: (a -> b -> c) -> (a, b) -> c
    HOF_DECLARE(_Uncurry, id binFn, Tuple* pair);
    
#ifdef __cplusplus
}
#endif

