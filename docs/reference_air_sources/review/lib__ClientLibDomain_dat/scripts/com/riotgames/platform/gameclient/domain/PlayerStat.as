package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.utils.ObjectUtil;
   
   [RemoteClass]
   public class PlayerStat extends EventDispatcher
   {
      
      private static var STAT_PRIORITY:Object = [];
      
      private static var CATEGORY_MEMBERSHIP:Object = [];
      
      STAT_PRIORITY[RawStatType.TOTAL_PLAYER_SCORE] = 1;
      STAT_PRIORITY[RawStatType.OBJECTIVE_PLAYER_SCORE] = 2;
      STAT_PRIORITY[RawStatType.COMBAT_PLAYER_SCORE] = 3;
      STAT_PRIORITY[RawStatType.NODE_CAPTURE] = 2;
      STAT_PRIORITY[RawStatType.NODE_CAPTURE_ASSIST] = 3;
      STAT_PRIORITY[RawStatType.NODE_NEUTRALIZE] = 4;
      STAT_PRIORITY[RawStatType.NODE_NEUTRALIZE_ASSIST] = 5;
      STAT_PRIORITY[RawStatType.TEAM_OBJECTIVE] = 6;
      STAT_PRIORITY[RawStatType.NODE_KILL_OFFENSE] = 7;
      STAT_PRIORITY[RawStatType.NODE_KILL_DEFENSE] = 8;
      STAT_PRIORITY[RawStatType.CHAMPION_KILLS] = 2;
      STAT_PRIORITY[RawStatType.DEATHS] = 3;
      STAT_PRIORITY[RawStatType.ASSISTS] = 4;
      STAT_PRIORITY[RawStatType.LARGEST_KILLING_SPREE] = 5;
      STAT_PRIORITY[RawStatType.LARGEST_MULTI_KILL] = 6;
      STAT_PRIORITY[RawStatType.FIRST_BLOOD] = 8;
      STAT_PRIORITY[RawStatType.TOTAL_DAMAGE_DEALT_TO_CHAMPIONS] = 1;
      STAT_PRIORITY[RawStatType.PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS] = 2;
      STAT_PRIORITY[RawStatType.MAGIC_DAMAGE_DEALT_TO_CHAMPIONS] = 3;
      STAT_PRIORITY[RawStatType.TOTAL_DAMAGE_DEALT] = 4;
      STAT_PRIORITY[RawStatType.PHYSICAL_DAMAGE_DEALT_PLAYER] = 5;
      STAT_PRIORITY[RawStatType.MAGIC_DAMAGE_DEALT_PLAYER] = 6;
      STAT_PRIORITY[RawStatType.LARGEST_CRITICAL_STRIKE] = 7;
      STAT_PRIORITY[RawStatType.TOTAL_HEAL] = 1;
      STAT_PRIORITY[RawStatType.TOTAL_DAMAGE_TAKEN] = 2;
      STAT_PRIORITY[RawStatType.PHYSICAL_DAMAGE_TAKEN] = 3;
      STAT_PRIORITY[RawStatType.MAGIC_DAMAGE_TAKEN] = 4;
      STAT_PRIORITY[RawStatType.GOLD_EARNED] = 1;
      STAT_PRIORITY[RawStatType.TURRETS_KILLED] = 2;
      STAT_PRIORITY[RawStatType.BARRACKS_KILLED] = 3;
      STAT_PRIORITY[RawStatType.MINIONS_KILLED] = 4;
      STAT_PRIORITY[RawStatType.NEUTRAL_MINIONS_KILLED] = 5;
      STAT_PRIORITY[RawStatType.TOTAL_TIME_SPENT_DEAD] = 6;
      CATEGORY_MEMBERSHIP[RawStatType.TOTAL_PLAYER_SCORE] = PlayerStatCategory.SCORE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.OBJECTIVE_PLAYER_SCORE] = PlayerStatCategory.SCORE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.COMBAT_PLAYER_SCORE] = PlayerStatCategory.SCORE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.NODE_CAPTURE] = PlayerStatCategory.OBJECTIVE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.NODE_CAPTURE_ASSIST] = PlayerStatCategory.OBJECTIVE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.NODE_NEUTRALIZE] = PlayerStatCategory.OBJECTIVE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.NODE_NEUTRALIZE_ASSIST] = PlayerStatCategory.OBJECTIVE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.TEAM_OBJECTIVE] = PlayerStatCategory.OBJECTIVE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.NODE_KILL_OFFENSE] = PlayerStatCategory.OBJECTIVE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.NODE_KILL_DEFENSE] = PlayerStatCategory.OBJECTIVE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.CHAMPION_KILLS] = PlayerStatCategory.COMBAT_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.DEATHS] = PlayerStatCategory.COMBAT_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.ASSISTS] = PlayerStatCategory.COMBAT_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.LARGEST_KILLING_SPREE] = PlayerStatCategory.COMBAT_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.LARGEST_MULTI_KILL] = PlayerStatCategory.COMBAT_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.FIRST_BLOOD] = PlayerStatCategory.COMBAT_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.TOTAL_DAMAGE_DEALT] = PlayerStatCategory.DAMAGE_DONE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.TOTAL_DAMAGE_DEALT_TO_CHAMPIONS] = PlayerStatCategory.DAMAGE_DONE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS] = PlayerStatCategory.DAMAGE_DONE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.MAGIC_DAMAGE_DEALT_TO_CHAMPIONS] = PlayerStatCategory.DAMAGE_DONE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.PHYSICAL_DAMAGE_DEALT_PLAYER] = PlayerStatCategory.DAMAGE_DONE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.MAGIC_DAMAGE_DEALT_PLAYER] = PlayerStatCategory.DAMAGE_DONE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.LARGEST_CRITICAL_STRIKE] = PlayerStatCategory.DAMAGE_DONE_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.TOTAL_HEAL] = PlayerStatCategory.DAMAGE_TAKEN_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.TOTAL_DAMAGE_TAKEN] = PlayerStatCategory.DAMAGE_TAKEN_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.PHYSICAL_DAMAGE_TAKEN] = PlayerStatCategory.DAMAGE_TAKEN_CATEGORY;
      CATEGORY_MEMBERSHIP[RawStatType.MAGIC_DAMAGE_TAKEN] = PlayerStatCategory.DAMAGE_TAKEN_CATEGORY;
      
      private var _priority:int = 2147483647;
      
      private var _statCategory:PlayerStatCategory;
      
      private var _displayName:String;
      
      private var _value:Number;
      
      private var _statTypeName:String;
      
      public function PlayerStat(param1:String = "blank", param2:Number = 0)
      {
         super();
         this._value = param2;
         this.statTypeName = param1;
      }
      
      public static function priorityCompareFunction(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:PlayerStat = param1 as PlayerStat;
         var _loc5_:PlayerStat = param2 as PlayerStat;
         var _loc6_:int = 0;
         if(!_loc4_)
         {
            return -1;
         }
         if(!_loc5_)
         {
            return 1;
         }
         if(!_loc4_ && !_loc5_)
         {
            return 0;
         }
         _loc6_ = int(ObjectUtil.numericCompare(_loc4_.statCategory.priority,_loc5_.statCategory.priority));
         if(_loc6_ == 0)
         {
            return ObjectUtil.numericCompare(_loc4_.priority,_loc5_.priority);
         }
         return _loc6_;
      }
      
      public static function valueCompareFunction(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:PlayerStat = param1 as PlayerStat;
         var _loc5_:PlayerStat = param2 as PlayerStat;
         if(!_loc4_)
         {
            return -1;
         }
         if(!_loc5_)
         {
            return 1;
         }
         if(!_loc4_ && !_loc5_)
         {
            return 0;
         }
         return ObjectUtil.numericCompare(_loc4_.value,_loc5_.value);
      }
      
      public static function findStat(param1:String, param2:ArrayCollection, param3:Boolean = false) : PlayerStat
      {
         var _loc5_:ArrayCollection = null;
         var _loc6_:PlayerStat = null;
         var _loc4_:PlayerStat = null;
         if(param2 == null)
         {
            return null;
         }
         if(!param3)
         {
            for each(_loc6_ in param2)
            {
               if(_loc6_.statTypeName == param1)
               {
                  _loc4_ = _loc6_;
                  break;
               }
            }
         }
         else
         {
            for each(_loc6_ in param2.source)
            {
               if(_loc6_.statTypeName == param1)
               {
                  _loc4_ = _loc6_;
                  break;
               }
            }
         }
         return _loc4_;
      }
      
      public function get statTypeName() : String
      {
         return this._statTypeName;
      }
      
      public function get statCategory() : PlayerStatCategory
      {
         return this._statCategory;
      }
      
      [Bindable(event="propertyChange")]
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this.displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      private function set _1714148973displayName(param1:String) : void
      {
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function set value(param1:Number) : void
      {
         var _loc2_:Object = this.value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set statTypeName(param1:String) : void
      {
         this._statTypeName = param1;
         this._displayName = RiotResourceLoader.getStatResourceString(this.statTypeName,"**" + this.statTypeName);
         if(Boolean(CATEGORY_MEMBERSHIP[this.statTypeName]) && PlayerStatCategory.CATEGORIES.hasOwnProperty(CATEGORY_MEMBERSHIP[this.statTypeName]))
         {
            this._statCategory = new PlayerStatCategory(CATEGORY_MEMBERSHIP[this.statTypeName]);
         }
         else
         {
            this._statCategory = new PlayerStatCategory();
         }
         if(Boolean(STAT_PRIORITY[this.statTypeName]))
         {
            this._priority = STAT_PRIORITY[this.statTypeName];
         }
      }
      
      private function set _111972721value(param1:Number) : void
      {
         this._value = param1;
      }
   }
}

