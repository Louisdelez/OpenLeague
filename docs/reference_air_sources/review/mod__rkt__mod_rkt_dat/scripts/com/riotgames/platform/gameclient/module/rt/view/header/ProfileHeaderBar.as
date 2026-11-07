package com.riotgames.platform.gameclient.module.rt.view.header
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.header.ProfileHeaderBar;
   import blix.components.timeline.StatefulView;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.pvpnet.component.AudioButton;
   import com.riotgames.rust.components.FlashFlexComponent;
   import com.riotgames.rust.components.PromptingTextView;
   
   public class ProfileHeaderBar extends FlashFlexComponent
   {
      
      public static const STATE_INTRO:String = "intro";
      
      public static const STATE_PROFILE:String = "profile";
      
      public static const STATE_HISTORY:String = "history";
      
      public static const STATE_STATS:String = "stats";
      
      public static const STATE_MANAGE:String = "manage";
      
      public var historyTab:AudioButton;
      
      public var findTeamText:PromptingTextView;
      
      public var manageTab:AudioButton;
      
      public var leaguesTab:AudioButton;
      
      public var profileTab:AudioButton;
      
      public var statsTab:AudioButton;
      
      private var tabLayout:LayoutContainer;
      
      public function ProfileHeaderBar()
      {
         super(RTFacade.context,"rt.ProfileHeaderBar");
      }
      
      public function setManageTabVisible(param1:Boolean) : void
      {
         this.manageTab.setVisible(param1);
      }
      
      public function get view() : StatefulView
      {
         return _view as StatefulView;
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new StatefulView(_context);
      }
      
      private function onSearchForTeam() : void
      {
         var _loc1_:String = this.findTeamText.getText();
         if(_loc1_.length > 0)
         {
            RTFacade.teamProxy.showTeamByName(_loc1_);
         }
      }
      
      public function setState(param1:String) : void
      {
         if(param1 == STATE_INTRO)
         {
            this.view.setCurrentState("hideTabs");
         }
         else
         {
            this.view.setCurrentState("showTabs");
         }
         this.profileTab.setEnabled(true);
         this.manageTab.setEnabled(true);
         this.historyTab.setEnabled(true);
         this.statsTab.setEnabled(true);
         switch(param1)
         {
            case STATE_PROFILE:
               this.profileTab.setEnabled(false);
               break;
            case STATE_HISTORY:
               this.historyTab.setEnabled(false);
               break;
            case STATE_STATS:
               this.statsTab.setEnabled(false);
               break;
            case STATE_MANAGE:
               this.manageTab.setEnabled(false);
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:blix.assets.proxy.header.ProfileHeaderBar = new blix.assets.proxy.header.ProfileHeaderBar();
         this.profileTab = new AudioButton(this.view);
         this.view.setTimelineChild(_loc1_.tabLayoutHolder.profileButton,this.profileTab);
         this.historyTab = new AudioButton(this.view);
         this.view.setTimelineChild(_loc1_.tabLayoutHolder.historyButton,this.historyTab);
         this.historyTab.setVisible(RTFacade.instance.rtProvider.configShowTeamHistory);
         this.statsTab = new AudioButton(this.view);
         this.view.setTimelineChild(_loc1_.tabLayoutHolder.statsButton,this.statsTab);
         this.statsTab.setVisible(RTFacade.instance.rtProvider.configShowTeamStats);
         this.manageTab = new AudioButton(this.view);
         this.view.setTimelineChild(_loc1_.tabLayoutHolder.manageButton,this.manageTab);
         this.tabLayout = new LayoutContainer(_loc1_.tabLayoutHolder.create(this.view));
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.setHorizontalAlign(HorizontalAlign.LEFT);
         _loc2_.setGap(0);
         this.tabLayout.setLayoutAlgorithm(_loc2_);
         this.tabLayout.addElement(this.profileTab);
         this.tabLayout.addElement(this.historyTab);
         this.tabLayout.addElement(this.statsTab);
         this.tabLayout.addElement(this.manageTab);
         this.findTeamText = new PromptingTextView(this.view);
         this.findTeamText.setPrompt(RTResource.getString("findATeam"),8947848);
         this.view.setTimelineChild(_loc1_.findTeamText,this.findTeamText);
         this.findTeamText.onEnterPressed.add(this.onSearchForTeam);
      }
   }
}

