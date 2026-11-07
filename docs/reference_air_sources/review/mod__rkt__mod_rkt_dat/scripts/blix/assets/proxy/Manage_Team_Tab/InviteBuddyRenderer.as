package blix.assets.proxy.Manage_Team_Tab
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.icon;
   import blix.assets.proxy.inviteItemBg;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.separator;
   import blix.context.Context;
   
   public class InviteBuddyRenderer extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.InviteBuddyRenderer";
      
      public var icon:blix.assets.proxy.icon;
      
      public var groupText:TextFieldMapping;
      
      public var labelText:TextFieldMapping;
      
      public var separator:blix.assets.proxy.separator;
      
      public var inviteButton:addNewRankedTeamMemberButton;
      
      public var inviteItemBg:blix.assets.proxy.inviteItemBg;
      
      public function InviteBuddyRenderer(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.icon = new blix.assets.proxy.icon("icon",this);
         this.groupText = new TextFieldMapping("groupText",this);
         this.labelText = new TextFieldMapping("labelText",this);
         this.separator = new blix.assets.proxy.separator("separator",this);
         this.inviteButton = new addNewRankedTeamMemberButton("inviteButton",this);
         this.inviteItemBg = new blix.assets.proxy.inviteItemBg("inviteItemBg",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return InviteBuddyRenderer.create(param1);
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

