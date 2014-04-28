//
//  PointerFunction.h
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.28..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Function.h"


@interface PointerFunction : Function

+ (instancetype)fromPointer:(void*)ptr objCTypes:(const char*)types;

@end
