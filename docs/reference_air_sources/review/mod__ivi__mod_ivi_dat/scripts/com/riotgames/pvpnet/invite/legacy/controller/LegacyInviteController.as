package com.riotgames.pvpnet.invite.legacy.controller
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   import com.riotgames.platform.gameclient.domain.ObfuscatedParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   import com.riotgames.platform.gameclient.domain.invite.InviteState;
   import com.riotgames.platform.gameclient.domain.invite.InviteVerificationState;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.services.SummonerService;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.invite.legacy.action.DisplayInviteErrorAlertAction;
   import com.riotgames.pvpnet.invite.legacy.action.InviteSummonerByNameAction;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.invite.validator.SendInviteValidator;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionActionFactory;
   import com.riotgames.pvpnet.suggestedplayers.SuggestedPlayersProviderProxy;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class LegacyInviteController extends EventDispatcher implements IInviteController
   {
      
      private var _ownershipTransferredSignal:Signal = new Signal();
      
      private var _practiceGameJoinedSignal:Signal = new Signal();
      
      private var _inviteQuitSignal:Signal = new Signal();
      
      private var _ownerChangedSignal:Signal = new Signal();
      
      private var _inviteStatusListUpdatedSignal:Signal = new Signal();
      
      private var _inviteClearedSignal:Signal = new Signal();
      
      private var _participantCanceledSignal:Signal = new Signal();
      
      private var _inviteGroup:InviteGroup;
      
      private var _enablePendingInvitesSignal:Signal = new Signal();
      
      private var _rankedTeamLobbyCreatedSignal:Signal = new Signal();
      
      private var _dockedNotificationsProvider:INotificationsProvider;
      
      private var _summonerService:SummonerService;
      
      private var _invitePowerDelegatedChangedSignal:Signal = new Signal();
      
      private var _participantsAddedArrangedTeamSignal:Signal = new Signal();
      
      private var _participantsAddedPracticeGameSignal:Signal = new Signal();
      
      private var _inviteLobbyCreated:Signal = new Signal();
      
      private var _verifyInviteesRequestedSignal:Signal = new Signal();
      
      private var _closeLobbyRequestedSignal:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger("com.riotgames.gameclient.controllers.game.InviteController");
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _playerQuitingGame:Boolean = new Boolean(false);
      
      private var _chatRosterProvider:IChatRosterProvider;
      
      private var _pendingInviteList:ArrayCollection = new ArrayCollection();
      
      private var _disablePendingInvitesSignal:Signal = new Signal();
      
      private var _leaveLobbyRequestedSignal:Signal = new Signal();
      
      private var _restrictionActionFactory:QueueRestrictionActionFactory;
      
      public function LegacyInviteController(param1:InviteQueueManager, param2:INotificationsProvider, param3:InviteGroup, param4:IChatRosterProvider, param5:SummonerService, param6:QueueRestrictionActionFactory)
      {
         super();
         this._inviteGroup = param3;
         this._inviteQueueManager = param1;
         this._dockedNotificationsProvider = param2;
         this._summonerService = param5;
         this._chatRosterProvider = param4;
         this._restrictionActionFactory = param6;
      }
      
      private function resetParticipantInviteState(param1:Boolean) : void
      {
         if(param1)
         {
            this._inviteGroup.isOwner = true;
            this._inviteGroup.inviteState = InviteState.INVITOR;
            this._inviteGroup.allowedToInvite = true;
            this._inviteGroup.isGroupOpenToMembers = true;
         }
         else
         {
            this._inviteGroup.isOwner = false;
            this._inviteGroup.inviteState = InviteState.INVITEE;
         }
      }
      
      private function updateParticipantState(param1:InviteParticipant, param2:String) : void
      {
         param1.status = param2;
         this.addParticipant(param1);
      }
      
      public function invitePendingList() : void
      {
         var _loc2_:RosterItemVO = null;
         var _loc1_:ArrayCollection = this.pendingInviteList;
         for each(_loc2_ in _loc1_)
         {
            this.checkAddInviteParticipants([_loc2_]);
         }
      }
      
      public function getSelectedGameQueueConfig() : GameQueueConfig
      {
         return this._inviteQueueManager.getSelectedGameQueueConfig();
      }
      
      private function set _401195970pendingInviteList(param1:ArrayCollection) : void
      {
         this._pendingInviteList = param1;
      }
      
      public function setInviteGroupAsInvitee(param1:String, param2:String, param3:UnescapedJID, param4:Number, param5:String, param6:int, param7:Number, param8:Number, param9:String) : void
      {
         if(isNaN(param4) && Boolean(param3))
         {
            param4 = parseInt(param3.bareJID.replace(Summoner.SUMMONER_INTERNAL_NAME_PREFIX,"").replace("@" + ClientConfig.JABBER_DOMAIN,""));
         }
         this._inviteGroup.reset(param1,param3,param4,param5,param6,param7,param8);
         this._inviteGroup.inviteState = InviteState.INVITEE;
         this._inviteGroup.isGroupOpenToMembers = false;
         this._inviteGroup.inviteId = param2;
         this._inviteGroup.groupId = param9;
      }
      
      public function joinPracticeGame(param1:String, param2:String, param3:int) : void
      {
         this._inviteGroup.myUserName = param2;
         this._inviteGroup.myUserIconId = param3;
         this._practiceGameJoinedSignal.dispatch(param1);
      }
      
      public function getInvitePowerDelegatedChangedSignal() : ISignal
      {
         return this._invitePowerDelegatedChangedSignal;
      }
      
      public function revokeInvitePower(param1:InviteParticipant) : void
      {
         param1 = this._inviteGroup.getParticipantByName(param1.name);
         param1.hasDelegatedInvitePower = false;
         this._inviteGroup.refresh();
         this._invitePowerDelegatedChangedSignal.dispatch(param1,false);
      }
      
      public function verifyInviteesHaveAcked() : Boolean
      {
         var _loc2_:InviteParticipant = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._inviteGroup.acceptedParticipants)
         {
            if(_loc2_.status != InviteParticipantState.OWNER)
            {
               _loc1_++;
               if(_loc2_.verificationState != InviteVerificationState.ACK)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      private function updateInviteStatusLists(param1:GameDTO, param2:ArrayCollection) : void
      {
         this._inviteStatusListUpdatedSignal.dispatch(param1,param2);
      }
      
      public function getPracticeGameJoinedSignal() : ISignal
      {
         return this._practiceGameJoinedSignal;
      }
      
      public function cancelPlayerParticipant(param1:PlayerParticipant) : void
      {
         var _loc2_:InviteParticipant = null;
         var _loc3_:Number = NaN;
         for each(_loc2_ in this._inviteGroup.participants)
         {
            _loc3_ = new Number(_loc2_.jid.node.substring(3));
            if(_loc3_ == param1.summonerId)
            {
               this.cancelInviteParticipant(_loc2_);
               return;
            }
         }
      }
      
      public function banUserFromPracticeGame(param1:String) : void
      {
         var _loc2_:InviteParticipant = this._inviteGroup.getParticipantByName(param1);
         if(_loc2_ != null)
         {
            this.updateParticipantState(_loc2_,InviteParticipantState.CANCEL);
         }
      }
      
      private function handleAddInviteGroupParticipant(param1:String, param2:InviteParticipant) : void
      {
         if(param1 == ButtonNameType.LEFT_BUTTON)
         {
            this.addInviteGroupParticipants([param2]);
         }
      }
      
      private function trackSuggestedPlayersData() : void
      {
         if(!this._inviteGroup || this._inviteGroup.inviteState != InviteState.INVITOR)
         {
            return;
         }
         var _loc1_:Number = -1;
         var _loc2_:GameQueueManager = this._inviteQueueManager.getGameQueueManager;
         var _loc3_:GameQueueConfig = _loc2_.selectedGameQueueConfig;
         if(_loc3_)
         {
            _loc1_ = Number(_loc3_.id);
         }
         SuggestedPlayersProviderProxy.instance.notifyLobbyDisbanded(_loc1_);
      }
      
      public function get pendingInviteList() : ArrayCollection
      {
         return this._pendingInviteList;
      }
      
      public function cancelInviteParticipant(param1:InviteParticipant) : void
      {
         if(!this._inviteGroup.isOwner)
         {
            return;
         }
         param1.status = InviteParticipantState.CANCEL;
         this.addParticipant(param1);
         this._participantCanceledSignal.dispatch(param1);
      }
      
      public function inviteBuddy(param1:Buddy) : void
      {
         var _loc2_:UnescapedJID = new UnescapedJID(ChatController.jidFromSummonerId(param1.getSummonerId()));
         var _loc3_:RosterItemVO = RosterItemVO.get(_loc2_,true);
         var _loc4_:AlertAction = null;
         if(!param1.getIsMutualFriend())
         {
            _loc3_.online = true;
            _loc3_.displayName = param1.getName();
            _loc3_.show = Presence.SHOW_CHAT;
         }
         else
         {
            if(!_loc3_.online)
            {
               _loc4_ = new AlertAction(MessageDictionary.PLAYER_NOT_ONLINE,param1.getName());
               _loc4_.add();
               return;
            }
            if(_loc3_.show == Presence.SHOW_DND)
            {
               _loc4_ = new AlertAction(MessageDictionary.PLAYER_NOT_AVAILABLE,param1.getName());
               _loc4_.add();
               return;
            }
         }
         this.checkAddInviteParticipants([_loc3_]);
      }
      
      public function getDisablePendingInvitesSignal() : ISignal
      {
         return this._disablePendingInvitesSignal;
      }
      
      public function createRankedTeamLobby(param1:String) : void
      {
         this._rankedTeamLobbyCreatedSignal.dispatch(param1);
      }
      
      public function getOwnershipTransferredSignal() : ISignal
      {
         return this._ownershipTransferredSignal;
      }
      
      public function enablePendingInvites() : void
      {
         this._enablePendingInvitesSignal.dispatch();
      }
      
      public function leaveLobby() : void
      {
         this._leaveLobbyRequestedSignal.dispatch();
      }
      
      public function setInviteGroupAsInvitor(param1:String, param2:Number, param3:Number, param4:String, param5:Boolean = false) : void
      {
         this._inviteGroup.reset(param1,this._inviteGroup.myJID,this._inviteGroup.mySummonerId,this._inviteGroup.myUserName,this._inviteGroup.myUserIconId,param2,param3);
         this._inviteGroup.inviteState = InviteState.INVITOR;
         this._inviteGroup.isGroupOpenToMembers = true;
         this._inviteGroup.inviteId = param4 == "" ? this.generateInviteId() : param4;
         if(!param5)
         {
            this._inviteLobbyCreated.dispatch();
         }
      }
      
      public function getCloseLobbyRequestedSignal() : ISignal
      {
         return this._closeLobbyRequestedSignal;
      }
      
      public function verifyInviteess() : void
      {
         var _loc1_:InviteParticipant = null;
         for each(_loc1_ in this._inviteGroup.acceptedParticipants)
         {
            if(_loc1_.status != InviteParticipantState.OWNER)
            {
               _loc1_.verificationState = InviteVerificationState.CLR;
            }
         }
         this._inviteGroup.refresh();
         this._verifyInviteesRequestedSignal.dispatch();
      }
      
      public function arePlayersOnTeam(param1:ArrayCollection) : Boolean
      {
         var _loc3_:IParticipant = null;
         var _loc4_:PlayerParticipant = null;
         var _loc5_:ObfuscatedParticipant = null;
         var _loc6_:Number = NaN;
         var _loc2_:ArrayCollection = this._inviteGroup.getparticipantIDCollectionIncludingLeavers();
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_ as PlayerParticipant;
            _loc5_ = _loc3_ as ObfuscatedParticipant;
            for each(_loc6_ in _loc2_)
            {
               if(Boolean(_loc4_) && _loc4_.summonerId == _loc6_)
               {
                  return true;
               }
               if(Boolean(_loc5_) && _loc5_.gameUniqueId == parseInt(_loc6_.toString()))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function getReInviteList() : Array
      {
         var _loc2_:InviteParticipant = null;
         var _loc3_:InviteParticipant = null;
         var _loc1_:Array = [];
         if(Boolean(this._inviteGroup.isOwner) && Boolean(this._inviteGroup.acceptedParticipants))
         {
            for each(_loc2_ in this._inviteGroup.acceptedParticipants)
            {
               if(!_loc2_.isOwner)
               {
                  _loc3_ = new InviteParticipant(_loc2_.jid,_loc2_.summonerId,_loc2_.name,null,_loc2_.profileIconId);
                  _loc1_.push(_loc3_);
               }
            }
         }
         return _loc1_;
      }
      
      public function checkAddInviteParticipantsToRankedTeam(param1:Array, param2:String, param3:TeamId, param4:String = null) : void
      {
         var _loc6_:String = null;
         var _loc7_:AlertAction = null;
         var _loc5_:GameQueueManager = this._inviteQueueManager.getGameQueueManager;
         if(_loc5_.rankedTeamName != GameQueueManager.TEAM_NAME_UNSELECTED && _loc5_.rankedTeamName != param2)
         {
            _loc6_ = "checkAddInviteParticipantsToRankedTeam: Inviting people from a different ranked team! was: " + _loc5_.rankedTeamName + " now: " + param2;
            this.logger.error(_loc6_);
            _loc7_ = new AlertAction(RiotResourceLoader.getString("general_generalAlertErrorTitle"),RiotResourceLoader.getString("rankedTeams_error_inviting_to_different_teams"));
            _loc7_.add();
         }
         else if(!_loc5_.selectedGameQueueConfig || !_loc5_.selectedGameQueueConfig.teamOnly)
         {
            _loc6_ = "checkAddInviteParticipantsToRankedTeam: Trying to invite to a ranked team, when we are not in a ranked team game!";
            this.logger.error(_loc6_);
            _loc7_ = new AlertAction(RiotResourceLoader.getString("general_generalAlertErrorTitle"),RiotResourceLoader.getString("rankedTeams_error_not_in_ranked_game"));
            _loc7_.add();
         }
         else
         {
            if(_loc5_.rankedTeamName == GameQueueManager.TEAM_NAME_UNSELECTED)
            {
               this._rankedTeamLobbyCreatedSignal.dispatch(param2);
            }
            _loc5_.rankedTeamName = param2;
            _loc5_.rankedTeamId = param3;
            this.checkAddInviteParticipants(param1,param4);
         }
      }
      
      private function okToAddRosterItemToInviteBay(param1:RosterItemVO) : Boolean
      {
         var _loc2_:RosterItemVO = null;
         if(param1.jid.node == this._inviteGroup.myJID.node)
         {
            return false;
         }
         for each(_loc2_ in this.pendingInviteList)
         {
            if(_loc2_.jid.node == param1.jid.node)
            {
               return false;
            }
         }
         return true;
      }
      
      public function closeLobbyToAdditionalInvitees() : void
      {
         this._closeLobbyRequestedSignal.dispatch();
      }
      
      public function getPlayersOnTeam(param1:ArrayCollection) : ArrayCollection
      {
         var _loc5_:PlayerParticipant = null;
         var _loc6_:Number = NaN;
         var _loc2_:ArrayCollection = this._inviteGroup.getparticipantIDCollectionIncludingLeavers();
         var _loc3_:ArrayCollection = new ArrayCollection();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_] is PlayerParticipant)
            {
               _loc5_ = param1[_loc4_] as PlayerParticipant;
               for each(_loc6_ in _loc2_)
               {
                  if(_loc5_.summonerId == _loc6_)
                  {
                     _loc3_.addItem(_loc5_);
                  }
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getInviteStatusListUpdatedSignal() : ISignal
      {
         return this._inviteStatusListUpdatedSignal;
      }
      
      public function set pendingInviteList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.pendingInviteList;
         if(_loc2_ !== param1)
         {
            this._401195970pendingInviteList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pendingInviteList",_loc2_,param1));
         }
      }
      
      public function getOwnerChangedSignal() : ISignal
      {
         return this._ownerChangedSignal;
      }
      
      public function getVerifyInviteesHaveNotAcked() : ArrayCollection
      {
         var _loc2_:InviteParticipant = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this._inviteGroup.acceptedParticipants)
         {
            if(_loc2_.status != InviteParticipantState.OWNER)
            {
               if(_loc2_.verificationState != InviteVerificationState.ACK)
               {
                  _loc1_.addItem(_loc2_.name);
               }
            }
         }
         return _loc1_;
      }
      
      public function changePracticeGameInviteGroupOwnership(param1:PlayerParticipant) : void
      {
         var _loc2_:InviteParticipant = new InviteParticipant(ChatController.unescapedJIDFromSummonerId(param1.summonerId),param1.summonerId,param1.summonerName,InviteParticipantState.OWNER,param1.profileIconId);
         _loc2_.isOwner = true;
         this._inviteGroup.ownerParticipant = _loc2_;
         this._inviteGroup.addParticipant(_loc2_);
         this._ownerChangedSignal.dispatch(_loc2_,param1);
      }
      
      public function transferPracticeGameInviteGroupOwnership(param1:GameDTO, param2:ArrayCollection) : void
      {
         this._inviteGroup.inviteState = InviteState.INVITOR;
         this._inviteGroup.isOwner = true;
         this._inviteGroup.isGroupOpenToMembers = true;
         if(this._inviteGroup.ownerParticipant == null)
         {
            return;
         }
         this._ownershipTransferredSignal.dispatch(param1,param2);
      }
      
      public function getInviteGroupClearedSignal() : ISignal
      {
         return this._inviteClearedSignal;
      }
      
      private function generateInviteId() : String
      {
         var _loc1_:int = Math.random() * int.MAX_VALUE;
         return _loc1_.toString();
      }
      
      public function getLeaveLobbyRequestedSignal() : ISignal
      {
         return this._leaveLobbyRequestedSignal;
      }
      
      public function checkAddInviteParticipants(param1:Array, param2:String = null, param3:String = "DEFAULT", param4:String = "") : void
      {
         var _loc6_:RosterItemVO = null;
         var _loc7_:Number = NaN;
         var _loc8_:InviteParticipant = null;
         var _loc9_:InviteParticipant = null;
         var _loc10_:Boolean = false;
         var _loc11_:SendInviteValidator = null;
         var _loc12_:GameQueueConfig = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:Function = null;
         var _loc17_:IAction = null;
         var _loc18_:DockedPrompt = null;
         if(!this._inviteGroup.isOwner && !this._inviteGroup.allowedToInvite)
         {
            return;
         }
         var _loc5_:Array = new Array();
         for each(_loc6_ in param1)
         {
            if(RosterUtility.isAvailableForInvite(_loc6_))
            {
               if(_loc6_.jid.node != this._inviteGroup.myJID.node)
               {
                  _loc7_ = parseFloat(_loc6_.jid.bareJID.replace("@pvp.net","").replace("sum",""));
                  _loc8_ = new InviteParticipant(_loc6_.jid,_loc7_,_loc6_.displayName);
                  _loc8_.profileIconId = PresenceController.getProfileIcon(_loc6_.status);
                  if(Boolean(param2) && param2.length > 0)
                  {
                     _loc8_.originalInvitor = param2;
                  }
                  _loc9_ = this._inviteGroup.getParticipant(_loc8_);
                  _loc10_ = false;
                  if(_loc9_ != null)
                  {
                     _loc9_.originalInvitor = _loc8_.originalInvitor;
                     _loc14_ = "";
                     _loc15_ = ResourceManager.getInstance().getString("resources","common_button_ok");
                     _loc16_ = this.handleAddInviteGroupParticipant;
                     switch(_loc9_.status)
                     {
                        case InviteParticipantState.PENDING:
                           _loc13_ = ResourceManager.getInstance().getString("resources","invite_participant_with_status_pending",[_loc9_.name]);
                           break;
                        case InviteParticipantState.ACCEPTED:
                           _loc10_ = true;
                           _loc13_ = ResourceManager.getInstance().getString("resources","invite_participant_with_status_accepted",[_loc9_.name]);
                           _loc14_ = ResourceManager.getInstance().getString("resources","common_button_ok");
                           _loc15_ = null;
                           _loc16_ = null;
                           break;
                        case InviteParticipantState.CREATOR:
                        case InviteParticipantState.JOINED:
                           _loc10_ = true;
                           _loc13_ = ResourceManager.getInstance().getString("resources","invite_already_invite_member_exception",[_loc9_.name]);
                           _loc14_ = ResourceManager.getInstance().getString("resources","common_button_ok");
                           _loc15_ = null;
                           _loc16_ = null;
                           break;
                        case InviteParticipantState.OWNER:
                           _loc10_ = true;
                           _loc13_ = ResourceManager.getInstance().getString("resources","invite_participant_is_owner",[_loc9_.name]);
                           _loc14_ = ResourceManager.getInstance().getString("resources","common_button_ok");
                           _loc15_ = null;
                           _loc16_ = null;
                           break;
                        case InviteParticipantState.CANCEL:
                           if(param2 == null)
                           {
                              _loc10_ = true;
                              if(this._inviteGroup.gameType == GameType.PRACTICE_GAME)
                              {
                                 _loc13_ = ResourceManager.getInstance().getString("resources","invite_participant_with_status_cancel_pg",[_loc9_.name]);
                                 _loc14_ = ResourceManager.getInstance().getString("resources","common_button_ok");
                                 _loc15_ = null;
                                 _loc16_ = null;
                              }
                              else
                              {
                                 _loc13_ = ResourceManager.getInstance().getString("resources","invite_participant_with_status_cancel",[_loc9_.name]);
                                 _loc14_ = ResourceManager.getInstance().getString("resources","inviteePanel_inviteBuddies_label");
                                 _loc15_ = ResourceManager.getInstance().getString("resources","common_button_cancel");
                              }
                           }
                     }
                  }
                  _loc11_ = new SendInviteValidator();
                  _loc12_ = this.getSelectedGameQueueConfig();
                  if(Boolean(_loc6_.online) && !_loc11_.rosterItemMeetsLevelRequirement(_loc6_,_loc12_))
                  {
                     _loc17_ = new DisplayInviteErrorAlertAction("invite_error_requirements",[_loc8_.name]);
                     _loc17_.invoke();
                  }
                  else if(_loc10_)
                  {
                     _loc18_ = DockedPrompt.create(_loc13_,ResourceManager.getInstance().getString("resources","XMPP-GAME-INVITE-TITLE"),_loc9_.name,_loc14_,_loc15_,null,_loc16_,_loc8_);
                     this._dockedNotificationsProvider.showDockedPrompt(_loc18_);
                  }
                  else
                  {
                     _loc5_.push(_loc8_);
                  }
               }
            }
         }
         if(_loc5_.length > 0)
         {
            this.addInviteGroupParticipants(_loc5_,param3,param4);
         }
      }
      
      public function getEnablePendingInvitesSignal() : ISignal
      {
         return this._enablePendingInvitesSignal;
      }
      
      public function resetPendingInviteList() : void
      {
         this.pendingInviteList.removeAll();
      }
      
      public function addToPendingInviteList(param1:Array) : void
      {
         var _loc2_:RosterItemVO = null;
         for each(_loc2_ in param1)
         {
            if(!this.pendingInviteList.contains(_loc2_))
            {
               if(this.okToAddRosterItemToInviteBay(_loc2_))
               {
                  this.pendingInviteList.addItem(_loc2_);
               }
            }
         }
      }
      
      public function addRoomOccupants(param1:ChatRoom) : void
      {
         var _loc2_:RoomOccupant = null;
         var _loc3_:InviteParticipant = null;
         this._inviteGroup.clearParticipants();
         for each(_loc2_ in param1.getRoomOccupants())
         {
            _loc3_ = new InviteParticipant();
            _loc3_.name = _loc2_.displayName;
            _loc3_.summonerId = 0;
            _loc3_.jid = _loc2_.jid;
            _loc3_.status = InviteParticipantState.ACCEPTED;
            this._inviteGroup.addParticipant(_loc3_);
         }
      }
      
      public function updateCustomGame(param1:GameDTO, param2:GameDTO, param3:Boolean, param4:ArrayCollection) : void
      {
         this.resetParticipantInviteState(param3);
         if(Boolean(param2 && param2.ownerSummary && param1 && param1.ownerSummary) && Boolean(param2.ownerSummary.accountId != param1.ownerSummary.accountId) && param3)
         {
            this.transferPracticeGameInviteGroupOwnership(param1,param4);
         }
         else if(Boolean(param2 && param2.ownerSummary && param1) && Boolean(param1.ownerSummary) && param2.ownerSummary.accountId != param1.ownerSummary.accountId)
         {
            this.changePracticeGameInviteGroupOwnership(param1.ownerSummary);
         }
         else if(param3)
         {
            this.updateInviteStatusLists(param1,param4);
         }
      }
      
      public function getInviteGroupQuitSignal() : ISignal
      {
         return this._inviteQuitSignal;
      }
      
      public function hasAlreadyInvited(param1:RosterItemVO) : Boolean
      {
         var _loc2_:InviteParticipant = this._inviteGroup.getParticipantByNode(param1.jid.node);
         if(_loc2_ != null && (Boolean(InviteParticipantState.isMemberState(_loc2_.status)) || _loc2_.status == InviteParticipantState.CANCEL))
         {
            return true;
         }
         return false;
      }
      
      public function getPlayerQuittingGame() : Boolean
      {
         return this._playerQuitingGame;
      }
      
      public function transferOwnership(param1:Number) : void
      {
         this._ownershipTransferredSignal.dispatch(param1);
      }
      
      public function delegateInvitePower(param1:InviteParticipant) : void
      {
         param1 = this._inviteGroup.getParticipantByName(param1.name);
         param1.hasDelegatedInvitePower = true;
         this._inviteGroup.refresh();
         this._invitePowerDelegatedChangedSignal.dispatch(param1,true);
      }
      
      public function getVerifyInviteesRequestedSignal() : ISignal
      {
         return this._verifyInviteesRequestedSignal;
      }
      
      public function setPlayerQuittingGame(param1:Boolean) : void
      {
         this._playerQuitingGame = param1;
      }
      
      public function setInviteGroupCancel(param1:Boolean) : void
      {
         if(this._inviteGroup.inviteState == InviteState.NONE)
         {
            return;
         }
         if(!param1)
         {
            this._inviteQuitSignal.dispatch();
            this.trackSuggestedPlayersData();
            this._inviteGroup.clear();
         }
         this._inviteGroup.inviteState = InviteState.NONE;
         this._inviteGroup.allowedToInvite = false;
         this._inviteGroup.isGroupOpenToMembers = false;
         this._inviteGroup.inviteId = "";
         this._inviteClearedSignal.dispatch();
      }
      
      public function invitePlayerBySummonerName(param1:String, param2:String, param3:String = "") : void
      {
         var _loc4_:GameQueueConfig = this.getSelectedGameQueueConfig();
         var _loc5_:IAction = new InviteSummonerByNameAction(param1,this._inviteGroup.myUserName,this._chatRosterProvider,this._summonerService,param2,_loc4_,param3);
         _loc5_.getCompleted().addOnce(this.handleRosterItemPrepared);
         _loc5_.invoke();
      }
      
      public function isLocalPlayer(param1:RosterItemVO) : Boolean
      {
         return param1.jid.node == this._inviteGroup.myJID.node;
      }
      
      private function addInviteGroupParticipants(param1:Array, param2:String = "DEFAULT", param3:String = "") : void
      {
         var _loc4_:InviteParticipant = null;
         if(!this._inviteGroup.isGroupOpenToMembers || this._inviteGroup.inviteId == null || this._inviteGroup.inviteId.length == 0)
         {
            this._inviteGroup.isGroupOpenToMembers = true;
            this._inviteGroup.inviteState = InviteState.INVITOR;
            if(this._inviteGroup.isOwner)
            {
               this._inviteGroup.inviteId = this.generateInviteId();
            }
         }
         if(Boolean(this._inviteGroup.isOwner) || Boolean(this._inviteGroup.allowedToInvite))
         {
            for each(_loc4_ in param1)
            {
               this.addParticipant(_loc4_);
            }
            if(this._inviteQueueManager.isPracticeGame())
            {
               this._participantsAddedPracticeGameSignal.dispatch(param1,this._inviteQueueManager.getGameTypeConfig(),param2,param3);
            }
            else
            {
               this._participantsAddedArrangedTeamSignal.dispatch(param1,this.getSelectedGameQueueConfig(),param2,param3);
            }
         }
      }
      
      public function getInviteLobbyCreatedSignal() : ISignal
      {
         return this._inviteLobbyCreated;
      }
      
      private function addParticipant(param1:InviteParticipant) : void
      {
         this._inviteGroup.addParticipant(param1);
      }
      
      public function reInviteParticipants(param1:Array) : void
      {
         if(!param1)
         {
            return;
         }
         this.addInviteGroupParticipants(param1);
      }
      
      public function getParticipantsAddedArrangedTeamSignal() : ISignal
      {
         return this._participantsAddedArrangedTeamSignal;
      }
      
      private function handleRosterItemPrepared(param1:InviteSummonerByNameAction) : void
      {
         var _loc2_:RosterItemVO = param1.successfullyInvitedPlayerRosterItem;
         var _loc3_:String = param1.inviteType;
         var _loc4_:String = param1.payload;
         this.checkAddInviteParticipants([_loc2_],null,_loc3_,_loc4_);
      }
      
      public function getRankedTeamLobbyCreatedSignal() : ISignal
      {
         return this._rankedTeamLobbyCreatedSignal;
      }
      
      public function disablePendingInvites() : void
      {
         this._disablePendingInvitesSignal.dispatch();
      }
      
      public function getParticipantCanceledSignal() : ISignal
      {
         return this._participantCanceledSignal;
      }
      
      public function getParticipantsAddedPracticeGameSignal() : ISignal
      {
         return this._participantsAddedPracticeGameSignal;
      }
   }
}

