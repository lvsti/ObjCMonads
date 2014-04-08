
//  AKnightsQuest.m
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.08..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#import "AKnightsQuest.h"
#import "List.h"
#import "MonadPlus.h"
#import "ObjCObject+Monad.h"
#import "Tuple.h"

typedef Pair(@int, @int) KnightPos;


MonadicValue Guard(BOOL value, Class m) {
    return value? [m unit](MkUnit()): [m mzero]();
}


List(KnightPos) MoveKnight(KnightPos pos) {
    int c = [Fst(pos) intValue];
    int r = [Snd(pos) intValue];
    NSArray* moves = @[MkPair(@(c+2), @(r-1)), MkPair(@(c+2), @(r+1)),
                       MkPair(@(c-2), @(r-1)), MkPair(@(c-2), @(r+1)),
                       MkPair(@(c+1), @(r-2)), MkPair(@(c+1), @(r+2)),
                       MkPair(@(c-1), @(r-2)), MkPair(@(c-1), @(r+2))];
    
    return
        MBEGIN([[List alloc] initWithArray:moves]) >=
        ^MonadicValue(id pos1, Class m) {
            int c1 = [Fst(pos1) intValue];
            int r1 = [Snd(pos1) intValue];
            return
                MBEGIN(Guard(c1 >= 1 && c1 <= 8 && r1 >= 1 && r1 <= 8, m)) >
                [m unit](pos1)
                MEND;
        }
        MEND;
}

List(KnightPos) In3Moves(KnightPos startPos) {
    return
        MBEGIN(MoveKnight(startPos)) >=
        MCONT(MoveKnight) >=
        MCONT(MoveKnight)
        MEND;
}

BOOL CanReachIn3Moves(KnightPos startPos, KnightPos endPos) {
    return Elem(endPos, In3Moves(startPos));
}

void Knight() {
    id start = MkPair(@6, @2);
    NSLog(@"knight: %@", MoveKnight(start));
//    NSLog(@"in 3 moves: %@", In3Moves(start));
    id end = MkPair(@6, @1);
    NSLog(@"can reach %@ from %@ in 3 moves: %d", end, start, CanReachIn3Moves(start, end));
}



