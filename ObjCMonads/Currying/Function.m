//
//  Function.m
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.27..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Function.h"
#import "BlockFunction.h"
#import "MethodFunction.h"
#import "PointerFunction.h"


static id sharedNull = nil;

@interface NullObject : NSObject
+ (instancetype)null;
@end

@implementation NullObject
+ (void)initialize {
    sharedNull = [NullObject new];
}

+ (instancetype)null {
    return sharedNull;
}
@end



@interface Function ()

@property (nonatomic, copy, readwrite) NSArray* args;

@end


@implementation Function

+ (instancetype)fromTarget:(id)target selector:(SEL)selector {
    return [MethodFunction fromTarget:target selector:selector];
}

+ (instancetype)fromBlock:(id)block {
    return [BlockFunction fromBlock:block];
}

+ (instancetype)fromPointer:(void*)ptr objCTypes:(const char*)types {
    return [PointerFunction fromPointer:ptr objCTypes:types];
}

- (instancetype)initWithArgCount:(NSInteger)argCount args:(NSArray*)args {
    assert(argCount > 0);
    assert([args count] <= argCount);
    
    self = [super init];
    if (self) {
        _argCount = argCount;
        _args = [args copy];
    }
    return self;
}

+ (id)nullArg {
    return [NullObject null];
}

- (id)copyWithZone:(NSZone*)zone {
    return [[[self class] alloc] initWithArgCount:_argCount args:_args];
}

- (id):(id)arg {
    assert([_args count] < _argCount);

    id obj = arg? arg: [Function nullArg];
    Function* f = [self copy];
    f.args = _args? [_args arrayByAddingObject:obj]: @[obj];

    if ([f.args count] == _argCount) {
        return [f invoke];
    }
    
    return f;
}

- (id)invoke {
    // to be overridden by subclasses
    assert(NO);
    return nil;
}

- (NSString*)debugDescription {
    NSMutableString* desc = [NSMutableString stringWithFormat:@"<Function:%p> (", self];
    for (int i = 0; i < _argCount; ++i) {
        if (i < [_args count]) {
            [desc appendFormat:@"%@", [_args[i] debugDescription]];
        } else {
            [desc appendString:@"?"];
        }
        
        if (i < _argCount - 1) {
            [desc appendString:@", "];
        }
    }
    [desc appendString:@")"];
    return [desc copy];
}

- (NSString*)description {
    return [self debugDescription];
}

@end
