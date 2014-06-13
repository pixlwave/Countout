// Generated by IB v0.4.7 gem. Do not edit it manually
// Run `rake ib:open` to refresh

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface AppDelegate: UIResponder <UIApplicationDelegate>
-(IBAction) updateOutput;
-(IBAction) countdownHasChanged;

@end

@interface AppearanceController: UIViewController

@property IBOutlet UIView * previewView;
@property IBOutlet UIImageView * previewImageView;
@property IBOutlet UILabel * previewLabel;

-(IBAction) viewDidLoad;
-(IBAction) done;
-(IBAction) chooseBackground;
-(IBAction) updateAppearance;
-(IBAction) imagePickerControllerDidCancel:(id) picker;

@end

@interface CountdownController: UIViewController

@property IBOutlet UIView * previewView;
@property IBOutlet UIImageView * previewImageView;
@property IBOutlet UILabel * previewLabel;
@property IBOutlet UILabel * outputStatusLabel;
@property IBOutlet UILabel * lengthLabel;
@property IBOutlet UITextField * minutesTextField;
@property IBOutlet UITextField * secondsTextField;
@property IBOutlet UIView * countdownLengthView;
@property IBOutlet NSLayoutConstraint * countdownLengthViewTopConstraint;
@property IBOutlet NSLayoutConstraint * countdownDoneButtonTopConstraint;
@property IBOutlet NSLayoutConstraint * countdownLengthViewBottomConstraint;

-(IBAction) viewDidLoad;
-(IBAction) preferredStatusBarStyle;
-(IBAction) supportedInterfaceOrientations;
-(IBAction) viewWillAppear:(id) animated;
-(IBAction) updateCountdownLength;
-(IBAction) updateLengthLabel;
-(IBAction) start;
-(IBAction) stop;
-(IBAction) reset;
-(IBAction) editCountdownLength;
-(IBAction) finishCountdownLength;

@end

@interface OutputController: UIViewController

@property IBOutlet UILabel * timeLabel;
@property IBOutlet UIImageView * backgroundImageView;

-(IBAction) viewDidLoad;
-(IBAction) viewWillAppear:(id) animated;
-(IBAction) updateAppearance;

@end

@interface Appearance: NSObject
-(IBAction) initialize;

@end

@interface CountdownTimer: NSObject
-(IBAction) initialize;
-(IBAction) setTime:(id) length;
-(IBAction) start;
-(IBAction) stop;
-(IBAction) reset;
-(IBAction) tick;

@end

