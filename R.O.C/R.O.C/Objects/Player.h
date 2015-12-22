//
//  Player.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject<PersonDelegate>

@property (nonatomic,retain) Player *enemyPlayer;
@property (nonatomic) NSInteger power;
@property (nonatomic,retain) NSMutableArray *farmers;
@property (nonatomic,retain) NSMutableArray *warriors;
@property (nonatomic,retain) Relic *relic;
@property (nonatomic) CGRect boundry;
@property (nonatomic,retain) SKLabelNode *nameNode,*goldNode,*stoneNode,*woodNode,*quoteNode,*healthTextNode;
@property (nonatomic) NSInteger goldAmount,stoneAmount,woodAmount;
@property (nonatomic,retain)  SKSpriteNode *shieldNode,*healthNode;
@property (nonatomic) BOOL attackingEnemyRelic,producingWarriors,gatheringGold,gatheringStone,gatheringWood,buildingWarriorHouse;
@property (nonatomic,retain) Gold *workGold;
@property (nonatomic,retain) Stone *workStone;
@property (nonatomic,retain) Wood *workWood;
@property (nonatomic,retain) WarriorHouse *warriorHouse;
@property BOOL underAttack;
@property (nonatomic,retain) NSMutableArray *enemyWarriorsToAttack,*attackingWarriors;

-(REQUIRED_RESOURCE_TYPE)hasResourcesForWarrior;
-(Warrior *)produceWarrior;
-(Farmer *)produceFarmer;

-(void)gatherGoldAtGold:(Gold *)gold withFarmers: (NSMutableArray *)farmers;
-(void)stopGatheringGold :(NSMutableArray *)farmers;
-(NSInteger)getGoldAmount;

-(void)gatherStoneAtStone:(Stone *)stone withFarmers: (NSMutableArray *)farmers;
-(void)stopGatheringStone :(NSMutableArray *)farmers;
-(NSInteger)getStoneAmount;

-(void)gatherWoodAtWood:(Wood *)wood withFarmers: (NSMutableArray *)farmers;
-(void)stopGatheringWood :(NSMutableArray *)farmers;
-(NSInteger)getWoodAmount;

-(void)attackEnemyRelic:(NSMutableArray *)warriors;
-(void)stopAttackingEnemyRelic:(NSMutableArray *)warriors;

-(void)attackEnemyNear;
-(void)stopattackingEnemyNear :(NSMutableArray *)warriors;


-(void)build:(NSMutableArray *)farmers;
-(void)stopBuilding :(NSMutableArray *)farmers;
-(NSInteger)getBuildProgress;
@end
