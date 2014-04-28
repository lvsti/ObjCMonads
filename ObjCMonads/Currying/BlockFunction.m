//
//  BlockFunction.m
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.27..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "BlockFunction.h"
#import "MABlockForwarding.h"
#import "NSInvocation+Extensions.h"
#import "NSInvocation+Function.h"


@interface BlockFunction ()

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
    
    return f;
}

- (id)copyWithZone:(NSZone*)zone {
    BlockFunction* f = [super copyWithZone:zone];
    f.block = _block;
    return f;
}

- (id)invoke {
    assert([self.args count] == self.argCount);
    assert(_block);

    NSMethodSignature* ms = SignatureForBlock(_block);
    __block id retval = nil;
    
    BlockInterposer invWrapper = ^(NSInvocation *inv, void (^call)()) {
        [inv setArgumentsWithArray:self.args
                   startingAtIndex:1
                    usingSignature:ms];
        
        call();
        
        const char* retType = [ms methodReturnType];
        retval = [inv returnedObjectWithObjCType:retType];
    };
    
    id (^wrapper)() = MAForwardingBlock(invWrapper, _block);
    wrapper();
    
    return retval;
}

@end
