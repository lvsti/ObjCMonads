//
//  Data.Either.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Data.Either.h"
#import "List.h"
#import "Tuple.h"


@interface Either ()
@property (nonatomic, strong) id value;
@property (nonatomic, assign) BOOL isLeft;

- (instancetype)initWithLeft:(id)lvalue;
- (instancetype)initWithRight:(id)rvalue;

@end


Either* Left(id lvalue) {
    return [Either left:lvalue];
}

Either* Right(id rvalue) {
    return [Either right:rvalue];
}

id WithEither(id(^funcAC)(id), id(^funcBC)(id), Either OF(a, b)* either) {
    assert(either);
    if (either.isLeft) {
        assert(funcAC);
        return funcAC(either.value);
    }
    
    assert(funcBC);
    return funcBC(either.value);
}

List* Lefts(List* eithers) {
    assert(eithers);
    return FoldR(^id(Either* obj, List* accum) {
        return obj.isLeft? Cons(obj, accum): accum;
    }, Empty(), eithers);
}

List* Rights(List* eithers) {
    assert(eithers);
    return FoldR(^id(Either* obj, List* accum) {
        return !obj.isLeft? Cons(obj, accum): accum;
    }, Empty(), eithers);
}

Tuple* PartitionEithers(List* eithers) {
    assert(eithers);
    return FoldR(^id(Either* obj, Tuple* accum) {
        return obj.isLeft? MkPair(Cons(obj, accum[0]), accum[1]): MkPair(accum[0], Cons(obj, accum[1]));
    }, MkPair(Empty(), Empty()), eithers);
}

BOOL IsLeft(Either* e) {
    return e.isLeft;
}

BOOL IsRight(Either* e) {
    return !e.isLeft;
}

id FromLeft(Either* e) {
    assert(e.isLeft);
    return e.value;
}

id FromRight(Either* e) {
    assert(!e.isLeft);
    return e.value;
}


@implementation Either

+ (Either*)left:(id)lvalue {
    return [[Either alloc] initWithLeft:lvalue];
}

+ (Either*)right:(id)rvalue {
    return [[Either alloc] initWithRight:rvalue];
}


- (instancetype)initWithLeft:(id)lvalue {
    assert(lvalue);
    self = [super initWithClusterClass:[Either class]
                            parameters:@[lvalue, TCFreeParameter()]];
    if (self) {
        _value = lvalue;
        _isLeft = YES;
    }
    return self;
}

- (instancetype)initWithRight:(id)rvalue {
    assert(rvalue);
    self = [super initWithClusterClass:[Either class]
                            parameters:@[TCFreeParameter(), rvalue]];
    if (self) {
        _value = rvalue;
        _isLeft = NO;
    }
    return self;
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
    
    if (![[self class] isCompatibleWithClass:[other class]]) {
        return NO;
    }
    
    return _isLeft == ((Either*)other).isLeft && [_value isEqual:((Either*)other).value];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %@", (_isLeft? @"Left": @"Right"), _value];
}

#pragma mark - Functor:

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^Either*(Mapping func, Either* ftor) {
        assert(ftor);
        if (!ftor.isLeft) {
            assert(func);
            return [Either right:func(ftor.value)];
        }
        
        return [ftor copy];
    };
}

#pragma mark - Monad:

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^MonadicValue(Either* mvalue, Continuation cont) {
        assert(mvalue);
        if (!mvalue.isLeft) {
            assert(cont);
            return cont(mvalue.value, self);
        }
        
        return [mvalue copy];
    };
}

+ (MonadicValue(^)(id))unit {
    return ^Either*(id value) {
        return [Either right:value];
    };
}

@end


