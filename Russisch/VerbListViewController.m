//
//  VerbListViewController.m
//  Russisch
//
//  Created by Josef Hilbert on 19.03.14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "VerbListViewController.h"
#import "VerbCell.h"
#import "Verb.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface VerbListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

{
    UISearchBar *mySearchBar;
    __weak IBOutlet UICollectionView *myCollectionView;
}

@property (strong, nonatomic) NSArray *verbArray;

@end

@implementation VerbListViewController

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
    self.navigationItem.title = @"Verben";
    
    if (!_verbArray) {
        _verbArray = [Verb verben];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VerbCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Verb *verb = _verbArray[indexPath.row];
    
    cell.labelRussian.text = verb.nennformRussisch;
    cell.labelDeutsch.text = verb.nennformDeutsch;
    cell.labelP1E.text = verb.p1eRussisch;
    cell.labelP2E.text = verb.p2eRussisch;
    cell.labelP3E.text = verb.p3eRussisch;
    cell.labelP1M.text = verb.p1mRussisch;
    cell.labelP2M.text = verb.p2mRussisch;
    cell.labelP3M.text = verb.p3mRussisch;
    
    if ([verb.deklination isEqualToString:@"х"])
    {
        cell.backgroundColor = UIColorFromRGB(0xFFB173);
    }
    if ([verb.deklination isEqualToString:@"иу"])
    {
        cell.backgroundColor = UIColorFromRGB(0xFFC900);
    }
    if ([verb.deklination isEqualToString:@"ил"] || [verb.deklination isEqualToString:@"иж"] || [verb.deklination isEqualToString:@"иш"] )
    {
        cell.backgroundColor = UIColorFromRGB(0xA68200);
    }
    if ([verb.deklination isEqualToString:@"и"])
    {
        cell.backgroundColor = UIColorFromRGB(0xFFE173);
    }
    if ([verb.deklination isEqualToString:@"еш"] || [verb.deklination isEqualToString:@"еова"] || [verb.deklination isEqualToString:@"еева"])
    {
        cell.backgroundColor = UIColorFromRGB(0x009B95);
    }
    if ([verb.deklination isEqualToString:@"е"])
    {
        cell.backgroundColor = UIColorFromRGB(0x5CCDC9);
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _verbArray.count;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
        _verbArray = [Verb verben];
    }
    else
    {
        _verbArray = [Verb verbsFiltered:searchText];
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
    _verbArray = [Verb verben];
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
