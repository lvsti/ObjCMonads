//
//  AppDelegate.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.03..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "AppDelegate.h"
#import "List.h"
#import "Maybe.h"
#import "State.h"
#import "Writer.h"
#import "NSString+Monoid.h"
#import "ObjCObject+Monad.h"
#import "ObjCObject+Monoid.h"
#import "Pierre.h"
#import "AKnightsQuest.h"


Continuation dec(int by) {
    return ^MonadicValue(id val, Class m) {
        int res = [val intValue]-by;
        return res >= 0? Just(@(res)): Nothing();
    };
}

Continuation checkSign() {
    return ^MonadicValue(id val, Class m){
        return [val intValue] > 0? Just(val): Nothing();
    };
}

Continuation numToStr() {
    return ^MonadicValue(id val, Class m){
        NSLog(@"numToStr");
        return Just([NSString stringWithFormat:@"%d", [val intValue]]);
    };
}

Continuation pop() {
    return ^MonadicValue(id value, Class m) {
        return MkState(^Tuple*(List* state) {
            return MkPair(Head(state), Tail(state));
        });
    };
}

Continuation push(id obj) {
    return ^MonadicValue(id value, Class m) {
        return MkState(^Tuple*(List* state) {
            return MkPair(MkUnit(), Cons(obj, state));
        });
    };
}


Continuation gen() {
    return ^MonadicValue(id value, Class m) {
        return Replicate(3, value);
    };
}



//logNumber :: Int -> Writer [String] Int  
//logNumber x = Writer (x, ["Got number: " ++ show x])  
//  
//multWithLog :: Writer [String] Int  
//multWithLog = do  
//    a <- logNumber 3  
//    b <- logNumber 5  
//    return (a*b)

Writer* logNumber(int n) {
    return MkWriter(MkRecord(@(n), Singleton([NSString stringWithFormat:@"got number: %d", n])));
}

Writer* multWithLog() {
    return MBEGIN(logNumber(3)) >=
    ^MonadicValue(id a) {
        return MBEGIN(logNumber(5)) >=
        ^MonadicValue(id b, Class m) {
            return MRETURN(@([a intValue]*[b intValue]));
        }
        MEND;
    }
    MEND;
}


// TODO:
// - monad-specific `return` from inline monadic functions
// - expose continuation argument without nesting: ... >= \a -> fun1 >>= \b -> return (a+b)
// - typed chaining?

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    Knight();
    
    Pierre4();
    NSLog(@"writer: %@", multWithLog());
    
    ObjCObject monoid = ObjCObject(Singleton(@42)) + Empty() + Cons(@55, Cons(@66, Empty()));
    NSLog(@"monoid: %@", monoid._object);
    
    ObjCObject val = ObjCObject(Just(@5)) >=
                    dec(2) >=
                    dec(4) >=
                    Just(@3) >=
                    ^MonadicValue(id value, Class m) {
                        NSLog(@"value = %@", value);
                        return [m unit](value);
                    } >=
                    dec(1);
    
    NSArray* stack = @[@5,@4,@3,@2,@1];
    
    ObjCObject val2 = ObjCObject(Get()) >=
        push(@42) >=
        push(@666) >
        Get() >=
        ^MonadicValue(id value, Class m) {
            NSLog(@"state1: %@", value);
            return Get();
        } >=
        pop() >=
        ^MonadicValue(id value) {
            NSLog(@"popped %@", value);
            return Get();
        } >=
        ^MonadicValue(id value) {
            NSLog(@"state2: %@", value);
            return Get();
        };
    
    Tuple* t = RunState(val2._object, [[List alloc] initWithArray:stack]);
    NSLog(@"%@, %@", t[0], t[1]);

    ObjCObject val3 = ObjCObject([[List alloc] initWithArray:stack]) >=
        gen() >=
        ^MonadicValue(id value) {
            NSLog(@"gen1: %@", value);
            return Singleton(value);
        } >=
        gen() >=
        ^MonadicValue(id value) {
            NSLog(@"gen2: %@", value);
            return Singleton(value);
        };

    
    
//    Maybe* val = Just(@15).
//        bind(dec(2)).
//        bind(dec(1)).
//        bind(checkSign()).
//        bind_(Just(@3)).
//        bind(dec(1));
    
    //    MonadicValue val3 = Put(stack).
//    bind(push(@42)).
//    bind(push(@666)).
//    bind(Get()).
//    ^MonadicValue(id value) {
//        NSLog(@"state1: %@", value);
//        return Put(value);
//    };
    

//    NSLog(@"%@", val);
}

@end


//- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
//{
//    NSString* selectorName = NSStringFromSelector(aSelector);
//    if ([selectorName isEqualToString:@"value"]) {
//        return nil;
//    }
//    
//    return [NSMethodSignature signatureWithObjCTypes:"@?@:"];
//}
//
//- (void)forwardInvocation:(NSInvocation*)aInvocation
//{
//    NSString* selectorName = NSStringFromSelector([aInvocation selector]);
//    NSLog(@"invoking %@ on %@", selectorName, [self class]);
//    id this = self;
//    [aInvocation setReturnValue:&this];
//}

