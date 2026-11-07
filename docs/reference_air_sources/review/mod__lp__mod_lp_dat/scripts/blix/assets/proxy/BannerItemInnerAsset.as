package blix.assets.proxy
{
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class BannerItemInnerAsset extends InstanceMapping
   {
      
      public var titleAsset:TextFieldMapping;
      
      public var subTitleAsset:TextFieldMapping;
      
      public var contentContainerAsset:empty;
      
      public function BannerItemInnerAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.titleAsset = new TextFieldMapping("titleAsset",this);
         this.subTitleAsset = new TextFieldMapping("subTitleAsset",this);
         this.contentContainerAsset = new empty("contentContainerAsset",this);
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

