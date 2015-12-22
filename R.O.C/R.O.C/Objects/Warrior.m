//
//  Warrior.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/03/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Warrior.h"

@implementation Warrior
-(instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    if (self) {
        //   self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.texture.size];
        //   self.physicsBody.dynamic = YES;
        self.life = 100;
        self.zPosition = 1;
        self.attackedByWarriors = [[NSMutableArray alloc] init];
        SKTextureAtlas *playerAnimationAtlas = [SKTextureAtlas atlasNamed:@"warrior"];
        walkAnimation = [[NSMutableArray alloc] init];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_01"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_02"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_03"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_04"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_05"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_06"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_07"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_08"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_09"]];
        [walkAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_walk_10"]];
        
        attackAnimation = [[NSMutableArray alloc] init];
        [attackAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_attack_01"]];
        [attackAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_attack_02"]];
        attackAnimation = [Utilities shuffleArray:attackAnimation];
        
        dieAnimation = [[NSMutableArray alloc]init];
        [dieAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_dead_01"]];
        [dieAnimation addObject:[playerAnimationAtlas textureNamed:@"warrior_dead_02"]];
        
    }
    return self;
}
#pragma Warrior death
-(void) die{
    [self runAction: [SKAction animateWithTextures:dieAnimation timePerFrame:0.5f resize:NO restore:YES]withKey:@"playerAttackAnimation"];
    [self performSelector:@selector(callDieDelegates) withObject:nil afterDelay:0.6];
}

-(void)callDieDelegates{
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_warriorDelegate respondsToSelector:@selector(warriorDiedAI:)]) {
                [_warriorDelegate warriorDiedAI:self];
            }
            break;
        case PC:
            if ([_warriorDelegate respondsToSelector:@selector(warriorDied:)]) {
                [_warriorDelegate warriorDied:self];
            }
            break;
        default:
            break;
    }
    
}
-(void)increaseDamageDoneToEnemy{
    _attackingEnemyWarrior.life-=3;
    if(_attackingEnemyWarrior.life <= 0){
        if(damageTimerEnemyNear){
            [damageTimerEnemyNear invalidate];
        }
        //Kill warrior
        [_attackingEnemyWarrior die];
        [_player.enemyWarriorsToAttack removeObject:_attackingEnemyWarrior];
        [_enemyPlayer.warriors removeObject:_attackingEnemyWarrior];
        [self performSelector:@selector(removeWarrior) withObject:nil afterDelay:0.5];
    }
}

-(void)removeWarrior{
    for(Warrior *warrior in _attackingEnemyWarrior.attackedByWarriors){
        [warrior stopAllTasks];
    }
}

-(void)attackEnemyRelic:(CGPoint)location{
    if (location.x > self.position.x) {
        [self setXScale:-1.0];
    } else {
        [self setXScale:1.0];
    }
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:attackAnimation timePerFrame:0.3f resize:NO restore:YES]] withKey:@"playerAttackAnimation"];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_warriorDelegate respondsToSelector:@selector(startedAttackingAI:)]) {
                [_warriorDelegate startedAttackingAI:self];
            }
            break;
        case PC:
            if ([_warriorDelegate respondsToSelector:@selector(startedAttacking:)]) {
                [_warriorDelegate startedAttacking:self];
            }
            break;
        default:
            break;
    }
    //Increasing damage done
    damageTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target: self
                                                 selector: @selector(increaseDamageDoneToEnemyRelic) userInfo: nil repeats: YES];
}

-(void)increaseDamageDoneToEnemyRelic{
    _enemyPlayer.relic.life-=1;
}

-(void) stopAllTasks{
    self.CURR_TASK = NON;
    if(self.attackEnemyWarrior){
        [self stopAttackingEnemyNear];
    }
    //Dont call below here. cause an error. The damage to tower not updating
    //   [self stopAttackEnemyRelic];
}

-(void)stopAttackEnemyRelic{
    [self removeActionForKey:@"playerAttackAnimation"];
    [self removeActionForKey:@"playerAttackMovement"];
    
    if(damageTimer){
        [damageTimer invalidate];
    }
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_warriorDelegate respondsToSelector:@selector(stoppedAttackingAI:)]) {
                [_warriorDelegate stoppedAttackingAI:self];
            }
            break;
        case PC:
            if ([_warriorDelegate respondsToSelector:@selector(stoppedAttacking:)]) {
                [_warriorDelegate stoppedAttacking:self];
            }
            break;
        default:
            break;
    }
}





#pragma Attacking enemy near
-(void)attackEnemyNear:(CGPoint)location{
    if (location.x > self.position.x) {
        [self setXScale:-1.0];
    } else {
        [self setXScale:1.0];
    }
    
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:attackAnimation timePerFrame:0.3f resize:NO restore:YES]] withKey:@"playerAttackAnimation"];
    
    
    //Increasing damage done
    damageTimerEnemyNear = [NSTimer scheduledTimerWithTimeInterval:1.0 target: self
                                                          selector: @selector(increaseDamageDoneToEnemy) userInfo: nil repeats: YES];
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_warriorDelegate respondsToSelector:@selector(startedAttackingEnemyNearAI:)]) {
                [_warriorDelegate startedAttackingEnemyNearAI:self];
            }
            break;
        case PC:
            if ([_warriorDelegate respondsToSelector:@selector(startedAttackingEnemyNear:)]) {
                [_warriorDelegate startedAttackingEnemyNear:self];
            }
            break;
        default:
            break;
    }
    
}


-(void)stopAttackingEnemyNear{
    [self removeActionForKey:@"playerAttackAnimation"];
    [self removeActionForKey:@"playerAttackMovement"];
    
    self.CURR_TASK = NON;
    
    if(damageTimerEnemyNear){
        [damageTimerEnemyNear invalidate];
    }
    switch (self.MAIN_TYPE) {
        case NPC:
            if ([_warriorDelegate respondsToSelector:@selector(stoppedAttackingEnemyNearAI:)]) {
                [_warriorDelegate stoppedAttackingEnemyNearAI:self];
            }
            break;
        case PC:
            if ([_warriorDelegate respondsToSelector:@selector(stoppedAttackingEnemyNear:)]) {
                [_warriorDelegate stoppedAttackingEnemyNear:self];
            }
            break;
        default:
            break;
    }
    
    self.attackingEnemyWarrior.underAttack = NO;
    self.attackingEnemyWarrior = nil;
    self.attackEnemyWarrior = NO;
    self.attackingEnemyWarrior.attackingEnemyWarrior = nil;
    
}
@end
