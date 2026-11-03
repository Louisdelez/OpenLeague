package blix.assets.proxy.mappings
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.Context;
   
   public class TextFieldMapping extends InstanceMapping
   {
      
      public function TextFieldMapping(param1:String, param2:InstanceMapping = null)
      {
         super(param1,param2);
      }
      
      public static function create(param1:Context) : TextFieldProxy
      {
         var _loc2_:TextFieldProxy = new TextFieldProxy(param1);
         _loc2_.setLinkage("flash.text.TextField");
         return _loc2_;
      }
      
      public function create(param1:DisplayObjectContainerProxy) : TextFieldProxy
      {
         var _loc2_:TextFieldProxy = new TextFieldProxy(param1);
         param1.setTimelineChildByName(getName(),_loc2_);
         return _loc2_;
      }
   }
}

