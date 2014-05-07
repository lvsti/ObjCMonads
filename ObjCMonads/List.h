//
//  List.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "Monad.h"
#import "Monoid.h"
#import "Tuple.h"


@interface List : NSObject<Monad, Functor, Monoid, NSCopying>

- (instancetype)initWithArray:(NSArray*)array;

@end

#ifdef __cplusplus
extern "C" {
#endif
    
    List* Empty();
    List* Cons(id value, List* list);
    List* Singleton(id value);
    id Head(List* list);
    List* Tail(List* list);
    int Length(List* list);
    List* Drop(int count, List* list);
    id FoldL(Function* step, id zero, List* list);
    id FoldR(Function* step, id zero, List* list);
    List* Append(List* list1, List* list2);
    List* Concat(List* list);
    List* Map(Function* func, List* list);
    List* Replicate(int count, id item);
    BOOL Elem(id value, List* list);
    BOOL IsEmpty(List* list);
    
    // unzip :: [(a, b)] -> ([a], [b])
    Tuple* Unzip(List* tuples);
    
    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    List* ZipWith(Function* zipper, List* as, List* bs);
    
    

    
#ifdef __cplusplus
}
#endif
