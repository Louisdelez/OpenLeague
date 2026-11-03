package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.MovieClip;
   
   public class MatchHistoryGraphMarker extends ButtonX
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _background:StatefulView;
      
      public function MatchHistoryGraphMarker(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("MatchHistoryGraphMarker");
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(NewMatchHistoryModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._background = new StatefulView(this);
         setTimelineChildByName("background",this._background);
         super.createChildren();
      }
      
      public function setAdvantageValue(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc4_:String = DateUtil.milisecondsToTimeString(param3);
         param2 = Math.abs(param2);
         if(param2 == 0)
         {
            assignToolTip(this,EMatchHistoryLocalization.getLocalizedString("newMatchHistory_evenAdvantageTooltip",[_loc4_]));
         }
         else if(param1 == this._model.getCurrentGame().searchedParticipant.teamId)
         {
            _loc5_ = this._model.getCurrentGame().searchedParticipant.player.summonerName;
            assignToolTip(this,EMatchHistoryLocalization.getLocalizedString("newMatchHistory_teamAdvantageTooltip_summonersTeam",[_loc5_,param2,_loc4_]));
         }
         else
         {
            assignToolTip(this,EMatchHistoryLocalization.getLocalizedString("newMatchHistory_teamAdvantageTooltip_otherTeam",[param2,_loc4_]));
         }
         if(param2 == 0)
         {
            this._background.setCurrentState("white");
         }
         else
         {
            this._background.setCurrentState(param1 == 100 ? "blue" : "purple");
         }
         this._background.setAlpha(1);
      }
      
      public function setTeamValue(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc4_:String = DateUtil.milisecondsToTimeString(param3);
         if(param1 == this._model.getCurrentGame().searchedParticipant.teamId)
         {
            _loc5_ = this._model.getCurrentGame().searchedParticipant.player.summonerName;
            assignToolTip(this,EMatchHistoryLocalization.getLocalizedString("newMatchHistory_teamTotalTooltip_summonersTeam",[_loc5_,param2,_loc4_]));
         }
         else
         {
            assignToolTip(this,EMatchHistoryLocalization.getLocalizedString("newMatchHistory_teamTotalTooltip_otherTeam",[param2,_loc4_]));
         }
         this._background.setAlpha(1);
         this._background.setCurrentState(param1 == 100 ? "blue" : "purple");
      }
      
      public function setParticipantValue(param1:MatchHistoryGameParticipant, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:String = DateUtil.milisecondsToTimeString(param4);
         var _loc6_:String = param1.player.summonerName;
         assignToolTip(this,EMatchHistoryLocalization.getLocalizedString("newMatchHistory_participantTotalTooltip",[_loc6_,param3,_loc5_]));
         this._background.setAlpha(1 - param2 * 0.1);
         this._background.setCurrentState(param1.teamId == 100 ? "blue" : "purple");
      }
   }
}

