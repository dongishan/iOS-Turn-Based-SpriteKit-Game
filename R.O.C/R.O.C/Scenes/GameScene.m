//
//  GameScene.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "GameScene.h"
#import "Farmer.h"
#import "Warrior.h"

static const int NUM_TREES = 8;
static const int NUM_GOLD = 10;
static const int NUM_STONE = 9;
static const int NUM_TERRAIN = 6;
static const int NUM_AI_FAMERS = 3;
static const int NUM_FAMERS = 3;

static const int BUILD_HOUSE_WARRIOR = 0;
static const int BUILD_STABLE = 1;
static const int CREATE_WARRIOR = 0;
static const int CREATE_FARMER = 1;
static const int START_GAME = 0;

//static const int ALERT_SHOW_LEVEL = 0;
static const int ALERT_BUILD_BUILDINGS = 1;
static const int ALERT_CREATE_PERSON = 2;
static const int ALERT_SHOW_OBJECTIVES = 3;

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //Adding notification obervers for algorythms
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(runResourceAssignmentAlgorythm) name:kRUN_RESOURCE_ASSIGNMENT_ALGORYTHM object:nil];
        
        NSError *error;
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"gameplay_music" withExtension:@"mp3"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        if(!error){
            self.backgroundMusicPlayer.numberOfLoops = -1;
            [self.backgroundMusicPlayer prepareToPlay];
            [self.backgroundMusicPlayer play];
        }
        
        SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.43 green:0.53 blue:0.07 alpha:1.00] size:CGSizeMake(1024, 676)];
        [self addChild:bgImage];
        bgImage.position = CGPointMake(self.size.width/2, 430);
        persons = [[NSMutableArray alloc] init];
        
        aiPlayer = [[AIPlayer alloc] init];
        humanPlayer = [[HumanPlayer alloc] init];
        
        [aiPlayer setEnemyPlayer:humanPlayer];
        [humanPlayer setEnemyPlayer:aiPlayer];
        
        if(kDEBUG){
            aiPlayer.goldAmount = 100;
            aiPlayer.stoneAmount = 100;
            aiPlayer.woodAmount = 100;
            
            humanPlayer.goldAmount = 100;
            humanPlayer.stoneAmount = 100;
            humanPlayer.woodAmount = 100;
        }
        
        [self addPhysicsToScence];
        [self markBoundries];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    [self addRivers];
    [self addTerrain];
    [self addGold];
    [self addStone];
    [self addTrees];
    [self addRelics];
    [self addFarmers];
    [self addAIFarmers];
    [self addDashBoard];
    
    self.paused  = YES;
    //    ROCAlertView *rocAlertViewLevel = [[ROCAlertView alloc]initWithPopupType:ROCLevelOne];
    //    rocAlertViewLevel.tag  = ALERT_SHOW_LEVEL;
    //    rocAlertViewLevel.delegate = self;
    //    [rocAlertViewLevel alertWithAnimationShowType:KLCPopupShowTypeBounceIn andDismissType:KLCPopupDismissTypeBounceOut dismissBg:YES dismissContent:YES];
    //    [rocAlertViewLevel showAlertViewForTime:4 andCompletionHandler:^{
    //        [rocAlertViewLevel dismiss];
    //    }];
    [self showObjectives];
}


#pragma Moving Validations
-(BOOL) validateMoveTouch : (CGPoint)location{
    //Checking on warriors
    for(Character *person in persons){
        if([person containsPoint:location]){
            return NO;
        }
    }
    return YES;
}

//******************************************** GENERIC METHODS *************************************************************
//******************************************** GENERIC METHODS *************************************************************
//******************************************** GENERIC METHODS *************************************************************

