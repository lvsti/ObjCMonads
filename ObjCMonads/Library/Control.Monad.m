//
//  Control.Monad.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.09..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Control.Monad.h"


MonadicValue BindR(Continuation cont, MonadicValue mvalue) {
    return [[mvalue class] bind](mvalue, cont);
}

MonadicValue Sequence(List* mvalues, Class<Monad> m) {
    return FoldR(^MonadicValue(MonadicValue obj, MonadicValue accum) {
        return obj.bind(^MonadicValue(id x, Class mx) {
            return accum.bind(^MonadicValue(List* xs, Class mxs) {
                return [m unit](Cons(x, xs));
            });
        });
    }, [m unit](Empty()), mvalues);
}

MonadicValue Sequence_(List* mvalues, Class m) {
    return FoldR(^id(MonadicValue obj, MonadicValue accum) {
        return obj.bind_(accum);
    }, [m unit](MkUnit()), mvalues);
}

MonadicValue MapM(Continuation cont, List* values, Class<Monad> m) {
    return Sequence(Map(^id(id x) {
        return cont(x, m);
    }, values), m);
}

MonadicValue MapM_(Continuation cont, List* values, Class<Monad> m) {
    return Sequence_(Map(^id(id x) {
        return cont(x, m);
    }, values), m);
}


@implementation List (MonadPlus)

+ (id<MonadPlus>(^)())mzero {
    return ^List*() {
        return Empty();
    };
}

+ (id<MonadPlus>(^)(id<MonadPlus>, id<MonadPlus>))mplus {
    return ^List*(List* list1, List* list2) {
        return Append(list1, list2);
    };
}

@end


@implementation Maybe (MonadPlus)

+ (id<MonadPlus>(^)())mzero {
    return ^Maybe*() {
        return Nothing();
    };
}

+ (id<MonadPlus>(^)(id<MonadPlus>, id<MonadPlus>))mplus {
    return ^Maybe*(Maybe* maybe1, Maybe* maybe2) {
        return IsJust(maybe1)? maybe1: maybe2;
    };
}

@end


MonadicValue Guard(BOOL value, Class<MonadPlus> m) {
    return value? [m unit](MkUnit()): [m mzero]();
}

MonadicValue FilterM(Continuation cont, List* values, Class<Monad> m) {
    if (IsEmpty(values)) {
        return [m unit](Empty());
    }
    
    id x = Head(values);
    return cont(x, m).bind(^MonadicValue(id flagObj, Class _) {
        BOOL flag = [flagObj boolValue];
        return FilterM(cont, Tail(values), m).bind(^MonadicValue(List* ys, Class _) {
            return [m unit](flag? Cons(x, ys): ys);
        });
    });
}

MonadicValue ForM(List* values, Continuation cont, Class<Monad> m) {
    return MapM(cont, values, m);
}

MonadicValue ForM_(List* values, Continuation cont, Class<Monad> m) {
    return MapM_(cont, values, m);
}

MonadicValue MSum(List* mvalues, Class<MonadPlus> m) {
    return FoldR([m mplus], [m mzero], mvalues);
}

Continuation MComposeL(Continuation contAB, Continuation contBC, Class<Monad> m) {
    return ^MonadicValue(id value, Class m) {
        return contAB(value, m).bind(contBC);
    };
}

Continuation MComposeR(Continuation contBC, Continuation contAB, Class<Monad> m) {
    return MComposeL(contAB, contBC, m);
}

MonadicValue Forever(MonadicValue mvalue) {
    return mvalue.bind_(^MonadicValue(MonadicValue mvalue1) {
        return Forever(mvalue);
    });
}

id<Functor> Void(id<Functor> ftor) {
    return ftor.fmap(^id(id x) {
        return MkUnit();
    });
}


MonadicValue Join(MonadicValue mmvalue) {
    return mmvalue.bind(^MonadicValue(id mvalue, Class m) {
        return mvalue;
    });
}

MonadicValue MapAndUnzipM(Continuation cont, List* values, Class<Monad> m) {
    return MapM(cont, values, m).bind(^MonadicValue(id value, Class m1) {
        return [m unit](Unzip(value));
    });
}

MonadicValue ZipWithM(MonadicValue(^zipper)(id, id), List* as, List* bs, Class<Monad> m) {
    return Sequence(ZipWith(zipper, as, bs), m);
}

