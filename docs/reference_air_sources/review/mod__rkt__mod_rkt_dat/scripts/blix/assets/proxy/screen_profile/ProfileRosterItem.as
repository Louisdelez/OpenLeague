package blix.assets.proxy.screen_profile
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy._buttons.addFriendButton;
   import blix.assets.proxy._buttons.viewProfileButton;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.profileStatusIcon;
   
   public class ProfileRosterItem extends InstanceMapping
   {
      
      public var nameText:TextFieldMapping;
      
      public var winsText:TextFieldMapping;
      
      public var statusIcon:profileStatusIcon;
      
      public var addFriendButton:blix.assets.proxy._buttons.addFriendButton;
      
      public var viewProfileButton:blix.assets.proxy._buttons.viewProfileButton;
      
      public function ProfileRosterItem(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.nameText = new TextFieldMapping("nameText",this);
         this.winsText = new TextFieldMapping("winsText",this);
         this.statusIcon = new profileStatusIcon("statusIcon",this);
         this.addFriendButton = new blix.assets.proxy._buttons.addFriendButton("addFriendButton",this);
         this.viewProfileButton = new blix.assets.proxy._buttons.viewProfileButton("viewProfileButton",this);
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

