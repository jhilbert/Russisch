//
//  ViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 18.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "TestSelectionViewController.h"
#import "ExerciseViewController.h"
#import "SubstantivTestViewController.h"

@interface TestSelectionViewController ()

@end

@implementation TestSelectionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundYellow.png"]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WohinWoWoher"])
    {
        ExerciseViewController *vc = segue.destinationViewController;
        vc.modus = segue.identifier;
    }
    if ([segue.identifier isEqualToString:@"Substantive"] || [segue.identifier isEqualToString:@"PluralExceptions"] )
    {
        SubstantivTestViewController *vc = segue.destinationViewController;
        vc.modus = segue.identifier;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
