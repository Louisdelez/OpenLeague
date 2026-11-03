package blix.assets.proxy.Manage_Team_Tab
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.inviteBuddyListProxy;
   import blix.assets.proxy.inviteBuddyListProxy_copy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.screen_profile.SimpleStatusIcon;
   import blix.assets.proxy.screen_profile.statusInfoHelp;
   import blix.assets.proxy.topTab.PromoteCaptainButton;
   import blix.context.Context;
   
   public class ManageTeamView extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.ManageTeamView";
      
      public var invited0:ManageInvitedRenderer;
      
      public var invited1:ManageInvitedRenderer;
      
      public var invited2:ManageInvitedRenderer;
      
      public var invited3:ManageInvitedRenderer;
      
      public var member0:ManageInvitedRenderer;
      
      public var member1:ManageInvitedRenderer;
      
      public var member2:ManageInvitedRenderer;
      
      public var member3:ManageInvitedRenderer;
      
      public var infoPanel:statusInfoHelp;
      
      public var statusStates:SimpleStatusIcon;
      
      public var buddyListProxy:inviteBuddyListProxy_copy;
      
      public var inviteListProxy:inviteBuddyListProxy;
      
      public var rosterListProxy:inviteBuddyListProxy;
      
      public var filterText:TextFieldMapping;
      
      public var teamNameText:TextFieldMapping;
      
      public var invitesAvailableText:TextFieldMapping;
      
      public var openSlotsText:TextFieldMapping;
      
      public var teamTagText:TextFieldMapping;
      
      public var statusText:TextFieldMapping;
      
      public var establishedText:TextFieldMapping;
      
      public var gamesPlayedText:TextFieldMapping;
      
      public var lastInviteText:TextFieldMapping;
      
      public var nextInviteText:TextFieldMapping;
      
      public var rosterFilledText:TextFieldMapping;
      
      public var promoteNewCaptainButton:PromoteCaptainButton;
      
      public function ManageTeamView(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.invited0 = new ManageInvitedRenderer("invited0",this);
         this.invited1 = new ManageInvitedRenderer("invited1",this);
         this.invited2 = new ManageInvitedRenderer("invited2",this);
         this.invited3 = new ManageInvitedRenderer("invited3",this);
         this.member0 = new ManageInvitedRenderer("member0",this);
         this.member1 = new ManageInvitedRenderer("member1",this);
         this.member2 = new ManageInvitedRenderer("member2",this);
         this.member3 = new ManageInvitedRenderer("member3",this);
         this.infoPanel = new statusInfoHelp("infoPanel",this);
         this.statusStates = new SimpleStatusIcon("statusStates",this);
         this.buddyListProxy = new inviteBuddyListProxy_copy("buddyListProxy",this);
         this.inviteListProxy = new inviteBuddyListProxy("inviteListProxy",this);
         this.rosterListProxy = new inviteBuddyListProxy("rosterListProxy",this);
         this.filterText = new TextFieldMapping("filterText",this);
         this.teamNameText = new TextFieldMapping("teamNameText",this);
         this.invitesAvailableText = new TextFieldMapping("invitesAvailableText",this);
         this.openSlotsText = new TextFieldMapping("openSlotsText",this);
         this.teamTagText = new TextFieldMapping("teamTagText",this);
         this.statusText = new TextFieldMapping("statusText",this);
         this.establishedText = new TextFieldMapping("establishedText",this);
         this.gamesPlayedText = new TextFieldMapping("gamesPlayedText",this);
         this.lastInviteText = new TextFieldMapping("lastInviteText",this);
         this.nextInviteText = new TextFieldMapping("nextInviteText",this);
         this.rosterFilledText = new TextFieldMapping("rosterFilledText",this);
         this.promoteNewCaptainButton = new PromoteCaptainButton("promoteNewCaptainButton",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return ManageTeamView.create(param1);
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

