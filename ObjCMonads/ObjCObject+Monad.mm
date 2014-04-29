//
//  ObjCObject+Monad.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.07..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "ObjCObject+Monad.h"


ObjCObject operator>=(const ObjCObject& mvalue, const ObjCObject& cont) {
    NSLog(@"%@ >= ", mvalue._object);
//    return ((MonadicValue)obj._object).bind(cont._object);
    return [[[[mvalue._object class] bind] :mvalue._object] :cont._object];
}

ObjCObject operator>=(const ObjCObject& mvalue, ContFunc cont) {
    return [[[[mvalue._object class] bind] :mvalue._object] :[Function fromBlock:^MonadicValue(id value, Class m) { return cont(value); }]];
}


ObjCObject operator>(const ObjCObject& mvalue0, const ObjCObject& mvalue1) {
    NSLog(@"%@ > ", mvalue0._object);
//    return ((MonadicValue)obj._object).bind_(cont._object);
    return [[[[mvalue0._object class] bind_] :mvalue0._object] :mvalue1._object];
}