//- (void)forwardInvocation:(NSInvocation *)invocation;
//{
//    [invocation invokeWithTarget:nil];
//}
//
//- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
//{
//    return [super methodSignatureForSelector:aSelector];
//}
//
//- (void)forwardInvocation:(NSInvocation*)aInvocation
//{
//    [super forwardInvocation:aInvocation];
//}
//
//- (MaybeFun)dec {
//    return ^Maybe*{
//        return Just(@([self.value intValue]-1));
//    };
//}
//
//- (MaybeFun)checkSign {
//    return ^Maybe*{
//        return [self.value intValue] > 0? Just(self.value): Nothing();
//    };
//}
//
//- (MaybeFun)numToStr {
//    return ^Maybe*{
//        NSLog(@"numToStr");
//        return Just([NSString stringWithFormat:@"%d", [self.value intValue]]);
//    };
//}
//
//- (MaybeFun)strToNum {
//    return ^Maybe*{
//        return Just(@([self.value intValue]));
//    };
//}

//@end

//@interface NothingMaybe : Maybe
//@end
//
//@implementation NothingMaybe
//
//- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
//{
//    NSString* selectorName = NSStringFromSelector(aSelector);
//    if ([selectorName isEqualToString:@"value"]) {
//        return nil;
//    }
//    
//    return [NSMethodSignature signatureWithObjCTypes:"@?@:"];
//}
//
//- (void)forwardInvocation:(NSInvocation*)aInvocation
//{
//    NSString* selectorName = NSStringFromSelector([aInvocation selector]);
//    NSLog(@"invoking %@ on %@", selectorName, [self class]);
//    id this = self;
//    [aInvocation setReturnValue:&this];
//}
//
//@end
////
////
//@interface JustMaybe : Maybe
//@end
//
//
//@implementation JustMaybe
//
//- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
//{
//    return [super methodSignatureForSelector:aSelector];
//}
//
//- (void)forwardInvocation:(NSInvocation*)aInvocation
//{
//    NSString* selectorName = NSStringFromSelector([aInvocation selector]);
//    NSLog(@"invoking %@ on %@", selectorName, [self class]);
//    [super forwardInvocation:aInvocation];
//}
//
//@end
//
//Maybe* Just(id value) {
//    JustMaybe* m = [JustMaybe new];
//    m.value = value;
//    return m;
//}
//
//Maybe* Nothing() {
//    return [NothingMaybe new];
//}

//Maybe* Just(id value) {
//    assert(value);
//    Maybe* m = [[Maybe alloc] initWithValue:value];
//    return m;
//}
//
//Maybe* Nothing() {
//    return [[Maybe alloc] initWithNothing];
//}

//Maybe* Just(id value) {
//    assert(value);
//    Maybe* m = [[JustMaybe alloc] initWithValue:value];
//    return m;
//}
//
//Maybe* Nothing() {
//    return [[NothingMaybe alloc] initWithNothing];
//}


//@implementation Maybe (x)
//
//- (MContinuation)dec {
//    return ^MonadicValue(int by){
//        return Just(@([self.value intValue]-by));
//    };
//}
//
//- (MaybeFun)checkSign {
//    return ^Maybe*{
//        return [self.value intValue] > 0? Just(self.value): Nothing();
//    };
//}
//
//- (MaybeFun)numToStr {
//    return ^Maybe*{
//        NSLog(@"numToStr");
//        return Just([NSString stringWithFormat:@"%d", [self.value intValue]]);
//    };
//}
//
//- (MaybeFun)strToNum {
//    return ^Maybe*{
//        return Just(@([self.value intValue]));
//    };
//}
//
//@end

//MaybeStep dec(int by) {
//    return ^Maybe*(id val) {
//        return Just(@([val intValue]-by));
//    };
//}
//
//MaybeStep checkSign() {
//    return ^Maybe*(id val){
//        return [val intValue] > 0? Just(val): Nothing();
//    };
//}
//
//MaybeStep numToStr() {
//    return ^Maybe*(id val){
//        NSLog(@"numToStr");
//        return Just([NSString stringWithFormat:@"%d", [val intValue]]);
//    };
//}



/*
- (MaybeInt)dec {
    return ^Maybe*(NSNumber* v) {
        return Just(@([v intValue]-1));
    };
}

- (MaybeInt)checkSign {
    return ^Maybe*(NSNumber* v) {
        return [v intValue] > 0? Just(v): Nothing();
    };
}

- (MaybeInt)numToStr {
    return ^Maybe*(NSNumber* v) {
        return Just([NSString stringWithFormat:@"%d", [v intValue]]);
    };
}

- (MaybeString)strToNum {
    return ^Maybe*(NSString* str) {
        return Just(@([str intValue]));
    };
}
*/


/*
- (Maybe*)dec:(NSNumber*)v {
    return Just(@([v intValue]-1));
}

- (Maybe*)checkSign:(NSNumber*)v {
    return [v intValue] > 0? Just(v): Nothing();
}

- (Maybe*)numToStr:(NSString*)v {
    return Just([NSString stringWithFormat:@"%d", [v intValue]]);
}

- (Maybe*)strToNum:(NSString*)str {
    return Just(@([str intValue]));
}
*/