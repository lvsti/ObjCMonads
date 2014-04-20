//
//  Data.Function.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.20..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Data.Function.h"


// (.) :: (b -> c) -> (a -> b) -> (a -> c)
Mapping ComposeR(Mapping mapBC, Mapping mapAB) {
    return ^id(id value) {
        return mapBC(mapAB(value));
    };
}


