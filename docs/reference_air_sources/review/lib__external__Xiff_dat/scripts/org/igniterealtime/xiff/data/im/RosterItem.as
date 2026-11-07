package org.igniterealtime.xiff.data.im
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class RosterItem extends XMLStanza implements ISerializable
   {
      
      public static var ELEMENT:String = "item";
      
      private var myGroupNodes:Array;
      
      public function RosterItem(param1:XMLNode = null)
      {
         super();
         getNode().nodeName = ELEMENT;
         this.myGroupNodes = new Array();
         if(exists(param1))
         {
            param1.appendChild(getNode());
         }
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(!exists(this.jid))
         {
            return false;
         }
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
               case "group":
                  this.myGroupNodes.push(_loc2_[_loc3_]);
            }
         }
         return true;
      }
      
      public function addGroupNamed(param1:String, param2:int) : void
      {
         var _loc3_:XMLNode = addTextNode(getNode(),"group",param1);
         _loc3_.attributes.priority = param2.toString();
         this.myGroupNodes.push(_loc3_);
      }
      
      public function get groupNames() : Array
      {
         var _loc2_:String = null;
         var _loc3_:XMLNode = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.myGroupNodes)
         {
            _loc3_ = this.myGroupNodes[_loc2_].firstChild;
            if(_loc3_ != null)
            {
               _loc1_.push(_loc3_.nodeValue);
            }
         }
         return _loc1_;
      }
      
      public function get groupPriorities() : Array
      {
         var _loc2_:String = null;
         var _loc3_:XMLNode = null;
         var _loc4_:String = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.myGroupNodes)
         {
            _loc3_ = this.myGroupNodes[_loc2_];
            if(_loc3_.attributes.priority != null)
            {
               _loc4_ = _loc3_.attributes.priority;
               _loc1_.push(parseInt(_loc4_));
            }
            else
            {
               _loc1_.push(RosterGroup.UNDEFINED_PRIORITY);
            }
         }
         return _loc1_;
      }
      
      public function get groupCount() : Number
      {
         return this.myGroupNodes.length;
      }
      
      public function removeAllGroups() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.myGroupNodes)
         {
            this.myGroupNodes[_loc1_].removeNode();
         }
         this.myGroupNodes = new Array();
      }
      
      public function removeGroupByName(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for(_loc2_ in this.myGroupNodes)
         {
            if(this.myGroupNodes[_loc2_].nodeValue == param1)
            {
               this.myGroupNodes[_loc2_].removeNode();
               this.myGroupNodes.splice(Number(_loc2_),1);
               return true;
            }
         }
         return false;
      }
      
      public function get jid() : EscapedJID
      {
         return new EscapedJID(getNode().attributes.jid);
      }
      
      public function set jid(param1:EscapedJID) : void
      {
         getNode().attributes.jid = param1.toString();
      }
      
      public function get name() : String
      {
         return getNode().attributes.name;
      }
      
      public function set name(param1:String) : void
      {
         getNode().attributes.name = param1;
      }
      
      public function get subscription() : String
      {
         return getNode().attributes.subscription;
      }
      
      public function set subscription(param1:String) : void
      {
         getNode().attributes.subscription = param1;
      }
      
      public function get askType() : String
      {
         return getNode().attributes.ask;
      }
      
      public function set askType(param1:String) : void
      {
         getNode().attributes.ask = param1;
      }
      
      public function get pending() : Boolean
      {
         if(this.askType == RosterExtension.ASK_TYPE_SUBSCRIBE && (this.subscription == RosterExtension.SUBSCRIBE_TYPE_NONE || this.subscription == RosterExtension.SUBSCRIBE_TYPE_FROM))
         {
            return true;
         }
         return false;
      }
      
      public function get note() : String
      {
         var _loc3_:XMLNode = null;
         var _loc1_:XMLNode = getNode();
         var _loc2_:Array = _loc1_.childNodes;
         for each(_loc3_ in _loc2_)
         {
            if(Boolean(_loc3_.firstChild) && _loc3_.nodeName == "note")
            {
               return _loc3_.firstChild.nodeValue;
            }
         }
         return "";
      }
   }
}

