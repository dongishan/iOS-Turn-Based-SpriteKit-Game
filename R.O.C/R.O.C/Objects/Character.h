//
//  Person.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 10/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Character;
@protocol PersonDelegate <NSObject>

@required
-(void)walkStop : (Character *)person;
@end

@interface Character : SKSpriteNode{
    NSMutableArray *walkAnimation;    
}

-(void)walkTo:(CGPoint)location;
@property (nonatomic) MAIN_TYPE MAIN_TYPE;
@property (nonatomic) SUB_TYPE SUB_TYPE;
@property (nonatomic) CURRENT_TASK CURR_TASK;
@property (nonatomic)id <PersonDelegate> delegate;
@property (nonatomic)  NSInteger life;
@property (nonatomic,retain) NSString *name;
@end
