package blix.assets.proxy.NewsPanel.BannerScroller
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.Common.PreloaderAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class BannerScrollerAsset extends InstanceMapping
   {
      
      public var bannerThumbsAsset:BannerThumbsAsset;
      
      public var callToActionAsset:HitAreaAsset;
      
      public var bannerItemsContainerAsset:empty;
      
      public var progressIndicatorAsset:PreloaderAsset;
      
      public var bannerItemAsset:BannerItemAsset;
      
      public function BannerScrollerAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.bannerThumbsAsset = new BannerThumbsAsset("bannerThumbsAsset",this);
         this.callToActionAsset = new HitAreaAsset("callToActionAsset",this);
         this.bannerItemsContainerAsset = new empty("bannerItemsContainerAsset",this);
         this.progressIndicatorAsset = new PreloaderAsset("progressIndicatorAsset",this);
         this.bannerItemAsset = new BannerItemAsset("bannerItemAsset",this);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : SpriteProxy
      {
         var _loc2_:String = getName();
         var _loc3_:SpriteProxy = new SpriteProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

