package com.riotgames.pvpnet.cap.controllers
{
   import blix.IDestructible;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CapLobbyTimerController implements IDestructible
   {
      
      private static const TICK_INTERVAL:int = 1000;
      
      private var model:CapModel;
      
      private var timer:Timer;
      
      private var _secondsRemaining:int;
      
      public function CapLobbyTimerController(param1:CapModel)
      {
         super();
         this.model = param1;
      }
      
      protected function updateModel(param1:int, param2:CapModel) : void
      {
         var _loc3_:String = this.formatTimeString(param1);
         param2.groupTtlString = _loc3_;
      }
      
      public function stopTimer() : void
      {
         if(this.timer)
         {
            this.timer.stop();
            this.timer.reset();
         }
         this.model.groupTtlString = "";
      }
      
      protected function handleTick(param1:TimerEvent) : void
      {
         --this._secondsRemaining;
         this.updateModel(this._secondsRemaining,this.model);
         if(this._secondsRemaining <= 0)
         {
            this.stopTimer();
         }
      }
      
      public function startTimerFromSeconds(param1:int) : void
      {
         this._secondsRemaining = param1;
         if(!this.timer)
         {
            this.timer = new Timer(TICK_INTERVAL);
            this.timer.addEventListener(TimerEvent.TIMER,this.handleTick,false,0,true);
         }
         this.timer.reset();
         this.timer.start();
      }
      
      protected function formatTimeString(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = Math.floor(param1 / 60);
         if(_loc3_ > 0)
         {
            _loc2_ += _loc3_;
         }
         else
         {
            _loc2_ = "0";
         }
         _loc2_ += ":";
         param1 -= _loc3_ * 60;
         if(param1 < 10)
         {
            _loc2_ += "0";
         }
         return _loc2_ + param1;
      }
      
      public function get secondsRemaining() : int
      {
         return this._secondsRemaining;
      }
      
      public function destroy() : void
      {
         this.stopTimer();
      }
   }
}

