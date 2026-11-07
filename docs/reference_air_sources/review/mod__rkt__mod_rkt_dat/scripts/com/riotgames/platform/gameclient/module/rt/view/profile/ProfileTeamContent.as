package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.screen_profile.TeamProfileView;
   import blix.components.button.ButtonX;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.chat.domain.Buddy;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatDetail;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatType;
   import com.riotgames.platform.gameclient.domain.systemstates.TeamRewardQaulificationVO;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ProfileTeamContent extends FlashFlexComponent
   {
      
      private var gamesPlayedText:TextFieldProxy;
      
      private var queue1:ProfileQueueSummaryView;
      
      private var roster:Vector.<ProfileRosterItemView> = new Vector.<ProfileRosterItemView>();
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var nameText:TextFieldProxy;
      
      private var queue2:ProfileQueueSummaryView;
      
      public var leaveButton:ButtonX;
      
      private var captain:ProfileRosterItemView;
      
      private var establishedText:TextFieldProxy;
      
      private var tagText:TextFieldProxy;
      
      public var inviteAllButton:ButtonX;
      
      private var lastGameText:TextFieldProxy;
      
      public function ProfileTeamContent(param1:RTContext)
      {
         super(param1,"rt.TeamProfileView");
         var _loc2_:TeamProfileView = new TeamProfileView();
         this.tagText = _loc2_.tagText.create(this.view);
         this.nameText = _loc2_.nameText.create(this.view);
         this.establishedText = _loc2_.establishedText.create(this.view);
         this.gamesPlayedText = _loc2_.gamesPlayedText.create(this.view);
         this.lastGameText = _loc2_.lastGameText.create(this.view);
         this.captain = this.wireRosterItem("captain");
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            this.roster[_loc3_] = this.wireRosterItem("roster" + _loc3_);
            _loc3_++;
         }
         this.queue1 = this.wireQueueSummary("summary1");
         this.queue2 = this.wireQueueSummary("summary2");
         this.leaveButton = param1.viewUtil.wireButton(this.view,_loc2_.leaveTeamButton,null);
         this.inviteAllButton = param1.viewUtil.wireButton(this.view,_loc2_.inviteAllChatButton,null);
         this.inviteAllButton.setVisible(false);
      }
      
      public function showTeam(param1:Team) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:TeamMemberInfo = null;
         if(param1)
         {
            this.tagText.setText(param1.getFormattedTag());
            this.nameText.setText(param1.name);
            this.establishedText.setText(RTResource.getString("profileEstablished",[param1.createDate ? DateUtil.getDateString(param1.createDate) : ""]));
            this.lastGameText.setText(RTResource.getString("profileLastGame",[param1.lastGameDate ? DateUtil.getDateString(param1.lastGameDate) : ""]));
            _loc2_ = 0;
            _loc3_ = false;
            _loc4_ = Number(RTFacade.instance.rtProvider.session.summoner.sumId);
            for each(_loc5_ in param1.roster.memberList)
            {
               if(_loc5_.playerId == _loc4_)
               {
                  _loc3_ = _loc5_.status == TeamMemberStatus.MEMBER;
               }
            }
            this.leaveButton.setVisible(_loc3_);
            this.inviteAllButton.setVisible(_loc3_);
            this.showStats(param1);
         }
      }
      
      private function showStats(param1:Team) : void
      {
         var _loc6_:TeamStatDetail = null;
         var _loc7_:TeamRewardQaulificationVO = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(Boolean(param1.teamStatSummary) && Boolean(param1.teamStatSummary.teamStatDetails))
         {
            for each(_loc6_ in param1.teamStatSummary.teamStatDetails)
            {
               if(ClientConfig.instance.leagueServiceEnabled)
               {
                  _loc6_.isLeague = true;
                  _loc6_.league = ServiceProxy.instance.leagueService.cache.getLeagueDataFromTeamCache(param1.name,_loc6_.teamStatType);
                  _loc6_.leaguePoints = ServiceProxy.instance.leagueService.cache.getLeaguePointsFromTeamCache(param1.name,_loc6_.teamStatType);
                  _loc7_ = ServiceProxy.instance.leagueService.cache.getIsQualifiedForRewardsFromTeam(param1.teamId.fullId,_loc6_.teamStatType);
                  _loc6_.isEligibleForRewardsFromTeam = _loc7_.qualifiedTierReward;
                  _loc6_.numberOfGamesNeededForEligibility = _loc7_.gameWinForReward;
                  _loc6_.decayWarningLevel = ServiceProxy.instance.leagueService.cache.getDemotionWarning(param1.teamId.fullId,_loc6_.teamStatType);
               }
               _loc2_ += _loc6_.wins;
               _loc2_ += _loc6_.losses;
               if(_loc6_.teamStatType == TeamStatType.RANKED_TEAM_3x3)
               {
                  this.queue1.setStats(_loc6_);
                  _loc4_ = true;
               }
               else if(_loc6_.teamStatType == TeamStatType.RANKED_TEAM_5x5)
               {
                  this.queue2.setStats(_loc6_);
                  _loc5_ = true;
               }
               else
               {
                  this.logger.warn("unsupported queue type " + _loc6_.teamStatType + " in ProfileTeamContent");
               }
            }
         }
         if(!_loc4_)
         {
            this.queue1.setStats(null);
         }
         if(!_loc5_)
         {
            this.queue2.setStats(null);
         }
         this.gamesPlayedText.setText(RTResource.getString("profileGamesPlayed",[_loc2_ + _loc3_]));
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context);
      }
      
      public function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
      
      private function wireRosterItem(param1:String) : ProfileRosterItemView
      {
         var _loc2_:ProfileRosterItemView = new ProfileRosterItemView(this.view);
         this.view.setTimelineChildByName(param1,_loc2_);
         return _loc2_;
      }
      
      public function showTeamRoster(param1:Team, param2:Array) : void
      {
         var _loc4_:TeamMemberInfo = null;
         var _loc5_:ProfileRosterItemData = null;
         var _loc6_:Buddy = null;
         var _loc3_:int = 0;
         if(Boolean(param1) && Boolean(param1.roster))
         {
            for each(_loc4_ in param1.roster.memberList)
            {
               _loc5_ = new ProfileRosterItemData(_loc4_);
               for each(_loc6_ in param2)
               {
                  if(_loc6_.getSummonerId() == _loc4_.playerId)
                  {
                     _loc5_.buddy = _loc6_;
                  }
               }
               if(_loc4_.playerId == param1.roster.ownerId)
               {
                  this.captain.setTeamMember(_loc5_);
               }
               else if(_loc4_.status == TeamMemberStatus.MEMBER)
               {
                  this.roster[_loc3_].setTeamMember(_loc5_);
                  _loc3_++;
               }
            }
         }
         while(_loc3_ < this.roster.length)
         {
            this.roster[_loc3_].setTeamMember(null);
            _loc3_++;
         }
      }
      
      private function wireQueueSummary(param1:String) : ProfileQueueSummaryView
      {
         var _loc2_:ProfileQueueSummaryView = new ProfileQueueSummaryView(this.view);
         this.view.setTimelineChildByName(param1,_loc2_);
         return _loc2_;
      }
   }
}

