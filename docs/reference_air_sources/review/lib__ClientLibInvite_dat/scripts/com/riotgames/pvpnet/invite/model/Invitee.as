package com.riotgames.pvpnet.invite.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   
   public class Invitee
   {
      
      private var _isMutualFriend:Boolean = false;
      
      private var _status:int;
      
      private var _filterStateChanged:Signal = new Signal();
      
      private var _presence:PresenceStatusData;
      
      private var _realName:String;
      
      private var _name:String;
      
      private var _summonerId:Number;
      
      private var _busyStatus:String;
      
      private var _busyStatusChanged:Signal = new Signal();
      
      private var _filterState:uint;
      
      public function Invitee()
      {
         super();
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function getSummonerId() : Number
      {
         return this._summonerId;
      }
      
      public function getBusyStatus() : String
      {
         return this._busyStatus;
      }
      
      public function get presence() : PresenceStatusData
      {
         return this._presence;
      }
      
      public function setRealName(param1:String) : void
      {
         this._realName = param1;
      }
      
      public function setStatus(param1:int) : void
      {
         this._status = param1;
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
      }
      
      public function setSummonerId(param1:Number) : void
      {
         this._summonerId = param1;
      }
      
      public function getBusyStatusChanged() : ISignal
      {
         return this._busyStatusChanged;
      }
      
      public function getIsMutualFriend() : Boolean
      {
         return this._isMutualFriend;
      }
      
      public function setBusyStatus(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != this._busyStatus)
         {
            _loc2_ = this._busyStatus;
            this._busyStatus = param1;
            this._busyStatusChanged.dispatch(_loc2_,this._busyStatus);
         }
      }
      
      public function setIsMutualFriend(param1:Boolean) : void
      {
         this._isMutualFriend = param1;
      }
      
      public function getFilterState() : uint
      {
         return this._filterState;
      }
      
      public function getStatus() : int
      {
         return this._status;
      }
      
      public function getFilterStateChanged() : ISignal
      {
         return this._filterStateChanged;
      }
      
      public function setPresence(param1:PresenceStatusData) : void
      {
         this._presence = param1;
      }
      
      public function setFilterState(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(param1 != this._filterState)
         {
            _loc2_ = this._filterState;
            this._filterState = param1;
            this._filterStateChanged.dispatch(_loc2_,this._filterState);
         }
      }
      
      public function getRealName() : String
      {
         return this._realName;
      }
   }
}

