package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.PromotionSeriesResultsEnum;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.tooltip.SingleLineToolTip;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ListItemMiniSeriesGames extends SpriteProxy
   {
      
      private const FIRST_GAME_INDEX:uint = 0;
      
      private const LAST_GAME_INDEX:uint = 4;
      
      private const TOTAL_GAMES:uint = 5;
      
      private const GAMES_TO_PLAY_TIER_ONE:uint = 5;
      
      private const GAMES_TO_PLAY_LOWER_TIERS:uint = 3;
      
      private var _miniSeriesGameIcons:Vector.<StatefulView>;
      
      private var _tooltipModel:EmblemModel;
      
      private var _tooltip:SingleLineToolTip;
      
      private var _tooltipHandler:EmblemsToolTipHandler;
      
      private var _titles:Array;
      
      private var _localeHelper:ILocaleHelper;
      
      public function ListItemMiniSeriesGames(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         this._titles = new Array();
         this._titles[PromotionSeriesResultsEnum.WIN_RANK_GAME] = this._localeHelper.localeLookup("ttMeritVictory");
         this._titles[PromotionSeriesResultsEnum.LOSE_RANK_GAME] = this._localeHelper.localeLookup("ttMeritDefeat");
         this._tooltip = new SingleLineToolTip(this);
         this._tooltipModel = new EmblemModel("","");
         this._tooltipHandler = new EmblemsToolTipHandler(this._tooltip,1,0);
         this._miniSeriesGameIcons = new Vector.<StatefulView>();
         var _loc1_:uint = 0;
         while(_loc1_ < this.TOTAL_GAMES)
         {
            this._miniSeriesGameIcons[_loc1_] = new StatefulView(this);
            this._miniSeriesGameIcons[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.onPromoGamesOver);
            this._miniSeriesGameIcons[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.onPromoGamesOut);
            setTimelineChildByName("promoGameIcon" + (_loc1_ + 1),this._miniSeriesGameIcons[_loc1_]);
            _loc1_++;
         }
      }
      
      public function set updateRenderedData(param1:ListItemObjectModel) : void
      {
         var _loc2_:uint = 0;
         if(Boolean(param1.miniSeriesResults) && param1.miniSeriesResults.length > 0)
         {
            this.resetIcons();
            if(param1.rank == LeagueRank.I)
            {
               this._miniSeriesGameIcons[this.FIRST_GAME_INDEX].setVisible(true);
               this._miniSeriesGameIcons[this.LAST_GAME_INDEX].setVisible(true);
               _loc2_ = 0;
               while(_loc2_ < this.GAMES_TO_PLAY_TIER_ONE - 1)
               {
                  this._miniSeriesGameIcons[_loc2_].setCurrentState(param1.miniSeriesResults[_loc2_]);
                  _loc2_++;
               }
            }
            else
            {
               this._miniSeriesGameIcons[this.FIRST_GAME_INDEX].setVisible(false);
               this._miniSeriesGameIcons[this.LAST_GAME_INDEX].setVisible(false);
               _loc2_ = 0;
               while(_loc2_ < this.GAMES_TO_PLAY_LOWER_TIERS - 1)
               {
                  this._miniSeriesGameIcons[_loc2_ + 1].setCurrentState(param1.miniSeriesResults[_loc2_]);
                  _loc2_++;
               }
            }
         }
         setVisible(Boolean(param1.miniSeriesResults) && param1.miniSeriesResults.length > 0);
      }
      
      private function resetIcons() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.GAMES_TO_PLAY_TIER_ONE)
         {
            this._miniSeriesGameIcons[_loc1_].setCurrentState(PromotionSeriesResultsEnum.DISABLE_RANK_GAME);
            _loc1_++;
         }
      }
      
      private function onPromoGamesOver(param1:MouseEvent) : void
      {
         var _loc2_:StatefulView = param1.target as StatefulView;
         var _loc3_:String = this._titles[_loc2_.getCurrentState()];
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

