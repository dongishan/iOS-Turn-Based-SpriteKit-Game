//
//  ROCAlertView.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/02/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "ROCAlertView.h"
#import "KLCPopup.h"

@interface ROCAlertView()
@property (nonatomic) CGFloat keyboardGapFromPopup;
@property (nonatomic,strong) KLCPopup* popup;
@property (nonatomic) KLCPopupLayout layout;
@property (nonatomic) ROCPopupType popupType;


@end
@implementation ROCAlertView

-(instancetype)initWithPopupType:(ROCPopupType)popupType{
    self = [super init];
    if (self) {
        switch (popupType) {
            case ROCFarmerBuild:
                self = [[[NSBundle mainBundle] loadNibNamed:@"FarmerBuildView" owner:self options:nil]objectAtIndex:0];
                break;
            case ROCreatPersons:
                self = [[[NSBundle mainBundle] loadNibNamed:@"CreatePersonView" owner:self options:nil]objectAtIndex:0];
                break;
                
            case ROCNotEnoughResources:
                self = [[[NSBundle mainBundle] loadNibNamed:@"NotEnoughResourcesView" owner:self options:nil]objectAtIndex:0];
                break;
            case ROCLevelOne:
                self = [[[NSBundle mainBundle] loadNibNamed:@"Level_1" owner:self options:nil]objectAtIndex:0];
                break;
            case ROCLevelTwo:
                self = [[[NSBundle mainBundle] loadNibNamed:@"Level_2" owner:self options:nil]objectAtIndex:0];
                break;
            case ROCShowObjectives:
                self = [[[NSBundle mainBundle] loadNibNamed:@"ObjectivesView" owner:self options:nil]objectAtIndex:0];
                break;
            default:
                break;
        }
        
    }
    
    return self;
}

#pragma picker view delegate methods // Delegates for the Data source and the picker view are allocated at the xibs
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerViewDataArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _pickerViewDataArray[row];
}


#pragma mark - Setting Outlets
-(void)alertWithPopupType:(ROCPopupType)popupType withTitle:(NSString *)title andMessage:(NSString *) message andDelegate:(id<ROCAlertViewDelegate>)delegate{
    self.popupType = popupType;
    if (self.titleLabel) {
        self.titleLabel.text = title;
    }
    if (self.messageLabel) {
        self.messageLabel.text = message;
    }
    self.delegate = delegate;
}
-(void)alertWithPopupType:(ROCPopupType)popupType withTitle:(NSString *)title andMessage:(NSString *) message andPositiveButtonTitle:(NSString *) positiveButtonTitle andDestructiveButtonTitle:(NSString *)destructiveButtonTitle andDelegate:(id<ROCAlertViewDelegate>)delegate{
    [self alertWithPopupType:popupType withTitle:title andMessage:message andDelegate:delegate];
//    if (self.positiveButton) {
//        [self.positiveButton setTitle:positiveButtonTitle forState:UIControlStateNormal];
//    }
//    if (self.destructiveButton) {
//        [self.destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
//    }
    if  (self.textField){
        [self.textField becomeFirstResponder];
    }
}

-(void)alertWithPopupType:(ROCPopupType)popupType withTitle:(NSString *)title andPositiveButtonTitle:(NSString *) positiveButtonTitle andDestructiveButtonTitle:(NSString *)destructiveButtonTitle andPickerData:(NSMutableArray *)pickerData andDelegate:(id<ROCAlertViewDelegate>)delegate{
    [self alertWithPopupType:popupType withTitle:title andMessage:nil andDelegate:delegate];
    
}

#pragma mark - Present & Dismiss
-(void)alertWithAnimationShowType:(KLCPopupShowType) showType andDismissType:(KLCPopupDismissType) dismissType dismissBg:(BOOL)dismissBg dismissContent:(BOOL)dismissContent{
    self.popup = [KLCPopup popupWithContentView:self];
    
    self.layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,
                                     (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    self.popup = [KLCPopup popupWithContentView:self
                                       showType:showType
                                    dismissType:dismissType
                                       maskType:KLCPopupMaskTypeNone
                       dismissOnBackgroundTouch:dismissBg
                          dismissOnContentTouch:dismissContent];
    
}


-(void)showAlertViewForTime:(unsigned long long )time andCompletionHandler:(alertDismissed) block{
    if (self) {
        [self.popup showWithLayout:self.layout];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismiss];
            block();
        });
    }
    
}
-(void)show{
    if (self) {
        [self.popup showWithLayout:self.layout];
    }
}
-(void)dismiss{
    if (self.messageLabel) {
        [(UIView *)self.messageLabel dismissPresentingPopup];
    }else{
        [(UIView *)self.titleLabel dismissPresentingPopup];
    }
    if (self.textField) {
        [self.textField resignFirstResponder];
    }
    [self dismissPresentingPopup];
    if([self.delegate respondsToSelector:@selector(didDismissed:)]){
        [self.delegate didDismissed:self];
    }
    
}

