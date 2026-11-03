package com.riotgames.platform.gameclient.domain.gameinvite
{
   import blix.util.string.parseBool;
   
   public class InvitationMetadata
   {
      
      public static const MAP_ID:String = "mapId";
      
      public static const GAME_MODE:String = "gameMode";
      
      public static const GAME_TYPE:String = "gameType";
      
      public static const RANKED_TEAM_NAME:String = "rankedTeamName";
      
      public static const RANKED_TEAM_ID:String = "rankedTeamId";
      
      public static const QUEUE_ID:String = "queueId";
      
      public static const IS_RANKED:String = "isRanked";
      
      public static const GAME_DIFFICULTY:String = "botDifficulty";
      
      public static const GAME_TYPE_CONFIG_ID:String = "gameTypeConfigId";
      
      public static const GROUP_ID:String = "groupFinderId";
      
      public static const GAME_ID:String = "gameId";
      
      private var _gameMetaData:String;
      
      private var _jsonBlob:Object;
      
      public function InvitationMetadata()
      {
         super();
      }
      
      public function get gameMetaData() : String
      {
         return this._gameMetaData;
      }
      
      public function set gameMetaData(param1:String) : void
      {
         this._gameMetaData = param1;
         this._jsonBlob = JSON.parse(param1);
      }
      
      public function get rankedTeamId() : String
      {
         return this._jsonBlob[RANKED_TEAM_ID];
      }
      
      public function get gameTypeConfigId() : int
      {
         return parseInt(this._jsonBlob[GAME_TYPE_CONFIG_ID]);
      }
      
      public function get queueId() : int
      {
         return parseInt(this._jsonBlob[QUEUE_ID]);
      }
      
      public function get gameDifficulty() : String
      {
         return this._jsonBlob[GAME_DIFFICULTY];
      }
      
      public function get rankedTeamName() : String
      {
         return this._jsonBlob[RANKED_TEAM_NAME];
      }
      
      public function get gameId() : Number
      {
         return parseInt(this._jsonBlob[GAME_ID]);
      }
      
      public function get gameMode() : String
      {
         return this._jsonBlob[GAME_MODE];
      }
      
      public function get mapId() : int
      {
         return parseInt(this._jsonBlob[MAP_ID]);
      }
      
      public function get groupId() : String
      {
         return this._jsonBlob[GROUP_ID];
      }
      
      public function get gameType() : String
      {
         return this._jsonBlob[GAME_TYPE];
      }
      
      public function get isRanked() : Boolean
      {
         return parseBool(this._jsonBlob[IS_RANKED]);
      }
   }
}

