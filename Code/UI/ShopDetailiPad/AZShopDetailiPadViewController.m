//
//  AZShopdetailiPadViewController.m
//  AutozvukUA
//
//  Created by Serbin Taras on 04.03.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZShopDetailiPadViewController.h"
#import "AZShopImageCollectionViewCell.h"
#import "AZShopPhoneTableViewCell.h"
#import <Haneke.h>
@interface AZShopDetailiPadViewController ()
{
    NSArray *_images;
    NSArray *_phones;
    NSString *_workTime;
    NSInteger _selectedIndex;
}
@end

@implementation AZShopDetailiPadViewController
@synthesize btnNext, btnPrev, imgPhoto, colPhotos, lblWorkTime, tblPhones, lblShopName, shopPin, shop, mapShops;
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    _selectedIndex = 0;
    
    if(IS_IPAD)
    {
        self.isSearch = NO;
        self.isTitle = YES;
        self.isCall = YES;
    }
    else
    {
        self.isTitle = YES;
        self.isCall = NO;
        self.isCart = NO;
    }
    self.title = @"Вернуться к списку";
    [self setUpNavigationBar];
    [colPhotos registerNib:[UINib nibWithNibName:@"AZShopImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AZShopImageCollectionViewCell"];
    [self loadData];
    [tblPhones registerNib:[UINib nibWithNibName:@"AZShopPhoneTableViewCell" bundle:nil] forCellReuseIdentifier:@"AZShopPhoneTableViewCell"];
    // Do any additional setup after loading the view from its nib.
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
    [imgPhoto hnk_setImageFromURL:[NSURL URLWithString:_images[_selectedIndex]]];
    [mapShops showAnnotations:self.mapShops.annotations animated:YES];
//    [colPhotos reloadData];
}

- (void)refreshImageWithIndex:(NSInteger)index
{
    [imgPhoto hnk_setImageFromURL:[NSURL URLWithString:_images[index]]];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger result = 0;
    //    if ([collectionView isEqual:collectionPhoto])
    //    {
    result = _images.count;
    //    }
    //    else
    //    {
    //        result = _phones.count;
    //    }
    return result;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    AZShopImageCollectionViewCell *imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AZShopImageCollectionViewCell" forIndexPath:indexPath];
    [imgCell.imgPhoto hnk_setImageFromURL:[NSURL URLWithString:_images[indexPath.row]]];
    
    cell = imgCell;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width / 3, collectionView.frame.size.height);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [self refreshImageWithIndex:_selectedIndex];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _phones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AZShopPhoneTableViewCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:@"AZShopPhoneTableViewCell" forIndexPath:indexPath];
    phoneCell.lblPhone.text = _phones[indexPath.row];
    return phoneCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringURL = [NSString stringWithFormat:@"telprompt://%@",_phones[indexPath.row]];
    stringURL = [stringURL stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneURL = [NSURL URLWithString:stringURL];
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL])
    {
        [[UIApplication sharedApplication] openURL:phoneURL];
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
