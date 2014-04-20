//
//  Tuple.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Tuple.h"


@interface Tuple ()
@property (nonatomic, copy) NSArray* objects;
@end


Tuple* MkUnit() {
    return [Tuple unit];
}

Tuple* MkPair(id a, id b) {
    return [Tuple pair:a :b];
}

id Fst(Tuple* tuple) {
    assert([[tuple class] clusterClass] == [Tuple class]);
    assert([[[tuple class] typeParameters] count] == 2);
    return tuple[0];
}

id Snd(Tuple* tuple) {
    assert([[tuple class] clusterClass] == [Tuple class]);
    assert([[[tuple class] typeParameters] count] == 2);
    return tuple[1];
}


@implementation Tuple

+ (Tuple*)unit {
    return [[Tuple alloc] initWithObjectsFromArray:@[]];
}

+ (Tuple*)pair:(id)a :(id)b {
    assert(a && b);
    return [[Tuple alloc] initWithObjectsFromArray:@[a, b]];
}

+ (Tuple*)tupleWithObjects:(id)firstObj, ... {
    NSMutableArray* params = [NSMutableArray array];
    
    if (firstObj) {
        [params addObject:firstObj];
        
        va_list args;
        va_start(args, firstObj);
        id obj = nil;
        
        while ((obj = va_arg(args, id))) {
            [params addObject:obj];
        }
        
        va_end(args);
    }

    return [self tupleWithObjectsFromArray:params];
}

+ (Tuple*)tupleWithObjectsFromArray:(NSArray*)objects {
    assert(objects);
    return [[Tuple alloc] initWithObjectsFromArray:objects];
}

- (instancetype)initWithObjectsFromArray:(NSArray*)objects {
    self = [super initWithClusterClass:[Tuple class] parameters:objects];
    if (self) {
        self.objects = objects;
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return _objects[index];
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
