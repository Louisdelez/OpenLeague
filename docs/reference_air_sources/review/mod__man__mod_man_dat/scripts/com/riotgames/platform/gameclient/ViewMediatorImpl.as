package com.riotgames.platform.gameclient
{
   import blix.action.IAction;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.event.RemoteServiceErrorEvent;
   import com.riotgames.platform.common.event.ServerWaitEvent;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.exception.InvalidSessionException;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.controllers.summoner.PlayTutorialGameController;
   import com.riotgames.platform.gameclient.domain.SummonerTalentsAndPoints;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.domain.summoner.InitialSkillLevel;
   import com.riotgames.platform.gameclient.summoner.SummonerController;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.CursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.FaultEvent;
   
   public class ViewMediatorImpl extends EventDispatcher implements ViewMediator
   {
      
      public static const NEW_WINDOW:String = "NEW_WINDOW";
      
      public var playTutorialGameController:PlayTutorialGameController;
      
      public var summonerController:SummonerController;
      
      public var applicationController:IAppController;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var lobbyController:ILobbyViewController;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      public var masterGameController:MasterGameController;
      
      private var _shellDispatcher:ShellDispatcher;
      
      private var _chatController:ChatController;
      
      private var resourceManager:IResourceManager;
      
      public var logManager:LogManager = LogManager.instance;
      
      private var showServerWaitAction:AlertWaitAction;
      
      private var _onEnterLobbyAction:IAction;
      
      private var connectionFailurePanelShown:Boolean = false;
      
      public var clientConfig:ClientConfig;
      
      public function ViewMediatorImpl()
      {
         super();
         this.resourceManager = ResourceManager.getInstance();
         this.clientConfig = ClientConfig.instance;
         this.shellDispatcher = ShellDispatcher.instance;
      }
      
      public function handleAbortResetPassword() : void
      {
         this.setMainViewState(IAppControllerConstants.LOGIN);
      }
      
      private function onShowServerWait(param1:ServerWaitEvent) : void
      {
         var _loc2_:IResourceManager = null;
         if(this.showServerWaitAction == null)
         {
            _loc2_ = ResourceManager.getInstance();
            this.showServerWaitAction = new AlertWaitAction(_loc2_.getString("resources","serverWait_retrievingDataMessage"),_loc2_.getString("resources","serverWait_loadingMessage"));
         }
         this.showServerWaitAction.add();
      }
      
      private function onHideServerWait(param1:Event) : void
      {
         this.showServerWaitAction.complete();
      }
      
      public function showRenameSummoner() : void
      {
         this.setMainViewState(IAppControllerConstants.RENAME_SUMMONER);
      }
      
      private function handleExit() : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.EXIT));
      }
      
      public function showSummonerIconScreen() : void
      {
         this.setMainViewState(IAppControllerConstants.CHOOSE_SUMMONER_ICON);
      }
      
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      public function minimizeClient() : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.MINIMIZE_TO_TRAY));
         this.soundManager.applyForceMute(true);
      }
      
      public function handleActivateBetaKey() : void
      {
         this.showSummonerWizardOrMainLobbyView();
      }
      
      public function showMainLobby() : void
      {
         CursorManager.getInstance().removeAllCursors();
         this.applicationController.home();
      }
      
      public function set chatController(param1:ChatController) : void
      {
         this._chatController = param1;
      }
      
      public function showSummonerWizardOrMainLobbyView() : void
      {
         if(this.onEnterLobbyAction != null)
         {
            DialogQueueProviderProxy.instance.addDialog(this.onEnterLobbyAction);
         }
         if((Session.instance.summoner == null || Session.instance.summoner.name == null) && Boolean(this.clientConfig.enableSummonerWizard))
         {
            this.showCreateSummoner();
         }
         else if(Session.instance.summoner.nameChangeFlag)
         {
            this.showRenameSummoner();
         }
         else if(Session.instance.summoner.profileIconId == -1)
         {
            this.showSummonerIconScreen();
         }
         else if(Session.instance.summoner.displayEloQuestionaire)
         {
            this.showEloQuestionaireScreen();
         }
         else if(!Session.instance.summoner.tutorialFlag)
         {
            this.showPlayTutorialGame();
         }
         else
         {
            this.showMainLobby();
         }
      }
      
      public function handlePlayTutorialClose() : void
      {
         this.showMainLobby();
      }
      
      private function handleUnhandledRemoteError(param1:RemoteServiceErrorEvent) : void
      {
         CursorManager.getInstance().removeAllCursors();
         var _loc2_:String = param1.faultEvent.message != null ? param1.faultEvent.message.toString() : "";
         this.logger.error("handleUnhandledRemoteError: message: {0}",_loc2_);
         var _loc3_:FaultEvent = param1.faultEvent;
         var _loc4_:Object = _loc3_.fault != null ? _loc3_.fault.rootCause : null;
         if(_loc4_ is InvalidSessionException && Boolean(InvalidSessionException(_loc4_).errorCode))
         {
            this.applicationController.logoutSessionExpired();
         }
      }
      
      public function showPracticeGameView() : void
      {
         DialogQueueProviderProxy.instance.removeActiveDialogs();
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_PRACTICE_GAME_STATE);
      }
      
      public function handleCreateSummoner() : void
      {
         this.continueCreateSummonerFlow();
      }
      
      public function maximizeClient() : void
      {
         AppConfig.instance.minimized = false;
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.RESTORE));
         this.soundManager.applyForceMute(false);
      }
      
      public function showLoginView() : void
      {
         this.setMainViewState(IAppControllerConstants.LOGIN);
      }
      
      public function get onEnterLobbyAction() : IAction
      {
         return this._onEnterLobbyAction;
      }
      
      public function handleAbortBetaKeyActivation() : void
      {
         this.setMainViewState(IAppControllerConstants.LOGIN);
      }
      
      public function showCreateSummoner() : void
      {
         this.setMainViewState(IAppControllerConstants.CREATE_SUMMONER);
      }
      
      public function shutdownClient(param1:Event) : void
      {
         this.applicationController.shutdownConnections();
         if(!this.applicationController.hasLogoutCompleted && !param1.isDefaultPrevented())
         {
            if(Session.instance.isLoggedIn)
            {
               param1.preventDefault();
               this.applicationController.logout();
            }
         }
         this.soundManager.stopBackgroundMusic();
      }
      
      public function showTalentTreeView(param1:SummonerTalentsAndPoints) : void
      {
         throw new Error("FIXME");
      }
      
      private function partnerBetaBlockedCloseHandler() : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.EXIT));
      }
      
      public function handleClientConnectionError() : void
      {
         var _loc1_:IResourceManager = null;
         var _loc2_:AlertAction = null;
         CursorManager.getInstance().removeAllCursors();
         if(!this.connectionFailurePanelShown)
         {
            _loc1_ = ResourceManager.getInstance();
            _loc2_ = new AlertAction(_loc1_.getString("resources",MessageDictionary.CONNECTION_FAILED_TITLE),_loc1_.getString("resources",MessageDictionary.CONNECTION_TO_HOST_FAILED));
            _loc2_.getCompleted().addOnce(this.handleClientConnectionErrorDialog);
            _loc2_.add();
            this.connectionFailurePanelShown = true;
         }
      }
      
      public function handleLogoutWithoutExit() : void
      {
         this.setMainViewState(IAppControllerConstants.LOGIN);
      }
      
      public function continueCreateSummonerFlow(param1:String = null) : void
      {
         if(param1 == InitialSkillLevel.EXPERT || param1 == InitialSkillLevel.VETERAN)
         {
            this.masterGameController.createTutorialGameController.chooseTutorialType(false);
         }
         if(Session.instance.summoner.profileIconId == -1)
         {
            this.showSummonerIconScreen();
         }
         else if(Session.instance.summoner.displayEloQuestionaire)
         {
            this.showEloQuestionaireScreen();
         }
         else if(!Session.instance.summoner.tutorialFlag)
         {
            this.showPlayTutorialGame();
         }
         else
         {
            this.showMainLobby();
         }
      }
      
      public function showEloQuestionaireScreen() : void
      {
         this.setMainViewState(IAppControllerConstants.ELO_QUESTIONAIRE);
      }
      
      private function handleClientConnectionErrorDialog() : void
      {
         this.connectionFailurePanelShown = false;
         if(!Session.instance.isLoggedIn)
         {
            this.handleExit();
         }
      }
      
      public function set onEnterLobbyAction(param1:IAction) : void
      {
         this._onEnterLobbyAction = param1;
      }
      
      public function showPlayTutorialGame() : void
      {
         this.setMainViewState(IAppControllerConstants.PLAY_TUTORIAL);
      }
      
      public function set shellDispatcher(param1:ShellDispatcher) : void
      {
         this._shellDispatcher = param1;
         this._shellDispatcher.addEventListener(RemoteServiceErrorEvent.UNHANDLED_REMOTE_SERVICE_ERROR,this.handleUnhandledRemoteError);
         this._shellDispatcher.addEventListener(ServerWaitEvent.SHOW,this.onShowServerWait);
         this._shellDispatcher.addEventListener(ServerWaitEvent.HIDE,this.onHideServerWait);
      }
      
      private function setMainViewState(param1:String) : void
      {
         AppConfig.instance.currentAppState = param1;
      }
      
      public function handleRenameSummoner() : void
      {
         var _loc1_:AlertAction = new AlertAction(this.resourceManager.getString("resources","summoner_summonerRenamedStatusTitle"),this.resourceManager.getString("resources","summoner_summonerRenamedStatusMessage"));
         _loc1_.add();
         this.showMainLobby();
      }
      
      public function showPartnerBetaBlockedMessage() : void
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:AlertAction = new AlertAction(_loc1_.getString("resources","partnerBetaBlocked_title"),_loc1_.getString("resources","partnerBetaBlocked_message"));
         _loc2_.getCompleted().addOnce(this.partnerBetaBlockedCloseHandler);
         _loc2_.add();
      }
      
      public function get shellDispatcher() : ShellDispatcher
      {
         return this._shellDispatcher;
      }
      
      public function showExitAlert(param1:String, param2:String) : void
      {
         var _loc3_:IResourceManager = ResourceManager.getInstance();
         var _loc4_:AlertAction = new AlertAction(_loc3_.getString("resources",param2),_loc3_.getString("resources",param1));
         _loc4_.getCompleted().addOnce(this.handleExit);
         _loc4_.affirmativeLabel = _loc3_.getString("resources","common_button_close");
         _loc4_.isModal = true;
         _loc4_.add();
      }
   }
}

