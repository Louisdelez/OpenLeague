package blix.assets.proxy.purchaseScreen
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.common.HitArea;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class PurchaseMathHolderAsset extends InstanceMapping
   {
      
      public var rpPurchase:PurchaseMathAsset;
      
      public var ipPurchase:PurchaseMathAsset;
      
      public var purchaseCardsSizer:HitArea;
      
      public function PurchaseMathHolderAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.rpPurchase = new PurchaseMathAsset("rpPurchase",this);
         this.ipPurchase = new PurchaseMathAsset("ipPurchase",this);
         this.purchaseCardsSizer = new HitArea("purchaseCardsSizer",this);
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

