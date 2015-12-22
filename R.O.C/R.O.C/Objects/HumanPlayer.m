//
//  HumanPlayer.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "HumanPlayer.h"

@implementation HumanPlayer

-(void) build:(Farmer *)farmer{
    self.buildingFarmer = farmer;
    NSMutableArray *farmers = [[NSMutableArray alloc] initWithObjects:farmer, nil];
    [super build:farmers];
}

-(void) stopBuilding{
    NSMutableArray *farmers = [[NSMutableArray alloc] initWithObjects:self.buildingFarmer, nil];
    [super stopBuilding:farmers];
}

-(void) gatherGoldAtGold:(Gold *)targetGold withFarmer:(Farmer *)selectedFarmer{
    NSMutableArray *farmers = [[NSMutableArray alloc] initWithObjects:selectedFarmer, nil];
    [super gatherGoldAtGold:targetGold withFarmers:farmers];
}

-(void)gatherStoneAtStone:(Stone *)targetStone withFarmer:(Farmer *)selectedFarmer{
    NSMutableArray *farmers = [[NSMutableArray alloc] initWithObjects:selectedFarmer, nil];
    [super gatherStoneAtStone:targetStone withFarmers:farmers];
}

-(void)gatherWoodAtWood:(Wood *)targetWood withFarmer:(Farmer *)selectedFarmer{
    NSMutableArray *farmers = [[NSMutableArray alloc] initWithObjects:selectedFarmer, nil];
    [super gatherWoodAtWood:targetWood withFarmers:farmers];
}

-(void) attackEnemyRelic: (Warrior *)warrior{
    NSMutableArray *warriors = [[NSMutableArray alloc] initWithObjects:warrior, nil];
    [super attackEnemyRelic:warriors];
}

@end
