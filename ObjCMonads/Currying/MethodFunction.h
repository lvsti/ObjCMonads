//
//  MethodFunction.h
//  ObjCHOF
//
//  Created by Tamas Lustyik on 2014.04.27..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Function.h"

@interface MethodFunction : Function

+ (instancetype)fromTarget:(id)target selector:(SEL)selector;

@end
