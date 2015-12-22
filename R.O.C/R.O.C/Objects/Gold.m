//
//  Gold.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Gold.h"

@implementation Gold

- (instancetype)initWithImageName :(NSString *)imageName position: (CGPoint)position value:(NSInteger)value{
    self = [super init];
    if (self) {
        self.goldNode = [[SKSpriteNode alloc]initWithImageNamed:imageName];
        self.goldNode.physicsBody = [SKPhysicsBody bodyWithTexture:self.goldNode.texture size:self.goldNode.texture.size];
        self.goldNode.physicsBody.dynamic = NO;
        self.goldNode.position = position;
        self.position = position;
        self.value = value;
        self.workPosition = CGPointMake(self.position.x+20, self.position.y-10);
    }
    return self;
}
@end
