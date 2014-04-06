//
//  NSObject+Subclass.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <objc/runtime.h>

typedef struct SelBlockPair { SEL aSEL; id (^__unsafe_unretained aBlock)(id, ...); } SelBlockPair;
#define NIL_PAIR ((struct SelBlockPair) { 0, 0 })
#define PAIR_LIST (struct SelBlockPair [])
#define BLOCK_CAST (id (^)(id, ...))

@interface NSObject (Subclass)

+ (Class)newSubclassNamed:(NSString*)name
                protocols:(Protocol**)protos
                    impls:(SelBlockPair*)impls;

@end

