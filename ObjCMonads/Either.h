//
//  Either.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "Monad.h"

#define Either(a, b) Either*


@interface Either : NSObject<Monad, Functor, NSCopying>

@end

#ifdef __cplusplus
extern "C" {
#endif

    Either* Left(id lvalue);
    Either* Right(id rvalue);
    BOOL IsLeft(Either* e);
    id FromLeft(Either* e);
    id FromRight(Either* e);

#ifdef __cplusplus
}
#endif

