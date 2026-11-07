package com.riotgames.pvpnet.CLS.views.rankingview.dropdownrenderers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   
   public class LeagueDropdownItemRenderer extends StatefulView
   {
      
      private var _icon:StatefulView;
      
      private var _textField:TextFieldProxy;
      
      private var _selectedBar:SpriteProxy;
      
      private var _mouseOverState:Boolean = false;
      
      public function LeagueDropdownItemRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("QueueDropdownRenderer");
         this._selectedBar.setVisible(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._icon = new StatefulView(this);
         setTimelineChildByName("rankIcon",this._icon);
         this._textField = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._textField);
         this._selectedBar = new SpriteProxy(this);
         setTimelineChildByName("selectedBar",this._selectedBar);
      }
      
      public function setData(param1:*) : void
      {
         var _loc2_:SummonerLeagueObjectModel = null;
         if(param1.league)
         {
            setMouseIsOver(false);
            _loc2_ = param1.league as SummonerLeagueObjectModel;
            if(this._icon.getCurrentState() != _loc2_.tier.value())
            {
               this._icon.setCurrentState(_loc2_.tier.value());
            }
         }
         else
         {
            this._icon.setCurrentState(LeagueTier.CHALLENGER.value());
         }
         this._textField.setText(param1.label);
      }
      
      public function toggleMouseOverState() : void
      {
         this._mouseOverState = !this._mouseOverState;
         if(this._mouseOverState)
         {
            setCurrentState("over");
         }
         else
         {
            setCurrentState("up");
         }
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this._selectedBar.setVisible(param1);
      }
   }
}

