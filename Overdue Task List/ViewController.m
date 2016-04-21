//
//  ViewController.m
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lazy Instantiation of Propreties
-(NSMutableArray *)taskObjects
{
    if (!_taskObjects){
        _taskObjects = [[NSMutableArray alloc] init];
    }
    return _taskObjects;
}

-(NSMutableArray *)overdue
{
    if (!_overdue){
        _overdue = [[NSMutableArray alloc] init];
    }
    return _overdue;
}
-(NSMutableArray *)uncompleted
{
    if (!_uncompleted){
        _uncompleted = [[NSMutableArray alloc] init];
    }
    return _uncompleted;
}
-(NSMutableArray *)completed
{
    if (!_completed){
        _completed = [[NSMutableArray alloc] init];
    }
    return _completed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
    NSArray *tasklist = [[NSUserDefaults standardUserDefaults] arrayForKey:TASK_LIST_OBJECT_KEY];
    
    for (NSDictionary *dictionary in tasklist)
    {
        Task *task = [self taskObjectFromDictionary:dictionary];
        
        [[self arraySelection:task forIndexPath:nil] addObject:task];
        
//       [self.taskObjects addObject:task];
    }
   // self.taskObjects = [@[self.overdue, self.uncompleted, self.completed] mutableCopy];
    NSLog(@"%@", self.taskObjects);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[UIBarButtonItem class]] && [segue.destinationViewController isKindOfClass:[AddTaskVC class]]){
        AddTaskVC *addTaskVC = segue.destinationViewController;
        addTaskVC.delegate = self;
    }
    if([sender isKindOfClass:[NSIndexPath class]] && [segue.destinationViewController isKindOfClass:[DetailTaskVC class]]){
        DetailTaskVC *detailTaskVC = segue.destinationViewController;
        detailTaskVC.delegate = self;
        NSIndexPath *indexPath = sender;
        detailTaskVC.indexPath = indexPath;
        detailTaskVC.task = [self arraySelection:nil forIndexPath:indexPath][indexPath.row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methode
-(NSDictionary *)taskObjectAsAPropertyList:(Task *)taskObject
{
    NSDictionary *dictionary = @{TASK_TITLE : taskObject.title, TASK_DETAIL : taskObject.detail, TASK_DATE : taskObject.date, TASK_COMPLETION : @(taskObject.completion)};
    
    return dictionary;
}

-(Task *)taskObjectFromDictionary:(NSDictionary *)dictionary
{
    return [[Task alloc] initWithData:dictionary];
}

-(BOOL *)isDateGreaterThanDate:(NSDate *)date and:(NSDate *)toDate
{
    int firstdate = [date timeIntervalSince1970];
    int seconddate = [toDate timeIntervalSince1970];
    
    if(firstdate > seconddate){
        return YES;
    }else{
        return NO;
    }
}

-(void)updateCompletionOfTask:(Task *)task forIndexPath:(NSIndexPath *)indexPath
{
    

    [[self arraySelection:task forIndexPath:nil] removeObjectAtIndex:indexPath.row];
    task.completion = !task.completion;
    
    [[self arraySelection:task forIndexPath:nil]  addObject:task];
    [self saveData];
    
}

-(void)saveData
{
    
    NSMutableArray *taskObjectFromSave = [[NSMutableArray alloc] init];
    
    for (Task *task in self.overdue){
        [taskObjectFromSave addObject:[self taskObjectAsAPropertyList:task]];
    }
    for (Task *task in self.uncompleted){
        [taskObjectFromSave addObject:[self taskObjectAsAPropertyList:task]];

    }
    for (Task *task in self.completed){
        [taskObjectFromSave addObject:[self taskObjectAsAPropertyList:task]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectFromSave forKey:TASK_LIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}
    
-(NSMutableArray *)arraySelection:(Task *)task forIndexPath:(NSIndexPath *) indexPath;
{
    if(task.completion == YES || indexPath.section == 2)return self.completed;
    else if ([self isDateGreaterThanDate:task.date and:[NSDate date]] || indexPath.section ==  1)return self.uncompleted;
    else return self.overdue;
}


#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return [self.overdue count];
    else if (section == 1) return [self.uncompleted count];
    else return [self.completed count];
    
    //return [self.taskObjects count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Overdue Task";
            break;
        case 1:
            return @"Uncompleted Task";
            break;
        case 2:
            return @"Completed Task";
            break;
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    Task *task = self.taskObjects[indexPath.row];
    
    Task *task = [self arraySelection:nil forIndexPath:indexPath][indexPath.row];
    
    //Conversion de la NSDate en string au format JJ-MM-AAAA
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    NSString *formatedDate = [formatter stringFromDate:task.date];
    
    
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = formatedDate;
    if (task.completion) {
        cell.backgroundColor = [UIColor greenColor];

    }
    else if([self isDateGreaterThanDate:task.date and:[NSDate date]]){
        cell.backgroundColor = [UIColor yellowColor];
    }
    else{
        cell.backgroundColor = [UIColor redColor];

    }

    return cell;
}

#pragma mark - TableView Delegate
//Action quand clic(central) sur une cellule
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self updateCompletionOfTask:[self arraySelection:nil forIndexPath:indexPath][indexPath.row] forIndexPath:indexPath];
}

//Autorisation de suppresion de la ligne
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//Action quand clic sur delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    [[self arraySelection:nil forIndexPath:indexPath] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self saveData];

    }
}

//Action quand clic sur accesory
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskVC" sender:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.editing;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(sourceIndexPath.section == destinationIndexPath.section){
        Task *taskObject = [self arraySelection:nil forIndexPath:sourceIndexPath][sourceIndexPath.row];
    
        [[self arraySelection:nil forIndexPath:sourceIndexPath] removeObjectAtIndex:sourceIndexPath.row];
    
        [[self arraySelection:nil forIndexPath:sourceIndexPath] insertObject:taskObject atIndex:destinationIndexPath.row];
    
        [self saveData];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Deplacement impossible entre differante section" delegate:nil cancelButtonTitle:@"Oki" otherButtonTitles:nil];
        [alert show];
        [self.tableView reloadData];
    }
}


#pragma mark - addTaskVC Delegate
-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)didAddTask:(Task *)task
{
    
    [[self arraySelection:task forIndexPath:nil] addObject:task];
    
    [self saveData];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DetailTaskVC Delegate

-(void)saveEditTaskFromDetailTaskVC
{
    NSMutableArray *overdueTmp = self.overdue;
    NSMutableArray *uncompleted = self.uncompleted;
    NSMutableArray *completed = self.completed;
    
    self.overdue = nil,
    self.uncompleted = nil;
    self.completed = nil;
    
    for (Task *task in overdueTmp){
        [[self arraySelection:task forIndexPath:nil] addObject:task];
    }
    for (Task *task in uncompleted){
        [[self arraySelection:task forIndexPath:nil] addObject:task];
    }
    for (Task *task in completed){
        [[self arraySelection:task forIndexPath:nil] addObject:task];
    }
    
    
     [self saveData];
}

#pragma mark - IBAction

- (IBAction)reorderBarButtonPressed:(UIBarButtonItem *)sender
{
    if (self.tableView.editing == YES)[self.tableView setEditing:NO animated:YES];
    else [self.tableView setEditing:YES animated:YES];
}


- (IBAction)addBarButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toAddTaskVC" sender:sender];
}

- (IBAction)reset:(UIBarButtonItem *)sender {
//    self.overdue = nil;
//    self.completed = nil;
//    self.uncompleted = nil;
    [self.tableView reloadData];
}
@end
