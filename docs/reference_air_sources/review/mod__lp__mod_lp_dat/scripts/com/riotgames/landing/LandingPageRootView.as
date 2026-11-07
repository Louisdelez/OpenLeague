package com.riotgames.landing
{
   import blix.assets.proxy.LandingPageAsset;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.keyboard.addKeyListener;
   import com.greensock.OverwriteManager;
   import com.riotgames.landing.dao.FeaturedGameDao;
   import com.riotgames.landing.dao.ILandingPageDao;
   import com.riotgames.landing.dao.LandingPageDao;
   import com.riotgames.landing.featuredgames.FeaturedGamesModel;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.net.URLRequest;
   import flash.system.Security;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LandingPageRootView extends RiotModuleView implements IMainScreen, ILandingPageContext
   {
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _landingPageAssetsUrlRequest:URLRequest;
      
      private var _newPlayerLandingPageAssetsUrlRequest:URLRequest;
      
      private var _config:LandingPageConfig = new LandingPageConfig();
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _navSignals:LandingPageNavSignals;
      
      public var landingPage:LandingPage;
      
      private var landingPageDao:ILandingPageDao;
      
      private var featuredGameDao:FeaturedGameDao;
      
      private var featuredGamesCheckTimeoutId:uint;
      
      public function LandingPageRootView(param1:IContext, param2:RiotModuleInfo, param3:LandingPageNavSignals, param4:LandingPageConfig)
      {
         super(param1,new MovieClip());
         this._moduleInfo = param2;
         this._navSignals = param3;
         this._config = param4;
         addKeyListener(this,this.keyDownHandler);
         ShellDispatcher.instance.addEventListener(ShellEvent.MINIMIZE_TO_TRAY,this.handleMinimizeEvent);
         ShellDispatcher.instance.addEventListener(ShellEvent.RESTORE,this.handleMaximizeEvent);
         OverwriteManager.init(OverwriteManager.PREEXISTING);
         this.landingPageDao = new LandingPageDao(this._config.aggregatorUrl,this._config.realm,ClientConfig.instance.locale,this._config.imageRoot,this);
         this.featuredGameDao = new FeaturedGameDao(this._config,this);
         reloadAssets();
         this.reloadData();
         _logger.logInfo("Webhost: " + this._config.aggregatorUrl);
         _logger.logInfo("Sandbox type: " + Security.sandboxType);
         _logger.logInfo("Realm: " + this._config.realm);
         _logger.logInfo("BaseUrl: " + this._config.baseUrl);
         _logger.logInfo("ObserverModeEnabled: " + this._config.observerModeEnabled);
         _logger.logInfo("FeaturedGamesVersion: v0.1");
      }
      
      private function handleMaximizeEvent(param1:ShellEvent) : void
      {
         this.checkForNewFeaturedGameData();
      }
      
      private function handleMinimizeEvent(param1:ShellEvent) : void
      {
         this.stopFeaturedGameTimers();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.landingPage = new LandingPage(this);
         this.landingPage.setLinkage(LandingPageAsset.LINKAGE);
         addChild(this.landingPage);
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.F5)
         {
            this.reloadData();
         }
      }
      
      private function landingPageDataErrorHandler(param1:Error) : void
      {
         _logger.logError("Data error " + param1.getStackTrace());
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         this.landingPage.errorPanel.showError(_loc2_.getString("LandingPage","error.title"),_loc2_.getString("LandingPage","error.loadingError"));
      }
      
      private function landingPageDataCompleteHandler(param1:LandingPageModel) : void
      {
         _logger.logInfo("landing page data complete");
         this.landingPage.setModel(param1);
         this.ready();
      }
      
      public function reloadData() : void
      {
         this.landingPageDao.loadLandingPageData(this.landingPageDataCompleteHandler,this.landingPageDataErrorHandler);
         setTimeout(this.checkForNewFeaturedGameData,500);
      }
      
      private function featuredGameDataErrorHandler(param1:Error) : void
      {
         _logger.logError("Data error " + param1.getStackTrace());
         this.landingPage.featuredGamesScroller.setVisible(false);
         this.startFeaturedGameTimer(60 * 1000);
      }
      
      private function featuredGameDataCompleteHandler(param1:FeaturedGamesModel) : void
      {
         _logger.logInfo("featured games data complete: " + param1);
         if(param1 != null)
         {
            this.startFeaturedGameTimer(param1.clientRefreshInterval);
         }
         else
         {
            this.stopFeaturedGameTimers();
         }
         this.landingPage.featuredGamesScroller.setModel(param1);
      }
      
      private function startFeaturedGameTimer(param1:int) : void
      {
         this.stopFeaturedGameTimers();
         this.featuredGamesCheckTimeoutId = setTimeout(this.checkForNewFeaturedGameData,param1);
      }
      
      private function checkForNewFeaturedGameData() : void
      {
         this.stopFeaturedGameTimers();
         this.featuredGameDao.loadFeaturedGamesData(this.featuredGameDataCompleteHandler,this.featuredGameDataErrorHandler);
      }
      
      private function stopFeaturedGameTimers() : void
      {
         if(this.featuredGamesCheckTimeoutId)
         {
            clearTimeout(this.featuredGamesCheckTimeoutId);
            this.featuredGamesCheckTimeoutId = 0;
         }
      }
      
      public function show() : void
      {
         this._landingPageAssetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"landingPageAssets.swf");
         loadAssets(this._landingPageAssetsUrlRequest);
         this._newPlayerLandingPageAssetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"newPlayerLandingPageAssets.swf");
         loadAssets(this._newPlayerLandingPageAssetsUrlRequest);
      }
      
      public function hide() : void
      {
         unloadAssets(this._landingPageAssetsUrlRequest);
         unloadAssets(this._newPlayerLandingPageAssetsUrlRequest);
      }
      
      public function getIsThinChrome() : Boolean
      {
         return false;
      }
      
      public function getHasNavigation() : Boolean
      {
         return false;
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function getConfig() : LandingPageConfig
      {
         return this._config;
      }
      
      public function navigateViaJson(param1:String) : void
      {
         this._navSignals.jsonNavigate.dispatch(param1);
      }
      
      public function spectateFeaturedGame(param1:FeaturedGame) : void
      {
         this._navSignals.spectateFeaturedGame.dispatch(param1);
      }
      
      public function ready() : void
      {
         this._navSignals.ready.dispatch();
      }
   }
}

