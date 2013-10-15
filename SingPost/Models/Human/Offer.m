#import "Offer.h"
#import "OfferImage.h"

@interface Offer ()

// Private interface goes here.

@end


@implementation Offer

- (UIImage *)displayImage
{
    if (self.images.count == 0)
        return nil;
    
    return [UIImage imageNamed:((OfferImage *)self.images[0]).image];
}

@end
