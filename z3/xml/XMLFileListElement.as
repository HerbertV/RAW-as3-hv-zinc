﻿/*
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
		// for storing additional data associative
		private var userdata:Array = new Array();
		
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * @param f 
		 * @param v
		 * @param ud 
		 */
		public function XMLFileListElement(
				f:String, 
				v:String,
				ud:Array = null
			)
		{
			filename = f;
			viewname = v;
			
			if( ud != null )
				userdata = ud;
		}
	
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setUserData
		 * ---------------------------------------------------------------------
		 *
		 * @param key
		 * @param value
		 */
		public function setUserData(key:String, value:String)
		{
			this.userdata[key] = value;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getUserData
		 * ---------------------------------------------------------------------
		 *
		 * @return
		 */
		public function getUserData(key:String):String
		{
			return this.userdata[key];
		}
				
		
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