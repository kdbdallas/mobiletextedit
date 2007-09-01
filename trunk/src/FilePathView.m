/*
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UISimpleTableCell.h>

#import "FilePathView.h"

#include "Constants.h"

@implementation FilePathView
- (id)initWithFrame:(CGRect)frame
{
    [super initWithFrame: frame];

    _localFileView = [[UIView alloc]
			 initWithFrame: CGRectMake( 0.0,
						    navBarHeight,
						    frame.size.width,
						    57.0f )];

    [self addSubview:_localFileView];

    float NavBarBottomColor[4] = {0.43,0.52,0.63,1.0};
    [_localFileView setBackgroundColor:
			CGColorCreate(CGColorSpaceCreateDeviceRGB(),
				      NavBarBottomColor)];


    _openSaveTransitionView = [[UITransitionView alloc]
				  initWithFrame: CGRectMake( 0.0,
							     0.0,
							     frame.size.width,
							     57.0 ) ];
    [_localFileView addSubview:_openSaveTransitionView];


    _pathField = [[MyTextField alloc]
		     initWithFrame: CGRectMake( 15.0, 10.0f,
						frame.size.width - 30.0,
						30.0 ) ];
    [_pathField setDelegate:self];


    _topNavBar = [[UINavigationBar alloc]
		     initWithFrame: CGRectMake(frame.origin.x, frame.origin.y,
					       frame.size.width, navBarHeight)];
    [_topNavBar hideButtons];  // Just until everything gets set up
    [_topNavBar setDelegate:self];
    [self addSubview:_topNavBar];
    [self updateTopNavBarButtonTexts];

    _recentsTransitionView = [[UITransitionView alloc]
			initWithFrame: CGRectMake( 0, 58.0f + navBarHeight,
						   frame.size.width,
						   frame.size.height-navBarHeight-58.0f ) ];

    _blank = [[UIView alloc]
			initWithFrame: CGRectMake( 0, 0,
						   frame.size.width,
						   frame.size.height-navBarHeight-58.0f ) ];

    float darkTransparentColor[4] = {0.2,0.2,0.2,1.0};
    [_blank setBackgroundColor:
			CGColorCreate(CGColorSpaceCreateDeviceRGB(),
				      darkTransparentColor)];


    _recentsTable = [[UITable alloc]
			initWithFrame: CGRectMake( 0, 0,
						   frame.size.width,
						   frame.size.height-navBarHeight-58.0f ) ];

    UITableColumn *column = [[UITableColumn alloc]
				initWithTitle: @"Recents"
				identifier: @"Recents"
				width: frame.size.width];
    [_recentsTable addTableColumn: column];
    [_recentsTable setDataSource:self];
    [_recentsTable setDelegate:self];

    [self addSubview:_recentsTransitionView];

    _openFinderButton = [[UIPushButton alloc] 
			    initWithFrame: CGRectMake( 10.0f,
						       5.0f,
						       300.0f,
						       46.0f ) ];

    [_openFinderButton
	setBackground: [UIImage applicationImageNamed:@"FindInFinderButton.png"]
	forState: UIPushButtonStateNormal];

    [_openFinderButton
	setBackground: [UIImage applicationImageNamed:@"FindInFinderButtonPressed.png"]
	forState: UIPushButtonStatePressed];


    [_openFinderButton addTarget:self action:@selector(finderButtonPressed:) forEvents:1];

    [_pathField setText:defaultPath];
    _mode = FilePathModeOpen;

    return self;
}

- (void)setDelegate: (id)delegate
{
    _delegate = delegate;
}

- (void)finderButtonPressed: (UIPushButton *)button
{
    [_delegate openFileInFinder];
}

- (void)aboutToShowWithMode: (unsigned)mode andPath: (NSString *)path
{
    if( [path length] > 0 ) {
	[_pathField setText:path];
    }
    else {
	[_pathField setText:defaultPath];
    }

    _mode = mode;
    [self updateTopNavBarButtonTexts];
    [_recentsTable reloadData];
}

- (void)updateTopNavBarButtonTexts
{
    switch(_mode)
    {
    case FilePathModeOpen:
	[_openSaveTransitionView transition:TransitionNone toView:_openFinderButton];
	[_recentsTransitionView transition:TransitionNone toView:_recentsTable];
	[_topNavBar showButtonsWithLeftTitle:@"Cancel" rightTitle: @"Open"];
	break;
    case FilePathModeSave:
	[_openSaveTransitionView transition:TransitionNone toView:_pathField];
	[_recentsTransitionView transition:TransitionNone toView:_blank];
	[_topNavBar showButtonsWithLeftTitle:@"Cancel" rightTitle: @"Save"];
	break;
    }
}


- (void) navigationBar: (UINavigationBar*)navbar buttonClicked: (int)button 
{
    if( navbar == _topNavBar )
    {
	switch( button ) 
	{
	case 0: // Right button (Open/Save)
	    switch( _mode )
	    {
	    case FilePathModeOpen:
		[_delegate openFile:[
		    [_delegate recentFiles]
					objectAtIndex:[_recentsTable selectedRow] ]
		    ];
		break;
	    case FilePathModeSave:
		[_delegate saveFile:[_pathField text]];
		break;
	    }
	    [_delegate closeFilePathView];
	    break;
	case 1: // Left button (Cancel)
	    [_delegate closeFilePathView];
	    break;
	}
    }
    else
    {
	NSLog("navBar buttonCLICKED\n");
    }
}


///////////////////////////////////////////////////////
//  Selectors to be a UITable data source
///////////////////////////////////////////////////////
- (int) numberOfRowsInTable: (UITable*)table
{
    if (table == _recentsTable)
    {
	return [[_delegate recentFiles] count];
//	return 3;
    }
    else
    {
	NSLog(@"UNKnown Size\n");
	return 0;
    }
}

- (UITableCell*) table: (UITable*)table cellForRow: (int)row column: (int)col
{
    UISimpleTableCell *cell = [[UISimpleTableCell alloc] init];
    [cell setTitle: [[_delegate recentFiles] objectAtIndex:row] ];
    return cell;
}


- (void)dealloc
{
    [_topNavBar release];
    [_localFileView release];
    [_recentsTable release];
    [_openFinderButton release];
    [_pathField release];
    [_openSaveTransitionView release];
    [_recentsTransitionView release];
    [_blank release];
    [super dealloc];
}

@end
