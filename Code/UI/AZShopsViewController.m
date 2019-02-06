//
//  AZShopsViewController.m
//  AutozvukUA
//
//  Created by Serbin Taras on 15.01.16.
//  Copyright © 2016 Artfulbits. All rights reserved.
//

#import "AZShopsViewController.h"
#import "AZShopDetailViewController.h"
#import "AZShopDetailiPadViewController.h"

@interface AZShopsViewController ()
{
    CLLocationManager *_clManager;
    AZShopAnnotationView *selectedView;
}
@end

@implementation AZShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_IPAD)
    {
        self.isSearch = NO;
        self.isTitle = YES;
        self.isCall = NO;
    }
    else
    {
        self.isLogo = NO;
        self.isMenu = YES;
        self.isCart = YES;
        self.isSearch = NO;
        self.isTitle = YES;
        self.isCall = NO;
    }
    self.title = @"Наши магазины";
    
    [super setUpNavigationBar];
    self.mapShops.delegate = self;
    self.btnMap.layer.cornerRadius = self.btnMap.frame.size.height / 2;
    self.btnShops.layer.cornerRadius = self.btnShops.frame.size.height / 2;
    [AZWebAPI getShopsWithCompletionBlock:^(NSArray *shops, NSError *error) {
        if (shops.count > 0)
        {
            self.shops = [AZShop getAll];
            [self loadData];
        }
        
    }];
    if (_clManager == nil)
    {
        _clManager = [[CLLocationManager alloc] init];
        _clManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _clManager.delegate = self;
    }
    [self.colViewShops registerNib:[UINib nibWithNibName:@"AZShopsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AZShopsCollectionViewCell"];
    [self.btnMap setSelected:YES];
    [self.btnShops setSelected:NO];
    self.colViewShops.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


-(void)loadData
{
    if (_btnMap.selected)
    {
        self.backgroundView.alpha = 0.4;
        [self.mapShops removeAnnotations:self.mapShops.annotations];
        for (AZShop *shop in self.shops)
        {
            if (shop.latitude && shop.longitude)
            {
                AZShopPin *pin = [[AZShopPin alloc] initWithCoordinates:CLLocationCoordinate2DMake(shop.latitude, shop.longitude)];
                pin.title = shop.title;
                pin.shopWorkTime = [self workTimeFromArray:[AZShop arrayFromString:shop.workTime]];
                pin.index = [self.shops indexOfObject:shop];
                [self.mapShops addAnnotation:pin];
                [self.mapShops viewForAnnotation:pin];
            }
        }
        [self.mapShops showAnnotations:self.mapShops.annotations animated:YES];
    }
    else
    {
        self.backgroundView.alpha = 0.8;
        [self.colViewShops reloadData];
    }
}

-(NSString *)workTimeFromArray:(NSArray *)array
{
    NSMutableString *str = [NSMutableString string];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    [gregorian setFirstWeekday:2];
    NSInteger weekday = [comps weekday] - 1;
    switch (weekday) {
        case 6:
            [str appendFormat:@"%@",array[1]];
            break;
        case -1:
            [str appendFormat:@"%@",array[2]];
        default:
            [str appendFormat:@"%@",array[0]];;
            break;
    }
    if (str.length > 8) {
        if (![str containsString:@"закрыт"])
        [str deleteCharactersInRange:NSMakeRange(0, str.length - 8)];
    }
    
    return [NSString stringWithFormat:@"Открыто %@", str];
}
#pragma mark - User actions
- (IBAction)btnShopsClicked:(id)sender
{
    [self buttonStateChange];
    [self loadData];
}
- (IBAction)btnMapClicked:(id)sender
{
    [self buttonStateChange];
    [self loadData];
}

- (IBAction)showUserLocationTaped:(id)sender
{
    [self.mapShops setCenterCoordinate:self.mapShops.userLocation.location.coordinate animated:YES];
}

-(void)buttonStateChange
{
    _btnShops.selected = !_btnShops.selected;
    _btnMap.selected = !_btnMap.selected;
//    _mapShops.hidden =  !_btnMap.selected;
    _colViewShops.hidden = !_btnShops.selected;
    _btnShowUserLocation.hidden = !_btnMap.selected;
    
    if(_colViewShops.hidden)
    {
        [_colViewShops.superview sendSubviewToBack:_colViewShops];
    }
    else
    {
        [_mapShops.superview sendSubviewToBack:_mapShops];
        [_colViewShops.superview bringSubviewToFront:_colViewShops];
    }
}

- (void)showShopsDetailWithIndex:(NSInteger)index
{
    if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        AZShopDetailiPadViewController *vc = [[AZShopDetailiPadViewController alloc]
                                          initWithNibName:@"AZShopDetailiPadViewController" bundle:nil];
        vc.shop = _shops[index];
        vc.shopPin = _mapShops.annotations[index];
        vc.menu = self.menu;
        vc.menuDelegate = self.menuDelegate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        AZShopDetailViewController *vc = [[AZShopDetailViewController alloc]
                                          initWithNibName:@"AZShopDetailViewController" bundle:nil];
        vc.shop = _shops[index];
        vc.shopPin = _mapShops.annotations[index];
        vc.menu = self.menu;
        vc.menuDelegate = self.menuDelegate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tapOnCalloutView:(UITapGestureRecognizer *)gesture
{
    AZShopAnnotationView *v = (AZShopAnnotationView *)gesture.view.superview;
    AZShopPin *pin = v.annotation;
    [self showShopsDetailWithIndex:pin.index];
    v.calloutView.hidden = YES;
}
#pragma mark - CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined && [_clManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [_clManager requestWhenInUseAuthorization];
    else
    {
        [self startUpdateLocation];
    }
}

-(void)startUpdateLocation
{
    switch ([CLLocationManager authorizationStatus]) {
        case  kCLAuthorizationStatusDenied:
        case  kCLAuthorizationStatusRestricted:
        {
            [[[UIAlertView alloc] initWithTitle:nil message:LOCATION_PERM_MSG delegate:self cancelButtonTitle:BTN_CANCEL_TITLE otherButtonTitles:BTN_ON_TITLE, nil] show];
        }
            break;
        case  kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [_clManager startUpdatingLocation];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self openSettings];
    }
}

