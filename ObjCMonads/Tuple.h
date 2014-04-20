//
//  Tuple.h
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
    id Fst(Tuple OF(a, b)* tuple);
    id Snd(Tuple OF(a, b)* tuple);
    
#ifdef __cplusplus
}
#endif
