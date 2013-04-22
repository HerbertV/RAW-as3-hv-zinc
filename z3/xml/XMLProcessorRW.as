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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.zinc.z3.xml 
{
	// MDM ZINC Lib
	import mdm.*;
	
	import as3.hv.core.xml.XMLProcessorR;
	
	import as3.hv.components.progress.IProgressSymbol;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	/**
	 * =========================================================================
	 * Class XMLProcessorRW
	 * =========================================================================
	 * Read-Write XML Processor
	 * uses AS3 XML classes
	 */ 
	public class XMLProcessorRW 
			extends XMLProcessorR 
	{
	
		// =====================================================================
		// Variables
		// =====================================================================
		protected var savingFailed:Boolean;
		protected var savingFinished:Boolean;
		
		protected var isLoadingEventBased:Boolean;
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 * 
		 * @param loadEventBased
		 */
		public function XMLProcessorRW(loadEventBased:Boolean=false) 
		{
			super();
			
			this.isLoadingEventBased = loadEventBased;
			this.savingFailed = false;
			this.savingFinished = false;
		}
		
		// =====================================================================
		// functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * loadXML
		 * ---------------------------------------------------------------------
		 * @param filename
		 * @param progressSym
		 */
		override public function loadXML(
				filename:String, 
				progressSym:IProgressSymbol = null
			):void
		{
			if( this.isLoadingEventBased )
			{
				// evenetbased uses default URLLoader
				super.loadXML(filename, progressSym);
				return;
			}
			
			// ZINC Loader
			this.loadingFailed = false;
			this.loadingFinished = false;
			this.myFilename = filename;
			
			try 
			{
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"loading XML: ",
							DebugLevel.INFO,
							filename
						);
				
				var unicodeData:String = mdm.FileSystem.loadFileUnicode(filename);
				this.myXML = XML(unicodeData);
				this.loadingFinished = true;
			}
			catch (error:Error)
			{
				if( Console.isConsoleAvailable() )
				{
					Console.getInstance().writeln(
							"IO Error while loading XML: ",
							DebugLevel.ERROR,
							filename
								+ "<br>" + error.message
						);
					Console.getInstance().newLine();
				}
				this.myXML = null;
				this.loadingFailed = true;
   			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * saveXML
		 * ---------------------------------------------------------------------
		 * @param filename
		 * @param xmldoc
		 */
		public function saveXML(
				filename:String,
				xmldoc:XML = null
			):void
		{
			this.savingFailed = false;
			this.savingFinished = false;
			
			if( xmldoc != null )
				this.myXML = xmldoc;
		
			try 
			{
				if( Console.isConsoleAvailable() )
					Console.getInstance().writeln(
							"saving XML: ",
							DebugLevel.INFO,
							filename
						);
				
				mdm.FileSystem.saveFileUnicode(
						filename, 
						xmldoc.toXMLString()
					);
				this.savingFinished = true;
			}
			catch( error:Error )
			{
				if( Console.isConsoleAvailable() )
				{
					Console.getInstance().writeln(
								"IO Error while saving XML: ",
								DebugLevel.ERROR,
								filename
									+ "<br>" + error.message
							);
					Console.getInstance().newLine();
				}
				this.savingFailed = true;
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasSavingError
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function hasSavingError():Boolean
		{
			return savingFailed;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isSaved
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function isSaved():Boolean
		{
			return savingFinished;
		}
		
	}

}