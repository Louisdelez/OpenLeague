package
{
   import com.riotgames.platform.common.exception.InvalidSessionException;
   import com.riotgames.platform.common.exception.PlatformException;
   import com.riotgames.platform.common.exception.UnexpectedServiceException;
   import com.riotgames.platform.common.exception.ValidationException;
   import com.riotgames.platform.gameclient.CDC.ClientDynamicConfigurationNotification;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.chat.domain.AutojoinChatDesc;
   import com.riotgames.platform.gameclient.domain.AccountInformation;
   import com.riotgames.platform.gameclient.domain.AccountSummary;
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
   import com.riotgames.platform.gameclient.domain.AggregatedStats;
   import com.riotgames.platform.gameclient.domain.AggregatedStatsKey;
   import com.riotgames.platform.gameclient.domain.AllPublicSummonerDataDTO;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.platform.gameclient.domain.BaseItem;
   import com.riotgames.platform.gameclient.domain.BasePublicSummonerDTO;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.ChampionStatInfo;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.ForcedClientShutdown;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameObserver;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.GlobalPrefs;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   import com.riotgames.platform.gameclient.domain.Item;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.ItemType;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import com.riotgames.platform.gameclient.domain.MasteryBookDTO;
   import com.riotgames.platform.gameclient.domain.MasteryBookPageDTO;
   import com.riotgames.platform.gameclient.domain.MatchMakerParams;
   import com.riotgames.platform.gameclient.domain.MiniSeriesDTO;
   import com.riotgames.platform.gameclient.domain.ObfuscatedParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.PlayerComplaint;
   import com.riotgames.platform.gameclient.domain.PlayerCredentialsDTO;
   import com.riotgames.platform.gameclient.domain.PlayerGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerLifetimeStats;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummaries;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStats;
   import com.riotgames.platform.gameclient.domain.PointsPenalty;
   import com.riotgames.platform.gameclient.domain.PublicSummoner;
   import com.riotgames.platform.gameclient.domain.RawStat;
   import com.riotgames.platform.gameclient.domain.RawStatDTO;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneCombiner;
   import com.riotgames.platform.gameclient.domain.RuneQuantity;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import com.riotgames.platform.gameclient.domain.SlotEntry;
   import com.riotgames.platform.gameclient.domain.SpectatorEndOfGameStats;
   import com.riotgames.platform.gameclient.domain.SpectatorPlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.SpectatorRawStatDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.StartChampSelectDTO;
   import com.riotgames.platform.gameclient.domain.SummaryAggStat;
   import com.riotgames.platform.gameclient.domain.SummaryAggStats;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerCatalog;
   import com.riotgames.platform.gameclient.domain.SummonerDefaultSpells;
   import com.riotgames.platform.gameclient.domain.SummonerIconInventoryDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemAndProgressDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemsDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueRewardsDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeaguesDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.gameclient.domain.SummonerLevelAndPoints;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.domain.SummonerRuneInventory;
   import com.riotgames.platform.gameclient.domain.SummonerSummary;
   import com.riotgames.platform.gameclient.domain.SummonerTalentsAndPoints;
   import com.riotgames.platform.gameclient.domain.TeamSkinRentalDTO;
   import com.riotgames.platform.gameclient.domain.UserLocaleProperties;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.gameclient.domain.accountState.AccountStateChangeNotification;
   import com.riotgames.platform.gameclient.domain.binge.BingePreventionNotification;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastNotification;
   import com.riotgames.platform.gameclient.domain.broadcast.ClientLoginKickNotification;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessageResponse;
   import com.riotgames.platform.gameclient.domain.featuredgame.FeaturedGameMetadataDTO;
   import com.riotgames.platform.gameclient.domain.game.FeaturedGameInfo;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMapEnabledDTO;
   import com.riotgames.platform.gameclient.domain.game.GameNotification;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameReconnectionInfo;
   import com.riotgames.platform.gameclient.domain.game.matched.BustedLeaver;
   import com.riotgames.platform.gameclient.domain.game.matched.FailedJoinPlayer;
   import com.riotgames.platform.gameclient.domain.game.matched.LeaverBusterLowPriorityQueueAbandoned;
   import com.riotgames.platform.gameclient.domain.game.matched.MatchSearchNotification;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueDisabled;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueDodger;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueInfo;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueRestricted;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueThrottled;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameSearchResult;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.PlayerPreferences;
   import com.riotgames.platform.gameclient.domain.inventory.ActiveBoosts;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.domain.loyalty.ChampionReward;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyRewards;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyStateChangeNotification;
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyResponseDTO;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Roster;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatDetail;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatSummary;
   import com.riotgames.platform.gameclient.domain.reroll.EogPointChangeBreakdown;
   import com.riotgames.platform.gameclient.domain.reroll.PointSummary;
   import com.riotgames.platform.gameclient.domain.social.SocialNetworkSummonerDTO;
   import com.riotgames.platform.gameclient.domain.social.SocialNetworkUserDTO;
   import com.riotgames.platform.gameclient.domain.social.SummonerSocialNetworkUserId;
   import com.riotgames.platform.gameclient.domain.store.RentalUpdateNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreAccountBalanceNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.gameclient.domain.summoner.customization.SummonerNameChangeDTO;
   import com.riotgames.platform.gameclient.domain.systemstates.ClientSystemStatesNotification;
   import com.riotgames.platform.gameclient.domain.systemstates.ReplaySystemStates;
   import com.riotgames.platform.gameclient.masteries.Talent;
   import flash.net.getClassByAlias;
   import flash.net.registerClassAlias;
   import flash.system.*;
   import flash.utils.*;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.graphics.ImageSnapshot;
   import mx.messaging.config.ConfigMap;
   import mx.messaging.messages.AcknowledgeMessage;
   import mx.messaging.messages.AcknowledgeMessageExt;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.AsyncMessageExt;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.CommandMessageExt;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.MessagePerformanceInfo;
   import mx.styles.StyleManager;
   import mx.utils.ObjectProxy;
   
   public class _ClientModuleMain_FlexInit
   {
      
      public function _ClientModuleMain_FlexInit()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var i:int;
         var styleNames:Array;
         var fbs:IFlexModuleFactory = param1;
         EffectManager.mx_internal::registerEffectTrigger("addedEffect","added");
         EffectManager.mx_internal::registerEffectTrigger("closeEffect","windowClose");
         EffectManager.mx_internal::registerEffectTrigger("completeEffect","complete");
         EffectManager.mx_internal::registerEffectTrigger("creationCompleteEffect","creationComplete");
         EffectManager.mx_internal::registerEffectTrigger("focusInEffect","focusIn");
         EffectManager.mx_internal::registerEffectTrigger("focusOutEffect","focusOut");
         EffectManager.mx_internal::registerEffectTrigger("hideDataEffect","hideData");
         EffectManager.mx_internal::registerEffectTrigger("hideEffect","hide");
         EffectManager.mx_internal::registerEffectTrigger("itemsChangeEffect","itemsChange");
         EffectManager.mx_internal::registerEffectTrigger("minimizeEffect","windowMinimize");
         EffectManager.mx_internal::registerEffectTrigger("mouseDownEffect","mouseDown");
         EffectManager.mx_internal::registerEffectTrigger("mouseUpEffect","mouseUp");
         EffectManager.mx_internal::registerEffectTrigger("moveEffect","move");
         EffectManager.mx_internal::registerEffectTrigger("removedEffect","removed");
         EffectManager.mx_internal::registerEffectTrigger("resizeEffect","resize");
         EffectManager.mx_internal::registerEffectTrigger("resizeEndEffect","resizeEnd");
         EffectManager.mx_internal::registerEffectTrigger("resizeStartEffect","resizeStart");
         EffectManager.mx_internal::registerEffectTrigger("rollOutEffect","rollOut");
         EffectManager.mx_internal::registerEffectTrigger("rollOverEffect","rollOver");
         EffectManager.mx_internal::registerEffectTrigger("showDataEffect","showData");
         EffectManager.mx_internal::registerEffectTrigger("showEffect","show");
         EffectManager.mx_internal::registerEffectTrigger("unminimizeEffect","windowUnminimize");
         try
         {
            if(getClassByAlias("com.riotgames.platform.login.InvalidSessionException") == null)
            {
               registerClassAlias("com.riotgames.platform.login.InvalidSessionException",InvalidSessionException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.login.InvalidSessionException",InvalidSessionException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.PlatformException") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.PlatformException",PlatformException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.PlatformException",PlatformException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.UnexpectedServiceException") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.UnexpectedServiceException",UnexpectedServiceException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.UnexpectedServiceException",UnexpectedServiceException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.ValidationException") == null)
            {
               registerClassAlias("com.riotgames.platform.ValidationException",ValidationException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.ValidationException",ValidationException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.client.dynamic.configuration.ClientDynamicConfigurationNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.client.dynamic.configuration.ClientDynamicConfigurationNotification",ClientDynamicConfigurationNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.client.dynamic.configuration.ClientDynamicConfigurationNotification",ClientDynamicConfigurationNotification);
         }
         try
         {
            if(getClassByAlias(">com.riotgames.platform.gameclient.Models.GameModel") == null)
            {
               registerClassAlias(">com.riotgames.platform.gameclient.Models.GameModel",GameModel);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.riotgames.platform.gameclient.Models.GameModel",GameModel);
         }
         try
         {
            if(getClassByAlias(">com.riotgames.platform.gameclient.chat.domain.AutojoinChatDesc") == null)
            {
               registerClassAlias(">com.riotgames.platform.gameclient.chat.domain.AutojoinChatDesc",AutojoinChatDesc);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.riotgames.platform.gameclient.chat.domain.AutojoinChatDesc",AutojoinChatDesc);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.account.management.AccountInformation") == null)
            {
               registerClassAlias("com.riotgames.platform.account.management.AccountInformation",AccountInformation);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.account.management.AccountInformation",AccountInformation);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.account.AccountSummary") == null)
            {
               registerClassAlias("com.riotgames.platform.account.AccountSummary",AccountSummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.account.AccountSummary",AccountSummary);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.AggregatedStat") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.AggregatedStat",AggregatedStat);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.AggregatedStat",AggregatedStat);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.AggregatedStatType") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.AggregatedStatType",AggregatedStatType);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.AggregatedStatType",AggregatedStatType);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.AggregatedStats") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.AggregatedStats",AggregatedStats);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.AggregatedStats",AggregatedStats);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.AggregatedStatsKey") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.AggregatedStatsKey",AggregatedStatsKey);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.AggregatedStatsKey",AggregatedStatsKey);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.AllPublicSummonerDataDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.AllPublicSummonerDataDTO",AllPublicSummonerDataDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.AllPublicSummonerDataDTO",AllPublicSummonerDataDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.AllSummonerData") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.AllSummonerData",AllSummonerData);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.AllSummonerData",AllSummonerData);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.catalog.BaseItem") == null)
            {
               registerClassAlias("com.riotgames.platform.catalog.BaseItem",BaseItem);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.catalog.BaseItem",BaseItem);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.BasePublicSummonerDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.BasePublicSummonerDTO",BasePublicSummonerDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.BasePublicSummonerDTO",BasePublicSummonerDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.BotParticipant") == null)
            {
               registerClassAlias("com.riotgames.platform.game.BotParticipant",BotParticipant);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.BotParticipant",BotParticipant);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.catalog.champion.ChampionDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.catalog.champion.ChampionDTO",Champion);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.catalog.champion.ChampionDTO",Champion);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.catalog.champion.ChampionSkinDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.catalog.champion.ChampionSkinDTO",ChampionSkin);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.catalog.champion.ChampionSkinDTO",ChampionSkin);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.ChampionStatInfo") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.ChampionStatInfo",ChampionStatInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.ChampionStatInfo",ChampionStatInfo);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.EndOfGameStats") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.EndOfGameStats",EndOfGameStats);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.EndOfGameStats",EndOfGameStats);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.ForcedClientShutdown") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.ForcedClientShutdown",ForcedClientShutdown);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.ForcedClientShutdown",ForcedClientShutdown);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.GameDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.game.GameDTO",GameDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.GameDTO",GameDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.GameObserver") == null)
            {
               registerClassAlias("com.riotgames.platform.game.GameObserver",GameObserver);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.GameObserver",GameObserver);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.GameParticipant") == null)
            {
               registerClassAlias("com.riotgames.platform.game.GameParticipant",GameParticipant);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.GameParticipant",GameParticipant);
         }
         try
         {
            if(getClassByAlias(">com.riotgames.platform.gameclient.domain.GlobalPrefs") == null)
            {
               registerClassAlias(">com.riotgames.platform.gameclient.domain.GlobalPrefs",GlobalPrefs);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.riotgames.platform.gameclient.domain.GlobalPrefs",GlobalPrefs);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.IParticipant") == null)
            {
               registerClassAlias("com.riotgames.platform.game.IParticipant",IParticipant);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.IParticipant",IParticipant);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.Item") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.Item",Item);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.Item",Item);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.catalog.ItemEffect") == null)
            {
               registerClassAlias("com.riotgames.platform.catalog.ItemEffect",ItemEffect);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.catalog.ItemEffect",ItemEffect);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.ItemType") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.ItemType",ItemType);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.ItemType",ItemType);
         }
         try
         {
            if(getClassByAlias("com.riotgames.leagues.pojo.LeagueItemDTO") == null)
            {
               registerClassAlias("com.riotgames.leagues.pojo.LeagueItemDTO",LeagueItemDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.leagues.pojo.LeagueItemDTO",LeagueItemDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.leagues.pojo.LeagueListDTO") == null)
            {
               registerClassAlias("com.riotgames.leagues.pojo.LeagueListDTO",LeagueListDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.leagues.pojo.LeagueListDTO",LeagueListDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.masterybook.MasteryBookDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.masterybook.MasteryBookDTO",MasteryBookDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.masterybook.MasteryBookDTO",MasteryBookDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.masterybook.MasteryBookPageDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.masterybook.MasteryBookPageDTO",MasteryBookPageDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.masterybook.MasteryBookPageDTO",MasteryBookPageDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.MatchMakerParams") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.MatchMakerParams",MatchMakerParams);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.MatchMakerParams",MatchMakerParams);
         }
         try
         {
            if(getClassByAlias("com.riotgames.leagues.pojo.MiniSeriesDTO") == null)
            {
               registerClassAlias("com.riotgames.leagues.pojo.MiniSeriesDTO",MiniSeriesDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.leagues.pojo.MiniSeriesDTO",MiniSeriesDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.ObfuscatedParticipant") == null)
            {
               registerClassAlias("com.riotgames.platform.game.ObfuscatedParticipant",ObfuscatedParticipant);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.ObfuscatedParticipant",ObfuscatedParticipant);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.PlayerChampionSelectionDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.game.PlayerChampionSelectionDTO",PlayerChampionSelectionDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.PlayerChampionSelectionDTO",PlayerChampionSelectionDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.harassment.HarassmentReport") == null)
            {
               registerClassAlias("com.riotgames.platform.harassment.HarassmentReport",PlayerComplaint);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.harassment.HarassmentReport",PlayerComplaint);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.PlayerCredentialsDto") == null)
            {
               registerClassAlias("com.riotgames.platform.game.PlayerCredentialsDto",PlayerCredentialsDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.PlayerCredentialsDto",PlayerCredentialsDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.PlayerGameStats") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.PlayerGameStats",PlayerGameStats);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.PlayerGameStats",PlayerGameStats);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.PlayerLifetimeStats") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.PlayerLifetimeStats",PlayerLifetimeStats);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.PlayerLifetimeStats",PlayerLifetimeStats);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.PlayerParticipant") == null)
            {
               registerClassAlias("com.riotgames.platform.game.PlayerParticipant",PlayerParticipant);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.PlayerParticipant",PlayerParticipant);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.PlayerParticipantStatsSummary") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.PlayerParticipantStatsSummary",PlayerParticipantStatsSummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.PlayerParticipantStatsSummary",PlayerParticipantStatsSummary);
         }
         try
         {
            if(getClassByAlias(">com.riotgames.platform.gameclient.domain.PlayerStat") == null)
            {
               registerClassAlias(">com.riotgames.platform.gameclient.domain.PlayerStat",PlayerStat);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.riotgames.platform.gameclient.domain.PlayerStat",PlayerStat);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.PlayerStatSummaries") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.PlayerStatSummaries",PlayerStatSummaries);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.PlayerStatSummaries",PlayerStatSummaries);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.PlayerStatSummary") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.PlayerStatSummary",PlayerStatSummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.PlayerStatSummary",PlayerStatSummary);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.PlayerStats") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.PlayerStats",PlayerStats);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.PlayerStats",PlayerStats);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.PointsPenalty") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.PointsPenalty",PointsPenalty);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.PointsPenalty",PointsPenalty);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.PublicSummoner") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.PublicSummoner",PublicSummoner);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.PublicSummoner",PublicSummoner);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.RawStat") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.RawStat",RawStat);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.RawStat",RawStat);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.RawStatDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.RawStatDTO",RawStatDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.RawStatDTO",RawStatDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.RawStatType") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.RawStatType",RawStatType);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.RawStatType",RawStatType);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.catalog.runes.Rune") == null)
            {
               registerClassAlias("com.riotgames.platform.catalog.runes.Rune",Rune);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.catalog.runes.Rune",Rune);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.inventory.loot.RuneCombiner") == null)
            {
               registerClassAlias("com.riotgames.platform.inventory.loot.RuneCombiner",RuneCombiner);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.inventory.loot.RuneCombiner",RuneCombiner);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.catalog.runes.RuneQuantity") == null)
            {
               registerClassAlias("com.riotgames.platform.catalog.runes.RuneQuantity",RuneQuantity);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.catalog.runes.RuneQuantity",RuneQuantity);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.RuneSlot") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.RuneSlot",RuneSlot);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.RuneSlot",RuneSlot);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.catalog.runes.RuneType") == null)
            {
               registerClassAlias("com.riotgames.platform.catalog.runes.RuneType",RuneType);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.catalog.runes.RuneType",RuneType);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.login.Session") == null)
            {
               registerClassAlias("com.riotgames.platform.login.Session",ServerSessionObject);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.login.Session",ServerSessionObject);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.spellbook.SlotEntry") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.spellbook.SlotEntry",SlotEntry);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.spellbook.SlotEntry",SlotEntry);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.observer.domain.EndOfGameStats") == null)
            {
               registerClassAlias("com.riotgames.platform.observer.domain.EndOfGameStats",SpectatorEndOfGameStats);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.observer.domain.EndOfGameStats",SpectatorEndOfGameStats);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.observer.domain.PlayerParticipantStatsSummary") == null)
            {
               registerClassAlias("com.riotgames.platform.observer.domain.PlayerParticipantStatsSummary",SpectatorPlayerParticipantStatsSummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.observer.domain.PlayerParticipantStatsSummary",SpectatorPlayerParticipantStatsSummary);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.observer.domain.RawStatDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.observer.domain.RawStatDTO",SpectatorRawStatDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.observer.domain.RawStatDTO",SpectatorRawStatDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.spellbook.SpellBookDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.spellbook.SpellBookDTO",SpellBookDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.spellbook.SpellBookDTO",SpellBookDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.spellbook.SpellBookPageDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.spellbook.SpellBookPageDTO",SpellBookPageDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.spellbook.SpellBookPageDTO",SpellBookPageDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.StartChampSelectDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.game.StartChampSelectDTO",StartChampSelectDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.StartChampSelectDTO",StartChampSelectDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.SummaryAggStat") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.SummaryAggStat",SummaryAggStat);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.SummaryAggStat",SummaryAggStat);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.statistics.SummaryAggStats") == null)
            {
               registerClassAlias("com.riotgames.platform.statistics.SummaryAggStats",SummaryAggStats);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.statistics.SummaryAggStats",SummaryAggStats);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.Summoner") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.Summoner",Summoner);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.Summoner",Summoner);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SummonerCatalog") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SummonerCatalog",SummonerCatalog);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SummonerCatalog",SummonerCatalog);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SummonerDefaultSpells") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SummonerDefaultSpells",SummonerDefaultSpells);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SummonerDefaultSpells",SummonerDefaultSpells);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.icon.SummonerIconInventoryDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.icon.SummonerIconInventoryDTO",SummonerIconInventoryDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.icon.SummonerIconInventoryDTO",SummonerIconInventoryDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemAndProgressDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemAndProgressDTO",SummonerLeagueItemAndProgressDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemAndProgressDTO",SummonerLeagueItemAndProgressDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemDTO",SummonerLeagueItemDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemDTO",SummonerLeagueItemDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemsDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemsDTO",SummonerLeagueItemsDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueItemsDTO",SummonerLeagueItemsDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueRewardsDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueRewardsDTO",SummonerLeagueRewardsDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeagueRewardsDTO",SummonerLeagueRewardsDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.leagues.client.dto.SummonerLeaguesDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeaguesDTO",SummonerLeaguesDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.leagues.client.dto.SummonerLeaguesDTO",SummonerLeaguesDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SummonerLevel") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SummonerLevel",SummonerLevel);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SummonerLevel",SummonerLevel);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SummonerLevelAndPoints") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SummonerLevelAndPoints",SummonerLevelAndPoints);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SummonerLevelAndPoints",SummonerLevelAndPoints);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.runes.SummonerRune") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.runes.SummonerRune",SummonerRune);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.runes.SummonerRune",SummonerRune);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.runes.SummonerRuneInventory") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.runes.SummonerRuneInventory",SummonerRuneInventory);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.runes.SummonerRuneInventory",SummonerRuneInventory);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SummonerSummary") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SummonerSummary",SummonerSummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SummonerSummary",SummonerSummary);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SummonerTalentsAndPoints") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SummonerTalentsAndPoints",SummonerTalentsAndPoints);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SummonerTalentsAndPoints",SummonerTalentsAndPoints);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.skin.rental.service.pojo.TeamSkinRentalDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.skin.rental.service.pojo.TeamSkinRentalDTO",TeamSkinRentalDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.skin.rental.service.pojo.TeamSkinRentalDTO",TeamSkinRentalDTO);
         }
         try
         {
            if(getClassByAlias(">com.riotgames.platform.gameclient.domain.UserLocaleProperties") == null)
            {
               registerClassAlias(">com.riotgames.platform.gameclient.domain.UserLocaleProperties",UserLocaleProperties);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.riotgames.platform.gameclient.domain.UserLocaleProperties",UserLocaleProperties);
         }
         try
         {
            if(getClassByAlias(">com.riotgames.platform.gameclient.domain.UserPrefs") == null)
            {
               registerClassAlias(">com.riotgames.platform.gameclient.domain.UserPrefs",UserPrefs);
            }
         }
         catch(e:Error)
         {
            registerClassAlias(">com.riotgames.platform.gameclient.domain.UserPrefs",UserPrefs);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.account.impl.AccountStateChangeEventImpl") == null)
            {
               registerClassAlias("com.riotgames.platform.account.impl.AccountStateChangeEventImpl",AccountStateChangeNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.account.impl.AccountStateChangeEventImpl",AccountStateChangeNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.binge.server.BingePreventionNotification") == null)
            {
               registerClassAlias("com.riotgames.binge.server.BingePreventionNotification",BingePreventionNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.binge.server.BingePreventionNotification",BingePreventionNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.broadcast.BroadcastMessage") == null)
            {
               registerClassAlias("com.riotgames.platform.broadcast.BroadcastMessage",BroadcastMessage);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.broadcast.BroadcastMessage",BroadcastMessage);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.broadcast.BroadcastNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.broadcast.BroadcastNotification",BroadcastNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.broadcast.BroadcastNotification",BroadcastNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.ClientLoginKickNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.ClientLoginKickNotification",ClientLoginKickNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.ClientLoginKickNotification",ClientLoginKickNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.persistence.SimpleDialogMessageResponse") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.persistence.SimpleDialogMessageResponse",SimpleDialogMessageResponse);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.persistence.SimpleDialogMessageResponse",SimpleDialogMessageResponse);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.featuredgame.metadata.service.pojo.FeaturedGameMetadataDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.featuredgame.metadata.service.pojo.FeaturedGameMetadataDTO",FeaturedGameMetadataDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.featuredgame.metadata.service.pojo.FeaturedGameMetadataDTO",FeaturedGameMetadataDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.FeaturedGameInfo") == null)
            {
               registerClassAlias("com.riotgames.platform.game.FeaturedGameInfo",FeaturedGameInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.FeaturedGameInfo",FeaturedGameInfo);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.map.GameMap") == null)
            {
               registerClassAlias("com.riotgames.platform.game.map.GameMap",GameMap);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.map.GameMap",GameMap);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.map.GameMapEnabledDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.game.map.GameMapEnabledDTO",GameMapEnabledDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.map.GameMapEnabledDTO",GameMapEnabledDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.message.GameNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.game.message.GameNotification",GameNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.message.GameNotification",GameNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.GameQueueConfig") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.GameQueueConfig",GameQueueConfig);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.GameQueueConfig",GameQueueConfig);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.PlatformGameLifecycleDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.game.PlatformGameLifecycleDTO",GameReconnectionInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.PlatformGameLifecycleDTO",GameReconnectionInfo);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.BustedLeaver") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.BustedLeaver",BustedLeaver);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.BustedLeaver",BustedLeaver);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.FailedJoinPlayer") == null)
            {
               registerClassAlias("com.riotgames.platform.game.FailedJoinPlayer",FailedJoinPlayer);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.FailedJoinPlayer",FailedJoinPlayer);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.leaverbuster.event.messaging.LeaverBusterLowPriorityQueueAbandoned") == null)
            {
               registerClassAlias("com.riotgames.platform.leaverbuster.event.messaging.LeaverBusterLowPriorityQueueAbandoned",LeaverBusterLowPriorityQueueAbandoned);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.leaverbuster.event.messaging.LeaverBusterLowPriorityQueueAbandoned",LeaverBusterLowPriorityQueueAbandoned);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.SearchingForMatchNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.SearchingForMatchNotification",MatchSearchNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.SearchingForMatchNotification",MatchSearchNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.QueueDisabled") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.QueueDisabled",QueueDisabled);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.QueueDisabled",QueueDisabled);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.QueueDodger") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.QueueDodger",QueueDodger);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.QueueDodger",QueueDodger);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.QueueInfo") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.QueueInfo",QueueInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.QueueInfo",QueueInfo);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.QueueRestricted") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.QueueRestricted",QueueRestricted);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.QueueRestricted",QueueRestricted);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.QueueThrottled") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.QueueThrottled",QueueThrottled);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.QueueThrottled",QueueThrottled);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.PracticeGameConfig") == null)
            {
               registerClassAlias("com.riotgames.platform.game.PracticeGameConfig",PracticeGameConfig);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.PracticeGameConfig",PracticeGameConfig);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.practice.PracticeGameSearchResult") == null)
            {
               registerClassAlias("com.riotgames.platform.game.practice.PracticeGameSearchResult",PracticeGameSearchResult);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.practice.PracticeGameSearchResult",PracticeGameSearchResult);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.game.GameTypeConfigDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.game.GameTypeConfigDTO",GameTypeConfig);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.GameTypeConfigDTO",GameTypeConfig);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.playerpreference.dto.PlayerPreferencesDto") == null)
            {
               registerClassAlias("com.riotgames.platform.playerpreference.dto.PlayerPreferencesDto",PlayerPreferences);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.playerpreference.dto.PlayerPreferencesDto",PlayerPreferences);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.boost.SummonerActiveBoostsDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.boost.SummonerActiveBoostsDTO",ActiveBoosts);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.boost.SummonerActiveBoostsDTO",ActiveBoosts);
         }
         try
         {
            if(getClassByAlias("com.riotgames.kudos.dto.PendingKudosDTO") == null)
            {
               registerClassAlias("com.riotgames.kudos.dto.PendingKudosDTO",PendingKudos);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.kudos.dto.PendingKudosDTO",PendingKudos);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.inventory.loyalty.ChampionReward") == null)
            {
               registerClassAlias("com.riotgames.platform.inventory.loyalty.ChampionReward",ChampionReward);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.inventory.loyalty.ChampionReward",ChampionReward);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.inventory.loyalty.LoyaltyRewards") == null)
            {
               registerClassAlias("com.riotgames.platform.inventory.loyalty.LoyaltyRewards",LoyaltyRewards);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.inventory.loyalty.LoyaltyRewards",LoyaltyRewards);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.loyalty.message.LoyaltyStateChangeNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.loyalty.message.LoyaltyStateChangeNotification",LoyaltyStateChangeNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.loyalty.message.LoyaltyStateChangeNotification",LoyaltyStateChangeNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.microfeedback.service.message.SurveyResponseDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.microfeedback.service.message.SurveyResponseDTO",SurveyResponseDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.microfeedback.service.message.SurveyResponseDTO",SurveyResponseDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.stats.MatchHistorySummary") == null)
            {
               registerClassAlias("com.riotgames.team.stats.MatchHistorySummary",MatchHistorySummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.stats.MatchHistorySummary",MatchHistorySummary);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.dto.PlayerDTO") == null)
            {
               registerClassAlias("com.riotgames.team.dto.PlayerDTO",Player);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.dto.PlayerDTO",Player);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.dto.RosterDTO") == null)
            {
               registerClassAlias("com.riotgames.team.dto.RosterDTO",Roster);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.dto.RosterDTO",Roster);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.dto.TeamDTO") == null)
            {
               registerClassAlias("com.riotgames.team.dto.TeamDTO",Team);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.dto.TeamDTO",Team);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.TeamId") == null)
            {
               registerClassAlias("com.riotgames.team.TeamId",TeamId);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.TeamId",TeamId);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.TeamInfo") == null)
            {
               registerClassAlias("com.riotgames.team.TeamInfo",TeamInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.TeamInfo",TeamInfo);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.dto.TeamMemberInfoDTO") == null)
            {
               registerClassAlias("com.riotgames.team.dto.TeamMemberInfoDTO",TeamMemberInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.dto.TeamMemberInfoDTO",TeamMemberInfo);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.stats.TeamStatDetail") == null)
            {
               registerClassAlias("com.riotgames.team.stats.TeamStatDetail",TeamStatDetail);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.stats.TeamStatDetail",TeamStatDetail);
         }
         try
         {
            if(getClassByAlias("com.riotgames.team.stats.TeamStatSummary") == null)
            {
               registerClassAlias("com.riotgames.team.stats.TeamStatSummary",TeamStatSummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.team.stats.TeamStatSummary",TeamStatSummary);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.reroll.pojo.EogPointChangeBreakdown") == null)
            {
               registerClassAlias("com.riotgames.platform.reroll.pojo.EogPointChangeBreakdown",EogPointChangeBreakdown);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.reroll.pojo.EogPointChangeBreakdown",EogPointChangeBreakdown);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.reroll.pojo.PointSummary") == null)
            {
               registerClassAlias("com.riotgames.platform.reroll.pojo.PointSummary",PointSummary);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.reroll.pojo.PointSummary",PointSummary);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SocialNetworkSummonerDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SocialNetworkSummonerDTO",SocialNetworkSummonerDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SocialNetworkSummonerDTO",SocialNetworkSummonerDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SocialNetworkUserDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SocialNetworkUserDTO",SocialNetworkUserDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SocialNetworkUserDTO",SocialNetworkUserDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.SummonerSocialNetworkUserId") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.SummonerSocialNetworkUserId",SummonerSocialNetworkUserId);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.SummonerSocialNetworkUserId",SummonerSocialNetworkUserId);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.RentalUpdateNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.RentalUpdateNotification",RentalUpdateNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.RentalUpdateNotification",RentalUpdateNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.StoreAccountBalanceNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.StoreAccountBalanceNotification",StoreAccountBalanceNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.StoreAccountBalanceNotification",StoreAccountBalanceNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.messaging.StoreFulfillmentNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.messaging.StoreFulfillmentNotification",StoreFulfillmentNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.messaging.StoreFulfillmentNotification",StoreFulfillmentNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo") == null)
            {
               registerClassAlias("com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo",LevelUpInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo",LevelUpInfo);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.customization.SummonerNameChangeDTO") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.customization.SummonerNameChangeDTO",SummonerNameChangeDTO);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.customization.SummonerNameChangeDTO",SummonerNameChangeDTO);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.systemstate.ClientSystemStatesNotification") == null)
            {
               registerClassAlias("com.riotgames.platform.systemstate.ClientSystemStatesNotification",ClientSystemStatesNotification);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.systemstate.ClientSystemStatesNotification",ClientSystemStatesNotification);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.systemstate.ReplaySystemStates") == null)
            {
               registerClassAlias("com.riotgames.platform.systemstate.ReplaySystemStates",ReplaySystemStates);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.systemstate.ReplaySystemStates",ReplaySystemStates);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.summoner.Talent") == null)
            {
               registerClassAlias("com.riotgames.platform.summoner.Talent",Talent);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.summoner.Talent",Talent);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayCollection") == null)
            {
               registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ArrayList") == null)
            {
               registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ArrayList",ArrayList);
         }
         try
         {
            if(getClassByAlias("flex.graphics.ImageSnapshot") == null)
            {
               registerClassAlias("flex.graphics.ImageSnapshot",ImageSnapshot);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.graphics.ImageSnapshot",ImageSnapshot);
         }
         try
         {
            if(getClassByAlias("flex.messaging.config.ConfigMap") == null)
            {
               registerClassAlias("flex.messaging.config.ConfigMap",ConfigMap);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.config.ConfigMap",ConfigMap);
         }
         try
         {
            if(getClassByAlias("flex.messaging.messages.AcknowledgeMessage") == null)
            {
               registerClassAlias("flex.messaging.messages.AcknowledgeMessage",AcknowledgeMessage);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.messages.AcknowledgeMessage",AcknowledgeMessage);
         }
         try
         {
            if(getClassByAlias("DSK") == null)
            {
               registerClassAlias("DSK",AcknowledgeMessageExt);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("DSK",AcknowledgeMessageExt);
         }
         try
         {
            if(getClassByAlias("flex.messaging.messages.AsyncMessage") == null)
            {
               registerClassAlias("flex.messaging.messages.AsyncMessage",AsyncMessage);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.messages.AsyncMessage",AsyncMessage);
         }
         try
         {
            if(getClassByAlias("DSA") == null)
            {
               registerClassAlias("DSA",AsyncMessageExt);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("DSA",AsyncMessageExt);
         }
         try
         {
            if(getClassByAlias("flex.messaging.messages.CommandMessage") == null)
            {
               registerClassAlias("flex.messaging.messages.CommandMessage",CommandMessage);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.messages.CommandMessage",CommandMessage);
         }
         try
         {
            if(getClassByAlias("DSC") == null)
            {
               registerClassAlias("DSC",CommandMessageExt);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("DSC",CommandMessageExt);
         }
         try
         {
            if(getClassByAlias("flex.messaging.messages.ErrorMessage") == null)
            {
               registerClassAlias("flex.messaging.messages.ErrorMessage",ErrorMessage);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.messages.ErrorMessage",ErrorMessage);
         }
         try
         {
            if(getClassByAlias("flex.messaging.messages.MessagePerformanceInfo") == null)
            {
               registerClassAlias("flex.messaging.messages.MessagePerformanceInfo",MessagePerformanceInfo);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.messages.MessagePerformanceInfo",MessagePerformanceInfo);
         }
         try
         {
            if(getClassByAlias("flex.messaging.io.ObjectProxy") == null)
            {
               registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
         }
         styleNames = ["kerning","iconColor","textRollOverColor","markerWidth","textDecoration","statusBarBackgroundColor","buttonPadding","fontThickness","titleAlignment","itemSelectionColor","selectionDisabledColor","buttonAlignment","letterSpacing","rollOverColor","itemRollOverColor","fontSize","shadowColor","strokeColor","titleBarColors","fontWeight","indicatorGap","leading","barColor","fontSharpness","axisTitleStyleName","modalTransparencyDuration","footerColors","statusTextStyleName","titleTextStyleName","fontAntiAliasType","errorColor","horizontalGridLineColor","backgroundDisabledColor","modalTransparencyColor","textIndent","themeColor","verticalGridLineColor","itemDisabledColor","modalTransparency","markerHeight","textAlign","headerColors","fontFamily","labelPlacement","textSelectedColor","strokeWidth","labelWidth","fontGridFitType","statusBarBackgroundSkin","fontStyle","dropShadowColor","disabledColor","selectionColor","titleBarBackgroundSkin","dropdownBorderColor","disabledIconColor","modalTransparencyBlur"
         ,"color","alternatingItemColors"];
         i = 0;
         while(i < styleNames.length)
         {
            StyleManager.registerInheritingStyle(styleNames[i]);
            i++;
         }
      }
   }
}

