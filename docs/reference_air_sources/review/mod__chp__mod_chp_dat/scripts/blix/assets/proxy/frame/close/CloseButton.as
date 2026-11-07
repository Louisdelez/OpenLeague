package blix.assets.proxy.frame.close
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.common.HitArea;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class CloseButton extends InstanceMapping
   {
      
      public var hitAreaClip:HitArea;
      
      public function CloseButton(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.hitAreaClip = new HitArea("hitAreaClip",this);
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

