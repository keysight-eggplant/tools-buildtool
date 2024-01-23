########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Adam Fox
# Commit ID: 89414f8d6fc0cc116eb50bdb3f563e6f00d9d950
# Date: 2020-10-24 16:49:15 -0600
########## End of Keysight Technologies Notice ##########
/*
   Project: buildtool

   Author: Gregory John Casamento,,,

   Created: 2011-08-20 11:42:51 -0400 by heron
*/

#import <Foundation/Foundation.h>
#import <XCode/PBXCoder.h>
#import <XCode/PBXContainer.h>
#import <XCode/NSString+PBXAdditions.h>

NSString *
findProjectFilename(NSArray *projectDirEntries)
{
  NSEnumerator *e = [projectDirEntries objectEnumerator];
  NSString     *fileName;

  while ((fileName = [e nextObject]))
    {
      NSRange range = [fileName rangeOfString:@"._"];
      if ([[fileName pathExtension] isEqual: @"xcodeproj"] && range.location == NSNotFound)
	{
	  return [fileName stringByAppendingPathComponent: @"project.pbxproj"];
	}
    }

  return nil;
}

int
main(int argc, const char *argv[])
{
  if(argc == 0)
    {
      return 0;
    }

  setlocale(LC_ALL, "en_US.utf8");
  id pool = [[NSAutoreleasePool alloc] init];
  NSString                   *fileName = nil;
  NSString                   *function = nil; 
  PBXCoder                   *coder = nil;
  PBXContainer               *container = nil;
  NSString                   *projectDir;
  NSArray                    *projectDirEntries;
  NSFileManager              *fileManager = [NSFileManager defaultManager];

  projectDir        = [fileManager currentDirectoryPath];
  projectDirEntries = [fileManager directoryContentsAtPath: projectDir];

  // Get the project...
  if(argv[1] != NULL)
    {
      NSString *xcodeFilePath = [NSString stringWithCString: argv[1]];
      fileName = [xcodeFilePath
			 stringByAppendingPathComponent: 
		     @"project.pbxproj"];
      if([[xcodeFilePath pathExtension] isEqualToString:@"xcodeproj"] == NO)
	{
	  fileName = findProjectFilename(projectDirEntries);
	  function = [NSString stringWithCString: argv[1]];
	}
      else
	{
	  // If there is a project, add the build operation...
	  if(argv[2] != NULL && argc > 1)
	    {
	      function = [NSString stringWithCString: argv[2]];
	    }
	}

    }
  else
    {
      fileName = findProjectFilename(projectDirEntries);
    }

  if([function isEqualToString: @""] || function == nil)
    {
      function = @"build"; // default action...
    }

  NSString *display = [function stringByCapitalizingFirstCharacter];

  // Unarchive...
  coder = [[PBXCoder alloc] initWithContentsOfFile: fileName];
  container = [coder unarchive];

  // Build...
  int returnCode = 1;
  SEL operation = NSSelectorFromString(function);
  if ([container respondsToSelector: operation])
    {

      // build...
      puts([[NSString stringWithFormat: @"\033[1;32m**\033[0m Start operation %@", display] cString]); 
      if ([container performSelector: operation])
	{
	  puts([[NSString stringWithFormat: @"\033[1;32m**\033[0m %@ Succeeded", display] cString]);
          returnCode = 0;
	}
      else
	{
          puts([[NSString stringWithFormat: @"\033[1;31m**\033[0m %@ Failed", display] cString]);
	}
    }
  else
    {
      puts([[NSString stringWithFormat: @"Unknown build operation \"%@",display] cString]);
    }

  // The end...
  [pool release];

  return returnCode;
}

