package blix.assets.proxy
{
   import blix.assets.proxy.common.loadingAnimation;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class purchaseProcessing extends InstanceMapping
   {
      
      public var animation:loadingAnimation;
      
      public var label:TextFieldMapping;
      
      public function purchaseProcessing(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.animation = new loadingAnimation("animation",this);
         this.label = new TextFieldMapping("label",this);
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

