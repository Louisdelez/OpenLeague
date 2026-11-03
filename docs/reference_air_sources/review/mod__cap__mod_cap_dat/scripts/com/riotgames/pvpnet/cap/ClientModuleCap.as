package com.riotgames.pvpnet.cap
{
   import blix.action.IAction;
   import blix.components.tooltip.IToolTipManager;
   import blix.decorator.DecoratorManager;
   import blix.decorator.IDecoratorManager;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.provider.ICapProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.platform.provider.loader.IProvidersClassLoader;
   import com.riotgames.platform.provider.loader.ProvidersClassLoader;
   import com.riotgames.pvpnet.cap.context.CapContext;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.delegates.CapGamePreparationDelegate;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainModel;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.CapModuleRequestedObserver;
   import com.riotgames.pvpnet.cap.observers.IObserver;
   import com.riotgames.pvpnet.cap.observers.group.GroupUnreadyObserver;
   import com.riotgames.pvpnet.cap.services.CapLcdsMessageRouter;
   import com.riotgames.pvpnet.cap.services.CapLcdsProxyServiceMessangerGroup;
   import com.riotgames.pvpnet.cap.services.CapService;
   import com.riotgames.pvpnet.cap.views.CapModuleView;
   import com.riotgames.pvpnet.game.IGamePreparationDelegate;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.suggestedplayers.ISuggestedPlayersProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.decorator.AnimationToggleDecorator;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.core.UIComponent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleCap extends Sprite implements ICapProvider, IProviderModule
   {
      
      public static const MODULE_RESOURCE_BUNDLE_NAME:String = "GroupFinder";
      
      public static const MODULE_DIRECTORY_NAME:String = "cap";
      
      private static const _dependendantProviders:Array = [IMasterGameController,IInventoryProvider,IInviteProvider,IClientNotificationProvider,ISoundProvider,IMasteriesProvider,IRuneBookController,IGameQueueManager,INotificationsProvider,IPresenceProvider,ISuggestedPlayersProvider];
      
      private var _animationToggleDecorator:AnimationToggleDecorator;
      
      private var _providerLoader:IProvidersClassLoader;
      
      private var _dependencies:Dictionary;
      
      private var _clientNotificationProvider:IClientNotificationProvider;
      
      private var _moduleRequestedObserver:CapModuleRequestedObserver;
      
      private var _playAgainModel:CapPlayAgainModel;
      
      private var _capContext:CapContext;
      
      private var _moduleStage:DisplayObject;
      
      private var _moduleView:CapModuleView;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _parentContainer:UIComponent;
      
      private var published:Boolean = false;
      
      public function ClientModuleCap()
      {
         super();
         this._playAgainModel = new CapPlayAgainModel();
      }
      
      public function set contentHolder(param1:UIComponent) : void
      {
         this._parentContainer = param1;
         if(this._parentContainer != null)
         {
            this._moduleStage = this._moduleView.getAsset();
            this._parentContainer.addChild(this._moduleStage);
         }
      }
      
      private function createModel(param1:Dictionary) : CapModel
      {
         var _loc2_:InviteGroup = param1[InviteGroup];
         var _loc3_:GameQueueManager = param1[IGameQueueManager];
         var _loc4_:GameQueueConfig = _loc3_.selectedGameQueueConfig;
         var _loc5_:CapModel = new CapModel(_loc4_.numPlayersPerTeam);
         _loc5_.gameMode = _loc4_.gameMode;
         _loc5_.gameTypeConfigId = _loc4_.gameTypeConfigId;
         _loc5_.summoner = Session.instance.summoner;
         var _loc6_:IMasteriesProvider = param1[IMasteriesProvider];
         var _loc7_:IInventoryProvider = param1[IInventoryProvider];
         var _loc8_:IInventory = _loc7_.getInventory();
         _loc5_.masteryPages = _loc6_.getPagesInfo();
         _loc5_.runeBook = _loc8_.runeBook;
         var _loc9_:IMasterGameController = param1[IMasterGameController];
         _loc5_.groupId = _loc2_.groupId;
         _loc5_.localPlayerSelection.isPopulated = true;
         _loc5_.localPlayerSelection.isInvitedPlayer = Boolean(_loc2_.groupId);
         _loc5_.localPlayerSelection.masteryPage = this.getSelectedMasteryPage(_loc5_.masteryPages);
         _loc5_.localPlayerSelection.runePage = _loc8_.runeBook != null ? _loc8_.runeBook.defaultPage : null;
         if(!_loc5_.localPlayerSelection.isInvitedPlayer && !_loc9_.isSolo)
         {
            _loc5_.localPlayerSelection.slotId = CapPlayerSelection.CAPTAIN_INDEX;
         }
         _loc5_.localPlayerSelection.visible = true;
         return _loc5_;
      }
      
      private function show() : void
      {
         if(!this._providerLoader.getHasCompleted())
         {
            this._providerLoader.getCompleted().addOnce(this.onDependencyLoadComplete);
            this._providerLoader.getErred().addOnce(this.onDependencyLoadError);
            this._providerLoader.invoke();
         }
         else
         {
            this.setup();
         }
      }
      
      private function onEnableAnimationsChanged() : void
      {
         this._animationToggleDecorator.animationsEnabled = UserPreferencesManager.userPrefs.enableAnimations;
      }
      
      private function onLoggingOut(param1:Boolean) : void
      {
         var _loc2_:ICapController = null;
         if(param1)
         {
            _loc2_ = this._capContext != null ? this._capContext.getDependency(ICapController) : null;
            if(_loc2_)
            {
               _loc2_.requestQuit(true);
            }
         }
      }
      
      private function onMasterGameControllerReceived(param1:MasterGameController) : void
      {
         this._moduleRequestedObserver = new CapModuleRequestedObserver(param1.lobbyController);
         this._moduleRequestedObserver.setupSignals();
         this._moduleRequestedObserver.refresh();
         this._moduleRequestedObserver.activatedSignal.add(this.show);
         param1.playAgainClicked.add(this.onPlayAgainClicked);
         this.setupLoader();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         ProviderLookup.getProvider(IMasterGameController,this.onMasterGameControllerReceived,this.onDependencyLoadError);
         this.loadLocalizationResources();
      }
      
      private function getSelectedMasteryPage(param1:ArrayCollection) : MasteryPageInfoSummary
      {
         var _loc3_:MasteryPageInfoSummary = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.getItemAt(_loc2_) as MasteryPageInfoSummary;
            if(_loc3_.isCurrent)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function loadLocalizationResources() : void
      {
         var _loc1_:ClientConfig = ClientConfig.instance;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_.locale,MODULE_RESOURCE_BUNDLE_NAME,MODULE_RESOURCE_BUNDLE_NAME,MODULE_DIRECTORY_NAME,_loc1_.debugLocale);
         _loc3_.getCompleted().addOnce(this.onLocalizationResourcesLoadComplete);
         _loc3_.invoke();
      }
      
      private function createDictionaryCopy(param1:Dictionary) : Dictionary
      {
         var _loc3_:Object = null;
         var _loc2_:Dictionary = new Dictionary();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      private function onLocalizationResourcesLoadComplete() : void
      {
      }
      
      public function quit(param1:Function = null, param2:Function = null) : void
      {
         var _loc3_:ICapController = this._capContext != null ? this._capContext.getDependency(ICapController) : null;
         if(_loc3_)
         {
            _loc3_.requestQuit(false,param1,param2);
         }
      }
      
      private function onDependencyLoadError() : void
      {
         this._providerLoader.destroy();
         this.setupLoader();
         this.teardownAndExit();
         var _loc1_:AlertAction = new AlertAction("Error","Unable to launch Cap - failed to load dependencies");
         _loc1_.add();
      }
      
      public function registerForAsyncMessages() : void
      {
         var _loc1_:CapLcdsProxyServiceMessangerGroup = new CapLcdsProxyServiceMessangerGroup();
         var _loc2_:ILcdsProxyServiceMessenger = this._capContext.getDependency(CapLcdsMessageRouter);
         var _loc3_:ILcdsProxyServiceMessenger = this._capContext.getDependency(CapService);
         _loc1_.addMessenger(_loc2_);
         _loc1_.addMessenger(_loc3_);
         this._clientNotificationProvider.getLcdsProxyMessageRouter().setServiceCallListener(ClientNotificationProxyServiceName.CAP,_loc1_);
      }
      
      public function isModuleActive() : Boolean
      {
         var _loc1_:ICapController = this._capContext != null ? this._capContext.getDependency(ICapController) : null;
         if(_loc1_)
         {
            return _loc1_.isInitialized;
         }
         return false;
      }
      
      private function onAssetsLoaded() : void
      {
         var _loc3_:ISoundProvider = null;
         this.contentHolder = this._parentContainer;
         if(!this.published)
         {
            _loc3_ = this._capContext.getDependency(ISoundProvider);
            _loc3_.registerAudioDefinitionFile(this._moduleInfo.getPath() + "assets/audio/CapAudioEventDefinitions.xml");
         }
         var _loc1_:CapViewMediator = this._capContext.getDependency(CapViewMediator);
         _loc1_.initialize(this._moduleView.capView);
         var _loc2_:CapGamePreparationDelegate = this._capContext.getDependency(IGamePreparationDelegate) as CapGamePreparationDelegate;
         _loc2_.setView(this._moduleView.capView);
         if(!this.published)
         {
            ProviderLookup.publishProvider(ICapProvider,this);
            this.published = true;
         }
      }
      
      private function onChatProvider(param1:IChatProvider) : void
      {
         this._dependencies[IChatProvider] = param1;
      }
      
      private function onDependencyLoadComplete() : void
      {
         this._dependencies = this._providerLoader.dependencies;
         this._clientNotificationProvider = this._dependencies[IClientNotificationProvider];
         ProviderLookup.getProvider(IChatProvider,this.onChatProvider,this.onDependencyLoadError);
         this._dependencies[ILobbyViewController] = (this._dependencies[IMasterGameController] as MasterGameController).lobbyController;
         this.setup();
      }
      
      private function setupLoader() : void
      {
         this._providerLoader = new ProvidersClassLoader(_dependendantProviders);
      }
      
      private function teardownAndExit() : void
      {
         this._moduleRequestedObserver.deactivatedSignal.remove(this.teardownAndExit);
         var _loc1_:ICapController = this._capContext.getDependency(ICapController);
         if(_loc1_)
         {
            _loc1_.quitCompletedSignal.remove(this.teardownAndExit);
            _loc1_.hideView();
         }
         if(Boolean(this._parentContainer) && Boolean(this._moduleStage) && Boolean(this._parentContainer.contains(this._moduleStage)))
         {
            this._parentContainer.removeChild(this._moduleStage);
         }
         AppConfig.instance.loggingOutChanged.remove(this.onLoggingOut);
         this.unregisterForAsyncMessages();
         if(this._capContext)
         {
            this._capContext.destroy();
            delete this._dependencies[CapModel];
            this._capContext = null;
         }
         if(this._moduleView)
         {
            this._moduleView.destroy();
            this._moduleView.hide();
         }
         this._moduleView = null;
      }
      
      private function onInitialized() : void
      {
         this._moduleView = new CapModuleView(this._capContext,this._moduleInfo);
         this._moduleView.getAssetChanged().addOnce(this.onAssetsLoaded);
         this._moduleView.show();
      }
      
      private function onPlayAgainClicked(param1:Boolean) : void
      {
         this._playAgainModel.playAgainClicked = true;
         this._playAgainModel.isVictorious = param1;
      }
      
      public function unregisterForAsyncMessages() : void
      {
         this._clientNotificationProvider.getLcdsProxyMessageRouter().removeServiceCallListener(ClientNotificationProxyServiceName.CAP);
      }
      
      private function setup() : void
      {
         var _loc3_:IObserver = null;
         var _loc4_:GroupUnreadyObserver = null;
         var _loc5_:ICapController = null;
         var _loc6_:IDecoratorManager = null;
         var _loc7_:ToolTipConfig = null;
         var _loc8_:IToolTipManager = null;
         AppConfig.instance.loggingOutChanged.addOnce(this.onLoggingOut);
         this._moduleRequestedObserver.deactivatedSignal.add(this.teardownAndExit);
         var _loc1_:Dictionary = this.createDictionaryCopy(this._dependencies);
         if(!_loc1_[InviteGroup])
         {
            _loc1_[InviteGroup] = this._dependencies[IInviteProvider].getInviteGroup();
         }
         if(!_loc1_[IInviteController])
         {
            _loc1_[IInviteController] = this._dependencies[IInviteProvider].getInviteController();
         }
         if(!this._animationToggleDecorator)
         {
            _loc6_ = new DecoratorManager();
            this._animationToggleDecorator = new AnimationToggleDecorator();
            _loc6_.addDecorator(this._animationToggleDecorator);
            this._animationToggleDecorator.animationsEnabled = UserPreferencesManager.userPrefs.enableAnimations;
            UserPrefs.enableAnimationsChanged.add(this.onEnableAnimationsChanged);
         }
         if(!_loc1_[AnimationToggleDecorator])
         {
            _loc1_[AnimationToggleDecorator] = this._animationToggleDecorator;
         }
         if(!_loc1_[IDecoratorManager])
         {
            _loc1_[IDecoratorManager] = _loc6_;
         }
         if(!_loc1_[IToolTipManager])
         {
            _loc7_ = new ToolTipConfig();
            _loc7_.showDelay = 0;
            _loc8_ = TipsProviderProxy.instance.createWindowToolTipManager(null,_loc7_);
            _loc1_[IToolTipManager] = _loc8_;
         }
         _loc1_[CapModel] = this.createModel(_loc1_);
         _loc1_[CapPlayAgainModel] = this._playAgainModel;
         this._capContext = new CapContext(_loc1_);
         this.registerForAsyncMessages();
         var _loc2_:Array = this._capContext.getObservers();
         for each(_loc3_ in _loc2_)
         {
            _loc3_.setupSignals();
            _loc3_.refresh();
         }
         _loc4_ = this._capContext.getDependency(GroupUnreadyObserver);
         _loc4_.removeSignals();
         _loc5_ = this._capContext.getDependency(ICapController);
         _loc5_.quitCompletedSignal.addOnce(this.teardownAndExit);
         _loc5_.intializedSignal.addOnce(this.onInitialized);
         _loc5_.initialize();
      }
   }
}

