//
//  Control.Applicative.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.26..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Control.Applicative.h"
#import "Control.Monad.h"
#import "Data.Function.h"
#import "EXTScope.h"


@concreteprotocol(Applicative)

+ (Function*)pure {
    assert(NO);
    return nil;
}

+ (Function*)ap {
    assert(NO);
    return nil;
}

+ (Function*)apR {
    return [Function fromBlock:^id<Applicative>(id<Applicative> avalue1, id<Applicative> avalue2) {
        assert(avalue1);
        assert(avalue2);
        id(^eqSecond)(id, id) = ^id(id a, id b) {
            return b;
        };
        return LiftA2([Function fromBlock:eqSecond], avalue1, avalue2);
    }];
}

+ (Function*)apL {
    return ^id<Applicative>(id<Applicative> avalue1, id<Applicative> avalue2) {
        assert(avalue1);
        assert(avalue2);
        id(^eqFirst)(id, id) = ^id(id a, id b) {
            return a;
        };
        return LiftA2([Function fromBlock:eqFirst], avalue1, avalue2);
    };
}

- (id<Applicative>(^)(id<Applicative>))ap {
    @weakify(self);
    return ^id<Applicative>(id<Applicative> avalue) {
        assert(avalue);
        @strongify(self);
        return [[[self class] ap] :self :avalue];
    };
}

- (id<Applicative>(^)(id<Applicative>))apR {
    @weakify(self);
    return ^id<Applicative>(id<Applicative> avalue) {
        assert(avalue);
        @strongify(self);
        return [[[self class] apR] :self :avalue];
    };
}

- (id<Applicative>(^)(id<Applicative>))apL {
    @weakify(self);
    return ^id<Applicative>(id<Applicative> avalue) {
        assert(avalue);
        @strongify(self);
        return [[[self class] apL] :self :avalue];
    };
}


@end


@concreteprotocol(Alternative)

+ (id<Alternative>)empty {
    assert(NO);
    return nil;
}

+ (Function*)or {
    assert(NO);
    return nil;
}

+ (Function*)some {
    return [Function fromBlock:^id<Alternative>(id<Alternative> avalue) {
        assert(avalue);
        Class aclass = [avalue class];
        id<Alternative> manyval = [[aclass many] :avalue];
        Function* cons = [Function fromPointer:Cons objCTypes:FPTR_SIG(List*, id, List*)];
        return (id<Alternative>)((id<Applicative>)avalue.fmap(cons)).ap(manyval);
    }];
}

+ (Function*)many {
    return [Function fromBlock:^id<Alternative>(id<Alternative> avalue) {
        assert(avalue);
        Class aclass = [avalue class];
        id<Alternative> someval = [[aclass some] :avalue];
        return someval.or([[aclass pure] :Empty()]);
    }];
}

- (id<Alternative>(^)(id<Alternative>))or {
    @weakify(self);
    return ^id<Alternative>(id<Alternative> avalue) {
        assert(avalue);
        @strongify(self);
        return [[[self class] or] :self :avalue];
    };
}

@end



@implementation Maybe (Applicative)

+ (Function*)pure {
    return [self unit];
}

+ (Function*)ap {
    return [Function fromBlock:^MonadicValue(Maybe* afunc, Maybe* avalue) {
        assert(afunc);
        assert(avalue);
        return Ap(afunc, avalue, [afunc class]);
    }];
}

@end


@implementation Maybe (Alternative)

+ (id<Alternative>)empty {
    return Nothing();
}

+ (Function*)or {
    return [Function fromBlock:^Maybe*(Maybe* avalue1, Maybe* avalue2) {
        assert(avalue1);
        assert(avalue2);
        return IsJust(avalue1)? avalue1: avalue2;
    }];
}

@end



@implementation List (Applicative)

+ (Function*)pure {
    return [self unit];
}

