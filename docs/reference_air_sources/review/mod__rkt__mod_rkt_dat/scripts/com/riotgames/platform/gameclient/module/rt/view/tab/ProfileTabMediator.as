package com.riotgames.platform.gameclient.module.rt.view.tab
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTNotificationConstants;
   import com.riotgames.platform.gameclient.module.rt.model.ProfilePlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.views.models.ProfileDisplayModel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class ProfileTabMediator extends Mediator
   {
      
      public static const NAME:String = "ProfileTabMediator";
      
      private var _tabTeam:TeamInfo;
      
      public function ProfileTabMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      private function setupView() : void
      {
         this.view.tabStates.addEventListener(MouseEvent.CLICK,this.onTabClicked);
         this.view.dropDownIndicatorButton.addEventListener(MouseEvent.CLICK,this.onDropdownArrowClicked);
         this.view.teamSelected.add(this.onTeamSelected);
         this.refreshView();
         this.profileDisplay.addEventListener("changed",this.onTabStateChanged);
         this.onTabStateChanged(null);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ProfileTeamProxy.PROFILE_TEAM_CHANGE:
               this.refreshView();
               break;
            case ProfilePlayerProxy.FIND_PROFILE_PLAYER_SUCCESS:
               this.onPlayerChanged(param1);
               break;
            case RTNotificationConstants.RT_MODULE_TEARDOWN:
         }
      }
      
      private function onDropdownArrowClicked(param1:MouseEvent) : void
      {
         var _loc5_:TeamInfo = null;
         if(this.view.isDropdownShowing)
         {
            this.view.hideDropdown();
            if(this._tabTeam)
            {
               if(!this.profileTeamProxy.isViewExternal)
               {
                  this.teamProxy.showTeamById(this._tabTeam.teamId,false);
               }
            }
            this.goToRankedTeamsView();
            return;
         }
         var _loc2_:ArrayCollection = this.profilePlayerProxy.memberTeams;
         var _loc3_:ArrayCollection = this.profilePlayerProxy.invitedTeams;
         var _loc4_:Array = [];
         if(_loc2_)
         {
            for each(_loc5_ in _loc2_)
            {
               _loc4_.push(_loc5_);
            }
         }
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            if(_loc4_.length > 0)
            {
               _loc4_.push(null);
            }
            for each(_loc5_ in _loc3_)
            {
               _loc4_.push(_loc5_);
            }
         }
         this.view.showDropdown(_loc4_);
      }
      
      private function setTabTeam(param1:TeamInfo) : void
      {
         this._tabTeam = param1;
         if(param1 == null)
         {
            this.view.tabText.setText(RTResource.getString("profileRTTabName"));
         }
         else
         {
            this.view.tabText.setText(this._tabTeam.name);
         }
      }
      
      public function get teamProxy() : TeamProxy
      {
         return RTFacade.instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      private function onTeamSelected(param1:TeamInfo) : void
      {
         this.teamProxy.showTeamById(param1.teamId,false);
         this.goToRankedTeamsView();
      }
      
      private function onTabClicked(param1:MouseEvent) : void
      {
         this.view.hideDropdown();
         if(this._tabTeam)
         {
            if(!this.profileTeamProxy.isViewExternal)
            {
               this.teamProxy.showTeamById(this._tabTeam.teamId,false);
            }
         }
         this.goToRankedTeamsView();
      }
      
      private function get profileDisplay() : ProfileDisplayModel
      {
         return RTFacade.instance.rtProvider.profileDisplayModel;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [RTNotificationConstants.RT_MODULE_TEARDOWN,ProfileTeamProxy.PROFILE_TEAM_CHANGE,ProfilePlayerProxy.FIND_PROFILE_PLAYER_SUCCESS];
      }
      
      private function shouldShowDropDown(param1:uint) : Boolean
      {
         var _loc3_:TeamMemberInfo = null;
         var _loc2_:Boolean = param1 > 1;
         if(!_loc2_ && this.profilePlayerProxy.isLocal)
         {
            _loc3_ = ProfileTeamProxy.findLocalMember(this.profileTeamProxy.team);
            if(!_loc3_ || !(_loc3_.status == TeamMemberStatus.INVITED || _loc3_.status == TeamMemberStatus.MEMBER))
            {
               _loc2_ = param1 > 0;
            }
         }
         return _loc2_;
      }
      
      public function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      private function get view() : ProfileTab
      {
         return viewComponent as ProfileTab;
      }
      
      public function get profileTeamProxy() : ProfileTeamProxy
      {
         return RTFacade.instance.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.setupView();
      }
      
      private function goToRankedTeamsView() : void
      {
         if(this.profilePlayerProxy.isLocal)
         {
         }
         this.profileDisplay.activeView = ProfileDisplayModel.RANKED_TEAMS_VIEW;
         this.profileDisplay.update();
      }
      
      private function hasInactiveOrPendingTeams() : Boolean
      {
         var _loc2_:TeamInfo = null;
         var _loc1_:Player = this.profilePlayerProxy.player;
         if(_loc1_)
         {
            for each(_loc2_ in _loc1_.playerTeams)
            {
               if(_loc2_.calculateSecondsUntilEligibleForDeletion() < Team.INACTIVE_WARNING_SECONDS)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function refreshView() : void
      {
         var _loc1_:ArrayCollection = null;
         var _loc2_:ArrayCollection = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:TeamInfo = null;
         if(this.profilePlayerProxy.player != null)
         {
            _loc1_ = this.profilePlayerProxy.memberTeams;
            _loc2_ = this.profilePlayerProxy.invitedTeams;
            _loc3_ = Boolean(_loc2_) && _loc2_.length > 0;
            _loc4_ = (_loc1_ ? _loc1_.length : 0) + (_loc2_ ? _loc2_.length : 0);
            _loc5_ = this.shouldShowDropDown(_loc4_);
            if(_loc3_)
            {
               this.view.alertIcon.setVisible(true);
               this.view.alertIcon.setCurrentState("invited");
            }
            else if(this.hasInactiveOrPendingTeams())
            {
               this.view.alertIcon.setVisible(true);
               this.view.alertIcon.setCurrentState("inactive");
            }
            else
            {
               this.view.alertIcon.setVisible(false);
            }
            this.view.dropDownIndicatorButton.setVisible(_loc5_);
            if(this.profileTeamProxy.team != null && !this.profileTeamProxy.isDataOnly)
            {
               this.view.setVisible(true);
               this.setTabTeam(TeamInfo.fromTeam(this.profileTeamProxy.team));
            }
            else
            {
               _loc6_ = false;
               if(_loc1_)
               {
                  var _loc8_:int = 0;
                  var _loc9_:* = _loc1_;
                  for each(_loc7_ in _loc9_)
                  {
                     this.setTabTeam(_loc7_);
                     _loc6_ = true;
                  }
               }
               if(!_loc6_ && Boolean(_loc2_))
               {
                  _loc8_ = 0;
                  _loc9_ = _loc2_;
                  for each(_loc7_ in _loc9_)
                  {
                     this.setTabTeam(_loc7_);
                     _loc6_ = true;
                  }
               }
               if(!_loc6_)
               {
                  this.view.setVisible(this.profilePlayerProxy.isLocal);
                  this.setTabTeam(null);
               }
               else
               {
                  this.view.setVisible(true);
               }
            }
         }
         else
         {
            this.view.setVisible(true);
            this.view.alertIcon.setVisible(false);
            this.view.dropDownIndicatorButton.setVisible(false);
            this.view.tabText.setText(RTResource.getString("profileRTTabName"));
         }
         RTFacade.instance.rtProvider.getCreateRankedTeamButton().visible = this.profilePlayerProxy.isLocal && RTFacade.playerProxy.localAllowsRankedTeams();
      }
      
      private function onPlayerChanged(param1:INotification) : void
      {
         var _loc2_:Boolean = false;
         if(param1.getBody() != null && param1.getBody() is Boolean)
         {
            _loc2_ = param1.getBody() as Boolean;
         }
         if(_loc2_)
         {
            this.goToSummonerView();
         }
         this.refreshView();
      }
      
      private function goToSummonerView() : void
      {
         RTFacade.instance.rtProvider.profileDisplayModel.activeView = ProfileDisplayModel.SUMMONER_VIEW;
         RTFacade.instance.rtProvider.profileDisplayModel.update();
      }
      
      private function onTabStateChanged(param1:Event) : void
      {
         if(this.profileDisplay.activeView == ProfileDisplayModel.RANKED_TEAMS_VIEW)
         {
            this.view.setTabSelected(true);
         }
         else
         {
            if(this.profileTeamProxy.isViewExternal)
            {
               this.profileTeamProxy.team = null;
               this.refreshView();
            }
            this.view.setTabSelected(false);
         }
      }
   }
}

