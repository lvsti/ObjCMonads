//
//  Monoid.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.07..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Monoid.h"
#import "EXTScope.h"
#import "List.h"

@concreteprotocol(Monoid)

+ (id<Monoid>(^)())mempty {
    assert(NO);
    return nil;
}

+ (id<Monoid>(^)(id<Monoid>, id<Monoid>))mappend {
    assert(NO);
    return nil;
}

+ (id<Monoid>(^)(List*))mconcat {
    return ^id<Monoid>(List* list) {
        ReduceStepR step = ^id(id obj, id accum) {
            return [self mappend](obj, accum);
        };
        return FoldR(step, [self mempty], list);
    };
}

- (id<Monoid>(^)(id<Monoid>))mappend {
    @weakify(self);
    return ^id<Monoid>(id<Monoid> other) {
        @strongify(self);
        return [[self class] mappend](self, other);
    };
}

@end
