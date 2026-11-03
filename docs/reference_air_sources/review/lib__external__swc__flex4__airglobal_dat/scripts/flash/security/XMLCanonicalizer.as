package flash.security
{
   [API("661")]
   [native(cls="XMLCanonicalizerClass",instance="XMLCanonicalizerObject",methods="auto",construct="native")]
   internal class XMLCanonicalizer
   {
      
      public function XMLCanonicalizer()
      {
         super();
      }
      
      private function sortNameSpace(nsA:Namespace, nsB:Namespace) : int
      {
         if(nsA.prefix < nsB.prefix)
         {
            return -1;
         }
         if(nsA.prefix == nsB.prefix)
         {
            return 0;
         }
         return 1;
      }
      
      private native function c14nTransform(param1:String) : String;
      
      public function CanonicalizeXML(xml:XML) : String
      {
         var currentPrettyPrint:Boolean = Boolean(XML.prettyPrinting);
         XML.prettyPrinting = false;
         var xmlStr:String = xml.toXMLString();
         var outStr:String = this.c14nTransform(xmlStr);
         XML.prettyPrinting = currentPrettyPrint;
         if(outStr == null)
         {
            throw new Error("error encountered while canonicalizing " + xmlStr);
         }
         return outStr;
      }
      
      public function CanonicalizeXMLList(xmlList:XMLList) : String
      {
         var currentPrettyPrint:Boolean = Boolean(XML.prettyPrinting);
         XML.prettyPrinting = false;
         var retVal:String = this.CanonicalizeString(xmlList.toXMLString());
         XML.prettyPrinting = currentPrettyPrint;
         return retVal;
      }
      
      private function CanonicalizeString(xmlString:String) : String
      {
         return this.expandEmptyXMLTags(xmlString);
      }
      
      private function expandEmptyXMLTags(inputStr:String) : String
      {
         var findEmptyTagExp:RegExp = /<[^>]*?\/>/gms;
         var tagIdx:int = inputStr.search(inputStr);
         return inputStr.replace(findEmptyTagExp,this.replaceEmptyTags);
      }
      
      private function replaceEmptyTags() : String
      {
         var endTag:String = null;
         var findTag:RegExp = /(\/|\s)/;
         var tagIdx:int = int(arguments[0].search(findTag));
         if(tagIdx >= 0)
         {
            endTag = "</" + arguments[0].substr(1,tagIdx - 1) + ">";
            return arguments[0].substring(0,arguments[0].length - 2) + ">" + endTag;
         }
         return arguments[0];
      }
   }
}

