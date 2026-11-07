package com.riotgames.platform.gameclient.controllers.game.builders
{
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.ChatService;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.controllers.game.commands.AnonymizeNamesCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.BanCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.CreateSpellSelectionsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.DisabledCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.FindAssignedItemsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.GameUpdateCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.GetBannableChampionsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.GetDisabledChampionsForGameCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.InitializeBannableChampionsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.MapTeamCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.ResolveChampionReassignmentCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.SetActiveTeamCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.SetTeamsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.SetVisibleChampionsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdateBansCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdateMenuStatesCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdateParticipantChampionCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdatePlayerRosterCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdatePlayerSelectionBadgesCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdatePlayerSelectionTeamsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdatePlayerSelectionsForTeamCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdatePlayerSelectionsLengthForTeamCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdateSpectatorsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.UpdateSpellsFromDTOCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.chat.ChangeChampionPresenceCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.chat.CloseChatRoomCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.chat.CreateChatRoomCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.chat.PrintBansCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.chat.PrintMatchDetailsCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.chat.ShowDockedPromptMessageCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.select.LockInCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.select.SkinSelectCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.select.SpellSelectCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.select.SummonCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.sound.PlayMusicCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.sound.PlaySoundCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.trades.ShowTradeMessageCommand;
   import com.riotgames.platform.gameclient.controllers.game.controllers.IMasteriesManager;
   import com.riotgames.platform.gameclient.controllers.game.controllers.MasteriesManager;
   import com.riotgames.platform.gameclient.controllers.game.controllers.SelectRunePageCommand;
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
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.platform.gameclient.services.SpellBookService;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   
   public class ChampionSelectionCommandFactory implements IChampionSelectionCommandFactory
   {
      
      private var _soundProvider:ISoundProvider;
      
      private var _dockedNotificationsProvider:INotificationsProvider;
      
      private var _inventoryController:IInventoryController;
      
      private var _presenceProvider:IPresenceProvider;
      
      private var _cursorManager:ICursorManager;
      
      private var _chatService:ChatService;
      
      private var _resourceManager:IResourceManager;
      
      private var _spellBookService:SpellBookService;
      
      private var _gameService:GameService;
      
      private var _chatRoomProvider:IChatRoomProvider;
      
      private var _alerterProvider:IAlerterProvider;
      
      private var _inventory:IInventory;
      
      public function ChampionSelectionCommandFactory(param1:IAlerterProvider, param2:ChatService, param3:GameService, param4:IInventory, param5:IInventoryController, param6:IChatRoomProvider, param7:IPresenceProvider, param8:INotificationsProvider, param9:ISoundProvider, param10:IResourceManager, param11:ICursorManager)
      {
         super();
         this._alerterProvider = param1;
         this._chatService = param2;
         this._gameService = param3;
         this._chatRoomProvider = param6;
         this._presenceProvider = param7;
         this._dockedNotificationsProvider = param8;
         this._soundProvider = param9;
         this._resourceManager = param10;
         this._cursorManager = param11;
         this._inventory = param4;
         this._inventoryController = param5;
      }
      
      public function getPlaySoundCommand(param1:String) : ICommand
      {
         return new PlaySoundCommand(param1,this._soundProvider);
      }
      
      public function getSetTeamsCommand(param1:ChampionSelectionModel) : ICommand
      {
         return new SetTeamsCommand(param1);
      }
      
      public function getUpdateParticipantChampionCommand(param1:Array, param2:IList, param3:Array) : ICommand
      {
         return new UpdateParticipantChampionCommand(param1,param2,param3);
      }
      
      public function getCreateChatRoomCommand(param1:GameDTO, param2:ChampionSelectionModel) : ICommand
      {
         if(!this._chatRoomProvider)
         {
            return this.getDisabledCommand(getQualifiedClassName(ShowDockedPromptMessageCommand),"IChatRoomProvider unavailable");
         }
         return new CreateChatRoomCommand(param1,param2,this._chatRoomProvider);
      }
      
      public function getSetActiveTeamsCommand(param1:ChampionSelectionModel) : ICommand
      {
         return new SetActiveTeamCommand(param1);
      }
      
      public function getFindAssignedItemsCommand(param1:ChampionSelectionModel) : ICommand
      {
         return new FindAssignedItemsCommand(param1);
      }
      
      public function getMasteriesManager(param1:ChampionSelectionModel) : IMasteriesManager
      {
         return new MasteriesManager(param1);
      }
      
      public function getPlayMusicCommand(param1:String, param2:String, param3:int, param4:String) : ICommand
      {
         return new PlayMusicCommand(this._soundProvider,param1,param2,param3,param4);
      }
      
      public function getResolveChampionReassignmentCommand(param1:ParticipantChampionListView, param2:ChampionSelectionModel) : ICommand
      {
         return new ResolveChampionReassignmentCommand(param1,param2,this._inventory);
      }
      
      public function getUpdateBansCommand(param1:GameDTO, param2:ArrayCollection, param3:ArrayCollection, param4:ChampionSelectionModel, param5:Boolean) : ICommand
      {
         return new UpdateBansCommand(param1,param2,param3,param4,param5);
      }
      
      public function getBanCommand(param1:Champion) : ICommand
      {
         return new BanCommand(param1,this._gameService,this._resourceManager,this._cursorManager);
      }
      
      public function getCreateSpellSelectionsCommand(param1:ChampionSelectionModel, param2:String, param3:Number) : ICommand
      {
         return new CreateSpellSelectionsCommand(param1,param2,param3,this._inventoryController);
      }
      
      public function getGetBannableChampionsCommand() : ICommand
      {
         return new GetBannableChampionsCommand(this._gameService,this._resourceManager,this._cursorManager);
      }
      
      public function getShowTradeMessageCommand(param1:ChampionTrade, param2:String, param3:String, param4:Array, param5:uint = 5000) : ICommand
      {
         return new ShowTradeMessageCommand(param1,param2,param3,param4,this._resourceManager,param5);
      }
      
      public function getSpellSelectCommand(param1:Spell, param2:Spell, param3:ChampionSelectionModel) : ICommand
      {
         return new SpellSelectCommand(param1,param2,param3,this._gameService);
      }
      
      public function getPrintMatchDetailsCommand(param1:GameDTO, param2:ChatRoom, param3:GameMap, param4:GameTypeConfig) : ICommand
      {
         return new PrintMatchDetailsCommand(param1,param2,param3,param4);
      }
      
      public function getUpdateSpectatorsCommand(param1:ChampionSelectionModel, param2:Array, param3:Number) : ICommand
      {
         return new UpdateSpectatorsCommand(param1,param2,param3);
      }
      
      public function getUpdatePlayerSelectionBadgesCommand(param1:ArrayCollection, param2:ArrayCollection) : ICommand
      {
         return new UpdatePlayerSelectionBadgesCommand(param1,param2);
      }
      
      public function getSummonCommand(param1:Champion, param2:ChampionSelectionModel, param3:ParticipantChampionListView) : ICommand
      {
         return new SummonCommand(param1,param2,param3,this._gameService,this._resourceManager,this._cursorManager);
      }
      
      public function getTeamMapCommand(param1:Object, param2:ArrayCollection) : ICommand
      {
         return new MapTeamCommand(param1,param2);
      }
      
      public function getSkinSelectCommand(param1:ChampionSelectionModel, param2:ChampionSkin) : ICommand
      {
         return new SkinSelectCommand(param1,param2,this._gameService,this._resourceManager,this._cursorManager);
      }
      
      public function getSetVisibleChampionsCommand(param1:ChampionSelectionModel, param2:String, param3:Boolean, param4:Boolean, param5:Boolean) : ICommand
      {
         return new SetVisibleChampionsCommand(param1,param2,param3,param4,param5);
      }
      
      public function getUpdateSpellSelectionFromDtoCommand(param1:PlayerSelection, param2:PlayerChampionSelectionDTO, param3:ArrayCollection) : ICommand
      {
         return new UpdateSpellsFromDTOCommand(param1,param2,param3);
      }
      
      public function getUpdatePlayerSelectionsForTeamCommand(param1:ParticipantChampionListView, param2:ArrayCollection, param3:ArrayCollection, param4:ArrayCollection, param5:String, param6:GameTypeConfig, param7:Boolean, param8:Boolean) : ICommand
      {
         return new UpdatePlayerSelectionsForTeamCommand(param1,param2,param3,param4,this._inventory,param5,param6,param7,param8);
      }
      
      public function getUpdatePlayerRosterCommand(param1:GameDTO, param2:Array, param3:Number, param4:Number) : ICommand
      {
         return new UpdatePlayerRosterCommand(param1,param2,param3,param4);
      }
      
      public function getChangeChampionPresenceCommand(param1:Champion) : ICommand
      {
         return new ChangeChampionPresenceCommand(param1,this._presenceProvider);
      }
      
      public function getInitializeBannableChampionsCommand(param1:ChampionSelectionModel) : ICommand
      {
         return new InitializeBannableChampionsCommand(param1,this._gameService,this._alerterProvider,this);
      }
      
      public function getGameUpdateCommand(param1:ChampionSelectionModel, param2:ParticipantChampionListView, param3:Number, param4:Array) : ICommand
      {
         return new GameUpdateCommand(param1,param2,param3,param4,this);
      }
      
      public function getLockInCommand(param1:ChampionSelectionModel) : ICommand
      {
         return new LockInCommand(this._gameService,this._soundProvider,param1,this._resourceManager,this._cursorManager);
      }
      
      public function getUpdatePlayerSelectionTeamsCommand(param1:ArrayCollection, param2:String, param3:ArrayCollection, param4:String) : ICommand
      {
         return new UpdatePlayerSelectionTeamsCommand(param1,param2,param3,param4);
      }
      
      public function getSelectRunePageCommand(param1:ChampionSelectionModel, param2:SpellBookDTO, param3:SpellBookPageDTO) : ICommand
      {
         return new SelectRunePageCommand(param1,param2,this._spellBookService,param3);
      }
      
      public function getShowDockedPromptMessageCommand(param1:String, param2:String, param3:Array, param4:String, param5:String, param6:String, param7:Boolean = true) : ICommand
      {
         if(!this._chatRoomProvider)
         {
            return this.getDisabledCommand(getQualifiedClassName(ShowDockedPromptMessageCommand),"IChatRoomProvider unavailable");
         }
         return new ShowDockedPromptMessageCommand(param1,param2,param3,param4,param5,param6,this._dockedNotificationsProvider,this._resourceManager,param7);
      }
      
      public function getUpdatePlayerSelectionsLengthForTeamCommand(param1:ArrayCollection, param2:ArrayCollection) : ICommand
      {
         return new UpdatePlayerSelectionsLengthForTeamCommand(param1,param2);
      }
      
      public function getUpdateMenuStatesCommand(param1:ChampionSelectionModel) : ICommand
      {
         return new UpdateMenuStatesCommand(param1);
      }
      
      public function getCloseChatRoomCommand(param1:ChampionSelectionModel) : ICommand
      {
         if(!this._chatRoomProvider || !param1.chatRoom)
         {
            return this.getDisabledCommand(getQualifiedClassName(ShowDockedPromptMessageCommand),"IChatRoomProvider unavailable");
         }
         return new CloseChatRoomCommand(param1,this._chatRoomProvider);
      }
      
      public function setChatRoomProvider(param1:IChatRoomProvider) : void
      {
         this._chatRoomProvider = param1;
      }
      
      public function getDisabledChampionsForGameCommand(param1:GameDTO, param2:ParticipantChampionListView) : ICommand
      {
         return new GetDisabledChampionsForGameCommand(param1,param2,this._resourceManager,this._cursorManager);
      }
      
      public function getAnonymizeNamesCommand(param1:ArrayCollection) : ICommand
      {
         return new AnonymizeNamesCommand(param1);
      }
      
      private function getDisabledCommand(param1:String, param2:String) : ICommand
      {
         return new DisabledCommand(param1,param2);
      }
      
      public function getPrintBansCommand(param1:ChatRoom, param2:ParticipantChampionListView, param3:ArrayCollection, param4:Array) : ICommand
      {
         return new PrintBansCommand(param1,param2,param3,param4,this._soundProvider);
      }
   }
}

