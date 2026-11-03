package blix.assets.proxy.mappings
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.context.Context;
   
   public class MovieClipMapping extends InstanceMapping
   {
      
      public function MovieClipMapping(param1:String, param2:InstanceMapping = null)
      {
         super(param1,param2);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage("flash.display.MovieClip");
         return _loc2_;
      }
      
      public function create(param1:DisplayObjectContainerProxy) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         param1.setTimelineChildByName(getName(),_loc2_);
         return _loc2_;
      }
   }
}

