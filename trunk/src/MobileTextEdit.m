#import "MobileTextEdit.h"

@implementation MobileTextEdit

- (void) navigationBar: (UINavigationBar*)navbar buttonClicked: (int)button 
{
	switch (button) 
	{
		case 0: //Save
			if (path != @"")
			{
				[[textView text]
				        writeToFile: path
				        atomically: NO
				        encoding: NSMacOSRomanStringEncoding
				        error: &error];
			
				buttons = [NSArray arrayWithObjects:@"Close",nil];
			
				popup = [[UIAlertSheet alloc] initWithTitle:@"Saved" buttons:buttons defaultButtonIndex:0 delegate:self context:nil];

				[popup setBodyText: @"File Saved"];

				[popup popupAlertAnimated: TRUE];
			}
			else
			{
				[[textView text]
				        writeToFile: @"/tmp/mynewfile.txt"
				        atomically: NO
				        encoding: NSMacOSRomanStringEncoding
				        error: &error];
			
				buttons = [NSArray arrayWithObjects:@"Close",nil];
			}
		break;

		case 1:	//Open
			[self launchApplicationWithIdentifier:@"com.googlecode.MobileFinder" suspended:NO];
		break;
	}
}

- (void) alertSheet: (UIAlertSheet*)sheet buttonClicked:(int)button
{
	[sheet dismissAnimated: TRUE];
}

- (void) applicationDidFinishLaunching: (id) unused
{	
    UIWindow *window;
	mainView = NULL;
	float navBarWidth = 320.0f;
	float navBarHeight = 40.0f;
	float navBarSouthBuffer = 5.0f;
	float newButtonWidth = 56.0f;
	float buttonHeight = 32.0f;
	float buttonBuffer = 4.0f;
	float buttonBarWidth = 320.0f;
	float buttonBarHeight = 48.0f;

	window = [[UIWindow alloc] initWithContentRect:
		 [UIHardware fullScreenApplicationContentRect]
	];

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;

	mainView = [[UIView alloc] initWithFrame: rect];

	[window setContentView: mainView]; 
	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];

	_navBar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
	[_navBar showButtonsWithLeftTitle: @"Open" rightTitle: @"Save" leftBack: NO];
    [_navBar setBarStyle: 3];
	[_navBar setDelegate: self];

	[mainView addSubview: _navBar];
	
	_newButton = [[UINavBarButton alloc] initWithFrame: CGRectMake(
		navBarWidth / 2.0f - newButtonWidth / 2.0f - buttonBuffer,
		navBarHeight - buttonHeight - navBarSouthBuffer, 
		newButtonWidth, buttonHeight)];
	[_newButton setAutosizesToFit: FALSE];
	[_newButton addTarget: self action: @selector(newButtonPressed) forEvents: 1];
	[self resetFileOpButtons];
	[_navBar addSubview: _newButton];

    textView = [[UITextView alloc]
        initWithFrame: CGRectMake(0.0f, 40.0f, 320.0f, 245.0f - 40.0f)];
    [textView setEditable:YES];
    [textView setTextSize:14];

    kb = [[UIKeyboard alloc]
        initWithFrame:CGRectMake(0.0f, 245.0f, 320.0f, 200.0f)];

    [window setContentView: mainView];
    [mainView addSubview:textView];
    [mainView addSubview:kb];

	NSArray *myArgs = [[NSProcessInfo processInfo] arguments];

	if ([myArgs count] > 1)
	{
  		path = [myArgs objectAtIndex:1];

		[textView setText:
	        [NSMutableString
	            stringWithContentsOfFile:path
	            encoding:NSMacOSRomanStringEncoding
	            error:&error]];
	}
	else
	{
		[textView setText: @""];
	}
}

- (void) newButtonPressed
{
	path = @"";

	[textView setText: @""];
}

- (void) resetFileOpButtons
{
	if (_newButton != nil)
	{
		[_newButton setNavBarButtonStyle: 0];
		[_newButton setTitle: @"New"];
		[_newButton setEnabled: TRUE];
	}
}

- (void) applicationWillSuspend
{
   //
}

@end