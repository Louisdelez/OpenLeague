package
{
   import blix.action.IAction;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.ratings.ShowRatingsPopupAction;
   import com.riotgames.platform.common.xmpp.logging.XMPPSessionLogger;
   import com.riotgames.platform.gameclient.ApplicationController;
   import com.riotgames.platform.gameclient.ViewMediatorImpl;
   import com.riotgames.platform.gameclient.account.GameCfgData.Keybinding.KeyBindingController;
   import com.riotgames.platform.gameclient.account.GameCfgData.PlayerPreferencesSyncController;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.gameclient.chat.mediator.ChatViewMediatorImpl;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertController;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.help.NewbieTipsController;
   import com.riotgames.platform.gameclient.controllers.lobby.ChooseGameFlowViewController;
   import com.riotgames.platform.gameclient.controllers.lobby.LobbyController;
   import com.riotgames.platform.gameclient.controllers.loyalty.LoyaltyController;
   import com.riotgames.platform.gameclient.controllers.notification.LocalStatusController;
   import com.riotgames.platform.gameclient.controllers.social.RealNameController;
   import com.riotgames.platform.gameclient.controllers.store.StoreController;
   import com.riotgames.platform.gameclient.controllers.summoner.ChooseSummonerIconController;
   import com.riotgames.platform.gameclient.controllers.summoner.EloQuestionaireController;
   import com.riotgames.platform.gameclient.controllers.summoner.PlayTutorialGameController;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerNameController;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.accountState.AccountStateChangeNotificationListener;
   import com.riotgames.platform.gameclient.domain.accountState.IShowAccountTransferPopupAction;
   import com.riotgames.platform.gameclient.domain.accountState.ShowAccountTransferCompletedPopupAction;
   import com.riotgames.platform.gameclient.domain.accountState.ShowAccountTransferFailedPopupAction;
   import com.riotgames.platform.gameclient.domain.accountState.ShowAccountTransferStartedPopupAction;
   import com.riotgames.platform.gameclient.domain.accountState.ShowAccountTransferUnknownPopupAction;
   import com.riotgames.platform.gameclient.domain.game.PracticeGameManager;
   import com.riotgames.platform.gameclient.leaverbuster.LeaverBusterController;
   import com.riotgames.platform.gameclient.popup.ShowAFKFilterChampionSelectionPopupAction;
   import com.riotgames.platform.gameclient.popup.ShowLeaverBusterAlertAction;
   import com.riotgames.platform.gameclient.popup.ShowLegacyChampionSelectionPopupAction;
   import com.riotgames.platform.gameclient.popup.ShowQueueDodgePopupAction;
   import com.riotgames.platform.gameclient.popup.ShowRankedQueueFailurePopupAction;
   import com.riotgames.platform.gameclient.popup.ShowReportPlayerPopupAction;
   import com.riotgames.platform.gameclient.rss.RSSAlertController;
   import com.riotgames.platform.gameclient.summoner.SummonerController;
   import com.riotgames.platform.gameclient.summoner.SummonerSearchController;
   import com.riotgames.platform.gameclient.tooltips.SummonerTooltipManager;
   import com.riotgames.platform.gameclient.views.PreloadMediator;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameScoreboardProvider;
   import com.riotgames.platform.gameclient.views.models.ProfileDisplayModel;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileLifetimeStatsPresentationModel;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsSummaryPresentationModel;
   import com.riotgames.platform.gameclient.views.summoner.wizard.LegacyAccountCreationProvider;
   import com.riotgames.pvpnet.game.alerts.IAFKFilterChampionSelectionAlertAction;
   import com.riotgames.pvpnet.game.alerts.ILeaverBusterAlertAction;
   import com.riotgames.pvpnet.game.alerts.ILegacyChampionSelectionAlertAction;
   import com.riotgames.pvpnet.game.alerts.IQueueDodgeAlertAction;
   import com.riotgames.pvpnet.game.alerts.IRankedQueueFailureAlertAction;
   import com.riotgames.pvpnet.game.alerts.IReportPlayerAlertAction;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.controllers.InGameController;
   import com.riotgames.pvpnet.game.controllers.LCDSHeartBeatController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.SpectatorController;
   import com.riotgames.pvpnet.game.controllers.TeamSelectionController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.practice.CreatePracticeGameController;
   import com.riotgames.pvpnet.game.controllers.practice.JoinGameController;
   import com.riotgames.pvpnet.game.controllers.tutorial.CreateTutorialGameController;
   import com.riotgames.pvpnet.game.domain.EnterChampionSelectManager;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   import org.swizframework.core.BeanLoader;
   
   use namespace mx_internal;
   
   public class LolClientBeans extends BeanLoader implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _825517952playTutorialGameController:PlayTutorialGameController;
      
      private var _1139512301accountStateChangeNotificationListener:AccountStateChangeNotificationListener;
      
      private var _130501837showAccountTransferUnknownPopupAction:ShowAccountTransferUnknownPopupAction;
      
      private var _1074839630lcdsHeartBeatController:LCDSHeartBeatController;
      
      private var _2108568786summonerSearchController:SummonerSearchController;
      
      private var _2108295968practiceGameManager:PracticeGameManager;
      
      private var _1164646953endOfGameStatsController:EndOfGameStatsController;
      
      private var _491262004legacyAccountCreationProvider:LegacyAccountCreationProvider;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _816736922rssAlertController:RSSAlertController;
      
      private var _1137159790gameQueueManager:GameQueueManager;
      
      private var _891297527presenceController:PresenceController;
      
      private var _566834807summonerProfileController:SummonerProfileController;
      
      private var _61479806loyaltyController:LoyaltyController;
      
      private var _1576335205createPracticeGameController:CreatePracticeGameController;
      
      private var _1685149624createTutorialGameController:CreateTutorialGameController;
      
      private var _1239547184enterChampionSelectManager:EnterChampionSelectManager;
      
      private var _2037600984leaverBusterController:LeaverBusterController;
      
      private var _77251536profileDisplayModel:ProfileDisplayModel;
      
      private var _159335554profileLifetimeStatsPresentationModel:ProfileLifetimeStatsPresentationModel;
      
      private var _385461411storeController:StoreController;
      
      private var _357060636preloadMediator:PreloadMediator;
      
      private var _1292102721profileStatsSummaryPresentationModel:ProfileStatsSummaryPresentationModel;
      
      private var _317735280arrowedAlertController:ArrowedAlertController;
      
      private var _1406224812glowComponentController:GlowComponentController;
      
      private var _2113026512showReportPlayerPopupAction:ShowReportPlayerPopupAction;
      
      private var _1575296219showLegacyChampionSelectionPopupAction:ShowLegacyChampionSelectionPopupAction;
      
      private var _672657526summonerController:SummonerController;
      
      private var _2092253646playerPreferencesSyncController:PlayerPreferencesSyncController;
      
      private var _2070536460applicationController:ApplicationController;
      
      private var _269543472masterGameController:MasterGameController;
      
      private var _1315726466privacyListController:PrivacyListController;
      
      private var _1883749947realNameController:RealNameController;
      
      private var _349030418lobbyController:LobbyController;
      
      private var _1075359937showRankedQueueFailurePopupAction:ShowRankedQueueFailurePopupAction;
      
      private var _962434184chooseGameFlowViewController:ChooseGameFlowViewController;
      
      private var _1048750206keybindingController:KeyBindingController;
      
      private var _1408434614showAccountTransferFailedPopupAction:ShowAccountTransferFailedPopupAction;
      
      private var _1197293384viewMediator:ViewMediatorImpl;
      
      private var _1621263383endOfGameScoreboardProvider:EndOfGameScoreboardProvider;
      
      private var _192111834chooseSummonerIconController:ChooseSummonerIconController;
      
      private var _620829944joinGameController:JoinGameController;
      
      private var _2131669637eloQuestionaireController:EloQuestionaireController;
      
      private var _1295553550newbieTipsController:NewbieTipsController;
      
      private var _1365522105localStatusController:LocalStatusController;
      
      private var _1380429858chatProperSessionLogger:XMPPSessionLogger;
      
      mx_internal var _watchers:Array;
      
      private var _1106847388showAccountTransferStartedPopupAction:ShowAccountTransferStartedPopupAction;
      
      private var _872287488showAFKFilterChampionSelectionPopupAction:ShowAFKFilterChampionSelectionPopupAction;
      
      private var _185498505showRatingsPopupAction:ShowRatingsPopupAction;
      
      private var _680281042showAccountTransferCompletedPopupAction:ShowAccountTransferCompletedPopupAction;
      
      private var _172540104summonerToolTipManager:SummonerTooltipManager;
      
      private var _957204045inGameController:InGameController;
      
      private var _307054059spectatorController:SpectatorController;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _843995307teamSelectionController:TeamSelectionController;
      
      private var _1659834913showQueueDodgePopupAction:ShowQueueDodgePopupAction;
      
      private var _660759600chatViewMediator:ChatViewMediatorImpl;
      
      private var _1019249940chatController:ChatController;
      
      private var _1559360015createSummonerWizardController:SummonerNameController;
      
      private var _1915053881showLeaverBusterAlertAction:ShowLeaverBusterAlertAction;
      
      private var _1450947915masterGameViewController:MasterGameViewController;
      
      mx_internal var _bindings:Array;
      
      public function LolClientBeans()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:LolClientBeans = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         this._LolClientBeans_AccountStateChangeNotificationListener1_i();
         this._LolClientBeans_ApplicationController1_i();
         this._LolClientBeans_ArrowedAlertController1_i();
         this._LolClientBeans_ChatController1_i();
         this._LolClientBeans_XMPPSessionLogger1_i();
         this._LolClientBeans_ChatViewMediatorImpl1_i();
         this._LolClientBeans_ChooseGameFlowViewController1_i();
         this._LolClientBeans_ChooseSummonerIconController1_i();
         this._LolClientBeans_CreatePracticeGameController1_i();
         this._LolClientBeans_SummonerNameController1_i();
         this._LolClientBeans_CreateTutorialGameController1_i();
         this._LolClientBeans_EloQuestionaireController1_i();
         this._LolClientBeans_EndOfGameScoreboardProvider1_i();
         this._LolClientBeans_EndOfGameStatsController1_i();
         this._LolClientBeans_EnterChampionSelectManager1_i();
         this._LolClientBeans_GameQueueManager1_i();
         this._LolClientBeans_GlowComponentController1_i();
         this._LolClientBeans_InGameController1_i();
         this._LolClientBeans_JoinGameController1_i();
         this._LolClientBeans_KeyBindingController1_i();
         this._LolClientBeans_LCDSHeartBeatController1_i();
         this._LolClientBeans_LeaverBusterController1_i();
         this._LolClientBeans_LegacyAccountCreationProvider1_i();
         this._LolClientBeans_LobbyController1_i();
         this._LolClientBeans_LocalStatusController1_i();
         this._LolClientBeans_LoyaltyController1_i();
         this._LolClientBeans_MasterGameController1_i();
         this._LolClientBeans_MasterGameViewController1_i();
         this._LolClientBeans_NewbieTipsController1_i();
         this._LolClientBeans_PlayTutorialGameController1_i();
         this._LolClientBeans_PlayerPreferencesSyncController1_i();
         this._LolClientBeans_PracticeGameManager1_i();
         this._LolClientBeans_PreloadMediator1_i();
         this._LolClientBeans_PresenceController1_i();
         this._LolClientBeans_PrivacyListController1_i();
         this._LolClientBeans_ProfileDisplayModel1_i();
         this._LolClientBeans_ProfileLifetimeStatsPresentationModel1_i();
         this._LolClientBeans_ProfileStatsSummaryPresentationModel1_i();
         this._LolClientBeans_RealNameController1_i();
         this._LolClientBeans_RSSAlertController1_i();
         this._LolClientBeans_ShowAFKFilterChampionSelectionPopupAction1_i();
         this._LolClientBeans_ShowAccountTransferCompletedPopupAction1_i();
         this._LolClientBeans_ShowAccountTransferFailedPopupAction1_i();
         this._LolClientBeans_ShowAccountTransferStartedPopupAction1_i();
         this._LolClientBeans_ShowAccountTransferUnknownPopupAction1_i();
         this._LolClientBeans_ShowLeaverBusterAlertAction1_i();
         this._LolClientBeans_ShowLegacyChampionSelectionPopupAction1_i();
         this._LolClientBeans_ShowQueueDodgePopupAction1_i();
         this._LolClientBeans_ShowRankedQueueFailurePopupAction1_i();
         this._LolClientBeans_ShowRatingsPopupAction1_i();
         this._LolClientBeans_ShowReportPlayerPopupAction1_i();
         this._LolClientBeans_SpectatorController1_i();
         this._LolClientBeans_StoreController1_i();
         this._LolClientBeans_SummonerController1_i();
         this._LolClientBeans_SummonerProfileController1_i();
         this._LolClientBeans_SummonerSearchController1_i();
         this._LolClientBeans_SummonerTooltipManager1_i();
         this._LolClientBeans_TeamSelectionController1_i();
         this._LolClientBeans_ViewMediatorImpl1_i();
         bindings = this._LolClientBeans_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_LolClientBeansWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         LolClientBeans._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get showQueueDodgePopupAction() : ShowQueueDodgePopupAction
      {
         return this._1659834913showQueueDodgePopupAction;
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorController() : SpectatorController
      {
         return this._307054059spectatorController;
      }
      
      private function _LolClientBeans_RSSAlertController1_i() : RSSAlertController
      {
         var _loc1_:RSSAlertController = new RSSAlertController();
         this.rssAlertController = _loc1_;
         BindingManager.executeBindings(this,"rssAlertController",this.rssAlertController);
         return _loc1_;
      }
      
      public function set showAFKFilterChampionSelectionPopupAction(param1:ShowAFKFilterChampionSelectionPopupAction) : void
      {
         var _loc2_:Object = this._872287488showAFKFilterChampionSelectionPopupAction;
         if(_loc2_ !== param1)
         {
            this._872287488showAFKFilterChampionSelectionPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showAFKFilterChampionSelectionPopupAction",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_ShowAccountTransferStartedPopupAction1_i() : ShowAccountTransferStartedPopupAction
      {
         var _loc1_:ShowAccountTransferStartedPopupAction = new ShowAccountTransferStartedPopupAction();
         this.showAccountTransferStartedPopupAction = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get lobbyController() : LobbyController
      {
         return this._349030418lobbyController;
      }
      
      [Bindable(event="propertyChange")]
      public function get accountStateChangeNotificationListener() : AccountStateChangeNotificationListener
      {
         return this._1139512301accountStateChangeNotificationListener;
      }
      
      private function _LolClientBeans_SummonerNameController1_i() : SummonerNameController
      {
         var _loc1_:SummonerNameController = new SummonerNameController();
         this.createSummonerWizardController = _loc1_;
         BindingManager.executeBindings(this,"createSummonerWizardController",this.createSummonerWizardController);
         return _loc1_;
      }
      
      public function set applicationController(param1:ApplicationController) : void
      {
         var _loc2_:Object = this._2070536460applicationController;
         if(_loc2_ !== param1)
         {
            this._2070536460applicationController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applicationController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_ShowAccountTransferUnknownPopupAction1_i() : ShowAccountTransferUnknownPopupAction
      {
         var _loc1_:ShowAccountTransferUnknownPopupAction = new ShowAccountTransferUnknownPopupAction();
         this.showAccountTransferUnknownPopupAction = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get preloadMediator() : PreloadMediator
      {
         return this._357060636preloadMediator;
      }
      
      public function set lobbyController(param1:LobbyController) : void
      {
         var _loc2_:Object = this._349030418lobbyController;
         if(_loc2_ !== param1)
         {
            this._349030418lobbyController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyController",_loc2_,param1));
         }
      }
      
      public function set accountStateChangeNotificationListener(param1:AccountStateChangeNotificationListener) : void
      {
         var _loc2_:Object = this._1139512301accountStateChangeNotificationListener;
         if(_loc2_ !== param1)
         {
            this._1139512301accountStateChangeNotificationListener = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountStateChangeNotificationListener",_loc2_,param1));
         }
      }
      
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this._1019249940chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatViewMediator() : ChatViewMediatorImpl
      {
         return this._660759600chatViewMediator;
      }
      
      [Bindable(event="propertyChange")]
      public function get legacyAccountCreationProvider() : LegacyAccountCreationProvider
      {
         return this._491262004legacyAccountCreationProvider;
      }
      
      [Bindable(event="propertyChange")]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      private function _LolClientBeans_NewbieTipsController1_i() : NewbieTipsController
      {
         var _loc1_:NewbieTipsController = new NewbieTipsController();
         this.newbieTipsController = _loc1_;
         return _loc1_;
      }
      
      public function set preloadMediator(param1:PreloadMediator) : void
      {
         var _loc2_:Object = this._357060636preloadMediator;
         if(_loc2_ !== param1)
         {
            this._357060636preloadMediator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"preloadMediator",_loc2_,param1));
         }
      }
      
      public function set practiceGameManager(param1:PracticeGameManager) : void
      {
         var _loc2_:Object = this._2108295968practiceGameManager;
         if(_loc2_ !== param1)
         {
            this._2108295968practiceGameManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"practiceGameManager",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get createTutorialGameController() : CreateTutorialGameController
      {
         return this._1685149624createTutorialGameController;
      }
      
      private function _LolClientBeans_ShowRankedQueueFailurePopupAction1_i() : ShowRankedQueueFailurePopupAction
      {
         var _loc1_:ShowRankedQueueFailurePopupAction = new ShowRankedQueueFailurePopupAction();
         this.showRankedQueueFailurePopupAction = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get showAccountTransferFailedPopupAction() : ShowAccountTransferFailedPopupAction
      {
         return this._1408434614showAccountTransferFailedPopupAction;
      }
      
      private function _LolClientBeans_InGameController1_i() : InGameController
      {
         var _loc1_:InGameController = new InGameController();
         this.inGameController = _loc1_;
         BindingManager.executeBindings(this,"inGameController",this.inGameController);
         return _loc1_;
      }
      
      public function set showLegacyChampionSelectionPopupAction(param1:ShowLegacyChampionSelectionPopupAction) : void
      {
         var _loc2_:Object = this._1575296219showLegacyChampionSelectionPopupAction;
         if(_loc2_ !== param1)
         {
            this._1575296219showLegacyChampionSelectionPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showLegacyChampionSelectionPopupAction",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_PlayerPreferencesSyncController1_i() : PlayerPreferencesSyncController
      {
         var _loc1_:PlayerPreferencesSyncController = new PlayerPreferencesSyncController();
         this.playerPreferencesSyncController = _loc1_;
         BindingManager.executeBindings(this,"playerPreferencesSyncController",this.playerPreferencesSyncController);
         return _loc1_;
      }
      
      public function set chatViewMediator(param1:ChatViewMediatorImpl) : void
      {
         var _loc2_:Object = this._660759600chatViewMediator;
         if(_loc2_ !== param1)
         {
            this._660759600chatViewMediator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatViewMediator",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_ShowLegacyChampionSelectionPopupAction1_i() : ShowLegacyChampionSelectionPopupAction
      {
         var _loc1_:ShowLegacyChampionSelectionPopupAction = new ShowLegacyChampionSelectionPopupAction();
         this.showLegacyChampionSelectionPopupAction = _loc1_;
         return _loc1_;
      }
      
      public function set enterChampionSelectManager(param1:EnterChampionSelectManager) : void
      {
         var _loc2_:Object = this._1239547184enterChampionSelectManager;
         if(_loc2_ !== param1)
         {
            this._1239547184enterChampionSelectManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enterChampionSelectManager",_loc2_,param1));
         }
      }
      
      public function set legacyAccountCreationProvider(param1:LegacyAccountCreationProvider) : void
      {
         var _loc2_:Object = this._491262004legacyAccountCreationProvider;
         if(_loc2_ !== param1)
         {
            this._491262004legacyAccountCreationProvider = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"legacyAccountCreationProvider",_loc2_,param1));
         }
      }
      
      public function set showAccountTransferUnknownPopupAction(param1:ShowAccountTransferUnknownPopupAction) : void
      {
         var _loc2_:Object = this._130501837showAccountTransferUnknownPopupAction;
         if(_loc2_ !== param1)
         {
            this._130501837showAccountTransferUnknownPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showAccountTransferUnknownPopupAction",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameQueueManager() : GameQueueManager
      {
         return this._1137159790gameQueueManager;
      }
      
      private function _LolClientBeans_StoreController1_i() : StoreController
      {
         var _loc1_:StoreController = new StoreController();
         this.storeController = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_PrivacyListController1_i() : PrivacyListController
      {
         var _loc1_:PrivacyListController = new PrivacyListController();
         this.privacyListController = _loc1_;
         BindingManager.executeBindings(this,"privacyListController",this.privacyListController);
         return _loc1_;
      }
      
      private function _LolClientBeans_LegacyAccountCreationProvider1_i() : LegacyAccountCreationProvider
      {
         var _loc1_:LegacyAccountCreationProvider = new LegacyAccountCreationProvider();
         this.legacyAccountCreationProvider = _loc1_;
         BindingManager.executeBindings(this,"legacyAccountCreationProvider",this.legacyAccountCreationProvider);
         return _loc1_;
      }
      
      private function _LolClientBeans_ProfileLifetimeStatsPresentationModel1_i() : ProfileLifetimeStatsPresentationModel
      {
         var _loc1_:ProfileLifetimeStatsPresentationModel = new ProfileLifetimeStatsPresentationModel();
         this.profileLifetimeStatsPresentationModel = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._566834807summonerProfileController;
      }
      
      public function set summonerToolTipManager(param1:SummonerTooltipManager) : void
      {
         var _loc2_:Object = this._172540104summonerToolTipManager;
         if(_loc2_ !== param1)
         {
            this._172540104summonerToolTipManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerToolTipManager",_loc2_,param1));
         }
      }
      
      public function set showLeaverBusterAlertAction(param1:ShowLeaverBusterAlertAction) : void
      {
         var _loc2_:Object = this._1915053881showLeaverBusterAlertAction;
         if(_loc2_ !== param1)
         {
            this._1915053881showLeaverBusterAlertAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showLeaverBusterAlertAction",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get eloQuestionaireController() : EloQuestionaireController
      {
         return this._2131669637eloQuestionaireController;
      }
      
      [Bindable(event="propertyChange")]
      public function get playTutorialGameController() : PlayTutorialGameController
      {
         return this._825517952playTutorialGameController;
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         var _loc2_:Object = this._269543472masterGameController;
         if(_loc2_ !== param1)
         {
            this._269543472masterGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arrowedAlertController() : ArrowedAlertController
      {
         return this._317735280arrowedAlertController;
      }
      
      [Bindable(event="propertyChange")]
      public function get loyaltyController() : LoyaltyController
      {
         return this._61479806loyaltyController;
      }
      
      public function set createTutorialGameController(param1:CreateTutorialGameController) : void
      {
         var _loc2_:Object = this._1685149624createTutorialGameController;
         if(_loc2_ !== param1)
         {
            this._1685149624createTutorialGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createTutorialGameController",_loc2_,param1));
         }
      }
      
      public function set showAccountTransferFailedPopupAction(param1:ShowAccountTransferFailedPopupAction) : void
      {
         var _loc2_:Object = this._1408434614showAccountTransferFailedPopupAction;
         if(_loc2_ !== param1)
         {
            this._1408434614showAccountTransferFailedPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showAccountTransferFailedPopupAction",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_ProfileDisplayModel1_i() : ProfileDisplayModel
      {
         var _loc1_:ProfileDisplayModel = new ProfileDisplayModel();
         this.profileDisplayModel = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_SpectatorController1_i() : SpectatorController
      {
         var _loc1_:SpectatorController = new SpectatorController();
         this.spectatorController = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get showAccountTransferStartedPopupAction() : ShowAccountTransferStartedPopupAction
      {
         return this._1106847388showAccountTransferStartedPopupAction;
      }
      
      [Bindable(event="propertyChange")]
      public function get privacyListController() : PrivacyListController
      {
         return this._1315726466privacyListController;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamSelectionController() : TeamSelectionController
      {
         return this._843995307teamSelectionController;
      }
      
      private function _LolClientBeans_ShowAFKFilterChampionSelectionPopupAction1_i() : ShowAFKFilterChampionSelectionPopupAction
      {
         var _loc1_:ShowAFKFilterChampionSelectionPopupAction = new ShowAFKFilterChampionSelectionPopupAction();
         this.showAFKFilterChampionSelectionPopupAction = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get profileLifetimeStatsPresentationModel() : ProfileLifetimeStatsPresentationModel
      {
         return this._159335554profileLifetimeStatsPresentationModel;
      }
      
      private function _LolClientBeans_EndOfGameStatsController1_i() : EndOfGameStatsController
      {
         var _loc1_:EndOfGameStatsController = new EndOfGameStatsController();
         this.endOfGameStatsController = _loc1_;
         BindingManager.executeBindings(this,"endOfGameStatsController",this.endOfGameStatsController);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get masterGameViewController() : MasterGameViewController
      {
         return this._1450947915masterGameViewController;
      }
      
      [Bindable(event="propertyChange")]
      public function get viewMediator() : ViewMediatorImpl
      {
         return this._1197293384viewMediator;
      }
      
      [Bindable(event="propertyChange")]
      public function get localStatusController() : LocalStatusController
      {
         return this._1365522105localStatusController;
      }
      
      public function set storeController(param1:StoreController) : void
      {
         var _loc2_:Object = this._385461411storeController;
         if(_loc2_ !== param1)
         {
            this._385461411storeController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"storeController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_AccountStateChangeNotificationListener1_i() : AccountStateChangeNotificationListener
      {
         var _loc1_:AccountStateChangeNotificationListener = new AccountStateChangeNotificationListener();
         this.accountStateChangeNotificationListener = _loc1_;
         BindingManager.executeBindings(this,"accountStateChangeNotificationListener",this.accountStateChangeNotificationListener);
         return _loc1_;
      }
      
      private function _LolClientBeans_GlowComponentController1_i() : GlowComponentController
      {
         var _loc1_:GlowComponentController = new GlowComponentController();
         this.glowComponentController = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get showRankedQueueFailurePopupAction() : ShowRankedQueueFailurePopupAction
      {
         return this._1075359937showRankedQueueFailurePopupAction;
      }
      
      private function _LolClientBeans_KeyBindingController1_i() : KeyBindingController
      {
         var _loc1_:KeyBindingController = new KeyBindingController();
         this.keybindingController = _loc1_;
         BindingManager.executeBindings(this,"keybindingController",this.keybindingController);
         return _loc1_;
      }
      
      public function set createPracticeGameController(param1:CreatePracticeGameController) : void
      {
         var _loc2_:Object = this._1576335205createPracticeGameController;
         if(_loc2_ !== param1)
         {
            this._1576335205createPracticeGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createPracticeGameController",_loc2_,param1));
         }
      }
      
      public function set rssAlertController(param1:RSSAlertController) : void
      {
         var _loc2_:Object = this._816736922rssAlertController;
         if(_loc2_ !== param1)
         {
            this._816736922rssAlertController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rssAlertController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerSearchController() : SummonerSearchController
      {
         return this._2108568786summonerSearchController;
      }
      
      private function _LolClientBeans_PresenceController1_i() : PresenceController
      {
         var _loc1_:PresenceController = new PresenceController();
         this.presenceController = _loc1_;
         BindingManager.executeBindings(this,"presenceController",this.presenceController);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaverBusterController() : LeaverBusterController
      {
         return this._2037600984leaverBusterController;
      }
      
      private function _LolClientBeans_LocalStatusController1_i() : LocalStatusController
      {
         var _loc1_:LocalStatusController = new LocalStatusController();
         this.localStatusController = _loc1_;
         return _loc1_;
      }
      
      public function set gameQueueManager(param1:GameQueueManager) : void
      {
         var _loc2_:Object = this._1137159790gameQueueManager;
         if(_loc2_ !== param1)
         {
            this._1137159790gameQueueManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameQueueManager",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_ShowAccountTransferFailedPopupAction1_i() : ShowAccountTransferFailedPopupAction
      {
         var _loc1_:ShowAccountTransferFailedPopupAction = new ShowAccountTransferFailedPopupAction();
         this.showAccountTransferFailedPopupAction = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_LCDSHeartBeatController1_i() : LCDSHeartBeatController
      {
         var _loc1_:LCDSHeartBeatController = new LCDSHeartBeatController();
         this.lcdsHeartBeatController = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_XMPPSessionLogger1_i() : XMPPSessionLogger
      {
         var _loc1_:XMPPSessionLogger = new XMPPSessionLogger();
         this.chatProperSessionLogger = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_EndOfGameScoreboardProvider1_i() : EndOfGameScoreboardProvider
      {
         var _loc1_:EndOfGameScoreboardProvider = new EndOfGameScoreboardProvider();
         this.endOfGameScoreboardProvider = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_CreatePracticeGameController1_i() : CreatePracticeGameController
      {
         var _loc1_:CreatePracticeGameController = new CreatePracticeGameController();
         this.createPracticeGameController = _loc1_;
         BindingManager.executeBindings(this,"createPracticeGameController",this.createPracticeGameController);
         return _loc1_;
      }
      
      private function _LolClientBeans_ShowAccountTransferCompletedPopupAction1_i() : ShowAccountTransferCompletedPopupAction
      {
         var _loc1_:ShowAccountTransferCompletedPopupAction = new ShowAccountTransferCompletedPopupAction();
         this.showAccountTransferCompletedPopupAction = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_LoyaltyController1_i() : LoyaltyController
      {
         var _loc1_:LoyaltyController = new LoyaltyController();
         this.loyaltyController = _loc1_;
         return _loc1_;
      }
      
      public function set chooseGameFlowViewController(param1:ChooseGameFlowViewController) : void
      {
         var _loc2_:Object = this._962434184chooseGameFlowViewController;
         if(_loc2_ !== param1)
         {
            this._962434184chooseGameFlowViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseGameFlowViewController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_ViewMediatorImpl1_i() : ViewMediatorImpl
      {
         var _loc1_:ViewMediatorImpl = new ViewMediatorImpl();
         this.viewMediator = _loc1_;
         BindingManager.executeBindings(this,"viewMediator",this.viewMediator);
         return _loc1_;
      }
      
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         var _loc2_:Object = this._566834807summonerProfileController;
         if(_loc2_ !== param1)
         {
            this._566834807summonerProfileController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerProfileController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get joinGameController() : JoinGameController
      {
         return this._620829944joinGameController;
      }
      
      private function _LolClientBeans_ChatViewMediatorImpl1_i() : ChatViewMediatorImpl
      {
         var _loc1_:ChatViewMediatorImpl = new ChatViewMediatorImpl();
         this.chatViewMediator = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get chooseSummonerIconController() : ChooseSummonerIconController
      {
         return this._192111834chooseSummonerIconController;
      }
      
      private function _LolClientBeans_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():PresenceController
         {
            return presenceController;
         },function(param1:PresenceController):void
         {
            chatController.presenceController = param1;
         },"chatController.presenceController");
         result[0] = binding;
         binding = new Binding(this,function():XMPPSessionLogger
         {
            return chatProperSessionLogger;
         },function(param1:XMPPSessionLogger):void
         {
            chatController.xmppSessionLogger = param1;
         },"chatController.xmppSessionLogger");
         result[1] = binding;
         binding = new Binding(this,function():PrivacyListController
         {
            return privacyListController;
         },function(param1:PrivacyListController):void
         {
            chatController.privacyListController = param1;
         },"chatController.privacyListController");
         result[2] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            presenceController.chatController = param1;
         },"presenceController.chatController");
         result[3] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            privacyListController.chatController = param1;
         },"privacyListController.chatController");
         result[4] = binding;
         binding = new Binding(this,function():SummonerController
         {
            return summonerController;
         },function(param1:SummonerController):void
         {
            applicationController.summonerController = param1;
         },"applicationController.summonerController");
         result[5] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            applicationController.masterGameController = param1;
         },"applicationController.masterGameController");
         result[6] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            applicationController.chatController = param1;
         },"applicationController.chatController");
         result[7] = binding;
         binding = new Binding(this,function():ILobbyViewController
         {
            return lobbyController;
         },function(param1:ILobbyViewController):void
         {
            applicationController.lobbyController = param1;
         },"applicationController.lobbyController");
         result[8] = binding;
         binding = new Binding(this,function():ViewMediator
         {
            return viewMediator;
         },function(param1:ViewMediator):void
         {
            applicationController.viewMediator = param1;
         },"applicationController.viewMediator");
         result[9] = binding;
         binding = new Binding(this,function():InGameController
         {
            return inGameController;
         },function(param1:InGameController):void
         {
            applicationController.inGameController = param1;
         },"applicationController.inGameController");
         result[10] = binding;
         binding = new Binding(this,function():IGameQueueManager
         {
            return gameQueueManager;
         },function(param1:IGameQueueManager):void
         {
            applicationController.gameQueueManager = param1;
         },"applicationController.gameQueueManager");
         result[11] = binding;
         binding = new Binding(this,function():StoreController
         {
            return storeController;
         },function(param1:StoreController):void
         {
            applicationController.storeController = param1;
         },"applicationController.storeController");
         result[12] = binding;
         binding = new Binding(this,function():PresenceController
         {
            return presenceController;
         },function(param1:PresenceController):void
         {
            applicationController.presenceController = param1;
         },"applicationController.presenceController");
         result[13] = binding;
         binding = new Binding(this,function():MasterGameViewController
         {
            return masterGameViewController;
         },function(param1:MasterGameViewController):void
         {
            applicationController.masterGameViewController = param1;
         },"applicationController.masterGameViewController");
         result[14] = binding;
         binding = new Binding(this,function():RSSAlertController
         {
            return rssAlertController;
         },function(param1:RSSAlertController):void
         {
            applicationController.rssAlertController = param1;
         },"applicationController.rssAlertController");
         result[15] = binding;
         binding = new Binding(this,function():LeaverBusterController
         {
            return leaverBusterController;
         },function(param1:LeaverBusterController):void
         {
            applicationController.leaverBusterController = param1;
         },"applicationController.leaverBusterController");
         result[16] = binding;
         binding = new Binding(this,function():RealNameController
         {
            return realNameController;
         },function(param1:RealNameController):void
         {
            applicationController.realNameController = param1;
         },"applicationController.realNameController");
         result[17] = binding;
         binding = new Binding(this,function():AccountStateChangeNotificationListener
         {
            return accountStateChangeNotificationListener;
         },function(param1:AccountStateChangeNotificationListener):void
         {
            applicationController.accountStateChangeEventListener = param1;
         },"applicationController.accountStateChangeEventListener");
         result[18] = binding;
         binding = new Binding(this,function():PlayerPreferencesSyncController
         {
            return playerPreferencesSyncController;
         },function(param1:PlayerPreferencesSyncController):void
         {
            applicationController.playerPreferencesSyncController = param1;
         },"applicationController.playerPreferencesSyncController");
         result[19] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            viewMediator.chatController = param1;
         },"viewMediator.chatController");
         result[20] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            viewMediator.applicationController = param1;
         },"viewMediator.applicationController");
         result[21] = binding;
         binding = new Binding(this,function():SummonerController
         {
            return summonerController;
         },function(param1:SummonerController):void
         {
            viewMediator.summonerController = param1;
         },"viewMediator.summonerController");
         result[22] = binding;
         binding = new Binding(this,function():ILobbyViewController
         {
            return lobbyController;
         },function(param1:ILobbyViewController):void
         {
            viewMediator.lobbyController = param1;
         },"viewMediator.lobbyController");
         result[23] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            viewMediator.masterGameController = param1;
         },"viewMediator.masterGameController");
         result[24] = binding;
         binding = new Binding(this,function():PlayTutorialGameController
         {
            return playTutorialGameController;
         },function(param1:PlayTutorialGameController):void
         {
            viewMediator.playTutorialGameController = param1;
         },"viewMediator.playTutorialGameController");
         result[25] = binding;
         binding = new Binding(this,function():IAction
         {
            return showRatingsPopupAction;
         },function(param1:IAction):void
         {
            viewMediator.onEnterLobbyAction = param1;
         },"viewMediator.onEnterLobbyAction");
         result[26] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            enterChampionSelectManager.masterGameController = param1;
         },"enterChampionSelectManager.masterGameController");
         result[27] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            masterGameController.applicationController = param1;
         },"masterGameController.applicationController");
         result[28] = binding;
         binding = new Binding(this,function():MasterGameViewController
         {
            return masterGameViewController;
         },function(param1:MasterGameViewController):void
         {
            masterGameController.masterGameViewController = param1;
         },"masterGameController.masterGameViewController");
         result[29] = binding;
         binding = new Binding(this,function():JoinGameController
         {
            return joinGameController;
         },function(param1:JoinGameController):void
         {
            masterGameController.joinGameController = param1;
         },"masterGameController.joinGameController");
         result[30] = binding;
         binding = new Binding(this,function():CreatePracticeGameController
         {
            return createPracticeGameController;
         },function(param1:CreatePracticeGameController):void
         {
            masterGameController.createPracticeGameController = param1;
         },"masterGameController.createPracticeGameController");
         result[31] = binding;
         binding = new Binding(this,function():CreateTutorialGameController
         {
            return createTutorialGameController;
         },function(param1:CreateTutorialGameController):void
         {
            masterGameController.createTutorialGameController = param1;
         },"masterGameController.createTutorialGameController");
         result[32] = binding;
         binding = new Binding(this,function():ILobbyViewController
         {
            return lobbyController;
         },function(param1:ILobbyViewController):void
         {
            masterGameController.lobbyController = param1;
         },"masterGameController.lobbyController");
         result[33] = binding;
         binding = new Binding(this,function():TeamSelectionController
         {
            return teamSelectionController;
         },function(param1:TeamSelectionController):void
         {
            masterGameController.teamSelectionController = param1;
         },"masterGameController.teamSelectionController");
         result[34] = binding;
         binding = new Binding(this,function():InGameController
         {
            return inGameController;
         },function(param1:InGameController):void
         {
            masterGameController.inGameController = param1;
         },"masterGameController.inGameController");
         result[35] = binding;
         binding = new Binding(this,function():EndOfGameStatsController
         {
            return endOfGameStatsController;
         },function(param1:EndOfGameStatsController):void
         {
            masterGameController.endOfGameStatsController = param1;
         },"masterGameController.endOfGameStatsController");
         result[36] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            masterGameController.chatController = param1;
         },"masterGameController.chatController");
         result[37] = binding;
         binding = new Binding(this,function():ViewMediator
         {
            return viewMediator;
         },function(param1:ViewMediator):void
         {
            masterGameController.viewMediator = param1;
         },"masterGameController.viewMediator");
         result[38] = binding;
         binding = new Binding(this,function():EnterChampionSelectManager
         {
            return enterChampionSelectManager;
         },function(param1:EnterChampionSelectManager):void
         {
            masterGameController.enterChampionSelectManager = param1;
         },"masterGameController.enterChampionSelectManager");
         result[39] = binding;
         binding = new Binding(this,function():PracticeGameManager
         {
            return practiceGameManager;
         },function(param1:PracticeGameManager):void
         {
            masterGameController.practiceGameManager = param1;
         },"masterGameController.practiceGameManager");
         result[40] = binding;
         binding = new Binding(this,function():IAFKFilterChampionSelectionAlertAction
         {
            return showAFKFilterChampionSelectionPopupAction;
         },function(param1:IAFKFilterChampionSelectionAlertAction):void
         {
            masterGameController.AFKFilterChampionSelectionAlertAction = param1;
         },"masterGameController.AFKFilterChampionSelectionAlertAction");
         result[41] = binding;
         binding = new Binding(this,function():ILegacyChampionSelectionAlertAction
         {
            return showLegacyChampionSelectionPopupAction;
         },function(param1:ILegacyChampionSelectionAlertAction):void
         {
            masterGameController.legacyChampionSelectionAlertAction = param1;
         },"masterGameController.legacyChampionSelectionAlertAction");
         result[42] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            joinGameController.masterGameController = param1;
         },"joinGameController.masterGameController");
         result[43] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            createPracticeGameController.masterGameController = param1;
         },"createPracticeGameController.masterGameController");
         result[44] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            createTutorialGameController.masterGameController = param1;
         },"createTutorialGameController.masterGameController");
         result[45] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            teamSelectionController.masterGameController = param1;
         },"teamSelectionController.masterGameController");
         result[46] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            teamSelectionController.chatController = param1;
         },"teamSelectionController.chatController");
         result[47] = binding;
         binding = new Binding(this,function():IRankedQueueFailureAlertAction
         {
            return showRankedQueueFailurePopupAction;
         },function(param1:IRankedQueueFailureAlertAction):void
         {
            teamSelectionController.rankedQueueFailureAlertAction = param1;
         },"teamSelectionController.rankedQueueFailureAlertAction");
         result[48] = binding;
         binding = new Binding(this,function():LCDSHeartBeatController
         {
            return lcdsHeartBeatController;
         },function(param1:LCDSHeartBeatController):void
         {
            endOfGameStatsController.lcdsHeartBeatController = param1;
         },"endOfGameStatsController.lcdsHeartBeatController");
         result[49] = binding;
         binding = new Binding(this,function():ViewMediator
         {
            return viewMediator;
         },function(param1:ViewMediator):void
         {
            endOfGameStatsController.viewMediator = param1;
         },"endOfGameStatsController.viewMediator");
         result[50] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            endOfGameStatsController.chatController = param1;
         },"endOfGameStatsController.chatController");
         result[51] = binding;
         binding = new Binding(this,function():PresenceController
         {
            return presenceController;
         },function(param1:PresenceController):void
         {
            endOfGameStatsController.presenceController = param1;
         },"endOfGameStatsController.presenceController");
         result[52] = binding;
         binding = new Binding(this,function():CreateTutorialGameController
         {
            return createTutorialGameController;
         },function(param1:CreateTutorialGameController):void
         {
            endOfGameStatsController.createTutorialGameController = param1;
         },"endOfGameStatsController.createTutorialGameController");
         result[53] = binding;
         binding = new Binding(this,function():ArrowedAlertController
         {
            return arrowedAlertController;
         },function(param1:ArrowedAlertController):void
         {
            endOfGameStatsController.arrowedAlertController = param1;
         },"endOfGameStatsController.arrowedAlertController");
         result[54] = binding;
         binding = new Binding(this,function():GlowComponentController
         {
            return glowComponentController;
         },function(param1:GlowComponentController):void
         {
            endOfGameStatsController.glowComponentController = param1;
         },"endOfGameStatsController.glowComponentController");
         result[55] = binding;
         binding = new Binding(this,function():IReportPlayerAlertAction
         {
            return showReportPlayerPopupAction;
         },function(param1:IReportPlayerAlertAction):void
         {
            endOfGameStatsController.reportPlayerAlertAction = param1;
         },"endOfGameStatsController.reportPlayerAlertAction");
         result[56] = binding;
         binding = new Binding(this,function():ViewMediator
         {
            return viewMediator;
         },function(param1:ViewMediator):void
         {
            masterGameViewController.viewMediator = param1;
         },"masterGameViewController.viewMediator");
         result[57] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            masterGameViewController.masterGameController = param1;
         },"masterGameViewController.masterGameController");
         result[58] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            masterGameViewController.applicationController = param1;
         },"masterGameViewController.applicationController");
         result[59] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            masterGameViewController.chatController = param1;
         },"masterGameViewController.chatController");
         result[60] = binding;
         binding = new Binding(this,function():GameQueueManager
         {
            return gameQueueManager;
         },function(param1:GameQueueManager):void
         {
            masterGameViewController.gameQueueManager = param1;
         },"masterGameViewController.gameQueueManager");
         result[61] = binding;
         binding = new Binding(this,function():ILobbyViewController
         {
            return lobbyController;
         },function(param1:ILobbyViewController):void
         {
            masterGameViewController.lobbyController = param1;
         },"masterGameViewController.lobbyController");
         result[62] = binding;
         binding = new Binding(this,function():PresenceController
         {
            return presenceController;
         },function(param1:PresenceController):void
         {
            masterGameViewController.presenceController = param1;
         },"masterGameViewController.presenceController");
         result[63] = binding;
         binding = new Binding(this,function():IRankedQueueFailureAlertAction
         {
            return showRankedQueueFailurePopupAction;
         },function(param1:IRankedQueueFailureAlertAction):void
         {
            masterGameViewController.rankedQueueFailureAlertAction = param1;
         },"masterGameViewController.rankedQueueFailureAlertAction");
         result[64] = binding;
         binding = new Binding(this,function():ILeaverBusterAlertAction
         {
            return showLeaverBusterAlertAction;
         },function(param1:ILeaverBusterAlertAction):void
         {
            masterGameViewController.leaverBusterPopupAction = param1;
         },"masterGameViewController.leaverBusterPopupAction");
         result[65] = binding;
         binding = new Binding(this,function():IQueueDodgeAlertAction
         {
            return showQueueDodgePopupAction;
         },function(param1:IQueueDodgeAlertAction):void
         {
            masterGameViewController.queueDodgeAlertAction = param1;
         },"masterGameViewController.queueDodgeAlertAction");
         result[66] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            chooseGameFlowViewController.applicationController = param1;
         },"chooseGameFlowViewController.applicationController");
         result[67] = binding;
         binding = new Binding(this,function():GameQueueManager
         {
            return gameQueueManager;
         },function(param1:GameQueueManager):void
         {
            chooseGameFlowViewController.gameQueueManager = param1;
         },"chooseGameFlowViewController.gameQueueManager");
         result[68] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            chooseGameFlowViewController.masterGameController = param1;
         },"chooseGameFlowViewController.masterGameController");
         result[69] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            inGameController.applicationController = param1;
         },"inGameController.applicationController");
         result[70] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            inGameController.masterGameController = param1;
         },"inGameController.masterGameController");
         result[71] = binding;
         binding = new Binding(this,function():MasterGameViewController
         {
            return masterGameViewController;
         },function(param1:MasterGameViewController):void
         {
            lobbyController.masterGameViewController = param1;
         },"lobbyController.masterGameViewController");
         result[72] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            lobbyController.applicationController = param1;
         },"lobbyController.applicationController");
         result[73] = binding;
         binding = new Binding(this,function():SummonerSearchController
         {
            return summonerSearchController;
         },function(param1:SummonerSearchController):void
         {
            lobbyController.summonerSearchController = param1;
         },"lobbyController.summonerSearchController");
         result[74] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            lobbyController.summonerProfileController = param1;
         },"lobbyController.summonerProfileController");
         result[75] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            lobbyController.masterGameController = param1;
         },"lobbyController.masterGameController");
         result[76] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            lobbyController.chatController = param1;
         },"lobbyController.chatController");
         result[77] = binding;
         binding = new Binding(this,function():ChooseGameFlowViewController
         {
            return chooseGameFlowViewController;
         },function(param1:ChooseGameFlowViewController):void
         {
            lobbyController.chooseGameFlowViewController = param1;
         },"lobbyController.chooseGameFlowViewController");
         result[78] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            createSummonerWizardController.applicationController = param1;
         },"createSummonerWizardController.applicationController");
         result[79] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            summonerProfileController.chatController = param1;
         },"summonerProfileController.chatController");
         result[80] = binding;
         binding = new Binding(this,function():ProfileLifetimeStatsPresentationModel
         {
            return profileLifetimeStatsPresentationModel;
         },function(param1:ProfileLifetimeStatsPresentationModel):void
         {
            summonerProfileController.profileLifetimeStatsPresentationModel = param1;
         },"summonerProfileController.profileLifetimeStatsPresentationModel");
         result[81] = binding;
         binding = new Binding(this,function():ProfileStatsSummaryPresentationModel
         {
            return profileStatsSummaryPresentationModel;
         },function(param1:ProfileStatsSummaryPresentationModel):void
         {
            summonerProfileController.profileStatsSummaryPresentationModel = param1;
         },"summonerProfileController.profileStatsSummaryPresentationModel");
         result[82] = binding;
         binding = new Binding(this,function():ViewMediator
         {
            return viewMediator;
         },function(param1:ViewMediator):void
         {
            chooseSummonerIconController.viewMediator = param1;
         },"chooseSummonerIconController.viewMediator");
         result[83] = binding;
         binding = new Binding(this,function():PresenceController
         {
            return presenceController;
         },function(param1:PresenceController):void
         {
            chooseSummonerIconController.presenceController = param1;
         },"chooseSummonerIconController.presenceController");
         result[84] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            chooseSummonerIconController.summonerProfileController = param1;
         },"chooseSummonerIconController.summonerProfileController");
         result[85] = binding;
         binding = new Binding(this,function():ILobbyViewController
         {
            return lobbyController;
         },function(param1:ILobbyViewController):void
         {
            playTutorialGameController.lobbyController = param1;
         },"playTutorialGameController.lobbyController");
         result[86] = binding;
         binding = new Binding(this,function():ViewMediator
         {
            return viewMediator;
         },function(param1:ViewMediator):void
         {
            playTutorialGameController.viewMediator = param1;
         },"playTutorialGameController.viewMediator");
         result[87] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            playTutorialGameController.masterGameController = param1;
         },"playTutorialGameController.masterGameController");
         result[88] = binding;
         binding = new Binding(this,function():ViewMediator
         {
            return viewMediator;
         },function(param1:ViewMediator):void
         {
            eloQuestionaireController.viewMediator = param1;
         },"eloQuestionaireController.viewMediator");
         result[89] = binding;
         binding = new Binding(this,function():ChatController
         {
            return chatController;
         },function(param1:ChatController):void
         {
            profileStatsSummaryPresentationModel.chatController = param1;
         },"profileStatsSummaryPresentationModel.chatController");
         result[90] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            rssAlertController.applicationController = param1;
         },"rssAlertController.applicationController");
         result[91] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            leaverBusterController.masterGameController = param1;
         },"leaverBusterController.masterGameController");
         result[92] = binding;
         binding = new Binding(this,function():IAppController
         {
            return applicationController;
         },function(param1:IAppController):void
         {
            accountStateChangeNotificationListener.applicationController = param1;
         },"accountStateChangeNotificationListener.applicationController");
         result[93] = binding;
         binding = new Binding(this,function():IShowAccountTransferPopupAction
         {
            return showAccountTransferCompletedPopupAction;
         },function(param1:IShowAccountTransferPopupAction):void
         {
            accountStateChangeNotificationListener.accountTransferCompletedPopupAction = param1;
         },"accountStateChangeNotificationListener.accountTransferCompletedPopupAction");
         result[94] = binding;
         binding = new Binding(this,function():IShowAccountTransferPopupAction
         {
            return showAccountTransferFailedPopupAction;
         },function(param1:IShowAccountTransferPopupAction):void
         {
            accountStateChangeNotificationListener.accountTransferFailedPopupAction = param1;
         },"accountStateChangeNotificationListener.accountTransferFailedPopupAction");
         result[95] = binding;
         binding = new Binding(this,function():IShowAccountTransferPopupAction
         {
            return showAccountTransferStartedPopupAction;
         },function(param1:IShowAccountTransferPopupAction):void
         {
            accountStateChangeNotificationListener.accountTransferStartedPopupAction = param1;
         },"accountStateChangeNotificationListener.accountTransferStartedPopupAction");
         result[96] = binding;
         binding = new Binding(this,function():IShowAccountTransferPopupAction
         {
            return showAccountTransferUnknownPopupAction;
         },function(param1:IShowAccountTransferPopupAction):void
         {
            accountStateChangeNotificationListener.accountTransferUnknownPopupAction = param1;
         },"accountStateChangeNotificationListener.accountTransferUnknownPopupAction");
         result[97] = binding;
         binding = new Binding(this,function():PlayerPreferencesSyncController
         {
            return playerPreferencesSyncController;
         },function(param1:PlayerPreferencesSyncController):void
         {
            keybindingController.playerPreferencesSyncController = param1;
         },"keybindingController.playerPreferencesSyncController");
         result[98] = binding;
         binding = new Binding(this,function():KeyBindingController
         {
            return keybindingController;
         },function(param1:KeyBindingController):void
         {
            playerPreferencesSyncController.keybindingController = param1;
         },"playerPreferencesSyncController.keybindingController");
         result[99] = binding;
         binding = new Binding(this,function():MasterGameController
         {
            return masterGameController;
         },function(param1:MasterGameController):void
         {
            playerPreferencesSyncController.masterGameController = param1;
         },"playerPreferencesSyncController.masterGameController");
         result[100] = binding;
         binding = new Binding(this,function():ChooseSummonerIconController
         {
            return chooseSummonerIconController;
         },function(param1:ChooseSummonerIconController):void
         {
            legacyAccountCreationProvider.chooseSummonerIconController = param1;
         },"legacyAccountCreationProvider.chooseSummonerIconController");
         result[101] = binding;
         binding = new Binding(this,function():CreateTutorialGameController
         {
            return createTutorialGameController;
         },function(param1:CreateTutorialGameController):void
         {
            legacyAccountCreationProvider.createTutorialGameController = param1;
         },"legacyAccountCreationProvider.createTutorialGameController");
         result[102] = binding;
         binding = new Binding(this,function():EloQuestionaireController
         {
            return eloQuestionaireController;
         },function(param1:EloQuestionaireController):void
         {
            legacyAccountCreationProvider.eloQuestionnaireController = param1;
         },"legacyAccountCreationProvider.eloQuestionnaireController");
         result[103] = binding;
         binding = new Binding(this,function():PlayTutorialGameController
         {
            return playTutorialGameController;
         },function(param1:PlayTutorialGameController):void
         {
            legacyAccountCreationProvider.playTutorialGameController = param1;
         },"legacyAccountCreationProvider.playTutorialGameController");
         result[104] = binding;
         binding = new Binding(this,function():SummonerNameController
         {
            return createSummonerWizardController;
         },function(param1:SummonerNameController):void
         {
            legacyAccountCreationProvider.summonerNameController = param1;
         },"legacyAccountCreationProvider.summonerNameController");
         result[105] = binding;
         return result;
      }
      
      private function _LolClientBeans_EloQuestionaireController1_i() : EloQuestionaireController
      {
         var _loc1_:EloQuestionaireController = new EloQuestionaireController();
         this.eloQuestionaireController = _loc1_;
         BindingManager.executeBindings(this,"eloQuestionaireController",this.eloQuestionaireController);
         return _loc1_;
      }
      
      private function _LolClientBeans_EnterChampionSelectManager1_i() : EnterChampionSelectManager
      {
         var _loc1_:EnterChampionSelectManager = new EnterChampionSelectManager();
         this.enterChampionSelectManager = _loc1_;
         BindingManager.executeBindings(this,"enterChampionSelectManager",this.enterChampionSelectManager);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get applicationController() : ApplicationController
      {
         return this._2070536460applicationController;
      }
      
      public function set eloQuestionaireController(param1:EloQuestionaireController) : void
      {
         var _loc2_:Object = this._2131669637eloQuestionaireController;
         if(_loc2_ !== param1)
         {
            this._2131669637eloQuestionaireController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eloQuestionaireController",_loc2_,param1));
         }
      }
      
      public function set keybindingController(param1:KeyBindingController) : void
      {
         var _loc2_:Object = this._1048750206keybindingController;
         if(_loc2_ !== param1)
         {
            this._1048750206keybindingController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"keybindingController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
      }
      
      private function _LolClientBeans_MasterGameViewController1_i() : MasterGameViewController
      {
         var _loc1_:MasterGameViewController = new MasterGameViewController();
         this.masterGameViewController = _loc1_;
         BindingManager.executeBindings(this,"masterGameViewController",this.masterGameViewController);
         return _loc1_;
      }
      
      public function set playTutorialGameController(param1:PlayTutorialGameController) : void
      {
         var _loc2_:Object = this._825517952playTutorialGameController;
         if(_loc2_ !== param1)
         {
            this._825517952playTutorialGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playTutorialGameController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get presenceController() : PresenceController
      {
         return this._891297527presenceController;
      }
      
      private function _LolClientBeans_ArrowedAlertController1_i() : ArrowedAlertController
      {
         var _loc1_:ArrowedAlertController = new ArrowedAlertController();
         this.arrowedAlertController = _loc1_;
         return _loc1_;
      }
      
      public function set summonerController(param1:SummonerController) : void
      {
         var _loc2_:Object = this._672657526summonerController;
         if(_loc2_ !== param1)
         {
            this._672657526summonerController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerController",_loc2_,param1));
         }
      }
      
      public function set loyaltyController(param1:LoyaltyController) : void
      {
         var _loc2_:Object = this._61479806loyaltyController;
         if(_loc2_ !== param1)
         {
            this._61479806loyaltyController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loyaltyController",_loc2_,param1));
         }
      }
      
      public function set arrowedAlertController(param1:ArrowedAlertController) : void
      {
         var _loc2_:Object = this._317735280arrowedAlertController;
         if(_loc2_ !== param1)
         {
            this._317735280arrowedAlertController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrowedAlertController",_loc2_,param1));
         }
      }
      
      public function set showRatingsPopupAction(param1:ShowRatingsPopupAction) : void
      {
         var _loc2_:Object = this._185498505showRatingsPopupAction;
         if(_loc2_ !== param1)
         {
            this._185498505showRatingsPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showRatingsPopupAction",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_CreateTutorialGameController1_i() : CreateTutorialGameController
      {
         var _loc1_:CreateTutorialGameController = new CreateTutorialGameController();
         this.createTutorialGameController = _loc1_;
         BindingManager.executeBindings(this,"createTutorialGameController",this.createTutorialGameController);
         return _loc1_;
      }
      
      private function _LolClientBeans_ChatController1_i() : ChatController
      {
         var _loc1_:ChatController = new ChatController();
         this.chatController = _loc1_;
         BindingManager.executeBindings(this,"chatController",this.chatController);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get practiceGameManager() : PracticeGameManager
      {
         return this._2108295968practiceGameManager;
      }
      
      [Bindable(event="propertyChange")]
      public function get showAFKFilterChampionSelectionPopupAction() : ShowAFKFilterChampionSelectionPopupAction
      {
         return this._872287488showAFKFilterChampionSelectionPopupAction;
      }
      
      public function set privacyListController(param1:PrivacyListController) : void
      {
         var _loc2_:Object = this._1315726466privacyListController;
         if(_loc2_ !== param1)
         {
            this._1315726466privacyListController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"privacyListController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_JoinGameController1_i() : JoinGameController
      {
         var _loc1_:JoinGameController = new JoinGameController();
         this.joinGameController = _loc1_;
         BindingManager.executeBindings(this,"joinGameController",this.joinGameController);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get showAccountTransferUnknownPopupAction() : ShowAccountTransferUnknownPopupAction
      {
         return this._130501837showAccountTransferUnknownPopupAction;
      }
      
      [Bindable(event="propertyChange")]
      public function get showLegacyChampionSelectionPopupAction() : ShowLegacyChampionSelectionPopupAction
      {
         return this._1575296219showLegacyChampionSelectionPopupAction;
      }
      
      [Bindable(event="propertyChange")]
      public function get enterChampionSelectManager() : EnterChampionSelectManager
      {
         return this._1239547184enterChampionSelectManager;
      }
      
      [Bindable(event="propertyChange")]
      public function get showLeaverBusterAlertAction() : ShowLeaverBusterAlertAction
      {
         return this._1915053881showLeaverBusterAlertAction;
      }
      
      private function _LolClientBeans_MasterGameController1_i() : MasterGameController
      {
         var _loc1_:MasterGameController = new MasterGameController();
         this.masterGameController = _loc1_;
         BindingManager.executeBindings(this,"masterGameController",this.masterGameController);
         return _loc1_;
      }
      
      public function set profileLifetimeStatsPresentationModel(param1:ProfileLifetimeStatsPresentationModel) : void
      {
         var _loc2_:Object = this._159335554profileLifetimeStatsPresentationModel;
         if(_loc2_ !== param1)
         {
            this._159335554profileLifetimeStatsPresentationModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileLifetimeStatsPresentationModel",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_RealNameController1_i() : RealNameController
      {
         var _loc1_:RealNameController = new RealNameController();
         this.realNameController = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.presenceController;
         _loc1_ = this.chatProperSessionLogger;
         _loc1_ = this.privacyListController;
         _loc1_ = this.chatController;
         _loc1_ = this.chatController;
         _loc1_ = this.summonerController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.chatController;
         _loc1_ = this.lobbyController;
         _loc1_ = this.viewMediator;
         _loc1_ = this.inGameController;
         _loc1_ = this.gameQueueManager;
         _loc1_ = this.storeController;
         _loc1_ = this.presenceController;
         _loc1_ = this.masterGameViewController;
         _loc1_ = this.rssAlertController;
         _loc1_ = this.leaverBusterController;
         _loc1_ = this.realNameController;
         _loc1_ = this.accountStateChangeNotificationListener;
         _loc1_ = this.playerPreferencesSyncController;
         _loc1_ = this.chatController;
         _loc1_ = this.applicationController;
         _loc1_ = this.summonerController;
         _loc1_ = this.lobbyController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.playTutorialGameController;
         _loc1_ = this.showRatingsPopupAction;
         _loc1_ = this.masterGameController;
         _loc1_ = this.applicationController;
         _loc1_ = this.masterGameViewController;
         _loc1_ = this.joinGameController;
         _loc1_ = this.createPracticeGameController;
         _loc1_ = this.createTutorialGameController;
         _loc1_ = this.lobbyController;
         _loc1_ = this.teamSelectionController;
         _loc1_ = this.inGameController;
         _loc1_ = this.endOfGameStatsController;
         _loc1_ = this.chatController;
         _loc1_ = this.viewMediator;
         _loc1_ = this.enterChampionSelectManager;
         _loc1_ = this.practiceGameManager;
         _loc1_ = this.showAFKFilterChampionSelectionPopupAction;
         _loc1_ = this.showLegacyChampionSelectionPopupAction;
         _loc1_ = this.masterGameController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.chatController;
         _loc1_ = this.showRankedQueueFailurePopupAction;
         _loc1_ = this.lcdsHeartBeatController;
         _loc1_ = this.viewMediator;
         _loc1_ = this.chatController;
         _loc1_ = this.presenceController;
         _loc1_ = this.createTutorialGameController;
         _loc1_ = this.arrowedAlertController;
         _loc1_ = this.glowComponentController;
         _loc1_ = this.showReportPlayerPopupAction;
         _loc1_ = this.viewMediator;
         _loc1_ = this.masterGameController;
         _loc1_ = this.applicationController;
         _loc1_ = this.chatController;
         _loc1_ = this.gameQueueManager;
         _loc1_ = this.lobbyController;
         _loc1_ = this.presenceController;
         _loc1_ = this.showRankedQueueFailurePopupAction;
         _loc1_ = this.showLeaverBusterAlertAction;
         _loc1_ = this.showQueueDodgePopupAction;
         _loc1_ = this.applicationController;
         _loc1_ = this.gameQueueManager;
         _loc1_ = this.masterGameController;
         _loc1_ = this.applicationController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.masterGameViewController;
         _loc1_ = this.applicationController;
         _loc1_ = this.summonerSearchController;
         _loc1_ = this.summonerProfileController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.chatController;
         _loc1_ = this.chooseGameFlowViewController;
         _loc1_ = this.applicationController;
         _loc1_ = this.chatController;
         _loc1_ = this.profileLifetimeStatsPresentationModel;
         _loc1_ = this.profileStatsSummaryPresentationModel;
         _loc1_ = this.viewMediator;
         _loc1_ = this.presenceController;
         _loc1_ = this.summonerProfileController;
         _loc1_ = this.lobbyController;
         _loc1_ = this.viewMediator;
         _loc1_ = this.masterGameController;
         _loc1_ = this.viewMediator;
         _loc1_ = this.chatController;
         _loc1_ = this.applicationController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.applicationController;
         _loc1_ = this.showAccountTransferCompletedPopupAction;
         _loc1_ = this.showAccountTransferFailedPopupAction;
         _loc1_ = this.showAccountTransferStartedPopupAction;
         _loc1_ = this.showAccountTransferUnknownPopupAction;
         _loc1_ = this.playerPreferencesSyncController;
         _loc1_ = this.keybindingController;
         _loc1_ = this.masterGameController;
         _loc1_ = this.chooseSummonerIconController;
         _loc1_ = this.createTutorialGameController;
         _loc1_ = this.eloQuestionaireController;
         _loc1_ = this.playTutorialGameController;
         _loc1_ = this.createSummonerWizardController;
      }
      
      private function _LolClientBeans_ProfileStatsSummaryPresentationModel1_i() : ProfileStatsSummaryPresentationModel
      {
         var _loc1_:ProfileStatsSummaryPresentationModel = new ProfileStatsSummaryPresentationModel();
         this.profileStatsSummaryPresentationModel = _loc1_;
         BindingManager.executeBindings(this,"profileStatsSummaryPresentationModel",this.profileStatsSummaryPresentationModel);
         return _loc1_;
      }
      
      private function _LolClientBeans_PracticeGameManager1_i() : PracticeGameManager
      {
         var _loc1_:PracticeGameManager = new PracticeGameManager();
         this.practiceGameManager = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_ChooseSummonerIconController1_i() : ChooseSummonerIconController
      {
         var _loc1_:ChooseSummonerIconController = new ChooseSummonerIconController();
         this.chooseSummonerIconController = _loc1_;
         BindingManager.executeBindings(this,"chooseSummonerIconController",this.chooseSummonerIconController);
         return _loc1_;
      }
      
      public function set teamSelectionController(param1:TeamSelectionController) : void
      {
         var _loc2_:Object = this._843995307teamSelectionController;
         if(_loc2_ !== param1)
         {
            this._843995307teamSelectionController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSelectionController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_PreloadMediator1_i() : PreloadMediator
      {
         var _loc1_:PreloadMediator = new PreloadMediator();
         this.preloadMediator = _loc1_;
         return _loc1_;
      }
      
      public function set glowComponentController(param1:GlowComponentController) : void
      {
         var _loc2_:Object = this._1406224812glowComponentController;
         if(_loc2_ !== param1)
         {
            this._1406224812glowComponentController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glowComponentController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_SummonerController1_i() : SummonerController
      {
         var _loc1_:SummonerController = new SummonerController();
         this.summonerController = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_TeamSelectionController1_i() : TeamSelectionController
      {
         var _loc1_:TeamSelectionController = new TeamSelectionController();
         this.teamSelectionController = _loc1_;
         BindingManager.executeBindings(this,"teamSelectionController",this.teamSelectionController);
         return _loc1_;
      }
      
      public function set lcdsHeartBeatController(param1:LCDSHeartBeatController) : void
      {
         var _loc2_:Object = this._1074839630lcdsHeartBeatController;
         if(_loc2_ !== param1)
         {
            this._1074839630lcdsHeartBeatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lcdsHeartBeatController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get createPracticeGameController() : CreatePracticeGameController
      {
         return this._1576335205createPracticeGameController;
      }
      
      public function set inGameController(param1:InGameController) : void
      {
         var _loc2_:Object = this._957204045inGameController;
         if(_loc2_ !== param1)
         {
            this._957204045inGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inGameController",_loc2_,param1));
         }
      }
      
      public function set masterGameViewController(param1:MasterGameViewController) : void
      {
         var _loc2_:Object = this._1450947915masterGameViewController;
         if(_loc2_ !== param1)
         {
            this._1450947915masterGameViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameViewController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get storeController() : StoreController
      {
         return this._385461411storeController;
      }
      
      private function _LolClientBeans_ShowQueueDodgePopupAction1_i() : ShowQueueDodgePopupAction
      {
         var _loc1_:ShowQueueDodgePopupAction = new ShowQueueDodgePopupAction();
         this.showQueueDodgePopupAction = _loc1_;
         return _loc1_;
      }
      
      public function set viewMediator(param1:ViewMediatorImpl) : void
      {
         var _loc2_:Object = this._1197293384viewMediator;
         if(_loc2_ !== param1)
         {
            this._1197293384viewMediator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"viewMediator",_loc2_,param1));
         }
      }
      
      public function set showAccountTransferStartedPopupAction(param1:ShowAccountTransferStartedPopupAction) : void
      {
         var _loc2_:Object = this._1106847388showAccountTransferStartedPopupAction;
         if(_loc2_ !== param1)
         {
            this._1106847388showAccountTransferStartedPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showAccountTransferStartedPopupAction",_loc2_,param1));
         }
      }
      
      public function set localStatusController(param1:LocalStatusController) : void
      {
         var _loc2_:Object = this._1365522105localStatusController;
         if(_loc2_ !== param1)
         {
            this._1365522105localStatusController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localStatusController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rssAlertController() : RSSAlertController
      {
         return this._816736922rssAlertController;
      }
      
      [Bindable(event="propertyChange")]
      public function get chooseGameFlowViewController() : ChooseGameFlowViewController
      {
         return this._962434184chooseGameFlowViewController;
      }
      
      private function _LolClientBeans_ShowRatingsPopupAction1_i() : ShowRatingsPopupAction
      {
         var _loc1_:ShowRatingsPopupAction = new ShowRatingsPopupAction();
         this.showRatingsPopupAction = _loc1_;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get keybindingController() : KeyBindingController
      {
         return this._1048750206keybindingController;
      }
      
      public function set showRankedQueueFailurePopupAction(param1:ShowRankedQueueFailurePopupAction) : void
      {
         var _loc2_:Object = this._1075359937showRankedQueueFailurePopupAction;
         if(_loc2_ !== param1)
         {
            this._1075359937showRankedQueueFailurePopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showRankedQueueFailurePopupAction",_loc2_,param1));
         }
      }
      
      public function set realNameController(param1:RealNameController) : void
      {
         var _loc2_:Object = this._1883749947realNameController;
         if(_loc2_ !== param1)
         {
            this._1883749947realNameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"realNameController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerToolTipManager() : SummonerTooltipManager
      {
         return this._172540104summonerToolTipManager;
      }
      
      public function set profileStatsSummaryPresentationModel(param1:ProfileStatsSummaryPresentationModel) : void
      {
         var _loc2_:Object = this._1292102721profileStatsSummaryPresentationModel;
         if(_loc2_ !== param1)
         {
            this._1292102721profileStatsSummaryPresentationModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileStatsSummaryPresentationModel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showRatingsPopupAction() : ShowRatingsPopupAction
      {
         return this._185498505showRatingsPopupAction;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerController() : SummonerController
      {
         return this._672657526summonerController;
      }
      
      private function _LolClientBeans_SummonerTooltipManager1_i() : SummonerTooltipManager
      {
         var _loc1_:SummonerTooltipManager = new SummonerTooltipManager();
         this.summonerToolTipManager = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_ShowLeaverBusterAlertAction1_i() : ShowLeaverBusterAlertAction
      {
         var _loc1_:ShowLeaverBusterAlertAction = new ShowLeaverBusterAlertAction();
         this.showLeaverBusterAlertAction = _loc1_;
         return _loc1_;
      }
      
      private function _LolClientBeans_LobbyController1_i() : LobbyController
      {
         var _loc1_:LobbyController = new LobbyController();
         this.lobbyController = _loc1_;
         BindingManager.executeBindings(this,"lobbyController",this.lobbyController);
         return _loc1_;
      }
      
      private function _LolClientBeans_ApplicationController1_i() : ApplicationController
      {
         var _loc1_:ApplicationController = new ApplicationController();
         this.applicationController = _loc1_;
         BindingManager.executeBindings(this,"applicationController",this.applicationController);
         return _loc1_;
      }
      
      private function _LolClientBeans_ShowReportPlayerPopupAction1_i() : ShowReportPlayerPopupAction
      {
         var _loc1_:ShowReportPlayerPopupAction = new ShowReportPlayerPopupAction();
         this.showReportPlayerPopupAction = _loc1_;
         return _loc1_;
      }
      
      public function set showAccountTransferCompletedPopupAction(param1:ShowAccountTransferCompletedPopupAction) : void
      {
         var _loc2_:Object = this._680281042showAccountTransferCompletedPopupAction;
         if(_loc2_ !== param1)
         {
            this._680281042showAccountTransferCompletedPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showAccountTransferCompletedPopupAction",_loc2_,param1));
         }
      }
      
      public function set profileDisplayModel(param1:ProfileDisplayModel) : void
      {
         var _loc2_:Object = this._77251536profileDisplayModel;
         if(_loc2_ !== param1)
         {
            this._77251536profileDisplayModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileDisplayModel",_loc2_,param1));
         }
      }
      
      public function set playerPreferencesSyncController(param1:PlayerPreferencesSyncController) : void
      {
         var _loc2_:Object = this._2092253646playerPreferencesSyncController;
         if(_loc2_ !== param1)
         {
            this._2092253646playerPreferencesSyncController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerPreferencesSyncController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get glowComponentController() : GlowComponentController
      {
         return this._1406224812glowComponentController;
      }
      
      public function set endOfGameStatsController(param1:EndOfGameStatsController) : void
      {
         var _loc2_:Object = this._1164646953endOfGameStatsController;
         if(_loc2_ !== param1)
         {
            this._1164646953endOfGameStatsController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameStatsController",_loc2_,param1));
         }
      }
      
      public function set showReportPlayerPopupAction(param1:ShowReportPlayerPopupAction) : void
      {
         var _loc2_:Object = this._2113026512showReportPlayerPopupAction;
         if(_loc2_ !== param1)
         {
            this._2113026512showReportPlayerPopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showReportPlayerPopupAction",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_PlayTutorialGameController1_i() : PlayTutorialGameController
      {
         var _loc1_:PlayTutorialGameController = new PlayTutorialGameController();
         this.playTutorialGameController = _loc1_;
         BindingManager.executeBindings(this,"playTutorialGameController",this.playTutorialGameController);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get lcdsHeartBeatController() : LCDSHeartBeatController
      {
         return this._1074839630lcdsHeartBeatController;
      }
      
      [Bindable(event="propertyChange")]
      public function get inGameController() : InGameController
      {
         return this._957204045inGameController;
      }
      
      public function set chooseSummonerIconController(param1:ChooseSummonerIconController) : void
      {
         var _loc2_:Object = this._192111834chooseSummonerIconController;
         if(_loc2_ !== param1)
         {
            this._192111834chooseSummonerIconController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseSummonerIconController",_loc2_,param1));
         }
      }
      
      public function set leaverBusterController(param1:LeaverBusterController) : void
      {
         var _loc2_:Object = this._2037600984leaverBusterController;
         if(_loc2_ !== param1)
         {
            this._2037600984leaverBusterController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaverBusterController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_GameQueueManager1_i() : GameQueueManager
      {
         var _loc1_:GameQueueManager = new GameQueueManager();
         this.gameQueueManager = _loc1_;
         return _loc1_;
      }
      
      public function set chatProperSessionLogger(param1:XMPPSessionLogger) : void
      {
         var _loc2_:Object = this._1380429858chatProperSessionLogger;
         if(_loc2_ !== param1)
         {
            this._1380429858chatProperSessionLogger = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatProperSessionLogger",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileStatsSummaryPresentationModel() : ProfileStatsSummaryPresentationModel
      {
         return this._1292102721profileStatsSummaryPresentationModel;
      }
      
      public function set showQueueDodgePopupAction(param1:ShowQueueDodgePopupAction) : void
      {
         var _loc2_:Object = this._1659834913showQueueDodgePopupAction;
         if(_loc2_ !== param1)
         {
            this._1659834913showQueueDodgePopupAction = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showQueueDodgePopupAction",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileDisplayModel() : ProfileDisplayModel
      {
         return this._77251536profileDisplayModel;
      }
      
      public function set summonerSearchController(param1:SummonerSearchController) : void
      {
         var _loc2_:Object = this._2108568786summonerSearchController;
         if(_loc2_ !== param1)
         {
            this._2108568786summonerSearchController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerSearchController",_loc2_,param1));
         }
      }
      
      private function _LolClientBeans_LeaverBusterController1_i() : LeaverBusterController
      {
         var _loc1_:LeaverBusterController = new LeaverBusterController();
         this.leaverBusterController = _loc1_;
         BindingManager.executeBindings(this,"leaverBusterController",this.leaverBusterController);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get realNameController() : RealNameController
      {
         return this._1883749947realNameController;
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGameStatsController() : EndOfGameStatsController
      {
         return this._1164646953endOfGameStatsController;
      }
      
      private function _LolClientBeans_SummonerSearchController1_i() : SummonerSearchController
      {
         var _loc1_:SummonerSearchController = new SummonerSearchController();
         this.summonerSearchController = _loc1_;
         return _loc1_;
      }
      
      public function set endOfGameScoreboardProvider(param1:EndOfGameScoreboardProvider) : void
      {
         var _loc2_:Object = this._1621263383endOfGameScoreboardProvider;
         if(_loc2_ !== param1)
         {
            this._1621263383endOfGameScoreboardProvider = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameScoreboardProvider",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerPreferencesSyncController() : PlayerPreferencesSyncController
      {
         return this._2092253646playerPreferencesSyncController;
      }
      
      [Bindable(event="propertyChange")]
      public function get chatProperSessionLogger() : XMPPSessionLogger
      {
         return this._1380429858chatProperSessionLogger;
      }
      
      [Bindable(event="propertyChange")]
      public function get showAccountTransferCompletedPopupAction() : ShowAccountTransferCompletedPopupAction
      {
         return this._680281042showAccountTransferCompletedPopupAction;
      }
      
      private function _LolClientBeans_SummonerProfileController1_i() : SummonerProfileController
      {
         var _loc1_:SummonerProfileController = new SummonerProfileController();
         this.summonerProfileController = _loc1_;
         BindingManager.executeBindings(this,"summonerProfileController",this.summonerProfileController);
         return _loc1_;
      }
      
      public function set spectatorController(param1:SpectatorController) : void
      {
         var _loc2_:Object = this._307054059spectatorController;
         if(_loc2_ !== param1)
         {
            this._307054059spectatorController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showReportPlayerPopupAction() : ShowReportPlayerPopupAction
      {
         return this._2113026512showReportPlayerPopupAction;
      }
      
      public function set createSummonerWizardController(param1:SummonerNameController) : void
      {
         var _loc2_:Object = this._1559360015createSummonerWizardController;
         if(_loc2_ !== param1)
         {
            this._1559360015createSummonerWizardController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createSummonerWizardController",_loc2_,param1));
         }
      }
      
      public function set presenceController(param1:PresenceController) : void
      {
         var _loc2_:Object = this._891297527presenceController;
         if(_loc2_ !== param1)
         {
            this._891297527presenceController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"presenceController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGameScoreboardProvider() : EndOfGameScoreboardProvider
      {
         return this._1621263383endOfGameScoreboardProvider;
      }
      
      [Bindable(event="propertyChange")]
      public function get createSummonerWizardController() : SummonerNameController
      {
         return this._1559360015createSummonerWizardController;
      }
      
      private function _LolClientBeans_ChooseGameFlowViewController1_i() : ChooseGameFlowViewController
      {
         var _loc1_:ChooseGameFlowViewController = new ChooseGameFlowViewController();
         this.chooseGameFlowViewController = _loc1_;
         BindingManager.executeBindings(this,"chooseGameFlowViewController",this.chooseGameFlowViewController);
         return _loc1_;
      }
      
      public function set joinGameController(param1:JoinGameController) : void
      {
         var _loc2_:Object = this._620829944joinGameController;
         if(_loc2_ !== param1)
         {
            this._620829944joinGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"joinGameController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newbieTipsController() : NewbieTipsController
      {
         return this._1295553550newbieTipsController;
      }
      
      public function set newbieTipsController(param1:NewbieTipsController) : void
      {
         var _loc2_:Object = this._1295553550newbieTipsController;
         if(_loc2_ !== param1)
         {
            this._1295553550newbieTipsController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newbieTipsController",_loc2_,param1));
         }
      }
   }
}

