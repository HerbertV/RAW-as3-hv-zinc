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
 * Copyright (c) 2010-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.zinc.z3
{
	import as3.hv.core.console.Console;
	
	import as3.hv.zinc.z3.console.cmd.*;
	
	import flash.display.MovieClip;

	import mdm.*;
	
	// =========================================================================
	// Class ZincLauncher
	// =========================================================================
	// Launcher for Zinc based Projects
	// Needs SWC  "{mdm}Script 3.0 AS3 for Flash CS3"
	//
	public class ZincLauncher
	{
		
		// =====================================================================
		// Constants
		// =====================================================================
		public static const VERSION:String = "1.0.0";
		
		// final Zinc 3 version
		public static const ZINC_VERSION:String = "3.0.24";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		// becomes true if Zinc Wrapper is loaded
		private static var ready:Boolean = false;
		// becomes true if Zinc Wrapper failed to load
		private static var error:Boolean = false;
		
		// additional callback function
		private static var funcInitCallback:Function = null;
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * 
		 * @param mainClip
		 * @param callback
		 */
		public static function init( 
				mainClip:MovieClip,
				callback:Function=null
			):void 
		{
			ZincLauncher.funcInitCallback = callback;
			
			mdm.Application.init(mainClip, onInitHandler);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 */
		public static function isReady():Boolean
		{
			return ZincLauncher.ready;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasError
		 * ---------------------------------------------------------------------
		 */
		public static function hasError():Boolean
		{
			return ZincLauncher.error;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * onInitHandler
		 * ---------------------------------------------------------------------
		 */
		private static function onInitHandler():void
		{
			try 
			{
				if( Console.isConsoleAvailable() )
				{
					// register zinc specific console commands
					// System CMD override
					Console.getInstance().registerCommand( 
							CmdSystem.CMD, 
							new CmdSystem() 
						);
					
					// show zinc is ready
					Console.getInstance().writeln(
							"<b> &gt; &gt; ZINC READY &lt; &lt; </b>",
							DebugLevel.COMMAND,
							null,
							false
						);
					Console.getInstance().newLine();	
				}
				
				if( ZincLauncher.funcInitCallback != null )
					ZincLauncher.funcInitCallback();
				
				ZincLauncher.ready = true;
				
			} catch( error:TypeError ) {
				
				if( Console.isConsoleAvailable() )
				{
					// show zinc is ready
					Console.getInstance().writeln(
							"Zinc launch failed: ",
							DebugLevel.FATAL_ERROR,
							" --> "+ error.toString();
						);
				}
				ZincLauncher.error = true;
			}
		}
		
	}
}