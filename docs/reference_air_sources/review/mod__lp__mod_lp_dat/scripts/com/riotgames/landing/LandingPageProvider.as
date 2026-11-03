package com.riotgames.landing
{
   import blix.action.IAction;
   import blix.assets.proxy.DisplayAdapter;
   import blix.signals.ISignal;
   import com.riotgames.platform.common.provider.MainScreenProviderProxy;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class LandingPageProvider extends Sprite implements IProviderModule, ILobbyLandingPage
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _rootView:IMainScreen;
      
      private var _config:LandingPageConfig;
      
      private var _navSignals:LandingPageNavSignals = new LandingPageNavSignals();
      
      public function LandingPageProvider()
      {
         super();
      }
      
      public function getLandingPageScreen() : IMainScreen
      {
         var _loc1_:LandingPageRootView = null;
         if(this._rootView == null)
         {
            _loc1_ = new LandingPageRootView(null,this._moduleInfo,this._navSignals,this._config);
            this._rootView = _loc1_;
         }
         return this._rootView;
      }
      
      private function loadLocalization() : void
      {
         var _loc1_:String = ClientConfig.instance.locale;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,"LandingPage","LandingPage","lp",ClientConfig.instance.debugLocale);
         _loc3_.getCompleted().add(this.localizationLoaded);
         _loc3_.invoke();
      }
      
      private function localizationLoaded() : void
      {
         ProviderLookup.publishProvider(ILobbyLandingPage,this);
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         MainScreenProviderProxy.instance.registerMainScreenFactory(param1.getExtraDataValue("mainScreen"),this.getLandingPageScreen);
         this.loadLocalization();
      }
      
      public function getReady() : ISignal
      {
         return this._navSignals.ready;
      }
      
      public function getJsonNavigate() : ISignal
      {
         return this._navSignals.jsonNavigate;
      }
      
      public function getSpectateFeaturedGame() : ISignal
      {
         return this._navSignals.spectateFeaturedGame;
      }
      
      public function configureLandingPage(param1:Object) : void
      {
         this._config = new LandingPageConfig();
         this._config.baseUrl = "mod/lp/";
         if(param1.regionTag)
         {
            this._config.realm = param1.regionTag;
         }
         if(param1.featuredGamesURL)
         {
            this._config.featuredGamesUrl = param1.featuredGamesURL;
         }
         if(param1.championsObject)
         {
            this._config.championData = JSON.parse(param1.championsObject);
         }
         if(param1.observerModeEnabled)
         {
            this._config.observerModeEnabled = param1.observerModeEnabled;
         }
      }
      
      public function showLandingPage(param1:DisplayAdapter) : void
      {
         if(this._config == null)
         {
            throw new IllegalOperationError("Cannot call this before configureLandingPage!");
         }
         var _loc2_:IMainScreen = this.getLandingPageScreen();
         _loc2_.show();
         param1.addChild(_loc2_);
      }
   }
}

