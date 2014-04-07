//
//  ObjCObject.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.07..
//  Copyright (c) 2014 LKXF. All rights reserved.
//


class ObjCObject {
public:
    ObjCObject(id obj): _object(obj) {}
    __strong id _object;
};

