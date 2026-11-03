package org.igniterealtime.xiff.data
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class XMLStanza extends ExtensionContainer implements INodeProxy, IExtendable
   {
      
      public static var XMLFactory:XMLDocument = new XMLDocument();
      
      private var myXML:XMLNode;
      
      public function XMLStanza()
      {
         super();
         this.myXML = XMLStanza.XMLFactory.createElement("");
      }
      
      public static function exists(param1:*) : Boolean
      {
         if(param1 != null && param1 !== undefined)
         {
            return true;
         }
         return false;
      }
      
      public function addTextNode(param1:XMLNode, param2:String, param3:String) : XMLNode
      {
         var _loc4_:XMLNode = XMLStanza.XMLFactory.createElement(param2);
         _loc4_.appendChild(XMLFactory.createTextNode(param3));
         param1.appendChild(_loc4_);
         return _loc4_;
      }
      
      public function ensureNode(param1:XMLNode, param2:String) : XMLNode
      {
         if(!exists(param1))
         {
            param1 = XMLStanza.XMLFactory.createElement(param2);
            this.getNode().appendChild(param1);
         }
         return param1;
      }
      
      public function replaceTextNode(param1:XMLNode, param2:XMLNode, param3:String, param4:String) : XMLNode
      {
         var _loc5_:XMLNode = null;
         if(param2 != null)
         {
            param2.removeNode();
         }
         if(exists(param4))
         {
            _loc5_ = XMLStanza.XMLFactory.createElement(param3);
            if(param4.length > 0)
            {
               _loc5_.appendChild(XMLStanza.XMLFactory.createTextNode(param4));
            }
            param1.appendChild(_loc5_);
         }
         return _loc5_;
      }
      
      public function getNode() : XMLNode
      {
         return this.myXML;
      }
      
      public function setNode(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = this.myXML.parentNode;
         this.myXML.removeNode();
         this.myXML = param1;
         if(exists(this.myXML) && _loc2_ != null)
         {
            _loc2_.appendChild(this.myXML);
         }
         return true;
      }
   }
}

