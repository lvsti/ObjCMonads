//
//  Monad.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTConcreteProtocol.h"

@protocol Monad;

typedef id<Monad> MonadicValue;
typedef MonadicValue(^Continuation)(id, Class);


@protocol Monad <NSObject>
@required

// bind :: m a -> (a -> m b) -> m b
+ (MonadicValue(^)(MonadicValue, Continuation))bind;

// unit :: a -> m a
+ (MonadicValue(^)(id))unit;

@concrete

// bind_ :: m a -> m b -> m b
+ (MonadicValue(^)(MonadicValue, MonadicValue))bind_;

@property (nonatomic, readonly) MonadicValue (^bind)(Continuation);
@property (nonatomic, readonly) MonadicValue (^bind_)(MonadicValue);

@end

