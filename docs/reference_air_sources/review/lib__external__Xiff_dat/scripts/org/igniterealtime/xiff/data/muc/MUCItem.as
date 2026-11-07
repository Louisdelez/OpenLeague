package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class MUCItem extends XMLStanza implements ISerializable
   {
      
      public static var ELEMENT:String = "item";
      
      private var myActorNode:XMLNode;
      
      private var myReasonNode:XMLNode;
      
      public function MUCItem(param1:XMLNode = null)
      {
         super();
         getNode().nodeName = ELEMENT;
         if(exists(param1))
         {
            param1.appendChild(getNode());
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
         var _loc3_:String = null;
         setNode(param1);
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            switch(_loc2_[_loc3_].nodeName)
            {
               case "actor":
                  this.myActorNode = _loc2_[_loc3_];
                  break;
               case "reason":
                  this.myReasonNode = _loc2_[_loc3_];
            }
         }
         return true;
      }
      
      public function get actor() : EscapedJID
      {
         return new EscapedJID(this.myActorNode.attributes.jid);
      }
      
      public function set actor(param1:EscapedJID) : void
      {
         this.myActorNode = ensureNode(this.myActorNode,"actor");
         this.myActorNode.attributes.jid = param1.toString();
      }
      
      public function get reason() : String
      {
         return this.myReasonNode.firstChild.nodeValue;
      }
      
      public function set reason(param1:String) : void
      {
         this.myReasonNode = replaceTextNode(getNode(),this.myReasonNode,"reason",param1);
      }
      
      public function get affiliation() : String
      {
         return getNode().attributes.affiliation;
      }
      
      public function set affiliation(param1:String) : void
      {
         getNode().attributes.affiliation = param1;
      }
      
      public function get jid() : EscapedJID
      {
         if(getNode().attributes.jid == null)
         {
            return null;
         }
         return new EscapedJID(getNode().attributes.jid);
      }
      
      public function set jid(param1:EscapedJID) : void
      {
         getNode().attributes.jid = param1.toString();
      }
      
      public function get nick() : String
      {
         return getNode().attributes.nick;
      }
      
      public function set nick(param1:String) : void
      {
         getNode().attributes.nick = param1;
      }
      
      public function get role() : String
      {
         return getNode().attributes.role;
      }
      
      public function set role(param1:String) : void
      {
         getNode().attributes.role = param1;
      }
   }
}

