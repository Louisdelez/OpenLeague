package blix.assets.proxy.purchaseScreen
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.ModalBlockAsset;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.purchaseProcessing;
   
   public class PurchaseScreenAsset extends InstanceMapping
   {
      
      public var closeButton:PurchaseCloseButton;
      
      public var purchaseProcessHolder:purchaseProcessing;
      
      public var purchaseRpButton:PurchaseRPButtonAsset;
      
      public var doneButton:PurchaseRPButtonAsset;
      
      public var confirmPanel:ConfirmPanelAsset;
      
      public var purchaseMathHolder:PurchaseMathHolderAsset;
      
      public var itemCard:PurchaseItemCardAsset;
      
      public var purchaseItemTitle:PurchaseItemTitleAsset;
      
      public var modalBlock:ModalBlockAsset;
      
      public function PurchaseScreenAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.closeButton = new PurchaseCloseButton("closeButton",this);
         this.purchaseProcessHolder = new purchaseProcessing("purchaseProcessHolder",this);
         this.purchaseRpButton = new PurchaseRPButtonAsset("purchaseRpButton",this);
         this.doneButton = new PurchaseRPButtonAsset("doneButton",this);
         this.confirmPanel = new ConfirmPanelAsset("confirmPanel",this);
         this.purchaseMathHolder = new PurchaseMathHolderAsset("purchaseMathHolder",this);
         this.itemCard = new PurchaseItemCardAsset("itemCard",this);
         this.purchaseItemTitle = new PurchaseItemTitleAsset("purchaseItemTitle",this);
         this.modalBlock = new ModalBlockAsset("modalBlock",this);
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

