package com.riotgames.pvpnet.endofgamegiftwindow
{
   import blix.action.IAction;
   import blix.context.IContext;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.common.utils.encode.JSONEncoder;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.endofgamegiftwindow.actions.EndOfGameGiftActionFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.controllers.EndOfGameGiftWindowController;
   import com.riotgames.pvpnet.endofgamegiftwindow.controllers.IEndOfGameGiftWindowController;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.EndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.GiftListValueObjectFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.GiftingRules;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.ISessionPlayer;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.SessionPlayerSummary;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.EndOfGameGiftService;
   import com.riotgames.pvpnet.endofgamegiftwindow.utils.AsyncSemaphore;
   import com.riotgames.pvpnet.endofgamegiftwindow.utils.AsyncSemaphoreDependency;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.EndOfGameGiftViewMediator;
   import com.riotgames.pvpnet.endofgamegiftwindow.views.IEndOfGameGiftWindow;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleEndOfGameGiftWindow extends Sprite implements IEndOfGameGiftWindow, IProviderModule, IEndOfGameGiftWindowProvider
   {
      
      public static const MODULE_RESOURCE_BUNDLE_NAME:String = "EndOfGameGiftWindow";
      
      public static const MODULE_DIRECTORY_NAME:String = "eogg";
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _blixContext:IContext;
      
      private var _moduleView:IEndOfGameGiftWindow;
      
      private var _playerInventory:IInventory;
      
      private var _dependencySemaphore:AsyncSemaphore;
      
      private var _dependencyList:Vector.<AsyncSemaphoreDependency>;
      
      private var _sessionPlayer:ISessionPlayer;
      
      private var _eoggModel:EndOfGameGiftModel;
      
      private var _viewMediator:EndOfGameGiftViewMediator;
      
      private var _eOGGWindowController:IEndOfGameGiftWindowController;
      
      private var _dtoValidator:GiftListValueObjectFactory;
      
      private var _eoggActionFactory:EndOfGameGiftActionFactory;
      
      private var _endOfGameGiftService:EndOfGameGiftService;
      
      private var _clientNotificationProvider:IClientNotificationProvider;
      
      private var _encoder:IEncode;
      
      private var _decoder:IDecode;
      
      public function ClientModuleEndOfGameGiftWindow()
      {
         super();
         this._dependencyList = new Vector.<AsyncSemaphoreDependency>();
         this._dependencyList.push(new AsyncSemaphoreDependency(this.loadLocalizedResources,[]));
         this._dependencyList.push(new AsyncSemaphoreDependency(ProviderLookup.getProvider,[IInventoryProvider,this.onInventoryProviderReceived]));
         this._dependencyList.push(new AsyncSemaphoreDependency(ProviderLookup.getProvider,[IClientNotificationProvider,this.onClientNotificationProviderReceived]));
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         this._encoder = new JSONEncoder();
         this._decoder = new JSONDecoder();
         if(Session.instance.summoner == null)
         {
            Session.instance.getSummonerLevelChanged().addOnce(this.continueModuleInitialization);
            return;
         }
         this.continueModuleInitialization();
      }
      
      public function getIsThinChrome() : Boolean
      {
         return false;
      }
      
      public function getHasNavigation() : Boolean
      {
         return false;
      }
      
      public function show() : void
      {
      }
      
      public function getHideCompleted() : ISignal
      {
         return null;
      }
      
      public function hide() : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this._blixContext = null;
         this._moduleInfo = null;
         this._encoder = null;
         this._decoder = null;
      }
      
      public function initializeEndOfGameGiftWindow(param1:IContext) : void
      {
         this._blixContext = param1;
         var _loc2_:IBaseLcdsService = this._blixContext.getDependency(IBaseLcdsService);
         this._endOfGameGiftService = new EndOfGameGiftService(_loc2_,this._decoder);
      }
      
      public function showEndOfGameGiftWindow() : void
      {
         this._eOGGWindowController.showEndOfGameGiftWindow();
      }
      
      public function hideEndOfGameGiftWindow() : void
      {
         this._eOGGWindowController.hideEndOfGameGiftWindow();
      }
      
      public function setGiftRecipient(param1:IPlayerSummary) : void
      {
         this._eOGGWindowController.setGiftRecipient(param1);
      }
      
      public function canEnableGiftButton(param1:IPlayerSummary) : Boolean
      {
         return this._eOGGWindowController.canEnableGiftButton(param1);
      }
      
      public function canShowGiftButton(param1:IPlayerSummary) : Boolean
      {
         return this._eOGGWindowController.canShowGiftButton(param1);
      }
      
      public function getGiftButtonToolTip(param1:IPlayerSummary) : String
      {
         return this._eOGGWindowController.getGiftButtonToolTip(param1);
      }
      
      public function sendGift() : void
      {
         this._eOGGWindowController.sendGift();
      }
      
      public function get display() : DisplayObject
      {
         return this._moduleView.display;
      }
      
      public function getGiftWindowClosed() : ISignal
      {
         return this._eOGGWindowController.getGiftWindowClosed();
      }
      
      public function getGiftSendSuccess() : ISignal
      {
         return this._eOGGWindowController.getGiftSendSuccess();
      }
      
      public function getGiftedPlayerUpdated() : ISignal
      {
         return this._eOGGWindowController.getGiftedPlayerUpdated();
      }
      
      public function cleanSessionData() : void
      {
         this._eOGGWindowController.cleanSessionData();
      }
      
      public function setGiftedPlayer(param1:IPlayerSummary) : void
      {
         this._eOGGWindowController.setGiftRecipient(param1);
      }
      
      public function getGiftSent() : ISignal
      {
         return null;
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._moduleView.getLayoutInvalidated();
      }
      
      public function invalidateLayout() : void
      {
         this._moduleView.invalidateLayout();
      }
      
      public function getIncludeInLayout() : Boolean
      {
         return this._moduleView.getIncludeInLayout();
      }
      
      public function setIncludeInLayout(param1:Boolean) : void
      {
         this._moduleView.setIncludeInLayout(param1);
      }
      
      public function setAvailableSize(param1:Number, param2:Number) : SizeConstraints
      {
         return this._moduleView.setAvailableSize(param1,param2);
      }
      
      public function getExplicitSize() : Point
      {
         return this._moduleView.getExplicitSize();
      }
      
      public function setExplicitSize(param1:Number, param2:Number) : Point
      {
         return this._moduleView.setExplicitSize(param1,param2);
      }
      
      public function getExplicitPosition() : Point
      {
         return this._moduleView.getExplicitPosition();
      }
      
      public function setExplicitPosition(param1:Number, param2:Number) : Point
      {
         return this._moduleView.setExplicitPosition(param1,param2);
      }
      
      private function continueModuleInitialization() : void
      {
         ProviderLookup.publishProvider(IEndOfGameGiftWindowProvider,this);
         if(this._dependencyList != null)
         {
            this._dependencySemaphore = new AsyncSemaphore(this._dependencyList,this.onAllProvidersReceived);
            this._dependencySemaphore.captureLocks();
         }
      }
      
      private function loadLocalizedResources() : void
      {
         var _loc1_:String = this.getCurrentLocale();
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,MODULE_RESOURCE_BUNDLE_NAME,MODULE_RESOURCE_BUNDLE_NAME,MODULE_DIRECTORY_NAME,ClientConfig.instance.debugLocale);
         _loc3_.getCompleted().addOnce(this.onLocaleAssetsLoaded);
         _loc3_.invoke();
      }
      
      private function getCurrentLocale() : String
      {
         return ClientConfig.instance.locale;
      }
      
      private function onInventoryProviderReceived(param1:IInventoryProvider) : void
      {
         this._playerInventory = param1.getInventory();
         this._dependencySemaphore.releaseLock();
      }
      
      private function onClientNotificationProviderReceived(param1:IClientNotificationProvider) : void
      {
         this._clientNotificationProvider = param1;
         this._clientNotificationProvider.getLcdsProxyMessageRouter().setServiceCallListener(EndOfGameGiftService.DESTINATION_SERVICE_NAME,this._endOfGameGiftService);
         this._dependencySemaphore.releaseLock();
      }
      
      private function onLocaleAssetsLoaded() : void
      {
         this._dependencySemaphore.releaseLock();
      }
      
      private function onAllProvidersReceived() : void
      {
         this._dependencySemaphore.destroy();
         this._dependencySemaphore = null;
         this._dependencyList = null;
         this._sessionPlayer = SessionPlayerSummary.getPlayerSummaryForSessionPlayer(Session.instance,ClientConfig.instance.locale,this._playerInventory.riotPoints);
         this._dtoValidator = new GiftListValueObjectFactory();
         this._eoggModel = new EndOfGameGiftModel(this._sessionPlayer,new GiftingRules());
         this._viewMediator = new EndOfGameGiftViewMediator(this._blixContext);
         this._eoggActionFactory = new EndOfGameGiftActionFactory(this._blixContext,this._moduleInfo,this._eoggModel,this._viewMediator,this._endOfGameGiftService,this._dtoValidator,this._encoder,this._decoder);
         this._eOGGWindowController = new EndOfGameGiftWindowController(this._blixContext,this._moduleInfo,this._eoggModel,this._viewMediator,this._endOfGameGiftService,this._eoggActionFactory);
      }
   }
}

