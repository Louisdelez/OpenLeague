package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   
   public class Presence extends XMPPStanza implements ISerializable
   {
      
      public static const UNAVAILABLE_TYPE:String = "unavailable";
      
      public static const PROBE_TYPE:String = "probe";
      
      public static const SUBSCRIBE_TYPE:String = "subscribe";
      
      public static const UNSUBSCRIBE_TYPE:String = "unsubscribe";
      
      public static const SUBSCRIBED_TYPE:String = "subscribed";
      
      public static const UNSUBSCRIBED_TYPE:String = "unsubscribed";
      
      public static const ERROR_TYPE:String = "error";
      
      public static const MOBILE_TYPE:String = "mobile";
      
      public static const JOIN_TYPE:String = "join";
      
      public static const LEAVE_TYPE:String = "leave";
      
      public static const SHOW_AWAY:String = "away";
      
      public static const SHOW_CHAT:String = "chat";
      
      public static const SHOW_DND:String = "dnd";
      
      public static const SHOW_OFFLINE:String = "offline";
      
      public static const SHOW_XA:String = "xa";
      
      public static const SHOW_CHAT_MOBILE:String = "chatMobile";
      
      public static const SHOW_PRIORITIES:Array = [Presence.SHOW_DND,Presence.SHOW_CHAT,Presence.SHOW_CHAT_MOBILE];
      
      public static const MUC_ROOM_FULL:String = "muc-room-full";
      
      private var myShowNode:XMLNode;
      
      private var myStatusNode:XMLNode;
      
      private var myPriorityNode:XMLNode;
      
      private var delayed:Boolean = false;
      
      private var _timestamp:Date;
      
      public function Presence(param1:EscapedJID = null, param2:EscapedJID = null, param3:String = null, param4:String = null, param5:String = null, param6:Number = 0)
      {
         super(param1,param2,param3,null,"presence");
         this.show = param4;
         this.status = param5;
         this.priority = param6;
         this._timestamp = new Date();
      }
      
      override public function serialize(param1:XMLNode) : Boolean
      {
         return super.serialize(param1);
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc2_:Boolean = super.deserialize(param1);
         if(_loc2_)
         {
            _loc3_ = param1.childNodes;
            for(_loc4_ in _loc3_)
            {
               switch(_loc3_[_loc4_].nodeName)
               {
                  case "show":
                     this.myShowNode = _loc3_[_loc4_];
                     break;
                  case "status":
                     this.myStatusNode = _loc3_[_loc4_];
                     break;
                  case "priority":
                     this.myPriorityNode = _loc3_[_loc4_];
                     break;
                  case "delay":
                     this.delayed = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function get show() : String
      {
         if(!this.myShowNode || !exists(this.myShowNode.firstChild))
         {
            return null;
         }
         return this.myShowNode.firstChild.nodeValue;
      }
      
      public function set show(param1:String) : void
      {
         if(param1 != SHOW_AWAY && param1 != SHOW_CHAT && param1 != SHOW_DND && param1 != SHOW_XA && param1 != null && param1 != "")
         {
            throw new Error("Invalid show value: " + param1 + " for presence");
         }
         if(Boolean(this.myShowNode) && (param1 == null || param1 == ""))
         {
            this.myShowNode.removeNode();
            this.myShowNode = null;
         }
         this.myShowNode = replaceTextNode(getNode(),this.myShowNode,"show",param1);
      }
      
      public function get status() : String
      {
         if(this.myStatusNode == null || this.myStatusNode.firstChild == null)
         {
            return null;
         }
         return this.myStatusNode.firstChild.nodeValue;
      }
      
      public function set status(param1:String) : void
      {
         this.myStatusNode = replaceTextNode(getNode(),this.myStatusNode,"status",param1);
      }
      
      public function get priority() : Number
      {
         if(this.myPriorityNode == null)
         {
            return NaN;
         }
         var _loc1_:Number = Number(this.myPriorityNode.firstChild.nodeValue);
         if(isNaN(_loc1_))
         {
            return NaN;
         }
         return _loc1_;
      }
      
      public function set priority(param1:Number) : void
      {
         this.myPriorityNode = replaceTextNode(getNode(),this.myPriorityNode,"priority",param1.toString());
      }
      
      public function isDelayed() : Boolean
      {
         return this.delayed;
      }
      
      public function get timestamp() : Date
      {
         return this._timestamp;
      }
   }
}

