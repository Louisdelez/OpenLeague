package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class SpectatorDelayManager extends EventDispatcher
   {
      
      public static const DELAY_EXPIRED:String = "delayExpired";
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var spectatorWaitStartTime:int;
      
      private var spectatorDelayTimer:Timer;
      
      private var totalSpectatorWaitTimeSeconds:int = 0;
      
      public function SpectatorDelayManager(param1:ChampionSelectionModel)
      {
         super();
         this.championSelectionModel = param1;
         param1.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_STATE_CHANGED,this.onChampionSelectionStateChanged,false,0,true);
         this.checkShouldStartDelay();
      }
      
      private function startDelay(param1:int) : void
      {
         this.championSelectionModel.spectatorDelaySecondsRemaining = param1;
         this.championSelectionModel.spectatorDelayProgress = 1;
         if(param1 <= 0)
         {
            return;
         }
         this.totalSpectatorWaitTimeSeconds = param1;
         this.spectatorWaitStartTime = getTimer();
         this.startTimer();
      }
      
      private function startTimer() : void
      {
         if(Boolean(this.spectatorDelayTimer) && this.spectatorDelayTimer.running)
         {
            this.spectatorDelayTimer.stop();
         }
         else
         {
            this.spectatorDelayTimer = new Timer(100);
         }
         this.spectatorDelayTimer.addEventListener(TimerEvent.TIMER,this.onSpectatorDelayTimer);
         this.spectatorDelayTimer.delay = 100;
         this.spectatorDelayTimer.start();
      }
      
      private function onChampionSelectionStateChanged(param1:Event) : void
      {
         this.checkShouldStartDelay();
      }
      
      private function cleanupTimer() : void
      {
         if(!this.spectatorDelayTimer)
         {
            return;
         }
         if(Boolean(this.spectatorDelayTimer) && this.spectatorDelayTimer.running)
         {
            this.spectatorDelayTimer.stop();
         }
         this.spectatorDelayTimer.removeEventListener(TimerEvent.TIMER,this.onSpectatorDelayTimer);
         this.spectatorDelayTimer = null;
      }
      
      private function onSpectatorDelayTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:int = _loc2_ - this.spectatorWaitStartTime;
         var _loc4_:Number = _loc3_ / (this.totalSpectatorWaitTimeSeconds * 1000);
         this.championSelectionModel.spectatorDelayProgress = Math.min(Math.max(1 - _loc4_,0),1);
         var _loc5_:int = this.totalSpectatorWaitTimeSeconds - Math.floor(_loc3_ * 0.001);
         this.championSelectionModel.spectatorDelaySecondsRemaining = Math.min(Math.max(_loc5_,0),this.totalSpectatorWaitTimeSeconds);
         if(this.championSelectionModel.spectatorDelaySecondsRemaining == 0)
         {
            this.cleanupTimer();
            dispatchEvent(new Event(DELAY_EXPIRED));
         }
      }
      
      private function checkShouldStartDelay() : void
      {
         if(this.championSelectionModel.championSelectionState == GameState.START_REQUESTED || this.championSelectionModel.championSelectionState == GameState.IN_PROGRESS)
         {
            this.startDelay(this.championSelectionModel.currentGame.spectatorDelay);
         }
      }
   }
}