- (void)openSettings
{
    [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    id v = nil;
    if ([annotation isKindOfClass:[AZShopPin class]])
    {
        v = (AZShopAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:((AZShopPin*)annotation).title];
        if (!v)
        {
            v = [[AZShopAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:((AZShopPin*)annotation).title];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCalloutView:)];
        [((AZShopAnnotationView *)v).calloutView addGestureRecognizer:tapGesture];
        ((AZShopAnnotationView *)v).annotation = annotation;
    }
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        static NSString *ident = @"User_loc";
        v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (!v)
        {
            v = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ident];
        }
        ((MKAnnotationView *)v).image = [UIImage imageNamed:@"userPin"];
        ((MKAnnotationView *)v).contentMode = UIViewContentModeScaleAspectFill;
        ((MKAnnotationView *)v).canShowCallout = NO;
    }
    
    return v;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[AZShopAnnotationView class]])
    {
        if (!selectedView)
        {
            selectedView = (AZShopAnnotationView*)view;
            selectedView.calloutView.hidden = NO;
        }
        else
        {
            if (selectedView == view)
            {
                selectedView.calloutView.hidden = YES;
                selectedView = nil;
            }
            else
            {
                selectedView.calloutView.hidden = YES;
                AZShopAnnotationView *v = (AZShopAnnotationView*)view;
                v.calloutView.hidden = NO;
                selectedView = v;
            }
        }
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (selectedView == view)
    {
        selectedView.calloutView.hidden = YES;
        selectedView = nil;
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDatasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _shops.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AZShopsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AZShopsCollectionViewCell" forIndexPath:indexPath];
    AZShop *shop = _shops[indexPath.row];
    cell.lblShopName.text = shop.title;
    NSArray *workTimeArr = [AZShop arrayFromString:shop.workTime];
    NSMutableString *workTime = [NSMutableString string];
    for (int i = 0; i <= workTimeArr.count - 1; i++)
    {
        NSString *str = workTimeArr[i];
        if (i != workTimeArr.count - 1)
        {
            [workTime appendFormat:@"%@\n",str];
        }
        else
        {
            [workTime appendString:str];
        }
    }
    cell.lblShopWorkTime.text = workTime;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
         return CGSizeMake(collectionView.frame.size.width /2, 180.0);
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width, 150.0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showShopsDetailWithIndex:indexPath.row];
}

@end
