//
//  Control.Monad.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.09..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"
#import "Maybe.h"
#import "Monad.h"


@protocol MonadPlus <Monad>
@required

// mzero :: m a
+ (id<MonadPlus>(^)())mzero;

// mplus :: m a -> m a -> m a
+ (id<MonadPlus>(^)(id<MonadPlus>, id<MonadPlus>))mplus;

@end


@interface List (MonadPlus) <MonadPlus>
@end


@interface Maybe (MonadPlus) <MonadPlus>
@end


#ifdef __cplusplus
extern "C" {
#endif

    // guard :: (MonadPlus m) => Bool -> m ()
    MonadicValue Guard(BOOL value, Class<MonadPlus> m);
    
#ifdef __cplusplus
}
#endif

