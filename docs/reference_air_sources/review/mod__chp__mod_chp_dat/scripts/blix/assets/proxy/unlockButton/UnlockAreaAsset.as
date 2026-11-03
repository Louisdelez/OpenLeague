package blix.assets.proxy.unlockButton
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.IpIconAsset;
   import blix.assets.proxy.RpIconAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.common.HitArea;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class UnlockAreaAsset extends InstanceMapping
   {
      
      public var hitAreaClip:HitArea;
      
      public var pricePosition:Empty;
      
      public var rpIcon:RpIconAsset;
      
      public var ipIcon:IpIconAsset;
      
      public var rpCostText:TextFieldMapping;
      
      public var ipCostText:TextFieldMapping;
      
      public var orText:TextFieldMapping;
      
      public var priceSizer:HitArea;
      
      public var unlockButton:UnlockButtonAsset;
      
      public function UnlockAreaAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.hitAreaClip = new HitArea("hitAreaClip",this);
         this.pricePosition = new Empty("pricePosition",this);
         this.rpIcon = new RpIconAsset("rpIcon",this);
         this.ipIcon = new IpIconAsset("ipIcon",this);
         this.rpCostText = new TextFieldMapping("rpCostText",this);
         this.ipCostText = new TextFieldMapping("ipCostText",this);
         this.orText = new TextFieldMapping("orText",this);
         this.priceSizer = new HitArea("priceSizer",this);
         this.unlockButton = new UnlockButtonAsset("unlockButton",this);
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

