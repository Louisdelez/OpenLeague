package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.RawStatType")]
   public class RawStatType implements IEventDispatcher
   {
      
      public static const WINS:String = "WIN";
      
      public static const TIME_PLAYED:String = "TIME_PLAYED";
      
      public static const LOSE:String = "LOSE";
      
      public static const WIN:String = "WIN";
      
      public static const LEAVES:String = "LEAVES";
      
      public static const CHAMPION_KILLS:String = "CHAMPIONS_KILLED";
      
      public static const DEATHS:String = "NUM_DEATHS";
      
      public static const ASSISTS:String = "ASSISTS";
      
      public static const MINIONS_KILLED:String = "MINIONS_KILLED";
      
      public static const TURRETS_KILLED:String = "TURRETS_KILLED";
      
      public static const BARRACKS_KILLED:String = "BARRACKS_KILLED";
      
      public static const GOLD_EARNED:String = "GOLD_EARNED";
      
      public static const TOTAL_DAMAGE_DEALT_TO_CHAMPIONS:String = "TOTAL_DAMAGE_DEALT_TO_CHAMPIONS";
      
      public static const TOTAL_DAMAGE_DEALT:String = "TOTAL_DAMAGE_DEALT";
      
      public static const TOTAL_DAMAGE_TAKEN:String = "TOTAL_DAMAGE_TAKEN";
      
      public static const LARGEST_KILLING_SPREE:String = "LARGEST_KILLING_SPREE";
      
      public static const NEUTRAL_MINIONS_KILLED:String = "NEUTRAL_MINIONS_KILLED";
      
      public static const LARGEST_MULTI_KILL:String = "LARGEST_MULTI_KILL";
      
      public static const LARGEST_CRITICAL_STRIKE:String = "LARGEST_CRITICAL_STRIKE";
      
      public static const TOTAL_HEAL:String = "TOTAL_HEAL";
      
      public static const FIRST_BLOOD:String = "FIRST_BLOOD";
      
      public static const PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS:String = "PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS";
      
      public static const PHYSICAL_DAMAGE_DEALT_PLAYER:String = "PHYSICAL_DAMAGE_DEALT_PLAYER";
      
      public static const MAGIC_DAMAGE_DEALT_TO_CHAMPIONS:String = "MAGIC_DAMAGE_DEALT_TO_CHAMPIONS";
      
      public static const MAGIC_DAMAGE_DEALT_PLAYER:String = "MAGIC_DAMAGE_DEALT_PLAYER";
      
      public static const PHYSICAL_DAMAGE_TAKEN:String = "PHYSICAL_DAMAGE_TAKEN";
      
      public static const MAGIC_DAMAGE_TAKEN:String = "MAGIC_DAMAGE_TAKEN";
      
      public static const TOTAL_TIME_SPENT_DEAD:String = "TOTAL_TIME_SPENT_DEAD";
      
      public static const LEVEL:String = "LEVEL";
      
      public static const NODE_CAPTURE:String = "NODE_CAPTURE";
      
      public static const NODE_KILL_DEFENSE:String = "NODE_KILL_DEFENSE";
      
      public static const DEFENSE_PLAYER_SCORE:String = "DEFENSE_PLAYER_SCORE";
      
      public static const DEFENDE_POINT_NEUTRALIZE:String = "DEFENDE_POINT_NEUTRALIZE";
      
      public static const TEAM_OBJECTIVE:String = "TEAM_OBJECTIVE";
      
      public static const TOTAL_PLAYER_SCORE:String = "TOTAL_PLAYER_SCORE";
      
      public static const OFFENSE_PLAYER_SCORE:String = "OFFENSE_PLAYER_SCORE";
      
      public static const VICTORY_POINT_TOTAL:String = "VICTORY_POINT_TOTAL";
      
      public static const LAST_STAND:String = "LAST_STAND";
      
      public static const NODE_NEUTRALIZE:String = "NODE_NEUTRALIZE";
      
      public static const NODE_KILL_OFFENSE:String = "NODE_KILL_OFFENSE";
      
      public static const COMBAT_PLAYER_SCORE:String = "COMBAT_PLAYER_SCORE";
      
      public static const OBJECTIVE_PLAYER_SCORE:String = "OBJECTIVE_PLAYER_SCORE";
      
      public static const NODE_CAPTURE_ASSIST:String = "NODE_CAPTURE_ASSIST";
      
      public static const NODE_NEUTRALIZE_ASSIST:String = "NODE_NEUTRALIZE_ASSIST";
      
      public static const TOTAL_SCORE_RANK:String = "TOTAL_SCORE_RANK";
      
      public static const ITEM1:String = "ITEM0";
      
      public static const ITEM2:String = "ITEM1";
      
      public static const ITEM3:String = "ITEM2";
      
      public static const ITEM4:String = "ITEM3";
      
      public static const ITEM5:String = "ITEM4";
      
      public static const ITEM6:String = "ITEM5";
      
      public static const SPELL1_CAST:String = "SPELL1_CAST";
      
      public static const SPELL2_CAST:String = "SPELL2_CAST";
      
      private var _3373707name:String;
      
      private var _3059181code:Number;
      
      private var _3355id:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function RawStatType()
      {
         super();
      }
      
      public static function getCode(param1:String) : int
      {
         return 0;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
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
      
      [Bindable(event="propertyChange")]
      public function get code() : Number
      {
         return this._3059181code;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
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
   }
}

