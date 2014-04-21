//
//  Either.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Either.h"
#import "List.h"
#import "Tuple.h"


@interface Either ()
@property (nonatomic, strong) id left;
@property (nonatomic, strong) id right;
@property (nonatomic, assign) BOOL isLeft;

- (instancetype)initWithLeft:(id)lvalue;
- (instancetype)initWithRight:(id)rvalue;

@end


Either* Left(id lvalue) {
    return [[Either alloc] initWithLeft:lvalue];
}

Either* Right(id rvalue) {
    return [[Either alloc] initWithRight:rvalue];
}

BOOL IsLeft(Either* e) {
    return e.isLeft;
}

id FromLeft(Either* e) {
    return e.left;
}

id FromRight(Either* e) {
    return e.right;
}


@implementation Either

- (instancetype)initWithLeft:(id)lvalue {
    self = [super init];
    if (self) {
        _left = lvalue;
        _isLeft = YES;
    }
    return self;
}

- (instancetype)initWithRight:(id)rvalue {
    self = [super init];
    if (self) {
        _right = rvalue;
        _isLeft = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (id)left {
    assert(_isLeft);
    return _left;
}

- (id)right {
    assert(!_isLeft);
    return _right;
}

- (NSString*)description {
    return _isLeft? [NSString stringWithFormat:@"Left %@", _left]: [NSString stringWithFormat:@"Right %@", _right];
}

#pragma mark - Functor:

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^Either*(Mapping map, Either* ftor) {
        return ftor.isLeft? [ftor copy]: Right(map(ftor.right));
    };
}

#pragma mark - Monad:

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^MonadicValue(Either* mvalue, Continuation cont) {
        if (!mvalue.isLeft) {
            return cont(mvalue.value, self);
        }
        
        // nothing
        return [mvalue copy];
    };
}

+ (MonadicValue(^)(id))unit {
    return ^Either*(id value) {
        return Right(value);
    };
}

@end


