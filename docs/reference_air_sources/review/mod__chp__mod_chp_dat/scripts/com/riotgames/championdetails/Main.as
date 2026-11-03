package com.riotgames.championdetails
{
   import blix.action.SequenceAction;
   import blix.action.XmlLoaderAction;
   import blix.assets.proxy.MainAsset;
   import blix.assets.proxy.toolTip.ToolTipAsset;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTip;
   import blix.components.tooltip.ToolTipManager;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.greensock.OverwriteManager;
   import com.riotgames.championdetails.dao.ChampionDetailsDao;
   import com.riotgames.championdetails.dao.MockChampionDetailsDao;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.championdetails.tooltip.TweenedToolTipHandler;
   import com.riotgames.gameItems.dao.GameItemDao;
   import com.riotgames.gameItems.dao.MockGameItemDao;
   import com.riotgames.platform.common.GeneratedContentLoader;
   import com.riotgames.platform.common.domain.inventory.InventoryType;
   import com.riotgames.platform.common.provider.IReportingProvider;
   import com.riotgames.platform.common.provider.ReportingProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.pvpnet.system.messaging.MessageQueue;
   import com.riotgames.rust.module.RiotModuleView;
   import com.riotgames.store.dao.MockStoreCatalogDao;
   import com.riotgames.store.dao.StoreCatalogDao;
   import com.riotgames.store.model.Catalog;
   import com.riotgames.store.model.CatalogResult;
   import com.riotgames.store.model.ChampionSearchTag;
   import com.riotgames.util.logging.ErrorUtil;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.utils.getTimer;
   import mx.messaging.events.MessageEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class Main extends RiotModuleView implements IChampionDetailsContext
   {
      
      public static const CHAMPION_DETAILS_RESOURCE_ID:String = "ChampionDetails";
      
      private static const BASE_URL:String = "app:/mod/chp/";
      
      private static const BASE_LOCALE_URL:String = "app:/assets/locale/ChampionDetails/";
      
      private static const SKIN_CRITERIA_INFO_LIST:String = "skinInfo";
      
      private static const SKIN_CRITERIA_OBTAINABLE:String = "skinObtainable";
      
      private const skinCriteria:String = "skinObtainable";
      
      private var services:CDPServices = new CDPServices();
      
      private var assetsUrlRequest:URLRequest;
      
      private var sequence:SequenceAction;
      
      private var _config:CDPConfig = new CDPConfig();
      
      private var defaultToolTipHandler:TweenedToolTipHandler;
      
      private var configAction:XmlLoaderAction;
      
      private var loadModuleResourceBundleAction:LoadModuleResourceBundleAction;
      
      private var servicesAreInitialized:Boolean = false;
      
      private var _catalogResult:CatalogResult;
      
      private var _catalogResultChanged:Signal = new Signal();
      
      private var _closeRequested:Signal = new Signal();
      
      private var intentToPurchase:Boolean;
      
      private var resourceManager:IResourceManager;
      
      public var championDetails:ChampionDetails;
      
      public function Main()
      {
         var _loc1_:uint = uint(getTimer());
         super(null,new MovieClip());
         setOpaqueBackground(true);
         setScrollRect(new Rectangle(0,0,ScreenSize.WIDTH,ScreenSize.HEIGHT));
         logger.info("CDP construction time: " + (getTimer() - _loc1_) + "ms");
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.resourceManager = ResourceManager.getInstance();
         this.defaultToolTipHandler = new TweenedToolTipHandler();
         var _loc1_:ToolTipManager = new ToolTipManager(this,this.defaultToolTipHandler);
         registerDependency(IToolTipManager,_loc1_);
         registerDependency(IResourceManager,this.resourceManager);
      }
      
      override protected function setIsOnStage(param1:Boolean) : void
      {
         if(_isOnStage == param1)
         {
            return;
         }
         super.setIsOnStage(param1);
         if(param1)
         {
            getStage().stageFocusRect = false;
            getStage().focus = getInteractiveAsset();
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         logger.info("Player version: " + Capabilities.version);
         OverwriteManager.init(OverwriteManager.PREEXISTING);
         this.sequence = new SequenceAction();
         this.configAction = new XmlLoaderAction(new URLRequest(BASE_URL + "assets/championDetailsConfig.xml"));
         this.configAction.getCompleted().addOnce(this.configCompletedHandler);
         this.sequence.then(this.configAction);
         this.sequence.thenCall(this.initializeServices,null,true);
         this.sequence.getCompleted().addOnce(this.startupComplete);
         this.sequence.invoke();
         var _loc1_:ServiceProxy = ServiceProxy.instance;
         var _loc2_:MessageQueue = new MessageQueue("nonGame",this.onNonGameMessageReceived);
         _loc1_.messageRouterService.addClientNotificationMessageListener(_loc2_.onMessageReceived);
      }
      
      private function onNonGameMessageReceived(param1:MessageEvent) : void
      {
         var _loc2_:IClientNotification = param1.message.body as IClientNotification;
         if(!_loc2_)
         {
            return;
         }
         switch(_loc2_.notificationType)
         {
            case ClientNotificationType.FULFILLMENT:
               this.handleStoreFulfillmentNotification(_loc2_ as StoreFulfillmentNotification);
         }
      }
      
      private function handleStoreFulfillmentNotification(param1:StoreFulfillmentNotification) : void
      {
         var _loc2_:Catalog = null;
         var _loc3_:Vector.<Catalog> = null;
         var _loc4_:Catalog = null;
         var _loc5_:Catalog = null;
         var _loc6_:Boolean = false;
         var _loc7_:Champion = null;
         var _loc8_:ChampionSkin = null;
         logger.info("Handling Fulfillment in CDP");
         if(this._catalogResult)
         {
            switch(param1.inventoryType)
            {
               case "CHAMPION":
                  logger.info("Handling Champion Fulfillment");
                  _loc2_ = this._catalogResult.getCatalogByItemId("champions_" + param1.data.championId);
                  _loc2_.item.isOwned = param1.data.owned;
                  _loc3_ = this._catalogResult.getSkinsForChampion(_loc2_);
                  for each(_loc5_ in _loc3_)
                  {
                     _loc5_.item.championOwned = param1.data.owned;
                  }
                  this.championDetails.refreshCatalogDisplay();
                  break;
               case "CHAMPION_SKIN":
                  logger.info("Handling Champion Skin Fulfillment");
                  _loc4_ = this._catalogResult.getCatalogByItemId("championsskin_" + param1.data.skinId);
                  _loc4_.item.isOwned = param1.data.owned;
            }
            this._catalogResultChanged.dispatch(this._catalogResult);
         }
         if(this.intentToPurchase)
         {
            _loc6_ = false;
            if(param1.inventoryType == InventoryType.CHAMPION)
            {
               _loc7_ = param1.data as Champion;
               _loc6_ = this.intentToPurchase && this._config.initialSkinId <= 0 && this._config.initialChampionId == _loc7_.championId;
            }
            else if(param1.inventoryType == InventoryType.CHAMPION_SKIN)
            {
               _loc8_ = param1.data as ChampionSkin;
               _loc6_ = this.intentToPurchase && this._config.initialSkinId == _loc8_.skinId;
            }
            if(_loc6_)
            {
               this.close();
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.championDetails = new ChampionDetails(this);
         this.championDetails.setLinkage(MainAsset.LINKAGE);
         var _loc1_:ToolTip = new ToolTip(this);
         _loc1_.setLinkage(ToolTipAsset.LINKAGE);
         this.defaultToolTipHandler.setView(_loc1_);
      }
      
      private function configCompletedHandler() : void
      {
         this._config.parseXml(this.configAction.xml);
         logger.info("XML config loaded: " + this._config);
      }
      
      private function initializeServices() : void
      {
         if(this.servicesAreInitialized)
         {
            return;
         }
         this.servicesAreInitialized = true;
         if(this._config.useMockServices)
         {
            logger.info("Initializing CDP mock services");
            this.services.storeCatalogDao = new MockStoreCatalogDao(BASE_URL + "mockData/",this);
         }
         else
         {
            logger.info("Initializing CDP services");
            this.services.storeCatalogDao = new StoreCatalogDao();
         }
         if(Capabilities.playerType == "Desktop")
         {
            this.services.gameItemDao = new GameItemDao(ClientConfig.instance.locale,this);
            this.services.championDetailsDao = new ChampionDetailsDao(ClientConfig.instance.locale,this);
         }
         else
         {
            this.services.gameItemDao = new MockGameItemDao();
            this.services.championDetailsDao = new MockChampionDetailsDao();
         }
         this.services.storeCatalogDao.getCatalogForUser(this.getCatalogSuccessHandler,this.getCatalogFailHandler);
         this.refreshCurrentChampion();
      }
      
      private function refreshCurrentChampion() : void
      {
         if(this.championDetails != null)
         {
            try
            {
               this.championDetails.setChampionInfo(null);
               this.championDetails.errorDialog.close();
            }
            catch(error:Error)
            {
            }
         }
         if(this.servicesAreInitialized && Boolean(this._config.initialChampionId))
         {
            this.services.championDetailsDao.getChampionInfoById(this._config.initialChampionId,this.getChampionSuccessHandler,this.getChampionErredHandler);
         }
      }
      
      private function getChampionErredHandler(param1:Error) : void
      {
         logger.error(ErrorUtil.makeErrorMessage(param1,"Could not load champion, " + param1.message));
         var _loc2_:AlertAction = new AlertAction(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"getChampionInfoErrorTitle"),this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"getChampionInfoError"));
         _loc2_.add();
      }
      
      private function getChampionSuccessHandler(param1:ChampionInfo) : void
      {
         var _loc4_:AlertAction = null;
         var _loc5_:String = null;
         var _loc6_:ChampionSearchTag = null;
         if(param1 == null)
         {
            logger.error("0001 The champion with the specified id could not be found.");
            _loc4_ = new AlertAction(this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"getChampionInfoErrorTitle"),this.resourceManager.getString(CHAMPION_DETAILS_RESOURCE_ID,"getChampionInfoError"));
            _loc4_.add();
            this.close();
            return;
         }
         var _loc2_:Object = GeneratedContentLoader.instance.championDataDictionary[param1.id];
         var _loc3_:Vector.<ChampionSearchTag> = new Vector.<ChampionSearchTag>();
         if(_loc2_.hasOwnProperty("searchTagsSecondary"))
         {
            for each(_loc5_ in _loc2_.searchTagsSecondary)
            {
               _loc6_ = new ChampionSearchTag();
               _loc6_.name = _loc5_;
               _loc6_.displayName = ResourceManager.getInstance().getString("champion_search_tag_resources","champion_search_tag_" + _loc5_);
               _loc3_.push(_loc6_);
            }
         }
         param1.secondaryTags = _loc3_;
         logger.info("Get champion action completed");
         addChild(this.championDetails);
         this.championDetails.setChampionInfo(param1);
      }
      
      private function startupComplete() : void
      {
         logger.info("Startup complete.");
      }
      
      private function getCatalogSuccessHandler(param1:CatalogResult) : void
      {
         logger.info("Catalogue item received.");
         this._catalogResult = param1;
         this._catalogResultChanged.dispatch(this._catalogResult);
      }
      
      private function getCatalogFailHandler(param1:Error) : void
      {
         logger.error("0002 get catalog failed: " + param1);
         this._catalogResultChanged.dispatch(null);
      }
      
      public function getCloseRequested() : ISignal
      {
         return this._closeRequested;
      }
      
      public function getConfig() : CDPConfig
      {
         return this._config;
      }
      
      public function getServices() : CDPServices
      {
         return this.services;
      }
      
      public function getCatalogResultChanged() : ISignal
      {
         return this._catalogResultChanged;
      }
      
      public function getCatalogResult() : CatalogResult
      {
         return this._catalogResult;
      }
      
      public function trackEvent(param1:String, param2:String = "", param3:int = -1) : void
      {
         var _loc4_:String = "ChampionDetail";
         var _loc5_:IReportingProvider = ReportingProviderProxy.instance;
         _loc5_.trackEvent(_loc4_,param1,param2,param3);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,ScreenSize.WIDTH,ScreenSize.HEIGHT);
      }
      
      public function close() : void
      {
         this._closeRequested.dispatch();
      }
      
      public function displayUserError(param1:String, param2:Function = null) : void
      {
         if(this.championDetails)
         {
            this.championDetails.errorDialog.showErrorMessage(param1,param2);
         }
      }
      
      public function show(param1:Champion, param2:int, param3:String, param4:Boolean = false) : void
      {
         var _loc5_:ChampionSkin = null;
         var _loc6_:Object = null;
         this.intentToPurchase = param4;
         if(this.assetsUrlRequest == null)
         {
            this.assetsUrlRequest = new URLRequest(BASE_URL + "assets/championDetailAssets.swf");
         }
         loadAssets(this.assetsUrlRequest);
         this._config.initialChampionId = param1.championId;
         this._config.initialSkinId = param2;
         this._config.entryPoint = param3;
         this._config.validSkins = new Vector.<int>();
         if(this.skinCriteria == SKIN_CRITERIA_OBTAINABLE)
         {
            for each(_loc5_ in param1.championSkins)
            {
               if(_loc5_.stillObtainable)
               {
                  this._config.validSkins.push(_loc5_.skinId);
               }
            }
         }
         else if(this.skinCriteria == SKIN_CRITERIA_INFO_LIST)
         {
            for each(_loc6_ in param1.skinInfo)
            {
               this._config.validSkins.push(_loc6_.skinId);
            }
         }
         this.refreshCurrentChampion();
         this.trackEvent("EnterFrom_" + this._config.entryPoint,"Champion_" + this._config.initialChampionId + "_Skin_" + this._config.initialSkinId);
      }
      
      public function hide() : void
      {
         this.championDetails.errorDialog.close();
         this.championDetails.setChampionInfo(null);
         unloadAssets(this.assetsUrlRequest);
      }
   }
}

