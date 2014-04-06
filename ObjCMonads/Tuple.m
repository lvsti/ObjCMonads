//
//  Tuple.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Tuple.h"

@implementation Tuple {
    NSArray* _objects;
}

+ (instancetype)empty {
    return [[Tuple alloc] initWithObjectsFromArray:@[]];
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

@end
