package com.riotgames.pvpnet.invite
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public interface IInviteController
   {
      
      function getVerifyInviteesHaveNotAcked() : ArrayCollection;
      
      function getOwnerChangedSignal() : ISignal;
      
      function invitePendingList() : void;
      
      function getSelectedGameQueueConfig() : GameQueueConfig;
      
      function getInviteGroupClearedSignal() : ISignal;
      
      function revokeInvitePower(param1:InviteParticipant) : void;
      
      function joinPracticeGame(param1:String, param2:String, param3:int) : void;
      
      function addRoomOccupants(param1:ChatRoom) : void;
      
      function getEnablePendingInvitesSignal() : ISignal;
      
      function setInviteGroupAsInvitee(param1:String, param2:String, param3:UnescapedJID, param4:Number, param5:String, param6:int, param7:Number, param8:Number, param9:String) : void;
      
      function getLeaveLobbyRequestedSignal() : ISignal;
      
      function checkAddInviteParticipants(param1:Array, param2:String = null, param3:String = "DEFAULT", param4:String = null) : void;
      
      function getInvitePowerDelegatedChangedSignal() : ISignal;
      
      function addToPendingInviteList(param1:Array) : void;
      
      function updateCustomGame(param1:GameDTO, param2:GameDTO, param3:Boolean, param4:ArrayCollection) : void;
      
      function resetPendingInviteList() : void;
      
      function verifyInviteesHaveAcked() : Boolean;
      
      function isLocalPlayer(param1:RosterItemVO) : Boolean;
      
      function getPracticeGameJoinedSignal() : ISignal;
      
      function getInviteGroupQuitSignal() : ISignal;
      
      function banUserFromPracticeGame(param1:String) : void;
      
      function arePlayersOnTeam(param1:ArrayCollection) : Boolean;
      
      function inviteBuddy(param1:Buddy) : void;
      
      function get pendingInviteList() : ArrayCollection;
      
      function cancelPlayerParticipant(param1:PlayerParticipant) : void;
      
      function transferOwnership(param1:Number) : void;
      
      function getPlayerQuittingGame() : Boolean;
      
      function hasAlreadyInvited(param1:RosterItemVO) : Boolean;
      
      function getDisablePendingInvitesSignal() : ISignal;
      
      function setInviteGroupCancel(param1:Boolean) : void;
      
      function delegateInvitePower(param1:InviteParticipant) : void;
      
      function getReInviteList() : Array;
      
      function setPlayerQuittingGame(param1:Boolean) : void;
      
      function getOwnershipTransferredSignal() : ISignal;
      
      function enablePendingInvites() : void;
      
      function getVerifyInviteesRequestedSignal() : ISignal;
      
      function getRankedTeamLobbyCreatedSignal() : ISignal;
      
      function createRankedTeamLobby(param1:String) : void;
      
      function invitePlayerBySummonerName(param1:String, param2:String, param3:String = null) : void;
      
      function reInviteParticipants(param1:Array) : void;
      
      function leaveLobby() : void;
      
      function setInviteGroupAsInvitor(param1:String, param2:Number, param3:Number, param4:String, param5:Boolean = false) : void;
      
      function getCloseLobbyRequestedSignal() : ISignal;
      
      function verifyInviteess() : void;
      
      function checkAddInviteParticipantsToRankedTeam(param1:Array, param2:String, param3:TeamId, param4:String = null) : void;
      
      function getParticipantsAddedArrangedTeamSignal() : ISignal;
      
      function getInviteLobbyCreatedSignal() : ISignal;
      
      function getInviteStatusListUpdatedSignal() : ISignal;
      
      function closeLobbyToAdditionalInvitees() : void;
      
      function getPlayersOnTeam(param1:ArrayCollection) : ArrayCollection;
      
      function disablePendingInvites() : void;
      
      function set pendingInviteList(param1:ArrayCollection) : void;
      
      function getParticipantCanceledSignal() : ISignal;
      
      function getParticipantsAddedPracticeGameSignal() : ISignal;
   }
}

