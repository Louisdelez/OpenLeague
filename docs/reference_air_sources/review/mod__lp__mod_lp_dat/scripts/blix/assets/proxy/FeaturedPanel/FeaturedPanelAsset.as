package blix.assets.proxy.FeaturedPanel
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class FeaturedPanelAsset extends InstanceMapping
   {
      
      public var titleTextFieldAsset:TextFieldMapping;
      
      public var featuredPanelContentAsset:FeaturedPanelContentAsset;
      
      public function FeaturedPanelAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.titleTextFieldAsset = new TextFieldMapping("titleTextFieldAsset",this);
         this.featuredPanelContentAsset = new FeaturedPanelContentAsset("featuredPanelContentAsset",this);
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

