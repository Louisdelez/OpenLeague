package blix.assets.proxy.overview
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class Owned extends InstanceMapping
   {
      
      public var championOwned:TextFieldMapping;
      
      public function Owned(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.championOwned = new TextFieldMapping("championOwned",this);
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

