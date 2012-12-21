//
//  AbstractMapViewController.h
//  ImmopolyIPhone
//
//  Created by Tobias Buchholz on 12.12.12.
//
//

#import "AbstractViewController.h"
#import <MapKit/MapKit.h>
#import "LocationDelegate.h"
#import "AsynchronousImageView.h"
#import "WebViewController.h"

//#define METERS_PER_MILE 50000.00
#define ANNO_WIDTH 43
#define ANNO_HEIGHT 37

#define EXPOSE_TRESHOLD_OLD 2592000000 // = 1000L * 60L * 60L * 24L * 30L
#define EXPOSE_TRESHOLD_NEW 604800000 // = 1000L * 60L * 60L * 24L* 7L

@interface AbstractMapViewController : AbstractViewController <MKMapViewDelegate, UIPageViewControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate> {
    @protected
        MKMapView *mapView;
        Flat *sameFlat;
        Flat *selectedImmoScoutFlat;
        bool isCalloutBubbleIn;
}

- (void)recenterMap;
- (void)calloutBubbleIn;
- (void)calloutBubbleOut;
- (void)filterAnnotations:(NSArray *)_flatsToFilter;

@end
