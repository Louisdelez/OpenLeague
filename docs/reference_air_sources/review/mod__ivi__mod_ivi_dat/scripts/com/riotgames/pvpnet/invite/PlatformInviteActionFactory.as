package com.riotgames.pvpnet.invite
{
   import blix.action.IAction;
   import blix.action.NoopAction;
   import com.riotgames.notification.IDialogQueueProvider;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.GameInviteService;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.game.QuitPracticeGameAction;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.invite.action.ChangeInvitePrivilegesAction;
   import com.riotgames.pvpnet.invite.action.CloseLobbyAction;
   import com.riotgames.pvpnet.invite.action.CreateArrangedBotTeamLobbyAction;
   import com.riotgames.pvpnet.invite.action.CreateArrangedRankedTeamLobbyAction;
   import com.riotgames.pvpnet.invite.action.CreateArrangedTeamLobbyAction;
   import com.riotgames.pvpnet.invite.action.CreateGroupFinderLobbyAction;
   import com.riotgames.pvpnet.invite.action.GetLobbyStatusAction;
   import com.riotgames.pvpnet.invite.action.InvitePlayersAction;
   import com.riotgames.pvpnet.invite.action.JoinInviteChatRoomAction;
   import com.riotgames.pvpnet.invite.action.JoinInviteLobbyAction;
   import com.riotgames.pvpnet.invite.action.KickPlayerAction;
   import com.riotgames.pvpnet.invite.action.LeaveLobbyAction;
   import com.riotgames.pvpnet.invite.action.ProcessLobbyStatusAction;
   import com.riotgames.pvpnet.invite.action.RespondToInviteAction;
   import com.riotgames.pvpnet.invite.action.RetrievePendingInvitationsAction;
   import com.riotgames.pvpnet.invite.action.ShowGameInviteAction;
   import com.riotgames.pvpnet.invite.action.TransferOwnershipAction;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.invite.legacy.action.BeingGameFlowAction;
   import com.riotgames.pvpnet.invite.legacy.action.CoopVsAIGameInviteAcceptAction;
   import com.riotgames.pvpnet.invite.legacy.action.NormalGameInviteAcceptAction;
   import com.riotgames.pvpnet.invite.legacy.action.PracticeGameInviteAcceptAction;
   import com.riotgames.pvpnet.invite.legacy.action.QuitGameAction;
   import com.riotgames.pvpnet.invite.legacy.action.RankedGameInviteAcceptAction;
   import com.riotgames.pvpnet.invite.model.GameInvite;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import mx.resources.IResourceManager;
   
   public class PlatformInviteActionFactory
   {
      
      private var _resourceManager:IResourceManager;
      
      private var _notificationsProvider:INotificationsProvider;
      
      private var _masterGameController:MasterGameController;
      
      private var _gameInviteService:GameInviteService;
      
      private var _appController:IAppController;
      
      private var _gameTypeConfigManager:GameTypeConfigManager;
      
      private var _soundProvider:ISoundProvider;
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _gameService:GameService;
      
      private var _shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var _chatRoomProvider:IChatRoomProvider;
      
      private var _lobbyViewController:ILobbyViewController;
      
      private var _alerterProvider:IAlerterProvider;
      
      private var _presenceProvider:IPresenceProvider;
      
      private var _dialogQueueProvider:IDialogQueueProvider;
      
      public function PlatformInviteActionFactory(param1:INotificationsProvider, param2:GameInviteService, param3:GameService, param4:IResourceManager, param5:IAppController, param6:MasterGameController, param7:ILobbyViewController, param8:IDialogQueueProvider, param9:IAlerterProvider, param10:IPresenceProvider, param11:ISoundProvider, param12:InviteQueueManager, param13:GameTypeConfigManager)
      {
         super();
         this._gameInviteService = param2;
         this._gameService = param3;
         this._notificationsProvider = param1;
         this._resourceManager = param4;
         this._appController = param5;
         this._masterGameController = param6;
         this._lobbyViewController = param7;
         this._dialogQueueProvider = param8;
         this._alerterProvider = param9;
         this._presenceProvider = param10;
         this._soundProvider = param11;
         this._inviteQueueManager = param12;
         this._gameTypeConfigManager = param13;
      }
      
      public function getMapResourceString(param1:String, param2:int, param3:String) : String
      {
         return RiotResourceLoader.getMapResourceString(param1,param2,param3);
      }
      
      public function getCreateGroupFinderLobbyAction(param1:Number, param2:String) : IAction
      {
         return new CreateGroupFinderLobbyAction(param1,param2,this._gameInviteService,this);
      }
      
      public function getCloseLobbyAction() : IAction
      {
         return new CloseLobbyAction(this._gameInviteService,this);
      }
      
      public function getProcessLobbyStatusAction(param1:LobbyStatus, param2:InviteGroup) : IAction
      {
         return new ProcessLobbyStatusAction(param1,param2,this);
      }
      
      public function getJoinInviteChatRoomAction(param1:InviteGroup) : IAction
      {
         if(!this._chatRoomProvider || this._masterGameController.currentGame != null)
         {
            return new NoopAction();
         }
         return new JoinInviteChatRoomAction(this._chatRoomProvider,param1,this._presenceProvider);
      }
      
      public function getQuitPracticeGameAction() : IAction
      {
         return new QuitPracticeGameAction(this._masterGameController,this._gameService);
      }
      
      public function getCreateArrangedRankedTeamLobbyAction(param1:Number, param2:String) : IAction
      {
         return new CreateArrangedRankedTeamLobbyAction(param1,param2,this._gameInviteService,this);
      }
      
      public function getJoinInviteLobbyAction(param1:LobbyStatus, param2:InviteGroup, param3:IInviteController) : IAction
      {
         return new JoinInviteLobbyAction(param1,param2,param3,this);
      }
      
      public function getChangeInvitePrivilegesAction(param1:InviteParticipant, param2:Boolean) : IAction
      {
         return new ChangeInvitePrivilegesAction(param1,param2,this._gameInviteService,this);
      }
      
      public function getPracticeGameInviteAcceptAction(param1:int) : IAction
      {
         return new PracticeGameInviteAcceptAction(param1,this._appController,this._masterGameController);
      }
      
      public function getRiotResourceString(param1:String, param2:String, param3:Array = null) : String
      {
         return RiotResourceLoader.getString(param1,param2,param3);
      }
      
      public function getCreateArrangedBotTeamLobbyAction(param1:Number, param2:String) : IAction
      {
         return new CreateArrangedBotTeamLobbyAction(param1,param2,this._gameInviteService,this);
      }
      
      public function showDockedPrompt(param1:String, param2:String, param3:String, param4:Array) : void
      {
         var _loc5_:DockedPrompt = DockedPrompt.create(param2,param1,param3,param4[0]);
         this._notificationsProvider.showDockedPrompt(_loc5_);
      }
      
      public function playSound(param1:String) : void
      {
         this._soundProvider.play(param1);
      }
      
      public function getCoopVsAIGameInviteAcceptAction(param1:Boolean) : IAction
      {
         return new CoopVsAIGameInviteAcceptAction(this._appController,this._masterGameController,this._lobbyViewController,this._dialogQueueProvider,param1);
      }
      
      public function getShowGameInviteAction(param1:GameInvite, param2:IInviteController, param3:InviteGroup, param4:InviteQueueManager) : ShowGameInviteAction
      {
         return new ShowGameInviteAction(param1,param2,this._notificationsProvider,this._gameTypeConfigManager,this._shellDispatcher,this,param3,param4);
      }
      
      public function getInvitePlayersAction(param1:Array, param2:InviteGroup, param3:String, param4:String) : IAction
      {
         return new InvitePlayersAction(param1,param2,this._gameInviteService,this._notificationsProvider,this,param3,param4);
      }
      
      public function getRetrievePendingInvitationsAction() : IAction
      {
         return new RetrievePendingInvitationsAction(this._gameInviteService);
      }
      
      public function getBeginGameflowAction(param1:int, param2:String, param3:String, param4:String, param5:String, param6:int) : IAction
      {
         if(this._masterGameController.currentGame != null)
         {
            return new NoopAction();
         }
         return new BeingGameFlowAction(param1,param2,param3,param4,param5,param6,this._inviteQueueManager,this);
      }
      
      public function getRankedGameInviteAcceptAction(param1:Boolean) : IAction
      {
         return new RankedGameInviteAcceptAction(this._appController,this._masterGameController,this._lobbyViewController,this._dialogQueueProvider,param1);
      }
      
      public function getKickPlayerAction(param1:InviteParticipant) : IAction
      {
         return new KickPlayerAction(param1,this._gameInviteService,this);
      }
      
      public function getNormalGameInviteAcceptAction(param1:Boolean) : IAction
      {
         return new NormalGameInviteAcceptAction(this._appController,this._masterGameController,this._lobbyViewController,this._dialogQueueProvider,param1);
      }
      
      public function getTransferOwnershipAction(param1:InviteParticipant) : IAction
      {
         return new TransferOwnershipAction(param1,this._gameInviteService,this);
      }
      
      public function getCreateArrangedTeamLobbyAction(param1:Number) : IAction
      {
         return new CreateArrangedTeamLobbyAction(param1,this._gameInviteService,this);
      }
      
      public function setChatRoomProvider(param1:IChatRoomProvider) : void
      {
         this._chatRoomProvider = param1;
      }
      
      public function getLeaveLobbyAction() : IAction
      {
         return new LeaveLobbyAction(this._gameInviteService);
      }
      
      public function getQuitGameAction(param1:String, param2:Boolean = false) : IAction
      {
         return new QuitGameAction(param1,param2,this._masterGameController,this._appController,this._gameInviteService,this);
      }
      
      public function getRespondToInviteAction(param1:GameInvite, param2:IInviteController, param3:Boolean, param4:InviteGroup, param5:InviteQueueManager) : IAction
      {
         return new RespondToInviteAction(param1,param2,param3,this._gameInviteService,this,param4,param5);
      }
      
      public function getResourceManagerString(param1:String, param2:Array = null) : String
      {
         return this._resourceManager.getString("resources",param1,param2);
      }
      
      public function getGetLobbyStatusAction() : IAction
      {
         return new GetLobbyStatusAction(this._gameInviteService);
      }
   }
}

