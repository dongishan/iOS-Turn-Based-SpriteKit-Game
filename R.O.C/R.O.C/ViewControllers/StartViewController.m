//
//  StartViewController.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 13/03/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    progressValues = [[NSMutableArray alloc] initWithObjects:@"0.1",@"0.3",@"0.5",@"0.65",@"0.95",@"1",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didPressStart:(id)sender{
    [self.view setUserInteractionEnabled:NO];
    AppDelegate *app = [[UIApplication sharedApplication ]delegate];
    [app stopInitialMusic];
    [_progressBar setHidden:NO];
    progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.4
                                                           target:self
                                                         selector:@selector(updateProgress)
                                                         userInfo:nil
                                                          repeats:YES];
    
    
}

-(void)updateProgress{
    if(!dontUpdate){
        float currProgressVal = [[progressValues objectAtIndex:progressCounter++] floatValue];
        [_progressBar setProgress:currProgressVal animated:YES];
        if(currProgressVal == 1){
            dontUpdate = YES;
            [progressUpdateTimer invalidate];
            [self.view setUserInteractionEnabled:YES];
            [_loadingIndicator setHidden:NO];
            [_loadingIndicator startAnimating];
            [self performSegueWithIdentifier:@"goToGameWindow" sender:self];
        }
    }
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
