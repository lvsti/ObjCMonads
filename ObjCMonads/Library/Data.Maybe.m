//
//  Data.Maybe.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Data.Maybe.h"
#import "List.h"


static Maybe* sharedNothing = nil;


@interface Maybe ()

@property (nonatomic, strong) id value;
@property (nonatomic, assign) BOOL isJust;

- (instancetype)initWithNothing;
- (instancetype)initWithValue:(id)value;

@end


Maybe* Just(id value) {
    return [Maybe just:value];
}

Maybe* Nothing() {
    return [Maybe nothing];
}


id WithMaybe(id defValue, Mapping func, Maybe* mvalue) {
    assert(mvalue);
    if (mvalue.isJust) {
        assert(func);
        return func(mvalue.value);
    }

    assert(defValue);
    return defValue;
}

BOOL IsJust(Maybe* mvalue) {
    assert(mvalue);
    return mvalue.isJust;
}

BOOL IsNothing(Maybe* mvalue) {
    assert(mvalue);
    return !mvalue.isJust;
}

id FromJust(Maybe* mvalue) {
    assert(mvalue && mvalue.isJust);
    return mvalue.value;
}

id FromMaybe(id defValue, Maybe* mvalue) {
    assert(mvalue);
    if (mvalue.isJust) {
        return mvalue.value;
    }
    
    assert(defValue);
    return defValue;
}

List* MaybeToList(Maybe* mvalue) {
    assert(mvalue);
    return mvalue.isJust? Singleton(mvalue.value): Empty();
}

Maybe* ListToMaybe(List* values) {
    assert(values);
    return IsEmpty(values)? [Maybe nothing]: [Maybe just:Head(values)];
}

List* CatMaybes(List* mvalues) {
    assert(mvalues);
    return FoldR(^id(Maybe* obj, List* accum) {
        return obj.isJust? Cons(obj, accum): accum;
    }, Empty(), mvalues);
}

List* MapMaybe(Maybe*(^func)(id), List* values) {
    assert(values);
    if (IsEmpty(values)) {
        return Empty();
    }
    
    assert(func);
    Maybe* mx = func(Head(values));
    List* mxs = MapMaybe(func, Tail(values));
    return mx.isJust? Cons(mx, mxs): mxs;
}


@implementation Maybe

@synthesize value = _value;

+ (void)initialize {
    sharedNothing = [[Maybe alloc] initWithNothing];
}

+ (Maybe*)just:(id)value {
    return [[Maybe alloc] initWithValue:value];
}

+ (Maybe*)nothing {
    return sharedNothing;
}

- (instancetype)initWithNothing {
    self = [super initWithClusterClass:[Maybe class] parameters:@[TCFreeParameter()]];
    if (self) {
        _isJust = NO;
    }
    return self;
}

- (instancetype)initWithValue:(id)aValue {
    assert(aValue);
    self = [super initWithClusterClass:[Maybe class] parameters:@[aValue]];
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

    // nothings ruled out by this point
    return _isJust == ((Maybe*)other).isJust && [_value isEqual:((Maybe*)other).value];
}

- (NSString*)description {
    return _isJust? [NSString stringWithFormat:@"Just %@", _value]: @"Nothing";
}

#pragma mark - Functor:

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^Maybe*(Mapping map, Maybe* ftor) {
        assert(ftor);
        if (ftor.isJust) {
            assert(map);
            return [Maybe just:map(ftor.value)];
        }
        
        return [Maybe nothing];
    };
}

#pragma mark - Monad:

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^MonadicValue(Maybe* mvalue, Continuation cont) {
        assert(mvalue);
        if (mvalue.isJust) {
            assert(cont);
            return cont(mvalue.value, self);
        }
        
        return [Maybe nothing];
    };
}

+ (MonadicValue(^)(id))unit {
    return ^Maybe*(id value) {
        return [Maybe just:value];
    };
}

@end

