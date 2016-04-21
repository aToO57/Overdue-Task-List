//
//  EditTaskVC.h
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol EditTaskVCDelegate <NSObject>

@required
-(void)saveEditTask;

@end

@interface EditTaskVC : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <EditTaskVCDelegate> delegate;
@property (strong, nonatomic) Task *task;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)saveBarButtonPressed:(UIBarButtonItem *)sender;


@end
