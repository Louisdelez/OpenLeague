package com.riotgames.landing
{
   import blix.assets.proxy.LandingPageAsset;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.NewsPanel.News.News_Item.NewsItemAsset;
   import blix.assets.proxy.NewsPanel.News.News_Item.TakeoverNewsItemAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.util.callback.preventRepeatedCalls;
   import com.riotgames.landing.analytics.trackEvent;
   import com.riotgames.landing.errorpanel.ErrorPanel;
   import com.riotgames.landing.featured.FeaturedPanel;
   import com.riotgames.landing.featuredgames.FeaturedGamesScroller;
   import com.riotgames.landing.news.NewsContent;
   import com.riotgames.landing.news.bannerscroller.BannerScroller;
   import com.riotgames.landing.onsale.ItemPanel;
   import com.riotgames.landing.spotlight.SpotlightPanel;
   import com.riotgames.landing.takeover.TakeoverEvent;
   import com.riotgames.landing.takeover.TakeoverView;
   import com.riotgames.newplayerlanding.NewPlayerLandingConfig;
   import com.riotgames.newplayerlanding.views.NPLPView;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LandingPage extends StatefulView
   {
      
      private var _model:LandingPageModel;
      
      public var errorPanel:ErrorPanel;
      
      public var bannerScroller:BannerScroller;
      
      public var newsContent:NewsContent;
      
      public var featuredPanel:FeaturedPanel;
      
      public var onSalePanel1:ItemPanel;
      
      public var onSalePanel2:ItemPanel;
      
      public var spotlightPanel:SpotlightPanel;
      
      public var surveyButton:LabelButtonX;
      
      public var takeoverView:TakeoverView;
      
      public var featuredGamesScroller:FeaturedGamesScroller;
      
      private var nplpView:NPLPView;
      
      private var nplpContainer:MovieClipProxy;
      
      private var fullScreenRect:Rectangle;
      
      protected var featuredEndTimeout:uint;
      
      public function LandingPage(param1:IContext)
      {
         super(param1);
         this.refreshNewsContent();
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onCrossModuleTrackerProvider);
      }
      
      private function onCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         param1.getLoginProcessTracker().landingPageLoaded();
      }
      
      override protected function createChildren() : void
      {
         var resourceManager:IResourceManager;
         var map:LandingPageAsset;
         var newsTitle:Text;
         var fullScreenSizer:SpriteProxy = null;
         super.createChildren();
         resourceManager = ResourceManager.getInstance();
         map = new LandingPageAsset();
         this.errorPanel = new ErrorPanel(this);
         setTimelineChild(map.errorPanelAsset,this.errorPanel);
         this.bannerScroller = new BannerScroller(this);
         setTimelineChild(map.bannerScrollerAsset,this.bannerScroller);
         this.featuredGamesScroller = new FeaturedGamesScroller(this);
         this.featuredGamesScroller.getVisibleChanged().add(this.featuredGamesScrollerVisibleChangeHandler);
         setTimelineChild(map.featuredGamesScrollerAsset,this.featuredGamesScroller);
         this.newsContent = new NewsContent(this);
         setTimelineChild(map.newsContentAsset,this.newsContent);
         this.featuredPanel = new FeaturedPanel(this);
         this.featuredPanel.getVisibleChanged().add(this.featuredPanelVisibleChangeHandler);
         setTimelineChild(map.featuredPanelAsset,this.featuredPanel);
         this.onSalePanel1 = new ItemPanel(this);
         setTimelineChild(map.onSalePanel1Asset,this.onSalePanel1);
         this.onSalePanel2 = new ItemPanel(this);
         setTimelineChild(map.onSalePanel2Asset,this.onSalePanel2);
         this.spotlightPanel = new SpotlightPanel(this);
         setTimelineChild(map.spotlightPanelAsset,this.spotlightPanel);
         this.surveyButton = new LabelButtonX(this);
         this.surveyButton.setText(resourceManager.getString("LandingPage","survey.title"));
         this.surveyButton.addEventListener(MouseEvent.CLICK,this.surveyClickHandler);
         setTimelineChild(map.surveyButtonAsset,this.surveyButton);
         this.takeoverView = new TakeoverView(this);
         setTimelineChild(map.takeoverAsset,this.takeoverView);
         this.takeoverView.addEventListener(TakeoverEvent.TAKEOVER_CLOSED,this.handleTakeoverEvent,false,0,true);
         this.nplpView = new NPLPView(this,this.isNPLPEnabled());
         this.nplpView.getClosed().add(this.handleNPLPClosed);
         this.nplpContainer = new MovieClipProxy(this);
         this.nplpContainer.setLinkage("assets.newPlayerLandingContainer");
         setTimelineChildByName("newPlayerLandingContainer",this.nplpContainer);
         this.nplpContainer.addChild(this.nplpView);
         fullScreenSizer = map.fullScreenSizer.create(this);
         fullScreenSizer.getAssetChanged().add(function():void
         {
            var _loc1_:DisplayObject = fullScreenSizer.getAsset();
            if(_loc1_ != null)
            {
               fullScreenRect = new Rectangle(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
               spotlightPanel.setFullScreenRect(fullScreenRect);
            }
         });
         newsTitle = new Text(this);
         setTimelineChild(map.newsTitle,newsTitle);
         newsTitle.setText(resourceManager.getString("LandingPage","newsTabNavigator.news"));
      }
      
      private function handleTakeoverEvent(param1:TakeoverEvent) : void
      {
         this.takeoverView.removeEventListener(TakeoverEvent.TAKEOVER_CLOSED,this.handleTakeoverEvent);
         this.setCurrentState("normal");
      }
      
      private function handleNPLPClosed() : void
      {
         if(this._model != null && this._model.takeoverModel != null)
         {
            this.setCurrentState("takeover");
         }
         else
         {
            this.setCurrentState("normal");
         }
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this.refreshNewsContent();
      }
      
      private function refreshNewsContent() : void
      {
         switch(_currentState)
         {
            case "normal":
               this.newsContent.setMaxNewsItems(3);
               this.newsContent.setNewsItemLinkage(NewsItemAsset.LINKAGE);
               break;
            case "takeover":
               this.newsContent.setMaxNewsItems(1);
               this.newsContent.setNewsItemLinkage(TakeoverNewsItemAsset.LINKAGE);
         }
      }
      
      private function surveyClickHandler(param1:MouseEvent) : void
      {
         if(this._model == null)
         {
            return;
         }
         if(preventRepeatedCalls(this.surveyClickHandler,[param1],2000))
         {
            return;
         }
         trackEvent(this,"Survey","Survey/Click");
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         navigate(this,new URLRequest(_loc2_.getString("LandingPage","survey.link")));
      }
      
      private function featuredPanelVisibleChangeHandler() : void
      {
         this.onSalePanel1.setVisible(!this.featuredPanel.getVisible());
      }
      
      private function featuredGamesScrollerVisibleChangeHandler() : void
      {
         this.bannerScroller.setVisible(!this.featuredGamesScroller.getVisible());
      }
      
      public function setModel(param1:LandingPageModel) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _logger.logDebug("Landing page model set: " + param1);
         if(this._model != null)
         {
            this.bannerScroller.setModel(null);
            this.featuredGamesScroller.setModel(null);
            this.newsContent.setModel(null);
            this.onSalePanel1.setModel(null);
            this.onSalePanel2.setModel(null);
            this.spotlightPanel.setModel(null);
            this.featuredPanel.setModel(null);
            this.takeoverView.setModel(null);
            clearTimeout(this.featuredEndTimeout);
         }
         this._model = param1;
         if(this._model != null)
         {
            this.bannerScroller.setModel(this._model.bannerScroller);
            this.newsContent.setModel(this._model.newsList);
            this.onSalePanel1.setModel(this._model.onSalePanelModel1);
            this.onSalePanel2.setModel(this._model.onSalePanelModel2);
            this.spotlightPanel.setModel(this._model.spotlightPanelModel);
            this.takeoverView.setModel(this._model.takeoverModel);
            if(this._model.featuredPanelModel != null)
            {
               this.featuredPanel.setModel(this._model.featuredPanelModel);
               _loc2_ = new Date().getTime();
               _loc3_ = this._model.featuredPanelModel.endTime.getTime() - _loc2_;
               this.featuredPanel.setVisible(_loc3_ > 0);
               if(_loc3_ > 0 && _loc3_ < 72 * 3600 * 1000)
               {
                  this.featuredEndTimeout = setTimeout(this.featuredPanel.setVisible,_loc3_,false);
               }
            }
            if(this.isNPLPEnabled())
            {
               this.setCurrentState("newplayer");
            }
            else if(this._model.takeoverModel != null)
            {
               this.setCurrentState("takeover");
            }
            else
            {
               this.setCurrentState("normal");
            }
            if(this.featuredGamesScroller.getModel() == null || this.featuredGamesScroller.getModel().featuredGames == null || Boolean(this.featuredGamesScroller.getModel().featuredGames) && Boolean(this.featuredGamesScroller.getModel().featuredGames.length == 0))
            {
               this.featuredGamesScroller.setVisible(false);
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         clearTimeout(this.featuredEndTimeout);
      }
      
      private function isNPLPEnabled() : Boolean
      {
         if(ClientConfig.instance.enableNPLP)
         {
            return true;
         }
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(NewPlayerLandingConfig.NAMESPACE,NewPlayerLandingConfig.AB_TEST_ENABLED,false,this.onDynamicConfigChange);
         if(Boolean(_loc1_.getBoolean()) && Session.instance.accountSummary.accountId % 2 == 0)
         {
            return false;
         }
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(NewPlayerLandingConfig.NAMESPACE,NewPlayerLandingConfig.ENABLED,false,this.onDynamicConfigChange);
         var _loc3_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(NewPlayerLandingConfig.NAMESPACE,NewPlayerLandingConfig.MAX_LEVEL,NewPlayerLandingConfig.MAX_LEVEL_DEFAULT,this.onDynamicConfigChange);
         return Boolean(_loc2_.getBoolean()) && Session.instance.summonerLevel.summonerLevel <= _loc3_.getInt();
      }
      
      private function onDynamicConfigChange() : void
      {
         this.setModel(this._model);
      }
   }
}