#pragma mark - Lifecycle
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.layer.cornerRadius = 5.0;
    self.textField.delegate = self;
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    if (newWindow == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
    }
}
-(void)didMoveToWindow{
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIKeyboardWillShowNotification

-(void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSNumber *animationDuration = [[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *animationCurve = [[notification userInfo]objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGFloat keyboardY = keyboardFrame.origin.y;
    CGFloat popUpBottomY =self.popup.contentView.bounds.origin.y+self.popup.contentView.bounds.size.height;
    self.keyboardGapFromPopup = keyboardY - popUpBottomY;
    
    [UIView animateWithDuration:[animationDuration doubleValue] delay:0.0 options:[animationCurve integerValue] animations:^{
        CGRect bounds = self.popup.bounds;
        bounds.origin.y +=self.keyboardGapFromPopup;
        self.popup.bounds = bounds;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIKeyboardWillHideNotification
-(void)keyboardWillHide:(NSNotification *)notification{
    NSNumber *animationDuration = [[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *animationCurve = [[notification userInfo]objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    [UIView animateWithDuration:[animationDuration doubleValue] delay:0.0 options:[animationCurve integerValue] animations:^{
        CGRect bounds = self.popup.bounds;
        bounds.origin.y -=self.keyboardGapFromPopup;
        self.popup.bounds = bounds;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - ABAlertViewDelegate
//- (IBAction)destructiveButton:(id)sender {
//    [self dismiss];
//    if ([self.delegate respondsToSelector:@selector(destructiveButtonPressedForABAlertView:)]) {
//        [self.delegate destructiveButtonPressedForABAlertView:self];
//    }
//    
//    
//}
//- (IBAction)positiveButton:(id)sender {
//    [self dismiss];
//    if ([self.delegate respondsToSelector:@selector(positiveButtonPressedForABAlertView:)]) {
//        [self.delegate positiveButtonPressedForABAlertView:self];
//    }
//    if (self.textField) {
//        if ([self.delegate respondsToSelector:@selector(positiveButtonPressedForABAlertView:WithTextFieldText:)]) {
//            [self.delegate positiveButtonPressedForABAlertView:self WithTextFieldText:self.textField.text];
//        }
//    }
//    if(self.pickerView){
//        if([self.delegate respondsToSelector:@selector(positiveButtonPressedForABAlertView:WithPickerView:andSelectedIndex:)]){
//            [self.delegate positiveButtonPressedForABAlertView:self WithPickerView:self.pickerView andSelectedIndex:[self.pickerView selectedRowInComponent:0]];
//        }
//    }
//}
- (IBAction)dismissButton:(id)sender {
    [self dismiss];
}
//again the first button of each list should start with tag 10 the second with tag 11 and so on so the delegate can send the corrects indexes(starting from 0)
- (IBAction)listButton:(UIButton *)sender {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(listButtonPressedForROCAlertView:AtIndex:withText:)]) {
        NSUInteger index = sender.tag - 10;
        [self.delegate listButtonPressedForROCAlertView:self AtIndex:index withText:sender.titleLabel.text];
    }
}

//+(void)showSimpleAlertWithMsg: (NSString *)msg{
//    ABAlertView *simpleAlert = [[ABAlertView alloc]initWithPopupType:ABPopupTypeWithButton];
//    [simpleAlert alertWithAnimationShowType:KLCPopupShowTypeBounceIn andDismissType:KLCPopupDismissTypeBounceOut];
//    [simpleAlert alertWithPopupType:ABPopupTypeWithPositiveButtonAndTextField withTitle:@"Alert" andMessage:msg andDelegate:nil];
//    [simpleAlert show];
//}
//
//+(void)showSimpleErrorAlertWithMsg: (NSString *)msg{
//    ABAlertView *simpleErrorAlert = [[ABAlertView alloc]initWithPopupType:ABPopupTypeErrorWithButton];
//    [simpleErrorAlert alertWithAnimationShowType:KLCPopupShowTypeBounceIn andDismissType:KLCPopupDismissTypeBounceOut];
//    [simpleErrorAlert alertWithPopupType:ABPopupTypeWithPositiveButtonAndTextField withTitle:@"Error" andMessage:msg andDelegate:nil];
//    [simpleErrorAlert show];
//}

@end
