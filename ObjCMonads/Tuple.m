//
//  Tuple.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Tuple.h"


Tuple* MkUnit() {
    return [[Tuple alloc] initWithObjectsFromArray:@[]];
}

Tuple* MkPair(id a, id b) {
    return [[Tuple alloc] initWithObjectsFromArray:@[a,b]];
}


@implementation Tuple {
    NSArray* _objects;
}

- (instancetype)initWithObjectsFromArray:(NSArray*)array {
    assert(array);
    self = [super init];
    if (self) {
        _objects = array;
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return _objects[index];
}

- (int)size {
    return (int)[_objects count];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* str = [NSMutableString stringWithString:@"("];
    [_objects enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@", obj];
        if (idx > 0) {
            [str appendString:@","];
        }
    }];
    [str appendString:@")"];
    return [str copy];
}


@end
