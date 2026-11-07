package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.GeneratedContentLoader;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.GUID;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.LoginConfig;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   import com.riotgames.pvpnet.system.leagues.ProfileUtils;
   
   public class InitializeClientDataAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function InitializeClientDataAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         var _loc2_:Date = null;
         var _loc3_:UserPrefs = null;
         this._initialClientData.inventory.runeDictionary = GeneratedContentLoader.instance.runeDictionary;
         this._initialClientData.inventory.knownMaps = GeneratedContentLoader.instance.mapData;
         this._initialClientData.inventory.gameItemData = GeneratedContentLoader.instance.gameItemData;
         this._initialClientData.inventory.championCount = GeneratedContentLoader.instance.championCount;
         this._initialClientData.inventory.championDataDictionary = GeneratedContentLoader.instance.championDataDictionary;
         this._initialClientData.inventory.spellDictionary = GeneratedContentLoader.instance.spellDictionary;
         this._initialClientData.inventoryController.populateSearchTags(GeneratedContentLoader.instance.championSearchTags);
         this._initialClientData.inventoryController.populateSecondarySearchTags(GeneratedContentLoader.instance.championSearchTagsSecondary);
         ProfileUtils.competitiveRegion = this._initialClientData.loginDataPacket.competitiveRegion;
         Session.instance.coopGameRewardResetTimeRemaining = Math.ceil(this._initialClientData.loginDataPacket.coOpVsAiMsecsUntilReset);
         Session.instance.coopGameRewardTimeRemaining = this._initialClientData.loginDataPacket.coOpVsAiMinutesLeftToday;
         Session.instance.customGameRewardTimeRemaining = this._initialClientData.loginDataPacket.customMinutesLeftToday;
         Session.instance.customGameRewardResetTimeRemaining = Math.ceil(this._initialClientData.loginDataPacket.customMsecsUntilReset);
         Session.instance.firstWinOfDayTimeRemaining = Math.ceil(this._initialClientData.loginDataPacket.timeUntilFirstWinOfDay);
         Session.instance.summonerCatalog = this._initialClientData.loginDataPacket.summonerCatalog;
         var _loc1_:AllSummonerData = this._initialClientData.loginDataPacket.allSummonerData;
         if(_loc1_ != null)
         {
            Session.instance.applyAllSummonerData(_loc1_);
            Session.instance.setRestorePointForTalentsAndPoints();
            GUID.summonerID = _loc1_.summoner.sumId + "";
            this._initialClientData.inventory.runeBook = _loc1_.spellBook;
            this._initialClientData.runeBookController.hydrateSpellBook(_loc1_.spellBook);
            if(_loc1_.summoner != null)
            {
               UserPreferencesManager.instance.loadUserPreferences(_loc1_.summoner.name);
               Session.instance.accountSummary.summonerName = _loc1_.summoner.name;
               Session.instance.accountSummary.summonerInternalName = _loc1_.summoner.internalName;
               InventoryProviderProxy.instance.getInventoryController().loadUserInventory();
               if(Boolean(this._initialClientData.activeBoosts.xpBoostEnabled) && _loc1_.summonerLevel.summonerLevel >= 30)
               {
                  _loc2_ = new Date();
                  --_loc2_.date;
                  this._initialClientData.activeBoosts.xpBoostEndDate = _loc2_.time;
                  this._initialClientData.activeBoosts.xpBoostPerWinCount = 0;
                  _loc3_ = UserPreferencesManager.userPrefs;
                  _loc3_.hadXPTimeBoost = false;
                  _loc3_.hadXPWinBoost = false;
               }
               this._initialClientData.inventory.activeBoosts = this._initialClientData.activeBoosts;
            }
         }
         if(this._initialClientData.loginDataPacket.ipBalance > -1 || this._initialClientData.loginDataPacket.rpBalance > -1)
         {
            InventoryProviderProxy.instance.getInventoryController().setBalanceFromLoginPacket(this._initialClientData.loginDataPacket.ipBalance,this._initialClientData.loginDataPacket.rpBalance);
         }
         GameTypeConfigManager.instance.setGameTypeConfigs(this._initialClientData.loginDataPacket.gameTypeConfigs);
         if(this._initialClientData.loginDataPacket.platformId != null && this._initialClientData.loginDataPacket.platformId != "unknown")
         {
            ClientConfig.instance.platformId = this._initialClientData.loginDataPacket.platformId;
         }
         PlatformConfigProviderProxy.instance.updatePlatformConfig(this._initialClientData.loginDataPacket.clientSystemStates);
         PlatformConfigProviderProxy.instance.getPlatformConfig().allGameQueues = this._initialClientData.availableGameQueues;
         LoginConfig.instance.languages = this._initialClientData.loginDataPacket.languages;
         LoginConfig.instance.inGhostGame = this._initialClientData.loginDataPacket.inGhostGame;
         LoginConfig.instance.maxPracticeGameSize = this._initialClientData.loginDataPacket.maxPracticeGameSize;
         LoginConfig.instance.matchMakingEnabled = this._initialClientData.loginDataPacket.matchMakingEnabled;
         LoginConfig.instance.reconnectInfo = this._initialClientData.loginDataPacket.reconnectInfo;
         LoginConfig.instance.playerStatSummaries = this._initialClientData.loginDataPacket.playerStatSummaries;
         LoginConfig.instance.broadcastNotification = this._initialClientData.loginDataPacket.broadcastNotification;
         LoginConfig.instance.leaverBusterPenaltyTime = this._initialClientData.loginDataPacket.leaverBusterPenaltyTime;
         LoginConfig.instance.leaverPenaltyLevel = this._initialClientData.loginDataPacket.leaverPenaltyLevel;
         LoginConfig.instance.bingeIsPlayerInBingePreventionWindow = this._initialClientData.loginDataPacket.bingeIsPlayerInBingePreventionWindow;
         LoginConfig.instance.bingeMinutesRemaining = this._initialClientData.loginDataPacket.bingeMinutesRemaining;
         LoginConfig.instance.bingePreventionSystemEnabledForClient = this._initialClientData.loginDataPacket.bingePreventionSystemEnabledForClient;
         LoginConfig.instance.minorShutdownEnforced = this._initialClientData.loginDataPacket.minorShutdownEnforced;
         LoginConfig.instance.minor = this._initialClientData.loginDataPacket.minor;
         LoginConfig.instance.minutesUntilMidnight = this._initialClientData.loginDataPacket.minutesUntilMidnight;
         LoginConfig.instance.minutesUntilShutdownEnabled = this._initialClientData.loginDataPacket.minutesUntilShutdownEnabled;
         LoginConfig.instance.minutesUntilShutdown = this._initialClientData.loginDataPacket.minutesUntilShutdown;
         LoginConfig.instance.showEmailVerificationPopup = this._initialClientData.loginDataPacket.showEmailVerificationPopup;
         LoginConfig.instance.pendingKudosDTO = this._initialClientData.loginDataPacket.pendingKudosDTO;
         LoginConfig.instance.pendingBadges = this._initialClientData.loginDataPacket.pendingBadges;
         ClientConfig.instance.maxPracticeGameSize = this._initialClientData.loginDataPacket.maxPracticeGameSize;
         InventoryProviderProxy.instance.getInventoryInitialized().addOnce(this.onInventoryInitialized);
      }
      
      private function onInventoryInitialized() : void
      {
         complete();
      }
   }
}

