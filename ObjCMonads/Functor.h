//
//  Functor.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.Function.h"
#import "EXTConcreteProtocol.h"


@protocol Functor <NSObject>
@required

// fmap :: (a -> b) -> f a -> f b
+ (id<Functor>(^)(Mapping, id<Functor>))fmap;

@concrete

// (<$) :: a -> f b -> f a
+ (id<Functor>(^)(id, id<Functor>))freplace;

@property (nonatomic, readonly) id<Functor>(^fmap)(Mapping);

@end

