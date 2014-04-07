//
//  Tuple.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Pair(fst_type, snd_type)    Tuple*


@interface Tuple : NSObject<NSCopying>

@property (nonatomic, assign, readonly) int size;

- (instancetype)initWithObjectsFromArray:(NSArray*)array;
- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end


#ifdef __cplusplus
extern "C" {
#endif
    
    Tuple* MkUnit();
    Tuple* MkPair(id a, id b);
    id Fst(Tuple* tuple);
    id Snd(Tuple* tuple);
    
#ifdef __cplusplus
}
#endif
