//
//  ObjCObject+Monoid.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.07..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "ObjCObject+Monoid.h"


ObjCObject operator+(const ObjCObject& mon1, const ObjCObject& mon2) {
    return [[[mon1._object class] mappend] :mon1._object :mon2._object];
}

