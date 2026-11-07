package blix.assets.proxy.takeover
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.Common.PreloaderAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class TakeoverAsset extends InstanceMapping
   {
      
      public var progressIndicatorAsset:PreloaderAsset;
      
      public var clickArea:HitAreaAsset;
      
      public var contentContainer:empty;
      
      public function TakeoverAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.progressIndicatorAsset = new PreloaderAsset("progressIndicatorAsset",this);
         this.clickArea = new HitAreaAsset("clickArea",this);
         this.contentContainer = new empty("contentContainer",this);
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

