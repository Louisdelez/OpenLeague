package com.riotgames.pvpnet.metrics
{
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.tracker.Tracker;
   
   public class ChampSelectTracker extends Tracker
   {
      
      private static var _instance:ChampSelectTracker;
      
      public static const CHOOSE_SPELL_1:String = "1";
      
      public static const CHOOSE_SPELL_2:String = "2";
      
      public static const CHOOSE_SPELL_BOTH:String = "both";
      
      private static const INFO_END_STATE:String = "info_end_state";
      
      private var _isInChampSelect:Boolean = false;
      
      public function ChampSelectTracker(param1:Object)
      {
         super("front_end_iron_champ_select");
      }
      
      public static function get instance() : ChampSelectTracker
      {
         if(!_instance)
         {
            _instance = new ChampSelectTracker(null);
         }
         return _instance;
      }
      
      private function getMapName(param1:int) : String
      {
         switch(param1)
         {
            case GameMap.SUMMONERS_RIFT_ID:
               return "SUMMONERS_RIFT";
            case GameMap.SUMMONERS_RIFT_AUTUMN_ID:
               return "SUMMONERS_RIFT_AUTUMN";
            case GameMap.PROVING_GROUNDS_ID:
               return "PROVING_GROUNDS";
            case GameMap.TWISTED_TREELINE_OLD_ID:
               return "TWISTED_TREELINE_OLD";
            case GameMap.SUMMONERS_RIFT_WINTER_ID:
               return "SUMMONERS_RIFT_WINTER";
            case GameMap.PROVING_GROUNDS_ARAM_ID:
               return "PROVING_GROUNDS_ARAM";
            case GameMap.CRYSTAL_SCAR_ID:
               return "CRYSTAL_SCAR";
            case GameMap.TWISTED_TREELINE_ID:
               return "TWISTED_TREELINE";
            case GameMap.SUMMONERS_RIFT_UPDATE_SHIPPING:
               return "SUMMONERS_RIFT_UPDATE_SHIPPING";
            case GameMap.HOWLING_ABYSS:
               return "HOWLING_ABYSS";
            case GameMap.SUMMONERS_RIFT_UPDATE_WIP:
               return "SUMMONERS_RIFT_UPDATE_WIP";
            case GameMap.PRE_SEASON_SANDBOX:
               return "PRE_SEASON_SANDBOX";
            default:
               return "unknown map " + param1.toString();
         }
      }
      
      public function enterChampSelect(param1:GameDTO, param2:GameTypeConfig) : void
      {
         this._isInChampSelect = true;
         setProperty("info_game_id",param1.id);
         setProperty("info_chat_room_id",param1.roomName);
         setProperty("info_game_map_id",param1.mapId);
         setProperty("info_game_map_name",this.getMapName(param1.mapId));
         setProperty("info_game_mode",param1.gameMode);
         setProperty("info_game_type",param1.gameType);
         setProperty("info_game_sub_type",param1.queueTypeName);
         setProperty("info_game_pick_type",param2.name);
         if(GameType.isRanked(param1.gameType))
         {
            setProperty("info_ranked.bool",true);
         }
      }
      
      public function spellsSelected(param1:String) : void
      {
         setProperty("summoner_spells_edited.bool",true);
         if(param1 == CHOOSE_SPELL_BOTH)
         {
            incrementCounter("summoner_spells_choose_both_clicked.count");
         }
         else if(param1 == CHOOSE_SPELL_1)
         {
            incrementCounter("summoner_spells_spell_1_clicked.count");
            incrementCounter("summoner_spells_spell_clicked.count");
         }
         else if(param1 == CHOOSE_SPELL_2)
         {
            incrementCounter("summoner_spells_spell_2_clicked.count");
            incrementCounter("summoner_spells_spell_clicked.count");
         }
      }
      
      public function champSelectCancelled() : void
      {
         if(this._isInChampSelect)
         {
            setProperty(INFO_END_STATE,"other_player_dodged");
            send();
            resetAllToDefaults();
            this._isInChampSelect = false;
         }
      }
      
      public function quitClient() : void
      {
         if(this._isInChampSelect)
         {
            setProperty(INFO_END_STATE,"dodge_by_exit_client");
            send();
            resetAllToDefaults();
            this._isInChampSelect = false;
         }
      }
      
      public function enterGame() : void
      {
         setProperty(INFO_END_STATE,"game_started");
         send();
         resetAllToDefaults();
         this._isInChampSelect = false;
      }
      
      public function quitChampSelect() : void
      {
         setProperty(INFO_END_STATE,"dodge_by_quit");
         send();
         resetAllToDefaults();
         this._isInChampSelect = false;
      }
   }
}

