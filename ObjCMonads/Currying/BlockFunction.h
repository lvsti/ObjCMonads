//
//  BlockFunction.h
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.27..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Function.h"

@interface BlockFunction : Function

+ (instancetype)fromBlock:(id)block;

@end

