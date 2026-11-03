package com.riotgames.platform.gameclient.domain.game.practice
{
   import com.riotgames.platform.gameclient.domain.Player;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.AllowSpectators;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import mx.collections.ArrayCollection;
   
   [RemoteClass(alias="com.riotgames.platform.game.practice.PracticeGameSearchResult")]
   public class PracticeGameSearchResult
   {
      
      public static var spectatorSlotLimit:int = 1;
      
      public var teamCounts:int;
      
      public var gameMap:GameMap;
      
      public var name:String;
      
      public var allowSpectators:String;
      
      public var team1Count:int;
      
      public var privateGame:Boolean;
      
      public var team2Count:int;
      
      public var id:int;
      
      public var gameMutators:ArrayCollection;
      
      public var isSpectatorFull:Boolean;
      
      public var owner:PlayerParticipant;
      
      public var gameMode:String;
      
      public var playersAvailable:String;
      
      public var gameMapId:int;
      
      public var glmPort:int;
      
      public var lowerOwnerSummonerName:String;
      
      public var lowerGameName:String;
      
      public var maxNumPlayers:int;
      
      public var spectatorSlotText:String;
      
      public var canLobbySpectate:Boolean;
      
      public var spectatorCount:int;
      
      public var player:Player;
      
      public var isGameFull:Boolean;
      
      public var glmSecurePort:int;
      
      public var glmHost:String;
      
      public var glmGameId:String;
      
      public var pickType:String;
      
      public function PracticeGameSearchResult(param1:Object = null)
      {
         super();
         if(param1 != null)
         {
            this.id = param1["id"];
            this.name = param1["name"];
            this.owner = param1["owner"];
            this.maxNumPlayers = param1["maxNumPlayers"];
            this.privateGame = param1["privateGame"];
            this.team1Count = param1["team1Count"];
            this.team2Count = param1["team2Count"];
            this.gameMap = param1["gameMap"];
            this.gameMapId = param1["gameMapId"];
            this.gameMode = param1["gameMode"];
            this.gameMutators = param1["gameMutators"];
            this.pickType = param1["pickType"];
            this.allowSpectators = param1["allowSpectators"];
            this.glmGameId = param1["glmGameId"];
            this.glmHost = param1["glmHost"];
            this.glmPort = param1["glmPort"];
            this.glmSecurePort = param1["glmSecurePort"];
         }
      }
      
      public function initParams() : void
      {
         this.teamCounts = this.team1Count + this.team2Count;
         this.playersAvailable = this.teamCounts + "/" + this.maxNumPlayers;
         this.canLobbySpectate = this.allowSpectators == AllowSpectators.ALL || this.allowSpectators == AllowSpectators.LOBBY_ONLY;
         if(this.canLobbySpectate)
         {
            this.spectatorSlotText = this.spectatorCount + "/" + spectatorSlotLimit;
         }
         else
         {
            this.spectatorSlotText = "0/0";
         }
         this.isSpectatorFull = this.spectatorCount == spectatorSlotLimit;
         this.isGameFull = this.team1Count + this.team2Count == this.maxNumPlayers;
         this.lowerOwnerSummonerName = this.owner.summonerName.toLowerCase();
         this.lowerGameName = this.name.toLowerCase();
      }
   }
}