+ (Function*)ap {
    return [Function fromBlock:^MonadicValue(List* afunc, List* avalue) {
        assert(afunc);
        assert(avalue);
        return Ap(afunc, avalue, [List class]);
    }];
}

@end


@implementation List (Alternative)

+ (id<Alternative>)empty {
    return Empty();
}

+ (Function*)or {
    return [Function fromBlock:^List*(List* avalue1, List* avalue2) {
        assert(avalue1);
        assert(avalue2);
        return Append(avalue1, avalue2);
    }];
}

@end


//instance Applicative IO where
//    pure = return
//    (<*>) = ap

//instance Applicative ((->) a) where
//    pure = const
//    (<*>) f g x = f x (g x)
//
//instance Monoid a => Applicative ((,) a) where
//    pure x = (mempty, x)
//    (u, f) <*> (v, x) = (u `mappend` v, f x)

@implementation Either (Applicative)

+ (Function*)pure {
    return [Function fromPointer:Right objCTypes:FPTR_SIG(Either*, id)];
}

+ (Function*)ap {
    return [Function fromBlock:^Either*(Either* afunc, Either* avalue) {
        assert(afunc);
        assert(avalue);
        return IsLeft(afunc)? afunc: (Either*)avalue.fmap(FromRight(afunc));
    }];
}

@end


@interface ZipList ()
@property (nonatomic, copy, readwrite) List* list;
@end

@implementation ZipList

+ (instancetype)zipListWithList:(List*)aList {
    assert(aList);
    ZipList* zl = [ZipList new];
    zl.list = aList;
    return zl;
}

@end


@implementation ZipList (Functor)

+ (Function*)fmap {
    return [Function fromBlock:^ZipList*(Function* func, ZipList* zipList) {
        return [ZipList zipListWithList:(List*)zipList.list.fmap(func)];
    }];
}

@end


List* Repeat(id value) {
    // TODO
    return nil;
}

@implementation ZipList (Applicative)

+ (Function*)pure {
    return [Function fromBlock:^ZipList*(id value) {
        return [ZipList zipListWithList:Repeat(value)];
    }];
}

+ (Function*)ap {
    return [Function fromBlock:^ZipList*(ZipList* afunc, ZipList* avalue) {
        assert(afunc);
        assert(avalue);
        Function* zipper = [Function fromPointer:Id objCTypes:FPTR_SIG(id, id)];
        return [ZipList zipListWithList:ZipWith(zipper, afunc.list, avalue.list)];
    }];
}

@end


// (<**>) :: Applicative f => f a -> f (a -> b) -> f b
id<Applicative> RevAp(id<Applicative> avalue, id<Applicative> afunc) {
    return afunc.ap(avalue);
}

// liftA :: Applicative f => (a -> b) -> f a -> f b
id<Applicative> LiftA(Function* func, id<Applicative> avalue) {
    assert(func);
    assert(avalue);
    return ((id<Applicative>)[[[avalue class] pure] :func]).ap(avalue);
}

// liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
id<Applicative> LiftA2(Function* func, id<Applicative> avalue1, id<Applicative> avalue2) {
    assert(func);
    assert(avalue1);
    assert(avalue2);
    return ((id<Applicative>)avalue1.fmap(func)).ap(avalue2);
}

// liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
id<Applicative> LiftA3(Function* func, id<Applicative> avalue1, id<Applicative> avalue2, id<Applicative> avalue3) {
    assert(func);
    assert(avalue1);
    assert(avalue2);
    return ((id<Applicative>)avalue1.fmap(func)).ap(avalue2).ap(avalue3);
}

// optional :: Alternative f => f a -> f (Maybe a)
id<Alternative> Optional(id<Alternative> avalue) {
    assert(avalue);
    Class aclass = [avalue class];
    Function* just = [Function fromPointer:Just objCTypes:FPTR_SIG(Maybe*, id)];
    return ((id<Alternative>)avalue.fmap(just)).or([[aclass pure] :Nothing()]);
}


