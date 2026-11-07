package blix.assets.proxy
{
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class linkHolder extends InstanceMapping
   {
      
      public var linkText:TextFieldMapping;
      
      public function linkHolder(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.linkText = new TextFieldMapping("linkText",this);
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

