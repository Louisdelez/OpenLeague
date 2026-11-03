package com.riotgames.platform.gameclient.domain.game
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.map.GameMapEnabledDTO")]
   public class GameMapEnabledDTO extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1142598912minPlayers:int;
      
      private var _983970501gameMapId:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GameMapEnabledDTO()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get minPlayers() : int
      {
         return this._1142598912minPlayers;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMapId() : int
      {
         return this._983970501gameMapId;
      }
      
      public function set minPlayers(param1:int) : void
      {
         var _loc2_:Object = this._1142598912minPlayers;
         if(_loc2_ !== param1)
         {
            this._1142598912minPlayers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minPlayers",_loc2_,param1));
         }
      }
      
      public function set gameMapId(param1:int) : void
      {
         var _loc2_:Object = this._983970501gameMapId;
         if(_loc2_ !== param1)
         {
            this._983970501gameMapId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMapId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

