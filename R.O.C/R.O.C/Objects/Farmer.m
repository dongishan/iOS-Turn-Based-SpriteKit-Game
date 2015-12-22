//
//  Farmer.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 16/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Farmer.h"

@implementation Farmer
-(instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    if (self) {
        //   self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.texture.size];
        //   self.physicsBody.dynamic = YES;
        self.life = 100;
        SKTextureAtlas *playerAnimationAtlas = [SKTextureAtlas atlasNamed:@"farmer"];
        walkAnimation = [[NSMutableArray alloc] init];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_01"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_02"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_03"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_04"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_05"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_06"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_07"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_08"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_09"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_10"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_11"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_12"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_13"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_14"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_walk_15"]];
        
        gatherAnimation = [[NSMutableArray alloc] init];
        [gatherAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_gather_01"]];
        [gatherAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_gather_02"]];
        
        buildAnimation = [[NSMutableArray alloc] init];
        [buildAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_build_01"]];
        [buildAnimation addObject:[playerAnimationAtlas textureNamed:@"farmer_build_02"]];
        
    }
    return self;
}
#pragma gather wood
-(void)gatherWood:(CGPoint)location {
    if (location.x > self.position.x) {
        [self setXScale:-1.0];
    } else {
        [self setXScale:1.0];
    }
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:gatherAnimation timePerFrame:0.4f resize:NO restore:YES]] withKey:@"playerGatherAnimation"];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(startedGatheringWoodAI:)]) {
                [_farmerDelegate startedGatheringWoodAI:self];
            }
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(startedGatheringWood:)]) {
                [_farmerDelegate startedGatheringWood:self];
            }
            break;
        default:
            break;
    }
    
    
    //Increasing gold amount
    gatheringWoodTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target: self
                                                        selector: @selector(increaseWoodAmount) userInfo: nil repeats: YES];
}
-(void)increaseWoodAmount{
    _woodAmount+=1;
}

-(void)stopGatheringWood {
    [self removeActionForKey:@"playerGatherAnimation"];
    [self removeActionForKey:@"playerGatherMovement"];
   
    self.CURR_TASK = NON;
    [gatheringWoodTimer invalidate];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedGatheringWoodAI:)]) {
                [_farmerDelegate stoppedGatheringWoodAI:self];
            }
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedGatheringWood:)]) {
                [_farmerDelegate stoppedGatheringWood:self];
            }
            break;
        default:
            break;
    }
}


#pragma gather stone
-(void)gatherStone:(CGPoint)location {
    if (location.x > self.position.x) {
        [self setXScale:-1.0];
    } else {
        [self setXScale:1.0];
    }
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:gatherAnimation timePerFrame:0.4f resize:NO restore:YES]] withKey:@"playerGatherAnimation"];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(startedGatheringStoneAI:)]) {
                [_farmerDelegate startedGatheringStoneAI:self];
            }
            
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(startedGatheringStone:)]) {
                [_farmerDelegate startedGatheringStone:self];
            }
            
            break;
        default:
            break;
    }
    
    //Increasing gold amount
    gatherStoneTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target: self
                                                      selector: @selector(increaseStoneAmount) userInfo: nil repeats: YES];
}
-(void)increaseStoneAmount{
    _stoneAmount+=1;
}

-(void)stopGatheringStone {
    [self removeActionForKey:@"playerGatherAnimation"];
    [self removeActionForKey:@"playerGatherMovement"];

    self.CURR_TASK = NON;
    [gatherStoneTimer invalidate];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedGatheringStoneAI:)]) {
                [_farmerDelegate stoppedGatheringStoneAI:self];
            }
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedGatheringStone:)]) {
                [_farmerDelegate stoppedGatheringStone:self];
            }
            break;
        default:
            break;
    }
}

#pragma gather gold
-(void)gatherGold:(CGPoint)location {
    if (location.x > self.position.x) {
        [self setXScale:-1.0];
    } else {
        [self setXScale:1.0];
    }
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:gatherAnimation timePerFrame:0.4f resize:NO restore:YES]] withKey:@"playerGatherAnimation"];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(startedGatherignGoldAI:)]) {
                [_farmerDelegate startedGatherignGoldAI:self];
            }
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(startedGatherignGold:)]) {
                [_farmerDelegate startedGatherignGold:self];
            }
            break;
        default:
            break;
    }
    
    //Increasing gold amount
    gatherGoldTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target: self
                                                     selector: @selector(increaseGoldAmount) userInfo: nil repeats: YES];
}

-(void)increaseGoldAmount{
    _goldAmount+=1;
}

-(void)stopAllTasks{
    [self stopGatheringGold];
    [self stopGatheringStone];
    [self stopGatheringWood];
    
}

-(void)stopGatheringGold {
    [self removeActionForKey:@"playerGatherAnimation"];
    [self removeActionForKey:@"playerGatherMovement"];
    
    self.CURR_TASK = NON;
    [gatherGoldTimer invalidate];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedGatheringGoldAI:)]) {
                [_farmerDelegate stoppedGatheringGoldAI:self];
            }
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedGatheringGold:)]) {
                [_farmerDelegate stoppedGatheringGold:self];
            }
            break;
        default:
            break;
    }
}

#pragma build warrior house
-(void)build:(CGPoint)location {
    if (location.x > self.position.x) {
        [self setXScale:-1.0];
    } else {
        [self setXScale:1.0];
    }
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:buildAnimation timePerFrame:0.4f resize:NO restore:YES]] withKey:@"playerBuildAnimation"];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(startedBuildingAI:)]) {
                [_farmerDelegate startedBuildingAI:self];
            }
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(startedBuilding:)]) {
                [_farmerDelegate startedBuilding:self];
            }
            
            break;
        default:
            break;
    }
    
    //Increasing build progress
    buildProgressTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target: self
                                                        selector: @selector(increaseBuildValue) userInfo: nil repeats: YES];
    
}

-(void)increaseBuildValue{
    _buildProgress+=10;
}

-(void)stopBuilding {
    [self removeActionForKey:@"playerBuildAnimation"];
    [self removeActionForKey:@"playerBuildMovement"];
    
    self.CURR_TASK = NON;
    [buildProgressTimer invalidate];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedBuildingAI:)]) {
                [_farmerDelegate stoppedBuildingAI:self];
            }
            break;
        case PC:
            if ([_farmerDelegate respondsToSelector:@selector(stoppedBuilding:)]) {
                [_farmerDelegate stoppedBuilding:self];
            }
            break;
        default:
            break;
    }
}
@end
