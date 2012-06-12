/*
 *  __  __      
 * /\ \/\ \  __________   
 * \ \ \_\ \/_______  /\   
 *  \ \  _  \  ____/ / /  
 *   \ \_\ \_\ \ \/ / / 
 *    \/_/\/_/\ \ \/ /  
 *             \ \  /
 *              \_\/
 *
 * -----------------------------------------------------------------------------
 * @author: Herbert Veitengruber 
 * @version: 1.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.zinc.z3
{
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	import mdm.*;
	
	// =========================================================================
	// Class RegistryHelper
	// =========================================================================
	// static class with usefull registry functions
	//
	public class RegistryHelper
	{
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * createFileAssociationEntry
		 * ---------------------------------------------------------------------
		 * creates a file association for your application
		 * and saves it into windows registry. 
		 * 
		 * If the user has windows 7 he needs admin rights.
		 *
		 * @param extension
		 * @param regKey
		 * @param contentType
		 * @param exeFile
		 * @param fileDescription
		 * @param icoFile
		 * @param icoIndex
		 *
		 * @return true if it was succesfull, false if not
		 */
		public static function createFileAssociationEntry(
				extension:String,
				regKey:String,
				contentType:String,
				exeFile:String,
				fileDescription:String,
				icoFile:String,
				icoIndex:int
			):Boolean
		{
			try 
			{
				//'1' -> HKEY_CLASSES_ROOT see zinc docs
				var registryPath:int = 1;
				
				var keyExists:Boolean = mdm.System.Registry.keyExists(
						registryPath, 
						"\\" + extension
					);
				
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"Accessing Registry...",
							DebugLevel.INFO,
							" --> looking for extension: " + extension 
								+ "<br> --> exists=" + keyExists
						);
					
				// check for admin rights on win 7 we need them
				if( !mdm.System.isAdmin )	
				{
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Sorry no admin rights. Registry access aborted.",
								DebugLevel.INFO
							);
					return false;	
				}
				
				if( keyExists ) 
				{
					// check if your extension is assoziated with your application
					// if not backup old one.
					
					var key:String = mdm.System.Registry.loadString(
							registryPath, 
							"\\" + extension, 
							""
						);
					if( key != regKey )
					{
						if( Console.isConsoleAvailable() )
							Console.getInstance().writeln(
									"Backup old reg entry: ",
									DebugLevel.INFO,
									" --> " + extension + " old: " +key
								);
						// Backup
						mdm.System.Registry.saveString(
								registryPath, 
								"\\" + extension, 
								"backup_val", 
								key
							);
						// save our entry
						mdm.System.Registry.saveString(
								registryPath, 
								"\\" + extension, 
								"", 
								regKey
							);
					}
				} else {
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Create new reg entry: ",
								DebugLevel.INFO,
								" --> " + extension 
							);
					// create new 	
					mdm.System.Registry.createKey(
							registryPath, 
							"\\" + extension, 
							regKey
						);
				}
				// set content type
				mdm.System.Registry.saveString(
						registryPath, 
						"\\" + extension, 
						"Content Type", 
						contentType
					);
					
				// now create/update application path for exe and icon
		
				keyExists = mdm.System.Registry.keyExists(
						registryPath, 
						"\\" + regKey
					);
				
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"Accessing Registry...",
							DebugLevel.INFO,
							" --> looking for " + regKey 
								+ "<br> --> exists=" + keyExists
						);
	
				if( keyExists == false ) 
				{
					if( Console.isConsoleAvailable() )
						Console.getInstance().writeln(
								"Create new entry: "+ regKey,
								DebugLevel.INFO
							);
		
					mdm.System.Registry.createKey(
							registryPath, 
							"\\" + regKey, 
							fileDescription
						);
					mdm.System.Registry.createKey(
							registryPath, 
							"\\" + regKey + "\\shell",
							""
						);
					mdm.System.Registry.createKey(
							registryPath, 
							"\\" + regKey + "\\shell\\open", 
							""
						);
					mdm.System.Registry.createKey(
							registryPath, 
							"\\" + regKey + "\\shell\\open\\command",
							""
						);
					mdm.System.Registry.createKey(
							registryPath, 
							"\\" + regKey + "\\DefaultIcon", 
							""
						);
				}
				// update
				var shortPath:String = mdm.FileSystem.getShortPathName(mdm.Application.path);
				var exePath:String = shortPath + exeFile;
				var icoPath:String = shortPath + icoFile;
				
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"Set pathes: ",
							DebugLevel.INFO,
							" --> exe: " + exePath
								+ "<br> --> ico: " + icoPath
						);

				mdm.System.Registry.saveString(
						registryPath, 
						"\\" + regKey + "\\shell\\open\\command", 
						"", 
						exePath+" \"%1\""
					);
				mdm.System.Registry.saveString(
						registryPath, 
						"\\" + regKey + "\\DefaultIcon", 
						"", 
						icoPath + "," + icoIndex
					);
	
			} catch( error:TypeError ) {
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"Problem with accessing the registry",
							DebugLevel.ERROR,
							error.toString()
						);
				
				return false;
			}
			return true;
		}
		
	}
}