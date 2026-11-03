package org.igniterealtime.xiff.bookmark
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class GroupChatBookmark implements ISerializable
   {
      
      private var _groupChatNode:XMLNode;
      
      private var _nickNode:XMLNode;
      
      private var _passwordNode:XMLNode;
      
      public function GroupChatBookmark(param1:String = null, param2:EscapedJID = null, param3:Boolean = false, param4:String = null, param5:String = null)
      {
         var _loc7_:XMLNode = null;
         var _loc8_:XMLNode = null;
         super();
         if(!param1 && !param2)
         {
            return;
         }
         if(!param1 || !param2)
         {
            throw new Error("Name and jid cannot be null, they must either both be null or an Object");
         }
         var _loc6_:XMLNode = new XMLNode(1,"conference");
         _loc6_.attributes.name = param1;
         _loc6_.attributes.jid = param2.toString();
         if(param3)
         {
            _loc6_.attributes.autojoin = "true";
         }
         if(Boolean(param4))
         {
            _loc7_ = new XMLNode(1,"nick");
            _loc7_.appendChild(new XMLNode(3,param4));
            _loc6_.appendChild(_loc7_);
         }
         if(Boolean(param5))
         {
            _loc8_ = new XMLNode(1,"password");
            _loc8_.appendChild(new XMLNode(3,param5));
            _loc6_.appendChild(_loc8_);
         }
         this._groupChatNode = _loc6_;
      }
      
      public function get name() : String
      {
         return this._groupChatNode.attributes.name;
      }
      
      public function get jid() : EscapedJID
      {
         return new EscapedJID(this._groupChatNode.attributes.jid);
      }
      
      public function get autoJoin() : Boolean
      {
         return this._groupChatNode.attributes.autojoin == "true";
      }
      
      public function set autoJoin(param1:Boolean) : void
      {
         this._groupChatNode.attributes.autojoin = param1.toString();
      }
      
      public function get nickname() : String
      {
         return this._nickNode.firstChild.nodeValue;
      }
      
      public function get password() : String
      {
         return this._passwordNode.firstChild.nodeValue;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = this._groupChatNode.cloneNode(true);
         var _loc3_:XMLNode = this._nickNode != null ? this._nickNode.cloneNode(true) : null;
         var _loc4_:XMLNode = this._passwordNode != null ? this._passwordNode.cloneNode(true) : null;
         if(_loc3_ != null)
         {
            _loc2_.appendChild(_loc3_);
         }
         if(_loc4_ != null)
         {
            _loc2_.appendChild(_loc4_);
         }
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:XMLNode = null;
         this._groupChatNode = param1.cloneNode(false);
         var _loc2_:Array = param1.childNodes;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.nodeName == "nick")
            {
               this._nickNode = _loc3_.cloneNode(true);
            }
            else if(_loc3_.nodeName == "password")
            {
               this._passwordNode = _loc3_.cloneNode(true);
            }
         }
         return true;
      }
   }
}

