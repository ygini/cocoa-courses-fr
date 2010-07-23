/* MyObject */

#import <Cocoa/Cocoa.h>
#import <ID3Panel/ID3Panel.h>

@interface MyObject : NSObject
{
    IBOutlet id myOutlet;
    
    ID3Panel * panel;
}
- (IBAction)myAction:(id)sender;
@end
