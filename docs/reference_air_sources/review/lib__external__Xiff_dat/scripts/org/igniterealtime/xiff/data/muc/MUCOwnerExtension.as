package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class MUCOwnerExtension extends MUCBaseExtension implements IExtension
   {
      
      public static var NS:String = "http://jabber.org/protocol/muc#owner";
      
      public static var ELEMENT:String = "query";
      
      private var myDestroyNode:XMLNode;
      
      public function MUCOwnerExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public function getNS() : String
      {
         return MUCOwnerExtension.NS;
      }
      
      public function getElementName() : String
      {
         return MUCOwnerExtension.ELEMENT;
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         super.deserialize(param1);
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            switch(_loc2_[_loc3_].nodeName)
            {
               case "destroy":
                  this.myDestroyNode = _loc2_[_loc3_];
            }
         }
         return true;
      }
      
      override public function serialize(param1:XMLNode) : Boolean
      {
         return super.serialize(param1);
      }
      
      public function destroy(param1:String, param2:EscapedJID) : void
      {
         var _loc3_:XMLNode = null;
         this.myDestroyNode = ensureNode(this.myDestroyNode,"destroy");
         for each(_loc3_ in this.myDestroyNode.childNodes)
         {
            _loc3_.removeNode();
         }
         if(exists(param1))
         {
            replaceTextNode(this.myDestroyNode,undefined,"reason",param1);
         }
         if(exists(param2))
         {
            this.myDestroyNode.attributes.jid = param2.toString();
         }
      }
   }
}

