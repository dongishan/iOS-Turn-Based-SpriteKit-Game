//
//  SplashViewController.m
//  ROC
//
//  Created by Gishan Don Ranasinghe on 07/11/2014.
//  Copyright (c) 2014 Gishan Don Ranasinghe. All rights reserved.
//

#import "SplashViewController.h"
#import "ProjectConstants.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    double delayInSeconds = SPLASH_DELAY;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     //   [self performSegueWithIdentifier:@"goToHome" sender:nil];
        
    });
    
}

-(IBAction)startGame:(id)sender{
    [self performSegueWithIdentifier:@"goToHome" sender:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
