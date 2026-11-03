package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.stats.TeamStatDetail")]
   public class TeamStatDetail extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const GAMES_PLAYED_FOR_RANKED_STATUS:int = 5;
      
      private var _1739445269queueType:String;
      
      private var _989243549isEligibleForRewardsFromTeam:Boolean = true;
      
      private var _1106736996leaves:int;
      
      private var _1106750929league:LeagueListDTO;
      
      private var _1096968431losses:int;
      
      private var _575046178decayWarningLevel:int = 0;
      
      private var _877713320teamId:TeamId;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3649559wins:int;
      
      private var _1896755366numberOfGamesNeededForEligibility:int = 0;
      
      private var _1041611051teamStatType:String;
      
      private var _471399410leaguePoints:Number = 0;
      
      private var _432716807isLeague:Boolean = false;
      
      public function TeamStatDetail()
      {
         super();
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get isLeague() : Boolean
      {
         return this._432716807isLeague;
      }
      
      public function getIsRanked() : Boolean
      {
         return this.wins + this.losses >= GAMES_PLAYED_FOR_RANKED_STATUS;
      }
      
      [Bindable(event="propertyChange")]
      public function get losses() : int
      {
         return this._1096968431losses;
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : int
      {
         return this._3649559wins;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaves() : int
      {
         return this._1106736996leaves;
      }
      
      public function set losses(param1:int) : void
      {
         var _loc2_:Object = this._1096968431losses;
         if(_loc2_ !== param1)
         {
            this._1096968431losses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losses",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamStatType() : String
      {
         return this._1041611051teamStatType;
      }
      
      [Bindable(event="propertyChange")]
      public function get league() : LeagueListDTO
      {
         return this._1106750929league;
      }
      
      [Bindable(event="propertyChange")]
      public function get decayWarningLevel() : int
      {
         return this._575046178decayWarningLevel;
      }
      
      public function set numberOfGamesNeededForEligibility(param1:int) : void
      {
         var _loc2_:Object = this._1896755366numberOfGamesNeededForEligibility;
         if(_loc2_ !== param1)
         {
            this._1896755366numberOfGamesNeededForEligibility = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numberOfGamesNeededForEligibility",_loc2_,param1));
         }
      }
      
      public function set wins(param1:int) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      public function set teamId(param1:TeamId) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      public function set leaves(param1:int) : void
      {
         var _loc2_:Object = this._1106736996leaves;
         if(_loc2_ !== param1)
         {
            this._1106736996leaves = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaves",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set decayWarningLevel(param1:int) : void
      {
         var _loc2_:Object = this._575046178decayWarningLevel;
         if(_loc2_ !== param1)
         {
            this._575046178decayWarningLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"decayWarningLevel",_loc2_,param1));
         }
      }
      
      public function set isEligibleForRewardsFromTeam(param1:Boolean) : void
      {
         var _loc2_:Object = this._989243549isEligibleForRewardsFromTeam;
         if(_loc2_ !== param1)
         {
            this._989243549isEligibleForRewardsFromTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isEligibleForRewardsFromTeam",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set queueType(param1:String) : void
      {
         var _loc2_:Object = this._1739445269queueType;
         if(_loc2_ !== param1)
         {
            this._1739445269queueType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueType",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : TeamId
      {
         return this._877713320teamId;
      }
      
      [Bindable(event="propertyChange")]
      public function get numberOfGamesNeededForEligibility() : int
      {
         return this._1896755366numberOfGamesNeededForEligibility;
      }
      
      public function set teamStatType(param1:String) : void
      {
         var _loc2_:Object = this._1041611051teamStatType;
         if(_loc2_ !== param1)
         {
            this._1041611051teamStatType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamStatType",_loc2_,param1));
         }
      }
      
      public function set league(param1:LeagueListDTO) : void
      {
         var _loc2_:Object = this._1106750929league;
         if(_loc2_ !== param1)
         {
            this._1106750929league = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"league",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isEligibleForRewardsFromTeam() : Boolean
      {
         return this._989243549isEligibleForRewardsFromTeam;
      }
      
      public function set leaguePoints(param1:Number) : void
      {
         var _loc2_:Object = this._471399410leaguePoints;
         if(_loc2_ !== param1)
         {
            this._471399410leaguePoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaguePoints",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get queueType() : String
      {
         return this._1739445269queueType;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaguePoints() : Number
      {
         return this._471399410leaguePoints;
      }
      
      public function set isLeague(param1:Boolean) : void
      {
         var _loc2_:Object = this._432716807isLeague;
         if(_loc2_ !== param1)
         {
            this._432716807isLeague = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isLeague",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

