//
//  RulesViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 27.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "RulesViewController.h"
#import "Substantiv.h"

@interface RulesViewController ()
{
    __weak IBOutlet UITextView *baseTextView;
    
    __weak IBOutlet UITextView *destinationTextView;
    __weak IBOutlet NSLayoutConstraint *heightBase;
    __weak IBOutlet NSLayoutConstraint *destinationHeight;
    __weak IBOutlet UITextView *appendixTextView;
    __weak IBOutlet NSLayoutConstraint *appendixHeight;
  
    UIFont *font;
    NSDictionary *attrsDictionary;
    __weak IBOutlet UISegmentedControl *segmentedControl;
  
    NSArray *wordSelection;
    NSArray *cases;
    NSInteger deklinationCase;

    NSMutableDictionary *compiledString;
    NSMutableDictionary *compiledAppendix;
    
}

@end

@implementation RulesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupExamples
{
 
    switch (deklinationCase) {
        case  0:
            wordSelection = @[@"театр", @"музей", @"окно", @"море", @"мама", @"тётя"];
            break;
        case  1:
            wordSelection = @[@"театр", @"музей", @"окно", @"море", @"мама", @"тётя"];
            break;
        case  2:
            wordSelection = @[@"театр", @"музей", @"студент", @"преподаватель", @"окно", @"море", @"мама", @"тётя"];
            break;
        case  3:
            wordSelection = @[@"театр", @"музей", @"окно", @"море", @"мама", @"тётя"];
            break;
        case  4:
            wordSelection = @[@"театр", @"музей", @"окно", @"море", @"мама", @"тётя", @"санаторий", @"здание", @"площадь", @"лекция", @"пол", @"лес"];
            break;
        case  5:
            wordSelection = @[@"театр", @"музей", @"окно", @"море", @"мама", @"тётя", @"парк", @"нож", @"преподаватель", @"лекция"];
            break;
        default:
            wordSelection = @[@"театр", @"музей", @"студент", @"преподаватель", @"окно", @"море", @"мама", @"тётя", @"санаторий", @"здание", @"площадь", @"лекция"];
            
            break;
    }
    
 //   cases = @[kNominative, kGenetive, kDative, kAccusative, kInstrumental, kPrepositional, kNominativePlural, kGenetivePlural, kDativePlural, kAccusativePlural, kInstrumentalPlural, kPrepositionalPlural];
    cases = @[kNominative, kGenetive, kDative, kAccusative, kInstrumental, kPrepositional, kNominativePlural];
    
    compiledString = [NSMutableDictionary new];
    compiledAppendix = [NSMutableDictionary new];
    
    for (NSString *caseToBuild in cases)
    {
        compiledString[caseToBuild] = [[NSMutableAttributedString alloc] init];
        compiledAppendix[caseToBuild] = [[NSMutableAttributedString alloc] init];
    }
    
    for (NSString *string in wordSelection)
    {
        Substantiv *substantiv = [Substantiv substantivDictionary][string];

        for (NSString *caseToBuild in cases)
        {
            [self appendAttributedString:substantiv.declinationAttributed[caseToBuild] toAttributedString:compiledString[caseToBuild]];
            [self appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"-%@", [substantiv.declination[caseToBuild] substringFromIndex:((NSString*)substantiv.declination[caseToBuild]).length -1]] attributes:attrsDictionary] toAttributedString:compiledAppendix[caseToBuild]];
        }
        
     }
    
    baseTextView.attributedText = compiledString[kNominative];
    destinationTextView.attributedText = compiledString[kGenetive];
    appendixTextView.attributedText = compiledAppendix[kGenetive];
    
    CGSize sizeThatShouldFitTheContent = [baseTextView sizeThatFits:baseTextView.frame.size];
    heightBase.constant = sizeThatShouldFitTheContent.height;
    
    sizeThatShouldFitTheContent = [destinationTextView sizeThatFits:destinationTextView.frame.size];
    destinationHeight.constant = sizeThatShouldFitTheContent.height;
    
    sizeThatShouldFitTheContent = [appendixTextView sizeThatFits:appendixTextView.frame.size];
    appendixHeight.constant = sizeThatShouldFitTheContent.height;
    
    switch (deklinationCase) {
        case  0:
            destinationTextView.attributedText = compiledString[kGenetive];
            appendixTextView.attributedText = compiledAppendix[kGenetive];
            self.navigationItem.title = @"Genetiv";
            break;
        case  1:
            destinationTextView.attributedText = compiledString[kDative];
            appendixTextView.attributedText = compiledAppendix[kDative];
            self.navigationItem.title = @"Dativ";
            break;
        case  2:
            destinationTextView.attributedText = compiledString[kAccusative];
            appendixTextView.attributedText = compiledAppendix[kAccusative];
            self.navigationItem.title = @"Akkusativ";
            break;
        case  3:
            destinationTextView.attributedText = compiledString[kInstrumental];
            appendixTextView.attributedText = compiledAppendix[kInstrumental];
            self.navigationItem.title = @"Instrumental";
            break;
        case  4:
            destinationTextView.attributedText = compiledString[kPrepositional];
            appendixTextView.attributedText = compiledAppendix[kPrepositional];
            self.navigationItem.title = @"Präpositiv";
            break;
        case  5:
            destinationTextView.attributedText = compiledString[kNominativePlural];
            appendixTextView.attributedText = compiledAppendix[kNominativePlural];
            self.navigationItem.title = @"Plural";
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [segmentedControl addTarget:self
	                     action:@selector(pickOne:)
	           forControlEvents:UIControlEventValueChanged];
    
    font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:16.0];
    //    font = [UIFont fontWithName:@"Courier" size:20.0];
    attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                  forKey:NSFontAttributeName];
    deklinationCase = 0;
    [self setupExamples];

    // Do any additional setup after loading the view.
}

-(NSMutableAttributedString*)appendAttributedString:(NSMutableAttributedString*)attributedString toAttributedString:(NSMutableAttributedString*)toAttributedString
{
    NSAttributedString *linebreak = [[NSAttributedString alloc] initWithString:@"\n"];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    [paragraph setLineSpacing:5];
    
    NSMutableAttributedString *tempString = attributedString;
    [tempString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [tempString length])];
    [toAttributedString appendAttributedString:tempString];
    [toAttributedString appendAttributedString:linebreak];
    return toAttributedString;
}

- (void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    deklinationCase = [segmentedControl selectedSegmentIndex];
    [self setupExamples];
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
