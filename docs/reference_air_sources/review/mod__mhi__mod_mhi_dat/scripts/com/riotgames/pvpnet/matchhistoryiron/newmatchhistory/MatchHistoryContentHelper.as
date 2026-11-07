package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory
{
   import flash.utils.Dictionary;
   
   public class MatchHistoryContentHelper
   {
      
      private static var _initialized:Boolean = false;
      
      private static var _mapDict:Dictionary = new Dictionary();
      
      private static var _modeDict:Dictionary = new Dictionary();
      
      private static var _queueDict:Dictionary = new Dictionary();
      
      private static var _typeDict:Dictionary = new Dictionary();
      
      private static var _mappingDict:Dictionary = new Dictionary();
      
      public function MatchHistoryContentHelper()
      {
         super();
      }
      
      public static function getMapLocalizationKey(param1:int) : String
      {
         if(!_initialized)
         {
            initializeData();
         }
         return _mapDict[param1];
      }
      
      public static function getModeLocalizationKey(param1:String) : String
      {
         if(!_initialized)
         {
            initializeData();
         }
         return _modeDict[param1];
      }
      
      public static function getQueueLocalizationKey(param1:int) : String
      {
         if(!_initialized)
         {
            initializeData();
         }
         return _queueDict[param1];
      }
      
      public static function shouldShowObjectiveScoreForMap(param1:int) : Boolean
      {
         return param1 == 8;
      }
      
      private static function initializeData() : void
      {
         initMapData();
         initModeData();
         initQueueData();
         initTypeData();
         initMappings();
         _initialized = true;
      }
      
      private static function initMapData() : void
      {
         _mapDict[1] = "map_summoners_rift";
         _mapDict[8] = "map_crystal_scar";
         _mapDict[10] = "map_twisted_treeline";
         _mapDict[11] = "map_summoners_rift";
         _mapDict[12] = "map_howling_abyss";
      }
      
      private static function initModeData() : void
      {
         _modeDict["CLASSIC"] = "mode_classic";
         _modeDict["ARAM"] = "mode_aram";
         _modeDict["ODIN"] = "mode_dominion";
         _modeDict["ASCENSION"] = "mode_ascension";
      }
      
      private static function initQueueData() : void
      {
         _queueDict[0] = "queue_custom";
         _queueDict[7] = "queue_coop_vs_ai";
         _queueDict[2] = "queue_normal_blind_pick";
         _queueDict[14] = "queue_normal_draft_mode";
         _queueDict[4] = "queue_ranked_draft_mode";
         _queueDict[42] = "queue_ranked_team";
         _queueDict[61] = "queue_normal_team_builder";
         _queueDict[31] = "queue_coop_vs_ai";
         _queueDict[32] = "queue_coop_vs_ai";
         _queueDict[33] = "queue_coop_vs_ai";
         _queueDict[52] = "queue_coop_vs_ai";
         _queueDict[8] = "queue_normal_blind_pick";
         _queueDict[41] = "queue_ranked_team";
         _queueDict[25] = "queue_coop_vs_ai";
         _queueDict[16] = "queue_normal_blind_pick";
         _queueDict[17] = "queue_normal_draft_mode";
         _queueDict[65] = "queue_aram";
         _queueDict[70] = "queue_one_for_all";
         _queueDict[73] = "queue_first_blood";
         _queueDict[76] = "queue_urf_mode";
         _queueDict[78] = "mode_one_for_all_mirror";
         _queueDict[83] = "queue_coop_vs_ai";
         _queueDict[91] = "queue_doom_bots_of_doom_1";
         _queueDict[92] = "queue_doom_bots_of_doom_2";
         _queueDict[93] = "queue_doom_bots_of_doom_5";
         _queueDict[96] = "queue_ascension";
         _queueDict[9] = "queue_ranked_team";
         _queueDict[6] = "queue_ranked_team";
      }
      
      private static function initTypeData() : void
      {
         _typeDict[0] = "mode_custom";
         _typeDict[1] = "queue_normal";
         _typeDict[2] = "queue_ranked";
         _typeDict[3] = "queue_coop_vs_ai";
      }
      
      private static function initMappings() : void
      {
         _mappingDict[0] = {"type":0};
         _mappingDict[2] = {
            "type":1,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[4] = {
            "type":2,
            "map":1,
            "mode":"draft",
            "ranked":"solo"
         };
         _mappingDict[7] = {
            "type":3,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[14] = {
            "type":1,
            "map":1,
            "mode":"draft"
         };
         _mappingDict[42] = {
            "type":2,
            "map":1,
            "mode":"draft",
            "ranked":"team"
         };
         _mappingDict[61] = {
            "type":1,
            "map":1,
            "mode":"teambuilder"
         };
         _mappingDict[31] = {
            "type":3,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[32] = {
            "type":3,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[33] = {
            "type":3,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[8] = {
            "type":1,
            "map":10,
            "mode":"blind"
         };
         _mappingDict[41] = {
            "type":2,
            "map":10,
            "mode":"draft",
            "ranked":"team"
         };
         _mappingDict[52] = {
            "type":3,
            "map":10,
            "mode":"blind"
         };
         _mappingDict[25] = {
            "type":3,
            "map":8,
            "mode":"blind"
         };
         _mappingDict[16] = {
            "type":1,
            "map":8,
            "mode":"blind"
         };
         _mappingDict[17] = {
            "type":1,
            "map":8,
            "mode":"draft"
         };
         _mappingDict[65] = {
            "type":1,
            "map":12,
            "mode":"aram"
         };
         _mappingDict[70] = {
            "type":1,
            "map":1,
            "mode":"draft"
         };
         _mappingDict[73] = {
            "type":1,
            "map":12,
            "mode":"draft"
         };
         _mappingDict[76] = {
            "type":1,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[78] = {
            "type":1,
            "map":12,
            "mode":"draft"
         };
         _mappingDict[83] = {
            "type":1,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[91] = {
            "type":3,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[92] = {
            "type":3,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[93] = {
            "type":3,
            "map":1,
            "mode":"blind"
         };
         _mappingDict[96] = {
            "type":1,
            "map":8,
            "mode":"draft"
         };
      }
   }
}

