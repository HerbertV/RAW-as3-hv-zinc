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
		public var filtervalues:Array;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param t		the tag to look for
		 * @param a		the attribute from the tag
		 * @param f		the filter values as Array the attribute need only 
		 * 				to match one value to pass the test (or dependecy)
		 */
		public function XMLFileListFilter(
				t:String, 
				a:String,
				f:Array
			)
		{
			tag = t;
			attribute = a;
			filtervalues = f;
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
			var attrval:String = (xml.descendants(this.tag)[0]).attribute(this.attribute)[0];
			
			for( var i:int = 0; i < this.filtervalues.length; i++ )
			{
				if( attrval == this.filtervalues[i] )
					return true;
			}
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
			return "XMLFileListFilter ["+tag+".@"+attribute+" == "+filtervalues+" ]";
		}
	
	}
}