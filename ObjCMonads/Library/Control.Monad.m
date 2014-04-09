//
//  Control.Monad.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.09..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Control.Monad.h"
#import "List.h"
#import "Maybe.h"
#import "Tuple.h"


MonadicValue Guard(BOOL value, Class<MonadPlus> m) {
    return value? [m unit](MkUnit()): [m mzero]();
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
