package com.riotgames.pvpnet.game.controllers.preload
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import com.riotgames.platform.common.event.GameCrashedEvent;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.gameclient.championselection.GameSelectionData;
   import com.riotgames.platform.gameclient.controllers.IGamePreloadController;
   import com.riotgames.platform.gameclient.domain.PlayerCredentialsDTO;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.pvpnet.system.maestro.IMaestroProvider;
   import com.riotgames.pvpnet.system.maestro.MaestroController;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.display.NativeWindowDisplayState;
   import flash.events.Event;
   import flash.events.NativeWindowDisplayStateEvent;
   
   public class LolGamePreloadController implements IDestructible, IGamePreloadController
   {
      
      private var _shouldPreload:Boolean;
      
      private var _maestro:IMaestroProvider;
      
      private var _maestroStarted:Boolean;
      
      private var _summoner:Summoner;
      
      private var _readyToPlay:Boolean;
      
      private var _receivedMinimizeEvent:Boolean;
      
      private var _displayStateChangeSignal:ISignal;
      
      private var _currentlyPreloading:Boolean;
      
      private var _crashHandlersRegistered:Boolean;
      
      public function LolGamePreloadController(param1:Boolean, param2:Summoner, param3:IMaestroProvider, param4:Boolean)
      {
         super();
         this._shouldPreload = param1;
         this._maestro = param3;
         this._maestroStarted = param4;
         this._summoner = param2;
         this._readyToPlay = false;
         this._receivedMinimizeEvent = false;
         this._currentlyPreloading = false;
         this._crashHandlersRegistered = false;
         ShellDispatcher.instance.addEventListener(ShellEvent.MINIMIZE_TO_TRAY,this.handleShellMinimize);
      }
      
      public function setDisplayStateChangeSignal(param1:ISignal) : void
      {
         this._displayStateChangeSignal = param1;
         if(this._displayStateChangeSignal != null)
         {
            this._displayStateChangeSignal.add(this.displayStageChangeHandler,true);
         }
      }
      
      public function get isPreloadingEnabled() : Boolean
      {
         return this.getPreloadingReady();
      }
      
      public function set shouldPreload(param1:Boolean) : void
      {
         this._shouldPreload = param1;
      }
      
      public function startGamePreload(param1:GameSelectionData) : void
      {
         if(this.getPreloadingReady())
         {
            this._maestro.createClientAndPreload(param1.gameMap.mapId.toString());
            this._currentlyPreloading = true;
            this.addCrashHandlers();
         }
      }
      
      public function updateGamePreloadWithPlayerCredentials(param1:PlayerCredentialsDTO, param2:Summoner, param3:Boolean) : void
      {
         if(this.getPreloadingReady())
         {
            this._maestro.updatePreloadedGameWithCredentials(param1.serverIp,param1.serverPort.toString(),param1.encryptionKey,param2.sumId.toString());
            if(param3)
            {
               this.completePreload();
            }
         }
      }
      
      public function completePreload() : void
      {
         if(this._receivedMinimizeEvent && this.getPreloadingReady())
         {
            this.playPreloadedGame();
         }
         else
         {
            this._readyToPlay = true;
         }
      }
      
      private function displayStageChangeHandler(param1:NativeWindowDisplayStateEvent) : void
      {
         if(this._readyToPlay && this.getPreloadingReady())
         {
            if(param1.afterDisplayState == NativeWindowDisplayState.MINIMIZED)
            {
               this.playPreloadedGame();
            }
         }
      }
      
      private function handleShellMinimize(param1:ShellEvent) : void
      {
         if(this._readyToPlay && this.getPreloadingReady())
         {
            this.playPreloadedGame();
         }
         this._receivedMinimizeEvent = true;
      }
      
      private function onPreloadedGameCrashedOrAbandoned(param1:Event) : void
      {
         this._shouldPreload = false;
         this._currentlyPreloading = false;
         this.removeCrashHandlers();
      }
      
      public function haltPreload() : void
      {
         if(this.getPreloadingReady() && this._currentlyPreloading)
         {
            this.removeCrashHandlers();
            this._maestro.killGameClientProcess();
         }
      }
      
      private function playPreloadedGame() : void
      {
         this._maestro.playPreloadedGame();
         this._readyToPlay = false;
         this._currentlyPreloading = false;
         this.removeCrashHandlers();
      }
      
      private function addMaestroServiceListeners() : void
      {
      }
      
      private function removeMaestroServiceListeners() : void
      {
      }
      
      private function getPreloadingReady() : Boolean
      {
         return this._shouldPreload && this._maestro != null && this._maestroStarted;
      }
      
      private function addCrashHandlers() : void
      {
         if(!this._crashHandlersRegistered)
         {
            ShellDispatcher.instance.addEventListener(GameCrashedEvent.CRASHED_EVENT_FROM_GAME,this.onPreloadedGameCrashedOrAbandoned);
            ShellDispatcher.instance.addEventListener(MaestroController.GAME_ABANDONED,this.onPreloadedGameCrashedOrAbandoned);
            this._crashHandlersRegistered = true;
         }
      }
      
      private function removeCrashHandlers() : void
      {
         if(this._crashHandlersRegistered)
         {
            ShellDispatcher.instance.removeEventListener(GameCrashedEvent.CRASHED_EVENT_FROM_GAME,this.onPreloadedGameCrashedOrAbandoned);
            ShellDispatcher.instance.removeEventListener(MaestroController.GAME_ABANDONED,this.onPreloadedGameCrashedOrAbandoned);
            this._crashHandlersRegistered = false;
         }
      }
      
      public function destroy() : void
      {
         if(this._displayStateChangeSignal != null)
         {
            this._displayStateChangeSignal.remove(this.displayStageChangeHandler);
         }
         this.haltPreload();
         this.removeMaestroServiceListeners();
         this.removeCrashHandlers();
         ShellDispatcher.instance.removeEventListener(ShellEvent.MINIMIZE_TO_TRAY,this.handleShellMinimize);
         this._maestro = null;
      }
   }
}

