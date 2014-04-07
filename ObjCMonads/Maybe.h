//
//  Maybe.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "Monad.h"

@interface Maybe : NSObject<Monad, Functor, NSCopying>

@end

#ifdef __cplusplus
extern "C" {
#endif
    
    Maybe* Just(id value);
    Maybe* Nothing();
    BOOL IsJust(Maybe* m);
    id FromJust(Maybe* m);
    
#ifdef __cplusplus
}
#endif

