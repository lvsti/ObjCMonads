//
//  Monoid.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class List;

@protocol Monoid <NSObject>

@property (nonatomic, readonly) id<Monoid>(^mappend)(id<Monoid>);

+ (id<Monoid>(^)())mempty;
+ (id<Monoid>(^)(id<Monoid>, id<Monoid>))mappend;
+ (id<Monoid>(^)(List*))mconcat;

@end
