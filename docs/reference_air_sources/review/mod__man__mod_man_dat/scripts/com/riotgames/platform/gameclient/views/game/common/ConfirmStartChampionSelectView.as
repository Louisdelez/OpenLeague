package com.riotgames.platform.gameclient.views.game.common
{
   import blix.assets.proxy.SpriteProxy;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.game.domain.GameAFKStatus;
   import com.riotgames.rust.context.RustContext;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.core.UIComponent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ConfirmStartChampionSelectView extends UIComponent implements ICancelableDialog
   {
      
      private var cleanupTimer:Timer = new Timer(40000,1);
      
      private var _confirmChampionSelectBlixView:EnterChampionSelectView;
      
      private var _onAccepted:Signal = new Signal();
      
      private var _onClosed:Signal = new Signal();
      
      private var _onDeclined:Signal = new Signal();
      
      private var _confirmChampionSelectWrapper:SpriteProxy;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _gameAFKStatus:GameAFKStatus;
      
      private var delayedClosedTimer:Timer = new Timer(2000,1);
      
      public function ConfirmStartChampionSelectView(param1:RustContext, param2:int)
      {
         super();
         this._confirmChampionSelectWrapper = new SpriteProxy(param1,this);
         this._confirmChampionSelectBlixView = new EnterChampionSelectView(this._confirmChampionSelectWrapper,param2);
         this._confirmChampionSelectWrapper.addChild(this._confirmChampionSelectBlixView);
         this._confirmChampionSelectBlixView.addEventListener("acceptButtonClicked",this.onAcceptButtonClicked);
         this._confirmChampionSelectBlixView.addEventListener("declineButtonClicked",this.onDeclineButtonClicked);
         this._confirmChampionSelectBlixView.addEventListener("cancelButtonClicked",this.onCancelButtonClicked);
         this._confirmChampionSelectBlixView.addEventListener("noButtonClicked",this.onNoButtonClicked);
         this._confirmChampionSelectBlixView.initializeView();
         this.cleanupTimer.addEventListener(TimerEvent.TIMER,this.onCleanupTimer);
         this.cleanupTimer.start();
      }
      
      private function onCleanupTimer(param1:TimerEvent) : void
      {
         this.logger.error("The AFK dialogue was still up when the cleanup timer expired!");
         this._onClosed.dispatch(this._onClosed);
         this._gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         this.removeTimers();
      }
      
      public function cleanUp() : void
      {
         this.removeTimers();
         if(this._confirmChampionSelectBlixView)
         {
            this._confirmChampionSelectBlixView.cleanup();
            this._confirmChampionSelectBlixView.destroy();
            this._confirmChampionSelectBlixView = null;
         }
      }
      
      public function updateView(param1:GameAFKStatus, param2:String, param3:Boolean = false) : void
      {
         this._gameAFKStatus = param1;
         if(param3)
         {
            this.delayedClosedTimer.addEventListener(TimerEvent.TIMER,this.onDelayedCloseTimer);
            this.delayedClosedTimer.start();
         }
         if(param2 != null)
         {
            this._confirmChampionSelectBlixView.updateReadinessIndicatorsIncrementally(param2);
         }
      }
      
      private function onDelayedCloseTimer(param1:TimerEvent) : void
      {
         this._onClosed.dispatch(this._onClosed);
         if(this.delayedClosedTimer)
         {
            this.delayedClosedTimer.stop();
            this.delayedClosedTimer.removeEventListener(TimerEvent.TIMER,this.onDelayedCloseTimer);
            this.delayedClosedTimer = null;
         }
      }
      
      public function getOnAccepted() : ISignal
      {
         return this._onAccepted;
      }
      
      private function onAcceptButtonClicked(param1:Event) : void
      {
         this._gameAFKStatus.acceptedPoppedGame = true;
         this._gameAFKStatus.respondedToPoppedGame = true;
         this._onAccepted.dispatch(this._onAccepted);
      }
      
      public function getOnClosed() : ISignal
      {
         return this._onClosed;
      }
      
      public function getOnDeclined() : ISignal
      {
         return this._onDeclined;
      }
      
      public function showReturningToLobby() : void
      {
         this._confirmChampionSelectBlixView.showReturningToLobby();
      }
      
      private function onCancelButtonClicked(param1:Event) : void
      {
         this._gameAFKStatus.waitingToRejoinTeamLobbyFromAFKReinvite = false;
         this._onClosed.dispatch(this._onClosed);
      }
      
      private function removeTimers() : void
      {
         if(this.cleanupTimer)
         {
            this.cleanupTimer.stop();
            this.cleanupTimer.removeEventListener(TimerEvent.TIMER,this.onCleanupTimer);
            this.cleanupTimer = null;
         }
         if(this.delayedClosedTimer)
         {
            this.delayedClosedTimer.stop();
            this.delayedClosedTimer.removeEventListener(TimerEvent.TIMER,this.onDelayedCloseTimer);
            this.delayedClosedTimer = null;
         }
      }
      
      private function onNoButtonClicked(param1:Event) : void
      {
         this._confirmChampionSelectBlixView.cleanup();
         this._gameAFKStatus.acceptedPoppedGame = false;
         this._gameAFKStatus.respondedToPoppedGame = false;
      }
      
      public function cancel() : void
      {
      }
      
      private function onDeclineButtonClicked(param1:Event) : void
      {
         this._gameAFKStatus.acceptedPoppedGame = false;
         this._gameAFKStatus.respondedToPoppedGame = true;
         this._onDeclined.dispatch(this._onDeclined);
      }
   }
}

