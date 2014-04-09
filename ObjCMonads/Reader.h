//
//  Reader.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "Monad.h"

typedef id Environment;
typedef id(^EnvironmentSelector)(Environment);
typedef Environment(^EnvironmentModifier)(Environment);
typedef id(^Computation)(Environment);


@interface Reader : NSObject<Monad, Functor, NSCopying>

@end


#ifdef __cplusplus
extern "C" {
#endif
    
    Reader* MkReader(Computation comp);
    id RunReader(Reader* m, Environment env);
    Reader* Ask();
    Reader* AskS(EnvironmentSelector sel);
    Reader* Local(EnvironmentModifier mod, Reader* m);
    
#ifdef __cplusplus
}
#endif
