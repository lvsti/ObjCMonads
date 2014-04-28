//
//  NSInvocation+Extensions.h
//  ObjCCurry
//
//  Created by Tamas Lustyik on 2014.04.29..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Extensions)

- (id)returnedObject;
- (id)returnedObjectWithObjCType:(const char*)type;

@end
