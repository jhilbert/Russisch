//
//  ChallengeViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 29.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "ChallengeViewController.h"
#import "JDFlipNumberView.h"
#import "Substantiv.h"
#import "CSAnimationView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString * const weichesA = @"я";
static NSString * const hartesA = @"а";
static NSString * const weichesE = @"е";
static NSString * const hartesE = @"э";
static NSString * const weichesI = @"и";
static NSString * const hartesI = @"ы";
static NSString * const weichesO = @"ё";
static NSString * const hartesO = @"о";
static NSString * const weichesU = @"ю";
static NSString * const hartesU = @"у";

@interface ChallengeViewController ()

{
    __weak IBOutlet UIImageView *smileyImage;
    __weak IBOutlet UILabel *resultLabel;
    __weak IBOutlet UITextView *challengeText;
    __weak IBOutlet UIButton *button1;
    __weak IBOutlet UIButton *button2;
    __weak IBOutlet UIButton *button3;
    __weak IBOutlet UIButton *button4;
    __weak IBOutlet UIButton *button5;
    __weak IBOutlet UIButton *button6;
    __weak IBOutlet UIButton *startButton;
    JDFlipNumberView *flipNumberView;
    NSInteger numberOfRound;
    NSInteger questionsPerRound;
    NSInteger correctAnswers;
    Substantiv *selectedSubstantiv;
    BOOL answerCorrect;
    UIButton* correctButton;
    NSString* rightAnswer;
    NSString *optionForAnswer;
    NSTimer *timer;

}
@end

@implementation ChallengeViewController

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
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundGreen.png"]];
    self.view.backgroundColor = UIColorFromRGB(0xE7E9E7);
    self.view.backgroundColor = UIColorFromRGB(0x514991);
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    CSAnimationView* questionView;
//    questionView = [[CSAnimationView alloc]initWithFrame:CGRectMake((self.view.frame.size.width * sub), 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [detailOverlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.1]];
 
    challengeText.backgroundColor = [UIColor whiteColor];
    challengeText.alpha = 0.8;
    challengeText.layer.cornerRadius = 15.0;
    challengeText.layer.masksToBounds = YES;
    
    questionsPerRound = 5;
    flipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2];
    flipNumberView.value = 0;
    [self.view addSubview: flipNumberView];
    flipNumberView.frame = CGRectMake(10,60,50,50);
    flipNumberView.hidden = YES;
    startButton.hidden = NO;
    smileyImage.hidden = YES;
    challengeText.text = @"Übung: Pluralendungen\n\nStarte das Spiel ...";
    resultLabel.text = @" ";
    button5.hidden = YES;
    button6.hidden = YES;
    
    button1.titleLabel.textColor = [UIColor whiteColor];
    button1.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25.0];
    button2.titleLabel.textColor = [UIColor whiteColor];
    button2.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25.0];
    button3.titleLabel.textColor = [UIColor whiteColor];
    button3.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25.0];
    button4.titleLabel.textColor = [UIColor whiteColor];
    button4.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25.0];
    button5.titleLabel.textColor = [UIColor whiteColor];
    button5.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25.0];
    button6.titleLabel.textColor = [UIColor whiteColor];
    button6.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25.0];
    
    button1.layer.cornerRadius = 10.0;
    button1.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 10.0;
    button2.layer.masksToBounds = YES;
    button3.layer.cornerRadius = 10.0;
    button3.layer.masksToBounds = YES;
    button4.layer.cornerRadius = 10.0;
    button4.layer.masksToBounds = YES;
    button1.backgroundColor = [UIColor blackColor];
    button2.backgroundColor = [UIColor blackColor];
    button3.backgroundColor = [UIColor blackColor];
    button4.backgroundColor = [UIColor blackColor];
    button5.backgroundColor = [UIColor blackColor];
    button6.backgroundColor = [UIColor blackColor];
 
    button1.enabled = NO;
    button2.enabled = NO;
    button3.enabled = NO;
    button4.enabled = NO;
    button5.enabled = NO;
    button6.enabled = NO;
}

-(void)startGame
{
    numberOfRound = 0;
    correctAnswers = 0;
    startButton.hidden = YES;
    [self nextExercise];
}

