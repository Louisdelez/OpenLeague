package com.riotgames.platform.gameclient.controllers.game.views.voting.oneteam
{
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   
   public class VotePlayerSelectionUtils
   {
      
      public function VotePlayerSelectionUtils()
      {
         super();
      }
      
      public static function getVoteChancesForPlayerSelections(param1:ArrayCollection) : Dictionary
      {
         var _loc4_:PlayerSelection = null;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc7_:Dictionary = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Dictionary = new Dictionary();
         for each(_loc4_ in param1)
         {
            if(_loc4_.champion != null && !_loc4_.champion.isWildCardChampion())
            {
               _loc2_++;
               if(_loc3_[_loc4_.champion.championId] == null)
               {
                  _loc3_[_loc4_.champion.championId] = 1;
               }
               else
               {
                  _loc3_[_loc4_.champion.championId] = int(_loc3_[_loc4_.champion.championId]) + 1;
               }
            }
         }
         _loc5_ = NaN;
         for(_loc6_ in _loc3_)
         {
            _loc8_ = int(_loc3_[_loc6_]);
            if(_loc8_ * 2 > _loc2_)
            {
               _loc5_ = int(_loc6_);
               break;
            }
         }
         _loc7_ = new Dictionary();
         if(!isNaN(_loc5_))
         {
            for each(_loc4_ in param1)
            {
               if(_loc4_.champion != null && !_loc4_.champion.isWildCardChampion())
               {
                  _loc7_[_loc4_] = _loc4_.champion.championId == _loc5_ ? 100 : 0;
               }
            }
         }
         else
         {
            _loc9_ = 100 / _loc2_;
            for each(_loc4_ in param1)
            {
               if(_loc4_.champion != null && !_loc4_.champion.isWildCardChampion())
               {
                  _loc10_ = _loc9_ * int(_loc3_[_loc4_.champion.championId]);
                  _loc7_[_loc4_] = _loc10_;
               }
            }
         }
         return _loc7_;
      }
   }
}

