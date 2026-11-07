package com.riotgames.platform.gameclient.controllers.summoner
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class PlayTutorialGameController
   {
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session = Session.instance;
      
      public var viewMediator:ViewMediator;
      
      public var lobbyController:ILobbyViewController;
      
      public var masterGameController:MasterGameController;
      
      public function PlayTutorialGameController()
      {
         super();
      }
      
      private function onSaveSummonerComplete(param1:Boolean) : void
      {
      }
      
      private function onSaveSummoner(param1:ResultEvent) : void
      {
      }
      
      public function playTutorialGame() : void
      {
         this.viewMediator.handlePlayTutorialClose();
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_TUTORIAL_GAME_STATE);
         this.masterGameController.startTutorialGame();
      }
      
      public function showLobby() : void
      {
         this.viewMediator.handlePlayTutorialClose();
      }
      
      public function saveSummonerTutorialFlag() : void
      {
         this.session.summoner.tutorialFlag = true;
         this.serviceProxy.summonerService.saveSeenTutorialFlag(this.onSaveSummoner,this.onSaveSummonerComplete);
      }
   }
}

