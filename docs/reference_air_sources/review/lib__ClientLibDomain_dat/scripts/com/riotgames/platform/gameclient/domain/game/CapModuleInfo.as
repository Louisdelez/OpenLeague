package com.riotgames.platform.gameclient.domain.game
{
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class CapModuleInfo implements IEventDispatcher
   {
      
      private static var _instance:CapModuleInfo;
      
      private var _609043194inMatchmakingQueue:Boolean = false;
      
      private var _296436236homeButtonRightPosition:Number;
      
      public var homeButtonVisibleChanged:Signal = new Signal();
      
      private var _1163661683lobbyTimeRemaining:String;
      
      private var _2136228383homeButtonLeftPosition:Number = 5;
      
      private var _962950093inSoloQueue:Boolean = false;
      
      private var _723603249lobbyTextVisible:Boolean = false;
      
      private var _2004442559homeButtonVisible:Boolean = false;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function CapModuleInfo(param1:SingletonEnforcer)
      {
         super();
      }
      
      public static function get instance() : CapModuleInfo
      {
         if(!_instance)
         {
            _instance = new CapModuleInfo(new SingletonEnforcer());
         }
         return _instance;
      }
      
      [Bindable(event="propertyChange")]
      public function get homeButtonVisible() : Boolean
      {
         return this._2004442559homeButtonVisible;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set homeButtonLeftPosition(param1:Number) : void
      {
         var _loc2_:Object = this._2136228383homeButtonLeftPosition;
         if(_loc2_ !== param1)
         {
            this._2136228383homeButtonLeftPosition = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeButtonLeftPosition",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set homeButtonVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._2004442559homeButtonVisible;
         if(_loc2_ !== param1)
         {
            this._2004442559homeButtonVisible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeButtonVisible",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inSoloQueue() : Boolean
      {
         return this._962950093inSoloQueue;
      }
      
      [Bindable(event="propertyChange")]
      public function get inMatchmakingQueue() : Boolean
      {
         return this._609043194inMatchmakingQueue;
      }
      
      [Bindable(event="propertyChange")]
      public function get lobbyTextVisible() : Boolean
      {
         return this._723603249lobbyTextVisible;
      }
      
      public function set inSoloQueue(param1:Boolean) : void
      {
         var _loc2_:Object = this._962950093inSoloQueue;
         if(_loc2_ !== param1)
         {
            this._962950093inSoloQueue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inSoloQueue",_loc2_,param1));
         }
      }
      
      public function set inMatchmakingQueue(param1:Boolean) : void
      {
         var _loc2_:Object = this._609043194inMatchmakingQueue;
         if(_loc2_ !== param1)
         {
            this._609043194inMatchmakingQueue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inMatchmakingQueue",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set lobbyTextVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._723603249lobbyTextVisible;
         if(_loc2_ !== param1)
         {
            this._723603249lobbyTextVisible = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyTextVisible",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeButtonLeftPosition() : Number
      {
         return this._2136228383homeButtonLeftPosition;
      }
      
      public function getHomeButtonVisibleChanged() : Signal
      {
         return this.homeButtonVisibleChanged;
      }
      
      public function set lobbyTimeRemaining(param1:String) : void
      {
         var _loc2_:Object = this._1163661683lobbyTimeRemaining;
         if(_loc2_ !== param1)
         {
            this._1163661683lobbyTimeRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyTimeRemaining",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set homeButtonRightPosition(param1:Number) : void
      {
         var _loc2_:Object = this._296436236homeButtonRightPosition;
         if(_loc2_ !== param1)
         {
            this._296436236homeButtonRightPosition = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeButtonRightPosition",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lobbyTimeRemaining() : String
      {
         return this._1163661683lobbyTimeRemaining;
      }
      
      [Bindable(event="propertyChange")]
      public function get homeButtonRightPosition() : Number
      {
         return this._296436236homeButtonRightPosition;
      }
      
      public function setHomeButtonVisible(param1:Boolean) : void
      {
         this.homeButtonVisible = param1;
         this.homeButtonVisibleChanged.dispatch();
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
