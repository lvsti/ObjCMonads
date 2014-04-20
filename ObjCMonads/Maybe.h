//
//  Maybe.h
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


@interface Maybe : TypeCluster<Monad, Functor, NSCopying>

+ (Maybe*)just:(id)value;
+ (Maybe*)nothing;

@end

#ifdef __cplusplus
extern "C" {
#endif
    
    Maybe* Just(id value);
    Maybe* Nothing();
    
// Functions over Maybe

    // maybe :: b -> (a -> b) -> Maybe a -> b
    id WithMaybe(id defValue, Mapping func, Maybe* mvalue);

    // isJust :: Maybe a -> Bool
    BOOL IsJust(Maybe* mvalue);
    
    // isNothing :: Maybe a -> Bool
    BOOL IsNothing(Maybe* mvalue);
    
    // fromJust :: Maybe a -> a
    id FromJust(Maybe* mvalue);
    
    // fromMaybe :: a -> Maybe a -> a
    id FromMaybe(id defValue, Maybe* mvalue);
    
    // maybeToList :: Maybe a -> [a]
    List* MaybeToList(Maybe* mvalue);

    // listToMaybe :: [a] -> Maybe a
    Maybe* ListToMaybe(List* values);
    
    // catMaybes :: [Maybe a] -> [a]
    List* CatMaybes(List* mvalues);

    // mapMaybe :: (a -> Maybe b) -> [a] -> [b]
    List* MapMaybe(Maybe*(^func)(id), List* values);
    
#ifdef __cplusplus
}
#endif

