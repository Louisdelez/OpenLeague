package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.SummonerRelationshipEnum;
   
   public class ListItemPlayerOrTeamName extends StatefulView
   {
      
      private static const OTHER_PLAYER_STATE:String = "otherPlayer";
      
      private static const SELF_PLAYER_STATE:String = "selfPlayer";
      
      private static const AVATAR_DISPLACEMENT:uint = 140;
      
      private static const TEAM_DISPLACEMENT:uint = 106;
      
      private var _playerNameLabel:TextFieldProxy;
      
      public function ListItemPlayerOrTeamName(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._playerNameLabel = new TextFieldProxy(this);
         setTimelineChildByName("playerNameLabel",this._playerNameLabel);
         this._playerNameLabel.setMouseEnabled(false);
      }
      
      public function setPlayerOrTeamName(param1:ListItemObjectModel) : void
      {
         this._playerNameLabel.setText(param1.name);
         this.setState(param1.relationship);
         this.updatePositionForTeams(param1.isTeam);
      }
      
      private function updatePositionForTeams(param1:Boolean) : void
      {
         if(param1)
         {
            this._playerNameLabel.setX(TEAM_DISPLACEMENT);
         }
         else
         {
            this._playerNameLabel.setX(AVATAR_DISPLACEMENT);
         }
      }
      
      private function setState(param1:String) : void
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
      
      public function get playerNameLabel() : TextFieldProxy
      {
         return this._playerNameLabel;
      }
   }
}