-(void)addDashBoard{
    SKSpriteNode *dashBgImage = [SKSpriteNode spriteNodeWithImageNamed:@"dashboard_bg"];
    dashBgImage.position = CGPointMake(512,0);
    [self addChild:dashBgImage];
    
    //Person
    personImage = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(70, 90)];
    personImage.position = CGPointMake(40,50);
    [self addChild:personImage];
    personImage.zPosition = 1;
    
    personName = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [personName setFontSize:15.0];
    personName.position =CGPointMake(115,80);
    [self addChild:personName];
    personName.zPosition = 1;
    
    personCurrActivity = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [personCurrActivity setFontSize:12.0];
    personCurrActivity.position =CGPointMake(138,60);
    [self addChild:personCurrActivity];
    personCurrActivity.zPosition = 1;
    
    personNxtActivity = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [personNxtActivity setFontSize:12.0];
    personNxtActivity.position =CGPointMake(132,40);
    [self addChild:personNxtActivity];
    personNxtActivity.zPosition = 1;
    
    personLife = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [personLife setFontSize:20.0];
    personLife.position =CGPointMake(134,15);
    [self addChild:personLife];
    personLife.zPosition = 1;
    
    farmerBuild = [SKSpriteNode spriteNodeWithImageNamed:@"build"];
    farmerBuild.position = CGPointMake(220,50);
    [farmerBuild setHidden:YES];
    [self addChild:farmerBuild];
    farmerBuild.zPosition = 1;
    
    
    //Players
    SKSpriteNode *playerShieldNode = [SKSpriteNode spriteNodeWithImageNamed:@"sparten_shield"];
    playerShieldNode.position = CGPointMake(300,50);
    [self addChild:playerShieldNode];
    playerShieldNode.zPosition = 1;
    [humanPlayer setShieldNode:playerShieldNode];
    
    SKLabelNode *playerNameNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [playerNameNode setFontSize:15.0];
    playerNameNode.position =CGPointMake(370,80);
    [playerNameNode setText:@"Spartans"];
    [self addChild:playerNameNode];
    playerNameNode.zPosition = 1;
    [humanPlayer setNameNode:playerNameNode];
    
    SKLabelNode *playerGoldNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [playerGoldNode setFontSize:12.0];
    playerGoldNode.position =CGPointMake(370,60);
    [playerGoldNode setText:@"Gold: 0"];
    [self addChild:playerGoldNode];
    playerGoldNode.zPosition = 1;
    [humanPlayer setGoldNode:playerGoldNode];
    
    SKLabelNode *playerStoneNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [playerStoneNode setFontSize:12.0];
    playerStoneNode.position =CGPointMake(370,40);
    [playerStoneNode setText:@"Stone: 0"];
    [self addChild:playerStoneNode];
    playerStoneNode.zPosition = 1;
    [humanPlayer setStoneNode:playerStoneNode];
    
    SKLabelNode *playerWoodNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [playerWoodNode setFontSize:12.0];
    playerWoodNode.position =CGPointMake(370,20);
    [playerWoodNode setText:@"Wood: 0"];
    [self addChild:playerWoodNode];
    playerWoodNode.zPosition = 1;
    [humanPlayer setWoodNode:playerWoodNode];
    
    exitGame = [SKSpriteNode spriteNodeWithImageNamed:@"exit_game"];
    exitGame.position = CGPointMake(430,50);
    [self addChild:exitGame];
    exitGame.zPosition = 1;
    
    addPerson = [SKSpriteNode spriteNodeWithImageNamed:@"add_farmer"];
    addPerson.position = CGPointMake(470,50);
    [self addChild:addPerson];
    addPerson.zPosition = 1;
    
    showObjectives = [SKSpriteNode spriteNodeWithImageNamed:@"objective"];
    showObjectives.position = CGPointMake(520,50);
    [self addChild:showObjectives];
    showObjectives.zPosition = 1;
    
    showHelp = [SKSpriteNode spriteNodeWithImageNamed:@"help"];
    showHelp.position = CGPointMake(560,50);
    [self addChild:showHelp];
    showHelp.zPosition = 1;
    
    
    //AI Players
    SKSpriteNode *aiShieldNode = [SKSpriteNode spriteNodeWithImageNamed:@"mongolian_shield"];
    aiShieldNode.position = CGPointMake(650,45);
    [self addChild:aiShieldNode];
    aiShieldNode.zPosition = 1;
    [aiPlayer setShieldNode:aiShieldNode];
    
    SKLabelNode *aiNameNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [aiNameNode setFontSize:15.0];
    aiNameNode.position =CGPointMake(740,75);
    [aiNameNode setText:@"Mongolians"];
    [self addChild:aiNameNode];
    aiNameNode.zPosition = 1;
    [aiPlayer setNameNode:aiNameNode];
    
    SKLabelNode *aiGoldNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [aiGoldNode setFontSize:12.0];
    aiGoldNode.position =CGPointMake(740,55);
    [aiGoldNode setText:@"Gold: 0"];
    [self addChild:aiGoldNode];
    aiGoldNode.zPosition = 1;
    [aiPlayer setGoldNode:aiGoldNode];
    
    SKLabelNode *aiStoneNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [aiStoneNode setFontSize:12.0];
    aiStoneNode.position =CGPointMake(740,35);
    [aiStoneNode setText:@"Stone: 0"];
    [self addChild:aiStoneNode];
    aiStoneNode.zPosition = 1;
    [aiPlayer setStoneNode:aiStoneNode];
    
    SKLabelNode *aiWoodNode = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [aiWoodNode setFontSize:12.0];
    aiWoodNode.position =CGPointMake(740,15);
    [aiWoodNode setText:@"Wood: 0"];
    [self addChild:aiWoodNode];
    aiWoodNode.zPosition = 1;
    [aiPlayer setWoodNode:aiWoodNode];
    
    SKSpriteNode *aiHealthRelic = [SKSpriteNode spriteNodeWithImageNamed:@"relic_small"];
    aiHealthRelic.position = CGPointMake(1000,53);
    [self addChild:aiHealthRelic];
    aiHealthRelic.zPosition = 1;
    
    SKSpriteNode *aiHealth = [SKSpriteNode spriteNodeWithImageNamed:@"health_100"];
    aiHealth.position = CGPointMake(920,70);
    [self addChild:aiHealth];
    aiHealth.zPosition = 1;
    [aiPlayer setHealthNode:aiHealth];
    
    SKLabelNode *aihealthTextLabel = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [aihealthTextLabel setFontSize:10.0];
    aihealthTextLabel.position =CGPointMake(920,65);
    [aihealthTextLabel setText:[NSString stringWithFormat:@"Mongol %d%%",aiPlayer.relic.life]];
    [self addChild:aihealthTextLabel];
    aihealthTextLabel.zPosition = 2;
    [aiPlayer setHealthTextNode:aihealthTextLabel];
    
    
    SKLabelNode *healthTextLabel = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    [healthTextLabel setFontSize:10.0];
    healthTextLabel.position =CGPointMake(920,30);
    [healthTextLabel setText:[NSString stringWithFormat:@"Sparta %d%%",humanPlayer.relic.life]];
    [self addChild:healthTextLabel];
    healthTextLabel.zPosition = 1;
    [humanPlayer setHealthTextNode:healthTextLabel];
    
    SKSpriteNode *health = [SKSpriteNode spriteNodeWithImageNamed:@"health_100"];
    health.position = CGPointMake(920,35);
    [self addChild:health];
    health.zPosition = 1;
    [humanPlayer setHealthNode:health];
    
}

