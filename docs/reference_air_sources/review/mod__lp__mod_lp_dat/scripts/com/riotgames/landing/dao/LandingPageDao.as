package com.riotgames.landing.dao
{
   import blix.action.UrlLoaderAction;
   import blix.context.IContext;
   import com.rational.serialization.json.JSON;
   import com.riotgames.landing.LandingPageModel;
   import com.riotgames.landing.featured.FeaturedPanelModel;
   import com.riotgames.landing.news.NewsListModel;
   import com.riotgames.landing.news.bannerscroller.BannerItemModel;
   import com.riotgames.landing.news.bannerscroller.BannerScrollerModel;
   import com.riotgames.landing.news.newsitem.NewsItemModel;
   import com.riotgames.landing.onsale.ItemPanelModel;
   import com.riotgames.landing.spotlight.SpotlightPanelModel;
   import com.riotgames.landing.spotlight.VideoSpotlightModel;
   import com.riotgames.landing.takeover.TakeoverModel;
   import com.riotgames.util.logging.getLogger;
   import flash.net.URLRequest;
   import mx.logging.ILogger;
   
   public class LandingPageDao implements ILandingPageDao
   {
      
      public var aggregatorUrl:String;
      
      public var realm:String;
      
      public var locale:String;
      
      public var imageRoot:String;
      
      private var logger:ILogger = getLogger(this);
      
      private var _urlLoaderAction:UrlLoaderAction;
      
      public function LandingPageDao(param1:String, param2:String, param3:String, param4:String, param5:IContext)
      {
         super();
         this.aggregatorUrl = param1;
         this.realm = param2;
         this.locale = param3;
         this.imageRoot = param4;
      }
      
      public function loadLandingPageData(param1:Function, param2:Function = null) : void
      {
         var completedHandler:Function = param1;
         var erredHandler:Function = param2;
         var url:String = this.aggregatorUrl + this.realm + "/" + this.locale + ".js";
         this.logger.info("Services url: " + url);
         this._urlLoaderAction = new UrlLoaderAction(new URLRequest(url));
         this._urlLoaderAction.unmarshallDataFunction = this.unmarshallLandingPageModel;
         this._urlLoaderAction.getCompleted().add(function():void
         {
            completedHandler(_urlLoaderAction.unmarshalledData);
         });
         if(erredHandler != null)
         {
            this._urlLoaderAction.getErred().add(function():void
            {
               erredHandler(_urlLoaderAction.getError());
            });
         }
         this._urlLoaderAction.invoke();
      }
      
      private function unmarshallLandingPageModel(param1:String) : LandingPageModel
      {
         var _loc2_:Object = com.rational.serialization.json.JSON.decode(param1);
         var _loc3_:LandingPageModel = new LandingPageModel();
         _loc3_.bannerScroller = this.unmarshallBannerScrollerModel(_loc2_.promos);
         _loc3_.newsList = this.unmarshallNewsListModel(_loc2_.news);
         if(Boolean(_loc2_.banners) && _loc2_.banners.length >= 1)
         {
            _loc3_.featuredPanelModel = this.unmarshallFeaturedPanelModel(_loc2_.banners[0]);
         }
         if(Boolean(_loc2_.items) && _loc2_.items.length >= 1)
         {
            _loc3_.onSalePanelModel1 = this.unmarshallItemPanelModel(_loc2_.items[0]);
            if(_loc2_.items.length >= 2)
            {
               _loc3_.onSalePanelModel2 = this.unmarshallItemPanelModel(_loc2_.items[1]);
            }
         }
         _loc3_.spotlightPanelModel = this.unmarshallSpotlightPanelModel(_loc2_.spotlight);
         if(Boolean(_loc2_.takeoverItems) && _loc2_.takeoverItems.length > 0)
         {
            _loc3_.takeoverModel = this.unmarshallTakeoverModel(_loc2_.takeoverItems[0]);
         }
         return _loc3_;
      }
      
      private function unmarshallItemPanelModel(param1:Object) : ItemPanelModel
      {
         var _loc4_:Object = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Object = param1.Item;
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:ItemPanelModel = new ItemPanelModel();
         _loc3_.title = _loc2_.name;
         _loc3_.subTitle = _loc2_.description;
         _loc3_.rpCost = parseInt(_loc2_.rp_cost);
         _loc3_.ipCost = parseInt(_loc2_.ip_cost);
         _loc3_.rpOriginalCost = parseInt(_loc2_.original_rp_cost);
         _loc3_.ipOriginalCost = parseInt(_loc2_.original_ip_cost);
         if(_loc2_.icon_absolute_url)
         {
            _loc3_.imageUrl = _loc2_.icon_absolute_url;
         }
         if(_loc2_.info_url)
         {
            _loc3_.infoUrlRequest = new URLRequest(_loc2_.info_url);
         }
         if(_loc2_.buy_url)
         {
            _loc3_.buyUrlRequest = new URLRequest(_loc2_.buy_url);
         }
         _loc3_.saleDiscount = _loc2_.sale_discount;
         if(_loc3_.saleDiscount)
         {
            _loc4_ = param1.ItemPricingSchedule;
            if(_loc4_.length > 0)
            {
               _loc3_.saleEndDate = new Date(_loc4_[0].end_date * 1000);
            }
         }
         return _loc3_;
      }
      
      private function unmarshallFeaturedPanelModel(param1:Object) : FeaturedPanelModel
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:FeaturedPanelModel = new FeaturedPanelModel();
         if(param1.BannerAsset != null)
         {
            _loc2_.imageUrlRequest = new URLRequest(param1.BannerAsset.image_url);
         }
         if(param1.Banner != null)
         {
            _loc2_.clickUrlRequest = new URLRequest(param1.Banner.click_value);
            _loc2_.startTime = new Date(param1.Banner.start_date * 1000);
            _loc2_.endTime = new Date(param1.Banner.end_date * 1000);
         }
         return _loc2_;
      }
      
      private function unmarshallBannerScrollerModel(param1:Object) : BannerScrollerModel
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:BannerScrollerModel = new BannerScrollerModel();
         _loc2_.bannerItemModels = new Vector.<BannerItemModel>();
         for each(_loc3_ in param1)
         {
            _loc2_.bannerItemModels[_loc2_.bannerItemModels.length] = this.unmarshallBannerItemModel(_loc3_);
         }
         return _loc2_;
      }
      
      private function unmarshallNewsListModel(param1:Array) : NewsListModel
      {
         var _loc3_:Object = null;
         var _loc2_:NewsListModel = new NewsListModel();
         _loc2_.newsItems = new Vector.<NewsItemModel>();
         for each(_loc3_ in param1)
         {
            _loc2_.newsItems[_loc2_.newsItems.length] = this.unmarshallNewsItemModel(_loc3_);
         }
         return _loc2_;
      }
      
      private function unmarshallNewsItemModel(param1:Object) : NewsItemModel
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:NewsItemModel = new NewsItemModel();
         _loc2_.title = param1.title;
         _loc2_.content = param1.description;
         _loc2_.imageRequest = new URLRequest(param1.thumbUrl);
         _loc2_.clickUrlRequest = new URLRequest(param1.linkUrl);
         _loc2_.date = new Date(parseInt(param1.created) * 1000);
         return _loc2_;
      }
      
      private function unmarshallBannerItemModel(param1:Object) : BannerItemModel
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:BannerItemModel = new BannerItemModel();
         _loc2_.title = String(param1.title);
         _loc2_.subTitle = String(param1.promoText);
         _loc2_.clickUrlRequest = new URLRequest(param1.linkUrl);
         _loc2_.thumbUrlRequest = new URLRequest(param1.thumbUrl);
         _loc2_.imageUrlRequest = new URLRequest(param1.imageUrl);
         return _loc2_;
      }
      
      private function unmarshallSpotlightPanelModel(param1:Object) : SpotlightPanelModel
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:SpotlightPanelModel = new SpotlightPanelModel();
         _loc2_.videoSpotlightModels = new Vector.<VideoSpotlightModel>();
         for each(_loc3_ in param1)
         {
            _loc2_.videoSpotlightModels[_loc2_.videoSpotlightModels.length] = this.unmarshallVideoSpotlightModel(_loc3_.Videos);
         }
         return _loc2_;
      }
      
      private function unmarshallVideoSpotlightModel(param1:Object) : VideoSpotlightModel
      {
         var _loc2_:VideoSpotlightModel = new VideoSpotlightModel();
         _loc2_.videoName = String(param1.title);
         _loc2_.videoUrl = param1.url;
         if(param1.Item != null)
         {
            if(param1.Item.info_url)
            {
               _loc2_.infoUrlRequest = new URLRequest(param1.Item.info_url);
            }
            if(param1.Item.buy_url)
            {
               _loc2_.buyUrlRequest = new URLRequest(param1.Item.buy_url);
            }
         }
         return _loc2_;
      }
      
      private function unmarshallTakeoverModel(param1:Object) : TakeoverModel
      {
         if(param1 == null || param1.imageUrl == null)
         {
            return null;
         }
         var _loc2_:TakeoverModel = new TakeoverModel();
         _loc2_.title = param1.title;
         _loc2_.clickUrl = param1.clickUrl;
         _loc2_.imageUrl = param1.imageUrl;
         return _loc2_;
      }
   }
}

