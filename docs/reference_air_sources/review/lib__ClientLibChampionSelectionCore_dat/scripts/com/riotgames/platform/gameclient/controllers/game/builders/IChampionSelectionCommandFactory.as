package com.riotgames.platform.gameclient.controllers.game.builders
{
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.controllers.game.controllers.IMasteriesManager;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionTrade;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public interface IChampionSelectionCommandFactory
   {
      
      function getSetTeamsCommand(param1:ChampionSelectionModel) : ICommand;
      
      function getTeamMapCommand(param1:Object, param2:ArrayCollection) : ICommand;
      
      function getLockInCommand(param1:ChampionSelectionModel) : ICommand;
      
      function getPlaySoundCommand(param1:String) : ICommand;
      
      function getSetVisibleChampionsCommand(param1:ChampionSelectionModel, param2:String, param3:Boolean, param4:Boolean, param5:Boolean) : ICommand;
      
      function getUpdateSpectatorsCommand(param1:ChampionSelectionModel, param2:Array, param3:Number) : ICommand;
      
      function getGameUpdateCommand(param1:ChampionSelectionModel, param2:ParticipantChampionListView, param3:Number, param4:Array) : ICommand;
      
      function getUpdateMenuStatesCommand(param1:ChampionSelectionModel) : ICommand;
      
      function getUpdatePlayerSelectionsForTeamCommand(param1:ParticipantChampionListView, param2:ArrayCollection, param3:ArrayCollection, param4:ArrayCollection, param5:String, param6:GameTypeConfig, param7:Boolean, param8:Boolean) : ICommand;
      
      function getShowDockedPromptMessageCommand(param1:String, param2:String, param3:Array, param4:String, param5:String, param6:String, param7:Boolean = true) : ICommand;
      
      function getUpdateParticipantChampionCommand(param1:Array, param2:IList, param3:Array) : ICommand;
      
      function getSelectRunePageCommand(param1:ChampionSelectionModel, param2:SpellBookDTO, param3:SpellBookPageDTO) : ICommand;
      
      function getUpdatePlayerSelectionsLengthForTeamCommand(param1:ArrayCollection, param2:ArrayCollection) : ICommand;
      
      function getShowTradeMessageCommand(param1:ChampionTrade, param2:String, param3:String, param4:Array, param5:uint = 5000) : ICommand;
      
      function getCloseChatRoomCommand(param1:ChampionSelectionModel) : ICommand;
      
      function getPrintMatchDetailsCommand(param1:GameDTO, param2:ChatRoom, param3:GameMap, param4:GameTypeConfig) : ICommand;
      
      function getAnonymizeNamesCommand(param1:ArrayCollection) : ICommand;
      
      function getSpellSelectCommand(param1:Spell, param2:Spell, param3:ChampionSelectionModel) : ICommand;
      
      function getInitializeBannableChampionsCommand(param1:ChampionSelectionModel) : ICommand;
      
      function getChangeChampionPresenceCommand(param1:Champion) : ICommand;
      
      function getUpdatePlayerSelectionTeamsCommand(param1:ArrayCollection, param2:String, param3:ArrayCollection, param4:String) : ICommand;
      
      function setChatRoomProvider(param1:IChatRoomProvider) : void;
      
      function getSetActiveTeamsCommand(param1:ChampionSelectionModel) : ICommand;
      
      function getDisabledChampionsForGameCommand(param1:GameDTO, param2:ParticipantChampionListView) : ICommand;
      
      function getResolveChampionReassignmentCommand(param1:ParticipantChampionListView, param2:ChampionSelectionModel) : ICommand;
      
      function getCreateChatRoomCommand(param1:GameDTO, param2:ChampionSelectionModel) : ICommand;
      
      function getCreateSpellSelectionsCommand(param1:ChampionSelectionModel, param2:String, param3:Number) : ICommand;
      
      function getFindAssignedItemsCommand(param1:ChampionSelectionModel) : ICommand;
      
      function getPlayMusicCommand(param1:String, param2:String, param3:int, param4:String) : ICommand;
      
      function getBanCommand(param1:Champion) : ICommand;
      
      function getSummonCommand(param1:Champion, param2:ChampionSelectionModel, param3:ParticipantChampionListView) : ICommand;
      
      function getMasteriesManager(param1:ChampionSelectionModel) : IMasteriesManager;
      
      function getUpdatePlayerSelectionBadgesCommand(param1:ArrayCollection, param2:ArrayCollection) : ICommand;
      
      function getUpdateBansCommand(param1:GameDTO, param2:ArrayCollection, param3:ArrayCollection, param4:ChampionSelectionModel, param5:Boolean) : ICommand;
      
      function getUpdatePlayerRosterCommand(param1:GameDTO, param2:Array, param3:Number, param4:Number) : ICommand;
      
      function getUpdateSpellSelectionFromDtoCommand(param1:PlayerSelection, param2:PlayerChampionSelectionDTO, param3:ArrayCollection) : ICommand;
      
      function getGetBannableChampionsCommand() : ICommand;
      
      function getSkinSelectCommand(param1:ChampionSelectionModel, param2:ChampionSkin) : ICommand;
      
      function getPrintBansCommand(param1:ChatRoom, param2:ParticipantChampionListView, param3:ArrayCollection, param4:Array) : ICommand;
   }
}

