package com.riotgames.pvpnet.invite
{
   import blix.action.IAction;
   import blix.action.SequenceAction;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.notification.IDialogQueueProvider;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.provider.ILeagueDataProvider;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatBlockedRosterProviderProxy;
   import com.riotgames.platform.gameclient.chat.ChatProviderProxy;
   import com.riotgames.platform.gameclient.chat.ChatRoomProviderProxy;
   import com.riotgames.platform.gameclient.chat.ChatRosterProviderProxy;
   import com.riotgames.platform.gameclient.chat.ChatStateProviderProxy;
   import com.riotgames.platform.gameclient.chat.IChatBlockedRosterProvider;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.IChatStateProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.invite.controller.InviteSystemManager;
   import com.riotgames.pvpnet.invite.controller.PlatformInviteController;
   import com.riotgames.pvpnet.invite.legacy.action.ShowInvitePlayersPopupAction;
   import com.riotgames.pvpnet.invite.legacy.controller.LegacyInviteController;
   import com.riotgames.pvpnet.invite.legacy.controller.LegacyRankedTeamInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionActionFactory;
   import com.riotgames.pvpnet.queuerestriction.QueueRestrictionCache;
   import com.riotgames.pvpnet.queuerestriction.controller.IQueueRestrictionController;
   import com.riotgames.pvpnet.queuerestriction.controller.QueueRestrictionController;
   import com.riotgames.pvpnet.summonerprofile.ISummonerProfileProvider;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.system.notification.ClientNotificationProviderProxy;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   import flash.display.Sprite;
   import mx.resources.ResourceManager;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleInvite extends Sprite implements IProviderModule, IInviteProvider
   {
      
      private var _masterGameController:MasterGameController;
      
      private var _masterGameViewController:MasterGameViewController;
      
      private var _dialogQueueProvider:IDialogQueueProvider;
      
      private var _soundProvider:ISoundProvider;
      
      private var _leagueDataProvider:ILeagueDataProvider;
      
      private var _clientNotificationsProvider:IClientNotificationProvider;
      
      private var _inviteGroup:InviteGroup;
      
      private var _platformInviteActionFactory:PlatformInviteActionFactory;
      
      private var _summonerProfileProvider:ISummonerProfileProvider;
      
      private var _queueRestrictionCache:QueueRestrictionCache;
      
      private var _session:Session;
      
      private var _loadAction:SequenceAction;
      
      private var _chatProvider:IChatProvider = ChatProviderProxy.instance;
      
      private var _inviteManager:InviteSystemManager;
      
      private var _dockedNotificationsProvider:INotificationsProvider;
      
      private var _presenceProvider:IPresenceProvider;
      
      private var _platformInviteController:PlatformInviteController;
      
      private var _queueRestrictionController:QueueRestrictionController;
      
      private var _appController:IAppController;
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _serviceProxy:ServiceProxy;
      
      private var _chatStateProvider:IChatStateProvider = ChatStateProviderProxy.instance;
      
      private var _chatBlockedRosterProvider:IChatBlockedRosterProvider = ChatBlockedRosterProviderProxy.instance;
      
      private var _chatRosterProvider:IChatRosterProvider = ChatRosterProviderProxy.instance;
      
      private var _shellDispatcher:ShellDispatcher;
      
      private var _queueRestrictionActionFactory:QueueRestrictionActionFactory;
      
      private var _chatRoomProvider:IChatRoomProvider = ChatRoomProviderProxy.instance;
      
      private var _inviteRankedTeamController:LegacyRankedTeamInviteController;
      
      private var _gameQueueManager:GameQueueManager;
      
      private var _clientConfig:ClientConfig;
      
      private var _lobbyViewController:ILobbyViewController;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _inviteController:IInviteController;
      
      private var _loadChatProvidersAction:SequenceAction;
      
      public function ClientModuleInvite()
      {
         super();
      }
      
      public function getInviteController() : IInviteController
      {
         return this._inviteController;
      }
      
      private function setChatLoginInfo(param1:UnescapedJID, param2:String, param3:int) : void
      {
         this._inviteGroup.myJID = param1;
         this._inviteGroup.myUserName = param2;
         this._inviteGroup.myUserIconId = param3;
      }
      
      private function getChatRosterProvider() : void
      {
         ProviderLookup.getProvider(IChatRosterProvider,this.onChatRosterProvider);
      }
      
      private function onPresenceProvider(param1:IPresenceProvider) : void
      {
         this._presenceProvider = param1;
         this._loadAction.completeFunction(this.getPresenceProvider);
      }
      
      private function onChatBlockedRosterProvider(param1:IChatBlockedRosterProvider) : void
      {
         this._chatBlockedRosterProvider = param1;
         this._loadChatProvidersAction.completeFunction(this.getChatBlockedRosterProvider);
      }
      
      private function onChatStateProvider(param1:IChatStateProvider) : void
      {
         this._chatStateProvider = param1;
         this._loadChatProvidersAction.completeFunction(this.getChatStateProvider);
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         this.loadProviders();
      }
      
      private function getLeagueProvider() : void
      {
         ProviderLookup.getProvider(ILeagueDataProvider,this.onLeagueDataProvider);
      }
      
      private function createChatControllers() : void
      {
         if(!this._loadAction.getHasCompleted() || !this._loadChatProvidersAction.getHasCompleted())
         {
            return;
         }
         if(this._inviteRankedTeamController)
         {
            this._inviteRankedTeamController.setChatProvider(this._chatProvider);
         }
         if(this._platformInviteActionFactory)
         {
            this._platformInviteActionFactory.setChatRoomProvider(this._chatRoomProvider);
         }
         this.setChatLoginInfo(this._chatProvider.currentUserJID,this._chatProvider.currentUserDisplayName,this._chatProvider.currentUserIconID);
         if(this._inviteManager)
         {
            this._inviteManager.setChatStateProvider(this._chatStateProvider);
         }
      }
      
      private function onChatRosterProvider(param1:IChatRosterProvider) : void
      {
         this._chatRosterProvider = param1;
         this._loadChatProvidersAction.completeFunction(this.getChatRosterProvider);
      }
      
      private function loadProviders() : void
      {
         this._serviceProxy = ServiceProxy.instance;
         this._clientNotificationsProvider = ClientNotificationProviderProxy.instance;
         this._dialogQueueProvider = DialogQueueProviderProxy.instance;
         this._session = Session.instance;
         this._session.getSummonerChanged().add(this.onSummonerChanged);
         this._soundProvider = SoundProviderProxy.instance;
         this._clientConfig = ClientConfig.instance;
         this._shellDispatcher = ShellDispatcher.instance;
         this._loadChatProvidersAction = new SequenceAction();
         this._loadChatProvidersAction.andCall(this.getChatRosterProvider);
         this._loadChatProvidersAction.andCall(this.getChatBlockedRosterProvider);
         this._loadChatProvidersAction.andCall(this.getChatProvider);
         this._loadChatProvidersAction.andCall(this.getChatRoomProvider);
         this._loadChatProvidersAction.andCall(this.getChatStateProvider);
         this._loadChatProvidersAction.getCompleted().add(this.onChatProvidersReady);
         this._loadChatProvidersAction.invoke();
         this._loadAction = new SequenceAction();
         this._loadAction.andCall(this.getDockedNotificationsProvider);
         this._loadAction.andCall(this.getSummonerProfileProvider);
         this._loadAction.andCall(this.getLeagueProvider);
         this._loadAction.andCall(this.getPresenceProvider);
         this._loadAction.andCall(this.getMasterGameController);
         this._loadAction.getCompleted().add(this.onProvidersReady);
         this._loadAction.invoke();
      }
      
      private function getSummonerProfileProvider() : void
      {
         ProviderLookup.getProvider(ISummonerProfileProvider,this.onSummonerProfileProvider);
      }
      
      private function onChatRoomProvider(param1:IChatRoomProvider) : void
      {
         this._chatRoomProvider = param1;
         this._loadChatProvidersAction.completeFunction(this.getChatRoomProvider);
      }
      
      private function getChatStateProvider() : void
      {
         ProviderLookup.getProvider(IChatStateProvider,this.onChatStateProvider);
      }
      
      public function getRankedInviteController() : IInviteRankedTeamController
      {
         return this._inviteRankedTeamController;
      }
      
      private function getChatBlockedRosterProvider() : void
      {
         ProviderLookup.getProvider(IChatBlockedRosterProvider,this.onChatBlockedRosterProvider);
      }
      
      private function createPlatformControllers() : void
      {
         this._platformInviteActionFactory = new PlatformInviteActionFactory(this._dockedNotificationsProvider,this._serviceProxy.gameInviteService,this._serviceProxy.gameService,ResourceManager.getInstance(),this._appController,this._masterGameController,this._lobbyViewController,this._dialogQueueProvider,AlerterProviderProxy.instance,this._presenceProvider,this._soundProvider,this._inviteQueueManager,GameTypeConfigManager.instance);
         this._platformInviteController = new PlatformInviteController(this._inviteController,this._inviteGroup,this._serviceProxy.messageRouterService,this._inviteQueueManager,this._platformInviteActionFactory,this._chatBlockedRosterProvider);
         this._platformInviteController.connectToLCDS();
      }
      
      private function getPresenceProvider() : void
      {
         ProviderLookup.getProvider(IPresenceProvider,this.onPresenceProvider);
      }
      
      private function getMasterGameController() : void
      {
         ProviderLookup.getProvider(IMasterGameController,this.onMasterGameController);
      }
      
      private function onSummonerProfileProvider(param1:ISummonerProfileProvider) : void
      {
         this._summonerProfileProvider = param1;
         this._loadAction.completeFunction(this.getSummonerProfileProvider);
      }
      
      private function onMasterGameController(param1:IMasterGameController) : void
      {
         this._masterGameController = param1 as MasterGameController;
         this._appController = this._masterGameController.applicationController;
         this._masterGameViewController = this._masterGameController.masterGameViewController;
         this._gameQueueManager = this._masterGameController.masterGameViewController.gameQueueManager;
         this._lobbyViewController = this._masterGameController.lobbyController;
         this._loadAction.completeFunction(this.getMasterGameController);
      }
      
      private function onDockedNotificationsProvider(param1:INotificationsProvider) : void
      {
         this._dockedNotificationsProvider = param1;
         this._loadAction.completeFunction(this.getDockedNotificationsProvider);
      }
      
      private function onSummonerChanged() : void
      {
         if(Boolean(this._session.summoner) && Boolean(this._inviteGroup))
         {
            this._inviteGroup.mySummonerId = this._session.summoner.sumId;
         }
      }
      
      public function getOpenInvitePanelAction() : IAction
      {
         return new ShowInvitePlayersPopupAction(this._serviceProxy.summonerService,this._chatRoomProvider,this._chatRosterProvider,this._inviteGroup,this._inviteController,this._gameQueueManager,null,this._inviteRankedTeamController,this._queueRestrictionActionFactory,this._queueRestrictionCache);
      }
      
      public function getInviteGroup() : InviteGroup
      {
         return this._inviteGroup;
      }
      
      private function onLeagueDataProvider(param1:ILeagueDataProvider) : void
      {
         this._leagueDataProvider = param1;
         this._loadAction.completeFunction(this.getLeagueProvider);
      }
      
      private function getDockedNotificationsProvider() : void
      {
         ProviderLookup.getProvider(INotificationsProvider,this.onDockedNotificationsProvider);
      }
      
      private function getChatRoomProvider() : void
      {
         ProviderLookup.getProvider(IChatRoomProvider,this.onChatRoomProvider);
      }
      
      private function getChatProvider() : void
      {
         ProviderLookup.getProvider(IChatProvider,this.onChatProvider);
      }
      
      private function onProvidersReady() : void
      {
         this._inviteGroup = new InviteGroup();
         this._inviteGroup.myJID = new UnescapedJID(Session.instance.accountSummary.username + "@" + ClientConfig.JABBER_DOMAIN);
         this._inviteGroup.myUserName = Session.instance.accountSummary.summonerName;
         this._inviteGroup.myUserIconId = Session.instance.summoner ? int(Session.instance.summoner.profileIconId) : 0;
         this._inviteGroup.setChatProvider(this._chatProvider);
         this.onSummonerChanged();
         this._inviteQueueManager = new InviteQueueManager(this._gameQueueManager,this._masterGameController,this._appController);
         this._queueRestrictionCache = new QueueRestrictionCache();
         this._queueRestrictionActionFactory = new QueueRestrictionActionFactory(this._queueRestrictionCache,this._serviceProxy.queueRestrictionService,this._inviteQueueManager,this._chatRosterProvider);
         this._inviteController = new LegacyInviteController(this._inviteQueueManager,this._dockedNotificationsProvider,this._inviteGroup,this._chatRosterProvider,this._serviceProxy.summonerService,this._queueRestrictionActionFactory);
         this._inviteRankedTeamController = new LegacyRankedTeamInviteController(this._serviceProxy,this._session,this._clientConfig,this._shellDispatcher,this._soundProvider,this._gameQueueManager,this._masterGameViewController,this._lobbyViewController,this._summonerProfileProvider,this._inviteGroup,this._chatProvider);
         this._inviteRankedTeamController.connect();
         this.createPlatformControllers();
         this.createChatControllers();
         this._inviteManager = new InviteSystemManager(this._inviteController,this._chatStateProvider,this._platformInviteController,this._inviteGroup);
         this._inviteManager.enable();
         this.createQueueRestrictionControllers();
         ProviderLookup.publishProvider(IInviteProvider,this);
      }
      
      private function createQueueRestrictionControllers() : void
      {
         this._queueRestrictionCache = new QueueRestrictionCache();
         this._queueRestrictionActionFactory = new QueueRestrictionActionFactory(this._queueRestrictionCache,this._serviceProxy.queueRestrictionService,this._inviteQueueManager,this._chatRosterProvider);
         this._queueRestrictionController = new QueueRestrictionController(this._platformInviteController,this._inviteQueueManager,this._inviteGroup,this._chatRosterProvider,this._queueRestrictionCache,this._queueRestrictionActionFactory);
         this._queueRestrictionController.connectListeners();
      }
      
      private function onChatProvidersReady() : void
      {
         this.createChatControllers();
      }
      
      private function onChatProvider(param1:IChatProvider) : void
      {
         this._chatProvider = param1;
         this._loadChatProvidersAction.completeFunction(this.getChatProvider);
      }
      
      public function getQueueRestrictionController() : IQueueRestrictionController
      {
         return this._queueRestrictionController;
      }
   }
}

