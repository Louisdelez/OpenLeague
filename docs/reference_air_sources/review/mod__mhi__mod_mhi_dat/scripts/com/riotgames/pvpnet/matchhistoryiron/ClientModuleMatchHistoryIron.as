package com.riotgames.pvpnet.matchhistoryiron
{
   import blix.action.IAction;
   import blix.assets.proxy.DisplayAdapter;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import com.riotgames.gameItems.dao.GameItemDao;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.matchhistoryiron.controller.MatchHistoryController;
   import com.riotgames.pvpnet.matchhistoryiron.ironviews.MatchHistoryIronView;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryModel;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryParser;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.controller.NewMatchHistoryController;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.factory.MatchHistoryActionFactory;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view.NewMatchHistoryView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.IPlatformConfigProvider;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.rust.components.sidebar.INestedScreen;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleMatchHistoryIron extends Sprite implements IProviderModule, IMatchHistoryIronProvider
   {
      
      private var MODULE_NAME:String = "MatchHistory";
      
      private const MODULE_SHORT_NAME:String = "mhi";
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _newMatchHistoryEnabled:Boolean = DynamicClientConfigManager.getConfiguration("NewMatchHistory","Enabled",false).getBoolean();
      
      private var _controller:MatchHistoryController;
      
      private var _model:MatchHistoryModel;
      
      private var _mainView:MatchHistoryIronView;
      
      private var _newController:NewMatchHistoryController;
      
      private var _newModel:NewMatchHistoryModel;
      
      private var _newView:NewMatchHistoryView;
      
      private var _activeView:INestedScreen;
      
      private var _inventoryProvider:IInventoryProvider;
      
      private var _resourcesLoaded:Boolean = false;
      
      private var _platformConfigProvider:IPlatformConfigProvider;
      
      private var _gameItemDao:GameItemDao;
      
      private var _gameItems:Dictionary = null;
      
      public function ClientModuleMatchHistoryIron()
      {
         if(ClientConfig.instance.matchHistoryTest)
         {
            this._newMatchHistoryEnabled = true;
         }
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         this._gameItemDao = new GameItemDao(ClientConfig.instance.locale,null);
         this.loadResources();
         ProviderLookup.getProvider(IInventoryProvider,this.onInventory);
         ProviderLookup.getProvider(IPlatformConfigProvider,this.onPlatformConfig);
         this._gameItemDao.getAllGameItemsDictionary(this.onGameItemsLoaded,null);
      }
      
      private function loadResources() : void
      {
         var _loc1_:String = ClientConfig.instance.locale;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,this.MODULE_NAME,this.MODULE_NAME,this.MODULE_SHORT_NAME,false);
         _loc3_.getCompleted().add(this.onResourcesLoaded);
         _loc3_.invoke();
      }
      
      private function onResourcesLoaded() : void
      {
         this._resourcesLoaded = true;
         this.joinGotDepdencies();
      }
      
      private function onGameItemsLoaded(param1:Dictionary) : void
      {
         this._gameItems = param1;
         this.joinGotDepdencies();
      }
      
      private function onInventory(param1:IInventoryProvider) : void
      {
         this._inventoryProvider = param1;
         this.joinGotDepdencies();
      }
      
      private function onPlatformConfig(param1:IPlatformConfigProvider) : void
      {
         this._platformConfigProvider = param1;
         this.joinGotDepdencies();
      }
      
      private function joinGotDepdencies() : void
      {
         if(Boolean(this._inventoryProvider && this._resourcesLoaded) && Boolean(this._gameItems) && Boolean(this._platformConfigProvider))
         {
            ProviderLookup.publishProvider(IMatchHistoryIronProvider,this);
         }
      }
      
      private function createMatchHistoryScreen() : INestedScreen
      {
         if(this._activeView == null)
         {
            if(this._newMatchHistoryEnabled)
            {
               this._activeView = this.createNewMatchHistory();
            }
            else
            {
               this._activeView = this.createOldMatchHistory();
            }
         }
         return this._activeView;
      }
      
      private function createOldMatchHistory() : INestedScreen
      {
         this._controller = new MatchHistoryController(this._inventoryProvider);
         this._model = new MatchHistoryModel();
         this._controller.setModel(this._model);
         return new MatchHistoryIronView(null,this._moduleInfo,this._model);
      }
      
      private function createNewMatchHistory() : INestedScreen
      {
         var _loc2_:GameQueueConfig = null;
         var _loc3_:Session = null;
         var _loc4_:IDecode = null;
         var _loc5_:MatchHistoryParser = null;
         var _loc6_:MatchHistoryActionFactory = null;
         var _loc1_:Dictionary = new Dictionary();
         for each(_loc2_ in this._platformConfigProvider.getPlatformConfig().allGameQueues)
         {
            _loc1_[_loc2_.id] = _loc2_;
         }
         this._newModel = new NewMatchHistoryModel();
         _loc3_ = Session.instance;
         _loc4_ = new JSONDecoder();
         _loc5_ = new MatchHistoryParser(_loc4_,this._inventoryProvider,this._gameItems,_loc1_);
         _loc6_ = new MatchHistoryActionFactory(this._newModel,_loc3_,_loc5_);
         this._newController = new NewMatchHistoryController(this._newModel,_loc6_);
         return new NewMatchHistoryView(null,this._moduleInfo,this._newModel,this._newController);
      }
      
      public function show(param1:Number, param2:DisplayAdapter) : void
      {
         var _loc3_:DisplayObjectContainerProxy = this.createMatchHistoryScreen() as DisplayObjectContainerProxy;
         if(!this._newMatchHistoryEnabled)
         {
            this._controller.getRecentGames(param1);
         }
         else
         {
            this._newController.showMatchHistoryForPlayer(param1);
         }
         this._activeView.show();
         param2.addChild(_loc3_);
      }
      
      public function hide() : void
      {
         this._activeView.hide();
      }
   }
}

