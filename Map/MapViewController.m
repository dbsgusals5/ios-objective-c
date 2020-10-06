//
//  MapViewController.m
//  iPadCourceYun
//
//  Created by alpha on 2019/09/12.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
@interface MapViewController () <GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegButton;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *mapSecondView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CusAddrText.text = self.CusAddr;
    self.CusNameText.text = self.CusName;
    [self getGeoInformations];
    
}
- (void)getGeoInformations {
    // #2 - This will be called during view did load.
    NSLog(@"Inside getGeoInformations");
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:self.CusAddr completionHandler:^(NSArray* placemarks, NSError* error){
        // This is called later, at some point after view did load is called.
        NSLog(@"Inside completionHandler.");
        
        if(error) {
            NSLog(@"Error");
            return;
        }
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude zoom:15];
        self.mapView = [GMSMapView mapWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 624.0f) camera:camera];
        self.mapView.myLocationEnabled = YES;
        self.mapView.mapType = kGMSTypeNormal;
        self.mapView.delegate = self;
        [self.mapSecondView addSubview:self.mapView];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        marker.snippet = self.CusAddr;
        marker.icon = [UIImage imageNamed:@"pin_standard@2x.png"];
        marker.map = self.mapView;
        self.mapView.selectedMarker = marker;
        NSLog(@"This is called third.");
    }];
    
    
}
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
   
    return nil;
}
- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker{
    UILabel *label= [[UILabel alloc]init];
    label.text = marker.snippet;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
    [label sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, label.intrinsicContentSize.width, label.intrinsicContentSize.height)];
    [label setFrame:CGRectMake(0, view.frame.size.height/3, label.intrinsicContentSize.width, label.intrinsicContentSize.height)];
    
    [view.layer setCornerRadius:5.0];
    [view addSubview:label];
    return view;
}

- (IBAction)BackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)MapSegBtn:(id)sender {
    switch (self.SegButton.selectedSegmentIndex) {
        case 0 :
           self.mapView.mapType = kGMSTypeNormal;
            break;
        case 1 :
            self.mapView.mapType = kGMSTypeHybrid;
            break;
        case 2 :
            self.mapView.mapType = kGMSTypeSatellite;
            break;
        default :
            break;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
