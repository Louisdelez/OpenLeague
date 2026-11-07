package com.riotgames.pvpnet.login
{
   import blix.action.IAction;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.resource.FlatFileResourceLoader;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.transitions.GenericTransitions;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import com.riotgames.platform.gameclient.module.login.controller.LoginMediator;
   import com.riotgames.platform.gameclient.module.login.controller.LoginQueueController;
   import com.riotgames.platform.gameclient.module.login.controller.LoginQueueMediator;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.login.chat.ChatLoginAction;
   import com.riotgames.pvpnet.login.dataload.SecondaryClientDataLoad;
   import com.riotgames.pvpnet.system.config.LoginConfig;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.tracking.trackers.login.ILoginProcessTracker;
   import com.riotgames.rust.module.RiotModuleView;
   import com.riotgames.rust.theme.ThemeConfig;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import mx.core.Application;
   
   public class LoginModule extends RiotModuleView implements IMainScreen
   {
      
      private var backgroundImageRequest:URLRequest;
      
      private var assetsUrlRequest:URLRequest;
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var loginQueueMediator:LoginQueueMediator;
      
      private var backgroundPartnerImageRequest:URLRequest;
      
      private var serverSession:ServerSessionObject;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      private var _hideCompleted:Signal = new Signal();
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var loginView:LoginView;
      
      private var _loginTracker:ILoginProcessTracker;
      
      private var backgroundSWFRequest:URLRequest;
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var loginMediator:LoginMediator;
      
      public function LoginModule(param1:IContext, param2:ProviderModuleInfo, param3:ILoginProcessTracker)
      {
         this._moduleInfo = param2;
         this._loginTracker = param3;
         super(param1,new MovieClip());
         ShellDispatcher.instance.addEventListener(ShellEvent.EXIT,this.onExit);
      }
      
      private function dataLoadErredHandler(param1:IAction) : void
      {
         logger.error(param1.getError().message);
      }
      
      public function hide() : void
      {
         var _loc1_:IAction = GenericTransitions.getFadeOut(getAsset());
         _loc1_.getCompleted().add(this.hideCompletedHandler);
         _loc1_.invoke();
      }
      
      public function show() : void
      {
         this.assetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"loginAssets.swf");
         loadAssets(this.assetsUrlRequest);
         this.loginView.setBackgroundArt(this.backgroundImageRequest,this.backgroundPartnerImageRequest,this.backgroundSWFRequest);
         this.loginView.prepareForLogin();
      }
      
      private function onServerSessionAvailable(param1:ServerSessionObject) : void
      {
         var _loc2_:SecondaryClientDataLoad = null;
         this.serverSession = param1;
         if(Application.application != null)
         {
            this.onChatLoginComplete();
         }
         else if(Session.instance.accountSummary != null)
         {
            _loc2_ = new SecondaryClientDataLoad();
            _loc2_.getCompleted().add(this.onLoginOperationsComplete);
            _loc2_.getErred().add(this.dataLoadErredHandler);
            _loc2_.invoke();
         }
         else
         {
            this.onLoginOperationsComplete();
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         var _loc1_:FlatFileResourceLoader = new FlatFileResourceLoader();
         _loc1_.init("Login2",this._moduleInfo.getPath() + "locale/login/{0}/Login2.properties","");
         this.backgroundImageRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"cs_bg_champions.png");
         this.backgroundPartnerImageRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"LOL_qqlogin.png");
         this.backgroundSWFRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"login.swf");
         this.soundManager.registerAudioDefinitionFile(this._moduleInfo.getPath() + "audio/LoginAudioEventDefinitions.xml");
      }
      
      public function getIsThinChrome() : Boolean
      {
         return ThemeConfig.instance.getDoesThemeHavePrecedence("parchment","iron");
      }
      
      private function onChatLoginComplete() : void
      {
         LoginConfig.instance.setLoginConfigurationComplete();
         LoginConfig.instance.hasReconnected = this.loginMediator.getUserHasReconnectedToGame();
         this.loginMediator.cleanup();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.loginView = new LoginView(this,this._loginTracker);
         this.loginView.themeWatchPath = ThemeConfig.instance.getThemeWatchPath(this._moduleInfo.getPath(),"login.swf");
         addChild(this.loginView);
         this.loginMediator = new LoginMediator(this.loginView,new LoginQueueController(this._loginTracker),this.onServerSessionAvailable,this._loginTracker);
         this.loginQueueMediator = new LoginQueueMediator(this.loginView.getLoginStatusPane());
         this.loginMediator.loginQueueMediator = this.loginQueueMediator;
      }
      
      private function onExit(param1:ShellEvent) : void
      {
         if(this._loginTracker)
         {
            this._loginTracker.cancelledQueue();
         }
      }
      
      public function getHasNavigation() : Boolean
      {
         return false;
      }
      
      private function hideCompletedHandler() : void
      {
         unloadAssets(this.assetsUrlRequest);
         this._hideCompleted.dispatch(this);
         this.loginView.destroy();
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      private function onLoginOperationsComplete() : void
      {
         var _loc1_:ChatLoginAction = new ChatLoginAction();
         _loc1_.getCompleted().add(this.onChatLoginComplete);
         _loc1_.invoke();
         ShellDispatcher.instance.removeEventListener(ShellEvent.EXIT,this.onExit);
      }
   }
}

