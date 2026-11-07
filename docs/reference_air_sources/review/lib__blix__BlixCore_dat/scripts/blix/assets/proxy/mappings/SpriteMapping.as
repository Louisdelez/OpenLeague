package blix.assets.proxy.mappings
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.Context;
   
   public class SpriteMapping extends InstanceMapping
   {
      
      public function SpriteMapping(param1:String, param2:InstanceMapping = null)
      {
         super(param1,param2);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage("flash.display.Sprite");
         return _loc2_;
      }
      
      public function create(param1:DisplayObjectContainerProxy) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         param1.setTimelineChildByName(getName(),_loc2_);
         return _loc2_;
      }
   }
}

