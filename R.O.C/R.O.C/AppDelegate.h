//
//  AppDelegate.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

-(void)stopInitialMusic;
@end

