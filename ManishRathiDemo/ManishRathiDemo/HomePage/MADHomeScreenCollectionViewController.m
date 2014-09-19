//
//  MADHomeScreenCollectionViewController.m
// 
//
//  Created by Manish Rathi on 18/09/14.
//  Copyright (c) 2014 Rathi Inc. All rights reserved.
//
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import "MADHomeScreenCollectionViewController.h"
#import "MADHomeScreenCollectionViewCell.h"
#import "HttpServiceCall.h"
#import "MADAppDelegate.h"
#import "MADHomeScreenCollectionViewFooterView.h"


@interface MADHomeScreenCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,MADCollectionFooterViewDelegate>
//Will hold the information list of Albums
@property (nonatomic,strong) NSMutableArray *albumList;
//will hold the current Page
@property NSInteger currentPageNumber;
@end

@implementation MADHomeScreenCollectionViewController

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
    // Do any additional setup after loading the view.
    
    self.albumList=[NSMutableArray array];
    self.currentPageNumber=0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Fetch Image-List
    [self fetchAlbumListForPageNumber:self.currentPageNumber];
}

#pragma mark - Fetch Album-List
-(void)fetchAlbumListForPageNumber:(NSUInteger)pageNumber
{
    //Show HUD
    [[MADAppDelegate instance] showProgressHudWithMessage:@"Loading..."];
    
    NSString *urlString=[NSString stringWithFormat:@"/ServiceV1/Albums/hindi/%d",pageNumber];

    //Call Http web-Service
    [[HttpServiceCall instance] callServiceWithParams:nil methodType:@"GET" servicePath:urlString onCompletion:^(id json) {
        if (json) {
            //Add Data into Array
            [self.albumList addObjectsFromArray:json];
            //Current Page
            self.currentPageNumber=self.currentPageNumber+1;
            //reload Data
            [self.collectionView reloadData];
        }
        //Hide HUD
        [[MADAppDelegate instance] hideProgressHud];
    }];
}

#pragma mark - CollectionView
#pragma mark DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albumList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MADHomeScreenCollectionViewCell *cell = (MADHomeScreenCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MADHomeScreenCollectionViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //Set Image Here.
    NSString *imageName=self.albumList[indexPath.row][@"ImageName"];
    NSString *imageUrlString=[NSString stringWithFormat:@"http://s3.amazonaws.com/SonyCrbt/Images/%@.jpg",imageName];
    [cell.thumbView downloadImageWithUrlString:imageUrlString];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        MADHomeScreenCollectionViewFooterView *footerview =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                           withReuseIdentifier:@"MADHomeScreenCollectionViewFooterView"
                                                  forIndexPath:indexPath];
        reusableview = footerview;
    }
    
    return reusableview;
}

#pragma mark collection view cell layout / size
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(101, 101);
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

#pragma mark collection view selection
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *albumDetails=self.albumList[indexPath.row];
    //perform Segue Here
}

#pragma mark - collection FooterView Delegate
// Optional method, will be useful to notify the loadMoreButtonPressed event.
- (void) homeScreenCollectionViewFooterView:(MADHomeScreenCollectionViewFooterView *)homeScreenCollectionViewFooterView
                      loadMoreButtonPressed:(id)sender
{
    //LOAD More Images Now
    [self fetchAlbumListForPageNumber:self.currentPageNumber+1];
}
@end
