//
//  GameScene.h
//  R.O.C
//

//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Character.h"
#import "Relic.h"

static const uint32_t missileCategory  =  0x1 << 0;
static const uint32_t shipCategory     =  0x1 << 1;
static const uint32_t asteroidCategory =  0x1 << 2;
static const uint32_t planetCategory   =  0x1 << 3;
static const uint32_t edgeCategory     =  0x1 << 4;

@import AVFoundation;
@interface GameScene : SKScene<SKPhysicsContactDelegate,FarmerDelegate,WarriorDelegate,ROCAlertViewDelegate>{
    Character *selectedPerson;
    NSMutableArray *woods,*golds,*stones,*terrains,*persons;
    SKSpriteNode *personImage,*farmerBuild,*addPerson,*showObjectives,*showHelp,*exitGame;
    SKLabelNode *personName,*personCurrActivity,*personNxtActivity,*personLife;
    AIPlayer *aiPlayer;
    HumanPlayer *humanPlayer;
    NSTimer *getGatheringGoldAmountTimer,*getGatheringGoldAmountTimerAI,*getGatheringStoneAmountTimer,*getGatheringStoneAmountTimerAI,*getGatheringWoodAmountTimer,*getGatheringWoodAmountTimerAI,*getDamageDoneTimer,*getDamageDoneTimerAI,*getBuildProgressTimer,*getBuildProgressTimerAI,*attackNearTimerAI,*attackNearTimer;
    BOOL schduledGatherGoldTimer,schduledGatherGoldTimerAI,schduledGatherStoneTimer,schduledGatherStoneTimerAI,schduledGatherWoodTimer,schduledGatherWoodTimerAI,schduledAttackTimer,schduledAttackTimerAI,schduledBuildTimer,schduledBuildTimerAI,schduledAttackNearTimerAI,schduledAttackNearTimer;
    Player *playerWon;
    Services *services;
}
@property (nonatomic) SKSpriteNode *river;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@end
