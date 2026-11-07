package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import com.riotgames.platform.common.event.RosterProviderEvent;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.controller.RTLeaveTeamCommand;
   import com.riotgames.platform.gameclient.module.rt.model.PlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class ProfileTeamMediator extends Mediator
   {
      
      public static const NAME:String = "ProfileTeamMediator";
      
      public function ProfileTeamMediator(param1:String = "ProfileTeamMediator", param2:Object = null)
      {
         super(param1,param2);
      }
      
      protected function refreshView() : void
      {
         this.view.profileContent.showTeam(this.profileTeamProxy.team);
         this.checkIfInvited();
         this.refreshRosterStatus();
      }
      
      private function setupView() : void
      {
         this.view.btnInvitedAccept.add(this.onAcceptClicked);
         this.view.btnInvitedDecline.add(this.onDeclineClicked);
         this.view.profileContent.leaveButton.addEventListener(MouseEvent.CLICK,this.onLeaveTeamClicked);
         this.view.profileContent.inviteAllButton.addEventListener(MouseEvent.CLICK,this.onInviteToChatClicked);
         if(this.profileTeam)
         {
            this.refreshView();
         }
      }
      
      private function get view() : ProfileTeamView
      {
         return viewComponent as ProfileTeamView;
      }
      
      private function get profileTeam() : Team
      {
         return ProfileTeamProxy(RTFacade.instance.retrieveProxy(ProfileTeamProxy.NAME)).team;
      }
      
      private function get profileTeamProxy() : ProfileTeamProxy
      {
         return facade.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.onCreationComplete();
      }
      
      private function memberFilterFunction(param1:Object) : Boolean
      {
         return param1.statusString == TeamMemberStatus.MEMBER;
      }
      
      private function onInviteToChatClicked(param1:MouseEvent) : void
      {
         var _loc5_:TeamMemberInfo = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc2_:Array = [];
         var _loc3_:Team = this.profileTeamProxy.team;
         var _loc4_:ArrayCollection = _loc3_.roster.memberList;
         for each(_loc5_ in _loc4_)
         {
            _loc8_ = RTFacade.instance.rtProvider.session.summoner.sumId == _loc5_.playerId;
            if(!_loc8_)
            {
               _loc2_.push(_loc5_.playerId);
            }
         }
         _loc6_ = RTResource.getString("teamChatRoomName",[_loc3_.tag,_loc3_.name]);
         _loc7_ = RTResource.getString("inviteAllToChatMessage",[_loc3_.tag,_loc3_.name]);
         RTFacade.instance.rtProvider.chatRoomProvider.inviteSummonersToChatRoom(_loc2_,_loc6_,_loc6_,"tm",_loc7_,true);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ProfileTeamProxy.PROFILE_TEAM_CHANGE,RosterProviderEvent.ROSTER_CHANGED,RTNotificationConstants.RT_MODULE_STARTUP,RTNotificationConstants.RT_MODULE_TEARDOWN];
      }
      
      protected function onAcceptClicked() : void
      {
         this.playerProxy.joinTeam(this.profileTeamProxy.team.teamId);
      }
      
      protected function onDeclineClicked() : void
      {
         this.playerProxy.declineInvite(this.profileTeamProxy.team.teamId);
      }
      
      private function onLeaveTeamClicked(param1:MouseEvent) : void
      {
         sendNotification(RTLeaveTeamCommand.LEAVE,RTLeaveTeamCommand.BuildCommandArgs(this.profileTeamProxy.team));
      }
      
      private function get playerProxy() : PlayerProxy
      {
         return facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
      }
      
      private function checkIfInvited() : void
      {
         var _loc1_:TeamMemberInfo = null;
         if(this.profileTeamProxy.team)
         {
            for each(_loc1_ in this.profileTeamProxy.team.roster.memberList)
            {
               if(_loc1_.playerId == RTFacade.instance.rtProvider.session.summoner.sumId && _loc1_.status == TeamMemberStatus.INVITED)
               {
                  this.view.isInvited = true;
                  return;
               }
            }
         }
         this.view.isInvited = false;
      }
      
      private function onCreationComplete() : void
      {
         this.setupView();
      }
      
      private function refreshRosterStatus() : void
      {
         this.view.profileContent.showTeamRoster(this.profileTeamProxy.team,RTFacade.instance.rtProvider.rosterProvider.getAllRosterBuddies());
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ProfileTeamProxy.PROFILE_TEAM_CHANGE:
               this.refreshView();
               break;
            case RosterProviderEvent.ROSTER_CHANGED:
               this.refreshRosterStatus();
               break;
            case RTNotificationConstants.RT_MODULE_STARTUP:
            case RTNotificationConstants.RT_MODULE_TEARDOWN:
         }
      }
   }
}

