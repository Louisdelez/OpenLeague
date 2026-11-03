package blix.assets.proxy.purchaseScreen
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.unlockButton.UnlockButtonAsset;
   
   public class PurchaseMathAsset extends InstanceMapping
   {
      
      public var balanceText:TextFieldMapping;
      
      public var currentText:TextFieldMapping;
      
      public var unlockWithLabel:TextFieldMapping;
      
      public var costLabelText:TextFieldMapping;
      
      public var costText:TextFieldMapping;
      
      public var balanceLabelText:TextFieldMapping;
      
      public var currentLabelText:TextFieldMapping;
      
      public var unlockWithButton:UnlockButtonAsset;
      
      public function PurchaseMathAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.balanceText = new TextFieldMapping("balanceText",this);
         this.currentText = new TextFieldMapping("currentText",this);
         this.unlockWithLabel = new TextFieldMapping("unlockWithLabel",this);
         this.costLabelText = new TextFieldMapping("costLabelText",this);
         this.costText = new TextFieldMapping("costText",this);
         this.balanceLabelText = new TextFieldMapping("balanceLabelText",this);
         this.currentLabelText = new TextFieldMapping("currentLabelText",this);
         this.unlockWithButton = new UnlockButtonAsset("unlockWithButton",this);
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

