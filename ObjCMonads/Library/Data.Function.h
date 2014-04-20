//
//  Data.Function.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.20..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^Mapping)(id);


#ifdef __cplusplus
extern "C" {
#endif

    // (.) :: (b -> c) -> (a -> b) -> (a -> c)
    Mapping ComposeR(Mapping mapBC, Mapping mapAB);

#ifdef __cplusplus
}
#endif

