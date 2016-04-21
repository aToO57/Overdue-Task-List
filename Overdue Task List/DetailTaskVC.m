//
//  DetailTaskVC.m
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import "DetailTaskVC.h"

@interface DetailTaskVC ()

@end

@implementation DetailTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self displayData:self.task];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[UIBarButtonItem class]] && [segue.destinationViewController isKindOfClass:[EditTaskVC class]])
    {
        EditTaskVC *editTaskVC = segue.destinationViewController;
        editTaskVC.task = self.task;
        editTaskVC.delegate = self;
    }
    
}
#pragma mark - Helper methode
-(void)displayData:(Task *) task
{
    //Conversion de la NSDate en string au format JJ-MM-AAAA
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    NSString *formatedDate = [formatter stringFromDate:task.date];
    
    self.nameLabel.text = task.title;
    self.dateLabel.text = formatedDate;
    self.detailLabel.text = task.detail;
    [self.isCompletButton setTitle:[NSString stringWithFormat:@"%@", task.completion ? @"YES" : @"NO"] forState:UIControlStateNormal];
}

#pragma mark - EditTaskVC Delegate

-(void)saveEditTask
{
    [self displayData:self.task];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate saveEditTaskFromDetailTaskVC];
}

#pragma mark - IBAction

- (IBAction)isCompletButtonPressed:(UIButton *)sender {
    [self.isCompletButton setTitle:[NSString stringWithFormat:@"%@", !self.task.completion ? @"YES" : @"NO"] forState:UIControlStateNormal];
    self.task.completion = !self.task.completion;
    [self.delegate saveEditTaskFromDetailTaskVC];
}

- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toEditTaskVC" sender:sender];
}
@end
