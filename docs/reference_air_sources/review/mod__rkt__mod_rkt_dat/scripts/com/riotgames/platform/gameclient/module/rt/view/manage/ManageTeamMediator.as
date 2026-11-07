package com.riotgames.platform.gameclient.module.rt.view.manage
{
   import com.riotgames.platform.common.event.RosterProviderEvent;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.controller.RTPromoteCaptainCommand;
   import com.riotgames.platform.gameclient.module.rt.model.*;
   import com.riotgames.platform.gameclient.module.rt.view.modal.ModalTeamMediator;
   import flash.events.MouseEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class ManageTeamMediator extends Mediator
   {
      
      public static const NAME:String = "ManageTeamMediator";
      
      public function ManageTeamMediator(param1:String = "ManageTeamMediator", param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function refreshView() : void
      {
         this.view.setTeamData(RTFacade.profileTeamProxy.team,RTFacade.instance.rtProvider.rosterProvider.getAllRosterBuddies());
      }
      
      public function setupView() : void
      {
         this.view.promoteButton.addEventListener(MouseEvent.CLICK,this.onPromoteClick);
         if(this.profileTeam)
         {
            this.refreshView();
         }
      }
      
      public function get view() : ManageTeamView
      {
         return viewComponent as ManageTeamView;
      }
      
      public function get profileTeam() : Team
      {
         return ProfileTeamProxy(RTFacade.instance.retrieveProxy(ProfileTeamProxy.NAME)).team;
      }
      
      private function onPromoteClick(param1:MouseEvent) : void
      {
         sendNotification(RTPromoteCaptainCommand.PROMOTE,RTPromoteCaptainCommand.BuildCommandArgs(RTFacade.profileTeamProxy.team));
      }
      
      override public function onRegister() : void
      {
         this.onCreationComplete();
         super.onRegister();
      }
      
      private function memberFilterFunction(param1:Object) : Boolean
      {
         return param1.statusString == TeamMemberStatus.MEMBER;
      }
      
      public function get playerProxy() : PlayerProxy
      {
         return RTFacade.instance.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
      }
      
      private function onRosterChanged() : void
      {
         this.refreshView();
      }
      
      public function get modalMediator() : ModalTeamMediator
      {
         return RTFacade.instance.retrieveMediator(ModalTeamMediator.NAME) as ModalTeamMediator;
      }
      
      public function onCreationComplete() : void
      {
         this.setupView();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [RTNotificationConstants.RT_MODULE_TEARDOWN,ProfileTeamProxy.PROFILE_TEAM_CHANGE,RosterProviderEvent.ROSTER_CHANGED];
      }
      
      private function inviteFilterFunction(param1:Object) : Boolean
      {
         return param1.statusString == TeamMemberStatus.INVITED;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ProfileTeamProxy.PROFILE_TEAM_CHANGE:
               this.refreshView();
               break;
            case RosterProviderEvent.ROSTER_CHANGED:
               this.onRosterChanged();
               break;
            case RTNotificationConstants.RT_MODULE_TEARDOWN:
         }
      }
      
      public function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
   }
}

