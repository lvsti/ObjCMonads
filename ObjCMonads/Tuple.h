//
//  Tuple.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import <Foundation/Foundation.h>


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
    
#ifdef __cplusplus
}
#endif
