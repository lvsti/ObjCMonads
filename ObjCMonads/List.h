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

typedef id(^ReduceStepL)(id accum, id obj);
typedef id(^ReduceStepR)(id obj, id accum);


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
    id FoldL(ReduceStepL step, id zero, List* list);
    id FoldR(ReduceStepR step, id zero, List* list);
    List* Append(List* list1, List* list2);
    List* Concat(List* list);
    List* Map(Mapping mapping, List* list);
    List* Replicate(int count, id item);
    BOOL Elem(id value, List* list);
    BOOL IsEmpty(List* list);
    
#ifdef __cplusplus
}
#endif
