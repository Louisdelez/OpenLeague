package com.riotgames.pvpnet.cap.controllers
{
   import blix.signals.Signal;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class CapTimerController
   {
      
      public var completeSignal:Signal = new Signal();
      
      private var relativeStartTime:Number;
      
      public var tickSignal:Signal = new Signal();
      
      private var timer:Timer;
      
      private var elapsedTime:Number;
      
      public var stopSignal:Signal = new Signal();
      
      private var timeLeft:Number = 0;
      
      private var millisecondsToTimeout:Number;
      
      public function CapTimerController(param1:Timer)
      {
         super();
         this.timer = param1;
      }
      
      public function stop() : void
      {
         if(!this.timer)
         {
            throw new Error("Timer must not be null.");
         }
         this.timer.stop();
         this.timer.reset();
         this.timeLeft = 0;
         this.stopSignal.dispatch();
      }
      
      public function get timeRemaining() : Number
      {
         return this.timeLeft;
      }
      
      public function start(param1:Number = 0) : void
      {
         if(!this.timer)
         {
            throw new Error("Timer must not be null.");
         }
         this.millisecondsToTimeout = param1;
         this.timeLeft = param1;
         if(!this.timer.hasEventListener(TimerEvent.TIMER))
         {
            this.timer.addEventListener(TimerEvent.TIMER,this.handleTick);
         }
         this.timer.reset();
         this.timer.start();
         this.relativeStartTime = getTimer();
      }
      
      protected function handleTick(param1:TimerEvent) : void
      {
         var _loc2_:Number = getTimer();
         this.elapsedTime = _loc2_ - this.relativeStartTime;
         this.timeLeft = this.millisecondsToTimeout - this.elapsedTime;
         this.tickSignal.dispatch();
         if(this.timeLeft <= 0)
         {
            this.stop();
            this.completeSignal.dispatch();
         }
      }
   }
}

