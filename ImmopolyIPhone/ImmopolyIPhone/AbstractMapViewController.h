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
#define ANNO_WIDTH 40
#define ANNO_HEIGHT 51

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
