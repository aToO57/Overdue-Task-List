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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSArray *tasklist = [[NSUserDefaults standardUserDefaults] arrayForKey:TASK_LIST_OBJECT_KEY];
    
    for (NSDictionary *dictionary in tasklist)
    {
        Task *task = [self taskObjectFromDictionary:dictionary];
        [self.taskObjects addObject:task];
    }
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
        detailTaskVC.task = self.taskObjects[indexPath.row];
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
    [self.taskObjects removeObjectAtIndex:indexPath.row];
    task.completion = !task.completion;
    [self.taskObjects insertObject:task atIndex:indexPath.row];
    
    [self saveData];
    
}

-(void)saveData
{
    
    NSMutableArray *taskObjectFromSave = [[NSMutableArray alloc] init];
    
//    for (int x = 0; x < [self.taskObjects count]; x ++){
//        
//        [taskObjectFromSave addObject:[self taskObjectAsAPropertyList:self.taskObjects[x]]];
//        
//    }
    for (Task *task in self.taskObjects){
        [taskObjectFromSave addObject:[self taskObjectAsAPropertyList:task]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectFromSave forKey:TASK_LIST_OBJECT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}
    
    
//    NSMutableArray *taskObjectFromSave = [[[NSUserDefaults standardUserDefaults]arrayForKey:TASK_LIST_OBJECT_KEY] mutableCopy];
//    if(!taskObjectFromSave) taskObjectFromSave = [[NSMutableArray alloc] init];
//    
//    if(task != nil && indexPath == nil){ //Ajout d'object
//        [taskObjectFromSave addObject:[self taskObjectAsAPropertyList:task]];
//    }
//    else if(task != nil && indexPath != nil && !didUpdate){ //Ajout d'un object a un index precis
//        [taskObjectFromSave insertObject:[self taskObjectAsAPropertyList:task] atIndex:indexPath.row];
//    }
//    else if (task != nil && indexPath != nil && didUpdate){ //update d'object
//        [taskObjectFromSave replaceObjectAtIndex:indexPath.row withObject:[self taskObjectAsAPropertyList:task]];
//    }
//    else if(task == nil && indexPath != nil){ // suppresion d'object
//        [taskObjectFromSave removeObjectAtIndex:indexPath.row];
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:taskObjectFromSave forKey:TASK_LIST_OBJECT_KEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];




#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.taskObjects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Task *task = self.taskObjects[indexPath.row];
    
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
    [self updateCompletionOfTask:self.taskObjects[indexPath.row] forIndexPath:indexPath];
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
    [self.taskObjects removeObjectAtIndex:indexPath.row];
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
    Task *taskObject = self.taskObjects[sourceIndexPath.row];
    
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    
    [self.taskObjects insertObject:taskObject atIndex:destinationIndexPath.row];
    
    [self saveData];
    
    
//    
//        //On rajoute l'object select a la position voulu puis on supprime l'origine
//        [self.taskObjects insertObject:self.taskObjects[sourceIndexPath.row] atIndex:destinationIndexPath.row];
//        [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
//    
//    [self saveData:self.taskObjects[sourceIndexPath.row] forIndexPath:destinationIndexPath forupdate:NO];
//    [self saveData:nil forIndexPath:sourceIndexPath forupdate:NO];
    
}

#pragma mark - addTaskVC Delegate
-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(Task *)task
{
    [self.taskObjects addObject:task];
    
    [self saveData];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DetailTaskVC Delegate

-(void)saveEditTaskFromDetailTaskVC
{
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
@end
