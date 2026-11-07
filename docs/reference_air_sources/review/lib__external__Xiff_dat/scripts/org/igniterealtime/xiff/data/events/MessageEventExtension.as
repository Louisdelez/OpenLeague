package org.igniterealtime.xiff.data.events
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class MessageEventExtension implements IExtension, ISerializable
   {
      
      public function MessageEventExtension()
      {
         super();
      }
      
      public function getNS() : String
      {
         return "jabber:x:event";
      }
      
      public function getElementName() : String
      {
         return "x";
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = new XMLNode(1,"x");
         _loc2_.attributes.xmlns = "jabber:x:event";
         var _loc3_:XMLNode = new XMLNode(1,"composing");
         _loc2_.appendChild(_loc3_);
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         return true;
      }
   }
}

