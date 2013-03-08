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
 * @version: 2.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.zinc.z3.console.cmd
{
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	import as3.hv.core.console.cmd.IConsoleCommand;
	
	import as3.hv.zinc.z3.ZincLauncher;
	
	import flash.system.Capabilities;
	
	import mdm.*;
	
	// =========================================================================
	// Class CmdSystem
	// =========================================================================
	// System command for MDM Zinc 3
	public class CmdSystem 
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "system";
		
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function CmdSystem()
		{
			
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * doCommand
		 * ---------------------------------------------------------------------
		 * @see IConsoleCommand 
		 *
		 * @param args 	not use by system		
		 */
		public function doCommand(args:Array=null):void
		{
			var cpu:Number = mdm.System.CPUSpeed / 1000;
			var ram:Number = Math.round(mdm.System.RAMSize/1024/1024);
			
			var msg:String =  "<b>Systeminfo</b><br>" 
					+ "Flash Player: " + Capabilities.version 
					+ "<br>MDM Zinc Version: " + ZincLauncher.ZINC_VERSION
					+ "<br>"
					+ "<br>OS: " + mdm.System.winVerStringDetail 
					+ "<br>Service Pack: " + mdm.System.servicePack
					+ "<br>"
					+ "<br>RAM: " + ram + " GB"
					+ "<br>CPU: " + cpu +" GHz"
					+ "<br>Display: " + Capabilities.screenResolutionX 
					+ "x" + Capabilities.screenResolutionY
					+ "<br>"
					+ "<br>Application Path: " + mdm.Application.path;
					
			Console.getInstance().writeln(msg, DebugLevel.COMMAND);
			Console.getInstance().newLine();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * usesArguments
		 * ---------------------------------------------------------------------
		 * @see IConsoleCommand 
		 *
		 * @return
		 */
		public function usesArguments():Boolean
		{
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - [z3] shows system info";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "USAGE: " + CMD 
					+ " [no args]<br/> - Extended Zinc 3 system info";
		}
		
		
	}
}