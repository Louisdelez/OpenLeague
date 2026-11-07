package com.riotgames.pvpnet.seasonrewards.views.progress
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.data.CanvasLayoutData;
   import com.riotgames.pvpnet.seasonrewards.configuration.SeasonRewardsConfig;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import com.riotgames.pvpnet.seasonrewards.models.RewardModel;
   import com.riotgames.pvpnet.seasonrewards.models.RewardTooltipModel;
   import com.riotgames.pvpnet.seasonrewards.views.RewardsFAQView.RewardsFAQView;
   import com.riotgames.pvpnet.seasonrewards.views.tooltips.RewardToolTip;
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   
   public class TeamRewardsProgressView extends StatefulView
   {
      
      private static const REWARDS_FAQ_QUESTIONS:Array = ["whatAreRewards","winsNeededOnSameTeam","winsRetroactive","notEnoughFriends","howDoBordersWork","allRewardTiers","doPointsTransfer"];
      
      private static const PRESEASON_FAQ_QUESTIONS:Array = ["preseason00","preseason01","preseason02","preseason03","preseason04","preseason05","preseason06","preseason07","preseason08"];
      
      private var rewardsTitle:TextFieldProxy;
      
      private var rewardsDescription:TextFieldProxy;
      
      private var preseasonRewardsTitle:TextFieldProxy;
      
      private var preseasonRewardsDescription:TextFieldProxy;
      
      private var progressBar:MovieClipProxy;
      
      private var rewardsContainer:SpriteProxy;
      
      private var rewardGraphic:StatefulView;
      
      private var popup:RewardsFAQView;
      
      private var localeHelper:ILocaleHelper;
      
      private var rewardPoints:int;
      
      private var currentReward:RewardModel;
      
      private var rewardModels:Vector.<RewardModel> = new Vector.<RewardModel>();
      
      private var rewardRenderers:Vector.<TeamRewardRenderer> = new Vector.<TeamRewardRenderer>();
      
      public function TeamRewardsProgressView(param1:IContext)
      {
         super(param1);
         setLinkage("RankedTeamRewards");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.localeHelper = getDependency(ILocaleHelper);
         var _loc1_:String = LeagueConfig.seasonName();
         var _loc2_:String = LeagueConfig.preseasonName();
         this.preseasonRewardsTitle = new TextFieldProxy(this);
         this.preseasonRewardsTitle.setHtmlText(this.localeHelper.localeLookup("preseason_rewards_help_title",[_loc2_]));
         setTimelineChildByName("preseasonRewardsTitle",this.preseasonRewardsTitle);
         this.preseasonRewardsDescription = new TextFieldProxy(this);
         this.preseasonRewardsDescription.setHtmlText(this.localeHelper.localeLookup("preseason_rewards_help_description",["event:faq",_loc1_,_loc2_]));
         this.preseasonRewardsDescription.addEventListener(TextEvent.LINK,this.onPreseasonFaqButtonClick);
         setTimelineChildByName("preseasonRewardsDescription",this.preseasonRewardsDescription);
         this.rewardsTitle = new TextFieldProxy(this);
         this.rewardsTitle.setHtmlText(this.localeHelper.localeLookup("season_rewards_help_title",[_loc1_]));
         setTimelineChildByName("teamRewardsTitle",this.rewardsTitle);
         this.rewardsDescription = new TextFieldProxy(this);
         this.rewardsDescription.setHtmlText(this.localeHelper.localeLookup("season_rewards_help_description",["event:faq",_loc1_]));
         this.rewardsDescription.addEventListener(TextEvent.LINK,this.onFaqButtonClick);
         setTimelineChildByName("rewardsDescription",this.rewardsDescription);
         this.progressBar = new MovieClipProxy(this);
         setTimelineChildByName("teamProgressBar",this.progressBar);
         this.rewardsContainer = new SpriteProxy(this);
         this.rewardsContainer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("rewardsContainer",this.rewardsContainer);
         this.rewardGraphic = new StatefulView(this);
         setTimelineChildByName("rewardGraphic",this.rewardGraphic);
         this.setIsPreseason(false);
      }
      
      public function setProgress(param1:int, param2:Boolean) : void
      {
         this.rewardPoints = param1;
         this.setIsPreseason(param2);
         invalidateLayout();
      }
      
      private function setIsPreseason(param1:Boolean) : void
      {
         if(param1)
         {
            setCurrentState("preseason");
         }
         else
         {
            setCurrentState("season");
         }
      }
      
      private function onFaqButtonClick(param1:TextEvent) : void
      {
         this.popup = new RewardsFAQView(this,REWARDS_FAQ_QUESTIONS);
         this.popup.selectionQuestion(0);
         this.popup.getOnClosed().addOnce(this.onFaqClosed);
         var _loc2_:CanvasLayoutData = new CanvasLayoutData();
         _loc2_.setLeft(5);
         _loc2_.setTop(5);
         _loc2_.setRight(5);
         _loc2_.setBottom(5);
         PopUpManager.addPopUp(this.popup,_loc2_,true);
      }
      
      private function onFaqClosed() : void
      {
         if(this.popup != null)
         {
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      private function onPreseasonFaqButtonClick(param1:TextEvent) : void
      {
         var _loc2_:String = this.localeHelper.localeLookup("lhMainTitlePreseason");
         this.popup = new RewardsFAQView(this,PRESEASON_FAQ_QUESTIONS,_loc2_);
         this.popup.selectionQuestion(0);
         this.popup.getOnClosed().addOnce(this.onFaqClosed);
         var _loc3_:CanvasLayoutData = new CanvasLayoutData();
         _loc3_.setLeft(5);
         _loc3_.setTop(5);
         _loc3_.setRight(5);
         _loc3_.setBottom(5);
         PopUpManager.addPopUp(this.popup,_loc3_,true);
      }
      
      private function calculatePercentage(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = Math.floor(param1 / param2 * 100);
         return _loc4_ > 0 ? _loc4_ : 1;
      }
      
      public function clearRewards() : void
      {
         this.rewardModels = new Vector.<RewardModel>();
         this.rewardRenderers = new Vector.<TeamRewardRenderer>();
         this.rewardsContainer.removeAllChildren();
      }
      
      public function addReward(param1:RewardModel) : void
      {
         var _loc2_:TeamRewardRenderer = new TeamRewardRenderer(this,param1);
         var _loc3_:RewardTooltipModel = new RewardTooltipModel();
         _loc3_.title = this.localeHelper.localeLookup(param1.rewardName);
         _loc3_.description = this.localeHelper.localeLookup(param1.rewardDescription,[param1.rewardCost]);
         _loc3_.icon = param1.rewardIcon;
         TipsProviderProxy.instance.assignCustomToolTip(_loc2_,_loc3_,RewardToolTip);
         this.rewardsContainer.addChild(_loc2_);
         this.rewardModels.push(param1);
         this.rewardRenderers.push(_loc2_);
         _loc2_.getMouseIsOverChanged().add(this.onRewardRendererMouseOverChanged);
      }
      
      private function onRewardRendererMouseOverChanged(param1:TeamRewardRenderer) : void
      {
         var _loc3_:RewardModel = null;
         var _loc2_:String = SeasonRewardsConfig.REWARD_ICONS[1];
         if(param1.getMouseIsOver())
         {
            _loc3_ = param1.getModel() as RewardModel;
            _loc2_ = _loc3_.rewardIcon;
            if(_loc3_ == this.currentReward)
            {
               _loc2_ += "selected";
            }
         }
         else if(this.currentReward)
         {
            _loc2_ = this.currentReward.rewardIcon + "selected";
         }
         this.rewardGraphic.setCurrentState(_loc2_);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this.rewardModels.length == 0)
         {
            this.progressBar.gotoAndStop(1);
         }
         else
         {
            this.updateProgressAndRewards();
         }
         return super.updateLayout(param1,param2);
      }
      
      private function updateProgressAndRewards() : void
      {
         var _loc2_:RewardModel = null;
         var _loc7_:Number = NaN;
         var _loc8_:TeamRewardRenderer = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc1_:RewardModel = this.rewardModels[this.rewardModels.length - 1];
         this.currentReward = null;
         var _loc3_:int = this.calculatePercentage(this.rewardPoints,_loc1_.rewardCost);
         this.progressBar.gotoAndStop(_loc3_);
         var _loc4_:Number = 0;
         var _loc5_:Number = Number(this.rewardsContainer.getWidth());
         var _loc6_:uint = 0;
         while(_loc6_ < this.rewardModels.length)
         {
            _loc7_ = Math.floor(_loc4_);
            _loc8_ = this.rewardRenderers[_loc6_];
            _loc8_.setExplicitPosition(_loc7_,NaN);
            _loc4_ = _loc5_ * (this.rewardModels[_loc6_].rewardCost / _loc1_.rewardCost);
            _loc8_.setExplicitSize(Math.floor(_loc4_) - _loc7_,NaN);
            _loc8_.setEarned(false);
            if(this.rewardPoints >= this.rewardModels[_loc6_].rewardCost)
            {
               _loc9_ = "#ba9c68";
               if(this.rewardModels.length == _loc6_ + 1 || this.rewardPoints < this.rewardModels[_loc6_ + 1].rewardCost)
               {
                  this.currentReward = this.rewardModels[_loc6_];
                  this.rewardGraphic.setCurrentState(this.currentReward.rewardIcon + "selected");
                  _loc9_ = "#32843d";
               }
               _loc8_.setLabel("<font color=\'" + _loc9_ + "\'>" + this.localeHelper.localeLookup("reward_unlocked_label") + "</font>");
               this.rewardRenderers[_loc6_].setEarned(true);
            }
            else if(_loc2_ == null)
            {
               _loc2_ = this.rewardModels[_loc6_];
               _loc10_ = this.localeHelper.localeLookup("team_reward_progress",[this.rewardPoints,_loc2_.rewardCost]);
               _loc8_.setLabel("<font color=\'#000000\'>" + this.localeHelper.localeLookup("reward_label",[_loc10_]) + "</font>");
            }
            else
            {
               _loc8_.setLabel("<font color=\'#000000\'>" + this.localeHelper.localeLookup("reward_locked_label") + "</font>");
            }
            _loc8_.setIndex(_loc6_);
            _loc6_++;
         }
      }
   }
}

