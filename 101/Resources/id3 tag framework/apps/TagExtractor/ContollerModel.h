/* ContollerModel */

#import <Cocoa/Cocoa.h>

@interface ContollerModel : NSObject
{
    IBOutlet id extractSize;
    IBOutlet id fileName;
    IBOutlet id fileSize;
    IBOutlet id tagSize;
    IBOutlet id writeFileName;
    
    int start;
    int length;
    bool found;
}
- (IBAction)File:(id)sender;
- (IBAction)Write:(id)sender;
@end
