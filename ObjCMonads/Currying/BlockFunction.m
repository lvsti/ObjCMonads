//
//  BlockFunction.m
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.27..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "BlockFunction.h"
#import "EXTScope.h"
#import "MABlockForwarding.h"
#import "NSInvocation+Extensions.h"
#import "NSInvocation+Function.h"


@interface BlockFunction ()

@property (nonatomic, strong) NSMethodSignature* signature;
@property (nonatomic, copy) id (^block)(id, ...);

@end


@implementation BlockFunction

+ (instancetype)fromBlock:(id)block {
    NSMethodSignature* ms = SignatureForBlock(block);
    NSInteger argCount = [ms numberOfArguments] - 1;
    assert(argCount > 0);
    
    BlockFunction* f = [[BlockFunction alloc] initWithArgCount:argCount
                                                          args:nil];
    f.block = block;
    f.signature = ms;
    
    return f;
}

- (id)copyWithZone:(NSZone*)zone {
    BlockFunction* f = [super copyWithZone:zone];
    f.block = _block;
    f.signature = _signature;
    return f;
}

- (id)invoke {
    assert([self.args count] == self.argCount);
    assert(_block);

    BOOL useFastLane = NO;
    
    if (self.argCount <= 8 && [_signature methodReturnType][0] == '@') {
        BOOL onlyIdArgs = YES;
        for (int i = 0; i < self.argCount; ++i) {
            const char* argType = [_signature getArgumentTypeAtIndex:i+1];
            if (argType[0] != '@') {
                onlyIdArgs = NO;
                break;
            }
        }
        useFastLane = onlyIdArgs;
    }

    if (useFastLane) {
        switch (self.argCount) {
            case 1: return _block(self.args[0]);
            case 2: return _block(self.args[0], self.args[1]);
            case 3: return _block(self.args[0], self.args[1], self.args[2]);
            case 4: return _block(self.args[0], self.args[1], self.args[2], self.args[3]);
            case 5: return _block(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4]);
            case 6: return _block(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5]);
            case 7: return _block(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6]);
            case 8: return _block(self.args[0], self.args[1], self.args[2], self.args[3], self.args[4], self.args[5], self.args[6], self.args[7]);
                
            default:
                assert(NO);
                break;
        }
    } else {
        __block id retval = nil;
        
        @weakify(self);
        BlockInterposer invWrapper = ^(NSInvocation *inv, void (^call)()) {
            @strongify(self);
            [inv setArgumentsWithArray:self.args
                       startingAtIndex:1
                        usingSignature:self.signature];
            
            call();
            
            const char* retType = [self.signature methodReturnType];
            retval = [inv returnedObjectWithObjCType:retType];
        };
        
        void (^wrapper)() = MAForwardingBlock(invWrapper, _block);
        wrapper();

        return retval;
    }
    
    assert(NO);
    return nil;
}

@end
