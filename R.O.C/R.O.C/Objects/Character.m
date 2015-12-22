//
//  Person.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 10/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Character.h"

@implementation Character

-(void)walkTo:(CGPoint)location {
    if (location.x > self.position.x) {
        [self setXScale:1.0];
    } else {
        [self setXScale:-1.0];
    }
    
    CGPoint distance = CGPointMake(location.x - self.position.x, location.y - self.position.y);
    float walkLength = sqrtf(distance.x * distance.x + distance.y * distance.y);
    float walkDuration = walkLength / 100.0;
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:walkAnimation timePerFrame:0.05f resize:NO restore:YES]] withKey:@"playerWalkAnimation"];
    [self runAction:[SKAction sequence:@[[SKAction moveTo:location duration:walkDuration],
                                         [SKAction runBlock:^{ [self walkStop]; }]]] withKey:@"playerWalkMovement"];
}

-(void)walkStop {
   
    [self removeActionForKey:@"playerWalkAnimation"];
    [self removeActionForKey:@"playerWalkMovement"];
    if ([_delegate respondsToSelector:@selector(walkStop:)]) {
        [_delegate walkStop:self];
    }
}

@end
