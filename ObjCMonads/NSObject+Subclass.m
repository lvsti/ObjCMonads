//
//  NSObject+Subclass.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "NSObject+Subclass.h"

@implementation NSObject (subclass)

+ (Class)newSubclassNamed:(NSString*)name
                protocols:(Protocol**)protos
                    impls:(SelBlockPair*)impls
{
    if (name == nil)
    {
        // basically create a random name
        name = [NSString stringWithFormat:@"%s_%i_%i", class_getName(self), arc4random(), arc4random()];
    }
    
    // allocated a new class as a subclass of self (so I could use this on a NSArray if I wanted)
    Class newClass = objc_allocateClassPair(self, [name UTF8String], 0);
    
    // add all of the protocols untill we hit null
    while (protos && *protos != NULL)
    {
        class_addProtocol(newClass, *protos);
        protos++;
    }
    
    // add all the impls till we hit null
    while (impls && impls->aSEL)
    {
        class_addMethod(newClass, impls->aSEL, imp_implementationWithBlock(impls->aBlock), "@@:*");
        impls++;
    }
    
    // register our class pair
    objc_registerClassPair(newClass);
    
    return newClass;
}

@end

