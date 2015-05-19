
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>
@property CLLocationManager *myLocationMgr;

@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myLocationMgr = [[CLLocationManager alloc]init];
    [self.myLocationMgr requestWhenInUseAuthorization];
    self.myLocationMgr.delegate = self;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"I failed: %@",error);
}

- (IBAction)startViolationPrivacy:(id)sender
{
    [self.myLocationMgr startUpdatingLocation];
    self.myTextView.text = @"Locating you...";
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy <1000) {
            self.myTextView.text = @"Location found. Reverse Geocoding...";
            [self reverseGeocode:location];
            [self.myLocationMgr stopUpdatingLocation];
            break;
        }
    }
}

-(void) reverseGeocode: (CLLocation *) location
{
    CLGeocoder *geoCoder= [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placeMark =placemarks.firstObject;
        NSString *address = [NSString  stringWithFormat:@"%@ %@ \n%@",
                             placeMark.subThoroughfare, placeMark.thoroughfare, placeMark.locality];
        self.myTextView.text = [NSString stringWithFormat:@"Found you: %@", address];
        [self findJailNear:placeMark.location];
    }];
}

-(void) findJailNear: (CLLocation *)location
{

}

@end
