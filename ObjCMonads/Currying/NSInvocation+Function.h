//
//  NSInvocation+Function.h
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.29..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Function)

- (void)setArgumentsWithArray:(NSArray*)args
              startingAtIndex:(NSInteger)startIndex;

- (void)setArgumentsWithArray:(NSArray*)args
              startingAtIndex:(NSInteger)startIndex
               usingSignature:(NSMethodSignature*)signature;

@end
