/* ID3Panel */

#import <Cocoa/Cocoa.h>

@interface ID3Panel : NSWindowController
{
    IBOutlet id Advanced;
    IBOutlet id AlbumPage1;
    IBOutlet id AlbumPage2;
    IBOutlet id ArtistPage1;
    IBOutlet id ArtistPage2;
    IBOutlet id BitRate;
    IBOutlet id Channels;
    IBOutlet id Comments;
    IBOutlet id Composer;
    IBOutlet id DateModified;
    IBOutlet id Delete;
    IBOutlet id DeletePicture;
    IBOutlet id DiscNumber;
    IBOutlet id DiskMax;
    IBOutlet id EncodingWith;
    IBOutlet id Format;
    IBOutlet id Frame;
    IBOutlet id FrameContent;
    IBOutlet id FrameList;
    IBOutlet id FrameSize;
    IBOutlet id FrameSlider;
    IBOutlet id Genre;
    IBOutlet id ID3Tag;
    IBOutlet id Kind;
    IBOutlet id LastPlayed;
    IBOutlet id NextButton;
    IBOutlet id Path;
    IBOutlet id PreviousButton;
    IBOutlet id PicturePage1;
    IBOutlet id PicturePage4;
    IBOutlet id PictureSlider;
    IBOutlet id PlayCount;
    IBOutlet id SampleRate;
    IBOutlet id FileSize;
    IBOutlet id TitlePage1;
    IBOutlet id TitlePage2;
    IBOutlet id TrackNumber;
    IBOutlet id TrackTotal;
    IBOutlet id Volume;
    IBOutlet id Year;
    
    id Tag;
    NSArray * files;
    BOOL modified;
    int fileIndex;
    int pictureIndex;
    NSMutableArray * FrameSet;
    NSMutableArray * ImageSet;
    NSImage * Image1;
    NSImage * Image2;
    NSPopUpButton * noSelPopUp;
    BOOL text;
   // NSWindowController * controller;
    
    BOOL modArtist, modAlbum, modTitle, modComposer, modComment, modGenre, modPicture, modTrack, modDisk, modTracks, modDisks, modYear;
}
- (IBAction)AddPicture:(id)sender;
- (IBAction)Cancel:(id)sender;
- (IBAction)DeleteFrame:(id)sender;
- (IBAction)DeletePicture:(id)sender;
- (IBAction)FrameList:(id)sender;
- (IBAction)FrameSliderControl:(id)sender;
- (void)GenreSelector:(id)sender;
- (IBAction)myAction2:(id)sender;
- (IBAction)Next:(id)sender;
- (IBAction)OK:(id)sender;
- (IBAction)PictureSliderControl:(id)sender;
- (IBAction)Previous:(id)sender;


- (id)initWithArray:(NSArray *)Files genreList:(NSMutableDictionary *)Genres;

- (IBAction)orderFrontStandardAboutPanel:(id)sender;
- (IBAction)hide:(id)sender;
- (IBAction)hideOtherApplications:(id)sender;
- (void)terminate:(id)sender;
- (void)orderFrontStandardAboutPanel:(id)sender;
- (void)hideOtherApplications:(id)sender;
- (void)hide:(id)sender;
- (void)unhideAllApplications:(id)sender;

- (void)updateFile;
- (void)updatePictureControls:(int)index;
- (void)updatePictures:(int)index updatePage1:(BOOL)Page;
- (void)displayStreamInfo;
- (void)display:(BOOL)Update;
@end
