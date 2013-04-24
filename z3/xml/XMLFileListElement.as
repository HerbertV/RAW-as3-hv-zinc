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
	/**
	 * =========================================================================
	 * Class XMLFileListElement
	 * =========================================================================
	 */ 
	public class XMLFileListElement
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		// contains the relative path to the file
		public var filename:String;
		// needs to be public for array sort on 
		public var viewname:String;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * @param f
		 * @param v
		 */
		public function FileListElement(
				f:String, 
				v:String
			)
		{
			filename = f;
			viewname = v;
		}
	
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * toString
		 * ---------------------------------------------------------------------
		 *
		 * @return Object as string
		 */
		public function toString():String
		{
			return "XMLFileListElement ["+filename+", "+viewname+" ]";
		}
	
	}
}