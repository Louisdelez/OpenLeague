package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class JoinInviteLobbyAction extends BasicAction
   {
      
      private var _inviteController:IInviteController;
      
      private var _lobbyStatus:LobbyStatus;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _inviteGroup:InviteGroup;
      
      public function JoinInviteLobbyAction(param1:LobbyStatus, param2:InviteGroup, param3:IInviteController, param4:PlatformInviteActionFactory)
      {
         super(false);
         this._lobbyStatus = param1;
         this._inviteGroup = param2;
         this._inviteController = param3;
         this._inviteActionFactory = param4;
      }
      
      private function populateInvitees() : void
      {
         this._inviteActionFactory.getProcessLobbyStatusAction(this._lobbyStatus,this._inviteGroup).invoke();
      }
      
      private function setInviteLobbyState() : void
      {
         if(this._lobbyStatus.owner.summonerId != this._inviteGroup.mySummonerId)
         {
            this._inviteController.setInviteGroupAsInvitee(this._lobbyStatus.gameType,this._lobbyStatus.invitationId,ChatController.unescapedJIDFromSummonerId(this._lobbyStatus.owner.summonerId),this._lobbyStatus.owner.summonerId,this._lobbyStatus.owner.summonerName,0,0,this._lobbyStatus.mapId,"");
         }
         else
         {
            this._inviteController.setInviteGroupAsInvitor(this._lobbyStatus.gameType,0,this._lobbyStatus.mapId,this._lobbyStatus.invitationId,true);
         }
      }
      
      private function beginGameFlow() : void
      {
         this._inviteActionFactory.getBeginGameflowAction(this._lobbyStatus.queueId,this._lobbyStatus.gameDifficulty,this._lobbyStatus.rankedTeamName,this._lobbyStatus.rankedTeamId,this._lobbyStatus.gameType,this._lobbyStatus.mapId).invoke();
      }
      
      override protected function doInvocation() : void
      {
         if(this._lobbyStatus.gameType != GameType.PRACTICE_GAME)
         {
            this.beginGameFlow();
         }
         this.setInviteLobbyState();
         this.populateInvitees();
         this.joinChatRoom();
      }
      
      private function joinChatRoom() : void
      {
         var _loc1_:IAction = this._inviteActionFactory.getJoinInviteChatRoomAction(this._inviteGroup);
         _loc1_.invoke();
      }
   }
}

