//
//  FeedbackViewController.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/05/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : BaseViewController<NSURLConnectionDelegate>{
 NSMutableData *responseData;
}

@property(nonatomic,retain) IBOutlet UITextField *edQuestion1,*edQuestion2,*edQuestion3,*edQuestion4,*edComment;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *loading;

@end