#pragma Inserting elements to the map
-(void)addAIFarmers{
    for(int i = 0; i < NUM_AI_FAMERS; i++){
        Farmer *aiFarmer = [aiPlayer produceFarmer];
        aiFarmer.position =[Utilities randomPointInRect:CGRectMake(800, 120, 60, 60)];
        aiFarmer.MAIN_TYPE = NPC;
        aiFarmer.SUB_TYPE = AI_FARMER;
        aiFarmer.farmerDelegate = self;
        [self addChild:aiFarmer];
        [persons addObject:aiFarmer];
    }
}

-(void)addFarmers{
    for(int i = 0; i < NUM_FAMERS; i++){
        Farmer *farmer = [humanPlayer produceFarmer];
        farmer.position =[Utilities randomPointInRect:CGRectMake(300, 680, 60, 60)];
        farmer.MAIN_TYPE = PC;
        farmer.SUB_TYPE = FARMER;
        farmer.farmerDelegate = self;
        farmer.name = [NSString stringWithFormat:@"Farmer %d",i+1];
        [self addChild:farmer];
        [persons addObject:farmer];
    }
}

-(void)addTrees{
    woods = [[NSMutableArray alloc] init];
    for(int i =0; i < NUM_TREES; i++){
        CGPoint position = [[[Utilities TREE_POSITIONS] objectAtIndex:i] CGPointValue];
        Wood *wood = [[Wood alloc]initWithImageName:[NSString stringWithFormat:@"tree_01_%d",i] position:position value:100];
        [self addChild:wood.woodNode];
        [woods addObject:wood];
    }
}

-(void)addGold{
    golds = [[NSMutableArray alloc] init];
    for(int i =0; i < NUM_GOLD; i++){
        CGPoint position = [[[Utilities GOLD_POSITIONS] objectAtIndex:i] CGPointValue];
        Gold *gold = [[Gold alloc]initWithImageName:@"gold_01" position:position value:100];
        [self addChild:gold.goldNode];
        [golds addObject:gold];
    }
}

-(void)addStone{
    stones = [[NSMutableArray alloc] init];
    for(int i =0; i < NUM_STONE; i++){
        CGPoint position = [[[Utilities STONE_POSITIONS] objectAtIndex:i] CGPointValue];
        Stone *stone = [[Stone alloc]initWithImageName:@"stone_01" position:position value:100];
        [self addChild:stone.stoneNode];
        [stones addObject:stone];
    }
}

-(void)addRivers{
    _river = [SKSpriteNode spriteNodeWithImageNamed:@"river_01"];
    _river.position = CGPointMake(100, 400);
    [self addChild:_river];
    _river.physicsBody = [SKPhysicsBody bodyWithTexture:_river.texture size:_river.texture.size];
    _river.physicsBody.dynamic = NO;
    
}

-(void)addTerrain{
    terrains = [[NSMutableArray alloc] init];
    for(int i =0; i < NUM_TERRAIN; i++){
        CGPoint position = [[[Utilities TERRAIN_POSITIONS] objectAtIndex:i] CGPointValue];
        SKSpriteNode *terrain = [[SKSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"terrain_01_%d",i]];
        [terrain setPosition:position];
        [self addChild:terrain];
        terrain.physicsBody = [SKPhysicsBody bodyWithTexture:terrain.texture size:terrain.texture.size];
        terrain.physicsBody.dynamic = NO;
        [terrains addObject:terrain];
    }
}

-(void)addRelics{
    Relic *aiRelic = [[Relic alloc] initWithImageNamed:@"relic"];
    [aiRelic setMAIN_TYPE:NPC];
    [aiRelic setPosition:CGPointMake(950, 200)];
    [aiRelic setAttackPosition:CGPointMake(950, 170)];
    [self addChild:aiRelic];
    [aiPlayer setRelic:aiRelic];
    if(kDEBUG){
        aiPlayer.relic.life = 50;
    }
    
    Relic *relic = [[Relic alloc] initWithImageNamed:@"relic"];
    [relic setMAIN_TYPE:PC];
    [relic setPosition:CGPointMake(950, 700)];
    [relic setAttackPosition:CGPointMake(945, 640)];
    [self addChild:relic];
    [humanPlayer setRelic:relic];
}

- (void) addPhysicsToScence{
    // Give the scene an edge and configure other physics info on the scene.
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = edgeCategory;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = 0;
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
}



