package org.igniterealtime.xiff.data.disco
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class DiscoExtension extends Extension implements ISerializable
   {
      
      public static var NS:String = "http://jabber.org/protocol/disco";
      
      public static var ELEMENT:String = "query";
      
      public var myService:EscapedJID;
      
      public function DiscoExtension(param1:XMLNode)
      {
         super(param1);
      }
      
      public function get serviceNode() : String
      {
         return getNode().parentNode.attributes.node;
      }
      
      public function set serviceNode(param1:String) : void
      {
         getNode().parentNode.attributes.node = param1;
      }
      
      public function get service() : EscapedJID
      {
         var _loc1_:XMLNode = getNode().parentNode;
         if(_loc1_.attributes.type == "result")
         {
            return new EscapedJID(_loc1_.attributes.from);
         }
         return new EscapedJID(_loc1_.attributes.to);
      }
      
      public function set service(param1:EscapedJID) : void
      {
         var _loc2_:XMLNode = getNode().parentNode;
         if(_loc2_.attributes.type == "result")
         {
            _loc2_.attributes.from = param1.toString();
         }
         else
         {
            _loc2_.attributes.to = param1.toString();
         }
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(param1 != getNode().parentNode)
         {
            param1.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         setNode(param1);
         return true;
      }
   }
}

