//
//  BaseViewController.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 30/10/2014.
//  Copyright (c) 2014 Gishan Don Ranasinghe. All rights reserved.
//

#import "BaseViewController.h"
#import "CivSelectionViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 

}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(IBAction)backDidClicked:(id)sender{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)nextDidClicked:(id)sender{
    CivSelectionViewController *civSelectionVC = [[CivSelectionViewController alloc] initWithNibName:@"CivSelectionViewController" bundle:nil];
    
    [self.navigationController pushViewController:civSelectionVC animated:YES];
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
