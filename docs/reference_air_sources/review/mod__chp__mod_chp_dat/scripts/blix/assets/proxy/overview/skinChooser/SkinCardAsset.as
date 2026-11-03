package blix.assets.proxy.overview.skinChooser
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.common.HitArea;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.context.Context;
   
   public class SkinCardAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "assets.SkinCardAsset";
      
      public var frame:SkinCardFrameAsset;
      
      public var imageSizer:HitArea;
      
      public var imageHolder:Empty;
      
      public function SkinCardAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.frame = new SkinCardFrameAsset("frame",this);
         this.imageSizer = new HitArea("imageSizer",this);
         this.imageHolder = new Empty("imageHolder",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return SkinCardAsset.create(param1);
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

