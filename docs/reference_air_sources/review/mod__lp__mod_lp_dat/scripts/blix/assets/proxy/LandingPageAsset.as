package blix.assets.proxy
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.FeaturedGamesSlider.FeaturedGamesScrollerAsset;
   import blix.assets.proxy.FeaturedPanel.FeaturedPanelAsset;
   import blix.assets.proxy.NewsPanel.BannerScroller.BannerScrollerAsset;
   import blix.assets.proxy.NewsPanel.News.NewsContentAsset;
   import blix.assets.proxy.OnSalePanel.OnSalePanelAsset;
   import blix.assets.proxy.SpotlightPanel.SpotlightPanelAsset;
   import blix.assets.proxy.SurveyPanel.SurveyButton;
   import blix.assets.proxy.debugWindow.DebugWindowAsset;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.takeover.TakeoverAsset;
   import blix.context.Context;
   
   public class LandingPageAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "assets.LandingPageAsset";
      
      public var debuggerAsset:DebugWindowAsset;
      
      public var errorPanelAsset:ErrorPanelAsset;
      
      public var spotlightPanelAsset:SpotlightPanelAsset;
      
      public var featuredPanelAsset:FeaturedPanelAsset;
      
      public var onSalePanel2Asset:OnSalePanelAsset;
      
      public var onSalePanel1Asset:OnSalePanelAsset;
      
      public var surveyButtonAsset:SurveyButton;
      
      public var newsContentAsset:NewsContentAsset;
      
      public var newsTitle:TextFieldMapping;
      
      public var featuredGamesScrollerAsset:FeaturedGamesScrollerAsset;
      
      public var bannerScrollerAsset:BannerScrollerAsset;
      
      public var fullScreenSizer:HitAreaAsset;
      
      public var takeoverAsset:TakeoverAsset;
      
      public function LandingPageAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.debuggerAsset = new DebugWindowAsset("debuggerAsset",this);
         this.errorPanelAsset = new ErrorPanelAsset("errorPanelAsset",this);
         this.spotlightPanelAsset = new SpotlightPanelAsset("spotlightPanelAsset",this);
         this.featuredPanelAsset = new FeaturedPanelAsset("featuredPanelAsset",this);
         this.onSalePanel2Asset = new OnSalePanelAsset("onSalePanel2Asset",this);
         this.onSalePanel1Asset = new OnSalePanelAsset("onSalePanel1Asset",this);
         this.surveyButtonAsset = new SurveyButton("surveyButtonAsset",this);
         this.newsContentAsset = new NewsContentAsset("newsContentAsset",this);
         this.newsTitle = new TextFieldMapping("newsTitle",this);
         this.featuredGamesScrollerAsset = new FeaturedGamesScrollerAsset("featuredGamesScrollerAsset",this);
         this.bannerScrollerAsset = new BannerScrollerAsset("bannerScrollerAsset",this);
         this.fullScreenSizer = new HitAreaAsset("fullScreenSizer",this);
         this.takeoverAsset = new TakeoverAsset("takeoverAsset",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return LandingPageAsset.create(param1);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : MovieClipProxy
      {
         var _loc2_:String = getName();
         var _loc3_:MovieClipProxy = new MovieClipProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

