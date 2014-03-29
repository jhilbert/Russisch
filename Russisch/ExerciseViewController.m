//
//  ExerciseViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 22.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "ExerciseViewController.h"
#import "Verb.h"
#import "Substantiv.h"

static NSString * const praepositionWohin = @"в";
static NSString * const praepositionWo = @"в";
static NSString * const praepositionWoher = @"из";

@interface ExerciseViewController ()

{
    __weak IBOutlet UITextView *wordText;
    __weak IBOutlet UITextView *sentenceText;
    __weak IBOutlet UITextField *enterWordText;
    __weak IBOutlet UITextView *solutionWordText;
    
    BOOL showGerman;
}

@property (strong, nonatomic) NSArray *verbArray;
@property (strong, nonatomic) NSString *sentence;
@property (strong, nonatomic) NSString *wordRussian;
@property (strong, nonatomic) NSString *wordGerman;
@property (strong, nonatomic) NSString *solutionWord;

@end

@implementation ExerciseViewController

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
    showGerman = NO;
    [self nextExercise];
}

-(void)nextExercise
{
    if ([_modus isEqualToString:@"WohinWoWoher"])
    {
        NSUInteger i;
        Substantiv *selectedSubstantiv = nil;
        NSArray *substantivSelection = @[@"театр", @"музей", @"море", @"страна", @"унивеситет", @"балкон", @"ванная", @"гостиная", @"дом", @"квартира", @"комната", @"коридор", @"кухня", @"парк", @"спальня", @"туалет", @"библиотека", @"буфет", @"санаторий", @"площадь", @"здание", @"кино", @"бюро", @"мост", @"лес", @"город", @"улица", @"центр"];
        i = arc4random_uniform(substantivSelection.count);
        selectedSubstantiv = [Substantiv substantive][i];

        _wordRussian = selectedSubstantiv.nominativRussisch;
        _wordGerman = selectedSubstantiv.nominativDeutsch;
  
        NSString *praeposition;
        
        NSArray *verbSelection;
        NSUInteger nounCase = arc4random_uniform(3) + 1;
        switch (nounCase)
        {
            case 1:
                nounCase = 2;
                // gehen, spazieren, eilen
                verbSelection = @[@"идти", @"гулять", @"спешить"];
                _solutionWord = selectedSubstantiv.declination[kGenetive];
                praeposition = praepositionWoher;
                break;
            case 2:
                nounCase = 4;
                // gehen, spazieren, eilen
                verbSelection = @[@"идти", @"гулять", @"спешить"];
                _solutionWord = selectedSubstantiv.declination[kAccusative];
                praeposition = praepositionWohin;
                break;
            case 3:
                nounCase = 6;
                // sich befinden, sein
                verbSelection = @[@"пребывать", @"быть"];
                _solutionWord = selectedSubstantiv.declination[kPrepositional];
                praeposition = praepositionWo;
                break;
        }
        
        NSUInteger p = arc4random_uniform(6) + 1;

        i = arc4random_uniform(verbSelection.count);
        
        Verb *selectedVerb = [Verb verbDictionary][verbSelection[i]];
        NSString *personText;
        NSString *verbText;
        switch (p) {
            case 1:
                personText = @"я";
                verbText = selectedVerb.p1eRussisch;
                break;
            case 2:
                personText = @"Ты";
                verbText = selectedVerb.p2eRussisch;
                break;
            case 3:
                personText = (arc4random_uniform(2) == 0) ? @"Он":@"Она";
                verbText = selectedVerb.p3eRussisch;
                break;
            case 4:
                personText = @"мы";
                verbText = selectedVerb.p1mRussisch;
                break;
            case 5:
                personText = @"Вы";
                verbText = selectedVerb.p2mRussisch;
                break;
            case 6:
                personText = @"Они";
                verbText = selectedVerb.p3mRussisch;
                break;
            default:
                break;
        }
      
        // special case "sein": replace "sein" with "schon" ...
        if ([verbText isEqualToString:@"есть"])
        {
            verbText = @"уже";
        }
        
        _sentence = [NSString stringWithFormat:@"%@ %@ %@", personText, verbText, praeposition];

        
    }
    
    [self showWord];
    sentenceText.text = _sentence;
    solutionWordText.hidden = YES;
    solutionWordText.text = _solutionWord;
    enterWordText.text = @"";
    enterWordText.textColor = [UIColor blackColor];
}


- (void)showWord
{
    if (showGerman)
    {
        wordText.text = _wordGerman;
    }
    else
    {
        wordText.text = _wordRussian;
    }
}

- (IBAction)onSolutionPressed:(id)sender {
    solutionWordText.hidden = NO;
    
    if ([solutionWordText.text isEqualToString:enterWordText.text])
    {
        enterWordText.textColor = [UIColor greenColor];
    }
    else
    {
        enterWordText.textColor = [UIColor redColor];
    }
}

- (IBAction)onNextPressed:(id)sender {
    [self nextExercise];
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
