//
//  Farmer.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 16/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"
@class Farmer;
@protocol FarmerDelegate <NSObject>

@required
-(void)startedGatherignGold :(Farmer *)farmer;
-(void)stoppedGatheringGold :(Farmer *)farmer;
-(void)startedGatherignGoldAI :(Farmer *)farmer;
-(void)stoppedGatheringGoldAI :(Farmer *)farmer;

-(void)startedGatheringStone :(Farmer *)farmer;
-(void)stoppedGatheringStone :(Farmer *)farmer;
-(void)startedGatheringStoneAI :(Farmer *)farmer;
-(void)stoppedGatheringStoneAI :(Farmer *)farmer;

-(void)startedGatheringWood :(Farmer *)farmer;
-(void)stoppedGatheringWood :(Farmer *)farmer;
-(void)startedGatheringWoodAI :(Farmer *)farmer;
-(void)stoppedGatheringWoodAI :(Farmer *)farmer;

-(void)startedBuilding :(Farmer *)farmer;
-(void)stoppedBuilding :(Farmer *)farmer;
-(void)startedBuildingAI :(Farmer *)farmer;
-(void)stoppedBuildingAI :(Farmer *)farmer;
@end

@interface Farmer : Character{
    NSMutableArray *gatherAnimation,*buildAnimation;
    BOOL gatheringGold,gatheringStone,gatheringWood;
    NSTimer *gatherGoldTimer, *gatherStoneTimer,*gatheringWoodTimer,*buildProgressTimer;
}

-(void)gatherGold:(CGPoint)location;
-(void)stopGatheringGold;

-(void)gatherStone:(CGPoint)location;
-(void)stopGatheringStone;

-(void)gatherWood:(CGPoint)location;
-(void)stopGatheringWood;

-(void)build:(CGPoint)location;
-(void)stopBuilding;

-(void)stopAllTasks;

@property NSInteger goldAmount,stoneAmount,woodAmount,buildProgress;
@property (nonatomic)id <FarmerDelegate> farmerDelegate;
@end
