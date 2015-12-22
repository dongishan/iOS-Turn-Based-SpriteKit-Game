//
//  HelpViewController.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 13/03/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface HelpViewController : BaseViewController{
MPMoviePlayerController * moviePlayer;
}
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;


@end
