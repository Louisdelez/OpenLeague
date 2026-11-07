package com.riotgames.platform.gameclient.domain.game
{
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.PlayerCredentialsDTO;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.PlatformGameLifecycleDTO")]
   public class GameReconnectionInfo implements IEventDispatcher
   {
      
      private var _3165170game:GameDTO;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _520596588reconnectDelay:int;
      
      private var _1027754331playerCredentials:PlayerCredentialsDTO;
      
      public function GameReconnectionInfo()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set game(param1:GameDTO) : void
      {
         var _loc2_:Object = this._3165170game;
         if(_loc2_ !== param1)
         {
            this._3165170game = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"game",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get reconnectDelay() : int
      {
         return this._520596588reconnectDelay;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get game() : GameDTO
      {
         return this._3165170game;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set playerCredentials(param1:PlayerCredentialsDTO) : void
      {
         var _loc2_:Object = this._1027754331playerCredentials;
         if(_loc2_ !== param1)
         {
            this._1027754331playerCredentials = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerCredentials",_loc2_,param1));
         }
      }
      
      public function set reconnectDelay(param1:int) : void
      {
         var _loc2_:Object = this._520596588reconnectDelay;
         if(_loc2_ !== param1)
         {
            this._520596588reconnectDelay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reconnectDelay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerCredentials() : PlayerCredentialsDTO
      {
         return this._1027754331playerCredentials;
      }
   }
}

