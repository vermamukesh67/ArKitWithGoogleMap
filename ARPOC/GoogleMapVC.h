//
//  GoogleMapVC.h
//  ARPOC
//
//  Created by Mukesh Verma on 2/23/18.
//  Copyright © 2018 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
@interface GoogleMapVC : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    GMSMapView *mapView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actView;
@property (weak, nonatomic) IBOutlet UIButton *btnEnableLocation;
- (IBAction)btnEnableLocationTapped:(id)sender;
@end
