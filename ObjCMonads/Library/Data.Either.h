//
//  Data.Either.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "Monad.h"
#import "TypeCluster.h"

@class List;
@class Tuple;

@interface Either : TypeCluster<Monad, Functor, NSCopying>

+ (Either*)left:(id)lvalue;
+ (Either*)right:(id)rvalue;

@end

#ifdef __cplusplus
extern "C" {
#endif

    Either* Left(id lvalue);
    Either* Right(id rvalue);
    
    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    id WithEither(id(^funcAC)(id), id(^funcBC)(id), Either OF(a, b)* either);

    // lefts :: [Either a b] -> [a]
    List* Lefts(List* eithers);

    // rights :: [Either a b] -> [b]
    List* Rights(List* eithers);
    
    // partitionEithers :: [Either a b] -> ([a],[b])
    Tuple* PartitionEithers(List* eithers);
    
    BOOL IsLeft(Either* e);
    BOOL IsRight(Either* e);
    id FromLeft(Either* e);
    id FromRight(Either* e);

#ifdef __cplusplus
}
#endif

