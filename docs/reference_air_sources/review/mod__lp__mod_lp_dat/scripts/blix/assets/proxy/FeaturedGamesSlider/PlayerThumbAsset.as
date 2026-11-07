package blix.assets.proxy.FeaturedGamesSlider
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class PlayerThumbAsset extends InstanceMapping
   {
      
      public var imageContainerAsset:HitAreaAsset;
      
      public function PlayerThumbAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.imageContainerAsset = new HitAreaAsset("imageContainerAsset",this);
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

