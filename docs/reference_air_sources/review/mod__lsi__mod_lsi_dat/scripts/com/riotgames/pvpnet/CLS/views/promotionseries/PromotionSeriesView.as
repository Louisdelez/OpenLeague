package com.riotgames.pvpnet.CLS.views.promotionseries
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.PromotionSeriesResultsEnum;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.tooltip.SingleLineToolTip;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PromotionSeriesView extends StatefulView
   {
      
      private const PROMOTION_SERIES_STATE:String = "promotionSeries";
      
      private const HOW_TO_RANK_UP_STATE:String = "rankUp";
      
      private const CHALLENGER_TIER_STATE:String = "rankUp";
      
      private const MASTER_TIER_STATE:String = "rankUp";
      
      private const CHALLENGER_TIER_MODE:uint = 0;
      
      private const PROMOTION_SERIES_MODE:uint = 1;
      
      private const GAMES_TO_WIN_TIER_ONE:uint = 3;
      
      private const GAMES_TO_WIN_LOWER_TIERS:uint = 2;
      
      private const PROMOTION_SERIES_DESCRIPTION_PART1:uint = 1;
      
      private const FIRST_GAME_INDEX:uint = 0;
      
      private const LAST_GAME_INDEX:uint = 4;
      
      private const GAMES_TO_PLAY_DIVISION_ONE:uint = 5;
      
      private const MASTER_TIER_MODE:uint = 6;
      
      private var _currentMode:uint;
      
      private var _descriptions:Vector.<String>;
      
      private var miniSeriesGameResultIcon:Vector.<StatefulView>;
      
      private var _descriptionTxt:TextFieldProxy;
      
      private var _titleTxt:TextFieldProxy;
      
      private var _tooltipModel:EmblemModel;
      
      private var _tooltipHandler:EmblemsToolTipHandler;
      
      private var _localeHelper:ILocaleHelper;
      
      public function PromotionSeriesView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setCurrentState(this.HOW_TO_RANK_UP_STATE);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._currentMode = this.PROMOTION_SERIES_DESCRIPTION_PART1;
         this._localeHelper = getDependency(ILocaleHelper);
         var _loc1_:ILeagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         _loc1_.getOnReceiveRankInfoSignal().add(this.onSetSummonerRankedInfo);
         _loc1_.getOnRankRowSelectedUpdateSignal().add(this.onRankRowSelected);
         _loc1_.getOnLeagueSelectionUpdateSignal().add(this._onLeagueChange);
         _loc1_.getOnRankSelectionUpdateSignal().add(this.onRankButtonPressedSignal);
         _loc1_.getOnChallengerTierSelectionUpdateSignal().add(this._onChallengerTierChange);
         var _loc2_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("boardTitle",_loc2_);
         this._titleTxt = new TextFieldProxy(this);
         _loc2_.setTimelineChildByName("headerTitle",this._titleTxt);
         this._descriptionTxt = new TextFieldProxy(this);
         setTimelineChildByName("descriptionText",this._descriptionTxt);
         var _loc3_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("promoGames",_loc3_);
         this.miniSeriesGameResultIcon = new Vector.<StatefulView>();
         var _loc4_:uint = 0;
         while(_loc4_ < this.GAMES_TO_PLAY_DIVISION_ONE)
         {
            this.miniSeriesGameResultIcon[_loc4_] = new StatefulView(this);
            this.miniSeriesGameResultIcon[_loc4_].addEventListener(MouseEvent.MOUSE_OVER,this.onPromoGamesOver);
            this.miniSeriesGameResultIcon[_loc4_].addEventListener(MouseEvent.MOUSE_OUT,this.onPromoGamesOut);
            _loc3_.setTimelineChildByName("promoGameIcon" + (_loc4_ + 1),this.miniSeriesGameResultIcon[_loc4_]);
            _loc4_++;
         }
         var _loc5_:SingleLineToolTip = new SingleLineToolTip(this);
         this._tooltipModel = new EmblemModel("","");
         this._tooltipHandler = new EmblemsToolTipHandler(_loc5_,1,0);
         _loc1_.dispatchOnAskRankInfoSignal();
      }
      
      public function onRankRowSelected(param1:ListItemObjectModel, param2:Boolean) : void
      {
         setVisible(true);
         this.onSetSummonerRankedInfo(param1);
      }
      
      public function onSetSummonerRankedInfo(param1:ListItemObjectModel) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         if(this._currentMode == this.CHALLENGER_TIER_MODE || !param1)
         {
            this.setGenericChallengerDescription();
            return;
         }
         if(this._currentMode == this.MASTER_TIER_MODE)
         {
            this.setGenericMasterDescription();
            return;
         }
         this.resetIcons();
         setVisible(true);
         var _loc2_:Boolean = param1.rank == LeagueRank.I;
         var _loc3_:uint = _loc2_ ? this.GAMES_TO_WIN_TIER_ONE : this.GAMES_TO_WIN_LOWER_TIERS;
         if(param1.miniSeriesResults != null && param1.miniSeriesResults.length > 0)
         {
            setCurrentState(this.PROMOTION_SERIES_STATE);
            this._titleTxt.setText(this._localeHelper.localeLookup("pswPromoSeriesTitle"));
            _loc4_ = _loc2_ ? 0 : 1;
            this.miniSeriesGameResultIcon[this.FIRST_GAME_INDEX].setVisible(_loc2_);
            this.miniSeriesGameResultIcon[this.LAST_GAME_INDEX].setVisible(_loc2_);
            _loc5_ = 0;
            while(_loc5_ < this.GAMES_TO_PLAY_DIVISION_ONE - 1)
            {
               this.miniSeriesGameResultIcon[_loc5_ + _loc4_].setCurrentState(param1.miniSeriesResults[_loc5_]);
               if(param1.miniSeriesResults[_loc5_] == PromotionSeriesResultsEnum.WIN_RANK_GAME)
               {
                  _loc3_--;
               }
               _loc5_++;
            }
            this.setPromotionSeriesDescription(_loc3_,param1.isTeam);
         }
         else
         {
            if(param1.isInactive)
            {
               this.setDecayingDescription();
            }
            else if(param1.tier)
            {
               this.setHowToRankUpDescription(param1.tier,param1.rank);
            }
            setCurrentState(this.HOW_TO_RANK_UP_STATE);
         }
         this._descriptionTxt.setVisible(true);
      }
      
      private function resetIcons() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.GAMES_TO_PLAY_DIVISION_ONE)
         {
            this.miniSeriesGameResultIcon[_loc1_].setCurrentState(PromotionSeriesResultsEnum.DISABLE_RANK_GAME);
            _loc1_++;
         }
      }
      
      private function setGenericChallengerDescription() : void
      {
         setCurrentState(this.HOW_TO_RANK_UP_STATE);
         this._titleTxt.setText(this._localeHelper.localeLookup("pswChallengerTitle"));
         this._descriptionTxt.setText(this._localeHelper.localeLookup("pswChallengerDesc"));
         this._descriptionTxt.setVisible(true);
      }
      
      private function setGenericMasterDescription() : void
      {
         setCurrentState(this.HOW_TO_RANK_UP_STATE);
         this._titleTxt.setText(this._localeHelper.localeLookup("pswMasterTitle"));
         this._descriptionTxt.setText(this._localeHelper.localeLookup("pswMasterDesc"));
         this._descriptionTxt.setVisible(true);
      }
      
      private function setDecayingDescription() : void
      {
         this._titleTxt.setText(this._localeHelper.localeLookup("pswDecayingTitle"));
         this._descriptionTxt.setHtmlText(this._localeHelper.localeLookup("pswDecayingDesc"));
      }
      
      private function setHowToRankUpDescription(param1:LeagueTier, param2:LeagueRank) : void
      {
         var _loc3_:LeagueTier = param1.next();
         this._titleTxt.setText(this._localeHelper.localeLookup("pswRankUpTitle"));
         if(param2 == LeagueRank.I)
         {
            this._descriptionTxt.setText(this._localeHelper.localeLookup("pswHighTierDesc",[this._localeHelper.localeLookup(_loc3_.value()),this._localeHelper.localeLookup("pswRank")]));
         }
         else
         {
            this._descriptionTxt.setText(this._localeHelper.localeLookup("pswLowTierDesc",[param2.next().value()]));
         }
      }
      
      private function setPromotionSeriesDescription(param1:uint, param2:Boolean) : void
      {
         if(param2)
         {
            this._descriptionTxt.setText(this._localeHelper.localeLookup("pswPromoSeriesDescTeam",[param1]));
         }
         else
         {
            this._descriptionTxt.setText(this._localeHelper.localeLookup("pswPromoSeriesDesc",[param1]));
         }
      }
      
      private function _onLeagueChange(param1:SummonerLeagueObjectModel) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.tier == LeagueTier.MASTER)
         {
            this._currentMode = this.MASTER_TIER_MODE;
            setCurrentState(this.MASTER_TIER_STATE);
            this._descriptionTxt.setVisible(true);
            this._titleTxt.setText(this._localeHelper.localeLookup("pswMasterTitle"));
            this._descriptionTxt.setText(this._localeHelper.localeLookup("pswMasterDesc"));
         }
         else
         {
            this._currentMode = this.PROMOTION_SERIES_MODE;
         }
         this.onSetSummonerRankedInfo(param1.elements.myRank);
      }
      
      private function _onChallengerTierChange(param1:Vector.<ListItemObjectModel>) : void
      {
         this._currentMode = this.CHALLENGER_TIER_MODE;
         setCurrentState(this.CHALLENGER_TIER_STATE);
         this._descriptionTxt.setVisible(true);
         this._titleTxt.setText(this._localeHelper.localeLookup("pswChallengerTitle"));
         this._descriptionTxt.setText(this._localeHelper.localeLookup("pswChallengerDesc"));
      }
      
      private function onRankButtonPressedSignal(param1:RankListViewModel, param2:LeagueRank) : void
      {
         this.onSetSummonerRankedInfo(param1.myRank);
      }
      
      private function onPromoGamesOver(param1:MouseEvent) : void
      {
         var _loc2_:StatefulView = param1.target as StatefulView;
         var _loc3_:String = "";
         if(_loc2_.getCurrentState() == PromotionSeriesResultsEnum.WIN_RANK_GAME)
         {
            _loc3_ = this._localeHelper.localeLookup("ttMeritVictory");
         }
         else if(_loc2_.getCurrentState() == PromotionSeriesResultsEnum.LOSE_RANK_GAME)
         {
            _loc3_ = this._localeHelper.localeLookup("ttMeritDefeat");
         }
         if(_loc3_)
         {
            this._tooltipModel.title = _loc3_;
            this._tooltipModel.description = " ";
            assignToolTip(_loc2_,this._tooltipModel,this._tooltipHandler);
         }
      }
      
      private function onPromoGamesOut(param1:MouseEvent) : void
      {
         var _loc2_:StatefulView = param1.target as StatefulView;
         unassignToolTip(_loc2_);
      }
   }
}