-(void)nextExercise
{
    smileyImage.hidden = YES;
    if (numberOfRound < questionsPerRound)
    {
        numberOfRound++;
        resultLabel.text = [NSString stringWithFormat:@"%02i/%02i", correctAnswers, numberOfRound];
        NSUInteger i;
        selectedSubstantiv = nil;
        while (!(selectedSubstantiv))
        {
            i = arc4random_uniform([Substantiv substantive].count);
            selectedSubstantiv = [Substantiv substantive][i];
            if ([selectedSubstantiv.belebt isEqualToString:kIndeclinable])
            {
                selectedSubstantiv = nil;
            }
        }
      
        rightAnswer = selectedSubstantiv.declinationSuffix[kNominativePlural];
        challengeText.text = [NSString stringWithFormat:@"Welche Pluralendung hat ...\n\n%@",selectedSubstantiv.nominativRussisch];
        button5.hidden = YES;
        button6.hidden = YES;

        optionForAnswer = [@"-" stringByAppendingString:hartesI];
        [self isThisButtonRight:button1];
        optionForAnswer = [@"-" stringByAppendingString:weichesI];
        [self isThisButtonRight:button2];
        optionForAnswer = [@"-" stringByAppendingString:hartesA];
        [self isThisButtonRight:button3];
        optionForAnswer = [@"-" stringByAppendingString:weichesA];
        [self isThisButtonRight:button4];
        
        button1.enabled = YES;
        button2.enabled = YES;
        button3.enabled = YES;
        button4.enabled = YES;
 
        [button1 setBackgroundColor:[UIColor blackColor]];
        [button2 setBackgroundColor:[UIColor blackColor]];
        [button3 setBackgroundColor:[UIColor blackColor]];
        [button4 setBackgroundColor:[UIColor blackColor]];
        [button5 setBackgroundColor:[UIColor blackColor]];
        [button6 setBackgroundColor:[UIColor blackColor]];
        
        answerCorrect = NO;
        [self setTimer];
    }
    else
    {
        startButton.hidden = NO;
    }
}

-(void)isThisButtonRight:(UIButton*)button
{
    [button setTitle:optionForAnswer forState:UIControlStateNormal];
    if ([optionForAnswer isEqualToString:rightAnswer])
    {
        correctButton = button;
    }
}

-(void)setTimer
{
    flipNumberView.hidden = NO;
    flipNumberView.value = 10;
    [flipNumberView animateToValue:0 duration:10.0 completion:^(BOOL finished) {
        
        smileyImage.image = [UIImage imageNamed:@"Smiley2"];
        [self endRound];
        
    }];
}

-(void)endRound
{
    smileyImage.hidden = NO;
    resultLabel.text = [NSString stringWithFormat:@"%02i/%02i", correctAnswers, numberOfRound];
    button1.enabled = NO;
    button2.enabled = NO;
    button3.enabled = NO;
    button4.enabled = NO;
    button5.enabled = NO;
    button6.enabled = NO;
    [correctButton setBackgroundColor:UIColorFromRGB(0x00B900)];
    flipNumberView.hidden = YES;
    
    [self performSelector:@selector(nextExercise) withObject:nil afterDelay:3.0];
 //   timer = [NSTimer scheduledTimerWithTimeInterval:3.0
 //                                    target:self
 //                                  selector:@selector(nextExercise)
 //                                  userInfo:nil
 //                                   repeats:NO];

}

- (IBAction)onStartPressed:(id)sender {
    [self startGame];
}

- (void)buttonPressed:(UIButton *)sender {
    [flipNumberView stopAnimation];
    if ([sender.titleLabel.text isEqualToString:selectedSubstantiv.declinationSuffix[kNominativePlural]]){
        answerCorrect = YES;
        correctAnswers++;
        smileyImage.image = [UIImage imageNamed:@"Smiley"];
        [sender setBackgroundColor:UIColorFromRGB(0x00B900)];
    }
    else
    {
        smileyImage.image = [UIImage imageNamed:@"Smiley2"];
        [sender setBackgroundColor:UIColorFromRGB(0xE70000)];
    }
    [self endRound];

}

- (IBAction)onButton1Pressed:(UIButton*)sender {
    [self buttonPressed:sender];
}

- (IBAction)onButton2Pressed:(UIButton*)sender {
    [self buttonPressed:sender];
}
- (IBAction)onButton3Pressed:(UIButton*)sender {
    [self buttonPressed:sender];
}
- (IBAction)onButton4Pressed:(UIButton*)sender {
    [self buttonPressed:sender];
}
- (IBAction)onButton5Pressed:(UIButton*)sender {
    [self buttonPressed:sender];
}
- (IBAction)onButton6Pressed:(UIButton*)sender {
    [self buttonPressed:sender];
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
