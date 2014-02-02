#import "MyObject.h"

@implementation MyObject

- (IBAction)myAction:(id)sender
{
     int result;
     NSArray *fileTypes = [NSArray arrayWithObjects:@"mp3",
                        NSFileTypeForHFSTypeCode('mp3'), nil];
     NSOpenPanel * openPanel = [NSOpenPanel openPanel];
     [openPanel setCanChooseFiles: YES];
     [openPanel setCanChooseDirectories: NO];
     [openPanel setResolvesAliases: YES];
     [openPanel setAllowsMultipleSelection:YES];
     
     result = [openPanel runModalForDirectory:NSHomeDirectory()
                    file:nil types:fileTypes];
    if (result == NSOKButton) 
    {
	panel = [[ID3Panel alloc] initWithArray:[openPanel filenames] genreList:NULL];
	[panel release];
    }
}

@end
