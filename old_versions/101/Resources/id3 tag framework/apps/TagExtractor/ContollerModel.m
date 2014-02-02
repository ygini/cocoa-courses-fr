#import "ContollerModel.h"

@implementation ContollerModel

#define BUFFERLENGTH 1024

- (IBAction)File:(id)sender
{
    int result;
    int i;
    NSArray *fileTypes = [NSArray arrayWithObject:@"mp3"];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setAllowsMultipleSelection:FALSE];
    [oPanel setCanChooseDirectories:TRUE];

    result = [oPanel runModalForDirectory:NSHomeDirectory()
                    file:nil types:fileTypes];
    if (result == NSOKButton) 
    {
        [fileName setStringValue:[[oPanel filenames] objectAtIndex:0]];
            
        NSMutableData * data; 
        unsigned char * ptr = NULL;
        int filesize;
    
        NSFileHandle *file = [[NSFileHandle fileHandleForReadingAtPath: [fileName stringValue]] retain];
    
        if (file == NULL) return;
    
        filesize = [file seekToEndOfFile];
        [fileSize setIntValue:filesize];
        [file seekToFileOffset:0];
    
        data = [[file readDataOfLength:BUFFERLENGTH] retain];
        ptr = (unsigned char *) [data bytes];

        for (i = 0; i < BUFFERLENGTH; i++)
        {
            if ((*ptr == 'I')&&(ptr[1] == 'D')&&(ptr[2] == '3'))
            {
                length = ((ptr[6] & 127)*128*128*128) + (ptr[7] & 127)*128*128 + (ptr[8] & 127)*128 + (ptr[9] & 127);
                found = TRUE;
                if (length + i > filesize)
                {
                    // bad tag
                    [tagSize setIntValue:length];
                    if (filesize-128-1000-i <0) i = 0;
                    [extractSize setIntValue:filesize-1000-128];
                    } else
                {
                    [tagSize setIntValue:length];
                    [extractSize setIntValue:length];
                }
                [tagSize setIntValue:length];
                start = i;
                break;
            }
        }
        if (!found)
        {
            [tagSize setIntValue:0];
            [extractSize setIntValue:0];
            start = 0;
            length = 0;
        }
        [writeFileName setStringValue:[[fileName stringValue] stringByAppendingPathExtension:@"tag"]];
        
        [data release];
        [file closeFile];
    }
}

- (IBAction)Write:(id)sender
{            
    NSMutableData * data; 
    
    NSFileHandle *file = [[NSFileHandle fileHandleForReadingAtPath: [fileName stringValue]] retain];
    
    if (file == NULL) return;
    
    [file seekToFileOffset:start];
    data = [file readDataOfLength:(int)[extractSize intValue]+1000];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableString *tempString = [[writeFileName stringValue] mutableCopyWithZone:NULL];
    [tempString autorelease];
    
    //open unique file based on file name with .tag extention added
    while ([fileManager fileExistsAtPath:tempString]) [tempString appendString:@".tag"];
        [fileManager createFileAtPath:tempString contents:NULL attributes:NULL];

    if (![fileManager isWritableFileAtPath:tempString])
    {
        NSLog(@"File : %s is not writable",[tempString lossyCString]);
        return;
    }


    NSFileHandle *writefile = [NSFileHandle fileHandleForWritingAtPath: tempString];
    
    [writefile writeData:data];
    int filesize = [file seekToEndOfFile];
    if (filesize < 128) 
    {
        [file closeFile];
        return; 
    }
    [file seekToFileOffset: (filesize - 128)]; //reads last 128 bytes of the file as this is were a id3  tag would be stored
    data = [file readDataToEndOfFile];
    if (data == NULL)
    {
        [file closeFile];
        return;
    }
    [writefile writeData:data];
    [file closeFile];
    [writefile closeFile];
}

@end
