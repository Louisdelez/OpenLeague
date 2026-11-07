package com.riotgames.platform.gameclient.module.rt.model
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.controller.RTShowServiceError;
   import mx.rpc.events.ResultEvent;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class HistoryProxy extends Proxy
   {
      
      public static const NAME:String = "HistoryProxy";
      
      public static const MATCH_DETAILS_CHANGED:String = "MATCH_DETAILS_CHANGED";
      
      public static const MATCH_DETAILS_LOADING:String = "MATCH_DETAILS_LOADING";
      
      private var _currentDetails:EndOfGameStats;
      
      private var _currentMatchHistory:MatchHistorySummary;
      
      public function HistoryProxy()
      {
         super(NAME,null);
      }
      
      public function get currentDetails() : EndOfGameStats
      {
         return this._currentDetails;
      }
      
      public function loadMatchDetails(param1:MatchHistorySummary) : void
      {
         this._currentMatchHistory = param1;
         RTFacade.instance.sendNotification(MATCH_DETAILS_LOADING);
         this.serviceStateProxy.onServiceCall();
         var _loc2_:ServiceProxy = RTFacade.instance.rtProvider.serviceProxy;
         var _loc3_:Team = RTFacade.profileTeamProxy.team;
         _loc2_.playerStatsService.getTeamEndOfGameStats(_loc3_.teamId,param1.gameId,this.onGetDetailsSuccess,this.onGetDetailsComplete,this.onGetDetailsError);
      }
      
      private function onGetDetailsComplete(param1:Object) : void
      {
         this.serviceStateProxy.onServiceCallComplete();
      }
      
      public function get currentMatchHistory() : MatchHistorySummary
      {
         return this._currentMatchHistory;
      }
      
      private function onGetDetailsSuccess(param1:ResultEvent) : void
      {
         if(param1.result is EndOfGameStats)
         {
            this.showMatchDetails(param1.result as EndOfGameStats);
         }
         else
         {
            this.showMatchDetails(null);
         }
      }
      
      private function get serviceStateProxy() : ServiceStateProxy
      {
         return RTFacade.instance.retrieveProxy(ServiceStateProxy.NAME) as ServiceStateProxy;
      }
      
      public function showMatchDetails(param1:EndOfGameStats) : void
      {
         this._currentDetails = param1;
         RTFacade.instance.sendNotification(MATCH_DETAILS_CHANGED);
      }
      
      private function onGetDetailsError(param1:Object) : void
      {
         facade.sendNotification(RTShowServiceError.SHOW_ERROR,param1);
      }
   }
}

