package blix.assets.proxy.SpotlightPanel
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpotlightPanel.SpotlightPanelControls.ArrowButtonAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class SpotlightControlsAsset extends InstanceMapping
   {
      
      public var textFieldAsset:TextFieldMapping;
      
      public var leftArrowAsset:ArrowButtonAsset;
      
      public var rightArrowAsset:ArrowButtonAsset;
      
      public function SpotlightControlsAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.textFieldAsset = new TextFieldMapping("textFieldAsset",this);
         this.leftArrowAsset = new ArrowButtonAsset("leftArrowAsset",this);
         this.rightArrowAsset = new ArrowButtonAsset("rightArrowAsset",this);
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

