package
{
   import com.riotgames.platform.common.domain.AuthenticationCredentials;
   import com.riotgames.platform.common.error.invite.AlreadyMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.error.invite.ExceededInviteBulkMaxSizeException;
   import com.riotgames.platform.common.error.invite.GameInvitationBaseRuntimeException;
   import com.riotgames.platform.common.error.invite.IncorrectLobbyStateException;
   import com.riotgames.platform.common.error.invite.LobbyClosedException;
   import com.riotgames.platform.common.error.invite.LobbyCreationNotEnabledException;
   import com.riotgames.platform.common.error.invite.LobbyFullException;
   import com.riotgames.platform.common.error.invite.NoInvitePrivilegesException;
   import com.riotgames.platform.common.error.invite.NotAMemberOfInvitationLobbyException;
   import com.riotgames.platform.common.error.invite.NotInvitableException;
   import com.riotgames.platform.common.error.invite.PlayerDoesNotExistException;
   import com.riotgames.platform.common.error.invite.PlayerInGameException;
   import com.riotgames.platform.common.error.invite.ServiceNotAvailableException;
   import com.riotgames.platform.common.error.invite.UserBannedException;
   import com.riotgames.platform.common.exception.AccountException;
   import com.riotgames.platform.common.exception.AccountManagementException;
   import com.riotgames.platform.common.exception.ClientVersionMismatchException;
   import com.riotgames.platform.common.exception.LoginFailedException;
   import com.riotgames.platform.common.exception.PlatformException;
   import com.riotgames.platform.common.exception.UnexpectedServiceException;
   import com.riotgames.platform.common.exception.ValidationException;
   import com.riotgames.platform.gameclient.CDC.ClientDynamicConfigurationNotification;
   import com.riotgames.platform.gameclient.domain.AccountInformation;
   import com.riotgames.platform.gameclient.domain.AccountSummary;
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.platform.gameclient.domain.BaseItem;
   import com.riotgames.platform.gameclient.domain.BasePublicSummonerDTO;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameObserver;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
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
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.PlayerComplaint;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneCombiner;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import com.riotgames.platform.gameclient.domain.SlotEntry;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerCatalog;
   import com.riotgames.platform.gameclient.domain.SummonerDefaultSpells;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemsDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.gameclient.domain.SummonerLevelAndPoints;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.domain.SummonerTalentsAndPoints;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessageResponse;
   import com.riotgames.platform.gameclient.domain.featuredgame.MetadataServiceNotAvailableException;
   import com.riotgames.platform.gameclient.domain.game.FeaturedGameInfo;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.platform.gameclient.domain.game.trade.ChampionsOutOfDateException;
   import com.riotgames.platform.gameclient.domain.gameconfig.PlayerPreferences;
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyResponseDTO;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.social.SummonerSocialNetworkUserId;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.gameclient.domain.systemstates.ReplaySystemStates;
   import com.riotgames.platform.gameclient.exception.GameException;
   import com.riotgames.platform.gameclient.exception.MatchmakingException;
   import com.riotgames.platform.gameclient.exception.NoRollsRemainException;
   import com.riotgames.platform.gameclient.exception.ServiceNotAvailableException;
   import com.riotgames.platform.gameclient.exception.SkinRentalAlreadyPurchasedException;
   import com.riotgames.platform.gameclient.exception.SkinRentalInsufficientFundsException;
   import com.riotgames.platform.gameclient.exception.SkinRentalStoreException;
   import com.riotgames.platform.gameclient.exception.SkinRentalsNotAvailableException;
   import flash.net.getClassByAlias;
   import flash.net.registerClassAlias;
   import flash.system.*;
   import flash.utils.*;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.core.IFlexModuleFactory;
   import mx.messaging.config.ConfigMap;
   import mx.messaging.messages.AcknowledgeMessage;
   import mx.messaging.messages.AcknowledgeMessageExt;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.AsyncMessageExt;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.CommandMessageExt;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.messaging.messages.MessagePerformanceInfo;
   import mx.messaging.messages.RemotingMessage;
   import mx.styles.StyleManager;
   import mx.utils.ObjectProxy;
   
   public class _ClientModuleServices_FlexInit
   {
      
      public function _ClientModuleServices_FlexInit()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var i:int;
         var styleNames:Array;
         var fbs:IFlexModuleFactory = param1;
         try
         {
            if(getClassByAlias("com.riotgames.platform.login.AuthenticationCredentials") == null)
            {
               registerClassAlias("com.riotgames.platform.login.AuthenticationCredentials",AuthenticationCredentials);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.login.AuthenticationCredentials",AuthenticationCredentials);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.AlreadyMemberOfInvitationLobbyException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.AlreadyMemberOfInvitationLobbyException",AlreadyMemberOfInvitationLobbyException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.AlreadyMemberOfInvitationLobbyException",AlreadyMemberOfInvitationLobbyException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.ExceededInviteBulkMaxSizeException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.ExceededInviteBulkMaxSizeException",ExceededInviteBulkMaxSizeException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.ExceededInviteBulkMaxSizeException",ExceededInviteBulkMaxSizeException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.GameInvitationBaseRuntimeException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.GameInvitationBaseRuntimeException",GameInvitationBaseRuntimeException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.GameInvitationBaseRuntimeException",GameInvitationBaseRuntimeException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.IncorrectLobbyStateException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.IncorrectLobbyStateException",IncorrectLobbyStateException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.IncorrectLobbyStateException",IncorrectLobbyStateException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.LobbyClosedException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.LobbyClosedException",LobbyClosedException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.LobbyClosedException",LobbyClosedException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.LobbyCreationNotEnabledException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.LobbyCreationNotEnabledException",LobbyCreationNotEnabledException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.LobbyCreationNotEnabledException",LobbyCreationNotEnabledException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.LobbyFullException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.LobbyFullException",LobbyFullException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.LobbyFullException",LobbyFullException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.NoInvitePrivilegesException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.NoInvitePrivilegesException",NoInvitePrivilegesException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.NoInvitePrivilegesException",NoInvitePrivilegesException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.NotAMemberOfInvitationLobbyException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.NotAMemberOfInvitationLobbyException",NotAMemberOfInvitationLobbyException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.NotAMemberOfInvitationLobbyException",NotAMemberOfInvitationLobbyException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.NotInvitableException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.NotInvitableException",NotInvitableException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.NotInvitableException",NotInvitableException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.PlayerDoesNotExistException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.PlayerDoesNotExistException",PlayerDoesNotExistException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.PlayerDoesNotExistException",PlayerDoesNotExistException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.PlayerInGameException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.PlayerInGameException",PlayerInGameException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.PlayerInGameException",PlayerInGameException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.ServiceNotAvailableException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.ServiceNotAvailableException",com.riotgames.platform.common.error.invite.ServiceNotAvailableException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.ServiceNotAvailableException",com.riotgames.platform.common.error.invite.ServiceNotAvailableException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.gameinvite.contract.error.UserBannedException") == null)
            {
               registerClassAlias("com.riotgames.platform.gameinvite.contract.error.UserBannedException",UserBannedException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.gameinvite.contract.error.UserBannedException",UserBannedException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.account.AccountException") == null)
            {
               registerClassAlias("com.riotgames.platform.account.AccountException",AccountException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.account.AccountException",AccountException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.account.management.AccountManagementException") == null)
            {
               registerClassAlias("com.riotgames.platform.account.management.AccountManagementException",AccountManagementException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.account.management.AccountManagementException",AccountManagementException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.login.impl.ClientVersionMismatchException") == null)
            {
               registerClassAlias("com.riotgames.platform.login.impl.ClientVersionMismatchException",ClientVersionMismatchException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.login.impl.ClientVersionMismatchException",ClientVersionMismatchException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.login.LoginFailedException") == null)
            {
               registerClassAlias("com.riotgames.platform.login.LoginFailedException",LoginFailedException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.login.LoginFailedException",LoginFailedException);
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
            if(getClassByAlias("com.riotgames.platform.featuredgame.metadata.service.api.MetadataServiceNotAvailableException") == null)
            {
               registerClassAlias("com.riotgames.platform.featuredgame.metadata.service.api.MetadataServiceNotAvailableException",MetadataServiceNotAvailableException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.featuredgame.metadata.service.api.MetadataServiceNotAvailableException",MetadataServiceNotAvailableException);
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
            if(getClassByAlias("com.riotgames.platform.trade.api.contract.exception.ChampionsOutOfDateException") == null)
            {
               registerClassAlias("com.riotgames.platform.trade.api.contract.exception.ChampionsOutOfDateException",ChampionsOutOfDateException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.trade.api.contract.exception.ChampionsOutOfDateException",ChampionsOutOfDateException);
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
            if(getClassByAlias("com.riotgames.platform.game.GameException") == null)
            {
               registerClassAlias("com.riotgames.platform.game.GameException",GameException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.game.GameException",GameException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.matchmaking.MatchmakingException") == null)
            {
               registerClassAlias("com.riotgames.platform.matchmaking.MatchmakingException",MatchmakingException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.matchmaking.MatchmakingException",MatchmakingException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.reroll.logic.exception.NoRollsRemainException") == null)
            {
               registerClassAlias("com.riotgames.platform.reroll.logic.exception.NoRollsRemainException",NoRollsRemainException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.reroll.logic.exception.NoRollsRemainException",NoRollsRemainException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.reroll.logic.exception.ServiceNotAvailableException") == null)
            {
               registerClassAlias("com.riotgames.platform.reroll.logic.exception.ServiceNotAvailableException",com.riotgames.platform.gameclient.exception.ServiceNotAvailableException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.reroll.logic.exception.ServiceNotAvailableException",com.riotgames.platform.gameclient.exception.ServiceNotAvailableException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalAlreadyPurchasedException") == null)
            {
               registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalAlreadyPurchasedException",SkinRentalAlreadyPurchasedException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalAlreadyPurchasedException",SkinRentalAlreadyPurchasedException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalInsufficientFundsException") == null)
            {
               registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalInsufficientFundsException",SkinRentalInsufficientFundsException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalInsufficientFundsException",SkinRentalInsufficientFundsException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalStoreException") == null)
            {
               registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalStoreException",SkinRentalStoreException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalStoreException",SkinRentalStoreException);
         }
         try
         {
            if(getClassByAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalsNotAvailableException") == null)
            {
               registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalsNotAvailableException",SkinRentalsNotAvailableException);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("com.riotgames.platform.skin.rental.service.api.SkinRentalsNotAvailableException",SkinRentalsNotAvailableException);
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
            if(getClassByAlias("flex.messaging.messages.HTTPMessage") == null)
            {
               registerClassAlias("flex.messaging.messages.HTTPMessage",HTTPRequestMessage);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.messages.HTTPMessage",HTTPRequestMessage);
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
            if(getClassByAlias("flex.messaging.messages.RemotingMessage") == null)
            {
               registerClassAlias("flex.messaging.messages.RemotingMessage",RemotingMessage);
            }
         }
         catch(e:Error)
         {
            registerClassAlias("flex.messaging.messages.RemotingMessage",RemotingMessage);
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
         styleNames = [];
         i = 0;
         while(i < styleNames.length)
         {
            StyleManager.registerInheritingStyle(styleNames[i]);
            i++;
         }
      }
   }
}

