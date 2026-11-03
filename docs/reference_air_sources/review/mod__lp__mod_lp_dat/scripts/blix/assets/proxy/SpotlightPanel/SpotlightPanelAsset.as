package blix.assets.proxy.SpotlightPanel
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.Panel_common.panelBackgroundInner;
   import blix.assets.proxy.Panel_common.panelBackgroundOuter;
   import blix.assets.proxy.SpotlightPanel.SpotlightPanelControls.spotlightPanelControls;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class SpotlightPanelAsset extends InstanceMapping
   {
      
      public var fullScreenButtonAsset:FullScreenButton;
      
      public var titleTextFieldAsset:TextFieldMapping;
      
      public var controlsPosition:empty;
      
      public var spotlightPanelControls:blix.assets.proxy.SpotlightPanel.SpotlightPanelControls.spotlightPanelControls;
      
      public var youTubeScrollerAsset:empty;
      
      public var youTubeSizer:HitAreaAsset;
      
      public var backgroundInnerAsset:panelBackgroundInner;
      
      public var backgroundOuterAsset:panelBackgroundOuter;
      
      public function SpotlightPanelAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.fullScreenButtonAsset = new FullScreenButton("fullScreenButtonAsset",this);
         this.titleTextFieldAsset = new TextFieldMapping("titleTextFieldAsset",this);
         this.controlsPosition = new empty("controlsPosition",this);
         this.spotlightPanelControls = new blix.assets.proxy.SpotlightPanel.SpotlightPanelControls.spotlightPanelControls("spotlightPanelControls",this);
         this.youTubeScrollerAsset = new empty("youTubeScrollerAsset",this);
         this.youTubeSizer = new HitAreaAsset("youTubeSizer",this);
         this.backgroundInnerAsset = new panelBackgroundInner("backgroundInnerAsset",this);
         this.backgroundOuterAsset = new panelBackgroundOuter("backgroundOuterAsset",this);
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

