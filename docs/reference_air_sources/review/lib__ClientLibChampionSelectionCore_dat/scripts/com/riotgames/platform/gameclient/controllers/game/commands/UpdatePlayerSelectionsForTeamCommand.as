package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.championselection.enum.ChampionSelectState;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.controllers.game.views.voting.oneteam.VotePlayerSelectionUtils;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   
   public class UpdatePlayerSelectionsForTeamCommand extends CommandBase
   {
      
      private var currentPlayerSelections:ArrayCollection;
      
      private var participantChampionSelections:ParticipantChampionListView;
      
      private var team:ArrayCollection;
      
      private var oneTeamSelectionVotes:ArrayCollection;
      
      private var isOccludingActivePickTurns:Boolean;
      
      private var inventory:IInventory;
      
      private var gameTypeConfig:GameTypeConfig;
      
      private var shouldShowSpells:Boolean;
      
      private var selectionsDTOCollection:ArrayCollection;
      
      private var gameState:String;
      
      public function UpdatePlayerSelectionsForTeamCommand(param1:ParticipantChampionListView, param2:ArrayCollection, param3:ArrayCollection, param4:ArrayCollection, param5:IInventory, param6:String, param7:GameTypeConfig, param8:Boolean, param9:Boolean)
      {
         super();
         this.participantChampionSelections = param1;
         this.team = param2;
         this.currentPlayerSelections = param3;
         this.selectionsDTOCollection = param4;
         this.gameTypeConfig = param7;
         this.shouldShowSpells = param9;
         this.inventory = param5;
         this.gameState = param6;
         this.isOccludingActivePickTurns = param8;
      }
      
      protected function updatePlayerSelectionsForTeam(param1:ArrayCollection, param2:ArrayCollection, param3:ArrayCollection, param4:GameTypeConfig, param5:Boolean) : PlayerSelection
      {
         var _loc6_:GameParticipant = null;
         var _loc7_:PlayerParticipant = null;
         var _loc8_:PlayerSelection = null;
         var _loc9_:PlayerParticipant = null;
         var _loc10_:PlayerChampionSelectionDTO = null;
         var _loc11_:PlayerSelection = null;
         var _loc13_:Boolean = false;
         var _loc14_:Dictionary = null;
         var _loc15_:Object = null;
         var _loc16_:int = 0;
         this.oneTeamSelectionVotes = new ArrayCollection();
         var _loc12_:int = 0;
         while(_loc12_ < param1.length)
         {
            _loc6_ = param1.getItemAt(_loc12_) as GameParticipant;
            _loc13_ = false;
            for each(_loc8_ in param2)
            {
               _loc7_ = _loc6_ as PlayerParticipant;
               _loc9_ = _loc8_.participant as PlayerParticipant;
               if(Boolean(_loc7_) && Boolean(_loc9_) && _loc7_.accountId == _loc9_.accountId)
               {
                  this.updatePlayerSelection(_loc6_,_loc8_,param3,param4,param5);
                  if(_loc6_.isMe)
                  {
                     _loc11_ = _loc8_;
                  }
                  _loc13_ = true;
                  break;
               }
               if(Boolean(_loc6_ is BotParticipant) && Boolean(_loc9_) && _loc6_.summonerInternalName == _loc8_.participant.summonerInternalName)
               {
                  this.updatePlayerSelection(_loc6_,_loc8_,param3,param4,param5);
                  _loc13_ = true;
                  break;
               }
            }
            if(!_loc13_)
            {
               _loc8_ = param2.getItemAt(_loc12_) as PlayerSelection;
               _loc8_.participant = _loc6_;
               this.updatePlayerSelection(_loc6_,_loc8_,param3,param4,param5);
               if(_loc6_.isMe)
               {
                  _loc11_ = _loc8_;
               }
               _loc13_ = true;
            }
            _loc8_.gameState = this.gameState;
            _loc12_++;
         }
         if(this.oneTeamSelectionVotes != null && this.oneTeamSelectionVotes.length > 0)
         {
            _loc14_ = VotePlayerSelectionUtils.getVoteChancesForPlayerSelections(this.oneTeamSelectionVotes);
            for(_loc15_ in _loc14_)
            {
               _loc16_ = int(_loc14_[_loc15_]);
               PlayerSelection(_loc15_).selectionStateText = _loc16_ == 100 ? RiotResourceLoader.getString("champSelect_voting_majority") : RiotResourceLoader.getString("champSelect_voting_percent",null,[_loc16_]);
            }
         }
         return _loc11_;
      }
      
      private function updatePlayerSelectionState(param1:PlayerSelection, param2:GameParticipant) : void
      {
         param1.selectionState = this.getPlayerSelectionState(param2,param1.selectionState);
         param1.participant = param2;
         if(param2.hasOwnProperty("clientInSynch"))
         {
            param1.isInSync = param2["clientInSynch"];
         }
         else
         {
            param1.isInSync = true;
         }
      }
      
      private function updatePlayerSelectionFromDTO(param1:PlayerSelection, param2:PlayerChampionSelectionDTO, param3:GameParticipant, param4:GameTypeConfig, param5:Boolean) : void
      {
         this.updateSelectedChampion(param1,param2,param4);
         var _loc6_:PlayerParticipant = param3 as PlayerParticipant;
         if(Boolean(_loc6_))
         {
            param1.selectionStateText = this.getSelectionText(_loc6_,param4);
            if(this.gameState == GameState.CHAMPION_SELECTION && param4 != null && param4.id == GameTypeConfig.PICK_ID_ONE_TEAM_VOTE_DRAFT)
            {
               this.oneTeamSelectionVotes.addItem(param1);
            }
         }
         else
         {
            param1.selectionStateText = "";
         }
         if(Boolean(_loc6_ && !_loc6_.isMe && param5) && Boolean(this.gameState != GameState.PRE_CHAMPION_SELECTION) && param1.champion != null)
         {
            param1.spell1 = this.inventory.spellDictionary[param2.spell1Id];
            param1.spell2 = this.inventory.spellDictionary[param2.spell2Id];
         }
      }
      
      private function updateSelectedChampion(param1:PlayerSelection, param2:PlayerChampionSelectionDTO, param3:GameTypeConfig) : void
      {
         var _loc4_:Champion = null;
         var _loc5_:ParticipantChampionSelection = this.participantChampionSelections.getSelectionByChampionId(param2.championId);
         if(_loc5_ != null && _loc5_.champion != null)
         {
            _loc4_ = _loc5_.champion;
         }
         else
         {
            _loc4_ = this.inventory.championIdMapping[param2.championId];
         }
         this.updateDefaultChampionVisual(param1,_loc4_,param3);
         param1.champion = _loc4_;
      }
      
      private function updateDefaultChampionVisual(param1:PlayerSelection, param2:Champion, param3:GameTypeConfig) : void
      {
         if(param3 != null && param3.id == GameTypeConfig.PICK_ID_ALL_TEAM_VOTE_PICK)
         {
            param1.defaultChampionVisualName = param2 == null ? PlayerSelection.OBSCURED_VISUAL_NAME : null;
         }
         else
         {
            param1.defaultChampionVisualName = null;
         }
      }
      
      private function updatePlayerSelection(param1:GameParticipant, param2:PlayerSelection, param3:ArrayCollection, param4:GameTypeConfig, param5:Boolean) : void
      {
         var _loc6_:PlayerChampionSelectionDTO = null;
         this.updatePlayerSelectionState(param2,param1);
         for each(_loc6_ in param3)
         {
            if(_loc6_.summonerInternalName == param1.summonerInternalName)
            {
               this.updatePlayerSelectionFromDTO(param2,_loc6_,param1,param4,param5);
               break;
            }
         }
      }
      
      private function getSelectionText(param1:PlayerParticipant, param2:GameTypeConfig) : String
      {
         var _loc3_:String = "";
         if(param1.pickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            if(this.gameState == GameState.PRE_CHAMPION_SELECTION)
            {
               _loc3_ = RiotResourceLoader.getString("champSelect_banning");
               if(_loc3_ == null)
               {
                  _loc3_ = "Banning";
               }
            }
            else if(!this.isOccludingActivePickTurns)
            {
               _loc3_ = param2 != null && Boolean(param2.votePickGameTypeConfig) ? RiotResourceLoader.getString("champSelect_voting") : RiotResourceLoader.getString("champSelect_picking");
               if(_loc3_ == null)
               {
                  _loc3_ = "Picking";
               }
            }
         }
         return _loc3_;
      }
      
      private function getPlayerSelectionState(param1:GameParticipant, param2:String) : String
      {
         var _loc3_:String = "";
         var _loc4_:PlayerParticipant = param1 as PlayerParticipant;
         var _loc5_:Boolean = false;
         if(Boolean(_loc4_))
         {
            _loc5_ = Boolean(_loc4_.isMe);
         }
         if(param1.pickMode == GameParticipant.PICK_MODE_ACTIVE && !this.isOccludingActivePickTurns)
         {
            _loc3_ = _loc5_ ? ChampionSelectState.CHAMPION_SELECT_STATE_ACTIVESELF : ChampionSelectState.CHAMPION_SELECT_STATE_ACTIVEOTHER;
         }
         else
         {
            _loc3_ = _loc5_ ? ChampionSelectState.CHAMPION_SELECT_STATE_INACTIVESELF : ChampionSelectState.CHAMPION_SELECT_STATE_INACTIVEOTHER;
         }
         if(param2 != _loc3_)
         {
            return _loc3_;
         }
         return param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         var _loc1_:PlayerSelection = this.updatePlayerSelectionsForTeam(this.team,this.currentPlayerSelections,this.selectionsDTOCollection,this.gameTypeConfig,this.shouldShowSpells);
         onComplete(null);
         onResult(_loc1_);
      }
   }
}

