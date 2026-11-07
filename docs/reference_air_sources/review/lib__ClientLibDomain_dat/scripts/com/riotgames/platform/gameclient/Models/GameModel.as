package com.riotgames.platform.gameclient.Models
{
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.util.string.RiotStringUtil;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass]
   public class GameModel extends EventDispatcher
   {
      
      public static const TUTORIAL_TYPE_BASIC:String = "basic";
      
      public static const TUTORIAL_TYPE_ADVANCED:String = "advanced";
      
      public static const PVE_SUFFIX:String = "_pve";
      
      private var _1769142708gameType:String;
      
      private var _gameMap:GameMap;
      
      private var _gameMode:String;
      
      public var allowFreeChampions:Boolean = true;
      
      private var _1829500859difficulty:String;
      
      private var _608980920tutorialType:String;
      
      private var _938279477ranked:Boolean;
      
      private var _832155602numPlayersPerTeam:int;
      
      public function GameModel(param1:IEventDispatcher = null)
      {
         super(param1);
         this.reset();
      }
      
      public function get gameMap() : GameMap
      {
         return this._gameMap;
      }
      
      private function set _1769361227gameMode(param1:String) : void
      {
         this._gameMode = param1;
         if(!this.isCoopVsAi())
         {
            this.difficulty = "";
         }
      }
      
      public function get gameMode() : String
      {
         return this._gameMode;
      }
      
      public function reset() : void
      {
         this.difficulty = null;
         this.gameMode = null;
         this.gameMap = null;
         this.numPlayersPerTeam = 0;
         this.ranked = false;
         this.gameType = null;
         this.tutorialType = TUTORIAL_TYPE_BASIC;
         this.allowFreeChampions = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get ranked() : Boolean
      {
         return this._938279477ranked;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType() : String
      {
         return this._1769142708gameType;
      }
      
      public function set gameType(param1:String) : void
      {
         var _loc2_:Object = this._1769142708gameType;
         if(_loc2_ !== param1)
         {
            this._1769142708gameType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameType",_loc2_,param1));
         }
      }
      
      public function set numPlayersPerTeam(param1:int) : void
      {
         var _loc2_:Object = this._832155602numPlayersPerTeam;
         if(_loc2_ !== param1)
         {
            this._832155602numPlayersPerTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numPlayersPerTeam",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set gameMap(param1:GameMap) : void
      {
         var _loc2_:Object = this.gameMap;
         if(_loc2_ !== param1)
         {
            this._195623926gameMap = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMap",_loc2_,param1));
         }
      }
      
      private function set _195623926gameMap(param1:GameMap) : void
      {
         this._gameMap = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get numPlayersPerTeam() : int
      {
         return this._832155602numPlayersPerTeam;
      }
      
      public function set tutorialType(param1:String) : void
      {
         var _loc2_:Object = this._608980920tutorialType;
         if(_loc2_ !== param1)
         {
            this._608980920tutorialType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tutorialType",_loc2_,param1));
         }
      }
      
      public function copy() : GameModel
      {
         var _loc1_:GameModel = new GameModel();
         _loc1_.difficulty = this.difficulty;
         _loc1_.gameMode = this.gameMode;
         _loc1_.gameMap = this.gameMap;
         _loc1_.numPlayersPerTeam = this.numPlayersPerTeam;
         _loc1_.ranked = this.ranked;
         _loc1_.gameType = this.gameType;
         _loc1_.tutorialType = this.tutorialType;
         _loc1_.allowFreeChampions = this.allowFreeChampions;
         return _loc1_;
      }
      
      public function set difficulty(param1:String) : void
      {
         var _loc2_:Object = this._1829500859difficulty;
         if(_loc2_ !== param1)
         {
            this._1829500859difficulty = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"difficulty",_loc2_,param1));
         }
      }
      
      public function set ranked(param1:Boolean) : void
      {
         var _loc2_:Object = this._938279477ranked;
         if(_loc2_ !== param1)
         {
            this._938279477ranked = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ranked",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set gameMode(param1:String) : void
      {
         var _loc2_:Object = this.gameMode;
         if(_loc2_ !== param1)
         {
            this._1769361227gameMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMode",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get difficulty() : String
      {
         return this._1829500859difficulty;
      }
      
      public function isCoopVsAi() : Boolean
      {
         return !RiotStringUtil.isEmpty(this._gameMode) && Boolean(RiotStringUtil.endsWith(this._gameMode,"_pve"));
      }
      
      [Bindable(event="propertyChange")]
      public function get tutorialType() : String
      {
         return this._608980920tutorialType;
      }
   }
}

