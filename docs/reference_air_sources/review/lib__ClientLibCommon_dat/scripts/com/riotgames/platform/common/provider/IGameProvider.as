package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.controllers.IGamePreloadController;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   
   public interface IGameProvider
   {
      
      function cancelGameFlow() : void;
      
      function getMatchmakingState() : String;
      
      function setPlayingDisconnected() : void;
      
      function getGameStateChanged() : ISignal;
      
      function set gameModel(param1:GameModel) : void;
      
      function getPreloadController() : IGamePreloadController;
      
      function set currentState(param1:String) : void;
      
      function get currentGame() : GameDTO;
      
      function cancelMatchmaking() : void;
      
      function joinPracticeGame(param1:GameDTO) : void;
      
      function get currentState() : String;
      
      function joinQueueWithMapName(param1:int, param2:Boolean, param3:String, param4:String) : void;
      
      function get gameModelChanged() : ISignal;
      
      function get gameModel() : GameModel;
      
      function getCurrentGameChanged() : ISignal;
   }
}

