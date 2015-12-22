//
//  HumanPlayer.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Player.h"

@interface HumanPlayer : Player
-(void) build : (Farmer *)farmer;
-(void) stopBuilding;
-(void) gatherGoldAtGold:(Gold *)targetGold withFarmer:(Farmer *)selectedFarmer;
-(void) gatherStoneAtStone:(Stone *)targetStone withFarmer:(Farmer *)selectedFarmer;
-(void) gatherWoodAtWood:(Wood *)targetWood withFarmer:(Farmer *)selectedFarmer;
-(void) attackEnemyRelic: (Warrior *)warrior;
@property (nonatomic,retain)Farmer *buildingFarmer;
@end
