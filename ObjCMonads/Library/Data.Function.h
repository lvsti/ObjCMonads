//
//  Data.Function.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.20..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Function.h"


#ifdef __cplusplus
extern "C" {
#endif

    // id :: a -> a
    id Id(id value);
    
    // const :: a -> b -> a
    id Const(id value1, id value2);
    
    // (.) :: (b -> c) -> (a -> b) -> (a -> c)
    Function* ComposeR(Function* fBC, Function* fAB);

#ifdef __cplusplus
}
#endif

