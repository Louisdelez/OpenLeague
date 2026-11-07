package blix.assets.proxy.purchaseScreen
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class ConfirmPanelAsset extends InstanceMapping
   {
      
      public var confirmTitle:TextFieldMapping;
      
      public var confirmContent:TextFieldMapping;
      
      public function ConfirmPanelAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.confirmTitle = new TextFieldMapping("confirmTitle",this);
         this.confirmContent = new TextFieldMapping("confirmContent",this);
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

