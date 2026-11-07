package org.igniterealtime.xiff.data.im
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class RosterExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "jabber:iq:roster";
      
      public static var ELEMENT:String = "query";
      
      public static var SUBSCRIBE_TYPE_NONE:String = "none";
      
      public static var SUBSCRIBE_TYPE_TO:String = "to";
      
      public static var SUBSCRIBE_TYPE_FROM:String = "from";
      
      public static var SUBSCRIBE_TYPE_BOTH:String = "both";
      
      public static var SUBSCRIBE_TYPE_REMOVE:String = "remove";
      
      public static var ASK_TYPE_NONE:String = "none";
      
      public static var ASK_TYPE_SUBSCRIBE:String = "subscribe";
      
      public static var ASK_TYPE_UNSUBSCRIBE:String = "unsubscribe";
      
      public static var SHOW_UNAVAILABLE:String = "unavailable";
      
      public static var SHOW_PENDING:String = "Pending";
      
      private static var staticDepends:Array = [ExtensionClassRegistry];
      
      private var myItems:Array = [];
      
      public function RosterExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(RosterExtension);
      }
      
      public function getNS() : String
      {
         return RosterExtension.NS;
      }
      
      public function getElementName() : String
      {
         return RosterExtension.ELEMENT;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:XMLNode = getNode();
         for(_loc3_ in this.myItems)
         {
            if(!this.myItems[_loc3_].serialize(_loc2_))
            {
               return false;
            }
         }
         if(!exists(getNode().parentNode))
         {
            param1.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:RosterItem = null;
         setNode(param1);
         this.removeAllItems();
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            switch(_loc2_[_loc3_].nodeName)
            {
               case "item":
                  _loc4_ = new RosterItem(getNode());
                  if(!_loc4_.deserialize(_loc2_[_loc3_]))
                  {
                     return false;
                  }
                  this.myItems.push(_loc4_);
            }
         }
         return true;
      }
      
      public function getAllItems() : Array
      {
         return this.myItems;
      }
      
      public function getItemByJID(param1:EscapedJID) : RosterItem
      {
         var _loc2_:String = null;
         for(_loc2_ in this.myItems)
         {
            if(this.myItems[_loc2_].jid == param1.toString())
            {
               return this.myItems[_loc2_];
            }
         }
         return null;
      }
      
      public function addItem(param1:EscapedJID = null, param2:String = "", param3:String = "", param4:Array = null, param5:Array = null) : void
      {
         var _loc7_:int = 0;
         var _loc6_:RosterItem = new RosterItem(getNode());
         if(exists(param1))
         {
            _loc6_.jid = param1;
         }
         if(exists(param2))
         {
            _loc6_.subscription = param2;
         }
         if(exists(param3))
         {
            _loc6_.name = param3;
         }
         if(exists(param4) && exists(param5))
         {
            _loc7_ = 0;
            while(_loc7_ < param4.length)
            {
               _loc6_.addGroupNamed(param4[_loc7_],param5[_loc7_]);
               _loc7_++;
            }
         }
      }
      
      public function removeAllItems() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.myItems)
         {
            this.myItems[_loc1_].setNode(null);
         }
         this.myItems = new Array();
      }
   }
}

