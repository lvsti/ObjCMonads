//
//  MethodFunction.m
//  ObjCHOF
//
//  Created by Tamas Lustyik on 2014.04.27..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "MethodFunction.h"
#import "NSInvocation+Extensions.h"
#import "NSInvocation+Function.h"

@interface MethodFunction ()

@property (nonatomic, strong) NSInvocation* invocation;

@end


@implementation MethodFunction

+ (instancetype)fromTarget:(id)target selector:(SEL)selector {
    assert(target);
    assert(selector);
    NSString* selName = NSStringFromSelector(selector);
    NSInteger argCount = [[selName componentsSeparatedByString:@":"] count] - 1;
    assert(argCount > 0);
    
    MethodFunction* f = [[MethodFunction alloc] initWithArgCount:argCount args:nil];
    f.invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
    [f.invocation setTarget:target];
    [f.invocation setSelector:selector];
    
    return f;
}

- (id)copyWithZone:(NSZone*)zone {
    MethodFunction* f = [super copyWithZone:zone];
    f.invocation = [NSInvocation invocationWithMethodSignature:[_invocation methodSignature]];
    [f.invocation setTarget:_invocation.target];
    [f.invocation setSelector:_invocation.selector];
    return f;
}

- (id)invoke {
    assert([self.args count] == self.argCount);
    
    [_invocation setArgumentsWithArray:self.args
                       startingAtIndex:2];
    
    [_invocation invoke];

    return [_invocation returnedObject];
}



@end
