//
//  Tuple.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Tuple.h"


@interface Tuple ()
@property (nonatomic, copy, readwrite) NSArray* objects;
@end

Tuple* MkUnit() {
    return [[Tuple alloc] initWithObjectsFromArray:@[]];
}

Tuple* MkPair(id a, id b) {
    return [[Tuple alloc] initWithObjectsFromArray:@[a,b]];
}

id Fst(Tuple* tuple) {
    return tuple[0];
}

id Snd(Tuple* tuple) {
    return tuple[1];
}


@implementation Tuple

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

- (BOOL)isEqual:(id)other {
    if (self == other) {
        return YES;
    }
    
    if (!other) {
        return NO;
    }
    
    if ([self class] != [other class]) {
        return NO;
    }
    
    return [self.objects isEqualToArray:((Tuple*)other).objects];
}

- (NSString*)description {
    NSMutableString* str = [NSMutableString stringWithString:@"("];
    [_objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@", obj];
        if (idx < [_objects count] - 1) {
            [str appendString:@","];
        }
    }];
    [str appendString:@")"];
    return [str copy];
}


@end
