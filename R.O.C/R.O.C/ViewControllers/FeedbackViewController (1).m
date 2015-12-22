//
//  FeedbackViewController.m
//  R.O.C
//
//  Created by Gishan Don Ranasinghe on 08/05/2015.
//  Copyright (c) 2015 Gishan Don Ranasinghe. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}

-(IBAction)sendFeedback:(id)sender{
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_edQuestion1.text forKey:@"question_1"];
    [params setObject:_edQuestion2.text forKey:@"question_2"];
    [params setObject:_edQuestion3.text forKey:@"question_3"];
    [params setObject:_edQuestion4.text forKey:@"question_4"];
    [params setObject:_edComment.text forKey:@"open_comment"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        //Deal with error
    } else {
        NSString *requestJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Request - %@",requestJson);
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rollernw.rollertestingserver2.co.uk/gishan/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_loading setHidden:NO];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_loading setHidden:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback sent successfully!"
                                                    message:@"Thank you!\nEnjoy Rise of Civilisations"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
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
