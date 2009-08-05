//
//  Controller.h
//  testbedUI
//
//  Created by jlindsey on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Controller : NSObject {
	// UI Elements
	IBOutlet NSProgressIndicator *progressBar;
	IBOutlet NSTextField *urlInput;
	IBOutlet NSButton *goButton;
	
	// Connection guts
	NSURLConnection *connection;
	NSURLRequest *request;
	NSMutableData *payload;
}

#pragma mark -
#pragma mark Actions
- (IBAction) toggleDownload:(NSButton *)sender;

#pragma mark -
#pragma mark Internal Utility Methods
- (void) startDownload;
- (void) stopAllTheDownloadin;
- (void) formStateToggleIsDownloading:(BOOL)toggle;

#pragma mark -
#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)conn;
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error;
@end
