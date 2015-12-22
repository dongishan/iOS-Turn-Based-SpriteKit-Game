//
//  Utilities.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 10/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(CGPoint)randomPointInRect:(CGRect)r{
    CGPoint p = r.origin;
    p.x += arc4random() % (int)r.size.width;
    p.y += arc4random() % (int)r.size.height;
    return p;
}

+(NSMutableArray *)TREE_POSITIONS{
    NSMutableArray *treePositons = [[NSMutableArray alloc] init];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(130, 240)]];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(180, 280)]];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(240, 330)]];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(300, 330)]];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(340, 400)]];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(600, 500)]];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(440, 500)]];
    [treePositons addObject:[NSValue valueWithCGPoint:CGPointMake(360, 570)]];
    return treePositons;
}


+(NSMutableArray *)GOLD_POSITIONS{
    NSMutableArray *goldPositons = [[NSMutableArray alloc] init];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(980, 550)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(980, 530)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(980, 480)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(950, 480)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(970, 500)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(20, 115)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(15, 125)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(25, 125)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(45, 130)]];
    [goldPositons addObject:[NSValue valueWithCGPoint:CGPointMake(55, 150)]];
    return goldPositons;
}

+(NSMutableArray *) STONE_POSITIONS{
    NSMutableArray *stonePositons = [[NSMutableArray alloc] init];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(780, 240)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(800, 220)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(840, 220)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(140, 680)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(130, 690)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(150, 710)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(110, 690)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(90, 670)]];
    [stonePositons addObject:[NSValue valueWithCGPoint:CGPointMake(60, 680)]];
    return stonePositons;
}

+(NSMutableArray *) TERRAIN_POSITIONS{
    NSMutableArray *terrainPositons = [[NSMutableArray alloc] init];
    [terrainPositons addObject:[NSValue valueWithCGPoint:CGPointMake(540, 390)]];
    [terrainPositons addObject:[NSValue valueWithCGPoint:CGPointMake(660, 390)]];
    [terrainPositons addObject:[NSValue valueWithCGPoint:CGPointMake(830, 480)]];
    [terrainPositons addObject:[NSValue valueWithCGPoint:CGPointMake(900, 380)]];
    [terrainPositons addObject:[NSValue valueWithCGPoint:CGPointMake(780, 440)]];
    [terrainPositons addObject:[NSValue valueWithCGPoint:CGPointMake(750, 400)]];
    return terrainPositons;
}

+(void) postNotificationWithId : (NSString *)notificationId{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationId object:nil userInfo:nil];
}

+(NSMutableArray *)shuffleArray:(NSMutableArray *)array{
    
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return array;
}

@end
