package com.riotgames.pvpnet.championinventory.views
{
   import blix.action.SequenceAction;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ChampionDetailProviderProxy;
   import com.riotgames.platform.common.provider.IChampionDetailProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.championinventory.model.ChampionInventoryViewModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import mx.resources.ResourceManager;
   
   public class ChampionInventoryRootView extends RiotModuleView implements IMainScreen
   {
      
      private var _hideCompletedSignal:Signal = new Signal();
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var inventoryProvider:IInventoryProvider;
      
      private var startupSequence:SequenceAction;
      
      public function ChampionInventoryRootView(param1:IContext, param2:ProviderModuleInfo)
      {
         this._moduleInfo = param2;
         super(param1,new MovieClip());
         var _loc3_:String = ClientConfig.instance.locale;
         if(_loc3_ == "zh_CN" || _loc3_ == "zh_MY" || _loc3_ == "zh_TW")
         {
            setLinkagePostfix("_chinese");
         }
         setLinkage("ChampionInventory");
         this.startupSequence = new SequenceAction();
         this.startupSequence.andCall(this.fetchInventory);
         this.startupSequence.andCall(this.registerDependencies);
         this.startupSequence.getCompleted().addOnce(this.onStartupSequenceComplete);
         this.startupSequence.invoke();
      }
      
      private function onStartupSequenceComplete() : void
      {
         var _loc1_:ChampionInventoryView = new ChampionInventoryView(this);
         addChild(_loc1_);
      }
      
      private function fetchInventory() : void
      {
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProviderLookup);
      }
      
      private function onInventoryProviderLookup(param1:IInventoryProvider) : void
      {
         this.inventoryProvider = param1;
         this.inventoryProvider.getInventoryInitialized().add(this.onInventoryReady);
      }
      
      private function onInventoryReady() : void
      {
         this.inventoryProvider.getInventoryInitialized().remove(this.onInventoryReady);
         this.startupSequence.completeFunction(this.fetchInventory);
      }
      
      private function registerDependencies() : void
      {
         var _loc1_:IInventory = this.inventoryProvider.getInventory();
         registerDependency(IInventory,_loc1_);
         var _loc2_:ListView = new ListView(new ListX(_loc1_.champions));
         var _loc3_:Array = this.inventoryProvider.getInventoryController().createSearchTags();
         var _loc4_:ChampionInventoryViewModel = new ChampionInventoryViewModel(ResourceManager.getInstance(),_loc2_,new ListView(new ListX(_loc3_)),this.inventoryProvider.getInventoryController().hasAnyRentalItems());
         registerDependency(ChampionInventoryViewModel,_loc4_);
         var _loc5_:IChampionFilter = this.inventoryProvider.getInventoryController().createChampionFilter(_loc3_);
         _loc5_.getChanged().add(_loc2_.reset);
         _loc2_.filter(_loc5_.filter);
         _loc2_.sortWithCompare(_loc5_.sortByDisplayName);
         registerDependency(IChampionFilter,_loc5_);
         var _loc6_:IChampionDetailProvider = ChampionDetailProviderProxy.instance;
         registerDependency(IChampionDetailProvider,_loc6_);
         this.startupSequence.completeFunction(this.registerDependencies);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         var _loc1_:ToolTipConfig = new ToolTipConfig();
         _loc1_.mouseSize = new Point(10,10);
         _loc1_.gap = new Point(0,0);
         _loc1_.showDelay = 0;
         _loc1_.hideDelay = 0;
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this,_loc1_));
      }
      
      public function getIsThinChrome() : Boolean
      {
         return false;
      }
      
      public function getHasNavigation() : Boolean
      {
         return true;
      }
      
      public function show() : void
      {
         this._assetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"championInventoryAssets.swf");
         loadAssets(this._assetsUrlRequest);
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompletedSignal;
      }
      
      public function hide() : void
      {
         unloadAssets(this._assetsUrlRequest);
         this._hideCompletedSignal.dispatch(this);
      }
   }
}

