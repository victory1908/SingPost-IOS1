#import "StampImage.h"
#import "NSDictionary+Additions.h"

@interface StampImage ()

@end


@implementation StampImage

- (void)updateWithApiRepresentation:(NSDictionary *)json
{
    self.image = [json objectForKeyOrNil:@"Views"];
    self.name = [json objectForKeyOrNil:@"Name"];
}

@end
