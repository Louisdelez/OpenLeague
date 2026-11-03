package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.dto.TeamMemberInfoDTO")]
   public class TeamMemberInfo extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _892481550status:String;
      
      private var _1879273436playerId:Number;
      
      private var _1402233864joinDate:Date;
      
      private var _2095657228playerName:String;
      
      private var _1197598295inviteDate:Date;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TeamMemberInfo()
      {
         super();
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get playerName() : String
      {
         return this._2095657228playerName;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteDate() : Date
      {
         return this._1197598295inviteDate;
      }
      
      public function set playerName(param1:String) : void
      {
         var _loc2_:Object = this._2095657228playerName;
         if(_loc2_ !== param1)
         {
            this._2095657228playerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerId() : Number
      {
         return this._1879273436playerId;
      }
      
      public function set status(param1:String) : void
      {
         var _loc2_:Object = this._892481550status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set joinDate(param1:Date) : void
      {
         var _loc2_:Object = this._1402233864joinDate;
         if(_loc2_ !== param1)
         {
            this._1402233864joinDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"joinDate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get status() : String
      {
         return this._892481550status;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set inviteDate(param1:Date) : void
      {
         var _loc2_:Object = this._1197598295inviteDate;
         if(_loc2_ !== param1)
         {
            this._1197598295inviteDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteDate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get joinDate() : Date
      {
         return this._1402233864joinDate;
      }
      
      public function set playerId(param1:Number) : void
      {
         var _loc2_:Object = this._1879273436playerId;
         if(_loc2_ !== param1)
         {
            this._1879273436playerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerId",_loc2_,param1));
         }
      }
   }
}

