package com.riotgames.pvpnet.CLS.views.seemorestatsview
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import flash.events.MouseEvent;
   
   public class SeeMoreStatsView extends StatefulView
   {
      
      private var _title:TextFieldProxy;
      
      private var _backButton:ButtonX;
      
      private var _backButtonText:TextFieldProxy;
      
      private var _summonerNameTxt:TextFieldProxy;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      public function SeeMoreStatsView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._title = new TextFieldProxy(this);
         setTimelineChildByName("titletxt",this._title);
         this._backButton = new ButtonX(this);
         setTimelineChildByName("backButton",this._backButton);
         this._backButtonText = new TextFieldProxy(this);
         this._backButton.setTimelineChildByName("label",this._backButtonText);
         this._summonerNameTxt = new TextFieldProxy(this);
         setTimelineChildByName("summonerNameTxt",this._summonerNameTxt);
         this._backButton.addEventListener(MouseEvent.CLICK,this.onBackButtonClicked);
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getOnSeeMoreStatsPressed().add(this.onSeeMoreStats);
      }
      
      private function onSeeMoreStats(param1:String, param2:String, param3:String) : void
      {
         setVisible(true);
         this._summonerNameTxt.setText(param1);
      }
      
      private function onBackButtonClicked(param1:MouseEvent) : void
      {
         setVisible(false);
      }
   }
}

