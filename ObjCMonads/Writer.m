//
//  Writer.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Writer.h"
#import "NSObject+Subclass.h"

enum RecordFields {
    kRecResult = 0,
    kRecOutput = 1
};

enum TypeParameters {
    kTPResultType = 0,
    kTPOutputType = 1
};


Record MkRecord(Result result, Output output) {
    assert(result);
    assert(output);
    return MkPair(result, output);
}


@interface Writer ()

@property (nonatomic, copy, readwrite) Record record;
- (instancetype)initWithRecord:(Record)rec;

@end


Writer* MkWriter(Record rec) {
    return [[Writer alloc] initWithRecord:rec];
}

Record RunWriter(Writer* m) {
    return m.record;
}

Writer* Tell(Output output) {
    return MkWriter(MkRecord(MkUnit(), output));
}

Writer* Listen(Writer* m) {
    Record rec = RunWriter(m);
    return MkWriter(MkRecord(rec, rec[kRecOutput]));
}

Writer* ListenS(OutputSelector sel, Writer* m) {
    Record rec = RunWriter(m);
    Record srec = MkRecord(rec[kRecResult], sel(rec[kRecOutput]));
    return MkWriter(MkRecord(srec, rec[kRecOutput]));
}

Writer* Pass(Writer* m) {
    Record rec = RunWriter(m);
    Record result = rec[kRecResult];
    OutputModifier mod = result[kRecOutput];
    return MkWriter(MkRecord(result[kRecResult], mod(rec[kRecOutput])));
}

Writer* Censor(OutputModifier mod, Writer* m) {
    Record rec = RunWriter(m);
    return MkWriter(MkRecord(rec[kRecResult], mod(rec[kRecOutput])));
}


@implementation Writer

- (instancetype)initWithRecord:(Record)rec {
    assert([[rec class] clusterClass] == [Tuple class]);
    assert([[[rec class] typeParameters] count] == 2);
    assert([rec[kRecOutput] conformsToProtocol:@protocol(Monoid)]);
    
    self = [super initWithClusterClass:[Writer class]
                            parameters:@[rec[kRecResult], rec[kRecOutput]]];
    if (self) {
        self.record = rec;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ (%@, %@)",
            NSStringFromClass([self class]),
            self.record[0],
            self.record[1]];
}

#pragma mark - Functor:

+ (id<Functor>(^)(Mapping, id<Functor>))fmap {
    return ^id(Mapping map, Writer* ftor) {
        return MkWriter(MkRecord(map(ftor.record[kRecResult]), ftor.record[kRecOutput]));
    };
}

#pragma mark - Monad:

+ (MonadicValue(^)(MonadicValue, Continuation))bind {
    return ^Writer*(Writer* mvalue, Continuation cont) {
        Record rec0 = RunWriter(mvalue);
        Record rec1 = RunWriter((Writer*)cont(rec0[kRecResult], self));
        Class monoidClass = [rec0[kRecOutput] class];
        Output jointOutput = [monoidClass mappend](rec0[kRecOutput], rec1[kRecOutput]);
        return MkWriter(MkRecord(rec1[kRecOutput], jointOutput));
    };
}

+ (MonadicValue(^)(id))unit {
    Class class = [self typeParameters][kTPOutputType];
    return ^Writer*(id value) {
        return MkWriter(MkRecord(value, [class mempty]()));
    };
}

@end

