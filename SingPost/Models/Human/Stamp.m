#import "Stamp.h"
#import "StampImage.h"

@interface Stamp ()

@end


@implementation Stamp

- (UIImage *)displayImage
{
    if (self.images.count == 0)
        return nil;
    
    return [UIImage imageNamed:((StampImage *)self.images[0]).image];
}

@end
