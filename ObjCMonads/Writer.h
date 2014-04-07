//
//  Writer.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.06..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functor.h"
#import "Monad.h"
#import "Monoid.h"
#import "Tuple.h"

typedef id Result;
typedef id<Monoid> Output;
typedef Tuple* Record; // (Result, Output)
typedef id(^OutputSelector)(Output);
typedef Output(^OutputModifier)(Output);

@interface Writer : NSObject<Monad, Functor, NSCopying>

@end


#ifdef __cplusplus
extern "C" {
#endif
    
    // (,) :: a -> w -> (a, w)
    Record MkRecord(Result result, Output output);
    
    // writer :: (a, w) -> Writer w a
    Writer* MkWriter(Record rec);
    
    // runWriter :: Writer w a -> (a, w)
    Record RunWriter(Writer* m);
    
    // tell :: (Monoid w) => w -> Writer w ()
    Writer* Tell(Output output);
    
    // listen :: (Monoid w) => Writer w a -> Writer w (a, w)
    Writer* Listen(Writer* m);
    
    // listens :: (Monoid w) => (w -> b) -> Writer w a -> Writer w (a, b)
    Writer* ListenS(OutputSelector sel, Writer* m);
    
    // pass :: (Monoid w) => Writer w (a, w -> w) -> Writer w a
    Writer* Pass(Writer* m);
    
    // censor :: (Monoid w) => (w -> w) -> Writer w a -> Writer w a
    Writer* Censor(OutputModifier mod, Writer* m);
    
#ifdef __cplusplus
}
#endif

