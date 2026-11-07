package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class landingBG_left extends InstanceMapping
   {
      
      public var rating_shield:blix.assets.proxy.rating_shield;
      
      public function landingBG_left(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.rating_shield = new blix.assets.proxy.rating_shield("rating_shield",this);
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

