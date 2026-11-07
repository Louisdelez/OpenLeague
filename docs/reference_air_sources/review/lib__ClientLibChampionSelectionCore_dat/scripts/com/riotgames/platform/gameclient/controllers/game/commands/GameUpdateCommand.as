package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.gameclient.controllers.game.builders.IChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import mx.collections.ArrayCollection;
   
   public class GameUpdateCommand extends CommandBase
   {
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var playerRoster:Array = new Array();
      
      private var accountId:Number;
      
      public var myTeam:int;
      
      private var championSelections:ParticipantChampionListView;
      
      private var commandFactory:IChampionSelectionCommandFactory;
      
      public function GameUpdateCommand(param1:ChampionSelectionModel, param2:ParticipantChampionListView, param3:Number, param4:Array, param5:IChampionSelectionCommandFactory)
      {
         super();
         this.championSelectionModel = param1;
         this.championSelections = param2;
         this.accountId = param3;
         if(Boolean(param4))
         {
            this.playerRoster = param4;
         }
         this.commandFactory = param5;
      }
      
      private function anonymizeNames(param1:GameDTO) : void
      {
         if(param1.queueTypeName == QueueType.NONE || this.championSelectionModel.isSpectating)
         {
            return;
         }
         var _loc2_:ICommand = this.commandFactory.getAnonymizeNamesCommand(this.championSelectionModel.enemyTeam);
         _loc2_.execute();
      }
      
      private function updateSpectators(param1:GameDTO) : void
      {
         var _loc2_:ICommand = this.commandFactory.getUpdateSpectatorsCommand(this.championSelectionModel,this.playerRoster,this.accountId);
         _loc2_.execute();
      }
      
      private function onPlayerSelectionUpdateComplete(param1:Object) : void
      {
         if(this.championSelectionModel.currentPlayerSelection == null)
         {
            this.championSelectionModel.currentPlayerSelection = param1 as PlayerSelection;
         }
      }
      
      protected function updatePlayerSelections() : void
      {
         var _loc2_:ICommand = null;
         var _loc1_:ICommand = this.commandFactory.getResolveChampionReassignmentCommand(this.championSelections,this.championSelectionModel);
         _loc1_.execute();
         if(!this.championSelectionModel.currentTeamSelections)
         {
            this.championSelectionModel.currentTeamSelections = new ArrayCollection();
            this.championSelectionModel.enemyTeamSelections = new ArrayCollection();
         }
         if(this.championSelectionModel.currentTeamSelections.length != this.championSelectionModel.currentTeam.length)
         {
            _loc2_ = this.commandFactory.getUpdatePlayerSelectionsLengthForTeamCommand(this.championSelectionModel.currentTeam,this.championSelectionModel.currentTeamSelections);
            _loc2_.execute();
         }
         if(this.championSelectionModel.enemyTeamSelections.length != this.championSelectionModel.enemyTeam.length)
         {
            _loc2_ = this.commandFactory.getUpdatePlayerSelectionsLengthForTeamCommand(this.championSelectionModel.enemyTeam,this.championSelectionModel.enemyTeamSelections);
            _loc2_.execute();
         }
         var _loc3_:ICommand = this.commandFactory.getUpdatePlayerSelectionsForTeamCommand(this.championSelections,this.championSelectionModel.currentTeam,this.championSelectionModel.currentTeamSelections,this.championSelectionModel.currentGame.playerChampionSelections,this.championSelectionModel.championSelectionState,this.championSelectionModel.gameTypeConfig,this.championSelectionModel.isOccludingActivePickTurns,true);
         _loc3_.addResponder(this.onPlayerSelectionUpdateComplete);
         _loc3_.execute();
         _loc3_ = this.commandFactory.getUpdatePlayerSelectionsForTeamCommand(this.championSelections,this.championSelectionModel.enemyTeam,this.championSelectionModel.enemyTeamSelections,this.championSelectionModel.currentGame.playerChampionSelections,this.championSelectionModel.championSelectionState,this.championSelectionModel.gameTypeConfig,this.championSelectionModel.isOccludingActivePickTurns,this.championSelectionModel.isSpectating);
         _loc3_.execute();
      }
      
      private function setActiveTeams() : void
      {
         var _loc1_:ICommand = this.commandFactory.getSetActiveTeamsCommand(this.championSelectionModel);
         _loc1_.execute();
      }
      
      private function onPlayerRosterReady(param1:Object) : void
      {
         this.myTeam = param1 as int;
      }
      
      private function updateChampionSelections(param1:GameDTO, param2:int) : void
      {
         var _loc3_:Boolean = param2 == 1;
         var _loc4_:Boolean = param2 == 2;
         if(Boolean(this.championSelectionModel.gameTypeConfig) && this.championSelectionModel.gameTypeConfig.exclusivePick == true)
         {
            _loc3_ = _loc4_ = true;
         }
         var _loc5_:Object = new Object();
         if(_loc3_)
         {
            this.updateTeamMapForTeam(_loc5_,param1.teamOne);
         }
         if(_loc4_)
         {
            this.updateTeamMapForTeam(_loc5_,param1.teamTwo);
         }
         var _loc6_:Array = new Array();
         this.updatePlayerChampionSelectionsFromDTO(param1.playerChampionSelections,_loc6_,_loc5_);
         var _loc7_:ICommand = this.commandFactory.getUpdateParticipantChampionCommand(this.playerRoster,this.championSelections.list,_loc6_);
         _loc7_.execute();
      }
      
      private function updatePlayerChampionSelectionsFromDTO(param1:ArrayCollection, param2:Array, param3:Object) : void
      {
         var _loc4_:PlayerChampionSelectionDTO = null;
         var _loc5_:GameParticipant = null;
         for each(_loc4_ in this.championSelectionModel.currentGame.playerChampionSelections)
         {
            _loc5_ = param3[_loc4_.summonerInternalName];
            if(_loc5_ != null)
            {
               param2[_loc4_.championId] = _loc5_;
            }
         }
      }
      
      private function updateGame(param1:GameDTO) : void
      {
         if(!param1)
         {
            return;
         }
         this.updatePlayerRoster(param1);
         if(this.myTeam > 0)
         {
            this.championSelectionModel.currentPlayerParticipant = this.findPlayer(this.myTeam);
         }
         this.updateChampionSelections(this.championSelectionModel.currentGame,this.myTeam);
         this.updateSpectators(param1);
         this.setTeams(param1);
         this.updatePlayerSelections();
         this.updatePlayerSelectionTeams();
         this.updatePlayerSelectionBadges();
         this.anonymizeNames(param1);
         this.setActiveTeams();
         this.findAssignedItems(param1);
         this.updateMenuStates(param1);
      }
      
      private function updateMenuStates(param1:GameDTO) : void
      {
         var _loc2_:ICommand = this.commandFactory.getUpdateMenuStatesCommand(this.championSelectionModel);
         _loc2_.execute();
      }
      
      private function findAssignedItems(param1:GameDTO) : void
      {
         if(this.championSelectionModel.currentPlayerParticipant == null || this.championSelectionModel.isSpectating)
         {
            return;
         }
         var _loc2_:ICommand = this.commandFactory.getFindAssignedItemsCommand(this.championSelectionModel);
         _loc2_.execute();
      }
      
      private function findPlayerSelection() : PlayerSelection
      {
         var _loc1_:PlayerSelection = null;
         for each(_loc1_ in this.championSelectionModel.currentTeamSelections)
         {
            if(_loc1_.participant.isMe)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      protected function updatePlayerSelectionTeams() : void
      {
         var _loc1_:ArrayCollection = this.championSelectionModel.currentTeam;
         var _loc2_:ArrayCollection = this.championSelectionModel.enemyTeam;
         var _loc3_:ICommand = this.commandFactory.getUpdatePlayerSelectionTeamsCommand(_loc1_,this.championSelectionModel.currentTeamName,_loc2_,this.championSelectionModel.enemyTeamName);
         _loc3_.execute();
      }
      
      private function updatePlayerRoster(param1:GameDTO) : void
      {
         var _loc2_:Number = NaN;
         if(Boolean(param1.ownerSummary))
         {
            _loc2_ = Number(param1.ownerSummary.accountId);
         }
         else
         {
            _loc2_ = this.accountId;
         }
         var _loc3_:ICommand = this.commandFactory.getUpdatePlayerRosterCommand(param1,this.playerRoster,this.accountId,_loc2_);
         _loc3_.addResponder(this.onPlayerRosterReady);
         _loc3_.execute();
      }
      
      private function updateTeamMapForTeam(param1:Object, param2:ArrayCollection) : void
      {
         var _loc3_:ICommand = this.commandFactory.getTeamMapCommand(param1,param2);
         _loc3_.execute();
      }
      
      protected function updatePlayerSelectionBadges() : void
      {
         var _loc1_:ArrayCollection = this.championSelectionModel.currentTeamSelections;
         var _loc2_:ArrayCollection = this.championSelectionModel.enemyTeamSelections;
         var _loc3_:ICommand = this.commandFactory.getUpdatePlayerSelectionBadgesCommand(_loc1_,_loc2_);
         _loc3_.execute();
      }
      
      private function findPlayer(param1:int) : GameParticipant
      {
         var _loc2_:GameParticipant = null;
         if(param1 == 1)
         {
            for each(_loc2_ in this.championSelectionModel.currentGame.teamOne)
            {
               if(_loc2_.isMe)
               {
                  return _loc2_;
               }
            }
         }
         else
         {
            for each(_loc2_ in this.championSelectionModel.currentGame.teamTwo)
            {
               if(_loc2_.isMe)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      protected function setTeams(param1:GameDTO) : void
      {
         var _loc2_:ICommand = this.commandFactory.getSetTeamsCommand(this.championSelectionModel);
         _loc2_.execute();
      }
      
      override public function execute() : void
      {
         super.execute();
         this.updateGame(this.championSelectionModel.currentGame);
         onComplete();
         onResult();
      }
   }
}

