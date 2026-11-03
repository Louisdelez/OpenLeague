package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.TeamId")]
   public class TeamId extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1263418358fullId:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TeamId()
      {
         super();
      }
      
      public static function MakeTeamId(param1:String) : TeamId
      {
         var _loc2_:TeamId = new TeamId();
         _loc2_.fullId = param1;
         return _loc2_;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function Compare(param1:TeamId) : Boolean
      {
         return param1.toString() == this.toString();
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get fullId() : String
      {
         return this._1263418358fullId;
      }
      
      public function toString() : String
      {
         return this.fullId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set fullId(param1:String) : void
      {
         var _loc2_:Object = this._1263418358fullId;
         if(_loc2_ !== param1)
         {
            this._1263418358fullId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fullId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}

