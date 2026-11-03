package blix.assets.proxy.errorDialog
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.purchaseScreen.PurchaseCloseButton;
   import blix.assets.proxy.purchaseScreen.PurchaseRPButtonAsset;
   
   public class popupAsset extends InstanceMapping
   {
      
      public var closeButton:PurchaseCloseButton;
      
      public var errorMessageText:TextFieldMapping;
      
      public var okButton:PurchaseRPButtonAsset;
      
      public var titleText:TextFieldMapping;
      
      public function popupAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.closeButton = new PurchaseCloseButton("closeButton",this);
         this.errorMessageText = new TextFieldMapping("errorMessageText",this);
         this.okButton = new PurchaseRPButtonAsset("okButton",this);
         this.titleText = new TextFieldMapping("titleText",this);
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

