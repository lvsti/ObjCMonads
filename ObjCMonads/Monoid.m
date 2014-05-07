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

+ (id<Monoid>)mempty {
    assert(NO);
    return nil;
}

+ (Function*)mappend {
    assert(NO);
    return nil;
}

+ (Function*)mconcat {
    return [Function fromBlock:^id<Monoid>(List* list) {
        return FoldR([self mappend], [self mempty], list);
    }];
}

- (id<Monoid>(^)(id<Monoid>))mappend {
    @weakify(self);
    return ^id<Monoid>(id<Monoid> other) {
        @strongify(self);
        return [[[self class] mappend] :self :other];
    };
}

@end
