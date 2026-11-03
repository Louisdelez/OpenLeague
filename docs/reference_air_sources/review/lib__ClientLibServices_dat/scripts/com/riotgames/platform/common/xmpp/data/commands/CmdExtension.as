package com.riotgames.platform.common.xmpp.data.commands
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class CmdExtension extends Extension implements ISerializable
   {
      
      public static var NS:String = "http://jabber.org/protocol/commands";
      
      public static var ELEMENT:String = "command";
      
      public var myService:EscapedJID;
      
      public function CmdExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(param1 != getNode().parentNode)
         {
            param1.appendChild(getNode().cloneNode(true));
         }
         return true;
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
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         setNode(param1);
         return true;
      }
      
      public function get serviceNode() : String
      {
         return getNode().parentNode.attributes.node;
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
      
      public function set serviceNode(param1:String) : void
      {
         var _loc2_:XMLNode = this.getNode();
         getNode().parentNode.attributes.node = param1;
      }
   }
}

