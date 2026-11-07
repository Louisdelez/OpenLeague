package blix.assets.proxy.SpotlightPanel.SpotlightPanelControls
{
   import blix.assets.proxy.Common.BuyButtonAsset;
   import blix.assets.proxy.Common.InfoButtonAsset;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpotlightPanel.SpotlightControlsAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class spotlightPanelControls extends InstanceMapping
   {
      
      public var navControlsAsset:SpotlightControlsAsset;
      
      public var infoButtonAsset:InfoButtonAsset;
      
      public var buyButtonAsset:BuyButtonAsset;
      
      public function spotlightPanelControls(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.navControlsAsset = new SpotlightControlsAsset("navControlsAsset",this);
         this.infoButtonAsset = new InfoButtonAsset("infoButtonAsset",this);
         this.buyButtonAsset = new BuyButtonAsset("buyButtonAsset",this);
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

