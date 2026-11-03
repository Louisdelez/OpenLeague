package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   
   public class ListItemChallengerData extends StatefulView
   {
      
      private var _pointsLabel:TextFieldProxy;
      
      private var _winsLossesLabel:TextFieldProxy;
      
      private var _apexIcon:StatefulView;
      
      public function ListItemChallengerData(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._pointsLabel = new TextFieldProxy(this);
         setTimelineChildByName("pointsLabel",this._pointsLabel);
         this._pointsLabel.setMouseEnabled(false);
         this._winsLossesLabel = new TextFieldProxy(this);
         setTimelineChildByName("winsLossesLabel",this._winsLossesLabel);
         this._winsLossesLabel.setMouseEnabled(false);
         this._apexIcon = new StatefulView(this);
         setTimelineChildByName("apexIcon",this._apexIcon);
      }
      
      public function updateData(param1:ListItemObjectModel) : void
      {
         if(param1.tier.isApex())
         {
            this._winsLossesLabel.setText(param1.wins + "/" + param1.losses);
            this._pointsLabel.setText(param1.points.toString());
            if(param1.apexPendingDemotion)
            {
               this._apexIcon.setCurrentState("demote");
            }
            else if(param1.apexPendingPromotion)
            {
               this._apexIcon.setCurrentState("promote");
            }
            else
            {
               this._apexIcon.setCurrentState("none");
            }
         }
         else
         {
            this._apexIcon.setCurrentState("none");
         }
         setVisible(param1.tier.isApex());
      }
   }
}

