package com.riotgames.platform.gameclient.module.rt.view.history
{
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   
   public class MatchHistoryListData
   {
      
      public var details:EndOfGameStats;
      
      private var _isSelected:Boolean = false;
      
      public var summary:MatchHistorySummary;
      
      public var isSelectedChanged:Signal = new Signal();
      
      public function MatchHistoryListData(param1:MatchHistorySummary)
      {
         super();
         this.summary = param1;
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         if(this._isSelected != param1)
         {
            this._isSelected = param1;
            this.isSelectedChanged.dispatch(this);
         }
      }
   }
}

