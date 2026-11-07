package com.riotgames.pvpnet.game.controllers.practice
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.AllowSpectators;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.pvpnet.game.domain.MutatorsConfiguration;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import mx.collections.ArrayCollection;
   
   public class PracticeGameParameters
   {
      
      public var customGameType:String;
      
      public var practiceGameConfigs:ArrayCollection;
      
      public var practiceGameTypeNames:ArrayCollection;
      
      public var practiceGameRegionNames:ArrayCollection;
      
      public var practiceGameRegionNamesAvailable:Boolean = false;
      
      public var allowSpectatorTypes:ArrayCollection;
      
      public var filterFeaturedGamePickModes:Boolean = false;
      
      private var _enabledMaps:ArrayCollection;
      
      private var _gameMode:String;
      
      private var _gameMutators:Array;
      
      private var _overriddenGamePickIds:ArrayCollection;
      
      private var _overriddenMaxTeamSize:Number;
      
      private var _overriddenMapIds:ArrayCollection;
      
      private var _overriddenGameDescription:String;
      
      private var _overriddenGameTitle:String;
      
      public function PracticeGameParameters(param1:*)
      {
         super();
         this.customGameType = param1;
      }
      
      public function set gameMode(param1:String) : void
      {
         this._gameMode = param1;
      }
      
      public function set gameMutators(param1:Array) : void
      {
         this._gameMutators = param1;
      }
      
      public function set overriddenGamePickIds(param1:ArrayCollection) : void
      {
         this._overriddenGamePickIds = param1;
      }
      
      public function set overriddenMaxTeamSize(param1:Number) : void
      {
         this._overriddenMaxTeamSize = param1;
      }
      
      public function set overriddenMapIds(param1:ArrayCollection) : void
      {
         this._overriddenMapIds = param1;
      }
      
      public function set overriddenGameDescription(param1:String) : void
      {
         this._overriddenGameDescription = param1;
      }
      
      public function set overriddenGameTitle(param1:String) : void
      {
         this._overriddenGameTitle = param1;
      }
      
      internal function build() : void
      {
         var _loc2_:GameTypeConfig = null;
         var _loc3_:String = null;
         this.practiceGameRegionNamesAvailable = false;
         this.practiceGameRegionNames = ClientConfig.instance.knownGeographicGameServerRegions;
         var _loc1_:int = 0;
         while(_loc1_ < this.practiceGameRegionNames.length)
         {
            if(this.practiceGameRegionNames[_loc1_] != "")
            {
               this.practiceGameRegionNamesAvailable = true;
               break;
            }
            _loc1_++;
         }
         this.practiceGameConfigs = this.getPracticeGameTypeConfigs();
         this.practiceGameTypeNames = new ArrayCollection();
         for each(_loc2_ in this.practiceGameConfigs)
         {
            _loc3_ = RiotResourceLoader.getString("practiceGame_gameMode_" + _loc2_.name,_loc2_.pickMode);
            this.practiceGameTypeNames.addItem(_loc3_);
         }
         this.allowSpectatorTypes = new ArrayCollection();
         this.allowSpectatorTypes.addItem({
            "label":RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorType_" + AllowSpectators.NONE),
            "data":AllowSpectators.NONE
         });
         switch(ClientConfig.instance.observableCustomGameModes)
         {
            case AllowSpectators.ALL:
               this.allowSpectatorTypes.addItem({
                  "label":RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorType_" + AllowSpectators.ALL),
                  "data":AllowSpectators.ALL
               });
               this.allowSpectatorTypes.addItem({
                  "label":RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorType_" + AllowSpectators.LOBBY_ONLY),
                  "data":AllowSpectators.LOBBY_ONLY
               });
               this.allowSpectatorTypes.addItem({
                  "label":RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorType_" + AllowSpectators.DROP_IN_ONLY),
                  "data":AllowSpectators.DROP_IN_ONLY
               });
               break;
            case AllowSpectators.LOBBY_ONLY:
               this.allowSpectatorTypes.addItem({
                  "label":RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorType_" + AllowSpectators.LOBBY_ONLY),
                  "data":AllowSpectators.LOBBY_ONLY
               });
               break;
            case AllowSpectators.DROP_IN_ONLY:
               this.allowSpectatorTypes.addItem({
                  "label":RiotResourceLoader.getString("practiceGame_createOrJoinGame_allowSpectatorType_" + AllowSpectators.DROP_IN_ONLY),
                  "data":AllowSpectators.DROP_IN_ONLY
               });
         }
         this.updateMapEnablement();
      }
      
      public function updateMapEnablement() : void
      {
         var _loc3_:GameMap = null;
         var _loc4_:ArrayCollection = null;
         var _loc5_:String = null;
         var _loc1_:ArrayCollection = null;
         if(this._overriddenMapIds != null)
         {
            _loc1_ = new ArrayCollection();
            _loc4_ = AppConfig.instance.availableMaps;
            for each(_loc3_ in _loc4_)
            {
               if(this._overriddenMapIds.contains(_loc3_.mapId))
               {
                  _loc1_.addItem(_loc3_);
               }
            }
         }
         else
         {
            _loc1_ = AppConfig.instance.availableMaps;
         }
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in _loc1_)
         {
            _loc5_ = this.variant.getGameModeForMap(_loc3_.mapId);
            if(MutatorsConfiguration.isConfigurationEnabled(MutatorsConfiguration.ENABLED_MODES,_loc5_))
            {
               _loc2_.addItem(_loc3_);
            }
         }
         this._enabledMaps = _loc2_;
      }
      
      public function getGameDescription(param1:GameMap) : String
      {
         if(this._overriddenGameDescription != null)
         {
            return this._overriddenGameDescription;
         }
         return param1.description != null ? param1.description : RiotResourceLoader.getString("practiceGame_createPracticeGame_chooseMap_noMapSelectedDescription","Pick a map");
      }
      
      public function getGameTitle() : String
      {
         if(this._overriddenGameTitle != null)
         {
            return this._overriddenGameTitle;
         }
         return RiotResourceLoader.getString("practiceGame_createPracticeGame_chooseMap_heading","Choose Your Map");
      }
      
      public function getPlayableMaps() : ArrayCollection
      {
         return this._enabledMaps;
      }
      
      public function getMaxTeamSize(param1:GameMap, param2:int) : Number
      {
         if(!isNaN(this._overriddenMaxTeamSize))
         {
            return this._overriddenMaxTeamSize;
         }
         if(param1 == null)
         {
            return 0;
         }
         return Math.min(param2,param1.totalPlayers / 2);
      }
      
      public function get variant() : GameFlowVariant
      {
         return GameFlowVariantFactory.instance.getVariant(this._gameMutators,this._gameMode);
      }
      
      public function applyGameTypeToConfig(param1:PracticeGameConfig, param2:int) : void
      {
         param1.gameMode = this.variant.getGameModeForMap(param2);
         if(this._gameMutators != null && this._gameMutators.length > 0)
         {
            param1.gameMutators = new ArrayCollection(this._gameMutators);
         }
         else
         {
            param1.gameMutators = new ArrayCollection();
         }
      }
      
      private function getPracticeGameTypeConfigs() : ArrayCollection
      {
         var _loc3_:GameTypeConfig = null;
         var _loc1_:ArrayCollection = GameTypeConfigManager.instance.getPracticeGameTypeConfigs();
         var _loc2_:ArrayCollection = null;
         if(this.filterFeaturedGamePickModes)
         {
            _loc2_ = new ArrayCollection();
            for each(_loc3_ in _loc1_)
            {
               if(!_loc3_.featuredGameTypeConfig)
               {
                  _loc2_.addItem(_loc3_);
               }
            }
            _loc1_ = _loc2_;
         }
         if(this._overriddenGamePickIds != null)
         {
            _loc2_ = new ArrayCollection();
            for each(_loc3_ in _loc1_)
            {
               if(this._overriddenGamePickIds.contains(_loc3_.id))
               {
                  _loc2_.addItem(_loc3_);
               }
            }
         }
         else
         {
            _loc2_ = _loc1_;
         }
         return _loc2_;
      }
   }
}

