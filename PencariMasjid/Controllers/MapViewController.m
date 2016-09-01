//
//  MapViewController.m
//  PencariMasjid
//
//  Created by Himawan Putra on 11/3/12.
//  Copyright (c) 2012 Himawan Putra. All rights reserved.
//

#import "MapViewController.h"
#import "ANONPlace.h"
#import "MosqueAnnotation.h"
#import "PoiDetailViewController.h"
#import <iAd/iAd.h>

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Pencari Masjid";
        //_mapView.delegate = self;
        
        isBannerVisible = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(currentLocation == NULL)
    {
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = 39.281516;
        zoomLocation.longitude= -76.580806;
        
        // 2
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        // 3
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        // 4
        [_mapView setRegion:adjustedRegion animated:YES];
        _mapView.alpha = 0;
    }
        
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _mapView.showsUserLocation = YES;
    NSLog(@"appear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    UIBarButtonItem *findMosqueButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *helpUs = [[UIBarButtonItem alloc] initWithTitle:@"Bantu Kami" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    _toolbar.items = @[userTrackingButton, findMosqueButton, flexible, helpUs];
    [self toggleBanner];
}

#pragma mark -

- (void)refresh:(id)sender {
    [self toggleBanner];
    [self findMosque];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MapView delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    if(currentLocation == NULL)
    {
        NSLog(@"User Location retrieved");
        
        prevLocation = userLocation.location;
        currentLocation = userLocation.location;
        [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        // 3
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        // 4
        [_mapView setRegion:adjustedRegion animated:YES];
        _mapView.alpha = 1;
        
        [self findMosque];
        
    }
    
    currentLocation = userLocation.location;
    
    
}
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"Start locating");
}

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation
{
    /*
	MKAnnotationView *customAnnotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
	//UIImage *pinImage = [UIImage imageNamed:@"ReplacementPinImage.png"];
	//[customAnnotationView setImage:pinImage];
    customAnnotationView.canShowCallout = YES;
	//UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftIconImage.png"]];
	//customAnnotationView.leftCalloutAccessoryView = leftIconView;
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[rightButton addTarget:self action:@selector(annotationViewClick:) forControlEvents:UIControlEventTouchUpInside];
	customAnnotationView.rightCalloutAccessoryView = rightButton;
    return customAnnotationView;
     */
    
    if ([annotation isKindOfClass:[MosqueAnnotation class]]){
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag = 1;
        //[rightButton addTarget:self action:@selector(annotationViewClick:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        return customPinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MosqueAnnotation *poi = view.annotation;
    
    if(control.tag == 1)
    {
        //NSLog(@"title: %@", poi.idVenue);
        PoiDetailViewController *detailViewController = [[PoiDetailViewController alloc] initWithNibName:@"PoiDetailView_iPhone" bundle:nil];
        
        detailViewController.theName = poi.name;
        detailViewController.theAddress = poi.address;
        detailViewController.idVenue = poi.idVenue;
        detailViewController.currentLatitude = currentLocation.coordinate.latitude;
        detailViewController.currentLongitude = currentLocation.coordinate.longitude;
        detailViewController.targetLatitude = poi.coordinate.latitude;
        detailViewController.targetLongitude = poi.coordinate.longitude;
        detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
        
}
- (IBAction) annotationViewClick:(id) sender {
    NSLog(@"clicked");
    if ([sender isKindOfClass:[MosqueAnnotation class]]){
        //NSLog(@"title: %@", (MosqueAnnotation)sender.name);
    }
}

-(void) findMosque
{
    // clear any existing annotations
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if([annotation isKindOfClass:[MosqueAnnotation class]])
            [_mapView removeAnnotation:annotation];
    }

    
    ANONPlace *placeApi = [[ANONPlace alloc] init];
    //NSArray *results;
    
    [placeApi near:currentLocation.coordinate distance:100 callback:^(NSDictionary *response) {
        NSLog(@"Stat %@", response[@"stat"]);
        if([response[@"stat"] isEqualToString:@"ok"])
        {
            NSArray *venues = response[@"pois"];
            NSString *msg = [NSString stringWithFormat:@"There are %i POIs Found", [venues count]];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"POIs Found"
                                                              message:msg
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            
            // add annotations
            
            for(int i=0;i<venues.count;i++)
            {
                //NSLog(@"nama: %f", [response[@"pois"][i][@"location"][0] doubleValue]);
                
                CLLocationCoordinate2D coordinate;
                
                NSString *name = response[@"pois"][i][@"title"];
                NSString *idVenue = response[@"pois"][i][@"_id"];
                 NSLog(@"gshagshagshaj: %@", idVenue);
                NSString *address = response[@"pois"][i][@"address"];
                if (address == NULL) {
                    address = @"";
                } else {
                    address = [NSString stringWithFormat:@"%@, ", address];
                }
                NSString *city = response[@"pois"][i][@"city"];
                if (city == NULL) {
                    city = @"";
                } else {
                    city = [NSString stringWithFormat:@"%@, ", city];
                }
                NSString *province = response[@"pois"][i][@"province"];
                if (province == NULL) {
                    province = @"";
                } else {
                    province = [NSString stringWithFormat:@"%@, ", province];
                }
                NSString *country = response[@"pois"][i][@"country"];
                if (country == NULL) {
                    country = @"";
                } else {
                    country = [NSString stringWithFormat:@"%@", country];
                }
                NSString *fullAddress = [NSString stringWithFormat:@"%@%@%@%@", address, city, province, country];
                coordinate.latitude = [response[@"pois"][i][@"location"][1] doubleValue];
                coordinate.longitude = [response[@"pois"][i][@"location"][0] doubleValue];
                MosqueAnnotation *annotation = [[MosqueAnnotation alloc] initWithName:name idVenue:idVenue address:fullAddress coordinate:coordinate];
                [_mapView addAnnotation:annotation];
            }
            
        }
        else
            NSLog(@"Message: %@", response[@"message"]);
    }];
    
}

#pragma mark -
#pragma mark Banner

-(void) toggleBanner
{
    if(isBannerVisible)
    {
        NSLog(@"bannerView:didFailToReceiveAdWithError:");
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		// assumes the banner view is at the top of the screen.
		self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0, 50);
        
		[UIView commitAnimations];
		isBannerVisible = NO;
    }
    else
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		// assumes the banner view is at the top of the screen.
		self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0, -50);
        
		[UIView commitAnimations];
		isBannerVisible = YES;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if(!isBannerVisible)
        [self toggleBanner];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if(isBannerVisible)
        [self toggleBanner];
}

@end
