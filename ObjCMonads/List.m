//
//  List.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "List.h"
#import "EXTScope.h"


// flipped array (head is at the last index)
typedef NSArray FArray;

//instance  Monad []  where
//    m >>= k             = concat $ map k m
//    m >> k              = concat $ map (\ _ -> k) m
//    return x            = [x]

@interface List ()

@property (nonatomic, copy, readwrite) FArray* array;
- (instancetype)initWithFArray:(FArray*)array;

@end

List* Empty() {
    return [[List alloc] initWithFArray:@[]];
}

List* Cons(id value, List* list) {
    return [[List alloc] initWithFArray:[list.array arrayByAddingObject:value]];
}

List* Singleton(id value) {
    return [[List alloc] initWithFArray:@[value]];
}

id Head(List* list) {
    return [list.array objectAtIndex:[list.array count] - 1];
}

List* Tail(List* list) {
    return Drop(1, list);
}

int Length(List* list) {
    return (int)[list.array count];
}

List* Drop(int count, List* list) {
    if (count >= [list.array count]) {
        return Empty();
    }
    
    NSArray* subarray = [list.array subarrayWithRange:NSMakeRange(0, [list.array count] - count)];
    return [[List alloc] initWithFArray:subarray];
}

id FoldL(ReduceStepL step, id zero, List* list) {
    __block id accumulator = zero;
    [list.array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        accumulator = step(accumulator, obj);
    }];
    
    return accumulator;
}

id FoldR(ReduceStepR step, id zero, List* list) {
    __block id accumulator = zero;
    [list.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        accumulator = step(obj, accumulator);
    }];
    
    return accumulator;
}

List* Append(List* list1, List* list2) {
    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:[list1.array count] + [list2.array count]];
    [newArray addObjectsFromArray:list2.array];
    [newArray addObjectsFromArray:list1.array];
    return [[List alloc] initWithFArray:newArray];
}

List* Concat(List* list) {
    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:[list.array count]];
    [list.array enumerateObjectsUsingBlock:^(List* obj, NSUInteger idx, BOOL *stop) {
        [newArray addObjectsFromArray:obj.array];
    }];
    return [[List alloc] initWithFArray:newArray];
}

List* Map(Mapping mapping, List* list) {
    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:[list.array count]];
    [list.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [newArray addObject:mapping(obj)];
    }];
    return [[List alloc] initWithFArray:newArray];
}

List* Replicate(int count, id item) {
    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; ++i) {
        [newArray addObject:item];
    }
    return [[List alloc] initWithFArray:newArray];
}

BOOL Elem(id value, List* list) {
    return [list.array containsObject:value];
}

BOOL IsEmpty(List* list) {
    return [list.array count] == 0;
}


@implementation List

- (instancetype)initWithArray:(NSArray*)array {
    NSMutableArray* farray = [NSMutableArray arrayWithCapacity:[array count]];
    
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [farray addObject:obj];
    }];
    
    return [self initWithFArray:farray];
}

- (instancetype)initWithFArray:(FArray*)array {
    self = [super init];
    if (self) {
        self.array = array;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* str = [NSMutableString stringWithString:@"["];
    [self.array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@", obj];
        if (idx > 0) {
            [str appendString:@","];
        }
    }];
    [str appendString:@"]"];
    return [str copy];
}

#pragma mark - Monoid:

+ (id<Monoid>(^)())mempty {
    return ^List*() {
        return Empty();
    };
}

+ (id<Monoid>(^)(id<Monoid>, id<Monoid>))mappend {
    return ^List*(List* list1, List* list2) {
        return Append(list1, list2);
    };
}

+ (id<Monoid>(^)(List*))mconcat {
    return ^List*(List* list) {
        return Concat(list);
    };
}

#pragma mark - Functor:

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^List*(Mapping map, List* ftor) {
        return Map(map, ftor);
    };
}

#pragma mark - Monad:

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^List*(List* mvalue, Continuation cont) {
        Mapping m = ^id(id value) {
            return cont(value, self);
        };
        return Concat(Map(m, mvalue));
    };
}

+ (MonadicValue(^)(id))unit {
    return ^List*(id value) {
        return Singleton(value);
    };
}

@end

