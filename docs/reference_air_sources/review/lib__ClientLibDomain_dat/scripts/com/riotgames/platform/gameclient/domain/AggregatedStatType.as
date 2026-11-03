package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.AggregatedStatType")]
   public class AggregatedStatType implements IEventDispatcher
   {
      
      private static var enumMap:Dictionary;
      
      public static const GAMES_PLAYED:String = "TOTAL_SESSIONS_PLAYED";
      
      public static const STAT_TYPE_LOSSES:String = "TOTAL_SESSIONS_LOST";
      
      public static const STAT_TYPE_WINS:String = "TOTAL_SESSIONS_WON";
      
      public static const STAT_TYPE_TOTAL_CHAMPION_KILLS:String = "TOTAL_CHAMPION_KILLS";
      
      public static const TOTAL_DAMAGE_DEALT:String = "TOTAL_DAMAGE_DEALT";
      
      public static const STAT_TYPE_TOTAL_CHAMPION_DEATHS:String = "TOTAL_DEATHS_PER_SESSION";
      
      public static const TOTAL_ASSISTS:String = "TOTAL_ASSISTS";
      
      public static const STAT_TYPE_LEAVES:String = "TOTAL_LEAVES";
      
      public static const TOTAL_FIRST_BLOOD:String = "TOTAL_FIRST_BLOOD";
      
      public static const TOTAL_TIME_SPENT_DEAD:String = "TOTAL_TIME_SPENT_DEAD";
      
      public static const TOTAL_DOUBLE_KILLS:String = "TOTAL_DOUBLE_KILLS";
      
      public static const TOTAL_GOLD_EARNED:String = "TOTAL_GOLD_EARNED";
      
      public static const MOST_CHAMPION_KILLS_PER_SESSION:String = "MOST_CHAMPION_KILLS_PER_SESSION";
      
      public static const MAX_NUM_DEATHS:String = "MAX_NUM_DEATHS";
      
      public static const TOTAL_MAGIC_DAMAGE_DEALT:String = "TOTAL_MAGIC_DAMAGE_DEALT";
      
      public static const TOTAL_PHYSICAL_DAMAGE_DEALT:String = "TOTAL_PHYSICAL_DAMAGE_DEALT";
      
      public static const TOTAL_DAMAGE_TAKEN:String = "TOTAL_DAMAGE_TAKEN";
      
      public static const TOTAL_MINION_KILLS:String = "TOTAL_MINION_KILLS";
      
      public static const TOTAL_NEUTRAL_MINION_KILLS:String = "TOTAL_NEUTRAL_MINIONS_KILLED";
      
      public static const TOTAL_PENTA_KILLS:String = "TOTAL_PENTA_KILLS";
      
      public static const TOTAL_QUADRA_KILLS:String = "TOTAL_QUADRA_KILLS";
      
      public static const TOTAL_TRIPLE_KILLS:String = "TOTAL_TRIPLE_KILLS";
      
      public static const TOTAL_TURRETS_KILLED:String = "TOTAL_TURRETS_KILLED";
      
      public static const LARGEST_KILLING_SPREE:String = "MAX_LARGEST_KILLING_SPREE";
      
      public static const LARGEST_CRITICAL_STRIKE:String = "MAX_LARGEST_CRITICAL_STRIKE";
      
      public static const HEALTH_RESTORED:String = "TOTAL_HEAL";
      
      public static const LONGEST_TIME_PLAYED:String = "MAX_TIME_PLAYED";
      
      public static const MAX_CHAMPIONS_KILLED:String = "MAX_CHAMPIONS_KILLED";
      
      public static const AVERAGE_NODE_CAPTURE:String = "AVERAGE_NODE_CAPTURE";
      
      public static const AVERAGE_NODE_NEUTRALIZE:String = "AVERAGE_NODE_NEUTRALIZE";
      
      public static const AVERAGE_NODE_CAPTURE_ASSIST:String = "AVERAGE_NODE_CAPTURE_ASSIST";
      
      public static const AVERAGE_NODE_NEUTRALIZE_ASSIST:String = "AVERAGE_NODE_NEUTRALIZE_ASSIST";
      
      public static const AVERAGE_TEAM_OBJECTIVE:String = "AVERAGE_TEAM_OBJECTIVE";
      
      public static const AVERAGE_TOTAL_PLAYER_SCORE:String = "AVERAGE_TOTAL_PLAYER_SCORE";
      
      public static const AVERAGE_COMBAT_PLAYER_SCORE:String = "AVERAGE_COMBAT_PLAYER_SCORE";
      
      public static const AVERAGE_OBJECTIVE_PLAYER_SCORE:String = "AVERAGE_OBJECTIVE_PLAYER_SCORE";
      
      public static const AVERAGE_CHAMPIONS_KILLED:String = "AVERAGE_CHAMPIONS_KILLED";
      
      public static const AVERAGE_NUM_DEATHS:String = "AVERAGE_NUM_DEATHS";
      
      public static const AVERAGE_ASSISTS:String = "AVERAGE_ASSISTS";
      
      public static const MAX_NODE_CAPTURE:String = "MAX_NODE_CAPTURE";
      
      public static const MAX_NODE_NEUTRALIZE:String = "MAX_NODE_NEUTRALIZE";
      
      public static const MAX_NODE_NEUTRALIZE_ASSIST:String = "MAX_NODE_NEUTRALIZE_ASSIST";
      
      public static const MAX_NODE_CAPTURE_ASSIST:String = "MAX_NODE_CAPTURE_ASSIST";
      
      public static const MAX_TEAM_OBJECTIVE:String = "MAX_TEAM_OBJECTIVE";
      
      public static const MAX_TOTAL_PLAYER_SCORE:String = "MAX_TOTAL_PLAYER_SCORE";
      
      public static const MAX_COMBAT_PLAYER_SCORE:String = "MAX_COMBAT_PLAYER_SCORE";
      
      public static const MAX_OBJECTIVE_PLAYER_SCORE:String = "MAX_OBJECTIVE_PLAYER_SCORE";
      
      public static const TOTAL_NODE_CAPTURE:String = "TOTAL_NODE_CAPTURE";
      
      public static const TOTAL_NODE_NEUTRALIZE:String = "TOTAL_NODE_NEUTRALIZE";
      
      public static const MAX_ASSISTS:String = "MAX_ASSISTS";
      
      public static const TOTAL:String = "TOTAL";
      
      public static const AVERAGE:String = "AVERAGE";
      
      public static const MAX:String = "MAX";
      
      public static const OTHER:String = "OTHER";
      
      public static const INCREMENT:String = "INCREMENT";
      
      private var _1714148973displayName:String;
      
      private var _3373707name:String;
      
      private var _2000742958assocRawStatTypeCode:Number;
      
      private var _180925649calcType:String;
      
      private var _1724546052description:String;
      
      private var _1084588407doChampionCalc:int;
      
      private var _3059181code:Number;
      
      private var _3355id:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AggregatedStatType()
      {
         super();
      }
      
      public static function getByName(param1:String) : AggregatedStatType
      {
         if(!enumMap)
         {
            initializeEnumMap();
         }
         return enumMap[param1];
      }
      
      private static function createStatType(param1:String, param2:int, param3:String, param4:String, param5:Boolean, param6:Boolean, param7:int) : AggregatedStatType
      {
         var _loc8_:AggregatedStatType = new AggregatedStatType();
         _loc8_.name = param1;
         _loc8_.code = param2;
         _loc8_.displayName = param3;
         _loc8_.calcType = param4;
         _loc8_.doChampionCalc = param5 ? 1 : 0;
         _loc8_.assocRawStatTypeCode = param7;
         return _loc8_;
      }
      
      private static function initializeEnumMap() : void
      {
         enumMap = new Dictionary();
         enumMap[GAMES_PLAYED] = createStatType(GAMES_PLAYED,1,"Games Played",OTHER,true,true,0);
         enumMap[STAT_TYPE_LOSSES] = createStatType(STAT_TYPE_LOSSES,2,"Games Lost",INCREMENT,true,true,25);
         enumMap[STAT_TYPE_WINS] = createStatType(STAT_TYPE_WINS,3,"Games Won",INCREMENT,true,true,23);
         enumMap[STAT_TYPE_TOTAL_CHAMPION_KILLS] = createStatType(STAT_TYPE_TOTAL_CHAMPION_KILLS,4,"Champions Killed",TOTAL,true,true,8);
         enumMap[TOTAL_DAMAGE_DEALT] = createStatType(TOTAL_DAMAGE_DEALT,6,"Damage Dealt",TOTAL,true,true,10);
         enumMap[TOTAL_DAMAGE_TAKEN] = createStatType(TOTAL_DAMAGE_TAKEN,7,"Damage Taken",TOTAL,true,true,11);
         enumMap[MOST_CHAMPION_KILLS_PER_SESSION] = createStatType(MOST_CHAMPION_KILLS_PER_SESSION,8,"Most Champions Killed in Game",MAX,true,true,8);
         enumMap[TOTAL_MINION_KILLS] = createStatType(TOTAL_MINION_KILLS,9,"Minions Killed",TOTAL,true,true,7);
         enumMap[TOTAL_DOUBLE_KILLS] = createStatType(TOTAL_DOUBLE_KILLS,10,"Double Kills",TOTAL,true,true,16);
         enumMap[TOTAL_TRIPLE_KILLS] = createStatType(TOTAL_TRIPLE_KILLS,11,"Triple Kills",TOTAL,true,true,17);
         enumMap[TOTAL_QUADRA_KILLS] = createStatType(TOTAL_QUADRA_KILLS,12,"Quadra Kills",TOTAL,true,true,18);
         enumMap[TOTAL_PENTA_KILLS] = createStatType(TOTAL_PENTA_KILLS,13,"Penta Kills",TOTAL,true,true,19);
         enumMap[STAT_TYPE_TOTAL_CHAMPION_DEATHS] = createStatType(STAT_TYPE_TOTAL_CHAMPION_DEATHS,14,"Deaths Per Game",TOTAL,true,true,4);
         enumMap[TOTAL_GOLD_EARNED] = createStatType(TOTAL_GOLD_EARNED,16,"Gold Earned",TOTAL,true,true,2);
         enumMap[TOTAL_TURRETS_KILLED] = createStatType(TOTAL_TURRETS_KILLED,23,"Turrets Destroyed",TOTAL,true,true,6);
         enumMap[TOTAL_PHYSICAL_DAMAGE_DEALT] = createStatType(TOTAL_PHYSICAL_DAMAGE_DEALT,26,"Total Physical Damage Dealt",TOTAL,true,true,31);
         enumMap[TOTAL_MAGIC_DAMAGE_DEALT] = createStatType(TOTAL_MAGIC_DAMAGE_DEALT,27,"Total Magic Damage Dealt",TOTAL,true,true,32);
         enumMap[TOTAL_NEUTRAL_MINION_KILLS] = createStatType(TOTAL_NEUTRAL_MINION_KILLS,29,"Total Neutral Minions Killed",TOTAL,false,true,28);
         enumMap[TOTAL_FIRST_BLOOD] = createStatType(TOTAL_FIRST_BLOOD,32,"Total First Blood",OTHER,true,true,50);
         enumMap[TOTAL_ASSISTS] = createStatType(TOTAL_ASSISTS,34,"Total Assists",TOTAL,true,true,48);
         enumMap[TOTAL_TIME_SPENT_DEAD] = createStatType(TOTAL_TIME_SPENT_DEAD,35,"Total Time Spent Dead",TOTAL,true,true,42);
         enumMap[HEALTH_RESTORED] = createStatType(HEALTH_RESTORED,44,"Total Heal",TOTAL,false,true,43);
         enumMap[LARGEST_KILLING_SPREE] = createStatType(LARGEST_KILLING_SPREE,46,"Largest Killing Spree",MAX,false,true,22);
         enumMap[LARGEST_CRITICAL_STRIKE] = createStatType(LARGEST_CRITICAL_STRIKE,47,"Largest Critical Strike",MAX,false,true,39);
         enumMap[MAX_CHAMPIONS_KILLED] = createStatType(MAX_CHAMPIONS_KILLED,48,"Max Champions Killed",MAX,true,true,8);
         enumMap[MAX_NUM_DEATHS] = createStatType(MAX_NUM_DEATHS,49,"Max Number Of Deaths",MAX,true,true,4);
         enumMap[LONGEST_TIME_PLAYED] = createStatType(LONGEST_TIME_PLAYED,50,"Longest Time Played",MAX,false,true,40);
         enumMap[STAT_TYPE_LEAVES] = createStatType(STAT_TYPE_LEAVES,52,"Total Leaves",INCREMENT,false,true,53);
         enumMap[AVERAGE_NODE_CAPTURE] = createStatType(AVERAGE_NODE_CAPTURE,1000,"avg node capture",AVERAGE,false,true,RawStatType.getCode(RawStatType.NODE_CAPTURE));
         enumMap[AVERAGE_NODE_NEUTRALIZE] = createStatType(AVERAGE_NODE_NEUTRALIZE,1001,"avg node neutralize",AVERAGE,false,true,RawStatType.getCode(RawStatType.NODE_NEUTRALIZE));
         enumMap[AVERAGE_TEAM_OBJECTIVE] = createStatType(AVERAGE_TEAM_OBJECTIVE,1002,"avg team objective",AVERAGE,false,true,RawStatType.getCode(RawStatType.TEAM_OBJECTIVE));
         enumMap[AVERAGE_TOTAL_PLAYER_SCORE] = createStatType(AVERAGE_TOTAL_PLAYER_SCORE,1003,"avg total player score",AVERAGE,false,true,RawStatType.getCode(RawStatType.TOTAL_PLAYER_SCORE));
         enumMap[AVERAGE_COMBAT_PLAYER_SCORE] = createStatType(AVERAGE_COMBAT_PLAYER_SCORE,1004,"avg combat player score",AVERAGE,false,true,RawStatType.getCode(RawStatType.COMBAT_PLAYER_SCORE));
         enumMap[AVERAGE_OBJECTIVE_PLAYER_SCORE] = createStatType(AVERAGE_OBJECTIVE_PLAYER_SCORE,1005,"avg objective player score",AVERAGE,false,true,RawStatType.getCode(RawStatType.OBJECTIVE_PLAYER_SCORE));
         enumMap[AVERAGE_NODE_CAPTURE_ASSIST] = createStatType(AVERAGE_NODE_CAPTURE_ASSIST,1006,"avg node capture assist",AVERAGE,false,true,RawStatType.getCode(RawStatType.NODE_CAPTURE_ASSIST));
         enumMap[AVERAGE_NODE_NEUTRALIZE_ASSIST] = createStatType(AVERAGE_NODE_NEUTRALIZE_ASSIST,1007,"avg node neutralize assist",AVERAGE,false,true,RawStatType.getCode(RawStatType.NODE_NEUTRALIZE_ASSIST));
         enumMap[MAX_NODE_CAPTURE] = createStatType(MAX_NODE_CAPTURE,1020,"max node capture",MAX,false,true,RawStatType.getCode(RawStatType.NODE_CAPTURE));
         enumMap[MAX_NODE_NEUTRALIZE] = createStatType(MAX_NODE_NEUTRALIZE,1021,"max node neutralize",MAX,false,true,RawStatType.getCode(RawStatType.NODE_NEUTRALIZE));
         enumMap[MAX_TEAM_OBJECTIVE] = createStatType(MAX_TEAM_OBJECTIVE,1022,"max team objective",MAX,false,true,RawStatType.getCode(RawStatType.TEAM_OBJECTIVE));
         enumMap[MAX_TOTAL_PLAYER_SCORE] = createStatType(MAX_TOTAL_PLAYER_SCORE,1023,"max total player score",MAX,false,true,RawStatType.getCode(RawStatType.TOTAL_PLAYER_SCORE));
         enumMap[MAX_COMBAT_PLAYER_SCORE] = createStatType(MAX_COMBAT_PLAYER_SCORE,1024,"max combat player score",MAX,false,true,RawStatType.getCode(RawStatType.COMBAT_PLAYER_SCORE));
         enumMap[MAX_OBJECTIVE_PLAYER_SCORE] = createStatType(MAX_OBJECTIVE_PLAYER_SCORE,1025,"max objective player score",MAX,false,true,RawStatType.getCode(RawStatType.OBJECTIVE_PLAYER_SCORE));
         enumMap[MAX_NODE_CAPTURE_ASSIST] = createStatType(MAX_NODE_CAPTURE_ASSIST,1026,"max node capture assist",MAX,false,true,RawStatType.getCode(RawStatType.NODE_CAPTURE_ASSIST));
         enumMap[MAX_NODE_NEUTRALIZE_ASSIST] = createStatType(MAX_NODE_NEUTRALIZE_ASSIST,1027,"max node neutralize assist",MAX,false,true,RawStatType.getCode(RawStatType.NODE_NEUTRALIZE_ASSIST));
         enumMap[TOTAL_NODE_NEUTRALIZE] = createStatType(TOTAL_NODE_NEUTRALIZE,1028,"total node neutralize",TOTAL,false,true,RawStatType.getCode(RawStatType.NODE_NEUTRALIZE));
         enumMap[TOTAL_NODE_CAPTURE] = createStatType(TOTAL_NODE_CAPTURE,1029,"total node capture",TOTAL,false,true,RawStatType.getCode(RawStatType.NODE_CAPTURE));
         enumMap[AVERAGE_CHAMPIONS_KILLED] = createStatType(AVERAGE_CHAMPIONS_KILLED,1030,"avg kills",AVERAGE,false,true,RawStatType.getCode(RawStatType.CHAMPION_KILLS));
         enumMap[AVERAGE_NUM_DEATHS] = createStatType(AVERAGE_NUM_DEATHS,1031,"avg assists",AVERAGE,false,true,RawStatType.getCode(RawStatType.DEATHS));
         enumMap[AVERAGE_ASSISTS] = createStatType(AVERAGE_ASSISTS,1032,"avg assists",AVERAGE,false,true,RawStatType.getCode(RawStatType.ASSISTS));
         enumMap[MAX_ASSISTS] = createStatType(MAX_ASSISTS,1033,"max assists",MAX,false,true,RawStatType.getCode(RawStatType.ASSISTS));
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get doChampionCalc() : int
      {
         return this._1084588407doChampionCalc;
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function get statTypeName() : String
      {
         return this.name;
      }
      
      public function set code(param1:Number) : void
      {
         var _loc2_:Object = this._3059181code;
         if(_loc2_ !== param1)
         {
            this._3059181code = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"code",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
      }
      
      public function set calcType(param1:String) : void
      {
         var _loc2_:Object = this._180925649calcType;
         if(_loc2_ !== param1)
         {
            this._180925649calcType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"calcType",_loc2_,param1));
         }
      }
      
      public function set assocRawStatTypeCode(param1:Number) : void
      {
         var _loc2_:Object = this._2000742958assocRawStatTypeCode;
         if(_loc2_ !== param1)
         {
            this._2000742958assocRawStatTypeCode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"assocRawStatTypeCode",_loc2_,param1));
         }
      }
      
      public function set doChampionCalc(param1:int) : void
      {
         var _loc2_:Object = this._1084588407doChampionCalc;
         if(_loc2_ !== param1)
         {
            this._1084588407doChampionCalc = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"doChampionCalc",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get code() : Number
      {
         return this._3059181code;
      }
      
      [Bindable(event="propertyChange")]
      public function get calcType() : String
      {
         return this._180925649calcType;
      }
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this._1714148973displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get assocRawStatTypeCode() : Number
      {
         return this._2000742958assocRawStatTypeCode;
      }
      
      public function set id(param1:Number) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
   }
}

