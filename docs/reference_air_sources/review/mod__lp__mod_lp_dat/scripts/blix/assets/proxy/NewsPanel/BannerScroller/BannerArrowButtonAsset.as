package blix.assets.proxy.NewsPanel.BannerScroller
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class BannerArrowButtonAsset extends InstanceMapping
   {
      
      public var hitAreaAsset:HitAreaAsset;
      
      public function BannerArrowButtonAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.hitAreaAsset = new HitAreaAsset("hitAreaAsset",this);
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

