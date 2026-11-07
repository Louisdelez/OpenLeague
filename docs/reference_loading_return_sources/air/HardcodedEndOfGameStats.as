package com.riotgames.platform.gameclient.utils
{
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PointsPenalty;
   import com.riotgames.platform.gameclient.domain.RawStatDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import mx.collections.ArrayCollection;
   
   public class HardcodedEndOfGameStats
   {
      
      public static const NO_XP_GAIN:String = "NO_XP_GAIN";
      
      public static const XP_GAIN_NO_LEVEL:String = "XP_GAIN_NO_LEVEL";
      
      public static const XP_GAIN_WITH_LEVEL:String = "XP_GAIN_WITH_LEVEL";
      
      public static const XP_GAIN_WITH_LEVEL_MAX:String = "XP_GAIN_WITH_LEVEL_MAX";
      
      private static var _xpGainType:String = XP_GAIN_NO_LEVEL;
      
      private static var _enableXpBoost:Boolean = false;
      
      private static var _enableXpLocationBoost:Boolean = false;
      
      private static var _enableXpLoyaltyBoost:Boolean = false;
      
      public static const NO_IP_GAIN:String = "NO_IP_GAIN";
      
      public static const IP_GAIN:String = "IP_GAIN";
      
      private static var _ipGainType:String = IP_GAIN;
      
      private static var _enableIpBoost:Boolean = false;
      
      private static var _enableIpFirstWinBoost:Boolean = false;
      
      private static var _enableIpQueueBoost:Boolean = false;
      
      private static var _enableIpLocationBoost:Boolean = false;
      
      private static var _enableIpLoyaltyBoost:Boolean = false;
      
      private static var _firstWinOfTheDayRemainingTime:int = 25893;
      
      public static const NO_SP_GAIN:String = "NO_SP_GAIN";
      
      public static const SP_GAIN_NO_REWARD:String = "SP_GAIN_NO_REWARD";
      
      public static const SP_GAIN_WITH_REWARD:String = "SP_GAIN_WITH_REWARD";
      
      public static const SP_GAIN_WITH_REWARD_NO_MORE_REWARD:String = "SP_GAIN_WITH_REWARD_NO_MORE_REWARD";
      
      private static var _spGainType:String = NO_SP_GAIN;
      
      public static const NO_RANK:String = "NO_RANK";
      
      public static const RANK_WITH_NO_RANK:String = "RANK_WITH_NO_RANK";
      
      public static const RANK_WITH_NEW_RANK:String = "RANK_WITH_NEW_RANK";
      
      private static var _rankGainType:String = NO_RANK;
      
      private static var _forceLostPrevent:Boolean = false;
      
      private static var _forcedGameId:int = 666;
      
      private static var _forceEoGRewardDisplay:Boolean = false;
      
      private static var _playerSkinName:String = "Karthus";
      
      private static const ITEMS:Array = [1011,1026,1031,1056,1057,1062,1063,2047,3001,3006,3020,3035,3065,3089,3105,3109,3110,3111,3117,3126,3135,3136,3140,3143,3158,3178,3260];
      
      private static const SPELL1:Array = [1,2,3,4,5,6,7];
      
      private static const SPELL2:Array = [9,10,11,12,13,14,16,17];
      
      public function HardcodedEndOfGameStats()
      {
         super();
      }
      
      private static function determineItem() : int
      {
         if(rand(4) == 1)
         {
            return 0;
         }
         return ITEMS[rand(ITEMS.length)];
      }
      
      public static function set enableIpLocationBoost(param1:Boolean) : void
      {
         _enableIpLocationBoost = param1;
      }
      
      private static function clearXpGainData(param1:EndOfGameStats) : void
      {
         param1.experienceEarned = 0;
         param1.rerollEnabled = false;
         param1.rerollEarned = 0;
         param1.rerollBonusEarned = 0;
         param1.leveledUp = false;
         param1.expPointsToNextLevel = 0;
         param1.boostXpEarned = 0;
         param1.locationBoostXpEarned = 0;
         param1.loyaltyBoostXpEarned = 0;
      }
      
      public static function set enableIpFirstWinBoost(param1:Boolean) : void
      {
         _enableIpFirstWinBoost = param1;
      }
      
      private static function rand(param1:int) : int
      {
         return int(Math.random() * param1);
      }
      
      private static function determineGameMode(param1:Object, param2:String) : String
      {
         var _loc3_:Object = null;
         if(Boolean(param1))
         {
            if(param1.hasOwnProperty("player1"))
            {
               _loc3_ = param1["player1"];
               if(_loc3_.hasOwnProperty("NODE_CAPTURE"))
               {
                  return GameMode.DOMINION;
               }
            }
         }
         return param2;
      }
      
      private static function generateRankGainData(param1:EndOfGameStats, param2:Boolean) : void
      {
      }
      
      private static function clearIpGainData(param1:EndOfGameStats) : void
      {
         param1.basePoints = 0;
         param1.boostIpEarned = 0;
         param1.firstWinBonus = 0;
         param1.queueBonusEarned = 0;
         param1.locationBoostIpEarned = 0;
         param1.loyaltyBoostIpEarned = 0;
         param1.odinBonusIp = 0;
         param1.ipEarned = 0;
         param1.ipTotal = 0;
      }
      
      private static function generateXpGainData(param1:EndOfGameStats, param2:Boolean) : void
      {
         var _loc3_:LevelUpInfo = null;
         var _loc4_:Boolean = false;
         clearXpGainData(param1);
         if(param2)
         {
            _loc3_ = generateEndOfGameLevelUpInfo();
            _loc4_ = _enableXpBoost || _enableXpLocationBoost || _enableXpLoyaltyBoost;
            param1.rerollEnabled = true;
            param1.rerollEarned = 50;
            param1.rerollBonusEarned = 50;
            param1.experienceEarned = _loc3_.pointsEarned;
            param1.expPointsToNextLevel = _loc3_.totalPointsNeededForNextLevel;
            param1.experienceTotal = _loc3_.totalExperiencePoints;
            if(_loc4_ && _loc3_.pointsEarned > 0)
            {
               generateXpBonusData(param1);
            }
            if(_xpGainType == XP_GAIN_WITH_LEVEL || _xpGainType == XP_GAIN_WITH_LEVEL_MAX)
            {
               param1.leveledUp = true;
            }
         }
      }
      
      private static function createPlayerData(param1:Object, param2:String, param3:PlayerParticipantStatsSummary, param4:Boolean, param5:Boolean) : void
      {
         var _loc8_:String = null;
         var _loc9_:RawStatDTO = null;
         var _loc6_:Object = new Object();
         if(Boolean(param1))
         {
            if(param1.hasOwnProperty(param2))
            {
               _loc6_ = param1[param2];
               param3.summonerName = _loc6_["NAME"];
               param3.skinName = _loc6_["SKIN"];
               param3.leaver = _loc6_["WAS_AFK"] == 1;
            }
         }
         else
         {
            if(param4)
            {
               _loc6_["WIN"] = param5 ? 1 : null;
               _loc6_["LOSE"] = param5 ? null : 1;
            }
            else
            {
               _loc6_["WIN"] = param5 ? null : 1;
               _loc6_["LOSE"] = param5 ? 1 : null;
            }
            _loc6_["TOTAL_TIME_SPENT_DEAD"] = rand(200) + 20;
            _loc6_["COMBAT_PLAYER_SCORE"] = rand(120);
            _loc6_["MAGIC_DAMAGE_DEALT_PLAYER"] = rand(35000) + 5000;
            _loc6_["NODE_CAPTURE"] = rand(6);
            _loc6_["TOTAL_DAMAGE_DEALT"] = rand(220000) + 10000;
            _loc6_["PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS"] = rand(90000);
            _loc6_["MAGIC_DAMAGE_DEALT_TO_CHAMPIONS"] = rand(30000);
            _loc6_["TOTAL_DAMAGE_DEALT_TO_CHAMPIONS"] = _loc6_["PHYSICAL_DAMAGE_DEALT_TO_CHAMPIONS"] + _loc6_["MAGIC_DAMAGE_DEALT_TO_CHAMPIONS"];
            _loc6_["NODE_KILL_DEFENSE"] = 0;
            _loc6_["TOTAL_HEAL"] = rand(60000);
            _loc6_["OBJECTIVE_PLAYER_SCORE"] = 0;
            _loc6_["DEFEND_POINT_NEUTRALIZE"] = 0;
            _loc6_["MINIONS_KILLED"] = rand(100);
            _loc6_["ITEM0"] = determineItem();
            _loc6_["ITEM1"] = determineItem();
            _loc6_["ITEM2"] = determineItem();
            _loc6_["ITEM3"] = determineItem();
            _loc6_["ITEM4"] = determineItem();
            _loc6_["ITEM5"] = determineItem();
            _loc6_["TOTAL_DAMAGE_TAKEN"] = rand(20000) + 10000;
            _loc6_["PHYSICAL_DAMAGE_TAKEN"] = rand(12000) + 2000;
            _loc6_["TEAM_OBJECTIVE"] = 0;
            _loc6_["TOTAL_PLAYER_SCORE"] = rand(70) + 4;
            _loc6_["NODE_TIME_DEFENSE"] = 0;
            _loc6_["ASSISTS"] = rand(10) + 1;
            _loc6_["LARGEST_MULTI_KILL"] = rand(3);
            _loc6_["LARGEST_CRITICAL_STRIKE"] = rand(700);
            _loc6_["GOLD_EARNED"] = rand(3000) + 9000;
            _loc6_["MAGIC_DAMAGE_TAKEN"] = rand(12000) + 2000;
            _loc6_["LAST_STAND"] = 0;
            _loc6_["NEUTRAL_MINIONS_KILLED"] = rand(4);
            _loc6_["NODE_NEUTRALIZE"] = rand(10);
            _loc6_["LARGEST_KILLING_SPREE"] = rand(6);
            _loc6_["CHAMPIONS_KILLED"] = rand(18);
            _loc6_["NODE_KILL_OFFENSE"] = 0;
            _loc6_["NUM_DEATHS"] = rand(10) + 1;
            _loc6_["PHYSICAL_DAMAGE_DEALT_PLAYER"] = rand(50000) + 3000;
            _loc6_["LEVEL"] = rand(18) + 1;
            _loc6_["VICTORY_POINT_TOTAL"] = rand(120);
         }
         var _loc7_:ArrayCollection = new ArrayCollection();
         for(_loc8_ in _loc6_)
         {
            if(Boolean(_loc6_[_loc8_]))
            {
               _loc9_ = new RawStatDTO();
               _loc9_.statTypeName = _loc8_;
               _loc9_.value = _loc6_[_loc8_];
               _loc7_.addItem(_loc9_);
            }
         }
         param3.statistics = _loc7_;
      }
      
      public static function set enableXpBoost(param1:Boolean) : void
      {
         _enableXpBoost = param1;
      }
      
      public static function getRankRewardType() : String
      {
         return _rankGainType;
      }
      
      private static function generateIpBonusData(param1:EndOfGameStats) : void
      {
         if(_enableIpBoost)
         {
            param1.boostIpEarned = param1.basePoints;
         }
         if(_enableIpFirstWinBoost)
         {
            param1.firstWinBonus = param1.basePoints * 0.5;
         }
         if(_enableIpQueueBoost)
         {
            param1.queueBonusEarned = param1.basePoints * 0.1;
         }
         if(_enableIpLocationBoost)
         {
            param1.locationBoostIpEarned = param1.basePoints * 0.1;
         }
         if(_enableIpLoyaltyBoost)
         {
            param1.loyaltyBoostIpEarned = param1.basePoints * 0.1;
         }
         if(param1.gameMode == GameMode.DOMINION)
         {
            param1.odinBonusIp = param1.basePoints * 0.15;
         }
      }
      
      public static function set enableIpLoyaltyBoost(param1:Boolean) : void
      {
         _enableIpLoyaltyBoost = param1;
      }
      
      public static function setRankGainType(param1:String) : void
      {
         _rankGainType = param1;
         if(_rankGainType.indexOf("RANK") == -1)
         {
            _rankGainType = NO_RANK;
         }
      }
      
      public static function set forceLostPrevent(param1:Boolean) : void
      {
         _forceLostPrevent = param1;
      }
      
      private static function generateIpGainData(param1:EndOfGameStats, param2:Boolean) : void
      {
         var _loc3_:Boolean = _enableIpBoost || _enableIpFirstWinBoost || _enableIpLocationBoost || _enableIpLoyaltyBoost || _enableIpQueueBoost;
         _loc3_ ||= param1.gameMode == GameMode.DOMINION;
         clearIpGainData(param1);
         if(param2 && _ipGainType != NO_IP_GAIN)
         {
            param1.basePoints = 100;
            generateIpBonusData(param1);
            param1.ipEarned = param1.basePoints + param1.queueBonusEarned + param1.firstWinBonus + param1.boostIpEarned + param1.loyaltyBoostIpEarned + param1.locationBoostIpEarned + param1.odinBonusIp;
            param1.ipTotal = 283 + param1.ipEarned;
         }
      }
      
      public static function set firstWinOfTheDayRemainingTime(param1:int) : void
      {
         _firstWinOfTheDayRemainingTime = param1;
      }
      
      public static function set enableIpBoost(param1:Boolean) : void
      {
         _enableIpBoost = param1;
      }
      
      public static function setXpGainType(param1:String) : void
      {
         _xpGainType = param1;
         if(_xpGainType.indexOf("XP") == -1)
         {
            _xpGainType = NO_XP_GAIN;
         }
      }
      
      public static function set enableIpQueueBoost(param1:Boolean) : void
      {
         _enableIpQueueBoost = param1;
      }
      
      public static function set playerSkinName(param1:String) : void
      {
         _playerSkinName = param1;
      }
      
      public static function set forceEoGRewardDisplay(param1:Boolean) : void
      {
         _forceEoGRewardDisplay = param1;
      }
      
      private static function generateSpGainData(param1:EndOfGameStats, param2:Boolean) : void
      {
      }
      
      private static function generateXpBonusData(param1:EndOfGameStats) : void
      {
         if(_enableXpBoost)
         {
            param1.boostXpEarned = param1.experienceEarned * 0.3;
         }
         if(_enableXpLocationBoost)
         {
            param1.locationBoostXpEarned = param1.experienceEarned * 0.1;
         }
         if(_enableXpLoyaltyBoost)
         {
            param1.loyaltyBoostXpEarned = param1.experienceEarned * 0.1;
         }
      }
      
      public static function setIpGainType(param1:String) : void
      {
         _ipGainType = param1;
         if(_ipGainType.indexOf("IP") == -1)
         {
            _ipGainType = NO_IP_GAIN;
         }
      }
      
      public static function set enableXpLocationBoost(param1:Boolean) : void
      {
         _enableXpLocationBoost = param1;
      }
      
      private static function createFakeStats(param1:Object, param2:String, param3:Boolean, param4:Boolean) : EndOfGameStats
      {
         var _loc5_:EndOfGameStats = new EndOfGameStats();
         _loc5_.gameId = _loc5_.reportGameId = _forcedGameId;
         _loc5_.userId = param3 ? 1 : 0;
         _loc5_.newSpells = new ArrayCollection();
         _loc5_.talentPointsGained = 0;
         _loc5_.gameMode = determineGameMode(param1,param2);
         generateIpGainData(_loc5_,param3);
         generateXpGainData(_loc5_,param3);
         generateSpGainData(_loc5_,param3);
         generateRankGainData(_loc5_,param3);
         _loc5_.pointsPenalties = new ArrayCollection();
         var _loc6_:PointsPenalty = new PointsPenalty();
         _loc6_.penalty = 0.2;
         _loc6_.type = "practice";
         _loc5_.pointsPenalties.addItem(_loc6_);
         _loc6_ = new PointsPenalty();
         _loc6_.penalty = 0.2;
         _loc6_.type = "Twistedtreeline";
         _loc5_.pointsPenalties.addItem(_loc6_);
         _loc5_.eloChange = 40;
         _loc5_.elo = 1728;
         _loc5_.ranked = param4;
         _loc5_.queueType = QueueType.NONE;
         _loc5_.gameLength = 3601;
         _loc5_.timeUntilNextFirstWinBonus = _firstWinOfTheDayRemainingTime;
         _loc5_.customMinutesLeftToday = 99;
         _loc5_.customMsecsUntilReset = 360000;
         _loc5_.coOpVsAiMsecsUntilReset = 360000;
         _loc5_.sendStatsToTournamentProvider = true;
         _loc5_.invalid = _forceLostPrevent;
         return _loc5_;
      }
      
      public static function get forceEoGRewardDisplay() : Boolean
      {
         var _loc1_:Boolean = _forceEoGRewardDisplay;
         _forceEoGRewardDisplay = false;
         return _loc1_;
      }
      
      public static function getSpGainType() : String
      {
         return _spGainType;
      }
      
      private static function addPlayers(param1:EndOfGameStats, param2:Object, param3:String, param4:Number, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean) : void
      {
         var _loc9_:int = 7;
         var _loc10_:Number = param4 + 1;
         var _loc11_:int = 1;
         param1.teamPlayerParticipantStats = new ArrayCollection();
         param1.teamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,param3,_playerSkinName,param5 ? param4 : _loc10_++,param5,param6,_loc9_,true,param7));
         param1.teamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"Koopa","Rammus",_loc10_++,false,false,_loc9_,true,param7));
         param1.teamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"omgwhat","Ashe",_loc10_++,false,false,_loc9_,true,param7));
         param1.teamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"MejainaStacks","Jax",_loc10_++,false,false,_loc9_,true,param7));
         param1.teamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"Zileas","Singed",_loc10_++,false,false,_loc9_,true,param7));
         if(param8)
         {
            param1.teamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"DCool","Draven",_loc10_++,false,false,_loc9_,true,param7));
         }
         param1.otherTeamPlayerParticipantStats = new ArrayCollection();
         param1.otherTeamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"Brackhar","Malzahar",_loc10_++,false,false,_loc9_,false,param7));
         param1.otherTeamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"KarrieBear","Morgana",_loc10_++,false,false,_loc9_,false,param7));
         param1.otherTeamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"Geeves","Teemo",_loc10_++,false,false,_loc9_,false,param7));
         param1.otherTeamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"Ponts","Warwick",_loc10_++,false,false,_loc9_,false,param7));
         param1.otherTeamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"Banksy","MissFortune",_loc10_++,false,false,_loc9_,false,param7));
         if(param8)
         {
            param1.otherTeamPlayerParticipantStats.addItem(createPlayer(param2,_loc11_++,"LampLit","Jayce",_loc10_++,false,false,_loc9_,false,param7));
         }
      }
      
      public static function set forcedGameId(param1:int) : void
      {
         _forcedGameId = param1;
      }
      
      public static function setSpGainType(param1:String) : void
      {
         _spGainType = param1;
         if(_spGainType.indexOf("SP") == -1)
         {
            _spGainType = NO_SP_GAIN;
         }
      }
      
      public static function generateEndOfGameLevelUpInfo() : LevelUpInfo
      {
         var _loc1_:LevelUpInfo = new LevelUpInfo();
         switch(_xpGainType)
         {
            case XP_GAIN_NO_LEVEL:
               _loc1_.currentLevel = 10;
               _loc1_.nextLevel = 11;
               _loc1_.pointsNeededToLevelUp = 200;
               _loc1_.pointsEarned = 100;
               _loc1_.totalExperiencePoints = 75 + _loc1_.pointsEarned;
               _loc1_.lastPercentCompleteForNextLevel = 0.2;
               break;
            case XP_GAIN_WITH_LEVEL:
               _loc1_.currentLevel = 10;
               _loc1_.nextLevel = 11;
               _loc1_.pointsNeededToLevelUp = 600;
               _loc1_.pointsEarned = 150;
               _loc1_.totalExperiencePoints = 75;
               _loc1_.lastPercentCompleteForNextLevel = 0.85;
               break;
            case XP_GAIN_WITH_LEVEL_MAX:
               _loc1_.currentLevel = 29;
               _loc1_.nextLevel = 30;
               _loc1_.totalExperiencePoints = 950;
               _loc1_.pointsNeededToLevelUp = 200;
               _loc1_.pointsEarned = 250;
               _loc1_.lastPercentCompleteForNextLevel = 0.8;
               break;
            case NO_XP_GAIN:
            default:
               _loc1_.currentLevel = 4;
               _loc1_.nextLevel = 5;
               _loc1_.pointsEarned = 0;
         }
         return _loc1_;
      }
      
      public static function get forcedGameId() : int
      {
         return _forcedGameId;
      }
      
      public static function set enableXpLoyaltyBoost(param1:Boolean) : void
      {
         _enableXpLoyaltyBoost = param1;
      }
      
      public static function createEndOfGameStats(param1:String, param2:Number, param3:String = "CLASSIC", param4:Boolean = true, param5:Object = null, param6:Boolean = true, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false) : EndOfGameStats
      {
         var _loc10_:EndOfGameStats = createFakeStats(param5,param3,param4,param8);
         addPlayers(_loc10_,param5,param1,param2,param4,param7,param6,param9);
         return _loc10_;
      }
      
      private static function createPlayer(param1:Object, param2:int, param3:String, param4:String, param5:Number, param6:Boolean, param7:Boolean, param8:int, param9:Boolean, param10:Boolean) : PlayerParticipantStatsSummary
      {
         var _loc11_:PlayerParticipantStatsSummary = new PlayerParticipantStatsSummary();
         _loc11_.summonerName = param3;
         _loc11_.skinName = param4;
         _loc11_.userId = param5;
         _loc11_.isMe = param6;
         _loc11_.level = rand(20) + 1;
         _loc11_.leaver = param7;
         _loc11_.numItems = param8;
         _loc11_.teamId = param9 ? 100 : 200;
         _loc11_.elo = rand(800) + 1200;
         _loc11_.spell1Id = SPELL1[rand(SPELL1.length)];
         _loc11_.spell2Id = SPELL2[rand(SPELL2.length)];
         _loc11_.botPlayer = false;
         createPlayerData(param1,"player" + param2,_loc11_,param9,param10);
         if(param2 == 1)
         {
            _loc11_.wins = 75;
            _loc11_.losses = 22;
            _loc11_.leaves = 1;
         }
         return _loc11_;
      }
   }
}

