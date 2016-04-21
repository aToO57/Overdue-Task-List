//
//  DetailTaskVC.h
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "EditTaskVC.h"

@protocol DetailTaskVCDelegate <NSObject>

@required
-(void)saveEditTaskFromDetailTaskVC;

@end

@interface DetailTaskVC : UIViewController <EditTaskVCDelegate>

@property (weak, nonatomic) id <DetailTaskVCDelegate> delegate;
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIButton *isCompletButton;

- (IBAction)isCompletButtonPressed:(UIButton *)sender;
- (IBAction)editBarButtonPressed:(UIBarButtonItem *)sender;

@end