-(void)showObjectives{
    if(selectedPerson){
        [self resetPersonMenu];
    }
    ROCAlertView *rocAlertView = [[ROCAlertView alloc]initWithPopupType:ROCShowObjectives];
    [rocAlertView alertWithAnimationShowType:KLCPopupShowTypeBounceIn andDismissType:KLCPopupDismissTypeBounceOut dismissBg:NO dismissContent:NO];
    [rocAlertView setDelegate:self];
    rocAlertView.tag = ALERT_SHOW_OBJECTIVES;
    [rocAlertView show];
}
-(void)resetPersonMenu{
    [personImage setHidden:YES];
    personImage.texture = [SKTexture textureWithImageNamed:@""];
    [personName setText:@""];
    [personCurrActivity setText:@""];
    [personNxtActivity setText:@""];
    [personLife setText:@""];
    [farmerBuild setHidden:YES];
    selectedPerson = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    BOOL didselectPerson = NO;
    for(Character *person in persons){
        if([person containsPoint:location]){
            switch (person.MAIN_TYPE) {
                case PC:
                    switch (person.SUB_TYPE) {
                        case FARMER:
                            personImage.texture = [SKTexture textureWithImageNamed:@"farmer_idle"];
                            [personImage setHidden:NO];
                            [personName setText:person.name];
                            [personCurrActivity setText:@"Current Activity: Non"];
                            [personNxtActivity setText:@"Next Activity : Non"];
                            [personLife setText:[NSString stringWithFormat:@"Life : %ld%%",(long)person.life]];
                            [farmerBuild setHidden:NO];
                            break;
                        case WARRIOR:
                            personImage.texture = [SKTexture textureWithImageNamed:@"warrior_idle"];
                            [personImage setHidden:NO];
                            [personName setText:person.name];
                            [personCurrActivity setText:@"Current Activity: Non"];
                            [personNxtActivity setText:@"Next Activity : Non"];
                            [personLife setText:[NSString stringWithFormat:@"Life : %ld%%",(long)person.life]];
                            [farmerBuild setHidden:YES];
                            break;
                        default:
                            break;
                    }
                    
                    break;
                default:
                    break;
            }
            if(selectedPerson != person){
                didselectPerson = YES;
                selectedPerson = person;
                if(selectedPerson.SUB_TYPE == FARMER){
                    [(Farmer *)selectedPerson stopAllTasks];
                }
            }
        }
    }
    if(!didselectPerson){
        if(selectedPerson.SUB_TYPE == FARMER){
            Farmer *selectedFarmer = (Farmer *)selectedPerson;
            if([self selectedNodeGold:node]){
                [selectedFarmer stopAllTasks];
                Gold *targetGold;
                for(Gold *gold in golds){
                    if(CGRectContainsPoint(humanPlayer.boundry, gold.position)){
                        targetGold = gold;
                    }
                }
                if(targetGold){
                    [humanPlayer gatherGoldAtGold:targetGold withFarmer:selectedFarmer];
                }else{
                    //No GOLD in the area. Go for other gold with the warrior
                }
            }else if([self selectedNodeStone:node]){
                [selectedFarmer stopAllTasks];
                Stone *targetStone;
                for(Stone *stone in stones){
                    if(CGRectContainsPoint(humanPlayer.boundry, stone.position)){
                        targetStone = stone;
                    }
                }
                if(targetStone){
                    [humanPlayer gatherStoneAtStone:targetStone withFarmer:selectedFarmer];
                }else{
                    //No STONE in the area. Go for other stone with the warrior
                }
            }else if([self selectedNodeWood:node]){
                [selectedFarmer stopAllTasks];
                Wood *targetWood;
                for(Wood *wood in woods){
                    if(CGRectContainsPoint(humanPlayer.boundry, wood.position)){
                        targetWood = wood;
                    }
                }
                if(targetWood){
                    [humanPlayer gatherWoodAtWood:targetWood withFarmer:selectedFarmer];
                }else{
                    //No STONE in the area. Go for other stone with the warrior
                }
            }else{
                
            }
        }else{
            //Warrior
            Warrior *selectedWarrior = (Warrior *)selectedPerson;
            [selectedWarrior stopAllTasks];
            if([node isEqual:aiPlayer.relic]){
                [humanPlayer attackEnemyRelic:selectedWarrior];
            }
        }
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node isEqual:farmerBuild]){
        ROCAlertView *rocAlertViewFarmerBuild = [[ROCAlertView alloc]initWithPopupType:ROCFarmerBuild];
        [rocAlertViewFarmerBuild alertWithAnimationShowType:KLCPopupShowTypeBounceIn andDismissType:KLCPopupDismissTypeBounceOut dismissBg:YES dismissContent:NO];
        [rocAlertViewFarmerBuild setDelegate:self];
        rocAlertViewFarmerBuild.tag = ALERT_BUILD_BUILDINGS;
        [rocAlertViewFarmerBuild show];
    }else if([node isEqual:addPerson]){
        if(selectedPerson){
            [self resetPersonMenu];
        }
        ROCAlertView *rocAlertViewAddPerson = [[ROCAlertView alloc]initWithPopupType:ROCreatPersons];
        [rocAlertViewAddPerson alertWithAnimationShowType:KLCPopupShowTypeBounceIn andDismissType:KLCPopupDismissTypeBounceOut dismissBg:YES dismissContent:NO];
        [rocAlertViewAddPerson setDelegate:self];
        rocAlertViewAddPerson.tag = ALERT_CREATE_PERSON;
        [rocAlertViewAddPerson show];
    }else if([node isEqual:showObjectives]){
        [self showObjectives];
    }else if([node isEqual:exitGame]){
        // self.paused=!self.paused;
    }else if(selectedPerson.MAIN_TYPE == PC){
        
        if([self validateMoveTouch:location]){
            if(selectedPerson.SUB_TYPE == FARMER){
                [(Farmer *)selectedPerson stopAllTasks];
            }else{
                [(Warrior *)selectedPerson stopAllTasks];
            }
            [selectedPerson walkTo:location];
        }
    }
    
}

-(BOOL)selectedNodeGold:(SKNode *)node{
    for(Gold *gold in golds){
        if([gold.goldNode isEqual:node]){
            return YES;
        }
    }
    return NO;
    
}

-(BOOL)selectedNodeStone:(SKNode *)node{
    for(Stone *stone in stones){
        if([stone.stoneNode isEqual:node]){
            return YES;
        }
    }
    return NO;
    
}

-(BOOL)selectedNodeWood:(SKNode *)node{
    for(Wood *wood in woods){
        if([wood.woodNode isEqual:node]){
            return YES;
        }
    }
    return NO;
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)markBoundries{
    CGRect aiBoundry = CGRectMake(40, 100, 1024, 300);
    [aiPlayer setBoundry:aiBoundry];
    
    CGRect humanBoundry = CGRectMake(0, 500, 1024, 300);
    [humanPlayer setBoundry:humanBoundry];
    
}

//Removing observers
-(void)willMoveFromView:(SKView *)view{
    
}


//******************************************** AI PLAYER *************************************************************
//******************************************** AI PLAYER *************************************************************
//******************************************** AI PLAYER *************************************************************

#pragma GAME AIS

/*                                               Resource Assignment Algorythm
 ----------------------------------------------------------------------------------------------------------------------- */

-(void)runResourceAssignmentAlgorythm{
    
    [self win_attackEnemyRelic];
}

