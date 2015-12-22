//
//  ContentViewController.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 30/10/2014.
//  Copyright (c) 2014 Gishan Don Ranasinghe. All rights reserved.
//

#import "ContentViewController.h"
#import "ProjectConstants.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_pageIndex == LAST_INTRO_PAGE_INDEX){
        [_btnStart setTitle:@"Start" forState:UIControlStateNormal];
    }else{
        
    }
    _imageView.image = [UIImage imageNamed:_imageFile];
    _titleLabel.text = _titleText;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goToNext:(id)sender{
    //Should slide to next page
    [self performSegueWithIdentifier:@"goToHome" sender:nil];
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
