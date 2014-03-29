//
//  VerbViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 19.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "VerbTestViewController.h"
#import "Verb.h"

@interface VerbTestViewController ()

{
    __weak IBOutlet UITextView *personText;
    
    __weak IBOutlet UITextView *nennformText;
    __weak IBOutlet UITextView *verbText;
    __weak IBOutlet UITextField *verbTextEntered;
    
    Verb *meinVerb;
    BOOL showGerman;
}

@property (strong, nonatomic) NSArray *verbArray;

@end

@implementation VerbTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundYellow.png"]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_verbArray) {
        _verbArray = [Verb verben];
    }
    UIFont *mainTitleFont = [UIFont boldSystemFontOfSize:18.0];
    UIFont *subTitleFont = [UIFont systemFontOfSize:14.0];
    UIFont *textFont = [UIFont italicSystemFontOfSize:12.0];
    
 //
    showGerman = NO;
    [self nextVerb];
}

- (void)showNennform
{
    if (showGerman)
    {
        nennformText.text = meinVerb.nennformDeutsch;
    }
    else
    {
        nennformText.text = meinVerb.nennformRussisch;
    }
}

-(void)nextVerb
{
    NSUInteger i = arc4random_uniform(_verbArray.count);
    NSUInteger p = arc4random_uniform(6) + 1;
    
    meinVerb = _verbArray[i];
    switch (p) {
        case 1:
            personText.text = @"я";
            verbText.text = meinVerb.p1eRussisch;
            break;
        case 2:
            personText.text = @"Ты";
            verbText.text = meinVerb.p2eRussisch;
            break;
        case 3:
            personText.text = @"Он / Она";
            verbText.text = meinVerb.p3eRussisch;
            break;
        case 4:
            personText.text = @"мы";
            verbText.text = meinVerb.p1mRussisch;
            break;
        case 5:
            personText.text = @"Вы";
            verbText.text = meinVerb.p2mRussisch;
            break;
        case 6:
            personText.text = @"Они";
            verbText.text = meinVerb.p3mRussisch;
            break;
        default:
            break;
    }
    [self showNennform];
    verbText.hidden = YES;
    verbTextEntered.text = @"";
    verbTextEntered.textColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCheckPressed:(id)sender {
    verbText.hidden = NO;
    
    if ([verbText.text isEqualToString:verbTextEntered.text])
    {
        verbTextEntered.textColor = [UIColor greenColor];
    }
    else
    {
        verbTextEntered.textColor = [UIColor redColor];
    }
}

- (IBAction)onNextPressed:(id)sender {
    [self nextVerb];
}

- (IBAction)onLanguagePressed:(id)sender {
    if (showGerman)
    {
        showGerman = NO;
    }
    else
    {
        showGerman = YES;
    }
    [self showNennform];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