//1. Objective - Win | Task - Attack Enemy Relic | Prority - 1 | Rule - Enemy.Power < AI.Power | Solution - Production of warriors

-(void) win_attackEnemyRelic{
    if(aiPlayer.power > aiPlayer.enemyPlayer.power){
        NSLog(@"Objective: Win | Task: Attack the enemy relic");
        [aiPlayer attackEnemyRelic:aiPlayer.warriors];
    }
    
    if(aiPlayer.relic.life < aiPlayer.enemyPlayer.relic.life
       && aiPlayer.relic.underAttack){
        [self performSelectorOnMainThread:@selector(protectRelic_attackEnemyNear) withObject:nil waitUntilDone:NO];
    }
    
    //Increase Power - Produce Warriors
    NSLog(@"Objective: Increase Power | Task: Produce warriors");
    [self performSelectorOnMainThread:@selector(increasePower_produceWarriors) withObject:nil waitUntilDone:NO];
}

//2. Objective - Protect Relic | Task -  Attack enemy near boundry | Prority - 2 | Rule - Enemy Near && Enemy.Player.SUBTYPE == Warrior && AIPlayer.hasWarriors else Produce Warriors
-(void)protectRelic_attackEnemyNear{
    NSLog(@"Objective: Enemy Near | Task: Attack the enemy near");
    
    for(Warrior *enemyWarrior in aiPlayer.enemyPlayer.warriors){
        if(!enemyWarrior.underAttack && CGRectContainsPoint(aiPlayer.boundry, enemyWarrior.position)){
            if(![aiPlayer.enemyWarriorsToAttack containsObject:enemyWarrior]){
                [aiPlayer.enemyWarriorsToAttack addObject:enemyWarrior];
            }
        }
    }
    
    for(Warrior *warrior in aiPlayer.warriors){
        if(!warrior.attackEnemyWarrior){
            if(![aiPlayer.attackingWarriors containsObject:warrior]){
                [aiPlayer.attackingWarriors addObject:warrior];
            }
        }
    }
    [aiPlayer attackEnemyNear];
    
}

//3. Objective - Increase Power | Task - Produce Warriors | Prority - 3 | AIPlayer.recources >= RequiredWarrior.resources
-(void) increasePower_produceWarriors{
    switch ([aiPlayer hasResourcesForWarrior]) {
        case ALL:
        {
            Warrior *aiWarrior = [aiPlayer produceWarrior];
            aiWarrior.position =CGPointMake(570, 250);
            aiWarrior.MAIN_TYPE = NPC;
            aiWarrior.SUB_TYPE = AI_WARRIOR;
            aiWarrior.warriorDelegate = self;
            aiWarrior.enemyPlayer = humanPlayer;
            aiWarrior.player = aiPlayer;
            [self addChild:aiWarrior];
            [persons addObject:aiWarrior];
            [self updateGoldScoreAI];
            [self updateStoneScoreAI];
            [self updateWoodScoreAI];
        }
            break;
        case GOLD:
            if(!aiPlayer.gatheringGold){
                aiPlayer.gatheringGold = YES;
                [self increaseGold_gatherGold];
            }
            break;
        case STONE:
            if(!aiPlayer.gatheringStone){
                aiPlayer.gatheringStone = YES;
                [self increaseStone_gatherStone];
            }
            break;
        case WOOD:
            if(!aiPlayer.gatheringWood){
                aiPlayer.gatheringWood = YES;
                [self increaseWood_gatherWood];
            }
            break;
        case WARRIOR_HOUSE:
            if(!aiPlayer.buildingWarriorHouse){
                aiPlayer.buildingWarriorHouse = YES;
                [self buildWarriorHouse];
            }
            break;
        default:
            break;
    }
}

//4. Objective - Build Warriors | Build Warrior House
-(void) buildWarriorHouse{
    NSLog(@"Objective: Produce Warriors | Task: Build Warrior House");
    //Stopping other tasks
    [aiPlayer stopGatheringGold:aiPlayer.farmers];
    [aiPlayer stopGatheringStone:aiPlayer.farmers];
    [aiPlayer stopGatheringWood:aiPlayer.farmers];
    aiPlayer.warriorHouse = [[WarriorHouse alloc] initWithImageNamed:@"warrior_building_01"];
    aiPlayer.warriorHouse.buildPosition = CGPointMake(600, 280);
    aiPlayer.warriorHouse.position =CGPointMake(600,300);
    aiPlayer.warriorHouse.zPosition = 1;
    [aiPlayer build:aiPlayer.farmers];
    
}

//5. Objective - Increase Gold | Task - Gather Gold | Prority - 4
-(void) increaseGold_gatherGold{
    NSLog(@"Objective: Increase Gold | Task: Gather Gold");
    //Stopping other tasks
    [aiPlayer stopBuilding:aiPlayer.farmers];
    [aiPlayer stopGatheringStone:aiPlayer.farmers];
    [aiPlayer stopGatheringWood:aiPlayer.farmers];
    Gold *targetGold;
    for(Gold *gold in golds){
        if(CGRectContainsPoint(aiPlayer.boundry, gold.position)){
            targetGold = gold;
        }
    }
    if(targetGold){
        [aiPlayer gatherGoldAtGold:targetGold withFarmers:aiPlayer.farmers];
    }else{
        //No GOLD in the area. Go for other gold with the warrior
    }
}

//6. Objective - Increase Stone | Task - Gather Stone | Prority - 5
-(void) increaseStone_gatherStone{
    NSLog(@"Objective: Increase Stone | Task: Gather Stone");
    //Stopping other tasks
    [aiPlayer stopBuilding:aiPlayer.farmers];
    [aiPlayer stopGatheringWood:aiPlayer.farmers];
    [aiPlayer stopGatheringGold:aiPlayer.farmers];
    Stone *targetStone;
    for(Stone *stone in stones){
        if(CGRectContainsPoint(aiPlayer.boundry, stone.position)){
            targetStone = stone;
        }
    }
    if(targetStone){
        [aiPlayer gatherStoneAtStone:targetStone withFarmers:aiPlayer.farmers];
    }else{
        //No STONE in the area. Go for other stone with the warrior
    }
}

