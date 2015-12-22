//
//  Services.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 16/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "Services.h"

@implementation Services
@synthesize frequency;

-(id)initWithFrequency: (NSInteger) seconds{
    if(self = [super init]){
        self.frequency = seconds;
        return self;
    }
    return nil;
}
- (void)startService{
    [self startBackgroundTask];
}

- (void)doInBackground{
    [Utilities postNotificationWithId:kRUN_RESOURCE_ASSIGNMENT_ALGORYTHM];
}


- (void)stopService{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
}

- (void) startBackgroundTask{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:frequency
                                                        target:self
                                                      selector:@selector(doInBackground)
                                                      userInfo:nil
                                                       repeats:YES];
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
    }];
}
- (void) endBackgroundTask{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    [self startBackgroundTask];
}

@end

