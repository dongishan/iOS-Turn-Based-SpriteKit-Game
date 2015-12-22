//
//  Wood.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Wood.h"

@implementation Wood

- (instancetype)initWithImageName :(NSString *)imageName position: (CGPoint)position value:(NSInteger)value{
    self = [super init];
    if (self) {
        self.woodNode = [[SKSpriteNode alloc]initWithImageNamed:imageName];
        self.woodNode.physicsBody = [SKPhysicsBody bodyWithTexture:self.woodNode.texture size:self.woodNode.texture.size];
        self.woodNode.physicsBody.dynamic = NO;
        self.woodNode.position = position;
        self.position = position;
        self.value = value;
        self.workPosition = CGPointMake(self.position.x+20, self.position.y-10);
    }
    return self;
}
@end
