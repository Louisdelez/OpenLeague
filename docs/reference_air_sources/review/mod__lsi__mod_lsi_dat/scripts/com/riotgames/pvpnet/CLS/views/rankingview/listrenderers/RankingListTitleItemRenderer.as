package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.models.RankRowTitleModel;
   import com.riotgames.pvpnet.CLS.views.enums.RankItemsStateEnum;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.tooltip.SingleLineToolTip;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.display.MovieClip;
   
   public class RankingListTitleItemRenderer extends StatefulView
   {
      
      private const NB_TITLES:uint = 5;
      
      private var _titles:Vector.<TextFieldProxy>;
      
      private var _tooltipHandler:EmblemsToolTipHandler;
      
      private var _localeHelper:ILocaleHelper;
      
      public function RankingListTitleItemRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("RankListTitleRenderer");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         var _loc1_:SingleLineToolTip = new SingleLineToolTip(this);
         this._tooltipHandler = new EmblemsToolTipHandler(_loc1_,1,0);
         this._titles = new Vector.<TextFieldProxy>();
         var _loc2_:uint = 0;
         while(_loc2_ < this.NB_TITLES)
         {
            this._titles[_loc2_] = new AutoSizeTextFieldProxy(this);
            setTimelineChildByName("title" + _loc2_,this._titles[_loc2_]);
            _loc2_++;
         }
      }
      
      public function setData(param1:RankRowTitleModel) : void
      {
         var _loc2_:TextFieldProxy = null;
         var _loc3_:String = null;
         for each(_loc2_ in this._titles)
         {
            unassignToolTip(_loc2_);
         }
         _loc3_ = this._localeHelper.localeLookup("ttSummonersColumnHeader",[param1.title]);
         if(this._tooltipHandler)
         {
            switch(param1.type)
            {
               case RankItemsStateEnum.TITLE_NORMAL:
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_NORMAL_TEAMS:
                  _loc3_ = this._localeHelper.localeLookup("ttTeamsColumnHeader",[param1.title]);
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_PROMO_3:
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPromotionColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_PROMO_5:
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPromotionColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_CHALLENGE_TIER:
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinLossColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_CHALLENGE_TIER_TEAMS:
                  _loc3_ = this._localeHelper.localeLookup("ttTeamsColumnHeader",[param1.title]);
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinLossColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_TOP_MASTER_TIER:
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinLossColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_TOP_MASTER_TIER_TEAMS:
                  _loc3_ = this._localeHelper.localeLookup("ttTeamsColumnHeader",[param1.title]);
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinLossColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_APEX:
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinLossColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_APEX_TEAMS:
                  _loc3_ = this._localeHelper.localeLookup("ttTeamsColumnHeader",[param1.title]);
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinLossColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_PROMO_APEX:
                  assignToolTip(this._titles[1],new EmblemModel(_loc3_,""),this._tooltipHandler);
                  assignToolTip(this._titles[2],new EmblemModel(this._localeHelper.localeLookup("ttEmblemsColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[3],new EmblemModel(this._localeHelper.localeLookup("ttWinLossColumnHeader"),""),this._tooltipHandler);
                  assignToolTip(this._titles[4],new EmblemModel(this._localeHelper.localeLookup("ttPointsColumnHeader"),""),this._tooltipHandler);
                  break;
               case RankItemsStateEnum.TITLE_EMPTY:
                  _loc3_ = "";
            }
         }
         setCurrentState(param1.type);
         this._tooltipHandler.destroyToolTip();
      }
      
      public function update(param1:String, param2:String) : void
      {
         var _loc3_:Boolean = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
         if(param1 != getCurrentState())
         {
            setAlpha(0);
            if(param1 == RankItemsStateEnum.TITLE_CHALLENGE_TIER || param1 == RankItemsStateEnum.TITLE_CHALLENGE_TIER_TEAMS)
            {
               this.setData(new RankRowTitleModel(param1,this._localeHelper.localeLookup("rhvChallenger")));
            }
            else if(param1 == RankItemsStateEnum.TITLE_TOP_MASTER_TIER || param1 == RankItemsStateEnum.TITLE_TOP_MASTER_TIER_TEAMS)
            {
               this.setData(new RankRowTitleModel(param1,this._localeHelper.localeLookup("rhvMaster")));
            }
            else if(param1 == RankItemsStateEnum.TITLE_APEX || param1 == RankItemsStateEnum.TITLE_APEX_TEAMS || param1 == RankItemsStateEnum.TITLE_PROMO_APEX)
            {
               this.setData(new RankRowTitleModel(param1,this._localeHelper.localeLookup("rhvMaster")));
            }
            else if(param1 == RankItemsStateEnum.TITLE_EMPTY)
            {
               this.setData(new RankRowTitleModel(param1,""));
            }
            else if(param2.length > 0)
            {
               this.setData(new RankRowTitleModel(param1,this._localeHelper.getLeagueName(param2)));
            }
            setVisible(true);
            TweenLite.killTweensOf(this);
            TweenLite.to(getSetterProxy(),_loc3_ ? 0.5 : 0,{"alpha":1});
         }
         else if(getAlpha() < 0.01)
         {
            setVisible(true);
            TweenLite.killTweensOf(this);
            TweenLite.to(getSetterProxy(),_loc3_ ? 0.5 : 0,{"alpha":1});
         }
      }
      
      public function hide() : void
      {
         TweenLite.killTweensOf(this);
         setAlpha(0);
         setVisible(false);
      }
   }
}

