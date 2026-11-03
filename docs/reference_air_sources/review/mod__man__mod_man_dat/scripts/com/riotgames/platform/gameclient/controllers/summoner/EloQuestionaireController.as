package com.riotgames.platform.gameclient.controllers.summoner
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class EloQuestionaireController
   {
      
      public var isBusy:Boolean = false;
      
      public var session:Session = Session.instance;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var viewMediator:ViewMediator;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public function EloQuestionaireController()
      {
         super();
      }
      
      public function confirmQuestionaire(param1:String) : void
      {
         this.serviceProxy.playerStatsService.processEloQuestionaire(param1,this.onSaveEloQuestionaireSuccess,this.onSaveEloQuestionaireComplete);
         this.session.summoner.displayEloQuestionaire = false;
         this.isBusy = true;
      }
      
      public function showLobby() : void
      {
         this.viewMediator.handlePlayTutorialClose();
      }
      
      private function onSaveEloQuestionaireComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      private function onSaveEloQuestionaireSuccess(param1:ResultEvent) : void
      {
      }
      
      public function continueCreateSummonerFlow(param1:String = null) : void
      {
         this.viewMediator.continueCreateSummonerFlow(param1);
      }
   }
}

