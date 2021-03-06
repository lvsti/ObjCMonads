//
//  Maybe.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Maybe.h"
#undef Maybe


@interface Maybe ()

@property (nonatomic, strong, readwrite) id value;
@property (nonatomic, assign, readwrite) BOOL isJust;

- (instancetype)initWithNothing;
- (instancetype)initWithValue:(id)value;

@end


Maybe* Just(id value) {
    return [[Maybe alloc] initWithValue:value];
}

Maybe* Nothing() {
    return [[Maybe alloc] initWithNothing];
}

BOOL IsJust(Maybe* m) {
    return m.isJust;
}

id FromJust(Maybe* m) {
    return m.value;
}


@implementation Maybe

@synthesize value = _value;

- (instancetype)initWithNothing {
    self = [super init];
    if (self) {
        _isJust = NO;
    }
    return self;
}

- (instancetype)initWithValue:(id)aValue {
    self = [super init];
    if (self) {
        _value = aValue;
        _isJust = YES;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (id)value {
    assert(_isJust);
    return _value;
}

- (NSString*)description {
    return _isJust? [NSString stringWithFormat:@"Just %@", _value]: @"Nothing";
}

#pragma mark - Functor:

+ (Function*)fmap {
    return [Function fromBlock:^Maybe*(Function* func, Maybe* ftor) {
        return ftor.isJust? Just([func :ftor.value]): [ftor copy];
    }];
}

#pragma mark - Monad:

+ (Function*)bind {
    return [Function fromBlock:^MonadicValue(Maybe* mvalue, FunctionM* cont) {
        if (mvalue.isJust) {
            return [[cont :mvalue.value] :self];
        }
        
        // nothing
        return [mvalue copy];
    }];
}

+ (Function*)unit {
    return [Function fromBlock:^Maybe*(id value) {
        return Just(value);
    }];
}

@end