MonadicValue ZipWithM_(MonadicValue(^zipper)(id, id), List* as, List* bs, Class<Monad> m) {
    return Sequence_(ZipWith(zipper, as, bs), m);
}

MonadicValue FoldM(MReduceStepL step, id zero, List* values, Class<Monad> m) {
    if (IsEmpty(values)) {
        return [m unit](zero);
    }
    
    return step(zero, Head(values)).bind(^MonadicValue(id value, Class m1) {
        return FoldM(step, value, Tail(values), m);
    });
}

MonadicValue FoldM_(MReduceStepL step, id zero, List* values, Class<Monad> m) {
    return FoldM(step, zero, values, m).bind_([m unit](MkUnit()));
}

MonadicValue ReplicateM(int count, MonadicValue mvalue, Class<Monad> m) {
    return Sequence(Replicate(count, mvalue), m);
}

MonadicValue ReplicateM_(int count, MonadicValue mvalue, Class<Monad> m) {
    return Sequence_(Replicate(count, mvalue), m);
}

MonadicValue When(BOOL cond, MonadicValue mvalue, Class<Monad> m) {
    return cond? mvalue: [m unit](MkUnit());
}

MonadicValue Unless(BOOL cond, MonadicValue mvalue, Class<Monad> m) {
    return cond? [m unit](MkUnit()): mvalue;
}

MonadicValue LiftM(id(^func)(id), MonadicValue mvalue, Class<Monad> m) {
    return mvalue.bind(^MonadicValue(id value, Class m1) {
        return [m unit](func(value));
    });
}

MonadicValue LiftM2(id(^func)(id, id), MonadicValue mvalue1, MonadicValue mvalue2, Class<Monad> m) {
    return mvalue1.bind(^MonadicValue(id value1, Class m1) {
        return mvalue2.bind(^MonadicValue(id value2, Class m2) {
            return [m unit](func(value1, value2));
        });
    });
}

MonadicValue LiftM3(id(^func)(id, id, id),
                    MonadicValue mvalue1,
                    MonadicValue mvalue2,
                    MonadicValue mvalue3,
                    Class<Monad> m) {
    return mvalue1.bind(^MonadicValue(id value1, Class m1) {
        return mvalue2.bind(^MonadicValue(id value2, Class m2) {
            return mvalue3.bind(^MonadicValue(id value3, Class m3) {
                return [m unit](func(value1, value2, value3));
            });
        });
    });
}

MonadicValue LiftM4(id(^func)(id, id, id, id),
                    MonadicValue mvalue1,
                    MonadicValue mvalue2,
                    MonadicValue mvalue3,
                    MonadicValue mvalue4,
                    Class<Monad> m) {
    return mvalue1.bind(^MonadicValue(id value1, Class m1) {
        return mvalue2.bind(^MonadicValue(id value2, Class m2) {
            return mvalue3.bind(^MonadicValue(id value3, Class m3) {
                return mvalue4.bind(^MonadicValue(id value4, Class m4) {
                    return [m unit](func(value1, value2, value3, value4));
                });
            });
        });
    });
}

MonadicValue LiftM5(id(^func)(id, id, id, id, id),
                    MonadicValue mvalue1,
                    MonadicValue mvalue2,
                    MonadicValue mvalue3,
                    MonadicValue mvalue4,
                    MonadicValue mvalue5,
                    Class<Monad> m) {
    return mvalue1.bind(^MonadicValue(id value1, Class m1) {
        return mvalue2.bind(^MonadicValue(id value2, Class m2) {
            return mvalue3.bind(^MonadicValue(id value3, Class m3) {
                return mvalue4.bind(^MonadicValue(id value4, Class m4) {
                    return mvalue5.bind(^MonadicValue(id value5, Class m5) {
                        return [m unit](func(value1, value2, value3, value4, value5));
                    });
                });
            });
        });
    });
}

MonadicValue Ap(MonadicValue mfunc, MonadicValue mvalue, Class<Monad> m) {
    return mfunc.bind(^MonadicValue(id(^func)(id), Class m1) {
        return mvalue.bind(^MonadicValue(id value, Class m2) {
            return [m unit](func(value));
        });
    });
}


MonadicValue MFilter(BOOL(^pred)(id), MonadicValue mvalue, Class<MonadPlus> m) {
    return mvalue.bind(^MonadicValue(id value, Class m1) {
        return pred(value)? [m unit](value): [m mzero]();
    });
}

