package com.riotgames.pvpnet.CLS.models
{
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueSortOrder;
   import flash.utils.Dictionary;
   
   public class RankListViewModel
   {
      
      private var _leagueName:String = "";
      
      private var _allRankListElements:Vector.<ListItemObjectModel>;
      
      private var _myRank:ListItemObjectModel;
      
      private var _rankListElements:Dictionary;
      
      public function RankListViewModel()
      {
         super();
         this._allRankListElements = new Vector.<ListItemObjectModel>();
         this._rankListElements = new Dictionary();
      }
      
      public function getListFromRank(param1:LeagueRank) : Vector.<ListItemObjectModel>
      {
         if(!this._rankListElements[param1] || (this._rankListElements[param1] as Vector.<ListItemObjectModel>).length == 0)
         {
            return null;
         }
         return this._rankListElements[param1] as Vector.<ListItemObjectModel>;
      }
      
      public function organizeListElements() : void
      {
         var _loc1_:LeagueRank = null;
         var _loc2_:ListItemObjectModel = null;
         for each(_loc1_ in LeagueRank.values(LeagueSortOrder.DESCENDING))
         {
            this._rankListElements[_loc1_] = new Vector.<ListItemObjectModel>();
         }
         for each(_loc2_ in this._allRankListElements)
         {
            (this._rankListElements[_loc2_.rank] as Vector.<ListItemObjectModel>).push(_loc2_);
         }
      }
      
      public function get myRank() : ListItemObjectModel
      {
         return this._myRank;
      }
      
      public function set myRank(param1:ListItemObjectModel) : void
      {
         this._myRank = param1;
      }
      
      public function get allRankListElements() : Vector.<ListItemObjectModel>
      {
         return this._allRankListElements;
      }
      
      public function set allRankListElements(param1:Vector.<ListItemObjectModel>) : void
      {
         this._allRankListElements = param1;
      }
      
      public function get leagueName() : String
      {
         return this._leagueName;
      }
      
      public function set leagueName(param1:String) : void
      {
         this._leagueName = param1;
      }
   }
}

