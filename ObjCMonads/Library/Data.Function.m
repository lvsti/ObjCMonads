//
//  Data.Function.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.20..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "Data.Function.h"


id Id(id value) {
    return value;
}

id Const(id value1, id value2) {
    return value1;
}

Function* ComposeR(Function* fBC, Function* fAB) {
    return [Function fromBlock:^id(id value) {
        return [fBC :[fAB :value]];
    }];
}

id Flip(Function* func, id b, id a) {
    return [func :a :b];
}

id Until(Function* pred, Function* func, id a) {
    id value = a;
    while (![[pred :value] boolValue]) {
        value = [func :value];
    }
    
    return value;
}


