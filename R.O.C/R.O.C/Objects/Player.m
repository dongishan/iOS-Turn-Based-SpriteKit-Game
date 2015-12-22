//
//  Player.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 20/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Player.h"

static const NSInteger WARRIOR_GOLD = 6;
static const NSInteger WARRIOR_STONE = 10;
static const NSInteger WARRIOR_WOOD = 14;

@implementation Player

- (instancetype)init
{
    self = [super init];
    if (self) {
        _power = 0;
        _goldAmount = 0;
        _stoneAmount = 0;
        _woodAmount = 0;
        _farmers = [[NSMutableArray alloc] init];
        _warriors = [[NSMutableArray alloc] init];
        _attackingWarriors = [[NSMutableArray alloc] init];
        _enemyWarriorsToAttack = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(REQUIRED_RESOURCE_TYPE)hasResourcesForWarrior{
    if(!self.warriorHouse || self.warriorHouse.health < 100){
        return WARRIOR_HOUSE;
    }
    if(_goldAmount/2 < WARRIOR_GOLD){
        return GOLD;
    }
    if(_stoneAmount/2 < WARRIOR_STONE){
        return STONE;
    }
    if(_woodAmount/2 < WARRIOR_WOOD){
        return WOOD;
    }
    return ALL;
}

-(Warrior *)produceWarrior{
    Warrior *warrior  =[[Warrior alloc] initWithImageNamed:@"warrior_01"];
    warrior.delegate = self;
    [_warriors addObject:warrior];
    _goldAmount-=(WARRIOR_GOLD*2);
    _stoneAmount-=(WARRIOR_STONE*2);
    _woodAmount-=(WARRIOR_WOOD*2);
    _power+=1;
    return warrior;
}

-(Farmer *)produceFarmer{
    Farmer *farmer = [[Farmer alloc]initWithImageNamed:@"farmer_01"];
    farmer.delegate = self;
    [_farmers addObject:farmer];
    return  farmer;
}

//Gold
-(void)gatherGoldAtGold:(Gold *)gold withFarmers: (NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        farmer.CURR_TASK = GATHER_GOLD;
        self.workGold = gold;
        [farmer walkTo:[Utilities randomPointInRect:CGRectMake(gold.workPosition.x, gold.workPosition.y, 10, 10)]];
    }
}

-(void)stopGatheringGold :(NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        [farmer stopGatheringGold];
    }
}

-(NSInteger)getGoldAmount{
    [self deliverGold];
    return _goldAmount;
}

-(void) deliverGold{
    for(Farmer *farmer in _farmers){
        _goldAmount+= farmer.goldAmount;
        farmer.goldAmount = 0;
    }
}

//Stone
-(void)gatherStoneAtStone:(Stone *)stone withFarmers: (NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        farmer.CURR_TASK = GATHER_STONE;
        self.workStone = stone;
        [farmer walkTo:[Utilities randomPointInRect:CGRectMake(stone.workPosition.x, stone.workPosition.y, 10, 10)]];
    }
}


-(void)stopGatheringStone:(NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        [farmer stopGatheringStone];
    }
}

-(NSInteger)getStoneAmount{
    [self deliverStone];
    return _stoneAmount;
}

-(void) deliverStone{
    for(Farmer *farmer in _farmers){
        _stoneAmount+= farmer.stoneAmount;
        farmer.stoneAmount = 0;
    }
}

//Wood
-(void)gatherWoodAtWood:(Wood *)wood withFarmers: (NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        farmer.CURR_TASK = GATHER_WOOD;
        self.workWood = wood;
        [farmer walkTo:[Utilities randomPointInRect:CGRectMake(wood.workPosition.x, wood.workPosition.y, 10, 10)]];
    }
}


-(void)stopGatheringWood:(NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        [farmer stopGatheringWood];
    }
}

-(NSInteger)getWoodAmount{
    [self deliverWood];
    return _woodAmount;
}

-(void) deliverWood{
    for(Farmer *farmer in _farmers){
        _woodAmount+= farmer.woodAmount;
        farmer.woodAmount = 0;
    }
}

//Building warrior house
-(void)build:(NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        farmer.CURR_TASK = BUILD_WARRIOR_HOUSE;
        [farmer walkTo:[Utilities randomPointInRect:CGRectMake(_warriorHouse.buildPosition.x, _warriorHouse.buildPosition.y, 10, 10)]];
        
    }
}

-(NSInteger)getBuildProgress{
    for(Farmer *farmer in _farmers){
        _warriorHouse.health+= farmer.buildProgress;
        farmer.buildProgress = 0;
    }
    return _warriorHouse.health;
}

-(void)stopBuilding:(NSMutableArray *)farmers{
    for(Farmer *farmer in farmers){
        [farmer stopBuilding];
    }
}

