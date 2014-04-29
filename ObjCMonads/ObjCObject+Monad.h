//
//  ObjCObject+Monad.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.07..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "ObjCObject.h"
#import "metamacros.h"
#import "Monad.h"

#define MBEGIN(x) (ObjCObject(x)
#define MEND )._object;
#define MRETURN(x) [m unit](x)

#define metamacro_argcount0(...) metamacro_if_eq( metamacro_argcount(__VA_ARGS__), metamacro_argcount( foo, ## __VA_ARGS__) )( metamacro_dec(metamacro_argcount(__VA_ARGS__)) )(metamacro_argcount(__VA_ARGS__))

#define MCONT_SEP(...) metamacro_if_eq(0, metamacro_argcount0(__VA_ARGS__))()(,)
#define MCONT(fname, ...) \
    ^MonadicValue(id value, Class m) { \
        return (MonadicValue)fname( \
            __VA_ARGS__ \
            MCONT_SEP(__VA_ARGS__) \
            value ); \
    }

ObjCObject operator>=(const ObjCObject& mvalue, const ObjCObject& cont);
ObjCObject operator>=(const ObjCObject& mvalue, ContFunc cont);

ObjCObject operator>(const ObjCObject& mvalue0, const ObjCObject& mvalue1);


