package com.riotgames.platform.gameclient.module.rt.view.history
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.model.HistoryProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.views.models.ProfileDisplayModel;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class HistoryViewMediator extends Mediator
   {
      
      public static const NAME:String = "HistoryViewMediator";
      
      public function HistoryViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ProfileTeamProxy.PROFILE_TEAM_CHANGE,HistoryProxy.MATCH_DETAILS_LOADING,HistoryProxy.MATCH_DETAILS_CHANGED];
      }
      
      private function get view() : HistoryView
      {
         return this.viewComponent as HistoryView;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.view.backToMatchDetailsSignal.add(this.onBackToMatchDetails);
         this.refreshView();
      }
      
      override public function onRemove() : void
      {
         this.view.backToMatchDetailsSignal.remove(this.onBackToMatchDetails);
      }
      
      private function refreshView() : void
      {
         var _loc1_:Team = RTFacade.profileTeamProxy.team;
         if(_loc1_)
         {
            this.view.showSummaries(_loc1_.matchHistory);
            this.view.showDetails(null,false,null);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case HistoryProxy.MATCH_DETAILS_LOADING:
               this.showLoading();
               break;
            case HistoryProxy.MATCH_DETAILS_CHANGED:
               this.view.showDetails(RTFacade.historyProxy.currentDetails,false,RTFacade.historyProxy.currentMatchHistory);
               break;
            case ProfileTeamProxy.PROFILE_TEAM_CHANGE:
               this.refreshView();
         }
      }
      
      private function onBackToMatchDetails() : void
      {
         RTFacade.instance.rtProvider.requestReturnToMatchDetails();
         var _loc1_:ProfileDisplayModel = RTFacade.instance.rtProvider.profileDisplayModel;
         _loc1_.activeView = ProfileDisplayModel.RANKED_TEAMS_VIEW;
         _loc1_.update();
      }
      
      private function showLoading() : void
      {
         this.view.showDetails(null,true,null);
      }
   }
}

