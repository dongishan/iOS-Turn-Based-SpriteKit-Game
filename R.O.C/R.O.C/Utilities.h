//
//  Utilities.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 10/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

//Generates a random point for a given boundry
+ (CGPoint)randomPointInRect:(CGRect)r;
+ (NSMutableArray *) TREE_POSITIONS;
+ (NSMutableArray *) GOLD_POSITIONS;
+ (NSMutableArray *) STONE_POSITIONS;
+ (NSMutableArray *) TERRAIN_POSITIONS;
+ (NSMutableArray *)shuffleArray:(NSMutableArray *)array;

    //Notifictions
+(void) postNotificationWithId : (NSString *)notificationId;
@end
