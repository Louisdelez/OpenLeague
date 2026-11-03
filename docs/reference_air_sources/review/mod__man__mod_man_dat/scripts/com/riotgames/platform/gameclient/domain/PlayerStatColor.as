package com.riotgames.platform.gameclient.domain
{
   import com.degrafa.paint.SolidFill;
   
   public class PlayerStatColor
   {
      
      private static var _fills:Object;
      
      public static var STAT_COLOR:Object = [];
      
      STAT_COLOR[RawStatType.TOTAL_PLAYER_SCORE] = 7340185;
      STAT_COLOR[RawStatType.OBJECTIVE_PLAYER_SCORE] = 25343;
      STAT_COLOR[RawStatType.COMBAT_PLAYER_SCORE] = 16711680;
      STAT_COLOR[RawStatType.NODE_CAPTURE] = 3363839;
      STAT_COLOR[RawStatType.NODE_CAPTURE_ASSIST] = 473343;
      STAT_COLOR[RawStatType.NODE_NEUTRALIZE] = 17843;
      STAT_COLOR[RawStatType.NODE_NEUTRALIZE_ASSIST] = 1212851;
      STAT_COLOR[RawStatType.TEAM_OBJECTIVE] = 826088;
      STAT_COLOR[RawStatType.NODE_KILL_OFFENSE] = 3387903;
      STAT_COLOR[RawStatType.NODE_KILL_DEFENSE] = 911615;
      STAT_COLOR[RawStatType.CHAMPION_KILLS] = 15215628;
      STAT_COLOR[RawStatType.DEATHS] = 16732941;
      STAT_COLOR[RawStatType.ASSISTS] = 16711680;
      STAT_COLOR[RawStatType.LARGEST_KILLING_SPREE] = 15207546;
      STAT_COLOR[RawStatType.LARGEST_MULTI_KILL] = 16715263;
      STAT_COLOR[RawStatType.TOTAL_DAMAGE_DEALT_TO_CHAMPIONS] = 14355456;
      STAT_COLOR[RawStatType.PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS] = 15870464;
      STAT_COLOR[RawStatType.MAGIC_DAMAGE_DEALT_TO_CHAMPIONS] = 14368512;
      STAT_COLOR[RawStatType.TOTAL_DAMAGE_DEALT] = 14355456;
      STAT_COLOR[RawStatType.PHYSICAL_DAMAGE_DEALT_PLAYER] = 15870464;
      STAT_COLOR[RawStatType.MAGIC_DAMAGE_DEALT_PLAYER] = 14368512;
      STAT_COLOR[RawStatType.TURRETS_KILLED] = 6402048;
      STAT_COLOR[RawStatType.BARRACKS_KILLED] = 10315013;
      STAT_COLOR[RawStatType.LARGEST_CRITICAL_STRIKE] = 16743731;
      STAT_COLOR[RawStatType.FIRST_BLOOD] = 10308880;
      STAT_COLOR[RawStatType.TOTAL_HEAL] = 6489832;
      STAT_COLOR[RawStatType.TOTAL_DAMAGE_TAKEN] = 10881023;
      STAT_COLOR[RawStatType.PHYSICAL_DAMAGE_TAKEN] = 13371112;
      STAT_COLOR[RawStatType.MAGIC_DAMAGE_TAKEN] = 16713676;
      STAT_COLOR[RawStatType.GOLD_EARNED] = 16776960;
      STAT_COLOR[RawStatType.MINIONS_KILLED] = 16768819;
      STAT_COLOR[RawStatType.NEUTRAL_MINIONS_KILLED] = 10321680;
      STAT_COLOR[RawStatType.TOTAL_TIME_SPENT_DEAD] = 14540253;
      STAT_COLOR[RawStatType.LEVEL] = 16490240;
      
      public function PlayerStatColor()
      {
         super();
      }
      
      public static function get fills() : Object
      {
         var _loc1_:String = null;
         if(_fills)
         {
            return _fills;
         }
         _fills = {};
         for(_loc1_ in STAT_COLOR)
         {
            _fills[getColor(_loc1_)] = new SolidFill(getColor(_loc1_));
         }
         return _fills;
      }
      
      public static function getFill(param1:String) : SolidFill
      {
         return SolidFill(fills[getColor(param1)]);
      }
      
      public static function getColor(param1:String) : uint
      {
         return uint(STAT_COLOR[param1]);
      }
   }
}

