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

id FoldL(Function* step, id zero, List* list) {
    __block id accumulator = zero;
    [list.array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        accumulator = [step :accumulator :obj];
    }];
    
    return accumulator;
}

id FoldR(Function* step, id zero, List* list) {
    __block id accumulator = zero;
    [list.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        accumulator = [step :obj :accumulator];
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

List* Map(Function* func, List* list) {
    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:[list.array count]];
    [list.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [newArray addObject:[func :obj]];
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


Tuple* Unzip(List* tuples) {
    return FoldR(^id(Tuple* obj, Tuple* accum) {
        return MkPair(Cons(Fst(obj), Fst(accum)), Cons(Snd(obj), Snd(accum)));
    }, MkPair(Empty(), Empty()), tuples);
}

List* ZipWith(Function* zipper, List* as, List* bs) {
    if (IsEmpty(as) || IsEmpty(bs)) {
        return Empty();
    }
    
    return Cons([zipper :Head(as) :Head(bs)], ZipWith(zipper, Tail(as), Tail(bs)));
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

+ (id<Monoid>)mempty {
    return Empty();
}

+ (Function*)mappend {
    return [Function fromBlock:^List*(List* list1, List* list2) {
        return Append(list1, list2);
    }];
}

+ (Function*)mconcat {
    return [Function fromBlock:^List*(List* list) {
        return Concat(list);
    }];
}

#pragma mark - Functor:

+ (Function*)fmap {
    return [Function fromBlock:^List*(Function* func, List* ftor) {
        return Map(func, ftor);
    }];
}

#pragma mark - Monad:

+ (Function*)bind {
    return [Function fromBlock:^List*(List* mvalue, FunctionM* cont) {
        Function* mapping = ^id(id value) { return [cont :value :self]; };
        return Concat(Map([Function fromBlock:mapping], mvalue));
    }];
}

+ (Function*)unit {
    return [Function fromBlock:^List*(id value) {
        return Singleton(value);
    }];
}

@end

