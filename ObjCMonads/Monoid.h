//
//  Monoid.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTConcreteProtocol.h"
#import "Data.Function.h"

@class List;

@protocol Monoid <NSObject>
@required

// mempty :: Monoid a => a
+ (id<Monoid>)mempty;

// mappend :: Monoid a => a -> a -> a
+ (Function*)mappend;

@concrete

// mconcat :: Monoid a => [a] -> a
+ (Function*)mconcat;

@property (nonatomic, readonly) id<Monoid>(^mappend)(id<Monoid>);

@end
