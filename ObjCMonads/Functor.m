//
//  Functor.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Functor.h"
#import "EXTScope.h"

@concreteprotocol(Functor)

+ (Function*)fmap {
    assert(NO);
    return nil;
}

+ (Function*)freplace {
    return ComposeR([self fmap], [Function fromPointer:Const objCTypes:FPTR_SIG(id, id)]);
}

- (id<Functor>(^)(Function*))fmap {
    @weakify(self);
    return ^id<Functor>(Function* f) {
        @strongify(self);
        return [[[[self class] fmap] :f] :self];
    };
}

@end
