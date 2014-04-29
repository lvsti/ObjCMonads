//
//  Monad.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTConcreteProtocol.h"
#import "Function.h"

@protocol Monad;

typedef id<Monad> MonadicValue;
typedef MonadicValue(^Continuation)(id, Class);
typedef MonadicValue (*ContFunc)(id);

// function with an extra Class parameter to indicate monadic type
typedef Function FunctionM;


@protocol Monad <NSObject>
@required

// bind :: m a -> (a -> m b) -> m b
+ (Function*)bind;

// unit :: a -> m a
+ (Function*)unit;

@concrete

// bind_ :: m a -> m b -> m b
+ (Function*)bind_;

@property (nonatomic, readonly) MonadicValue (^bind)(FunctionM*);
@property (nonatomic, readonly) MonadicValue (^bind_)(MonadicValue);

@end

