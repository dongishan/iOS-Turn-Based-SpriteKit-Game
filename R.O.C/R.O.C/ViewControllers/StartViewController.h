//
//  StartViewController.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 13/03/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : BaseViewController{
    NSMutableArray const *progressValues;
    NSInteger progressCounter;
    BOOL dontUpdate;
    NSTimer *progressUpdateTimer;
}
@property (nonatomic,retain)IBOutlet UIProgressView *progressBar;
@property (nonatomic,retain)IBOutlet UIActivityIndicatorView *loadingIndicator;
@end
