//
//  AZShopDetailViewController.m
//  AutozvukUA
//
//  Created by Serbin Taras on 21.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZShopDetailViewController.h"
#import "AZShopImageCollectionViewCell.h"
#import "AZShopPhoneCollectionViewCell.h"
#import <Haneke.h>

@interface AZShopDetailViewController ()
{
    NSArray *_images;
    NSArray *_phones;
    NSString *_workTime;
    NSInteger _selectedIndex;
}
@end

@implementation AZShopDetailViewController
@synthesize imgLarge, btnNextImg, btnPrevImg, collectionPhoto, lblWorkTime, collectionPhone, mapShops, shop,
shopPin, lblShopName;
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = 0;
    self.isTitle = YES;
    self.isCall = YES;
    self.isCart = YES;
    [self setUpNavigationBar];
    [collectionPhoto registerNib:[UINib nibWithNibName:@"AZShopImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AZShopImageCollectionViewCell"];
    [collectionPhone  registerNib:[UINib nibWithNibName:@"AZShopPhoneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AZShopPhoneCollectionViewCell"];
    [self loadData];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    [mapShops addAnnotation:shopPin];
    [mapShops viewForAnnotation:shopPin];
    
    [self refreshImageWithIndex:_selectedIndex];
    lblShopName.text = [NSString stringWithFormat:@"%@ %@",lblShopName.text, shop.title];
    _images = [AZShop arrayFromString:shop.image];
    _phones = [AZShop arrayFromString:shop.phone];
    NSArray *workTimeArr = [AZShop arrayFromString:shop.workTime];
    NSMutableString *workTime = [NSMutableString string];
    for (NSString *str in workTimeArr)
    {
        if (![str isEqualToString:[workTimeArr lastObject]])
        {
            [workTime appendFormat:@"%@\n",str];
        }
        else
        {
            [workTime appendString:str];
        }
    }
    _workTime = [NSString stringWithString:workTime];
    lblWorkTime.text = workTime;
    [imgLarge hnk_setImageFromURL:[NSURL URLWithString:_images[_selectedIndex]]];
    [mapShops showAnnotations:self.mapShops.annotations animated:YES];
}

- (void)refreshImageWithIndex:(NSInteger)index
{
    [imgLarge hnk_setImageFromURL:[NSURL URLWithString:_images[index]]];
}

#pragma mark - User actions
- (IBAction)btnNextClicked:(UIButton *)sender {
    if (_selectedIndex != _images.count - 1)
    {
        _selectedIndex ++;
        [self refreshImageWithIndex:_selectedIndex];
    }
}
- (IBAction)btnPreviousClicked:(id)sender {
    if (_selectedIndex > 0) {
        _selectedIndex --;
        [self refreshImageWithIndex:_selectedIndex];
    }
}
- (IBAction)btnRouteClicked:(id)sender
{
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:shopPin.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:shop.title];
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if ([collectionView isEqual:collectionPhoto])
    {
        result = _images.count;
    }
    else
    {
        result = _phones.count;
    }
    return result;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if ([collectionView isEqual:collectionPhoto])
    {
       AZShopImageCollectionViewCell *imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AZShopImageCollectionViewCell" forIndexPath:indexPath];
        [imgCell.imgPhoto hnk_setImageFromURL:[NSURL URLWithString:_images[indexPath.row]]];

        cell = imgCell;
    }
    else
    {
       AZShopPhoneCollectionViewCell *phoneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AZShopPhoneCollectionViewCell" forIndexPath:indexPath];
        phoneCell.lblPhone.text = _phones[indexPath.row];
        cell = phoneCell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:collectionPhoto])
    {
        return CGSizeMake(collectionView.frame.size.width / 3, collectionView.frame.size.height);
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:collectionPhoto])
    {
        _selectedIndex = indexPath.row;
        [self refreshImageWithIndex:_selectedIndex];
    }
    else
    {
        
        NSString *stringURL = [NSString stringWithFormat:@"telprompt://%@",_phones[indexPath.row]];
        stringURL = [stringURL stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURL *phoneURL = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:phoneURL])
        {
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}
#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    AZShopAnnotationView *v = (AZShopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:((AZShopPin*)annotation).title];
    if (!v)
    {
        v = [[AZShopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:((AZShopPin*)annotation).title];
    }
    ((AZShopAnnotationView *)v).annotation = annotation;
    return v;
}
@end
