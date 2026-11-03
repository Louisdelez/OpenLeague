package blix.assets.proxy.screen_profile
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class statusInfoHelp extends InstanceMapping
   {
      
      public var bullet1:TextFieldMapping;
      
      public function statusInfoHelp(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.bullet1 = new TextFieldMapping("bullet1",this);
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

