//
//  AddTaskVC.m
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import "AddTaskVC.h"

@interface AddTaskVC ()

@end

@implementation AddTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    self.textView.delegate = self;
    // Do any additional setup after loading the view.
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
#pragma mark - Methode Helper

-(Task *)returnNewTask
{
    Task *newTask = [[Task alloc] init];
    newTask.title = self.textField.text;
    newTask.detail = self.textView.text;
    newTask.date = self.datePicker.date;
    newTask.completion = NO;    
    
    return  newTask;
}

#pragma mark - IBAction

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    
    
    [self.delegate didCancel];
}

- (IBAction)addTaskButtonPressed:(UIButton *)sender
{
    [self.delegate didAddTask:[self returnNewTask]];
}
@end
