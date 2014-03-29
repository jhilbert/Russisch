//
//  PräpositivViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 19.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "SubstantivTestViewController.h"
#import "Substantiv.h"


@interface SubstantivTestViewController ()

{
    
    __weak IBOutlet UITextField *fallTextField;
    __weak IBOutlet UITextView *nominativDeutschView;
    __weak IBOutlet UITextView *nominativRussischText;
    __weak IBOutlet UITextView *praepositivRussischText;
    
    __weak IBOutlet UITextField *praepositivRussischTextEntered;
    Substantiv *meinSubstantiv;
    BOOL showGerman;
}

@property (strong, nonatomic) NSArray *substantivArray;
@property (strong, nonatomic) NSString *solutionWord;

@end

@implementation SubstantivTestViewController

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
    if (!_substantivArray) {
        _substantivArray = [Substantiv substantive];
    }
    [self nextSubstantiv];
    
}
- (IBAction)onCheckPressed:(id)sender {
    praepositivRussischText.hidden = NO;
    if ([_solutionWord isEqualToString:praepositivRussischTextEntered.text])
    {
        praepositivRussischTextEntered.textColor = [UIColor greenColor];
    }
    else
    {
        praepositivRussischTextEntered.textColor = [UIColor redColor];
    }
}

- (IBAction)onNextPressed:(id)sender {
    [self nextSubstantiv];
}

-(void)nextSubstantiv
{
    meinSubstantiv = nil;
    while (!(meinSubstantiv))
    {
        NSUInteger i = arc4random_uniform(_substantivArray.count);
        meinSubstantiv = _substantivArray[i];
        if ([_modus isEqualToString:@"PluralExceptions"] && (meinSubstantiv.pluralException == NO))
        {
            meinSubstantiv = nil;
        }
    }
    praepositivRussischTextEntered.text = @"";
    praepositivRussischTextEntered.textColor = [UIColor blackColor];
    praepositivRussischText.hidden = YES;
    [self showWord];
    
    NSUInteger nounCase;
    if ([_modus isEqualToString:@"PluralExceptions"])
    {
        nounCase = 4;
    }
    else
    {
        nounCase = arc4random_uniform(4) + 1; 
    }
   
    switch (nounCase)
    {
        case 1:
            fallTextField.text = @"Genetiv";
            _solutionWord = meinSubstantiv.declination[kGenetive];
            break;
        case 2:
            fallTextField.text = @"Akkusativ";
            _solutionWord = meinSubstantiv.declination[kAccusative];
            break;
        case 3:
            fallTextField.text = @"Präpositiv";
            _solutionWord = meinSubstantiv.declination[kPrepositional];
            break;
        case 4:
            fallTextField.text = @"Plural Nom.";
            _solutionWord = meinSubstantiv.declination[kNominativePlural];
            break;
    }
    praepositivRussischText.text = _solutionWord;
    
}

- (void)showWord
{
    if (showGerman)
    {
        nominativRussischText.text = meinSubstantiv.nominativDeutsch;
    }
    else
    {
        nominativRussischText.text = meinSubstantiv.nominativRussisch;
    }
}

- (IBAction)onLanguagePressed:(id)sender
{
    if (showGerman)
    {
        showGerman = NO;
    }
    else
    {
        showGerman = YES;
    }
    [self showWord];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
