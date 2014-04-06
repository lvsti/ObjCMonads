//
//  Writer.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Writer.h"
//#import "EXTScope.h"
#import "NSObject+Subclass.h"


Record MkRecord(Result result, Output output) {
    assert(result);
    assert(output);
    return [[Tuple alloc] initWithObjectsFromArray:@[result, output]];
}


@interface Writer ()

@property (nonatomic, copy, readwrite) Record record;
- (instancetype)initWithRecord:(Record)rec;
+ (Class)outputClass;

@end


Writer* MkWriter(Record rec) {
    Class outputClass = [rec[1] class];
    struct SelBlockPair impls[] = {
        { @selector(outputClass), BLOCK_CAST ^id(id self) { return outputClass; } },
        { 0, 0 }
    };
    
    NSString* className = [NSString stringWithFormat:@"Writer_%@", NSStringFromClass(outputClass)];
    __strong Class newClass = [Writer newSubclassNamed:className
                                             protocols:NULL
                                                 impls:impls];
    
    return [[newClass alloc] initWithRecord:rec];
}

Record RunWriter(Writer* m) {
    return m.record;
}

Writer* Tell(Output output) {
    return MkWriter(MkRecord([NSNull null], output));
}

Writer* Listen(Writer* m) {
    Record rec = RunWriter(m);
    return MkWriter(MkRecord(rec, rec[1]));
}

Writer* ListenS(OutputSelector sel, Writer* m) {
    Record rec = RunWriter(m);
    Record srec = MkRecord(rec[0], sel(rec[1]));
    return MkWriter(MkRecord(srec, rec[1]));
}

Writer* Pass(Writer* m) {
    Record rec = RunWriter(m);
    Record result = rec[0];
    OutputModifier mod = result[1];
    return MkWriter(MkRecord(result[0], mod(rec[1])));
}

Writer* Censor(OutputModifier mod, Writer* m) {
    Record rec = RunWriter(m);
    return MkWriter(MkRecord(rec[0], mod(rec[1])));
}


@implementation Writer

- (instancetype)initWithRecord:(Record)rec {
    assert(rec.size == 2);
    self = [super init];
    if (self) {
        self.record = rec;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (Class)outputClass {
    return nil;
}

#pragma mark - Functor:

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^id(Mapping map, Writer* ftor) {
        return MkWriter(MkRecord(map(ftor.record[0]), ftor.record[1]));
    };
}


#pragma mark - Monad:

//- (MonadicValue(^)(Continuation))bind {
//    @weakify(self);
//    return ^MonadicValue(Continuation cont) {
//        @strongify(self);
//        return [Writer bind](self, cont);
//    };
//}
//
//- (MonadicValue(^)(MonadicValue))bind_ {
//    @weakify(self);
//    return ^MonadicValue(MonadicValue mvalue) {
//        @strongify(self);
//        return [Writer bind_](self, mvalue);
//    };
//}

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^Writer*(Writer* mvalue, Continuation cont) {
        Record rec0 = RunWriter(mvalue);
        Record rec1 = RunWriter((Writer*)cont(rec0[0]));
        Class monoidClass = [rec0[1] class];
        Output jointOutput = [monoidClass mappend](rec0[1], rec1[1]);
        return MkWriter(MkRecord(rec1[0], jointOutput));
    };
}

//+ (MonadicValue(^)(MonadicValue, MonadicValue))bind_ {
//    return ^Writer*(Writer* mvalue0, MonadicValue mvalue1) {
//        return [Writer bind](mvalue0, ^MonadicValue(id x) { return mvalue1; });
//    };
//}

+ (MonadicValue(^)(id))unit {
    Class class = [self outputClass];
    return ^Writer*(id value) {
        return MkWriter(MkRecord(value, [class mempty]));
    };
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Writer (%@, %@)", self.record[0], self.record[1]];
}

@end