//7. Objective - Increase Wood | Task - Gather Wood | Prority - 6
-(void) increaseWood_gatherWood{
    NSLog(@"Objective: Increase Wood | Task:Gather Wood");
    //Stopping other tasks
    [aiPlayer stopBuilding:aiPlayer.farmers];
    [aiPlayer stopGatheringGold:aiPlayer.farmers];
    [aiPlayer stopGatheringStone:aiPlayer.farmers];
    Wood *targetWood;
    for(Wood *wood in woods){
        if(CGRectContainsPoint(aiPlayer.boundry, wood.position)){
            targetWood = wood;
        }
    }
    if(targetWood){
        [aiPlayer gatherWoodAtWood:targetWood withFarmers:aiPlayer.farmers];
    }else{
        //No WOOD in the area. Go for other wood with the warrior
    }
}

#pragma Warrior Delegate
-(void)startedAttackingAI:(Warrior *)warrior{
    //This method called as same number of times as the amount of thr aiPlayer.warriors.count
    if(!schduledAttackTimerAI){
        getDamageDoneTimerAI = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                                              selector: @selector(updateHealthAI) userInfo: nil repeats: YES];
        schduledAttackTimerAI = YES;
    }
}

-(void)stoppedAttackingAI:(Warrior *)warrior{
    if(getDamageDoneTimerAI){
        [getDamageDoneTimerAI invalidate];
    }
}


-(void)startedAttackingEnemyNearAI:(Warrior *)warrior{
    if(!schduledAttackNearTimerAI){
        attackNearTimerAI = [NSTimer scheduledTimerWithTimeInterval: 1.5 target: self
                                                           selector: @selector(checkEnemyAttackingNear) userInfo: nil repeats: YES];
        schduledAttackNearTimerAI = YES;
    }
}

-(void)checkEnemyAttackingNear{
    NSMutableArray *warriorsToStop = [[NSMutableArray alloc] init];
    for(Warrior *warrior in aiPlayer.attackingWarriors){
        if(warrior.CURR_TASK == ATTACK_ENEMY_NEAR){
            if(!CGRectContainsPoint(CGRectMake(warrior.position.x, warrior.position.y, 5, 5)
                                    ,warrior.attackingEnemyWarrior.position)){
                if(CGRectContainsPoint(aiPlayer.boundry, warrior.attackingEnemyWarrior.position)){
                    [warrior walkTo:warrior.attackingEnemyWarrior.position];
                }else{
                    [warriorsToStop addObject:warrior];
                }
            }else{
                if(warrior.attackingEnemyWarrior.life < 0){
                    [warriorsToStop addObject:warrior];
                }
            }
            
        }
    }
    
    for(Warrior *warriorToStop in warriorsToStop){
        [warriorToStop stopAllTasks];
    }
}

-(void)stoppedAttackingEnemyNearAI:(Warrior *)warrior{
    if([aiPlayer.attackingWarriors containsObject:warrior]){
        [aiPlayer.attackingWarriors removeObject:warrior];
    }
    
    if([aiPlayer.enemyWarriorsToAttack containsObject:warrior.attackingEnemyWarrior]){
        [aiPlayer.enemyWarriorsToAttack removeObject:warrior.attackingEnemyWarrior];
    }
    
}


#pragma Farmer Build Delegate
-(void)startedBuildingAI:(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledBuildTimerAI){
        [self addChild:aiPlayer.warriorHouse];
        getBuildProgressTimerAI = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                                                 selector: @selector(updateBuildingAI) userInfo: nil repeats: YES];
        schduledBuildTimerAI = YES;
    }
}

-(void)stoppedBuildingAI:(Farmer *)farmer{
    if(getBuildProgressTimerAI){
        [getBuildProgressTimerAI invalidate];
    }
}

#pragma Farmer Wood Delegate
-(void)startedGatheringWoodAI:(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledGatherWoodTimerAI){
        getGatheringWoodAmountTimerAI = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                                       selector: @selector(updateWoodScoreAI) userInfo: nil repeats: YES];
        schduledGatherWoodTimerAI = YES;
    }
}

-(void)stoppedGatheringWoodAI:(Farmer *)farmer {
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(schduledGatherWoodTimerAI){
        if(getGatheringWoodAmountTimerAI){
            [getGatheringWoodAmountTimerAI invalidate];
            schduledGatherWoodTimerAI = NO;
        }
    }
    aiPlayer.gatheringWood = NO;
    [self updateWoodScoreAI];
}

#pragma Farmer Stone Delegate
-(void)startedGatheringStoneAI:(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledGatherStoneTimerAI){
        getGatheringStoneAmountTimerAI = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                                        selector: @selector(updateStoneScoreAI) userInfo: nil repeats: YES];
        schduledGatherStoneTimerAI = YES;
    }
}

-(void)stoppedGatheringStoneAI:(Farmer *)farmer {
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(schduledGatherStoneTimerAI){
        if(getGatheringStoneAmountTimerAI){
            [getGatheringStoneAmountTimerAI invalidate];
            schduledGatherStoneTimerAI = NO;
        }
    }
    aiPlayer.gatheringStone = NO;
    [self updateStoneScoreAI];
}

#pragma Farmer Gold Delegate
-(void)startedGatherignGoldAI :(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledGatherGoldTimerAI){
        getGatheringGoldAmountTimerAI = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                                       selector: @selector(updateGoldScoreAI) userInfo: nil repeats: YES];
        schduledGatherGoldTimerAI = YES;
    }
}

