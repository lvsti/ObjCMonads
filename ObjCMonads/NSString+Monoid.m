//
//  NSString+Monoid.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSString+Monoid.h"
#import "EXTScope.h"

@implementation NSString (Monoid)

+ (id<Monoid>)mempty {
    return @"";
}

+ (Function*)mappend {
    return [Function fromBlock:^NSString*(NSString* s1, NSString* s2) {
        return [s1 stringByAppendingString:s2];
    }];
}

@end
