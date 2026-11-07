package blix.assets.proxy.overview.abilitiesAndStats
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class OverviewAbilityIconAsset extends InstanceMapping
   {
      
      public var iconHolder:Empty;
      
      public function OverviewAbilityIconAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.iconHolder = new Empty("iconHolder",this);
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

