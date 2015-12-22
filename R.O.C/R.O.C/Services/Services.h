//
//  Services.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 16/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Services : NSObject

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic) NSInteger frequency;
@property (nonatomic, strong) NSTimer *updateTimer;

- (id) initWithFrequency: (NSInteger) seconds;
- (void) startService;
- (void) doInBackground;
- (void) stopService;
@end
