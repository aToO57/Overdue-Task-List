//
//  Task.m
//  Overdue Task List
//
//  Created by aTo on 20/04/2016.
//  Copyright © 2016 aTo. All rights reserved.
//

#import "Task.h"

@implementation Task

-(id)init
{
    self = [self initWithData:nil];
    return  self;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if(self){
        self.title = data[TASK_TITLE];
        self.detail = data[TASK_DETAIL];
        self.date = data[TASK_DATE];
        self.completion = [data[TASK_COMPLETION] boolValue];
    }

    return self;
}

@end
