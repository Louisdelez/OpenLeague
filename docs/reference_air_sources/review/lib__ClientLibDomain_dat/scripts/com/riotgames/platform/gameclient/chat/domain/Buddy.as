package com.riotgames.platform.gameclient.chat.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.data.Presence;
   
   public class Buddy extends EventDispatcher
   {
      
      public static const DATA_FORMAT:String = "buddyData";
      
      public static const STATUS_OFFLINE:int = 0;
      
      public static const STATUS_ONLINE:int = 1;
      
      public static const SUMMONER_LEVEL_UNKNOWN:int = 0;
      
      private var _status:int = 0;
      
      private var _realName:String;
      
      private var _summonerId:Number;
      
      private var _isMutualFriend:Boolean = false;
      
      private var _jid:String;
      
      private var _isOnMobile:Boolean;
      
      private var _eligibleQueuePartner:Boolean = true;
      
      private var _note:String = "";
      
      private var _presence:PresenceStatusData;
      
      public var disablePropertyChangeEvents:Boolean = false;
      
      private var _name:String;
      
      private var _buddyChanged:Signal = new Signal();
      
      private var _busyStatus:String;
      
      public function Buddy()
      {
         super();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getBuddyChanged() : ISignal
      {
         return this._buddyChanged;
      }
      
      public function setSummonerId(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this._summonerId != param1)
         {
            _loc2_ = this._summonerId;
            this._summonerId = param1;
            this.update();
         }
      }
      
      public function setName(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._name != param1)
         {
            _loc2_ = this._name;
            this._name = param1;
            this.update();
         }
      }
      
      public function getIsMutualFriend() : Boolean
      {
         return this._isMutualFriend;
      }
      
      public function getIsOnline() : Boolean
      {
         return this._status == STATUS_ONLINE;
      }
      
      public function setIsMutualFriend(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._isMutualFriend != param1)
         {
            _loc2_ = this._isMutualFriend;
            this._isMutualFriend = param1;
            this.update();
         }
      }
      
      public function isOnMobile() : Boolean
      {
         return this._isOnMobile;
      }
      
      public function setIsOnMobile(param1:Boolean) : void
      {
         if(this._isOnMobile != param1)
         {
            this._isOnMobile = param1;
            this.update();
         }
      }
      
      public function valueOf() : Object
      {
         return this._summonerId;
      }
      
      public function isEligibleQueuePartner() : Boolean
      {
         return this._eligibleQueuePartner;
      }
      
      public function isAvailableForInvite() : Boolean
      {
         return this.getIsOnline() && this.getBusyStatus() != Presence.SHOW_DND && !this.isOnMobile();
      }
      
      public function getRealName() : String
      {
         return this._realName;
      }
      
      public function getBusyStatus() : String
      {
         return this._busyStatus;
      }
      
      public function update() : void
      {
         if(!this.disablePropertyChangeEvents)
         {
            this._buddyChanged.dispatch(this);
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
         }
      }
      
      public function setRealName(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._realName != param1)
         {
            _loc2_ = this._realName;
            this._realName = param1;
            this.update();
         }
      }
      
      public function getJID() : String
      {
         return this._jid;
      }
      
      public function setBusyStatus(param1:String) : void
      {
         var _loc2_:String = null;
         if(this._busyStatus != param1)
         {
            _loc2_ = this._busyStatus;
            this._busyStatus = param1;
            this.update();
         }
      }
      
      public function setJId(param1:String) : void
      {
         this._jid = param1;
      }
      
      public function getNote() : String
      {
         return this._note;
      }
      
      public function getStatus() : int
      {
         return this._status;
      }
      
      public function setEligibleQueuePartner(param1:Boolean) : *
      {
         if(this._eligibleQueuePartner != param1)
         {
            this._eligibleQueuePartner = param1;
            this.update();
         }
      }
      
      public function getPresence() : PresenceStatusData
      {
         return this._presence;
      }
      
      public function setStatus(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this._status != param1)
         {
            _loc2_ = this._status;
            this._status = param1;
            this.update();
         }
      }
      
      public function getJidNode() : String
      {
         return this._jid.split("@")[0];
      }
      
      public function setNote(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != this._note)
         {
            _loc2_ = this._note;
            this._note = param1;
            this.update();
         }
      }
      
      public function setPresence(param1:PresenceStatusData) : void
      {
         var _loc2_:PresenceStatusData = null;
         if(this._presence != param1)
         {
            _loc2_ = this._presence;
            this._presence = param1;
            this.update();
         }
      }
      
      public function getSummonerId() : Number
      {
         return this._summonerId;
      }
   }
}

