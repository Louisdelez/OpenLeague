package blix.assets.proxy.toolTip
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class ToolTipAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "assets.ToolTipAsset";
      
      public var textField:TextFieldMapping;
      
      public var background:ToolTipBackgroundAsset;
      
      public function ToolTipAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.textField = new TextFieldMapping("textField",this);
         this.background = new ToolTipBackgroundAsset("background",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return ToolTipAsset.create(param1);
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

