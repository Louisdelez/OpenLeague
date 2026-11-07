package mx.utils
{
   import flash.xml.XMLDocument;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class XMLUtil
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function XMLUtil()
      {
         super();
      }
      
      public static function createXMLDocument(str:String) : XMLDocument
      {
         var xml:XMLDocument = new XMLDocument();
         xml.ignoreWhite = true;
         xml.parseXML(str);
         return xml;
      }
      
      public static function qnamesEqual(qname1:QName, qname2:QName) : Boolean
      {
         return qname1.uri == qname2.uri && qname1.localName == qname2.localName;
      }
      
      public static function qnameToString(qname:QName) : String
      {
         return Boolean(qname.uri) && qname.uri != "" ? qname.uri + ":" + qname.localName : qname.localName;
      }
      
      public static function getAttributeByQName(xml:XML, attrQName:QName) : XMLList
      {
         var attribute:XML = null;
         var thisQName:QName = null;
         var attributes:XMLList = xml.attribute(attrQName);
         for each(attribute in attributes)
         {
            thisQName = attribute.name();
            if(thisQName.uri == attrQName.uri)
            {
               return new XMLList(attribute);
            }
         }
         return new XMLList();
      }
   }
}

