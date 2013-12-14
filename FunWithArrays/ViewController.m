//
//  ViewController.m
//  FunWithArrays
//
//  Created by Basar Akyelli on 12/13/13.
//  Copyright (c) 2013 Basar Akyelli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tbArraySize;
@property (weak, nonatomic) IBOutlet UILabel *lblSol01;
@property (weak, nonatomic) IBOutlet UILabel *lblSol02;
@property (weak, nonatomic) IBOutlet UILabel *lblSol03;
- (IBAction)solveBtnPressed:(id)sender;

@end

@implementation ViewController

- (IBAction)solveBtnPressed:(id)sender {
    
    [self.tbArraySize resignFirstResponder];
    NSInteger arraySize = [self.tbArraySize.text integerValue];
    
    NSMutableArray *array = [NSMutableArray new];
    
    for(int i=0; i<arraySize; i++)
    {
        NSInteger randomNumber = arc4random_uniform(10000);
        [array addObject:[NSNumber numberWithInteger:randomNumber]];
    }
    
    NSInteger targetNumber = arc4random_uniform(10000);
    
    NSDate *start = [NSDate date];
    [self solveUsingMethod01:array targetNumber:targetNumber];
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    self.lblSol01.text = [NSString stringWithFormat:@"%f seconds", -timeInterval];
    
    NSMutableArray *arrayToSort = [[NSArray arrayWithArray:array] mutableCopy];

    start = [NSDate date];
    [self solveUsingMethod02:arrayToSort targetNumber:targetNumber];
    timeInterval = [start timeIntervalSinceNow];
    self.lblSol02.text = [NSString stringWithFormat:@"%f seconds", -timeInterval];
    
    start = [NSDate date];
    [self solveUsingMethod03:array targetNumber:targetNumber];
    timeInterval = [start timeIntervalSinceNow];
    self.lblSol03.text = [NSString stringWithFormat:@"%f seconds", -timeInterval];

}


///Create a hash table of each item first, then use the hash table to find the seeked number O(n)
-(BOOL) solveUsingMethod03:(NSMutableArray *)array targetNumber:(NSInteger)targetNumber
{
    NSMutableDictionary *hashTable = [NSMutableDictionary new];
    
    NSNumber *item;
    NSNumber *firstItem;
    NSNumber *lookingFor;
    
    for(int i=0; i<[array count]; i++)
    {
        item = array[i];
        [hashTable setObject:@"" forKey:item];
    }
    
    for(int i=0; i<[array count]; i++)
    {
        firstItem = array[i];
        if([firstItem integerValue] < targetNumber)
        {
            lookingFor = [NSNumber numberWithInteger:targetNumber-[firstItem integerValue]];
            
            if([hashTable objectForKey:(lookingFor)] != nil)
            {
                return YES;
            }
        }
    }
    return NO;
}


/// Find answer by first sorting the array, then doing a binary search for the seeked number O(nlogn)
-(BOOL) solveUsingMethod02:(NSMutableArray *)array targetNumber:(NSInteger)targetNumber
{
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [array sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
    
    NSNumber *firstItem;
    NSNumber *lookingFor;
    NSRange searchRange;
    NSUInteger findIndex;
    
    for(int i=0; i<[array count]; i++)
    {
        firstItem = array[i];
        if([firstItem integerValue] < targetNumber)
        {
            lookingFor = [NSNumber numberWithInteger:targetNumber-[firstItem integerValue]];
            
            searchRange = NSMakeRange(0, [array count]);
            findIndex = [array indexOfObject:lookingFor
                                          inSortedRange:searchRange
                                                options:NSBinarySearchingFirstEqual
                                        usingComparator:^(id obj1, id obj2)
                                    {
                                        return [obj1 compare:obj2];
                                    }];
            
            if(findIndex <= [array count]){
                return YES;
            }
        }
    
    }
    return NO;;
}


/// Find answer by iterating every over every item for every item in the array O(n2)
-(BOOL) solveUsingMethod01:(NSMutableArray *)array targetNumber:(NSInteger)targetNumber
{
    NSNumber *firstItem;
    NSNumber *secondItem;
    
    for(int i=0; i<[array count]; i++)
    {
        firstItem = array[i];
        
        for(int j=0; j<[array count]; j++)
        {
            if(i != j)
            {
                secondItem = array[j];
                
                if([firstItem integerValue] + [secondItem integerValue] == targetNumber)
                {
                   return YES;
                }
                
            }
        }
        
        
    }

    return NO;


}
@end
