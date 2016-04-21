//
//  EditTaskVC.m
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import "EditTaskVC.h"

@interface EditTaskVC ()

@end

@implementation EditTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.delegate = self;
    self.textView.delegate = self;
    
    self.textField.text = self.task.title;
    self.textView.text = self.task.detail;
    self.datePicker.date = self.task.date;
    [self.isCompletButton setTitle:[NSString stringWithFormat:@"%@", self.task.completion ? @"YES" : @"NO"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */
#pragma mark - UITextView Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - Helper Methode
-(void)updateTask
{
    self.task.title = self.textField.text;
    self.task.detail = self.textView.text;
    self.task.date = self.datePicker.date;
}

#pragma mark - IBAction

- (IBAction)saveBarButtonPressed:(UIBarButtonItem *)sender {
    [self updateTask];
    [self.delegate saveEditTask];
}

- (IBAction)isCompletButtonPressed:(UIButton *)sender {
    [self.isCompletButton setTitle:[NSString stringWithFormat:@"%@", !self.task.completion ? @"YES" : @"NO"] forState:UIControlStateNormal];
    self.task.completion = !self.task.completion;
}
@end
