//
//  TypedCluster.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.20..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypedCluster : NSObject

- (instancetype)initWithClusterClass:(Class)clusterClass
                          parameters:(NSArray*)params;

+ (Class)clusterClass;
+ (NSArray*)typeParameters;

@end
