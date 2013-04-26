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
	 * Class XMLFileListUserDataQuery
	 * =========================================================================
	 * for searching the xml for specific entries and storing them
	 * as userdate into XMLFileListElement.
	 */ 
	public class XMLFileListUserDataQuery 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		public var tag:String;
		public var attribute:String;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param t		the tag to look for
		 * @param a		the attribute from the tag
		 */
		public function XMLFileListUserDataQuery(
				t:String, 
				a:String
			)
		{
			this.tag = t;
			this.attribute = a;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
				
		/**
		 * ---------------------------------------------------------------------
		 * createKey
		 * ---------------------------------------------------------------------
		 * creates a key for the XMLFileListElement userdata associative array
		 * 
		 * @param t
		 * @param a
		 * 
		 * @return
		 */
		public static function createKey(t:String, a:String):String
		{
			return t + "@" + a;
		}
				
		/**
		 * ---------------------------------------------------------------------
		 * getKey
		 * ---------------------------------------------------------------------
		 * @return
		 */
		public function getKey():String
		{
			return XMLFileListUserDataQuery.createKey(this.tag,this.attribute);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * query
		 * ---------------------------------------------------------------------
		 * looks for the attribute entry
		 * 
		 * @param xml
		 * 
		 * @return
		 */
		public function query(xml:XML):String
		{
			var val:String = (xml.descendants(this.tag)[0]).attribute(this.attribute);
			return val;
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
			return "XMLFileListUserDataQuery ["+tag+".@"+attribute+"]";
		}
	}

}