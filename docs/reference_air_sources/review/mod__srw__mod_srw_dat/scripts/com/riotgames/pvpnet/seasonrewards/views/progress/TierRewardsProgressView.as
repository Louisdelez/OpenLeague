package com.riotgames.pvpnet.seasonrewards.views.progress
{
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   import com.riotgames.pvpnet.tips.config.RectPosition;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   
   public class TierRewardsProgressView extends StatefulView
   {
      
      private var localeHelper:ILocaleHelper;
      
      private var tooltipConfig:ToolTipConfig;
      
      private var tierRewardsTitle:Text;
      
      private var highestTierIcon:StatefulView;
      
      private var highestTierLabel:Text;
      
      private var highestTierDescription:Text;
      
      private var nextTierIcon:StatefulView;
      
      private var nextTierLabel:Text;
      
      private var nextTierDescription:Text;
      
      private var earnedTierIcon:StatefulView;
      
      private var earnedTierLabel:Text;
      
      private var earnedTierDescription:Text;
      
      private var earnedTeamRewardIcon:StatefulView;
      
      private var earnedTeamRewardLabel:Text;
      
      private var earnedTeamRewardDescription:Text;
      
      public function TierRewardsProgressView(param1:IContext)
      {
         super(param1);
         setLinkage("LeagueTierRewards");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.localeHelper = getDependency(ILocaleHelper);
         this.tooltipConfig = new ToolTipConfig();
         this.tooltipConfig.showDelay = 0;
         this.tooltipConfig.toolTipPosition = new RectPosition(RectPosition.BOTTOM_MIDDLE,RectPosition.BOTTOM_MIDDLE);
         var _loc1_:String = LeagueConfig.seasonName();
         this.tierRewardsTitle = new Text(this);
         this.tierRewardsTitle.setHtmlText(this.localeHelper.localeLookup("tier_rewards_help_title",[_loc1_]));
         setTimelineChildByName("tierRewardsTitle",this.tierRewardsTitle);
         this.highestTierIcon = new StatefulView(this);
         this.highestTierLabel = new Text(this);
         this.highestTierDescription = new Text(this);
         setTimelineChildByName("highestTierIcon",this.highestTierIcon);
         setTimelineChildByName("highestTierLabel",this.highestTierLabel);
         setTimelineChildByName("highestTierDescription",this.highestTierDescription);
         this.nextTierIcon = new StatefulView(this);
         this.nextTierLabel = new Text(this);
         this.nextTierDescription = new Text(this);
         setTimelineChildByName("nextTierIcon",this.nextTierIcon);
         setTimelineChildByName("nextTierLabel",this.nextTierLabel);
         setTimelineChildByName("nextTierDescription",this.nextTierDescription);
         this.earnedTierIcon = new StatefulView(this);
         this.earnedTierLabel = new Text(this);
         this.earnedTierDescription = new Text(this);
         setTimelineChildByName("tierRewardEarnedIcon",this.earnedTierIcon);
         setTimelineChildByName("tierRewardEarnedLabel",this.earnedTierLabel);
         setTimelineChildByName("tierRewardEarnedDescription",this.earnedTierDescription);
         this.earnedTeamRewardIcon = new StatefulView(this);
         this.earnedTeamRewardLabel = new Text(this);
         this.earnedTeamRewardDescription = new Text(this);
         setTimelineChildByName("teamRewardEarnedIcon",this.earnedTeamRewardIcon);
         setTimelineChildByName("teamRewardEarnedLabel",this.earnedTeamRewardLabel);
         setTimelineChildByName("teamRewardEarnedDescription",this.earnedTeamRewardDescription);
      }
      
      public function setRewardData(param1:LeagueTier, param2:int, param3:Boolean) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:LeagueTier = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc4_:String = this.tierToLocaleString(param1);
         var _loc5_:String = this.localeHelper.localeLookup(_loc4_);
         this.highestTierLabel.setText(this.localeHelper.localeLookup("highest_tier_title",[_loc5_]));
         this.highestTierIcon.setCurrentState(_loc4_);
         this.highestTierDescription.setHtmlText(this.localeHelper.localeLookup(_loc4_ + "_tier_reward_listing"));
         if(param3)
         {
            _loc6_ = LeagueConfig.preseasonName();
            _loc7_ = param1.isBelow(LeagueTier.BRONZE) ? "<br><br>" + this.localeHelper.localeLookup("no_tier_reward_msg",[_loc6_]) : "";
            setCurrentState("preseason");
            this.earnedTierLabel.setText(this.localeHelper.localeLookup("earned_tier_title"));
            this.earnedTierIcon.setCurrentState(_loc4_);
            this.earnedTierDescription.setHtmlText(this.localeHelper.localeLookup(_loc4_ + "_tier_reward_listing") + _loc7_);
            _loc8_ = this.localeHelper.localeLookup("reward" + param2 + "_name");
            _loc9_ = param2 > 0 ? "" : this.localeHelper.localeLookup("no_team_reward_msg",[_loc6_]);
            this.earnedTeamRewardLabel.setText(this.localeHelper.localeLookup("earned_team_reward_title"));
            this.earnedTeamRewardIcon.setCurrentState(param2.toString());
            this.earnedTeamRewardDescription.setHtmlText(this.localeHelper.localeLookup("team_reward_earned_description",[_loc8_,_loc9_]));
         }
         else if(param1 != LeagueTier.CHALLENGER)
         {
            setCurrentState("season");
            if(param1.isBelow(LeagueTier.BRONZE))
            {
               _loc10_ = LeagueTier.BRONZE;
            }
            else
            {
               _loc10_ = param1.next();
            }
            _loc11_ = this.tierToLocaleString(_loc10_);
            _loc12_ = this.localeHelper.localeLookup(_loc11_);
            this.nextTierLabel.setText(this.localeHelper.localeLookup("next_tier_title",[_loc12_]));
            this.nextTierIcon.setVisible(true);
            this.nextTierIcon.setCurrentState(_loc11_);
            this.nextTierDescription.setHtmlText(this.localeHelper.localeLookup(_loc11_ + "_tier_reward_listing"));
         }
         else
         {
            setCurrentState(_loc4_);
            this.nextTierLabel.setText("");
            this.nextTierIcon.setVisible(false);
            this.nextTierDescription.setText("");
         }
      }
      
      private function tierToLocaleString(param1:LeagueTier) : String
      {
         if(param1.isBelow(LeagueTier.BRONZE))
         {
            return "NONE";
         }
         return param1.value();
      }
   }
}

