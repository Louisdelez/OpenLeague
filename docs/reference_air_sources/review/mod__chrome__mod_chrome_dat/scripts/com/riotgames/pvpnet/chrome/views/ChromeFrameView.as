package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ILoyaltyProvider;
   import com.riotgames.platform.common.provider.LoyaltyProviderProxy;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyRewards;
   import com.riotgames.pvpnet.chrome.ChromeContextAlertController;
   import com.riotgames.pvpnet.chrome.ChromeController;
   import com.riotgames.pvpnet.chrome.metrics.TickerUsageTracker;
   import com.riotgames.pvpnet.chrome.model.ChromeModel;
   import com.riotgames.pvpnet.component.AudioButton;
   import com.riotgames.rust.theme.ThemeConfig;
   import flash.events.MouseEvent;
   import mx.resources.ResourceManager;
   
   public class ChromeFrameView extends StatefulView
   {
      
      private static const STATE_THIN:String = "thin";
      
      private static const STATE_THICK:String = "thick";
      
      private static const THEME_PARCHMENT:String = "parchment";
      
      private static const THEME_LOLBRAND:String = "lolBrand";
      
      private var _logoButton:ButtonX;
      
      private var _logoButtonContainer:SpriteProxy;
      
      private var _tickerButton:ChromeTickerButton;
      
      private var _playButton:ChromePlayButton;
      
      private var _summonerIconButton:ChromeSummonerIconButton;
      
      private var _summonerInfoView:ChromeSummonerInfoView;
      
      private var _topLevelNavigation:ChromeTopLevelNavigationView;
      
      private var _queueBox:QueueBox;
      
      private var _prefButton:ButtonX;
      
      private var _loyaltyMedal:SpriteProxy;
      
      private var _contextAlertView:ChromeContextAlertView;
      
      private var _controller:ChromeController;
      
      private var _contextAlertController:ChromeContextAlertController;
      
      private var _loyaltyProvider:ILoyaltyProvider;
      
      private var _model:ChromeModel;
      
      private var _tracker:TickerUsageTracker = new TickerUsageTracker();
      
      private const PROFILE_BUTTON_Y:int = 74;
      
      private const CHAT_ROOMS_BUTTON_X:int = 897;
      
      private const CHAT_ROOMS_BUTTON_Y:int = 585;
      
      private const LOYALTY_STATUS_IMAGE_X:int = 948;
      
      private const LOYALTY_STATUS_BRAND_X:int = 960;
      
      private const LOYALTY_STATUS_IMAGE_Y:int = 76;
      
      private const SUMMONER_ICON_IMAGE_Y:int = 76;
      
      private const PLAY_BUTTON_X:int = 484;
      
      private const PLAY_BUTTON_Y:int = 74;
      
      private const IP_BAR_X:int = 536;
      
      private const IP_BAR_Y:int = 100;
      
      private const EOG_REWARDS_INFO_X:int = 512;
      
      private const EOG_REWARDS_INFO_Y:int = 217;
      
      private const DEFAULT_POSITION_X:int = 949;
      
      private const DEFAULT_POSITION_Y:int = 90;
      
      private const BUTTON_PADDING:int = -157;
      
      public function ChromeFrameView(param1:IContext)
      {
         super(param1);
         setLinkage("ChromeView");
         this._model.contextAlertChanged.add(this.handleActiveContextAlertChanged);
         this._model.navigatorVisibleChanged.add(this.updateChromeState);
         this.updateChromeState();
      }
      
      override protected function initializeDependencies() : void
      {
         this._controller = getDependency(ChromeController);
         this._contextAlertController = getDependency(ChromeContextAlertController);
         this._loyaltyProvider = LoyaltyProviderProxy.instance;
         this._model = getDependency(ChromeModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._summonerIconButton = new ChromeSummonerIconButton(this);
         setTimelineChildByName("summonerIconButton",this._summonerIconButton);
         this._summonerIconButton.addEventListener(MouseEvent.CLICK,this.handleSummonerIconClicked);
         this._summonerInfoView = new ChromeSummonerInfoView(this);
         setTimelineChildByName("summonerInfoContainer",this._summonerInfoView);
         this._summonerInfoView.setMouseEnabled(false);
         this._logoButtonContainer = new SpriteProxy(this);
         setTimelineChildByName("logoButtonContainer",this._logoButtonContainer);
         this._logoButton = new AudioButton(this,null,AudioKeys.SOUND_TOP_NAV_BUTTON_CLICK);
         this._logoButton.setLinkage("ChromeLogoButton");
         this._logoButton.addEventListener(MouseEvent.CLICK,this.handleLogoButtonClicked);
         assignToolTip(this._logoButton,ResourceManager.getInstance().getString("resources","navigator_logo_tooltip"));
         this._logoButtonContainer.addChild(this._logoButton);
         var _loc1_:ChromeTicker = new ChromeTicker(this,this._tracker);
         setTimelineChildByName("ticker",_loc1_);
         this._tickerButton = new ChromeTickerButton(this,_loc1_,this._tracker);
         setTimelineChildByName("tickerButton",this._tickerButton);
         this._playButton = new ChromePlayButton(this);
         setTimelineChildByName("playButton",this._playButton);
         this._topLevelNavigation = new ChromeTopLevelNavigationView(this);
         setTimelineChildByName("topLevelNavigation",this._topLevelNavigation);
         this._queueBox = new QueueBox(this);
         setTimelineChildByName("queueBox",this._queueBox);
         this._prefButton = new AudioButton(this);
         this._prefButton.addEventListener(MouseEvent.CLICK,this.handlePreferencesButtonClicked);
         assignToolTip(this._prefButton,ResourceManager.getInstance().getString("resources","navigator_options_tooltip"));
         setTimelineChildByName("prefsButton",this._prefButton);
         this._loyaltyMedal = new SpriteProxy(this);
         setTimelineChildByName("loyaltyMedal",this._loyaltyMedal);
         this._loyaltyMedal.setVisible(false);
         this._loyaltyProvider.getRewardsChanged().add(this.handleLoyaltyRewardsChanged);
         this._contextAlertView = new ChromeContextAlertView(this);
         this._contextAlertView.setVisible(false);
         this._contextAlertView.getCloseButtonClicked().add(this.handleContextAlertCloseClicked);
         setTimelineChildByName("contextAlertView",this._contextAlertView);
         super.createChildren();
      }
      
      private function handleLoyaltyRewardsChanged() : void
      {
         var _loc1_:LoyaltyRewards = this._loyaltyProvider.getRewards();
         if(_loc1_)
         {
            this._loyaltyMedal.setVisible(true);
            assignToolTip(this._loyaltyMedal,this._loyaltyProvider.getRewardsDescription());
         }
         else
         {
            this._loyaltyMedal.setVisible(false);
            unassignToolTip(this._loyaltyMedal);
         }
      }
      
      private function updateChromeState() : void
      {
         if(this._model.navigatorVisible)
         {
            setCurrentState(STATE_THICK);
         }
         else
         {
            setCurrentState(STATE_THIN);
         }
      }
      
      private function handleLogoButtonClicked(param1:MouseEvent) : void
      {
         this._controller.navigateToLobby();
      }
      
      private function handleSummonerIconClicked(param1:MouseEvent) : void
      {
         this._controller.showSummonerIconChoosePopup();
      }
      
      private function handlePreferencesButtonClicked(param1:MouseEvent) : void
      {
         this._controller.showPreferencesPopup();
      }
      
      private function handleActiveContextAlertChanged() : void
      {
         this._contextAlertView.setVisible(this._model.contextAlert != null);
         this._contextAlertView.setModel(this._model.contextAlert);
         this.positionContextAlert();
      }
      
      private function handleContextAlertCloseClicked(param1:AlertParameters) : void
      {
         if(this._model)
         {
            this._contextAlertController.dismissAlert(param1);
         }
      }
      
      private function positionContextAlert() : void
      {
         if(ThemeConfig.instance.getDoesThemeHavePrecedence(THEME_LOLBRAND,THEME_PARCHMENT))
         {
            this.positionContextAlertForTheme(true);
         }
         else
         {
            this.positionContextAlertForTheme(false);
         }
      }
      
      private function positionContextAlertForTheme(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(!this._model.contextAlert)
         {
            return;
         }
         switch(this._model.contextAlert.location)
         {
            case AlertLocation.STORE_BUTTON:
            case AlertLocation.PROFILE_BUTTON:
            case AlertLocation.WATCH_BUTTON:
            case AlertLocation.JOURNAL_OF_JUSTICE_BUTTON:
               _loc2_ = this._topLevelNavigation.getButtonHorizontalCenterByAlertLocation(this._model.contextAlert.location);
               if(_loc2_ <= 0 || _currentState == STATE_THIN)
               {
                  this._contextAlertView.setExplicitPosition(this.DEFAULT_POSITION_X,this.DEFAULT_POSITION_Y);
                  this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_NO_ARROW);
                  break;
               }
               this._contextAlertView.setExplicitPosition(_loc2_ + this.BUTTON_PADDING,this.PROFILE_BUTTON_Y);
               this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_TOP_MIDDLE);
               break;
            case AlertLocation.IP_BAR:
               this._contextAlertView.setExplicitPosition(this.IP_BAR_X,this.IP_BAR_Y);
               this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_LEFT_TOP);
               break;
            case AlertLocation.EOG_REWARDS_INFO:
               this._contextAlertView.setExplicitPosition(this.EOG_REWARDS_INFO_X,this.EOG_REWARDS_INFO_Y);
               this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_TOP_MIDDLE);
               break;
            case AlertLocation.CHAT_ROOMS_BUTTON:
               this._contextAlertView.setExplicitPosition(this.CHAT_ROOMS_BUTTON_X,this.CHAT_ROOMS_BUTTON_Y);
               this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_BOTTOM_RIGHT);
               break;
            case AlertLocation.LOYALTY_STATUS_IMAGE:
               if(param1)
               {
                  this._contextAlertView.setExplicitPosition(this.LOYALTY_STATUS_BRAND_X,this.LOYALTY_STATUS_IMAGE_Y);
                  this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_TOP_EDGE);
               }
               else
               {
                  this._contextAlertView.setExplicitPosition(this.LOYALTY_STATUS_IMAGE_X,this.LOYALTY_STATUS_IMAGE_Y);
                  this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_TOP_RIGHT);
               }
               break;
            case AlertLocation.SUMMONER_ICON:
               this._contextAlertView.setExplicitPosition(this._summonerIconButton.getX() + this._summonerIconButton.getWidth() / 2 + this.BUTTON_PADDING,this.SUMMONER_ICON_IMAGE_Y);
               this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_TOP_MIDDLE);
               break;
            case AlertLocation.PLAY_BUTTON:
               if(param1)
               {
                  this._contextAlertView.setExplicitPosition(this._playButton.getX() + this._playButton.getWidth() / 2 + this.BUTTON_PADDING,this.PLAY_BUTTON_Y);
               }
               else
               {
                  this._contextAlertView.setExplicitPosition(this.PLAY_BUTTON_X,this.PLAY_BUTTON_Y);
               }
               this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_TOP_MIDDLE);
               break;
            default:
               this._contextAlertView.setExplicitPosition(this.DEFAULT_POSITION_X,this.DEFAULT_POSITION_Y);
               this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_NO_ARROW);
         }
         if(this._contextAlertView.getX() > this.LOYALTY_STATUS_BRAND_X)
         {
            this._contextAlertView.setExplicitPosition(this.DEFAULT_POSITION_X,this.DEFAULT_POSITION_Y);
            this._contextAlertView.setArrowState(AlertParameters.ARROW_STATE_NO_ARROW);
         }
      }
      
      private function positionContextAlertForLolBrand() : void
      {
         if(!this._model.contextAlert)
         {
            return;
         }
      }
   }
}

