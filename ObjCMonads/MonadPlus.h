//
//  MonadPlus.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.08..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monad.h"

@protocol MonadPlus <Monad>
@required

// mzero :: m a
+ (id<MonadPlus>(^)())mzero;

// mplus :: m a -> m a -> m a
+ (id<MonadPlus>(^)(id<MonadPlus>, id<MonadPlus>))mplus;

@end
