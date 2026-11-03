package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.dto.PlayerDTO")]
   public class Player extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1974010608teamsSummary:ArrayCollection;
      
      private var _1879273436playerId:Number;
      
      private var _1992534958createdTeams:ArrayCollection;
      
      private var _546513749playerTeams:ArrayCollection;
      
      public function Player()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
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
      public function get teamsSummary() : ArrayCollection
      {
         return this._1974010608teamsSummary;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerTeams() : ArrayCollection
      {
         return this._546513749playerTeams;
      }
      
      public function set createdTeams(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1992534958createdTeams;
         if(_loc2_ !== param1)
         {
            this._1992534958createdTeams = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createdTeams",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set teamsSummary(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1974010608teamsSummary;
         if(_loc2_ !== param1)
         {
            this._1974010608teamsSummary = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamsSummary",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerId() : Number
      {
         return this._1879273436playerId;
      }
      
      public function set playerTeams(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._546513749playerTeams;
         if(_loc2_ !== param1)
         {
            this._546513749playerTeams = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerTeams",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get createdTeams() : ArrayCollection
      {
         return this._1992534958createdTeams;
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

