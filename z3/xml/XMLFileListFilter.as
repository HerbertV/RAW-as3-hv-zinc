/*
 *    ___   ____                        __  
 *   / _ | / __/______  ___  ___ ___ __/ /_ 
 *  / __ |/ _// __/ _ \/ _ \/ _ `/ // / __/ 
 * /_/ |_/___/_/  \___/_//_/\_,_/\_,_/\__/
 *
 * An unoffical custom aircraft, pilot design and editing tool 
 * for the out-of-print CRIMSON SKIES boardgame by created FASA. 
 * 
 * Inspired by Scott Janssens' CADET. 
 * Visit: http://www.foxforcefive.de/cs/
 * -----------------------------------------------------------------------------
 * @author: Herbert Veitengruber 
 * @version: 1.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.zinc.z3.xml
{
	/**
	 * =========================================================================
	 * Class XMLFileListFilter
	 * =========================================================================
	 * A filter obtject for filtering xml file lists.
	 */ 
	public class XMLFileListFilter
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		public var tag:String;
		public var attribute:String;
		public var filtervalue:String;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param t		the tag to look for
		 * @param a		the attribute from the tag
		 * @param f		the filter value the attribute needs to pass the check
		 */
		public function XMLFileListFilter(
				t:String, 
				a:String,
				f:String
			)
		{
			tag = t;
			attribute = a;
			filtervalue = f;
		}
	
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * check
		 * ---------------------------------------------------------------------
		 * checks the filter
		 * 
		 * @param xml
		 * 
		 * @return 
		 */
		public function check(xml:XML):Boolean
		{
			if( xml..child(this.tag).attribute(this.attribute) == this.filtervalue )
				return true;
			
			return false;
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
			return "XMLFileListFilter ["+tag+".@"+attribute+" == "+filtervalue+" ]";
		}
	
	}
}