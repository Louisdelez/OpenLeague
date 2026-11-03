package com.riotgames.pvpnet.chrome
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.chrome.model.ChromeModel;
   import com.riotgames.pvpnet.chrome.views.ChromeFrameView;
   import com.riotgames.pvpnet.chrome.views.ChromeWindowControlsView;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.net.URLRequest;
   
   public class ChromeFactory extends RiotModuleView implements IChromeProvider
   {
      
      private var _model:ChromeModel = new ChromeModel();
      
      private var _controller:ChromeController;
      
      private var _contextAlertController:ChromeContextAlertController = new ChromeContextAlertController(this._model);
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _chromeView:ChromeFrameView;
      
      private var _windowControls:ChromeWindowControlsView;
      
      public function ChromeFactory(param1:IContext, param2:RiotModuleInfo, param3:IWindowControlsProvider)
      {
         this._moduleInfo = param2;
         this._controller = new ChromeController(this._model,param3,this._contextAlertController);
         super(param1);
         setLinkagePostfix("_" + ClientConfig.instance.locale);
         var _loc4_:ToolTipConfig = new ToolTipConfig();
         _loc4_.showDelay = 0;
         var _loc5_:IToolTipManager = TipsProviderProxy.instance.createWindowToolTipManager(this,_loc4_);
         registerDependency(IToolTipManager,_loc5_);
         registerDependency(ChromeModel,this._model);
         registerDependency(ChromeController,this._controller);
         registerDependency(ChromeContextAlertController,this._contextAlertController);
         var _loc6_:URLRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"ChromeAssets.swf");
         loadAssets(_loc6_);
         ProviderLookup.getProvider(ILobbyViewController,this.onGotLobbyViewController);
      }
      
      public function addFrame(param1:DisplayAdapter) : void
      {
         if(!this._chromeView)
         {
            this._chromeView = new ChromeFrameView(this);
         }
         param1.addChild(this._chromeView);
      }
      
      public function addWindowControls(param1:DisplayAdapter) : void
      {
         if(!this._windowControls)
         {
            this._windowControls = new ChromeWindowControlsView(this);
         }
         param1.addChild(this._windowControls);
      }
      
      public function registerCloseRequestedResponder(param1:Function) : void
      {
         this._model.closeRequestedHandler = param1;
      }
      
      private function onGotLobbyViewController(param1:ILobbyViewController) : void
      {
         registerDependency(ILobbyViewController,param1);
      }
   }
}