-(void)stoppedGatheringGoldAI:(Farmer *)farmer {
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(schduledGatherGoldTimerAI){
        if(getGatheringGoldAmountTimerAI){
            [getGatheringGoldAmountTimerAI invalidate];
            schduledGatherGoldTimerAI = NO;
        }
    }
    aiPlayer.gatheringGold = NO;
    [self updateGoldScoreAI];
}

#pragma Updating Scores
-(void)updateGoldScoreAI{
    [aiPlayer.goldNode setText:[ NSString stringWithFormat:@"Gold: %d",[aiPlayer getGoldAmount]/2]];
}

-(void)updateStoneScoreAI{
    [aiPlayer.stoneNode setText:[ NSString stringWithFormat:@"Stone: %d",[aiPlayer getStoneAmount]/2]];
}

-(void)updateWoodScoreAI{
    [aiPlayer.woodNode setText:[ NSString stringWithFormat:@"Wood: %d",[aiPlayer getWoodAmount]/2]];
}

#pragma update health
-(void)updateHealthAI{
    if(humanPlayer.relic.life <=0){
        humanPlayer.relic.life = 0;
        [humanPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_0"]];
        playerWon = aiPlayer;
        [self gameOver];
    }else if(humanPlayer.relic.life <25){
        [humanPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_25"]];
    }else if(humanPlayer.relic.life < 50){
        [humanPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_50"]];
    }else if(humanPlayer.relic.life < 75){
        [humanPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_75"]];
    }
    humanPlayer.healthNode.zPosition = 1;
    [humanPlayer.healthTextNode setText:[NSString stringWithFormat:@"Sparta %d%%",humanPlayer.relic.life]];
    humanPlayer.healthTextNode.zPosition = 2;
    
}

#pragma Updating buildings
-(void)updateBuildingAI{
    NSInteger buildProgress = [aiPlayer getBuildProgress];
    if(buildProgress < 25){
        [aiPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_01"]];
    }else if(buildProgress < 50){
        [aiPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_02"]];
    }else if(buildProgress < 99){
        [aiPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_03"]];
    }else{
        [aiPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_04"]];
        [aiPlayer stopBuilding:aiPlayer.farmers];
        [aiPlayer.warriorHouse setScale:1.05];
        aiPlayer.warriorHouse.health =100;
    }
    
}


#pragma Game Over
-(void) gameOver{
    NSString *msgId;
    if([playerWon isEqual:aiPlayer]){
        msgId = @"game_over";
    }else{
        msgId = @"you_won";
    }
    SKSpriteNode  *gameOverNode = [SKSpriteNode spriteNodeWithImageNamed:msgId];
    gameOverNode.position = CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height/2)+180);
    [self addChild:gameOverNode];
    gameOverNode.zPosition = 2;
    
    //Stop Play
    self.paused = YES;
    [services stopService];
}

#pragma ROCAlertView Delegates

-(void)didDismissed:(ROCAlertView *)view{
    switch (view.tag) {
        case ALERT_SHOW_OBJECTIVES:
            if(!services){
                services = [[Services alloc] initWithFrequency: 2];
                [services startService];
            }
            break;
        default:
            break;
    }
}
-(void)listButtonPressedForROCAlertView:(ROCAlertView *)view AtIndex:(NSUInteger)index withText:(NSString *)text{
    switch (view.tag) {
        case ALERT_BUILD_BUILDINGS:
            switch (index) {
                case BUILD_HOUSE_WARRIOR:
                {
                    Farmer *selectedFarmer = (Farmer *)selectedPerson;
                    [selectedFarmer stopAllTasks];
                    humanPlayer.warriorHouse = [[WarriorHouse alloc] initWithImageNamed:@"warrior_building_01"];
                    humanPlayer.warriorHouse.buildPosition = CGPointMake(700, 500);
                    humanPlayer.warriorHouse.position =CGPointMake(700,520);
                    humanPlayer.warriorHouse.zPosition = 1;
                    [humanPlayer build:selectedFarmer];
                    break;
                }
                case BUILD_STABLE:
                    
                    break;
                default:
                    break;
            }
            
            break;
        case ALERT_CREATE_PERSON:
            switch (index) {
                case CREATE_WARRIOR:
                    if([humanPlayer hasResourcesForWarrior] == ALL){
                        Warrior *warrior = [humanPlayer produceWarrior];
                        warrior.position =CGPointMake(660, 480);
                        warrior.MAIN_TYPE = PC;
                        warrior.SUB_TYPE = WARRIOR;
                        warrior.warriorDelegate = self;
                        warrior.name = @"Warrior";
                        warrior.enemyPlayer = aiPlayer;
                        warrior.player = humanPlayer;
                        [self addChild:warrior];
                        [persons addObject:warrior];
                        [self updateGoldScore];
                        [self updateStoneScore];
                        [self updateWoodScore];
                    }else{
                        ROCAlertView *al = [[ROCAlertView alloc]initWithPopupType:ROCNotEnoughResources];
                        [al alertWithAnimationShowType:KLCPopupShowTypeBounceIn andDismissType:KLCPopupDismissTypeBounceOut dismissBg:YES dismissContent:YES];
                        [al showAlertViewForTime:4 andCompletionHandler:^{
                            [al dismiss];
                        }];
                        
                    }
                    
                    break;
                case CREATE_FARMER:
                    break;
                default:
                    break;
            }
            break;
        case ALERT_SHOW_OBJECTIVES:
            switch (index) {
                case START_GAME:
                    self.paused = NO;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

-(void)warriorDiedAI:(Warrior *)warrior{
    
}

//******************************************** HUMAN PLAYER *************************************************************
//******************************************** HUMAN PLAYER *************************************************************
//******************************************** HUMAN PLAYER *************************************************************

#pragma Farmer Build Delegate Human
-(void)startedBuilding:(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledBuildTimer){
        [self addChild:humanPlayer.warriorHouse];
        getBuildProgressTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                                               selector: @selector(updateBuilding) userInfo: nil repeats: YES];
        schduledBuildTimer = YES;
    }
}

-(void)stoppedBuilding:(Farmer *)farmer{
    if(getBuildProgressTimer){
        [getBuildProgressTimer invalidate];
    }
    [farmer walkTo:CGPointMake(600, 600)];
}

#pragma Updating buildings
-(void)updateBuilding{
    NSInteger buildProgress = [humanPlayer getBuildProgress];
    if(buildProgress < 25){
        [humanPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_01"]];
    }else if(buildProgress < 50){
        [humanPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_02"]];
        [humanPlayer.warriorHouse setScale:0.4];
    }else if(buildProgress < 99){
        [humanPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_03"]];
        [humanPlayer.warriorHouse setScale:0.7];
    }else{
        [humanPlayer.warriorHouse setTexture:[SKTexture textureWithImageNamed:@"warrior_building_04"]];
        [humanPlayer stopBuilding];
        [humanPlayer.warriorHouse setScale:1.05];
        humanPlayer.warriorHouse.health =100;
    }
    
}

#pragma Farmer Wood Delegate
-(void)startedGatheringWood:(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledGatherWoodTimer){
        getGatheringWoodAmountTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                                     selector: @selector(updateWoodScore) userInfo: nil repeats: YES];
        schduledGatherWoodTimer = YES;
    }
}

-(void)stoppedGatheringWood:(Farmer *)farmer {
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(schduledGatherWoodTimer){
        if(getGatheringWoodAmountTimer){
            [getGatheringWoodAmountTimer invalidate];
            schduledGatherWoodTimer = NO;
        }
    }
    aiPlayer.gatheringWood = NO;
    [self updateWoodScore];
}

#pragma Farmer Stone Delegate
-(void)startedGatheringStone:(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledGatherStoneTimer){
        getGatheringStoneAmountTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                                      selector: @selector(updateStoneScore) userInfo: nil repeats: YES];
        schduledGatherStoneTimer = YES;
    }
}

-(void)stoppedGatheringStone:(Farmer *)farmer {
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(schduledGatherStoneTimer){
        if(getGatheringStoneAmountTimer){
            [getGatheringStoneAmountTimer invalidate];
            schduledGatherStoneTimer = NO;
        }
    }
    aiPlayer.gatheringStone = NO;
    [self updateStoneScore];
}

#pragma Farmer Gold Delegate
-(void)startedGatherignGold :(Farmer *)farmer{
    //This method called as same number of times as the amount of thr aiPlayer.farmer.count
    if(!schduledGatherGoldTimer){
        getGatheringGoldAmountTimer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                                                     selector: @selector(updateGoldScore) userInfo: nil repeats: YES];
        schduledGatherGoldTimer = YES;
    }
}

-(void)stoppedGatheringGold:(Farmer *)farmer {
    //This method called as same number of times as the amount of the humanPlayer.farmer.count
    if(schduledGatherGoldTimer){
        if(getGatheringGoldAmountTimer){
            [getGatheringGoldAmountTimer invalidate];
            schduledGatherGoldTimer = NO;
        }
    }
    humanPlayer.gatheringGold = NO;
    [self updateGoldScore];
}

#pragma Updating Scores
-(void)updateGoldScore{
    [humanPlayer.goldNode setText:[ NSString stringWithFormat:@"Gold: %d",[humanPlayer getGoldAmount]/2]];
}


-(void)updateStoneScore{
    [humanPlayer.stoneNode setText:[ NSString stringWithFormat:@"Stone: %d",[humanPlayer getStoneAmount]/2]];
}

-(void)updateWoodScore{
    [humanPlayer.woodNode setText:[ NSString stringWithFormat:@"Wood: %d",[humanPlayer getWoodAmount]/2]];
}

#pragma Human Warrior Delegates
-(void)startedAttacking:(Warrior *)warrior{
    //This method called as same number of times as the amount of thr aiPlayer.warriors.count
    if(!schduledAttackTimer){
        getDamageDoneTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                                            selector: @selector(updateHealth) userInfo: nil repeats: YES];
        schduledAttackTimer = YES;
    }
}

-(void)stoppedAttacking:(Warrior *)warrior{
    if(getDamageDoneTimer){
        [getDamageDoneTimer invalidate];
    }
}


-(void)startedAttackingEnemyNear:(Warrior *)warrior{
    
}

-(void)stoppedAttackingEnemyNear:(Warrior *)warrior{
    
}

#pragma update health
-(void)updateHealth{
    if(aiPlayer.relic.life <=0){
        aiPlayer.relic.life = 0;
        [aiPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_0"]];
        playerWon = humanPlayer;
        [self gameOver];
    }else if(aiPlayer.relic.life <25){
        [aiPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_25"]];
    }else if(aiPlayer.relic.life < 50){
        [aiPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_50"]];
    }else if(aiPlayer.relic.life < 75){
        [aiPlayer.healthNode setTexture:[SKTexture textureWithImageNamed:@"health_75"]];
    }
    aiPlayer.healthNode.zPosition = 1;
    [aiPlayer.healthTextNode setText:[NSString stringWithFormat:@"Mongol %d%%",aiPlayer.relic.life]];
    aiPlayer.healthTextNode.zPosition = 2;
}

-(void)warriorDied:(Warrior *)warrior{
    if([selectedPerson isEqual:warrior]){
        [self resetPersonMenu];
    }
    [warrior removeFromParent];
}

@end
