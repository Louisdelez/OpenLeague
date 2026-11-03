package mx.rpc.xml
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   [ExcludeClass]
   public class NamespaceUtil
   {
      
      public function NamespaceUtil()
      {
         super();
      }
      
      public static function getLocalName(xmlNode:XMLNode) : String
      {
         var name:String = xmlNode.nodeName;
         var myPrefixIndex:int = name.indexOf(":");
         if(myPrefixIndex != -1)
         {
            name = name.substring(myPrefixIndex + 1);
         }
         return name;
      }
      
      public static function getElementsByLocalName(xmlNode:XMLNode, lname:String) : Array
      {
         var elements:Array = null;
         var numChildren:uint = 0;
         var i:uint = 0;
         var subElement:XMLNode = null;
         if(xmlNode is XMLDocument)
         {
            elements = getElementsByLocalName(xmlNode.firstChild,lname);
         }
         else
         {
            elements = [];
            if(getLocalName(xmlNode) == lname)
            {
               elements.push(xmlNode);
            }
            numChildren = xmlNode.childNodes.length;
            for(i = 0; i < numChildren; i++)
            {
               subElement = xmlNode.childNodes[i];
               if(getLocalName(subElement) == lname)
               {
                  elements.push(subElement);
               }
            }
         }
         return elements;
      }
   }
}

