package com.riotgames.pvpnet.runes.views
{
   import blix.action.SequenceAction;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTip;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.ToolTipManager;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.factory.ClassFactory;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.navigation.INavigable;
   import com.riotgames.pvpnet.runes.controller.RecordBookMetricsAction;
   import com.riotgames.pvpnet.runes.controller.RuneConfigurationController;
   import com.riotgames.pvpnet.runes.controller.RuneCounter;
   import com.riotgames.pvpnet.runes.util.RuneImageCache;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneCombinerViewController;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneFilter;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneViewModel;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class RunesRootView extends RiotModuleView implements IMainScreen, INavigable
   {
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _runePageAssetsUrlRequest:URLRequest;
      
      private var _runeCombinerAssetsUrlRequest:URLRequest;
      
      private var startupSequence:SequenceAction;
      
      private var runeBookController:IRuneBookController;
      
      private var runesViewController:RunesViewController;
      
      private var runeConfigController:RuneConfigurationController;
      
      private var runesTracker:IRunesTracker;
      
      private var inventoryProvider:IInventoryProvider;
      
      private var runeCombinerViewController:RuneCombinerViewController;
      
      public function RunesRootView(param1:IContext, param2:RiotModuleInfo)
      {
         super(param1,new MovieClip());
         this._moduleInfo = param2;
         this.startupSequence = new SequenceAction();
         this.startupSequence.andCall(this.fetchMetricsProvider);
         this.startupSequence.andCall(this.fetchInventory);
         this.startupSequence.andCall(this.fetchRuneBookController);
         this.startupSequence.andCall(this.registerDependencies);
         this.startupSequence.getCompleted().addOnce(this.initializationCompleteHandler);
         this.startupSequence.invoke();
      }
      
      private function registerDependencies() : void
      {
         registerDependency(IRuneBookController,this.runeBookController);
         var _loc1_:IInventory = this.inventoryProvider.getInventory();
         registerDependency(IInventory,_loc1_);
         var _loc2_:ListView = new ListView(new ListX());
         var _loc3_:RuneCounter = new RuneCounter(null,null,this.runeBookController,_loc2_,ClientConfig.instance.runeUniquePerSpellBook);
         registerDependency(RuneCounter,_loc3_);
         var _loc4_:RuneFilter = new RuneFilter();
         registerDependency(RuneFilter,_loc4_);
         var _loc5_:RuneViewModel = new RuneViewModel(null,_loc2_,_loc4_);
         registerDependency(RuneViewModel,_loc5_);
         var _loc6_:ISoundProvider = SoundProviderProxy.instance;
         registerDependency(ISoundProvider,_loc6_);
         this.runeConfigController = new RuneConfigurationController(this.runesTracker);
         this.runeConfigController.lookupUXConfiguration();
         registerDependency(RuneConfigurationController,this.runeConfigController);
         var _loc7_:ClassFactory = new ClassFactory(RecordBookMetricsAction,[this.runesTracker]);
         this.runesViewController = new RunesViewController(this.runeBookController,_loc1_,_loc2_,_loc5_,_loc4_,_loc3_,Session.instance.summoner,_loc7_);
         registerDependency(RunesViewController,this.runesViewController);
         this.runeCombinerViewController = new RuneCombinerViewController(this.runeBookController,_loc4_,_loc2_);
         registerDependency(RuneCombinerViewController,this.runeCombinerViewController);
         var _loc8_:RunesTransportationController = new RunesTransportationController(this.runeBookController,this.runesViewController,this.runeCombinerViewController,_loc3_,_loc6_);
         registerDependency(RunesTransportationController,_loc8_);
         registerDependency(IRunesTracker,this.runesTracker);
         this.startupSequence.completeFunction(this.registerDependencies);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         var _loc1_:ToolTip = new ToolTip(this);
         _loc1_.setLinkage("ToolTipAsset");
         var _loc2_:ToolTipHandler = new ToolTipHandler(_loc1_);
         _loc2_.showDelay = 0;
         var _loc3_:ToolTipManager = new ToolTipManager(this,_loc2_);
         registerDependency(IToolTipManager,_loc3_);
      }
      
      private function fetchMetricsProvider() : void
      {
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onCrossModuleProviderLookup);
      }
      
      private function onCrossModuleProviderLookup(param1:ICrossModuleTrackerProvider) : void
      {
         this.runesTracker = param1.getRunesTracker();
         this.startupSequence.completeFunction(this.fetchMetricsProvider);
      }
      
      private function fetchInventory() : void
      {
         ProviderLookup.getProvider(IInventoryProvider,this.getInventorySuccessHandler);
      }
      
      private function getInventorySuccessHandler(param1:IInventoryProvider) : void
      {
         this.inventoryProvider = param1;
         var _loc2_:RuneImageCache = new RuneImageCache();
         _loc2_.setRuneDictionary(param1.getInventory().runeDictionary);
         registerDependency(RuneImageCache,_loc2_);
         this.startupSequence.completeFunction(this.fetchInventory);
      }
      
      private function fetchRuneBookController() : void
      {
         ProviderLookup.getProvider(IRuneBookController,this.onRuneBookControllerRetrieved);
      }
      
      private function onRuneBookControllerRetrieved(param1:IRuneBookController) : void
      {
         this.runeBookController = param1;
         this.startupSequence.completeFunction(this.fetchRuneBookController);
      }
      
      private function initializationCompleteHandler() : void
      {
         var _loc1_:RunesView = new RunesView(this);
         addChild(_loc1_);
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
         this.runesTracker.startRunes_PageVisit();
         this._assetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"runesAssets.swf");
         loadAssets(this._assetsUrlRequest);
         this._runePageAssetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"runePageAssets.swf");
         loadAssets(this._runePageAssetsUrlRequest);
         this._runeCombinerAssetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"runeCombinerAssets.swf");
         loadAssets(this._runeCombinerAssetsUrlRequest);
         if(Boolean(this.runeBookController) && Boolean(this.runeBookController.runeBook))
         {
            this.runesViewController.setCurrentRuneBookPage(this.runeBookController.runeBook.defaultPage);
            this.runesViewController.setViewIsHidden(false);
         }
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function hide() : void
      {
         if(this.runeCombinerViewController.getRuneCombinerViewActive())
         {
            this.runeCombinerViewController.setRuneCombinerViewActive(false);
         }
         if(this.runesViewController.getHasUnsavedChanges())
         {
            this.displayUnsavedChangesAlert();
         }
         this.runesViewController.setViewIsHidden(true);
         this.runesTracker.stopRunes_PageVisit();
         this._hideCompleted.dispatch();
         unloadAssets(this._assetsUrlRequest);
         unloadAssets(this._runePageAssetsUrlRequest);
         unloadAssets(this._runeCombinerAssetsUrlRequest);
      }
      
      private function displayUnsavedChangesAlert() : void
      {
         var _loc1_:AlertAction = new AlertAction(RiotResourceLoader.getString("runebook_book_unsavedChangesPromptTitle","Save Runes?"),RiotResourceLoader.getString("runebook_book_unsavedChangesPrompt","Save Runes?"));
         _loc1_.showNegative = true;
         _loc1_.setYesNoLabels();
         _loc1_.getCompleted().addOnce(this.onDisplayUnsavedChangesAlertClosed);
         _loc1_.add();
      }
      
      private function onDisplayUnsavedChangesAlertClosed(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this.runesViewController.save();
         }
         else
         {
            this.runesViewController.revert();
         }
      }
      
      public function setAccountId(param1:Number) : void
      {
         var _loc2_:Number = Number(Session.instance.summoner.acctId);
         if(!param1)
         {
            param1 = _loc2_;
         }
         if(param1 == _loc2_)
         {
            this.runeBookController.editing = true;
            this.runeBookController.combining = false;
            this.runeBookController.summoner = Session.instance.summoner;
            this.runeBookController.summonerLevel = Session.instance.summonerLevel.summonerLevel;
         }
         else
         {
            this.runeBookController.editing = false;
            this.runeBookController.combining = false;
         }
      }
      
      public function setPath(param1:String) : void
      {
      }
      
      public function setParameters(param1:URLVariables) : void
      {
         if(ClientConfig.instance.isDevSandbox)
         {
            this.setAccountId(0);
         }
         this.runeBookController.initialize();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,1054,520);
      }
   }
}

