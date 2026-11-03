package blix.assets.proxy.toolTip
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class DescriptiveToolTipAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "DescriptiveToolTipAsset";
      
      public var contentPositioner:Empty;
      
      public var titleText:TextFieldMapping;
      
      public var descriptionText:TextFieldMapping;
      
      public var hotKeyText:TextFieldMapping;
      
      public var costText:TextFieldMapping;
      
      public var background:DescriptiveToolTipBackground;
      
      public function DescriptiveToolTipAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.contentPositioner = new Empty("contentPositioner",this);
         this.titleText = new TextFieldMapping("titleText",this);
         this.descriptionText = new TextFieldMapping("descriptionText",this);
         this.hotKeyText = new TextFieldMapping("hotKeyText",this);
         this.costText = new TextFieldMapping("costText",this);
         this.background = new DescriptiveToolTipBackground("background",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return DescriptiveToolTipAsset.create(param1);
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

