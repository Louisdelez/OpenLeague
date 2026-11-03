package com.riotgames.pvpnet.cap.observers
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.MatchMakingState;
   
   public class CapModuleRequestedObserver implements IObserver
   {
      
      private static const TO_STATE_INDEX:int = 0;
      
      private static const FROM_STATE_INDEX:int = 1;
      
      private static const ignorableStateTransitions:Array = [[MatchMakingState.MATCHMAKING_CAP,MatchMakingState.MATCHMAKING_CAP],[MatchMakingState.MATCHMAKING_QUEUED,MatchMakingState.MATCHMAKING_CAP],[MatchMakingState.MATCHMAKING_CAP,MatchMakingState.MATCHMAKING_QUEUED]];
      
      private var _lobbyController:ILobbyViewController;
      
      private var _deactivatedSignal:Signal = new Signal();
      
      private var _activatedSignal:Signal = new Signal();
      
      public function CapModuleRequestedObserver(param1:ILobbyViewController)
      {
         super();
         this._lobbyController = param1;
      }
      
      public function get activatedSignal() : ISignal
      {
         return this._activatedSignal;
      }
      
      public function destroy() : void
      {
         this.removeSignals();
         this._activatedSignal.removeAll();
         this._deactivatedSignal.removeAll();
      }
      
      private function onMatchmakingStateChanged(param1:String, param2:String) : void
      {
         var _loc3_:Array = null;
         for each(_loc3_ in ignorableStateTransitions)
         {
            if(param2 == _loc3_[TO_STATE_INDEX] && param1 == _loc3_[FROM_STATE_INDEX])
            {
               return;
            }
         }
         if(param1 == MatchMakingState.MATCHMAKING_CAP || param1 == MatchMakingState.MATCHMAKING_QUEUED)
         {
            this._deactivatedSignal.dispatch();
         }
         else if(param2 == MatchMakingState.MATCHMAKING_CAP)
         {
            this._activatedSignal.dispatch();
         }
      }
      
      public function removeSignals() : void
      {
         this._lobbyController.matchmakingStateChanged.remove(this.onMatchmakingStateChanged);
      }
      
      public function setupSignals() : void
      {
         this._lobbyController.matchmakingStateChanged.add(this.onMatchmakingStateChanged);
      }
      
      public function get deactivatedSignal() : ISignal
      {
         return this._deactivatedSignal;
      }
      
      public function refresh() : void
      {
      }
   }
}

