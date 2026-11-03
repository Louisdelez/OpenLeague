package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.controllers.IGamePreloadController;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class GameProviderProxy extends ProviderProxyBase implements IGameProvider
   {
      
      private static var _instance:GameProviderProxy;
      
      public function GameProviderProxy()
      {
         super(IGameProvider);
      }
      
      public static function get instance() : GameProviderProxy
      {
         if(_instance == null)
         {
            _instance = new GameProviderProxy();
         }
         return _instance;
      }
      
      public function setPlayingDisconnected() : void
      {
         _invoke("setPlayingDisconnected");
      }
      
      public function getPreloadController() : IGamePreloadController
      {
         return _invoke("getPreloadController");
      }
      
      public function get currentGame() : GameDTO
      {
         return _invokeGetter("currentGame");
      }
      
      public function joinPracticeGame(param1:GameDTO) : void
      {
         _invoke("joinPracticeGame",[param1]);
      }
      
      public function joinQueueWithMapName(param1:int, param2:Boolean, param3:String, param4:String) : void
      {
         _invoke("joinQueueWithMapName",[param1,param2,param3,param4]);
      }
      
      public function get gameModelChanged() : ISignal
      {
         return _invokeGetter("gameModelChanged");
      }
      
      public function cancelMatchmaking() : void
      {
         _invoke("cancelMatchmaking");
      }
      
      public function getCurrentGameChanged() : ISignal
      {
         return _invoke("getCurrentGameChanged");
      }
      
      public function get currentState() : String
      {
         return _invokeGetter("currentState");
      }
      
      public function cancelGameFlow() : void
      {
         _invoke("cancelGameFlow");
      }
      
      public function getGameStateChanged() : ISignal
      {
         return _invoke("getGameStateChanged");
      }
      
      public function get gameModel() : GameModel
      {
         return _invokeGetter("currentGame");
      }
      
      public function set currentState(param1:String) : void
      {
         _invokeSetter("currentState",param1);
      }
      
      public function set gameModel(param1:GameModel) : void
      {
         _invokeSetter("gameModel",param1);
      }
      
      public function getMatchmakingState() : String
      {
         return _invoke("getMatchmakingState");
      }
   }
}

