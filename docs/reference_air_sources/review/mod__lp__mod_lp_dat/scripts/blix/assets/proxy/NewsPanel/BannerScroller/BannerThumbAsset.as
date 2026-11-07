package blix.assets.proxy.NewsPanel.BannerScroller
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.context.Context;
   
   public class BannerThumbAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "assets.BannerThumbAsset";
      
      public var sizer:HitAreaAsset;
      
      public var contentContainerAsset:empty;
      
      public function BannerThumbAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.sizer = new HitAreaAsset("sizer",this);
         this.contentContainerAsset = new empty("contentContainerAsset",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return BannerThumbAsset.create(param1);
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

