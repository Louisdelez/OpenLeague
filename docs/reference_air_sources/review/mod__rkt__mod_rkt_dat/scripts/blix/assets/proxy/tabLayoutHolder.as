package blix.assets.proxy
{
   import blix.assets.proxy.header.manageButton;
   import blix.assets.proxy.header.matchHistoryButton;
   import blix.assets.proxy.header.profileButton;
   import blix.assets.proxy.header.teamStatsButton;
   import blix.assets.proxy.mappings.InstanceMapping;
   
   public class tabLayoutHolder extends InstanceMapping
   {
      
      public var profileButton:blix.assets.proxy.header.profileButton;
      
      public var manageButton:blix.assets.proxy.header.manageButton;
      
      public var historyButton:matchHistoryButton;
      
      public var statsButton:teamStatsButton;
      
      public function tabLayoutHolder(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.profileButton = new blix.assets.proxy.header.profileButton("profileButton",this);
         this.manageButton = new blix.assets.proxy.header.manageButton("manageButton",this);
         this.historyButton = new matchHistoryButton("historyButton",this);
         this.statsButton = new teamStatsButton("statsButton",this);
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

