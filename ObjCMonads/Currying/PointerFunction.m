//
//  PointerFunction.m
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.28..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "PointerFunction.h"
#import "NSInvocation+Extensions.h"
#import "NSInvocation+Function.h"

@interface NSInvocation (PrivateAPI)
- (void)invokeUsingIMP:(IMP)imp;
@end


@interface PointerFunction ()

@property (nonatomic, assign) void* pointer;
@property (nonatomic, strong) NSInvocation* invocation;

@end


@implementation PointerFunction

+ (instancetype)fromPointer:(void*)ptr objCTypes:(const char*)types {
    assert(ptr);
    NSMethodSignature* ms = [NSMethodSignature signatureWithObjCTypes:types];
    NSInteger argCount = [ms numberOfArguments];
    assert(argCount > 0);
    
    PointerFunction* f = [[PointerFunction alloc] initWithArgCount:argCount
                                                              args:nil];
    f.pointer = ptr;
    f.invocation = [NSInvocation invocationWithMethodSignature:ms];
    return f;
}

- (id)copyWithZone:(NSZone*)zone {
    PointerFunction* f = [super copyWithZone:zone];
    f.pointer = _pointer;
    f.invocation = [NSInvocation invocationWithMethodSignature:[_invocation methodSignature]];
    return f;
}

- (id)invoke {
    assert([self.args count] == self.argCount);
    assert(_pointer);
    
    BOOL useFastLane = NO;
    
    if (self.argCount <= 8 && [[_invocation methodSignature] methodReturnType][0] == '@') {
        BOOL onlyIdArgs = YES;
        for (int i = 0; i < self.argCount; ++i) {
            const char* argType = [[_invocation methodSignature] getArgumentTypeAtIndex:i];
            if (argType[0] != '@') {
                onlyIdArgs = NO;
                break;
            }
        }
        useFastLane = onlyIdArgs;
    }
    
    if (useFastLane) {
        switch (self.argCount) {
            case 1: return ((id(*)(id,...))_pointer)(self.args[0]);
            case 2: return ((id(*)(id,...))_pointer)(self.args[0], self.args[1]);
            case 3: return ((id(*)(id,...))_pointer)(self.args[0], self.args[1], self.args[2]);
            case 4: return ((id(*)(id,...))_pointer)(self.args[0], self.args[1], self.args[2], self.args[3]);
            case 5: return ((id(*)(id,...))_pointer)(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4]);
            case 6: return ((id(*)(id,...))_pointer)(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5]);
            case 7: return ((id(*)(id,...))_pointer)(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6]);
            case 8: return ((id(*)(id,...))_pointer)(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6], self.args[7]);
                
            default:
                assert(NO);
                break;
        }
    } else {
        [_invocation setArgumentsWithArray:self.args
                           startingAtIndex:0];
        
        [_invocation invokeUsingIMP:(IMP)_pointer];
        
        return [_invocation returnedObject];
    }
    
    assert(NO);
    return nil;
}

@end
