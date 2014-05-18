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
#import <objc/message.h>

@interface MethodFunction ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

@end


@implementation MethodFunction

+ (instancetype)fromTarget:(id)target selector:(SEL)selector {
    assert(target);
    assert(selector);
    NSString* selName = NSStringFromSelector(selector);
    NSInteger argCount = [[selName componentsSeparatedByString:@":"] count] - 1;
    assert(argCount > 0);
    
    MethodFunction* f = [[MethodFunction alloc] initWithArgCount:argCount args:nil];
    f.target = target;
    f.selector = selector;
    
    return f;
}

- (id)copyWithZone:(NSZone*)zone {
    MethodFunction* f = [super copyWithZone:zone];
    f.target = _target;
    f.selector = _selector;
    return f;
}

- (id)invoke {
    assert([self.args count] == self.argCount);
    
    BOOL useFastLane = NO;
    NSMethodSignature* ms = [_target methodSignatureForSelector:_selector];
    
    if (self.argCount <= 8 && [ms methodReturnType][0] == '@') {
        BOOL onlyIdArgs = YES;
        for (int i = 0; i < self.argCount; ++i) {
            const char* argType = [ms getArgumentTypeAtIndex:i+2];
            if (argType[0] != '@') {
                onlyIdArgs = NO;
                break;
            }
        }
        useFastLane = onlyIdArgs;
    }
    
    if (useFastLane) {
        switch (self.argCount) {
            case 1: return objc_msgSend(_target, _selector, self.args[0]);
            case 2: return objc_msgSend(_target, _selector, self.args[0], self.args[1]);
            case 3: return objc_msgSend(_target, _selector, self.args[0], self.args[1], self.args[2]);
            case 4: return objc_msgSend(_target, _selector, self.args[0], self.args[1], self.args[2], self.args[3]);
            case 5: return objc_msgSend(_target, _selector, self.args[0], self.args[1], self.args[2], self.args[3], self.args[4]);
            case 6: return objc_msgSend(_target, _selector, self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5]);
            case 7: return objc_msgSend(_target, _selector, self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6]);
            case 8: return objc_msgSend(_target, _selector, self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6], self.args[7]);
                
            default:
                assert(NO);
                break;
        }
    } else {
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:ms];
        [inv setTarget:_target];
        [inv setSelector:_selector];
        [inv setArgumentsWithArray:self.args
                   startingAtIndex:2];
        
        [inv invoke];
        
        return [inv returnedObject];
    }

    assert(NO);
    return nil;
}


@end
