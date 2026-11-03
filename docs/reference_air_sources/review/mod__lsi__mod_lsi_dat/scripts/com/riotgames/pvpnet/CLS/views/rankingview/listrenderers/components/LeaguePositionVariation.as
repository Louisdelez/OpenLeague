package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.RankChangeIconStatesEnum;
   import flash.display.MovieClip;
   
   public class LeaguePositionVariation extends StatefulView
   {
      
      private var _rankVariationText:TextFieldProxy;
      
      public function LeaguePositionVariation(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._rankVariationText = new TextFieldProxy(this);
         setTimelineChildByName("variationText",this._rankVariationText);
         this._rankVariationText.setMouseEnabled(false);
      }
      
      public function updateLeaguePosition(param1:ListItemObjectModel) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = int(param1.position);
            _loc3_ = param1.previousPosition - _loc2_;
            if(!param1.isInactive || Boolean(param1.tier.isApex()))
            {
               if(_loc3_ > 0 && param1.previousPosition != 0)
               {
                  this._rankVariationText.setText(_loc3_.toString());
                  setCurrentState(RankChangeIconStatesEnum.RANK_UP);
               }
               else if(_loc3_ < 0 && param1.previousPosition != 0)
               {
                  this._rankVariationText.setText(Math.abs(_loc3_).toString());
                  setCurrentState(RankChangeIconStatesEnum.RANK_DOWN);
               }
               else
               {
                  this._rankVariationText.setText("");
                  setCurrentState(RankChangeIconStatesEnum.RANK_EQUAL);
               }
            }
            else
            {
               this._rankVariationText.setText("");
               setCurrentState(RankChangeIconStatesEnum.RANK_INACTIVE);
            }
         }
         setVisible(param1 != null);
      }
   }
}

