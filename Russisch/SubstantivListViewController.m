//
//  SubstantivListViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 21.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "SubstantivListViewController.h"
#import "SubstantivCell.h"
#import "Substantiv.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SubstantivListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

{
    UISearchBar *mySearchBar;
    __weak IBOutlet UICollectionView *myCollectionView;
    
}
@property (strong, nonatomic) NSArray *substantivArray;

@end

@implementation SubstantivListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    mySearchBar.delegate = self;
    [self.view addSubview:mySearchBar];
    
    if (!_substantivArray) {
        _substantivArray = [Substantiv substantive];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@ (%i)", @"Substantive", _substantivArray.count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubstantivCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Substantiv *substantiv = _substantivArray[indexPath.row];
    
    cell.labelRussian.text = substantiv.declination[kNominative];
    cell.labelDeutsch.text = substantiv.nominativDeutsch;
    cell.labelGenetiv.text = substantiv.declination[kGenetive];
    cell.labelDativ.text = substantiv.declination[kDative];
    cell.labelAkkusativ.text = substantiv.declination[kAccusative];
    cell.labelInstrumental.text = substantiv.declination[kInstrumental];
    cell.labelPraepositiv.text = substantiv.declination[kPrepositional];
    cell.labelPluralNominativ.text = substantiv.declination[kNominativePlural];
    
    if (([substantiv.genus isEqualToString:@"w"] && [substantiv.belebt isEqualToString:@"b"]))
    {
        cell.backgroundColor = UIColorFromRGB(0xFFD2ED);
    }
    if (([substantiv.genus isEqualToString:@"w"] && ([substantiv.belebt isEqualToString:@"u"] || [substantiv.belebt isEqualToString:@"ui"] || [substantiv.belebt isEqualToString:@"a"] )))
    {
        cell.backgroundColor = UIColorFromRGB(0xFFE7F5);
    }
    if (([substantiv.genus isEqualToString:@"m"] && [substantiv.belebt isEqualToString:@"b"]))
    {
        cell.backgroundColor = UIColorFromRGB(0xD7E4FF);
    }
    if (([substantiv.genus isEqualToString:@"m"] && ([substantiv.belebt isEqualToString:@"u"] || [substantiv.belebt isEqualToString:@"ui"] || [substantiv.belebt isEqualToString:@"a"])))
    {
        cell.backgroundColor = UIColorFromRGB(0xE9F0FF);
    }
    if ([substantiv.genus isEqualToString:@"s"])
    {
        cell.backgroundColor = UIColorFromRGB(0xFFF0D2);
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@ (%i)", @"Substantive", _substantivArray.count];
    return _substantivArray.count;
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
        _substantivArray = [Substantiv substantive];
    }
    else
    {
        _substantivArray = [Substantiv substantiveFiltered:searchText];
    }
    
    [myCollectionView performBatchUpdates:^{
        [myCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [myCollectionView reloadData];
    } completion:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    _substantivArray = [Substantiv substantive];
    [myCollectionView performBatchUpdates:^{
        [myCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [myCollectionView reloadData];
    } completion:nil];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
