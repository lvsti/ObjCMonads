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
    
    [_invocation setArgumentsWithArray:self.args
                       startingAtIndex:0];
    
    [_invocation invokeUsingIMP:(IMP)_pointer];
    
    return [_invocation returnedObject];
}

@end
