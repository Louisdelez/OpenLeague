package blix.assets.proxy.NewsPanel.BannerScroller
{
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class BannerThumbsAsset extends InstanceMapping
   {
      
      public var nextButtonAsset:BannerArrowButtonAsset;
      
      public var previousButtonAsset:BannerArrowButtonAsset;
      
      public var thumbsContainerAsset:empty;
      
      public function BannerThumbsAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.nextButtonAsset = new BannerArrowButtonAsset("nextButtonAsset",this);
         this.previousButtonAsset = new BannerArrowButtonAsset("previousButtonAsset",this);
         this.thumbsContainerAsset = new empty("thumbsContainerAsset",this);
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

