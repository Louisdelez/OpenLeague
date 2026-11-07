package com.riotgames.pvpnet.game.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   
   public class EnterChampionSelectManager implements IEventDispatcher
   {
      
      public var masterGameController:MasterGameController;
      
      public var timeRemaining:int;
      
      private var _868210744timeRemainingStr:String = "";
      
      private var onTimeRemainingChanged:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger("com.riotgames.gameclient.domain.game.EnterChampionSelectManager");
      
      private var myTimer:Timer;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function EnterChampionSelectManager()
      {
         super();
      }
      
      public function getOnTimeRemainingChanged() : ISignal
      {
         return this.onTimeRemainingChanged;
      }
      
      public function initializeTimer() : void
      {
         if(this.myTimer == null)
         {
            this.myTimer = new Timer(1000);
            this.myTimer.addEventListener("timer",this.updateTime);
         }
         if(!this.myTimer.running)
         {
            this.timeRemaining = 30;
            this.myTimer.start();
         }
      }
      
      public function cleanupTimer() : void
      {
         if(this.myTimer == null)
         {
            return;
         }
         if(this.myTimer.running)
         {
            this.myTimer.stop();
         }
      }
      
      private function updateTime(param1:TimerEvent) : void
      {
         this.timeRemaining -= 1;
         var _loc2_:String = ResourceManager.getInstance().getString("resources","championSelection_seconds");
         this.timeRemainingStr = this.timeRemaining.toString() + " " + _loc2_;
         this.onTimeRemainingChanged.dispatch(this.onTimeRemainingChanged,this.timeRemainingStr);
         if(this.timeRemaining <= 0)
         {
            this.cleanupTimer();
            if(this.masterGameController.currentState == GameViewState.WAIT_FOR_GAME_AFTER_MATCH)
            {
               this.masterGameController.currentState = GameViewState.CHAMPION_SELECTION;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get timeRemainingStr() : String
      {
         return this._868210744timeRemainingStr;
      }
      
      public function set timeRemainingStr(param1:String) : void
      {
         var _loc2_:Object = this._868210744timeRemainingStr;
         if(_loc2_ !== param1)
         {
            this._868210744timeRemainingStr = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeRemainingStr",_loc2_,param1));
            }
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
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

