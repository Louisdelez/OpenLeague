package blix.assets.proxy.screen_profile
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TwistedTreelineSummary;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.assets.proxy.ownerItem;
   import blix.assets.proxy.topTab.InviteAllToChatButton;
   import blix.assets.proxy.topTab.LeaveTeamButton;
   import blix.context.Context;
   
   public class TeamProfileView extends InstanceMapping
   {
      
      public static const LINKAGE:String = "rt.TeamProfileView";
      
      public var establishedText:TextFieldMapping;
      
      public var gamesPlayedText:TextFieldMapping;
      
      public var lastGameText:TextFieldMapping;
      
      public var tagText:TextFieldMapping;
      
      public var nameText:TextFieldMapping;
      
      public var summary1:TwistedTreelineSummary;
      
      public var summary2:TwistedTreelineSummary;
      
      public var roster0:ProfileRosterItem;
      
      public var roster1:ProfileRosterItem;
      
      public var roster2:ProfileRosterItem;
      
      public var roster3:ProfileRosterItem;
      
      public var roster4:ProfileRosterItem;
      
      public var roster5:ProfileRosterItem;
      
      public var roster6:ProfileRosterItem;
      
      public var captain:ownerItem;
      
      public var roster7:ProfileRosterItem;
      
      public var leaveTeamButton:LeaveTeamButton;
      
      public var inviteAllChatButton:InviteAllToChatButton;
      
      public function TeamProfileView(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.establishedText = new TextFieldMapping("establishedText",this);
         this.gamesPlayedText = new TextFieldMapping("gamesPlayedText",this);
         this.lastGameText = new TextFieldMapping("lastGameText",this);
         this.tagText = new TextFieldMapping("tagText",this);
         this.nameText = new TextFieldMapping("nameText",this);
         this.summary1 = new TwistedTreelineSummary("summary1",this);
         this.summary2 = new TwistedTreelineSummary("summary2",this);
         this.roster0 = new ProfileRosterItem("roster0",this);
         this.roster1 = new ProfileRosterItem("roster1",this);
         this.roster2 = new ProfileRosterItem("roster2",this);
         this.roster3 = new ProfileRosterItem("roster3",this);
         this.roster4 = new ProfileRosterItem("roster4",this);
         this.roster5 = new ProfileRosterItem("roster5",this);
         this.roster6 = new ProfileRosterItem("roster6",this);
         this.captain = new ownerItem("captain",this);
         this.roster7 = new ProfileRosterItem("roster7",this);
         this.leaveTeamButton = new LeaveTeamButton("leaveTeamButton",this);
         this.inviteAllChatButton = new InviteAllToChatButton("inviteAllChatButton",this);
      }
      
      public static function create(param1:Context) : SpriteProxy
      {
         var _loc2_:SpriteProxy = new SpriteProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : SpriteProxy
      {
         return TeamProfileView.create(param1);
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

