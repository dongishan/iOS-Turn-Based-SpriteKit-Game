//
//  HelpViewController.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 13/03/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for(UIView *imageView in self.imageViews){
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)playHelpVideo:(id)sender{
    NSString *filepath;
    switch ([sender tag]) {
        case 0:
            filepath = [[NSBundle mainBundle] pathForResource:@"moving_player" ofType:@"m4v"];
            break;
        case 1:
            filepath = [[NSBundle mainBundle] pathForResource:@"gather_resources" ofType:@"m4v"];
            break;
        case 2:
            filepath = [[NSBundle mainBundle] pathForResource:@"create_player" ofType:@"m4v"];
            break;
        case 3:
            break;
        case 4:
            filepath = [[NSBundle mainBundle] pathForResource:@"attack_tower" ofType:@"m4v"];
            break;
        default:
            break;
            
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [self.view addSubview:moviePlayer.view];
    moviePlayer.fullscreen = YES;
    [moviePlayer play];
    
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