//Warrior attack
-(void)attackEnemyRelic:(NSMutableArray *)warriors{
    [self.enemyPlayer.relic setUnderAttack:YES];
    for(Warrior *warrior in warriors){
        if(warrior.CURR_TASK != ATTACK_ENEMY_NEAR && warrior.CURR_TASK != ATTACK_ENEMY_RELIC){
            warrior.CURR_TASK = ATTACK_ENEMY_RELIC;
            [warrior walkTo:[Utilities randomPointInRect:CGRectMake(_enemyPlayer.relic.attackPosition.x, _enemyPlayer.relic.attackPosition.y, 10, 10)]];
        }
    }
}

-(void)stopAttackingEnemyRelic:(NSMutableArray *)warriors{
    for(Warrior *warrior in warriors){
        [warrior stopAttackEnemyRelic];
    }
}

#pragma Person Delegate Methods
-(void)walkStop:(Character *)person{
    switch (person.SUB_TYPE) {
        case AI_FARMER:
        case FARMER:
            switch (person.CURR_TASK) {
                case GATHER_GOLD:
                    [(Farmer *)person gatherGold:[Utilities randomPointInRect:CGRectMake(_workGold.workPosition.x, _workGold.workPosition.y, 10, 10)]];
                    break;
                case GATHER_STONE:
                    [(Farmer *)person gatherStone:[Utilities randomPointInRect:CGRectMake(_workStone.workPosition.x, _workStone.workPosition.y, 10, 10)]];
                    break;
                case GATHER_WOOD:
                    [(Farmer *)person gatherWood:[Utilities randomPointInRect:CGRectMake(_workWood.workPosition.x, _workWood.workPosition.y, 10, 10)]];
                    break;
                case BUILD_WARRIOR_HOUSE:
                    [(Farmer *)person build:[Utilities randomPointInRect:CGRectMake(_warriorHouse.buildPosition.x, _warriorHouse.buildPosition.y, 10, 10)]];
                    break;
                default:
                    break;
            }
            break;
        case AI_WARRIOR:
        case WARRIOR:
            switch (person.CURR_TASK) {
                case ATTACK_ENEMY_RELIC:
                {
                    [(Warrior *)person attackEnemyRelic:[Utilities randomPointInRect:CGRectMake(_enemyPlayer.relic.position.x, _enemyPlayer.relic.position.y, 20, 20)]];
                    break;
                }
                case ATTACK_ENEMY_NEAR:
                {
                    Warrior *warrior = (Warrior *)person;
                    if(warrior.attackingEnemyWarrior != nil){
                        if(CGRectContainsPoint(CGRectMake(warrior.position.x, warrior.position.y, 10, 10),warrior.attackingEnemyWarrior.position)){
                            
                            [warrior attackEnemyNear:[Utilities randomPointInRect:CGRectMake(warrior.attackingEnemyWarrior.position.x, warrior.attackingEnemyWarrior.position.y, 10, 10)]];
                        }else{
                            if(CGRectContainsPoint(self.boundry, warrior.attackingEnemyWarrior.position)){
                                [warrior walkTo:warrior.attackingEnemyWarrior.position];
                            }else{
                                [warrior stopAllTasks];
                            }
                        }
                    }
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

#pragma Attacking enemy near
-(void)attackEnemyNear{
    [self.enemyPlayer setUnderAttack:YES];
    for(int i = 0,j = 0; i < _attackingWarriors.count;i++, j++){
        Warrior *warrior = [_attackingWarriors objectAtIndex:i];
        Warrior *enemyWarrior;
        
        if(i < _enemyWarriorsToAttack.count){
            enemyWarrior  = [_enemyWarriorsToAttack objectAtIndex:j];
        }else{
            enemyWarrior = nil;
        }
        
        if(enemyWarrior){
            [self attackEnemyWithWarrior:warrior enemy:enemyWarrior];
            //Send another warrior if any
            if(warrior.life <= enemyWarrior.life){
                if(i+1 < _attackingWarriors.count){
                    Warrior *nxtWarrior = [_attackingWarriors objectAtIndex:++i];
                    [self attackEnemyWithWarrior:nxtWarrior enemy:enemyWarrior];
                }
            }
        }
    }
}

-(void)attackEnemyWithWarrior : (Warrior *)warrior enemy:(Warrior *)enemyWarrior{
    if(warrior.CURR_TASK != ATTACK_ENEMY_NEAR){
        [warrior stopAllTasks];
        warrior.CURR_TASK = ATTACK_ENEMY_NEAR;
        
        warrior.attackEnemyWarrior = YES;
        enemyWarrior.underAttack = YES;
        
        warrior.attackingEnemyWarrior = enemyWarrior;
        [enemyWarrior.attackedByWarriors addObject:warrior];
        [warrior walkTo:enemyWarrior.position];
    }
}


-(void)stopattackingEnemyNear: (NSMutableArray *)warriors{
    for(Warrior *warrior in warriors){
        [warrior stopAttackingEnemyNear];
    }
}
@end
