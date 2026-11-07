package com.riotgames.platform.gameclient.domain.invite
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   
   public class InviteParticipant implements IEventDispatcher
   {
      
      private var _3373707name:String;
      
      private var _1500726446originalInvitor:String = null;
      
      private var _status:String;
      
      private var _1567006620kickBanningEnabled:Boolean = true;
      
      private var _100313435image:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1359356291profileIconId:int;
      
      private var _2074795063hasDelegatedInvitePower:Boolean = false;
      
      private var _2067570601isOwner:Boolean;
      
      private var _presence:Presence;
      
      private var _1380252469isInvitor:Boolean;
      
      private var _1551198410verificationState:String;
      
      private var _80971529summonerId:Number;
      
      private var _statusChanged:Signal = new Signal();
      
      private var _105221jid:UnescapedJID;
      
      private var _1809925292displayStatus:String;
      
      public function InviteParticipant(param1:UnescapedJID = null, param2:Number = 0, param3:String = null, param4:String = null, param5:int = 0)
      {
         super();
         this.jid = param1;
         this.summonerId = param2;
         this.name = param3;
         this.status = param4 == null ? InviteParticipantState.PENDING : param4;
         this.image = "gameOwner.png";
         this.profileIconId = param5;
      }
      
      [Bindable(event="propertyChange")]
      public function get jid() : UnescapedJID
      {
         return this._105221jid;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerId() : Number
      {
         return this._80971529summonerId;
      }
      
      public function set jid(param1:UnescapedJID) : void
      {
         var _loc2_:Object = this._105221jid;
         if(_loc2_ !== param1)
         {
            this._105221jid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"jid",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set summonerId(param1:Number) : void
      {
         var _loc2_:Object = this._80971529summonerId;
         if(_loc2_ !== param1)
         {
            this._80971529summonerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerId",_loc2_,param1));
         }
      }
      
      private function set _892481550status(param1:String) : void
      {
         this._status = param1;
         if(!InviteParticipantState.isMemberState(this._status))
         {
            this.hasDelegatedInvitePower = false;
         }
         this.displayStatus = ResourceManager.getInstance().getString("resources","invite_participant_status_" + this._status);
         if(this.displayStatus == null)
         {
            this.displayStatus = "**" + this._status;
         }
         this._statusChanged.dispatch();
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set presence(param1:Presence) : void
      {
         var _loc2_:Object = this.presence;
         if(_loc2_ !== param1)
         {
            this._1276666629presence = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"presence",_loc2_,param1));
         }
      }
      
      public function set verificationState(param1:String) : void
      {
         var _loc2_:Object = this._1551198410verificationState;
         if(_loc2_ !== param1)
         {
            this._1551198410verificationState = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verificationState",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function set displayStatus(param1:String) : void
      {
         var _loc2_:Object = this._1809925292displayStatus;
         if(_loc2_ !== param1)
         {
            this._1809925292displayStatus = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayStatus",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isOwner() : Boolean
      {
         return this._2067570601isOwner;
      }
      
      public function getColor() : String
      {
         if(this.status == InviteParticipantState.PENDING)
         {
            return "0xe4d700";
         }
         if(InviteParticipantState.isMemberState(this.status))
         {
            return "0x04bc00";
         }
         return "0xbd0000";
      }
      
      [Bindable(event="propertyChange")]
      public function get originalInvitor() : String
      {
         return this._1500726446originalInvitor;
      }
      
      [Bindable(event="propertyChange")]
      public function get isInvitor() : Boolean
      {
         return this._1380252469isInvitor;
      }
      
      public function set image(param1:String) : void
      {
         var _loc2_:Object = this._100313435image;
         if(_loc2_ !== param1)
         {
            this._100313435image = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"image",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get verificationState() : String
      {
         return this._1551198410verificationState;
      }
      
      [Bindable(event="propertyChange")]
      public function get hasDelegatedInvitePower() : Boolean
      {
         return this._2074795063hasDelegatedInvitePower;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set kickBanningEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1567006620kickBanningEnabled;
         if(_loc2_ !== param1)
         {
            this._1567006620kickBanningEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kickBanningEnabled",_loc2_,param1));
         }
      }
      
      private function set _1276666629presence(param1:Presence) : void
      {
         this._presence = param1;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get displayStatus() : String
      {
         return this._1809925292displayStatus;
      }
      
      public function set isOwner(param1:Boolean) : void
      {
         var _loc2_:Object = this._2067570601isOwner;
         if(_loc2_ !== param1)
         {
            this._2067570601isOwner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isOwner",_loc2_,param1));
         }
      }
      
      public function set originalInvitor(param1:String) : void
      {
         var _loc2_:Object = this._1500726446originalInvitor;
         if(_loc2_ !== param1)
         {
            this._1500726446originalInvitor = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"originalInvitor",_loc2_,param1));
         }
      }
      
      public function get statusChanged() : ISignal
      {
         return this._statusChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function set status(param1:String) : void
      {
         var _loc2_:Object = this.status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
         }
      }
      
      public function set hasDelegatedInvitePower(param1:Boolean) : void
      {
         var _loc2_:Object = this._2074795063hasDelegatedInvitePower;
         if(_loc2_ !== param1)
         {
            this._2074795063hasDelegatedInvitePower = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasDelegatedInvitePower",_loc2_,param1));
         }
      }
      
      public function set isInvitor(param1:Boolean) : void
      {
         var _loc2_:Object = this._1380252469isInvitor;
         if(_loc2_ !== param1)
         {
            this._1380252469isInvitor = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isInvitor",_loc2_,param1));
         }
      }
      
      public function get status() : String
      {
         return this._status;
      }
      
      [Bindable(event="propertyChange")]
      public function get image() : String
      {
         return this._100313435image;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set profileIconId(param1:int) : void
      {
         var _loc2_:Object = this._1359356291profileIconId;
         if(_loc2_ !== param1)
         {
            this._1359356291profileIconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIconId",_loc2_,param1));
         }
      }
      
      public function get presence() : Presence
      {
         return this._presence;
      }
      
      [Bindable(event="propertyChange")]
      public function get kickBanningEnabled() : Boolean
      {
         return this._1567006620kickBanningEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get profileIconId() : int
      {
         return this._1359356291profileIconId;
      }
   }
}

