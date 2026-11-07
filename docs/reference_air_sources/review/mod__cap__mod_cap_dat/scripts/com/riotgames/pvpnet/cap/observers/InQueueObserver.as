package com.riotgames.pvpnet.cap.observers
{
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.MatchMakingState;
   
   public class InQueueObserver implements IObserver
   {
      
      private var _model:CapModel;
      
      private var _lobbyViewController:ILobbyViewController;
      
      public function InQueueObserver(param1:CapModel, param2:ILobbyViewController)
      {
         super();
         this._model = param1;
         this._lobbyViewController = param2;
      }
      
      private function isInQueue() : Boolean
      {
         return this._model.inSoloQuery || this._model.inMatchmakingQueue;
      }
      
      public function setupSignals() : void
      {
         this._model.inSoloQueryChanged.add(this.onQueueStateChanged);
         this._model.inMatchmakingQueueChanged.add(this.onQueueStateChanged);
      }
      
      public function removeSignals() : void
      {
         this._model.inSoloQueryChanged.remove(this.onQueueStateChanged);
         this._model.inMatchmakingQueueChanged.remove(this.onQueueStateChanged);
      }
      
      public function destroy() : void
      {
         this.removeSignals();
      }
      
      private function onQueueStateChanged() : void
      {
         if(this.isInQueue())
         {
            this._lobbyViewController.matchmakingState = MatchMakingState.MATCHMAKING_QUEUED;
         }
         else
         {
            this._lobbyViewController.matchmakingState = MatchMakingState.MATCHMAKING_CAP;
         }
      }
      
      public function refresh() : void
      {
         this.onQueueStateChanged();
      }
   }
}

