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
	import mdm.*;
	
	import as3.hv.core.utils.StringHelper;
	import as3.hv.core.xml.AbstractXMLProcessor;
	
	/**
	 * =========================================================================
	 * Class XMLFileList
	 * =========================================================================
	 * for generating file lists from xmls.
	 * where the view name is chosen from one tag.
	 * 
	 * Supports filtering by attributs.
	 */ 
	public class XMLFileList
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// file extension
		private var extension:String;
		// tag used for view.
		private var viewTag:String;
		
		private var filters:Array;
		
		private var xmlProcessor:XMLProcessorRW;
		
		private var lastRootFolder:String = "";
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param ext
		 * @param viewTag
		 */
		public function XMLFileList(
				ext:String,
				view:String
			)
		{
			this.extension = ext;
			this.viewTag = view;
			
			this.filters = new Array();
			
			this.xmlProcessor = new XMLProcessorRW();
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * clearFilters
		 * ---------------------------------------------------------------------
		 * removes all filters
		 */
		public function clearFilters():void
		{
			this.filters = new Array();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addFilter
		 * ---------------------------------------------------------------------
		 * adds a new filter. 
		 * 
		 * While generating a file list each filter added this way is checked
		 * against the loaded xml. If the check was success the file is added 
		 * to the list.
		 * 
		 * @param t		the tag to look for
		 * @param a		the attribute from the tag
		 * @param f		the filter value the attribute needs to pass the check
		 */
		public function addFilter(
				t:String, 
				a:String, 
				f:String
			):void
		{
			this.filters.push(new XMLFileListFilter(t, a, f));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * generate
		 * ---------------------------------------------------------------------
		 * generates an array of FileListElements. 
		 * Looks also into subpathes
		 *
		 * @param root (absolute path)
		 * @param path	releative to root this part is stored with the filename.
		 * @param basetag	
		 *
		 * @return 
		 */
		public function generate(
				root:String,
				path:String,
				basetag:String
			):Array
		{
			var loadedxml:XML;
			var arr:Array = new Array();
			var myFiles:Array = mdm.FileSystem.getFileList(
					root + path, 
					"*" + this.extension
				);
			
			lastRootFolder = root;
				
			for( var i:int=0; i<myFiles.length; i++ ) 
			{
				xmlProcessor.loadXML(path + myFiles[i]);
				loadedxml = xmlProcessor.getXML();
				
				if( loadedxml == null ) 
					continue;
					
				if( !AbstractXMLProcessor.checkDoc(loadedxml)
						|| loadedxml.child(basetag).length() < 1 )
					continue;
				
				if( !checkFilters(loadedxml) )
					continue;
				
				// store the relative path
				var fle:FileListElement = new FileListElement(
						path + myFiles[i],
						loadedxml..child(viewTag)
					);
				arr.push(fle);
			}
			
			var myDirs:Array = mdm.FileSystem.getFolderList(root + path);
			
			// now go one folder deeper
			for ( var j:int = 0; j < myDirs.length; j++)
			{
				var subarr:Array = generate(
						root, 
						path + myDirs[j], 
						basetag
					);
				if ( subarr.length > 0 )
					arr = arr.concat(subarr);
			}
			
			return arr;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * filter
		 * ---------------------------------------------------------------------
		 * for filtering an existing XMLFileList afterwards.
		 *
		 * @param filelist Array of XMLFileListElement
		 * @param filters Array of XMLFileListFilter
	     *
		 * @return the filterd array
		 */
		public function filter(
				filelist:Array, 
				filters:Array
			):Array
		{
			var arr:Array = new Array();
			this.filters = filters;
			
			for( var i:int=0; i<filelist.length; i++ ) 
			{
				xmlProcessor.loadXML(lastRootFolder + filelist[i].filename);
				loadedxml = xmlProcessor.getXML();
				
				if( loadedxml == null ) 
					continue;
				
				if( checkFilters(loadedxml) )
					arr.push( filelist[i] );
			}
			return arr;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * checkFilters
		 * ---------------------------------------------------------------------
		 * @param	xml
		 * 
		 * @return
		 */
		private function checkFilters(xml:XML):Boolean
		{
			for( var i:int = 0; i < filters.length; i++ )
				if( !XMLFileListFilter(filters[i]).check(xml) )
					return false;
			
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * sort
		 * ---------------------------------------------------------------------
		 * sorts a XMLFileListElement array by viewname
		 * 
		 * @param	arr
		 */
		public function sort(arr:Array):Array
		{
			if( arr.length > 1 ) 
				arr.sortOn(
						"viewname",
						Array.CASEINSENSITIVE
					);
					
			return arr;
		}
	
	}
}