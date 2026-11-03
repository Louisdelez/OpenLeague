package org.igniterealtime.xiff.data.im
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   
   public class RosterItemVO extends EventDispatcher implements Contact
   {
      
      private static var allContacts:Object = {};
      
      private var _jid:UnescapedJID;
      
      private var _displayName:String;
      
      private var _comparableDisplayName:String;
      
      private var _groups:Array = [];
      
      private var _askType:String;
      
      private var _subscribeType:String;
      
      private var _status:String;
      
      private var _show:String;
      
      private var _priority:Number;
      
      private var _online:Boolean = false;
      
      private var _duoQueueRestricted:Boolean = false;
      
      private var _rankedRestricted:Boolean = false;
      
      private var _isOnMobile:Boolean = false;
      
      private var resourcePresences:Dictionary = new Dictionary();
      
      private var _1704846688localUserData:Object;
      
      private var _3387378note:String;
      
      public function RosterItemVO(param1:UnescapedJID)
      {
         super();
         this.jid = param1;
      }
      
      public static function get(param1:UnescapedJID, param2:Boolean) : RosterItemVO
      {
         var _loc3_:RosterItemVO = null;
         var _loc4_:String = null;
         if(param1 != null)
         {
            _loc4_ = param1.bareJID;
            _loc3_ = allContacts[_loc4_];
            if(!_loc3_ && param2)
            {
               allContacts[_loc4_] = _loc3_ = new RosterItemVO(new UnescapedJID(_loc4_));
            }
         }
         return _loc3_;
      }
      
      public static function remove(param1:UnescapedJID) : Boolean
      {
         var _loc2_:String = param1.bareJID;
         var _loc3_:RosterItemVO = allContacts[_loc2_];
         var _loc4_:Boolean = false;
         if(_loc3_ != null)
         {
            allContacts[_loc2_] = null;
            delete allContacts[_loc2_];
            _loc4_ = true;
         }
         return _loc4_;
      }
      
      public static function removeAll() : void
      {
         allContacts = {};
      }
      
      public function set uid(param1:String) : void
      {
      }
      
      public function get uid() : String
      {
         return this._jid.toString();
      }
      
      private function set _1978787128isDuoQueueRestricted(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._duoQueueRestricted;
         this._duoQueueRestricted = param1;
         if(_loc2_ != param1)
         {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"duoQueueRestricted",_loc2_,this._duoQueueRestricted));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isDuoQueueRestricted() : Boolean
      {
         return this._duoQueueRestricted;
      }
      
      private function set _1123818960isRankedRestricted(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._rankedRestricted;
         this._rankedRestricted = param1;
         if(_loc2_ != param1)
         {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedRestricted",_loc2_,this._rankedRestricted));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isRankedRestricted() : Boolean
      {
         return this._rankedRestricted;
      }
      
      private function set _1572088740subscribeType(param1:String) : void
      {
         var _loc2_:String = this.subscribeType;
         this._subscribeType = param1;
         PropertyChangeEvent.createUpdateEvent(this,"subscribeType",_loc2_,this.subscribeType);
         dispatchEvent(new Event("changeSubscription"));
      }
      
      [Bindable(event="propertyChange")]
      public function get subscribeType() : String
      {
         return this._subscribeType;
      }
      
      private function set _1165461084priority(param1:Number) : void
      {
         var _loc2_:Number = this.priority;
         this._priority = param1;
         PropertyChangeEvent.createUpdateEvent(this,"priority",_loc2_,this.priority);
      }
      
      [Bindable(event="propertyChange")]
      public function get priority() : Number
      {
         return this._priority;
      }
      
      private function set _712664749askType(param1:String) : void
      {
         var _loc2_:String = this.askType;
         var _loc3_:Boolean = this.pending;
         this._askType = param1;
         PropertyChangeEvent.createUpdateEvent(this,"askType",_loc2_,this.askType);
         PropertyChangeEvent.createUpdateEvent(this,"pending",_loc3_,this.pending);
         dispatchEvent(new Event("changeAskType"));
      }
      
      [Bindable(event="propertyChange")]
      public function get askType() : String
      {
         return this._askType;
      }
      
      private function set _892481550status(param1:String) : void
      {
         var _loc2_:String = this.status;
         this._status = param1;
         PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,this.status);
      }
      
      [Bindable(event="propertyChange")]
      public function get status() : String
      {
         if(Boolean(this._status))
         {
            return this._status;
         }
         return this.online ? "Available" : "Offline";
      }
      
      private function set _1012222381online(param1:Boolean) : void
      {
         if(param1 == this.online)
         {
            return;
         }
         var _loc2_:Boolean = this.online;
         this._online = param1;
         PropertyChangeEvent.createUpdateEvent(this,"online",_loc2_,this.online);
      }
      
      [Bindable(event="propertyChange")]
      public function get online() : Boolean
      {
         return this._online;
      }
      
      private function set _3529469show(param1:String) : void
      {
         var _loc2_:String = this.show;
         this._show = param1;
         PropertyChangeEvent.createUpdateEvent(this,"show",_loc2_,this.show);
      }
      
      [Bindable(event="propertyChange")]
      public function get show() : String
      {
         return this._show;
      }
      
      private function set _536284843isOnMobile(param1:Boolean) : void
      {
         if(param1 == this.isOnMobile)
         {
            return;
         }
         this._isOnMobile = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get isOnMobile() : Boolean
      {
         return this._isOnMobile;
      }
      
      public function registerPresence(param1:Presence) : void
      {
         var _loc2_:String = Boolean(param1) ? param1.from.resource : "";
         if(param1 == null)
         {
            delete this.resourcePresences[_loc2_];
         }
         else if(param1.type == Presence.UNAVAILABLE_TYPE)
         {
            delete this.resourcePresences[_loc2_];
            delete this.resourcePresences[null];
            if(this.getMobilePresences().length == 0 && this.isPresenceFromMobileResource(param1))
            {
               delete this.resourcePresences[""];
            }
            if(this.getPrimaryPresence() == null)
            {
               this.status = param1.status;
               this._isOnMobile = false;
               this._online = false;
            }
         }
         else if(param1.type == Presence.MOBILE_TYPE && _loc2_ != "")
         {
            delete this.resourcePresences[_loc2_];
            this.resourcePresences[""] = param1;
         }
         else
         {
            this.resourcePresences[_loc2_] = param1;
         }
         this.updateFromPresences();
      }
      
      private function updateFromPresences() : void
      {
         var statusXML:XML = null;
         var rankedSoloRestriction:XMLList = null;
         var presence:Presence = this.getPrimaryPresence();
         if(presence != null)
         {
            this.status = presence.status;
            this.show = this.getShowFromPresence(presence);
            this.priority = presence.priority;
            if(!presence.type || presence.type == Presence.MOBILE_TYPE)
            {
               this.online = true;
            }
            else if(presence.type == Presence.UNAVAILABLE_TYPE)
            {
               this.online = false;
            }
            this.isOnMobile = this.isPresenceIndicatingMobileAvailability(presence);
            try
            {
               statusXML = new XML(presence.status);
               rankedSoloRestriction = statusXML.rankedSoloRestricted;
               if(Boolean(rankedSoloRestriction) && rankedSoloRestriction.length() > 0)
               {
                  this._rankedRestricted = rankedSoloRestriction[0].toString() == "true";
               }
            }
            catch(error:Error)
            {
               _rankedRestricted = false;
            }
         }
         else
         {
            this.online = false;
            this.isOnMobile = false;
            this.status = null;
            this.show = null;
            this.priority = 0;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"online",true,this.online));
         }
      }
      
      public function getPrimaryPresence() : Presence
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Presence = null;
         var _loc1_:Presence = null;
         var _loc2_:int = int(Presence.SHOW_PRIORITIES.length);
         for each(_loc5_ in this.resourcePresences)
         {
            _loc3_ = Presence.SHOW_PRIORITIES.indexOf(this.getShowFromPresence(_loc5_));
            _loc4_ = _loc5_.type == Presence.MOBILE_TYPE || this.isPresenceFromMobileResource(_loc5_);
            if(!(_loc3_ < 0 || _loc3_ > _loc2_ || _loc4_))
            {
               _loc1_ = _loc5_;
               _loc2_ = _loc3_;
            }
         }
         if(_loc1_ == null)
         {
            _loc1_ = this.getBestMobilePresence();
            if(!_loc1_)
            {
               _loc1_ = _loc5_;
            }
         }
         return _loc1_;
      }
      
      private function set _105221jid(param1:UnescapedJID) : void
      {
         var _loc2_:UnescapedJID = this._jid;
         this._jid = param1;
         if(!this._displayName)
         {
            dispatchEvent(new Event("changeDisplayName"));
         }
         PropertyChangeEvent.createUpdateEvent(this,"jid",_loc2_,param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get jid() : UnescapedJID
      {
         return this._jid;
      }
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:String = this.displayName;
         this._displayName = param1;
         this._comparableDisplayName = param1 == null ? null : param1.toLowerCase();
         PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,this.displayName);
         dispatchEvent(new Event("changeDisplayName"));
      }
      
      [Bindable(event="changeDisplayName")]
      public function get displayName() : String
      {
         return Boolean(this._displayName) ? this._displayName : this._jid.node;
      }
      
      [Bindable(event="changeSubscription")]
      [Bindable(event="changeAskType")]
      public function get pending() : Boolean
      {
         return this.askType == RosterExtension.ASK_TYPE_SUBSCRIBE && (this.subscribeType == RosterExtension.SUBSCRIBE_TYPE_NONE || this.subscribeType == RosterExtension.SUBSCRIBE_TYPE_FROM);
      }
      
      public function get comparableDisplayName() : String
      {
         return this._comparableDisplayName;
      }
      
      public function set comparableDisplayName(param1:String) : void
      {
         this._comparableDisplayName = param1;
      }
      
      override public function toString() : String
      {
         return this.jid.toString();
      }
      
      private function getShowFromPresence(param1:Presence) : String
      {
         var _loc2_:String = null;
         if(this.isPresenceIndicatingMobileAvailability(param1))
         {
            _loc2_ = Presence.SHOW_CHAT_MOBILE;
         }
         else
         {
            _loc2_ = param1.show;
         }
         return _loc2_;
      }
      
      private function isPresenceFromMobileResource(param1:Presence) : Boolean
      {
         var _loc2_:String = param1.from.resource;
         return Boolean(_loc2_) && _loc2_.toUpperCase().indexOf("MOB") == 0;
      }
      
      private function isPresenceIndicatingMobileAvailability(param1:Presence) : Boolean
      {
         return this.isPresenceFromMobileResource(param1) || param1.type == Presence.MOBILE_TYPE;
      }
      
      private function getBestMobilePresence() : Presence
      {
         var _loc2_:Presence = null;
         var _loc4_:Presence = null;
         var _loc1_:Array = this.getMobilePresences();
         var _loc3_:Date = new Date(1970);
         for each(_loc4_ in _loc1_)
         {
            if(_loc4_.timestamp.time >= _loc3_.time)
            {
               _loc2_ = _loc4_;
               _loc3_ = _loc4_.timestamp;
            }
         }
         return Boolean(_loc2_) ? _loc2_ : this.resourcePresences[""];
      }
      
      private function getMobilePresences() : Array
      {
         var _loc2_:Presence = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.resourcePresences)
         {
            if(this.isPresenceFromMobileResource(_loc2_))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get localUserData() : Object
      {
         return this._1704846688localUserData;
      }
      
      public function set localUserData(param1:Object) : void
      {
         var _loc2_:Object = this._1704846688localUserData;
         if(_loc2_ !== param1)
         {
            this._1704846688localUserData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localUserData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get note() : String
      {
         return this._3387378note;
      }
      
      public function set note(param1:String) : void
      {
         var _loc2_:Object = this._3387378note;
         if(_loc2_ !== param1)
         {
            this._3387378note = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"note",_loc2_,param1));
            }
         }
      }
      
      public function set isDuoQueueRestricted(param1:Boolean) : void
      {
         var _loc2_:Object = this.isDuoQueueRestricted;
         if(_loc2_ !== param1)
         {
            this._1978787128isDuoQueueRestricted = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isDuoQueueRestricted",_loc2_,param1));
            }
         }
      }
      
      public function set isRankedRestricted(param1:Boolean) : void
      {
         var _loc2_:Object = this.isRankedRestricted;
         if(_loc2_ !== param1)
         {
            this._1123818960isRankedRestricted = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isRankedRestricted",_loc2_,param1));
            }
         }
      }
      
      public function set subscribeType(param1:String) : void
      {
         var _loc2_:Object = this.subscribeType;
         if(_loc2_ !== param1)
         {
            this._1572088740subscribeType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subscribeType",_loc2_,param1));
            }
         }
      }
      
      public function set priority(param1:Number) : void
      {
         var _loc2_:Object = this.priority;
         if(_loc2_ !== param1)
         {
            this._1165461084priority = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"priority",_loc2_,param1));
            }
         }
      }
      
      public function set askType(param1:String) : void
      {
         var _loc2_:Object = this.askType;
         if(_loc2_ !== param1)
         {
            this._712664749askType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"askType",_loc2_,param1));
            }
         }
      }
      
      public function set status(param1:String) : void
      {
         var _loc2_:Object = this.status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
            }
         }
      }
      
      public function set online(param1:Boolean) : void
      {
         var _loc2_:Object = this.online;
         if(_loc2_ !== param1)
         {
            this._1012222381online = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"online",_loc2_,param1));
            }
         }
      }
      
      public function set show(param1:String) : void
      {
         var _loc2_:Object = this.show;
         if(_loc2_ !== param1)
         {
            this._3529469show = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"show",_loc2_,param1));
            }
         }
      }
      
      public function set isOnMobile(param1:Boolean) : void
      {
         var _loc2_:Object = this.isOnMobile;
         if(_loc2_ !== param1)
         {
            this._536284843isOnMobile = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isOnMobile",_loc2_,param1));
            }
         }
      }
      
      public function set jid(param1:UnescapedJID) : void
      {
         var _loc2_:Object = this.jid;
         if(_loc2_ !== param1)
         {
            this._105221jid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"jid",_loc2_,param1));
            }
         }
      }
   }
}

