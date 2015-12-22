//
//  ROCAlertView.h
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ROCAlertView;
typedef void (^alertDismissed)(void);

typedef NS_ENUM(NSInteger, ROCPopupType) {
    ROCFarmerBuild = 0,
    ROCreatPersons = 1,
    ROCNotEnoughResources = 2,
    ROCLevelOne = 3,
    ROCLevelTwo = 4,
    ROCShowObjectives
  
};

@protocol ROCAlertViewDelegate <NSObject>
@optional
-(void) positiveButtonPressedForROCAlertView:(ROCAlertView *)view;
-(void) destructiveButtonPressedForROCAlertView:(ROCAlertView *)view;
-(void) positiveButtonPressedForROCAlertView:(ROCAlertView *)view WithTextFieldText:(NSString *) message;
-(void) positiveButtonPressedForROCAlertView:(ROCAlertView *)view WithPickerView:(UIPickerView *) pickerView andSelectedIndex:(NSInteger)selectedIndex;

-(void) listButtonPressedForROCAlertView:(ROCAlertView *)view AtIndex:(NSUInteger )index withText:(NSString *)text;
-(void)didDismissed:(ROCAlertView*)view;
@end

@interface ROCAlertView : UIView <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *listButtons;//the first button of each list should start with tag = 10 the second with tag 11 and so on.
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (nonatomic,weak) id <ROCAlertViewDelegate> delegate;
@property(nonatomic,weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic,retain) NSMutableArray *pickerViewDataArray;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

-(instancetype)initWithPopupType:(ROCPopupType) popupType;
-(void)alertWithAnimationShowType:(KLCPopupShowType) showType andDismissType:(KLCPopupDismissType) dismissType dismissBg:(BOOL)dismissBg dismissContent:(BOOL)dismissContent;
-(void)alertWithPopupType:(ROCPopupType)popupType withTitle:(NSString *)title andMessage:(NSString *) message andDelegate:(id<ROCAlertViewDelegate>) delegate;
-(void)alertWithPopupType:(ROCPopupType)popupType withTitle:(NSString *)title andMessage:(NSString *) message andPositiveButtonTitle:(NSString *) positiveButtonTitle andDestructiveButtonTitle:(NSString *)destructiveButtonTitle andDelegate:(id<ROCAlertViewDelegate>) delegate;


-(void)show;
-(void)showAlertViewForTime:(unsigned long long )time andCompletionHandler:(alertDismissed) block;

-(void)dismiss;

//+(void)showSimpleAlertWithMsg: (NSString *)msg;
//+(void)showSimpleErrorAlertWithMsg: (NSString *)msg;
@end
