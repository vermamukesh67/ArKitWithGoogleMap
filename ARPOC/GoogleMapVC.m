//
//  GoogleMapVC.m
//  ARPOC
//
//  Created by Mukesh Verma on 2/23/18.
//  Copyright © 2018 Mukesh Verma. All rights reserved.
//

#import "GoogleMapVC.h"


#define kApiKey1 @"AIzaSyDskKDCnQslFDACxdeaVBoV1_Wpc2NWE1Q"
#define kApiKeyRestricted @"AIzaSyAhOkusjGqY-A5H8-YSAl3IH_S97lTyCcE"
#define kGoogleApiKey @"AIzaSyDOdxQB5HZ0mjJRqc6c3R9CBQdRJAFKvFw"


@interface GoogleMapVC ()

@end

@implementation GoogleMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnEnableLocation setHidden:YES];
    // Do any additional setup after loading the view.
    [self FetchLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Location

-(void)FetchLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
   
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
             [self.btnEnableLocation setHidden:NO];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    currentLocation=newLocation;
    [self createGoogleMap];
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    currentLocation = [locations lastObject];
    NSLog(@"locations = %@",locations);
    NSLog(@"lat%f - lon%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    [self createGoogleMap];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.btnEnableLocation setHidden:NO];
}
#pragma Google Map
-(void)createGoogleMap
{
    [self.actView startAnimating];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
             GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                                     longitude:currentLocation.coordinate.longitude
                                                                          zoom:17];
             camera=[GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:17 bearing:30 viewingAngle:45];
             GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
             mapView.myLocationEnabled = YES;
             self.view = mapView;
             mapView.delegate=self;
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = currentLocation.coordinate;
             marker.title = Address;
             marker.snippet = CountryArea;
             marker.map = mapView;
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
             GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                                     longitude:currentLocation.coordinate.longitude
                                                                          zoom:17];
             camera=[GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:17 bearing:30 viewingAngle:45];
             GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
             mapView.myLocationEnabled = YES;
             self.view = mapView;
             mapView.delegate=self;
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = currentLocation.coordinate;
             marker.title = @"Current Location";
             marker.map = mapView;
             //return;
         }
         
         [self.actView stopAnimating];
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
    
    
}


//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
//                                                            longitude:coordinate.longitude
//                                                                 zoom:17];
//    camera=[GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) zoom:17 bearing:30 viewingAngle:45];
//
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
////    marker.title = @"Micrp Parks";
////    marker.snippet = @"Noida";
//    marker.map = mapView;
//}

- (void)mapView:(GMSMapView *)mapView
didTapPOIWithPlaceID:(NSString *)placeID
           name:(NSString *)name
       location:(CLLocationCoordinate2D)location
{
     [self.actView startAnimating];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    CLLocation *Objlocation =  [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];

    [geocoder reverseGeocodeLocation:Objlocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = location;
             marker.title = Address;
             marker.snippet = CountryArea;
             marker.map = mapView;
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             // Create a GMSCameraPosition that tells the map to display the
             // coordinate -33.86,151.20 at zoom level 6.
             // Creates a marker in the center of the map.
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = location;
             marker.title = @"Current Location";
             marker.map = mapView;
             //return;
         }
         
         [self.actView stopAnimating];
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnEnableLocationTapped:(id)sender {
    [self FetchLocation];
}
@end
