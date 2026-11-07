package com.riotgames.platform.gameclient.shell
{
   import flash.display.Stage;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class FrameRateHandler
   {
      
      private static const MAXIMIZED_FRAMERATE:Number = 30;
      
      private static const MINIMIZED_FRAMERATE:Number = 1;
      
      private static const FORBIDDEN_FRAMERATE:Number = 1000;
      
      private static const FRAMERATE_RETRY:Number = 1000;
      
      private var _repeatSetFramerateTimer:Timer = null;
      
      private var _commitFramerateTimerId:uint = 0;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _goalFramerate:Number = 30;
      
      private var _stage:Stage;
      
      public function FrameRateHandler(param1:Stage)
      {
         super();
         this._stage = param1;
      }
      
      private function commitGoalFramerate() : void
      {
         if(this._commitFramerateTimerId != 0)
         {
            clearTimeout(this._commitFramerateTimerId);
            this._commitFramerateTimerId = 0;
         }
         this.attemptToSetFrameRate();
      }
      
      private function onRepeatFramerateTimerComplete(param1:TimerEvent) : void
      {
         this.cleanupRepeatFramerateTimer();
      }
      
      public function set minimized(param1:Boolean) : void
      {
         this.setGoalFramerate(param1 ? MINIMIZED_FRAMERATE : MAXIMIZED_FRAMERATE);
      }
      
      private function onRepeatFramerateTimerTick(param1:TimerEvent) : void
      {
         if(this._stage)
         {
            this._stage.frameRate = this._goalFramerate;
         }
      }
      
      private function cleanupRepeatFramerateTimer() : void
      {
         if(this._repeatSetFramerateTimer)
         {
            this._repeatSetFramerateTimer.removeEventListener(TimerEvent.TIMER,this.onRepeatFramerateTimerTick);
            this._repeatSetFramerateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onRepeatFramerateTimerComplete);
            this._repeatSetFramerateTimer.stop();
            this._repeatSetFramerateTimer = null;
         }
      }
      
      private function setGoalFramerate(param1:Number) : void
      {
         this._goalFramerate = param1;
         this.commitGoalFramerate();
      }
      
      private function repeatedlySetFramerate() : void
      {
         this.cleanupRepeatFramerateTimer();
         this._repeatSetFramerateTimer = new Timer(1000,10);
         this._repeatSetFramerateTimer.addEventListener(TimerEvent.TIMER,this.onRepeatFramerateTimerTick);
         this._repeatSetFramerateTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRepeatFramerateTimerComplete);
         this._repeatSetFramerateTimer.start();
      }
      
      private function attemptToSetFrameRate() : void
      {
         if(!this._stage)
         {
            this._commitFramerateTimerId = setTimeout(this.attemptToSetFrameRate,FRAMERATE_RETRY);
         }
         if(!this._stage.frameRate == FORBIDDEN_FRAMERATE)
         {
            this._commitFramerateTimerId = setTimeout(this.attemptToSetFrameRate,FRAMERATE_RETRY);
         }
         else
         {
            this._stage.frameRate = this._goalFramerate;
            this._commitFramerateTimerId = 0;
            this.repeatedlySetFramerate();
         }
      }
   }
}

