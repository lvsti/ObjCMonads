//
//  AppDelegate.m
//  RACKnight
//
//  Created by Tamas Lustyik on 2014.04.12..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "AppDelegate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef RACStream*(^Continuation)(id);

RACSequence* FromArray(NSArray* array) {
    __block RACSequence* seq = [RACSequence empty];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        seq = [seq startWith:obj];
    }];
    return seq;
}

RACSequence* Replicate(int n, id obj) {
    RACSequence* seq = [RACSequence empty];
    for (int i = 0; i < n; ++i) {
        seq = [seq startWith:obj];
    }
    return seq;
}



typedef RACTuple* KnightPos;

RACSequence* MoveKnight(KnightPos pos) {
    int c = [pos.first intValue];
    int r = [pos.second intValue];
    NSArray* moves = @[RACTuplePack(@(c+2), @(r-1)), RACTuplePack(@(c+2), @(r+1)),
                       RACTuplePack(@(c-2), @(r-1)), RACTuplePack(@(c-2), @(r+1)),
                       RACTuplePack(@(c+1), @(r-2)), RACTuplePack(@(c+1), @(r+2)),
                       RACTuplePack(@(c-1), @(r-2)), RACTuplePack(@(c-1), @(r+2))];
    
    // cons'ing a sequence
    RACSequence* movesSeq = FromArray(moves);
    
    return [movesSeq
        flattenMap:^RACSequence*(KnightPos move) {
            int c1 = [move.first intValue];
            int r1 = [move.second intValue];
            BOOL isValid = (c1 >= 1 && c1 <= 8 && r1 >= 1 && r1 <= 8);
            return isValid? [RACSequence return:move]: [RACSequence empty];
        }];
}

Continuation Cont_MoveKnight() {
    return ^RACStream*(KnightPos pos) {
        return MoveKnight(pos);
    };
}

Continuation Cont_Compose(Continuation contBC, Continuation contAB) {
    return ^RACSequence*(id value) {
        return [[[RACSequence
            return:value]
            flattenMap:contAB]
            flattenMap:contBC];
    };
}

    
RACSequence* In3Moves(KnightPos startPos) {
    return [[MoveKnight(startPos)
        flattenMap:Cont_MoveKnight()]
        flattenMap:Cont_MoveKnight()];
}

BOOL CanReachIn3Moves(KnightPos startPos, KnightPos endPos) {
    return [In3Moves(startPos) objectPassingTest:^BOOL(id value) {
        return [value isEqual:endPos];
    }] != nil;
}


RACSequence* InNMoves(int n, KnightPos startPos) {
//    inMany x start = return start >>= foldr (<=<) return (replicate x moveKnight)
    return
        [[RACSequence
            return:startPos]
            flattenMap:^RACStream*(id value) {
                Continuation cont = [Replicate(n, Cont_MoveKnight())
                    foldRightWithStart:^RACSequence*(id x) { return [RACSequence empty]; }
                    reduce:^id(id obj, RACSequence* rest) {
                        return Cont_Compose(obj, rest.head);
                    }];
                return cont(value);
            }];
}

BOOL CanReachInNMoves(int n, KnightPos startPos, KnightPos endPos) {
    return [InNMoves(n, startPos) objectPassingTest:^BOOL(id value) {
        return [value isEqual:endPos];
    }] != nil;
}



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    id start = RACTuplePack(@6, @1);
    id end = RACTuplePack(@7, @3);

    NSLog(@"can reach %@ from %@ in 3 moves: %d", end, start, CanReachIn3Moves(start, end));
    NSLog(@"can reach %@ from %@ in %d moves: %d", end, start, 5, CanReachInNMoves(5, start, end));
}

@end
