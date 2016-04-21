//
//  ViewController.h
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTaskVC.h"
#import "DetailTaskVC.h"


@interface ViewController : UIViewController <AddTaskVCDelegate, UITableViewDataSource, UITableViewDelegate, DetailTaskVCDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *taskObjects;

- (IBAction)reorderBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addBarButtonPressed:(UIBarButtonItem *)sender;


@end

