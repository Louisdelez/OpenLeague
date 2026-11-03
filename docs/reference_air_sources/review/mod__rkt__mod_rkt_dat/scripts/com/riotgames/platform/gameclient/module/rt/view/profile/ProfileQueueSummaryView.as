package com.riotgames.platform.gameclient.module.rt.view.profile
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.TwistedTreelineSummary;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.Context;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatDetail;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.system.leagues.ProfileUtils;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   
   public class ProfileQueueSummaryView extends StatefulView
   {
      
      private var ineligibleWarning:SpriteProxy;
      
      private var totalLossesText:TextFieldProxy;
      
      private var topRatingNumberText:TextFieldProxy;
      
      private var decayWarning:StatefulView;
      
      private var totalWinsText:TextFieldProxy;
      
      private var totalWinsAmount:TextFieldProxy;
      
      private var queueText:TextFieldProxy;
      
      private var leaguePointsAmount:TextFieldProxy;
      
      private var topRatingTitleText:TextFieldProxy;
      
      private var medal:StatefulView;
      
      private var rankText:TextFieldProxy;
      
      private var leaguePointsText:TextFieldProxy;
      
      public function ProfileQueueSummaryView(param1:Context)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this));
         var _loc1_:TwistedTreelineSummary = new TwistedTreelineSummary();
         this.queueText = _loc1_.queueText.create(this);
         this.rankText = _loc1_.rankText.create(this);
         this.totalWinsText = new TextFieldProxy(this);
         this.totalLossesText = new TextFieldProxy(this);
         this.setTimelineChildByName("totalWinsText",this.totalWinsText);
         this.setTimelineChildByName("totalLossesText",this.totalLossesText);
         this.medal = new StatefulView(this);
         this.setTimelineChildByName("medal",this.medal);
         this.topRatingTitleText = new TextFieldProxy(this);
         this.setTimelineChildByName("topRatingTitleText",this.topRatingTitleText);
         this.topRatingNumberText = new TextFieldProxy(this);
         this.setTimelineChildByName("topRatingNumberText",this.topRatingNumberText);
         this.leaguePointsText = new TextFieldProxy(this);
         this.setTimelineChildByName("leaguePointsText",this.leaguePointsText);
         this.leaguePointsAmount = new TextFieldProxy(this);
         this.setTimelineChildByName("leaguePointsAmount",this.leaguePointsAmount);
         this.totalWinsAmount = new TextFieldProxy(this);
         this.setTimelineChildByName("totalWinsAmount",this.totalWinsAmount);
         this.ineligibleWarning = new SpriteProxy(this);
         this.setTimelineChildByName("ineligibleWarning",this.ineligibleWarning);
         this.ineligibleWarning.setVisible(false);
         this.decayWarning = new StatefulView(this);
         this.setTimelineChildByName("decayWarning",this.decayWarning);
         this.decayWarning.setVisible(false);
         this.setStats(null);
      }
      
      public function setStats(param1:TeamStatDetail) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:LeagueTier = null;
         var _loc5_:LeagueRank = null;
         if(param1)
         {
            _loc2_ = param1.wins + param1.losses + param1.leaves;
            _loc3_ = _loc2_ >= ProfileUtils.MIN_RANKED_GAMES_FOR_LEAGUES[param1.teamStatType];
            _loc4_ = LeagueTier.NULL;
            _loc5_ = LeagueRank.DEFAULT;
            setVisible(true);
            this.ineligibleWarning.setVisible(false);
            this.decayWarning.setVisible(false);
            this.queueText.setText(RTResource.getString("queueName" + param1.teamStatType));
            if(_loc3_)
            {
               if(ClientConfig.instance.leagueServiceEnabled)
               {
                  if(Boolean(param1.isLeague) && param1.league != null)
                  {
                     if(DynamicClientConfigManager.getConfiguration("SeasonReward","QualificationWarningEnabled",false).getValue())
                     {
                        this.ineligibleWarning.setVisible(!param1.isEligibleForRewardsFromTeam);
                        assignToolTip(this.ineligibleWarning,RiotResourceLoader.getString("rankedTeams_notQualifiedForRewardsTooltip",null,[param1.numberOfGamesNeededForEligibility]));
                     }
                     else
                     {
                        this.ineligibleWarning.setVisible(false);
                     }
                     if(param1.decayWarningLevel > 0)
                     {
                        this.decayWarning.setVisible(true);
                        this.decayWarning.setCurrentState("level" + param1.decayWarningLevel);
                        assignToolTip(this.decayWarning,RiotResourceLoader.getString("demotionShieldLevel" + param1.decayWarningLevel + "Warning"));
                     }
                     else
                     {
                        this.decayWarning.setVisible(false);
                        unassignToolTip(this.decayWarning);
                     }
                     this.rankText.setText(RiotResourceLoader.getString("profile_devision_display",null,[RiotResourceLoader.getString("leagues_rank_" + param1.league.tier,"**" + param1.league.tier),RiotResourceLoader.getString("leagues_tier_" + param1.league.requestorsRank,"**" + param1.league.requestorsRank)]));
                     this.topRatingNumberText.setText("");
                     if(!LeagueTier.valueOf(param1.league.tier).isApex())
                     {
                        this.topRatingTitleText.setText(param1.league.name);
                     }
                     else
                     {
                        this.topRatingTitleText.setText("");
                     }
                     _loc4_ = LeagueTier.valueOf(param1.league.tier);
                     _loc5_ = LeagueRank.valueOf(param1.league.requestorsRank);
                  }
                  else
                  {
                     _loc4_ = LeagueTier.NULL;
                     this.ineligibleWarning.setVisible(false);
                     unassignToolTip(this.ineligibleWarning);
                     this.decayWarning.setVisible(false);
                     unassignToolTip(this.decayWarning);
                     this.rankText.setText("");
                     this.topRatingNumberText.setText("");
                     this.topRatingTitleText.setText(RTResource.getString("profileQueueHiddenLeaguePlacement"));
                  }
               }
               else
               {
                  _loc4_ = LeagueTier.NULL;
                  this.rankText.setText("");
                  this.topRatingNumberText.setText("");
                  this.topRatingTitleText.setText(RTResource.getString("profileTopRating"));
               }
            }
            else
            {
               if(_loc2_ > 0)
               {
                  _loc4_ = LeagueTier.PROVISIONAL;
               }
               else
               {
                  _loc4_ = LeagueTier.NULL;
               }
               this.rankText.setText(RTResource.getString("profileQueueHiddenRating",[_loc2_.toString(),ProfileUtils.MIN_RANKED_GAMES_FOR_LEAGUES[param1.teamStatType]]));
               this.topRatingTitleText.setText(RTResource.getString("profileQueueHiddenLeaguePlacement"));
               this.topRatingNumberText.setText("");
            }
            setCurrentState(_loc4_.value());
            this.medal.setCurrentState(_loc5_.value());
            if(Boolean(param1.isLeague) && param1.league != null)
            {
               this.totalWinsText.setText(RTResource.getString("profileTotalWins"));
               this.totalWinsAmount.setText(param1.wins.toString());
               this.leaguePointsText.setText(RTResource.getString("profileLeaguePoints"));
               this.leaguePointsAmount.setText(param1.leaguePoints.toString());
            }
            else
            {
               this.totalWinsText.setText(RTResource.getString("profileTotalWins"));
               this.totalWinsAmount.setText(param1.wins.toString());
               this.leaguePointsText.setText("");
               this.leaguePointsAmount.setText("");
            }
            this.totalLossesText.setText(RTResource.getString("profileTotalGames",[param1.wins + param1.losses]));
         }
         else
         {
            setVisible(false);
         }
      }
   }
}

