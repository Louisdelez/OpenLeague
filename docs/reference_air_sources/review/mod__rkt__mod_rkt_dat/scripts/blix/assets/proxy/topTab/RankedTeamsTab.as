package blix.assets.proxy.topTab
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.holder;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.context.Context;
   
   public class RankedTeamsTab extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.RankedTeamsTab";
      
      public var dropdownMarker:holder;
      
      public var dropDownIndicator:dropdownIndicator;
      
      public var tabStates:blix.assets.proxy.topTab.tabStates;
      
      public function RankedTeamsTab(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.dropdownMarker = new holder("dropdownMarker",this);
         this.dropDownIndicator = new dropdownIndicator("dropDownIndicator",this);
         this.tabStates = new blix.assets.proxy.topTab.tabStates("tabStates",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return RankedTeamsTab.create(param1);
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

