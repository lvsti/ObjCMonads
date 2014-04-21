//
//  Data.Tuple.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeCluster.h"

#define Pair(fst_type, snd_type)    Tuple*


@interface Tuple : TypeCluster<NSCopying>

+ (Tuple*)unit;
+ (Tuple*)pair:(id)a :(id)b;
+ (Tuple*)tupleWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (Tuple*)tupleWithObjectsFromArray:(NSArray*)objects;

- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end


#ifdef __cplusplus
extern "C" {
#endif
    
    Tuple OF()* MkUnit();
    Tuple OF(a, b)* MkPair(id a, id b);
    
    // fst :: (a, b) -> a
    id Fst(Tuple OF(a, b)* tuple);
    
    // snd :: (a, b) -> b
    id Snd(Tuple OF(a, b)* tuple);

    // curry :: ((a, b) -> c) -> a -> b -> c
    id Curry(id(^func)(Tuple*), id a, id b);

    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    id Uncurry(id(^func)(id, id), Tuple* pair);

    // swap :: (a, b) -> (b, a)
    Tuple* Swap(Tuple* pair);
    
#ifdef __cplusplus
}
#endif
