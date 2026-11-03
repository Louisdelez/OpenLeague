package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory
{
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipantStats;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipantTimeline;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipantTimelineItem;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimeline;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimelineFrame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimelineFrameEvent;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameTimelineParticipantFrameStats;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayerInfo;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryRecentGames;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryTeamStats;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class MatchHistoryParser
   {
      
      private var _decoder:IDecode;
      
      private var _inventoryProvider:IInventoryProvider;
      
      private var _gameItemDictionary:Dictionary;
      
      private var _queueDictionary:Dictionary;
      
      public function MatchHistoryParser(param1:IDecode, param2:IInventoryProvider, param3:Dictionary, param4:Dictionary)
      {
         super();
         this._decoder = param1;
         this._inventoryProvider = param2;
         this._gameItemDictionary = param3;
         this._queueDictionary = param4;
      }
      
      public function getPlayerInfo(param1:String) : MatchHistoryPlayerInfo
      {
         var _loc2_:Object = this._decoder.decode(param1);
         var _loc3_:MatchHistoryPlayerInfo = new MatchHistoryPlayerInfo();
         _loc3_.accountId = _loc2_["accountId"];
         _loc3_.platformId = _loc2_["platformId"];
         return _loc3_;
      }
      
      public function getPlayerRecentGames(param1:String) : MatchHistoryRecentGames
      {
         var _loc6_:Object = null;
         var _loc7_:MatchHistoryGame = null;
         var _loc2_:MatchHistoryRecentGames = new MatchHistoryRecentGames();
         var _loc3_:Object = this._decoder.decode(param1);
         var _loc4_:Object = _loc3_["games"];
         _loc2_.accountId = _loc3_["accountId"];
         _loc2_.gameCount = _loc4_["gameCount"];
         _loc2_.gameIndexBegin = _loc4_["gameIndexBegin"];
         _loc2_.gameIndexEnd = _loc4_["gameIndexEnd"];
         _loc2_.gameTimestampBegin = _loc4_["gameTimestampBegin"];
         _loc2_.gameTimestampEnd = _loc4_["gameTimestampEnd"];
         var _loc5_:Vector.<MatchHistoryGame> = new Vector.<MatchHistoryGame>();
         for each(_loc6_ in _loc4_["games"])
         {
            _loc7_ = this.getGameFromDecodedObject(_loc6_);
            _loc7_.searchedParticipant = _loc7_.participants[0];
            _loc5_.push(_loc7_);
         }
         _loc2_.games = _loc5_;
         return _loc2_;
      }
      
      public function getDetailedGame(param1:String) : MatchHistoryGame
      {
         var _loc2_:Object = this._decoder.decode(param1);
         return this.getDetailedGameFromDecodedObject(_loc2_);
      }
      
      public function getGameTimeline(param1:String) : MatchHistoryGameTimeline
      {
         var _loc2_:MatchHistoryGameTimeline = new MatchHistoryGameTimeline();
         var _loc3_:Object = this._decoder.decode(param1);
         _loc2_.frameInterval = _loc3_["frameInterval"];
         _loc2_.frames = this.getTimelineFramesFromDecodedArray(_loc3_["frames"]);
         _loc2_.events = this.getTimelineEventsFromDecodedFramesArray(_loc3_["frames"]);
         return _loc2_;
      }
      
      private function getTimelineFramesFromDecodedArray(param1:Array) : Vector.<MatchHistoryGameTimelineFrame>
      {
         var _loc3_:Object = null;
         var _loc4_:MatchHistoryGameTimelineFrame = null;
         var _loc2_:Vector.<MatchHistoryGameTimelineFrame> = new Vector.<MatchHistoryGameTimelineFrame>();
         for each(_loc3_ in param1)
         {
            _loc4_ = new MatchHistoryGameTimelineFrame();
            _loc4_.timeStamp = _loc3_["timestamp"];
            _loc4_.participantFrames = this.getTimelineParticipantFramesFromDecodedObject(_loc3_["participantFrames"]);
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function getTimelineEventsFromDecodedFramesArray(param1:Array) : Vector.<MatchHistoryGameTimelineFrameEvent>
      {
         var _loc3_:Object = null;
         var _loc4_:Vector.<MatchHistoryGameTimelineFrameEvent> = null;
         var _loc2_:Vector.<MatchHistoryGameTimelineFrameEvent> = new Vector.<MatchHistoryGameTimelineFrameEvent>();
         for each(_loc3_ in param1)
         {
            _loc4_ = this.getTimelineFrameEventsFromDecodedArray(_loc3_["events"]);
            _loc2_ = _loc2_.concat(_loc4_);
         }
         return _loc2_;
      }
      
      private function getTimelineParticipantFramesFromDecodedObject(param1:Object) : Dictionary
      {
         var _loc3_:Object = null;
         var _loc4_:MatchHistoryGameTimelineParticipantFrameStats = null;
         var _loc5_:Object = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            _loc4_ = new MatchHistoryGameTimelineParticipantFrameStats();
            _loc4_.currentGold = _loc3_["currentGold"];
            _loc4_.dominionScore = _loc3_["dominionScore"];
            _loc4_.jungleMinionsKilled = _loc3_["jungleMinionsKilled"];
            _loc4_.level = _loc3_["level"];
            _loc4_.minionsKilled = _loc3_["minionsKilled"];
            _loc4_.participantId = _loc3_["participantId"];
            if(_loc3_["position"])
            {
               _loc5_ = _loc3_["position"];
               _loc4_.position = new Point(_loc5_["x"],_loc5_["y"]);
            }
            _loc4_.teamScore = _loc3_["teamScore"];
            _loc4_.totalGold = _loc3_["totalGold"];
            _loc4_.xp = _loc3_["xp"];
            _loc2_[_loc4_.participantId] = _loc4_;
         }
         return _loc2_;
      }
      
      private function getTimelineFrameEventsFromDecodedArray(param1:Array) : Vector.<MatchHistoryGameTimelineFrameEvent>
      {
         var _loc3_:Object = null;
         var _loc4_:MatchHistoryGameTimelineFrameEvent = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc2_:Vector.<MatchHistoryGameTimelineFrameEvent> = new Vector.<MatchHistoryGameTimelineFrameEvent>();
         for each(_loc3_ in param1)
         {
            _loc4_ = new MatchHistoryGameTimelineFrameEvent();
            for each(_loc5_ in _loc3_["assistingParticipantIds"])
            {
               _loc4_.assistingParticipantIds.push(_loc5_);
            }
            _loc4_.creatorId = _loc3_["creatorId"];
            _loc4_.itemId = _loc3_["itemId"];
            _loc4_.killerId = _loc3_["killerId"];
            _loc4_.laneType = _loc3_["laneType"];
            _loc4_.monsterType = _loc3_["monsterType"];
            _loc4_.participantId = _loc3_["participantId"];
            if(_loc3_["position"])
            {
               _loc6_ = _loc3_["position"];
               _loc4_.position = new Point(_loc6_["x"],_loc6_["y"]);
            }
            _loc4_.teamId = _loc3_["teamId"];
            _loc4_.timestamp = _loc3_["timestamp"];
            _loc4_.towerType = _loc3_["towerType"];
            _loc4_.type = _loc3_["type"];
            _loc4_.victimId = _loc3_["victimId"];
            _loc4_.wardType = _loc3_["wardType"];
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      private function getDetailedGameFromDecodedObject(param1:Object) : MatchHistoryGame
      {
         var _loc3_:Object = null;
         var _loc2_:MatchHistoryGame = this.getGameFromDecodedObject(param1);
         _loc2_.gameMode = param1["gameMode"];
         _loc2_.gameType = param1["gameType"];
         _loc2_.teams = new Dictionary();
         for each(_loc3_ in param1["teams"])
         {
            _loc2_.teams[_loc3_["teamId"]] = this.getTeamStatsFromDecodedObject(_loc3_);
         }
         return _loc2_;
      }
      
      private function getTeamStatsFromDecodedObject(param1:Object) : MatchHistoryTeamStats
      {
         var _loc3_:Object = null;
         var _loc4_:Champion = null;
         var _loc2_:MatchHistoryTeamStats = new MatchHistoryTeamStats();
         for each(_loc3_ in param1["bans"])
         {
            _loc4_ = this._inventoryProvider.getInventoryController().getChampionById(_loc3_["championId"]);
            _loc2_.bans.push(_loc4_);
         }
         _loc2_.baronKills = param1["baronKills"];
         _loc2_.dominionVictoryScore = param1["dominionVictoryScore"];
         _loc2_.dragonKills = param1["dragonKills"];
         _loc2_.firstBaron = param1["firstBaron"];
         _loc2_.firstBlood = param1["firstBlood"];
         _loc2_.firstDragon = param1["firstDragon"];
         _loc2_.firstInhibitor = param1["firstInhibitor"];
         _loc2_.firstTower = param1["firstTower"];
         _loc2_.inhibitorKills = param1["inhibitorKills"];
         _loc2_.teamId = param1["teamId"];
         _loc2_.towerKills = param1["towerKills"];
         _loc2_.vilemawKills = param1["vilemawKills"];
         _loc2_.win = param1["win"];
         return _loc2_;
      }
      
      private function getGameFromDecodedObject(param1:Object) : MatchHistoryGame
      {
         var _loc2_:MatchHistoryGame = new MatchHistoryGame();
         _loc2_.gameCreation = param1["gameCreation"];
         _loc2_.gameDuration = param1["gameDuration"];
         _loc2_.gameId = param1["gameId"];
         _loc2_.gameMode = param1["gameMode"];
         _loc2_.gameType = param1["gameType"];
         _loc2_.gameVersion = param1["gameVersion"];
         _loc2_.mapId = param1["mapId"];
         _loc2_.participants = this.getParticipantsFromDecodedObjects(param1["participants"],param1["participantIdentities"]);
         _loc2_.participantsDict = this.createParticipantsDictionary(_loc2_.participants);
         _loc2_.platformId = param1["platformId"];
         _loc2_.queue = this._queueDictionary[param1["queueId"]];
         _loc2_.queueId = param1["queueId"];
         _loc2_.seasonId = param1["seasonId"];
         return _loc2_;
      }
      
      private function getParticipantsFromDecodedObjects(param1:Array, param2:Array) : Vector.<MatchHistoryGameParticipant>
      {
         var _loc5_:MatchHistoryPlayer = null;
         var _loc6_:MatchHistoryGameParticipant = null;
         var _loc3_:Vector.<MatchHistoryGameParticipant> = new Vector.<MatchHistoryGameParticipant>();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = this.getPlayerFromDecodedObject(param2[_loc4_]["player"]);
            _loc6_ = this.getParticipantFromDecodedObject(param1[_loc4_]);
            _loc6_.player = _loc5_;
            _loc3_.push(_loc6_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function createParticipantsDictionary(param1:Vector.<MatchHistoryGameParticipant>) : Dictionary
      {
         var _loc3_:MatchHistoryGameParticipant = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            _loc2_[_loc3_.participantId] = _loc3_;
         }
         return _loc2_;
      }
      
      private function getPlayerFromDecodedObject(param1:Object) : MatchHistoryPlayer
      {
         var _loc2_:MatchHistoryPlayer = new MatchHistoryPlayer();
         _loc2_.accountId = param1["accountId"];
         _loc2_.currentAccountId = param1["currentAccountId"];
         _loc2_.currentPlatformId = param1["currentPlayformId"];
         _loc2_.matchHistoryUri = param1["matchHistoryUri"];
         _loc2_.platformId = param1["platformId"];
         _loc2_.profileIcon = param1["profileIcon"];
         _loc2_.summonerName = param1["summonerName"];
         _loc2_.playerInfoRetrieved = true;
         return _loc2_;
      }
      
      private function getParticipantFromDecodedObject(param1:Object) : MatchHistoryGameParticipant
      {
         var _loc2_:MatchHistoryGameParticipant = new MatchHistoryGameParticipant();
         _loc2_.champion = this._inventoryProvider.getInventoryController().getChampionById(param1["championId"]);
         _loc2_.participantId = param1["participantId"];
         _loc2_.skinId = param1["skinId"];
         _loc2_.spell1 = this._inventoryProvider.getInventoryController().getSpellById(param1["spell1Id"]);
         _loc2_.spell2 = this._inventoryProvider.getInventoryController().getSpellById(param1["spell2Id"]);
         _loc2_.stats = this.getParticipantStatsFromDecodedObject(param1["stats"]);
         _loc2_.teamId = param1["teamId"];
         _loc2_.timeline = this.getParticipantTimelineFromDecodedObject(param1["timeline"]);
         return _loc2_;
      }
      
      private function getParticipantStatsFromDecodedObject(param1:Object) : MatchHistoryGameParticipantStats
      {
         var _loc2_:MatchHistoryGameParticipantStats = new MatchHistoryGameParticipantStats();
         _loc2_.assists = param1["assists"];
         _loc2_.champLevel = param1["champLevel"];
         _loc2_.combatPlayerScore = param1["combatPlayerScore"];
         _loc2_.deaths = param1["deaths"];
         _loc2_.doubleKills = param1["doubleKills"];
         _loc2_.firstBloodAssist = param1["firstBloodAssist"];
         _loc2_.firstBloodKill = param1["firstBloodKill"];
         _loc2_.firstInhibitorAssist = param1["firstInhibitorAssist"];
         _loc2_.firstInhibitorKill = param1["firstInhibitorKill"];
         _loc2_.firstTowerAssist = param1["firstTowerAssist"];
         _loc2_.firstTowerKill = param1["firstTowerKill"];
         _loc2_.goldEarned = param1["goldEarned"];
         _loc2_.goldSpent = param1["goldSpent"];
         _loc2_.inhibitorKills = param1["inhibitorKills"];
         _loc2_.item0 = this._gameItemDictionary[param1["item0"]];
         _loc2_.item1 = this._gameItemDictionary[param1["item1"]];
         _loc2_.item2 = this._gameItemDictionary[param1["item2"]];
         _loc2_.item3 = this._gameItemDictionary[param1["item3"]];
         _loc2_.item4 = this._gameItemDictionary[param1["item4"]];
         _loc2_.item5 = this._gameItemDictionary[param1["item5"]];
         _loc2_.item6 = this._gameItemDictionary[param1["item6"]];
         _loc2_.killingSprees = param1["killingSprees"];
         _loc2_.kills = param1["kills"];
         _loc2_.largestCriticalStrike = param1["largestCriticalStrike"];
         _loc2_.largestKillingSpree = param1["largestKillingSpree"];
         _loc2_.largestMultiKill = param1["largestMultiKill"];
         _loc2_.longestTimeSpentLiving = param1["longestTimeSpentLiving"];
         _loc2_.magicalDamageTaken = param1["magicalDamageTaken"];
         _loc2_.magicDamageDealt = param1["magicDamageDealt"];
         _loc2_.magicDamageDealtToChampions = param1["magicDamageDealtToChampions"];
         _loc2_.neutralMinionsKilled = param1["neutralMinionsKilled"];
         _loc2_.neutralMinionsKilledEnemyJungle = param1["neutralMinionsKilledEnemyJungle"];
         _loc2_.neutralMinionsKilledTeamJungle = param1["neutralMinionsKilledTeamJungle"];
         _loc2_.objectivePlayerScore = param1["objectivePlayerScore"];
         _loc2_.participantId = param1["participantId"];
         _loc2_.pentaKills = param1["pentaKills"];
         _loc2_.physicalDamageDealt = param1["physicalDamageDealt"];
         _loc2_.physicalDamageDealtToChampions = param1["physicalDamageDealtToChampions"];
         _loc2_.physicalDamageTaken = param1["physicalDamageTaken"];
         _loc2_.quadraKills = param1["quadraKills"];
         _loc2_.sightWardsBoughtInGame = param1["sightWardsBoughtInGame"];
         _loc2_.totalDamageDealt = param1["totalDamageDealt"];
         _loc2_.totalDamageDealtToChampions = param1["totalDamageDealtToChampions"];
         _loc2_.totalDamageTaken = param1["totalDamageTaken"];
         _loc2_.totalHeal = param1["totalHeal"];
         _loc2_.totalMinionsKilled = param1["totalMinionsKilled"];
         _loc2_.totalPlayerScore = param1["totalPlayerScore"];
         _loc2_.totalTimeCrowdControlDealt = param1["totalTimeCrowdControlDealt"];
         _loc2_.totalTimeSpentDead = param1["totalTimeSpentDead"];
         _loc2_.totalScoreRank = param1["totalScoreRank"];
         _loc2_.totalUnitsHealed = param1["totalUnitsHealed"];
         _loc2_.tripleKills = param1["tripleKills"];
         _loc2_.trueDamageDealt = param1["trueDamageDealt"];
         _loc2_.trueDamageDealtToChampions = param1["trueDamageDealtToChampions"];
         _loc2_.trueDamageTaken = param1["trueDamageTaken"];
         _loc2_.turretKills = param1["turretKills"];
         _loc2_.unrealKills = param1["unrealKills"];
         _loc2_.visionWardsBoughtInGame = param1["visionWardsBoughtInGame"];
         _loc2_.wardsKilled = param1["wardsKilled"];
         _loc2_.wardsPlaced = param1["wardsPlaced"];
         _loc2_.win = param1["win"];
         return _loc2_;
      }
      
      private function getParticipantTimelineFromDecodedObject(param1:Object) : MatchHistoryGameParticipantTimeline
      {
         var _loc2_:MatchHistoryGameParticipantTimeline = new MatchHistoryGameParticipantTimeline();
         _loc2_.lane = param1["lane"];
         _loc2_.participantId = param1["participantId"];
         _loc2_.role = param1["role"];
         _loc2_.creepsPerMinDeltas = this.getParticipantTimelineDeltasFromDecodedObject(param1["creepsPerMinDeltas"]);
         _loc2_.csDiffPerMinDeltas = this.getParticipantTimelineDeltasFromDecodedObject(param1["csDiffPerMinDeltas"]);
         _loc2_.damageTakenDiffPerMinDeltas = this.getParticipantTimelineDeltasFromDecodedObject(param1["damageTakenDiffPerMinDeltas"]);
         _loc2_.damageTakenPerMinDeltas = this.getParticipantTimelineDeltasFromDecodedObject(param1["damageTakenPerMinDeltas"]);
         _loc2_.goldPerMinDeltas = this.getParticipantTimelineDeltasFromDecodedObject(param1["goldPerMinDeltas"]);
         _loc2_.xpDiffPerMinDeltas = this.getParticipantTimelineDeltasFromDecodedObject(param1["xpDiffPerMinDeltas"]);
         _loc2_.xpPerMinDeltas = this.getParticipantTimelineDeltasFromDecodedObject(param1["xpPerMinDeltas"]);
         return _loc2_;
      }
      
      private function getParticipantTimelineDeltasFromDecodedObject(param1:Object) : Vector.<MatchHistoryGameParticipantTimelineItem>
      {
         var _loc3_:String = null;
         var _loc4_:MatchHistoryGameParticipantTimelineItem = null;
         var _loc2_:Vector.<MatchHistoryGameParticipantTimelineItem> = new Vector.<MatchHistoryGameParticipantTimelineItem>();
         for(_loc3_ in param1)
         {
            _loc4_ = new MatchHistoryGameParticipantTimelineItem();
            _loc4_.timeBucket = _loc3_;
            _loc4_.value = param1[_loc3_];
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
   }
}

