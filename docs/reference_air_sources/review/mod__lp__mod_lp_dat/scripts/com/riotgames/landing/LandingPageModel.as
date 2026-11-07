package com.riotgames.landing
{
   import com.riotgames.landing.featured.FeaturedPanelModel;
   import com.riotgames.landing.news.NewsListModel;
   import com.riotgames.landing.news.bannerscroller.BannerScrollerModel;
   import com.riotgames.landing.onsale.ItemPanelModel;
   import com.riotgames.landing.spotlight.SpotlightPanelModel;
   import com.riotgames.landing.takeover.TakeoverModel;
   
   public class LandingPageModel
   {
      
      public var bannerScroller:BannerScrollerModel;
      
      public var newsList:NewsListModel;
      
      public var featuredPanelModel:FeaturedPanelModel;
      
      public var onSalePanelModel1:ItemPanelModel;
      
      public var onSalePanelModel2:ItemPanelModel;
      
      public var spotlightPanelModel:SpotlightPanelModel;
      
      public var takeoverModel:TakeoverModel;
      
      public function LandingPageModel()
      {
         super();
      }
   }
}

