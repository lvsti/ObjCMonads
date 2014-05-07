//
//  Function.h
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.27..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "metamacros.h"


#define __FPTR_ENC(idx, arg)    , @encode(arg)
#define __FPTR_S(idx, arg)      "%s"

#define FPTR_SIG(...)   [[NSString stringWithFormat:@metamacro_foreach(__FPTR_S, , __VA_ARGS__) metamacro_foreach(__FPTR_ENC, , __VA_ARGS__)] UTF8String]


@interface Function : NSObject <NSCopying>

@property (nonatomic, assign, readonly) NSInteger argCount;
@property (nonatomic, copy, readonly) NSArray* args;

+ (instancetype)fromTarget:(id)target selector:(SEL)selector;
+ (instancetype)fromBlock:(id)block;
+ (instancetype)fromPointer:(void*)ptr objCTypes:(const char*)types;

- (instancetype)initWithArgCount:(NSInteger)argCount
                            args:(NSArray*)args;

+ (id)nullArg;

- (id):(id)arg;
- (id):(id)arg1 :(id)arg2;
- (id):(id)arg1 :(id)arg2 :(id)arg3;
- (id):(id)arg1 :(id)arg2 :(id)arg3 :(id)arg4;
- (id):(id)arg1 :(id)arg2 :(id)arg3 :(id)arg4 :(id)arg5;
- (id):(id)arg1 :(id)arg2 :(id)arg3 :(id)arg4 :(id)arg5 :(id)arg6;
- (id):(id)arg1 :(id)arg2 :(id)arg3 :(id)arg4 :(id)arg5 :(id)arg6 :(id)arg7;
- (id):(id)arg1 :(id)arg2 :(id)arg3 :(id)arg4 :(id)arg5 :(id)arg6 :(id)arg7 :(id)arg8;

- (id)invoke;

@end
