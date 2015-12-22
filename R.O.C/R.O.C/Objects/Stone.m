//
//  Stone.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Stone.h"

@implementation Stone
- (instancetype)initWithImageName :(NSString *)imageName position: (CGPoint)position value:(NSInteger)value{
    self = [super init];
    if (self) {
        self.stoneNode = [[SKSpriteNode alloc]initWithImageNamed:imageName];
        self.stoneNode.physicsBody = [SKPhysicsBody bodyWithTexture:self.stoneNode.texture size:self.stoneNode.texture.size];
        self.stoneNode.physicsBody.dynamic = NO;
        self.stoneNode.position = position;
        self.position = position;
        self.value = value;
        self.workPosition = CGPointMake(self.position.x+20, self.position.y-10);
    }
    return self;
}
@end
