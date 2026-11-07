package blix.assets.proxy.FeaturedPanel
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class FeaturedPanelContentAsset extends InstanceMapping
   {
      
      public var hitAreaAsset:HitAreaAsset;
      
      public var loaderContainerAsset:empty;
      
      public function FeaturedPanelContentAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.hitAreaAsset = new HitAreaAsset("hitAreaAsset",this);
         this.loaderContainerAsset = new empty("loaderContainerAsset",this);
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

