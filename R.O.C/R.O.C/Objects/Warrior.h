//
//  Warrior.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/03/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Character.h"
@class Warrior;
@class Player;
@protocol WarriorDelegate <NSObject>

@required
-(void)startedAttacking :(Warrior *)warrior;
-(void)stoppedAttacking :(Warrior *)warrior;
-(void)startedAttackingAI :(Warrior *)warrior;
-(void)stoppedAttackingAI :(Warrior *)warrior;

-(void)startedAttackingEnemyNear :(Warrior *)warrior;
-(void)stoppedAttackingEnemyNear :(Warrior *)warrior;
-(void)startedAttackingEnemyNearAI :(Warrior *)warrior;
-(void)stoppedAttackingEnemyNearAI :(Warrior *)warrior;

-(void)warriorDied :(Warrior *)warrior;
-(void)warriorDiedAI :(Warrior *)warrior;

@end

@interface Warrior : Character{
    NSMutableArray *attackAnimation,*dieAnimation;
    NSTimer *damageTimer,*damageTimerEnemyNear,*checkWarriorHealthTimer;
}
@property BOOL underAttack,attackEnemyWarrior;
@property (nonatomic,retain) Warrior *attackingEnemyWarrior;
@property (nonatomic,retain) NSMutableArray *attackedByWarriors;

@property (nonatomic)id <WarriorDelegate> warriorDelegate;
@property (nonatomic,retain) Player *enemyPlayer,*player;

-(void)die;

-(void)attackEnemyRelic:(CGPoint)location;
-(void)stopAttackEnemyRelic;

-(void)attackEnemyNear:(CGPoint)location;
-(void)stopAttackingEnemyNear;

-(void) stopAllTasks;
@end
