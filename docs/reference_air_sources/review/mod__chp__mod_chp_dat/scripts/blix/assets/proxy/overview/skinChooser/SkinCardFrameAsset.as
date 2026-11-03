package blix.assets.proxy.overview.skinChooser
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.IpIconAsset;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.RpIconAsset;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.requiresChampion;
   
   public class SkinCardFrameAsset extends InstanceMapping
   {
      
      public var title:TextFieldMapping;
      
      public var ipIcon:IpIconAsset;
      
      public var rpIcon:RpIconAsset;
      
      public var rpCostText:TextFieldMapping;
      
      public var ipCostText:TextFieldMapping;
      
      public var pricePosition:Empty;
      
      public var requiresChampion:blix.assets.proxy.requiresChampion;
      
      public var unlockButton:SkinUnlockButton;
      
      public var unavailableText:TextFieldMapping;
      
      public var ownedText:TextFieldMapping;
      
      public function SkinCardFrameAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.title = new TextFieldMapping("title",this);
         this.ipIcon = new IpIconAsset("ipIcon",this);
         this.rpIcon = new RpIconAsset("rpIcon",this);
         this.rpCostText = new TextFieldMapping("rpCostText",this);
         this.ipCostText = new TextFieldMapping("ipCostText",this);
         this.pricePosition = new Empty("pricePosition",this);
         this.requiresChampion = new blix.assets.proxy.requiresChampion("requiresChampion",this);
         this.unlockButton = new SkinUnlockButton("unlockButton",this);
         this.unavailableText = new TextFieldMapping("unavailableText",this);
         this.ownedText = new TextFieldMapping("ownedText",this);
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

