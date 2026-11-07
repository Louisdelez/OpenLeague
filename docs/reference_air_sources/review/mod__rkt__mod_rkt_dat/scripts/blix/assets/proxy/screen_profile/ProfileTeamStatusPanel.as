package blix.assets.proxy.screen_profile
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.statusInfoHelpHitBox;
   import blix.context.Context;
   
   public class ProfileTeamStatusPanel extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.ProfileTeamStatusPanel";
      
      public var hitBox:statusInfoHelpHitBox;
      
      public var infoPanel:statusInfoHelp;
      
      public var statusStates:StatusDisplay;
      
      public function ProfileTeamStatusPanel(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.hitBox = new statusInfoHelpHitBox("hitBox",this);
         this.infoPanel = new statusInfoHelp("infoPanel",this);
         this.statusStates = new StatusDisplay("statusStates",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return ProfileTeamStatusPanel.create(param1);
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

