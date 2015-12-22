//
//  Relic.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 16/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Relic : SKSpriteNode

@property (nonatomic) MAIN_TYPE MAIN_TYPE;
@property (nonatomic) CGPoint attackPosition;
@property BOOL underAttack;
@property (nonatomic) NSInteger life;
@end
