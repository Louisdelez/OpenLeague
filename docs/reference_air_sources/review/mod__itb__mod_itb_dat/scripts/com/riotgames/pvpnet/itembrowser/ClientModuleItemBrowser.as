package com.riotgames.pvpnet.itembrowser
{
   import blix.action.IAction;
   import blix.action.SequenceAction;
   import blix.assets.proxy.DisplayAdapter;
   import blix.context.IContext;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.provider.IGameProvider;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.MainScreenProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.ItemSetItem;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.itembrowser.controller.ItemBrowserController;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.model.ItemBrowserModel;
   import com.riotgames.pvpnet.itembrowser.sets.dao.ItemSetsDao;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.itembrowser.sets.service.ItemSetServiceManager;
   import com.riotgames.pvpnet.itembrowser.views.ItemBrowserModuleView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTrackerPlaceholder;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTrackerPlaceHolder;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProviderPlaceholder;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.registerClassAlias;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleItemBrowser extends Sprite implements IProviderModule, IItemBrowserProvider
   {
      
      public static const ITEMBROWSER_RESOURCE_ID:String = "itemBrowser";
      
      private var gameProvider:IGameProvider;
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _itemBrowserController:ItemBrowserController;
      
      private var _itemBrowserView:ItemBrowserModuleView;
      
      private var _itemSetsBehaviorTracker:IItemSetsBehaviorTracker = new IItemSetsBehaviorTrackerPlaceholder();
      
      private var appConfig:AppConfig;
      
      private var _itemSetsOrganizationalStructureTracker:IItemSetsOrganizationalStructureTracker = new IItemSetsOrganizationalStructureTrackerPlaceHolder();
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _sessionMetrics:ISessionMetricsProvider = new ISessionMetricsProviderPlaceholder();
      
      private var inventoryProvider:IInventoryProvider;
      
      private var _itemSetServiceManager:ItemSetServiceManager;
      
      private var initSequence:SequenceAction;
      
      private var _itemBrowserModel:ItemBrowserModel;
      
      public function ClientModuleItemBrowser()
      {
         super();
      }
      
      private function getAppConfig() : void
      {
         this.appConfig = AppConfig.instance;
         this.initSequence.completeFunction(this.getAppConfig);
      }
      
      private function handleGameChanged() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:PlayerChampionSelectionDTO = null;
         var _loc4_:Champion = null;
         var _loc1_:GameDTO = this.gameProvider.currentGame;
         if(Boolean(_loc1_) && _loc1_.gameState == GameState.START_REQUESTED)
         {
            _loc2_ = Number(_loc1_.mapId);
            _loc3_ = _loc1_.getSelectionForSummonerName(Session.instance.summoner.internalName);
            if(_loc3_ != null)
            {
               _loc4_ = this.inventoryProvider.getInventory().championIdMapping[_loc3_.championId];
               this.outputChampionItems(_loc4_,_loc2_);
            }
         }
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         registerClassAlias(getQualifiedClassName(GameItem),GameItem);
         registerClassAlias(getQualifiedClassName(ItemSetItem),ItemSetItem);
         this._moduleInfo = param1;
         this.initSequence = new SequenceAction();
         this.initSequence.and(this.getLoadLocalizedResources());
         if(!UserPreferencesManager.instance.hasLoadedUserPreferences)
         {
            this.initSequence.andCall(this.getUserPreferences);
         }
         this.initSequence.andCall(this.getInventoryProvider);
         this.initSequence.andCall(this.getAppConfig);
         this.initSequence.andCall(this.getGameProvider);
         this.initSequence.getCompleted().addOnce(this.onInitComplete);
         this.initSequence.invoke();
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onCrossModuleTrackerProvider);
         ProviderLookup.getProvider(ISessionMetricsProvider,this.onSessionMetricsProvider);
      }
      
      private function onSessionMetricsProvider(param1:ISessionMetricsProvider) : void
      {
         this._sessionMetrics = param1;
      }
      
      public function getItemBrowserScreen(param1:IContext) : IMainScreen
      {
         if(this._itemBrowserView == null)
         {
            this._itemBrowserView = new ItemBrowserModuleView(param1,this._moduleInfo,this._itemBrowserModel,this._itemSetsModel,this._itemBrowserController,this._itemSetsController,this._itemSetsBehaviorTracker,this._itemSetsOrganizationalStructureTracker);
            this._itemBrowserView.setItemBrowserModel(this._itemBrowserModel);
            this._itemBrowserView.setItemSetsModel(this._itemSetsModel);
         }
         return this._itemBrowserView;
      }
      
      private function gotGameProvider(param1:IGameProvider) : void
      {
         this.gameProvider = param1;
         this.gameProvider.getCurrentGameChanged().add(this.handleGameChanged);
         this.initSequence.completeFunction(this.getGameProvider);
      }
      
      private function getInventoryProvider() : void
      {
         ProviderLookup.getProvider(IInventoryProvider,this.gotInventoryProvider);
      }
      
      private function onGottenUserPreferences(param1:Event) : void
      {
         this.initSequence.completeFunction(this.getUserPreferences);
         UserPreferencesManager.instance.removeEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.onGottenUserPreferences);
      }
      
      private function onCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._itemSetsOrganizationalStructureTracker = param1.getItemSetsOrganizationalStructureTracker();
         this._itemSetsBehaviorTracker = param1.getItemSetsBehaviorTracker();
      }
      
      private function gotInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventoryProvider = param1;
         this.initSequence.completeFunction(this.getInventoryProvider);
      }
      
      public function hide() : void
      {
         this._itemBrowserView.hide();
      }
      
      public function outputChampionItems(param1:Champion, param2:int = 1) : void
      {
         if(this._itemBrowserController)
         {
            this._itemBrowserController.exportChampionItems(param1,param2);
         }
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.F10)
         {
            this.outputChampionItems(this.inventoryProvider.getInventory().championIdMapping[22]);
         }
      }
      
      public function initModelAndController() : void
      {
         var _loc1_:ItemSetsDao = null;
         if(this._itemSetServiceManager == null)
         {
            this._itemSetServiceManager = new ItemSetServiceManager(ServiceProxy.instance.lcdsService,ClientConfig.instance);
         }
         if(this._itemSetsModel == null)
         {
            this._itemSetsModel = new ItemSetsModel();
         }
         if(this._itemBrowserModel == null)
         {
            this._itemBrowserModel = new ItemBrowserModel();
            this._itemBrowserModel.setItemSetsModel(this._itemSetsModel);
         }
         if(this._itemSetsController == null)
         {
            _loc1_ = new ItemSetsDao(this._itemSetServiceManager);
            this._itemSetsController = new ItemSetsController(this._itemSetsModel,_loc1_,this.inventoryProvider,this.appConfig,this._itemSetsBehaviorTracker,this._itemSetsOrganizationalStructureTracker,this._sessionMetrics);
         }
         if(this._itemBrowserController == null)
         {
            this._itemBrowserController = new ItemBrowserController(this._itemSetsController,this._itemBrowserModel,this._itemSetsBehaviorTracker);
         }
      }
      
      private function onInitComplete() : void
      {
         this.initModelAndController();
         ProviderLookup.publishProvider(IItemBrowserProvider,this);
         MainScreenProviderProxy.instance.registerMainScreenFactory(this._moduleInfo.getExtraDataValue("mainScreen"),this.getItemBrowserScreen);
         MainScreenProviderProxy.instance.registerMainScreenFactory("itemBrowser",this.getItemBrowserScreen);
      }
      
      private function getLoadLocalizedResources() : IAction
      {
         var _loc1_:String = ClientConfig.instance.locale;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         return new LoadModuleResourceBundleAction(_loc2_,_loc1_,"itemBrowser","itemBrowser","itb",ClientConfig.instance.debugLocale);
      }
      
      private function getUserPreferences() : void
      {
         UserPreferencesManager.instance.addEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.onGottenUserPreferences);
      }
      
      private function getGameProvider() : void
      {
         ProviderLookup.getProvider(IGameProvider,this.gotGameProvider);
      }
      
      public function show(param1:Number, param2:DisplayAdapter) : void
      {
         var _loc3_:ItemBrowserModuleView = this.getItemBrowserScreen(null) as ItemBrowserModuleView;
         _loc3_.show();
         param2.addChild(_loc3_);
      }
   }
}

