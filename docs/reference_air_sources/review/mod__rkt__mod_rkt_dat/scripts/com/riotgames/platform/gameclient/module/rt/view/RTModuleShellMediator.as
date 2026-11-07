package com.riotgames.platform.gameclient.module.rt.view
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.model.*;
   import flash.events.MouseEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class RTModuleShellMediator extends Mediator
   {
      
      public static const NAME:String = "RTShellMediator";
      
      public function RTModuleShellMediator(param1:String = "RTShellMediator", param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ProfileTeamProxy.PROFILE_TEAM_CHANGE,ProfilePlayerProxy.FIND_PROFILE_PLAYER_SUCCESS,RTNotificationConstants.RT_MODULE_TEARDOWN,TeamProxy.SHOW_TEAM_STARTED];
      }
      
      private function onHistoryClick(param1:MouseEvent) : void
      {
         this.view.goToHistory();
      }
      
      private function onManageClick(param1:MouseEvent) : void
      {
         this.view.goToManage();
      }
      
      public function get view() : RTModuleShell
      {
         return viewComponent as RTModuleShell;
      }
      
      private function onStatsClick(param1:MouseEvent) : void
      {
         this.view.goToStats();
      }
      
      private function onTeamChanging() : void
      {
         if(!RTFacade.profileTeamProxy.team)
         {
            this.view.goToProfile();
         }
      }
      
      private function onTeamChange(param1:INotification) : void
      {
         var _loc2_:Boolean = true;
         if(param1.getBody() != null && param1.getBody() is Boolean)
         {
            _loc2_ = param1.getBody() as Boolean;
         }
         this.refreshView(_loc2_);
      }
      
      private function get playerProxy() : PlayerProxy
      {
         return RTFacade.instance.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
      }
      
      private function refreshView(param1:Boolean = true) : void
      {
         var _loc2_:TeamMemberInfo = null;
         var _loc3_:Boolean = false;
         if(Boolean(RTFacade.profileTeamProxy.team) && !RTFacade.profileTeamProxy.isDataOnly)
         {
            _loc2_ = ProfileTeamProxy.findLocalMember(RTFacade.profileTeamProxy.team);
            _loc3_ = Boolean(_loc2_) && _loc2_.playerId == RTFacade.profileTeamProxy.team.roster.ownerId;
            if(!_loc3_ || param1)
            {
               this.view.goToProfile();
            }
            if(this.view.profileHeaderBar != null)
            {
               this.view.profileHeaderBar.setManageTabVisible(_loc3_);
            }
         }
         else if(this.teamProxy.isTeamPending)
         {
            this.view.goToProfile();
         }
         else
         {
            this.view.goToIntro();
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.initView();
         this.refreshView();
      }
      
      private function initView() : void
      {
         if(this.view.profileHeaderBar != null)
         {
            this.view.profileHeaderBar.profileTab.addEventListener(MouseEvent.CLICK,this.onProfileClick);
            this.view.profileHeaderBar.historyTab.addEventListener(MouseEvent.CLICK,this.onHistoryClick);
            this.view.profileHeaderBar.statsTab.addEventListener(MouseEvent.CLICK,this.onStatsClick);
            this.view.profileHeaderBar.manageTab.addEventListener(MouseEvent.CLICK,this.onManageClick);
         }
      }
      
      private function get teamProxy() : TeamProxy
      {
         return RTFacade.instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ProfilePlayerProxy.FIND_PROFILE_PLAYER_SUCCESS:
               this.onTeamChange(param1);
               break;
            case ProfileTeamProxy.PROFILE_TEAM_CHANGE:
               this.onTeamChange(param1);
               break;
            case TeamProxy.SHOW_TEAM_STARTED:
               this.onTeamChanging();
         }
      }
      
      private function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      private function onProfileClick(param1:MouseEvent) : void
      {
         this.view.goToProfile();
      }
   }
}

