package com.riotgames.platform.gameclient.controllers.game.views.voting.allteam
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionWildCardEnums;
   import com.riotgames.platform.gameclient.domain.game.ChampionVoteInfo;
   import com.riotgames.platform.gameclient.domain.game.FeaturedGameInfo;
   import flash.utils.Dictionary;
   
   public class VoteItemFactory
   {
      
      public function VoteItemFactory()
      {
         super();
      }
      
      internal static function markWinningVoteItem(param1:int, param2:Array, param3:Boolean) : VoteItem
      {
         var _loc4_:VoteItem = null;
         var _loc7_:VoteItem = null;
         var _loc8_:Array = null;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         for each(_loc4_ in param2)
         {
            if(!_loc4_.abstain)
            {
               if(_loc4_.locked)
               {
                  _loc5_.push(_loc4_);
               }
               else
               {
                  _loc6_.push(_loc4_);
               }
            }
         }
         _loc7_ = null;
         _loc8_ = _loc5_.concat(_loc6_);
         for each(_loc4_ in _loc8_)
         {
            if(_loc4_.champion.championId == param1)
            {
               _loc7_ = _loc4_;
               _loc7_.winner = true;
               break;
            }
         }
         for each(_loc4_ in param2)
         {
            _loc4_.winnerDecided = _loc7_ != null || param3;
            _loc4_.locked = _loc4_.locked || param3;
            _loc4_.allVotingComplete = param3;
         }
         return _loc7_;
      }
      
      public static function createIntermediateVoteItems(param1:Array, param2:ChampionVoteInfo, param3:FeaturedGameInfo) : Array
      {
         var _loc4_:Array = convertToVoteItems(param1,param3);
         _loc4_ = groupVoteItems(_loc4_);
         markMyVoteItem(param2,_loc4_);
         _loc4_ = prioritizeVoteItems(_loc4_);
         var _loc5_:VoteItem = findLockedMajorityChampion(_loc4_);
         if(_loc5_ != null)
         {
            updateChancesWithMajorityChampion(_loc5_,_loc4_);
            markWinningVoteItem(_loc5_.champion.championId,_loc4_,false);
         }
         return _loc4_;
      }
      
      internal static function moveMineToBack(param1:Array) : Array
      {
         var _loc3_:VoteItem = null;
         var _loc2_:int = getMineIndex(param1);
         if(_loc2_ >= 0)
         {
            _loc3_ = param1.splice(_loc2_,1)[0];
            param1.push(_loc3_);
         }
         return param1;
      }
      
      internal static function findLockedMajorityChampion(param1:Array) : VoteItem
      {
         var _loc4_:VoteItem = null;
         var _loc5_:VoteItem = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            if(!(_loc4_.locked && _loc4_.abstain))
            {
               _loc3_ += _loc4_.size;
               if(_loc4_.locked)
               {
                  _loc2_.push(_loc4_);
               }
            }
         }
         _loc5_ = null;
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.size * 2 > _loc3_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      internal static function getMineIndex(param1:Array) : int
      {
         var _loc3_:VoteItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_.mine)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      internal static function moveMineToFront(param1:Array) : Array
      {
         var _loc3_:VoteItem = null;
         var _loc2_:int = getMineIndex(param1);
         if(_loc2_ >= 0)
         {
            _loc3_ = param1.splice(_loc2_,1)[0];
            param1.unshift(_loc3_);
         }
         return param1;
      }
      
      internal static function convertToVoteItems(param1:Array, param2:FeaturedGameInfo) : Array
      {
         var _loc4_:ChampionVoteInfo = null;
         var _loc5_:Champion = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2.championVoteInfoList)
         {
            _loc5_ = param1[_loc4_.championID];
            if(_loc5_ == null)
            {
               _loc5_ = new Champion();
               _loc5_.setAsWildCardChampion(ChampionWildCardEnums.ID_ABSTAIN_CHAMPION);
            }
            _loc3_.push(createVoteItem(_loc5_,_loc4_.lockedIn,_loc4_.percentChance));
         }
         return _loc3_;
      }
      
      internal static function markMyVoteItem(param1:ChampionVoteInfo, param2:Array) : VoteItem
      {
         var _loc3_:VoteItem = null;
         if(param1 != null)
         {
            for each(_loc3_ in param2)
            {
               if(param1.championID == _loc3_.champion.championId)
               {
                  if(param1.lockedIn == _loc3_.locked)
                  {
                     _loc3_.mine = true;
                     return _loc3_;
                  }
               }
            }
         }
         return null;
      }
      
      internal static function groupVoteItems(param1:Array) : Array
      {
         var _loc4_:VoteItem = null;
         var _loc5_:Champion = null;
         var _loc6_:VoteItem = null;
         var _loc2_:Array = [];
         var _loc3_:Dictionary = new Dictionary();
         for each(_loc4_ in param1)
         {
            _loc5_ = _loc4_.champion;
            if(!_loc4_.locked || _loc5_.championId == ChampionWildCardEnums.ID_ABSTAIN_CHAMPION)
            {
               _loc2_.push(_loc4_);
            }
            else
            {
               _loc6_ = _loc3_[_loc5_.championId];
               if(_loc6_ == null)
               {
                  _loc3_[_loc5_.championId] = _loc4_;
                  _loc2_.push(_loc4_);
               }
               else
               {
                  _loc6_.chance = _loc4_.chance;
                  _loc6_.mine = _loc6_.mine || _loc4_.mine;
                  ++_loc6_.size;
               }
            }
         }
         return _loc2_;
      }
      
      private static function createVoteItem(param1:Champion, param2:Boolean, param3:Number) : VoteItem
      {
         var _loc4_:VoteItem = new VoteItem();
         _loc4_.champion = param1;
         _loc4_.locked = param2;
         _loc4_.chance = param3;
         return _loc4_;
      }
      
      internal static function updateChancesWithMajorityChampion(param1:VoteItem, param2:Array) : void
      {
         var _loc3_:VoteItem = null;
         if(param1 != null)
         {
            param1.chance = 100;
            for each(_loc3_ in param2)
            {
               if(_loc3_.chance != 100)
               {
                  _loc3_.chance = 0;
               }
            }
         }
      }
      
      public static function createFinalVoteItems(param1:int, param2:Array) : Array
      {
         var _loc3_:VoteItem = markWinningVoteItem(param1,param2,true);
         param2 = groupVoteItems(param2);
         return prioritizeVoteItems(param2,false);
      }
      
      internal static function prioritizeVoteItems(param1:Array, param2:Boolean = true) : Array
      {
         var _loc7_:VoteItem = null;
         var _loc9_:VoteItem = null;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         for each(_loc7_ in param1)
         {
            if(_loc7_.champion.championId == ChampionWildCardEnums.ID_ABSTAIN_CHAMPION)
            {
               if(_loc7_.locked)
               {
                  _loc6_.push(_loc7_);
               }
               else
               {
                  _loc5_.push(_loc7_);
               }
            }
            else if(!_loc7_.locked)
            {
               _loc4_.push(_loc7_);
            }
            else
            {
               _loc3_.push(_loc7_);
            }
         }
         if(param2)
         {
            _loc3_.sortOn(["chance"],[Array.DESCENDING | Array.NUMERIC]);
         }
         _loc5_ = moveMineToFront(_loc5_);
         _loc4_ = moveMineToFront(_loc4_);
         var _loc8_:Array = _loc3_.concat(_loc4_).concat(_loc5_).concat(_loc6_);
         if(getMineIndex(_loc8_) >= 0)
         {
            _loc9_ = _loc8_[getMineIndex(_loc8_)];
            _loc8_ = _loc9_.locked ? moveMineToFront(_loc8_) : _loc8_;
         }
         return _loc8_;
      }
   }
}

