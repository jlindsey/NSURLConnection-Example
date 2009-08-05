//
//  Controller.m
//  testbedUI
//
//  Created by jlindsey on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"


@implementation Controller
#pragma mark -
#pragma mark Actions
- (IBAction) toggleDownload:(NSButton *)sender
{
	if ([sender state] == NSOnState)
	{
		[self startDownload];
	}
	else
	{
		[self stopAllTheDownloadin];
	}
}

#pragma mark -
#pragma mark Internal Utility Methods
- (void) startDownload
{
	[self formStateToggleIsDownloading:YES];
	
	NSString *input = [urlInput stringValue];
	NSURL *url = [NSURL URLWithString:input];
	
	request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection)
	{
		payload = [[NSMutableData data] retain];
		NSLog(@"Connection starting: %@", connection);
	}
	else
	{
		// Create and display an alert sheet
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:@"Unable to start download."];
		[alert setInformativeText:@"For some reason, this done fucked up."];
		[alert setAlertStyle:NSCriticalAlertStyle];
		
		[alert beginSheetModalForWindow:[goButton window] modalDelegate:self didEndSelector:nil contextInfo:nil];
		
		[self formStateToggleIsDownloading:NO];
	}
}

- (void) stopAllTheDownloadin
{
	[connection cancel];
	[self formStateToggleIsDownloading:NO];
}

- (void) formStateToggleIsDownloading:(BOOL)toggle
{
	[progressBar setMaxValue:100.0];
	[progressBar setDoubleValue:1.0];
	
	// Currently downloading
	if (toggle == YES)
	{
		[goButton setState:NSOnState];
		[progressBar setHidden:NO];
		[urlInput setHidden:YES];
	}
	else
	{
		[goButton setState:NSOffState];
		[progressBar setHidden:YES];
		[urlInput setStringValue:@""];
		[urlInput setHidden:NO];
	}
}

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"Recieved response with expected length: %i", [response expectedContentLength]);
	
	[payload setLength:0];
	[progressBar setMaxValue:[response expectedContentLength]];
}
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
	NSLog(@"Recieving data. Incoming Size: %i  Total Size: %i", [data length], [payload length]);
	
	[payload appendData:data];
	[progressBar setDoubleValue:[payload length]];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
	[self formStateToggleIsDownloading:NO];
	
	[conn release];
	
	NSLog(@"Connection finished: %@", conn);
}
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
	[self formStateToggleIsDownloading:NO];
	
	[payload setLength:0];
	
	// Create and display an alert sheet
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:[error localizedDescription]];
	[alert setInformativeText:[[error userInfo] objectForKey:NSErrorFailingURLStringKey]];
	[alert setAlertStyle:NSCriticalAlertStyle];
	
	[alert beginSheetModalForWindow:[goButton window] modalDelegate:self didEndSelector:nil contextInfo:nil];
}
@end
