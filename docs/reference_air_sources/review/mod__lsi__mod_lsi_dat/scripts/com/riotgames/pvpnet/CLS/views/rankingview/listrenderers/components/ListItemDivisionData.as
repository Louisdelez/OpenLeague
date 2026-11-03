package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.SummonerRelationshipEnum;
   
   public class ListItemDivisionData extends StatefulView
   {
      
      private static const OTHER_PLAYER_STATE:String = "otherPlayer";
      
      private static const SELF_PLAYER_STATE:String = "selfPlayer";
      
      private var _pointsLabel:TextFieldProxy;
      
      private var _winsLabel:TextFieldProxy;
      
      public function ListItemDivisionData(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._winsLabel = new TextFieldProxy(this);
         setTimelineChildByName("winsLabel",this._winsLabel);
         this._winsLabel.setMouseEnabled(false);
         this._pointsLabel = new TextFieldProxy(this);
         setTimelineChildByName("pointsLabel",this._pointsLabel);
         this._pointsLabel.setMouseEnabled(false);
      }
      
      public function updateData(param1:ListItemObjectModel) : void
      {
         this._winsLabel.setText(param1.wins.toString());
         this._pointsLabel.setText(param1.points.toString());
         this.renderState(param1.relationship);
         this._pointsLabel.setVisible(Boolean(param1.miniSeriesResults) && param1.miniSeriesResults.length == 0);
         setVisible(!param1.tier.isApex());
      }
      
      private function renderState(param1:String) : void
      {
         if(param1 == SummonerRelationshipEnum.SELF_RELATIONSHIP)
         {
            setCurrentState(SELF_PLAYER_STATE);
         }
         else
         {
            setCurrentState(OTHER_PLAYER_STATE);
         }
      }
   }
}

