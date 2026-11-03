package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getTimer;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.TeamInfo")]
   public class TeamInfo extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _3373707name:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _114586tag:String;
      
      private var _968683201secondsUntilEligibleForDeletion:Number;
      
      private var _877713320teamId:TeamId;
      
      private var localCreateTime:uint;
      
      private var _810178979memberStatusString:String;
      
      public function TeamInfo()
      {
         super();
         this.localCreateTime = getTimer();
      }
      
      public static function fromTeam(param1:Team) : TeamInfo
      {
         var _loc2_:TeamInfo = new TeamInfo();
         _loc2_.name = param1.name;
         _loc2_.teamId = param1.teamId;
         _loc2_.tag = param1.tag;
         _loc2_.memberStatusString = null;
         _loc2_.secondsUntilEligibleForDeletion = param1.calculateSecondsUntilEligibleForDeletion();
         return _loc2_;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get secondsUntilEligibleForDeletion() : Number
      {
         return this._968683201secondsUntilEligibleForDeletion;
      }
      
      public function set secondsUntilEligibleForDeletion(param1:Number) : void
      {
         var _loc2_:Object = this._968683201secondsUntilEligibleForDeletion;
         if(_loc2_ !== param1)
         {
            this._968683201secondsUntilEligibleForDeletion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondsUntilEligibleForDeletion",_loc2_,param1));
         }
      }
      
      public function calculateSecondsUntilEligibleForDeletion() : Number
      {
         var _loc1_:uint = uint(getTimer());
         var _loc2_:Number = (_loc1_ - this.localCreateTime) * 0.001;
         return Math.max(0,this.secondsUntilEligibleForDeletion - _loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      public function get teamId() : TeamId
      {
         return this._877713320teamId;
      }
      
      [Bindable(event="propertyChange")]
      public function get tag() : String
      {
         return this._114586tag;
      }
      
      [Bindable(event="propertyChange")]
      public function get memberStatusString() : String
      {
         return this._810178979memberStatusString;
      }
      
      public function set teamId(param1:TeamId) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      public function set tag(param1:String) : void
      {
         var _loc2_:Object = this._114586tag;
         if(_loc2_ !== param1)
         {
            this._114586tag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tag",_loc2_,param1));
         }
      }
      
      public function set memberStatusString(param1:String) : void
      {
         var _loc2_:Object = this._810178979memberStatusString;
         if(_loc2_ !== param1)
         {
            this._810178979memberStatusString = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memberStatusString",_loc2_,param1));
         }
      }
      
      public function getInactivityStatus() : int
      {
         var _loc1_:Number = this.calculateSecondsUntilEligibleForDeletion();
         if(_loc1_ <= 0)
         {
            return Team.STATUS_INACTIVE;
         }
         if(_loc1_ <= Team.INACTIVE_WARNING_SECONDS)
         {
            return Team.STATUS_PENDING_INACTIVE;
         }
         return Team.STATUS_ACTIVE;
      }
   }
}

