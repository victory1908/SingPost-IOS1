#import "PostingBox.h"


@interface PostingBox ()


@end


@implementation PostingBox

- (void)updateWithCsvRepresentation:(NSArray *)csv
{
    self.name = csv[0];
    self.type = csv[1];
    self.address = csv[2];
    self.latitude = csv[3];
    self.longitude = csv[4];
    self.notification = csv[5];
    self.mon_opening = csv[6];
    self.mon_closing = csv[7];
    self.tue_opening = csv[8];
    self.tue_closing = csv[9];
    self.wed_opening = csv[10];
    self.wed_closing = csv[11];
    self.thu_opening = csv[12];
    self.thu_closing = csv[13];
    self.fri_opening = csv[14];
    self.fri_closing = csv[15];
    self.sat_opening = csv[16];
    self.sat_closing = csv[17];
    self.sun_opening = csv[18];
    self.sun_closing = csv[19];
    self.ph_opening = csv[20];
    self.ph_closing = csv[21];
    self.services = csv[22];
    self.postingbox = csv[23];
}

@end
