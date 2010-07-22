    //
//  EventDetailsViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/13/10.
//  Copyright 2010 VMware, Inc. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventDescriptionViewController.h"
#import "EventCurrentSessionsViewController.h"
#import "EventTweetsViewController.h"


@interface EventDetailsViewController()

@property (nonatomic, retain) NSArray *arrayMenuItems;

@end


@implementation EventDetailsViewController

@synthesize arrayMenuItems;
@synthesize event;
@synthesize labelTitle;
@synthesize labelDescription;
@synthesize labelTime;
@synthesize labelLocation;
@synthesize labelHashtag;
@synthesize tableViewMenu;
@synthesize eventDescriptionViewController;
@synthesize eventSessionsViewController;
@synthesize eventTweetsViewController;


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) 
	{
		case 0:
			[self.navigationController pushViewController:eventDescriptionViewController animated:YES];
			break;
		case 1:
			[self.navigationController pushViewController:eventSessionsViewController animated:YES];
			break;
		case 2:
			[self.navigationController pushViewController:eventTweetsViewController animated:YES];
			break;
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdent = @"menuCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSString *s = (NSString *)[arrayMenuItems objectAtIndex:indexPath.row];
	
	[cell.textLabel setText:s];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (arrayMenuItems)
	{
		return [arrayMenuItems count];
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = @"Event Details";
	
	self.arrayMenuItems = [[NSArray alloc] initWithObjects:@"Description", @"Current Sessions", @"Recent Tweets", @"Sessions", nil];
	
	self.eventDescriptionViewController = [[EventDescriptionViewController alloc] initWithNibName:nil bundle:nil];
	self.eventSessionsViewController = [[EventCurrentSessionsViewController alloc] initWithNibName:nil bundle:nil];
	self.eventTweetsViewController = [[EventTweetsViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	eventDescriptionViewController.eventDescription = event.description;
	eventSessionsViewController.eventId = event.eventId;
	eventTweetsViewController.eventId = event.eventId;
	
	labelTitle.text = event.title;
//	labelDescription.text = event.description;
	
	if ([event.startTime compare:event.endTime] == NSOrderedSame)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE, MMMM d, YYYY"];
		labelTime.text = [dateFormatter stringFromDate:event.startTime];
		[dateFormatter release];
	}
	else if ([event.startTime compare:event.endTime] == NSOrderedAscending)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEE, MMM d"];		
		NSString *formattedStartTime = [dateFormatter stringFromDate:event.startTime];
		[dateFormatter setDateFormat:@"EEE, MMM d, YYYY"];
		NSString *formattedEndTime = [dateFormatter stringFromDate:event.endTime];
		[dateFormatter release];
		
		NSString *formattedTime = [[NSString alloc] initWithFormat:@"%@ - %@", formattedStartTime, formattedEndTime];
		labelTime.text = formattedTime;
		[formattedTime release];
	}

	labelLocation.text = event.location;
	labelHashtag.text = event.hashtag;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	self.arrayMenuItems = nil;
	self.event = nil;
	self.labelTitle = nil;
	self.labelDescription = nil;
	self.labelTime = nil;
	self.labelLocation = nil;
	self.labelHashtag = nil;
	self.tableViewMenu = nil;
	self.eventDescriptionViewController = nil;
	self.eventSessionsViewController = nil;
	self.eventTweetsViewController = nil;
}


#pragma mark -
#pragma mark NSObject methods

- (void)dealloc 
{
	[arrayMenuItems release];
	[event release];
	[labelTitle release];
	[labelDescription release];
	[labelTime release];
	[labelLocation release];
	[labelHashtag release];
	[tableViewMenu release];
	[eventDescriptionViewController release];
	[eventSessionsViewController release];
	[eventTweetsViewController release];
	
    [super dealloc];
}


@end
