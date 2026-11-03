package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.model.PlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.module.rt.view.modal.ModalTeamMediator;
   import com.riotgames.platform.gameclient.module.rt.view.modal.TwoButtonGenericModalData;
   import com.riotgames.platform.gameclient.module.rt.vo.ErrorMessageVO;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTLeaveTeamCommand extends RTSimpleCommand
   {
      
      public static const LEAVE:String = "RTLeaveTeamCommand.LEAVE";
      
      public var team:Team;
      
      public function RTLeaveTeamCommand()
      {
         super();
      }
      
      private static function get shellDispatcher() : ShellDispatcher
      {
         return RTFacade.instance.rtProvider.shellDispatcher;
      }
      
      public static function BuildCommandArgs(param1:Team) : Object
      {
         return {"team":param1};
      }
      
      private static function get modalTeamMediator() : ModalTeamMediator
      {
         return RTFacade.modalMediator;
      }
      
      private function onLeaveTeamClicked() : void
      {
         this.playerProxy.leaveTeam(this.team.teamId);
      }
      
      private function get playerProxy() : PlayerProxy
      {
         return facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
      }
      
      private function onDisbandTeamClicked() : void
      {
         this.playerProxy.disbandTeam(this.team.teamId);
      }
      
      private function onOwnerLeaveTeamClicked(param1:TeamMemberInfo) : void
      {
         if(param1)
         {
            this.playerProxy.ownerLeaveTeam(param1.playerId,this.team.teamId);
         }
         else
         {
            sendNotification(RTErrorCommand.ERROR,new ErrorMessageVO("RT_NOT_TEAM_OWNER"));
         }
      }
      
      private function get profileTeamProxy() : ProfileTeamProxy
      {
         return facade.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:TwoButtonGenericModalData = null;
         var _loc5_:ArrayCollection = null;
         this.team = param1.getBody().team;
         var _loc2_:TeamMemberInfo = ProfileTeamProxy.findLocalMember(this.team);
         if(!_loc2_ || _loc2_.status != TeamMemberStatus.MEMBER)
         {
            sendNotification(RTErrorCommand.ERROR,new ErrorMessageVO("RT_NOT_TEAM_MEMBER"));
            return;
         }
         var _loc4_:uint = ProfileTeamProxy.countTeamMembers(this.team);
         if(_loc4_ == 1)
         {
            modalTeamMediator.showDisbandTeamModal(this.team.name,this.onDisbandTeamClicked);
         }
         else if(this.team.roster.ownerId == _loc2_.playerId)
         {
            _loc5_ = ProfileTeamProxy.findOwnerCandidates(this.team);
            modalTeamMediator.showPromoteCaptainModal(_loc5_,RTResource.getString("rankedTeams_profile_leave_team_owner_warning"),RTResource.getString("rankedTeams_profile_leave_team_button_label"),this.onOwnerLeaveTeamClicked);
         }
         else
         {
            _loc3_ = new TwoButtonGenericModalData();
            _loc3_.title = RTResource.getString("LeaveTeam");
            _loc3_.leftButtonLabel = ResourceManager.getInstance().getString("resources","common_button_cancel");
            _loc3_.rightButtonLabel = RTResource.getString("rankedTeams_profile_leave_team_button_label");
            _loc3_.message = RTResource.getString("rankedTeams_profile_leave_team_warning");
            _loc3_.rightButtonCallback = this.onLeaveTeamClicked;
            modalTeamMediator.showTwoButtonGenericModal(_loc3_);
         }
      }
   }
}

