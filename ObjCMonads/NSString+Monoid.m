//
//  NSString+Monoid.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSString+Monoid.h"
#import "EXTScope.h"
#import "List.h"

@implementation NSString (Monoid)

- (id<Monoid>(^)(id<Monoid>))mappend {
    @weakify(self);
    return ^id<Monoid>(NSString* str) {
        @strongify(self);
        return [NSString mappend](self, str);
    };
}

+ (id<Monoid>(^)())mempty {
    return ^NSString*() {
        return @"";
    };
}

+ (id<Monoid>(^)(id<Monoid>, id<Monoid>))mappend {
    return ^NSString*(NSString* s1, NSString* s2) {
        return [s1 stringByAppendingString:s2];
    };
}

+ (id<Monoid>(^)(List*))mconcat {
    return ^NSString*(List* list) {
        return FoldR([NSString mappend], @"", list);
    };
}

@end
