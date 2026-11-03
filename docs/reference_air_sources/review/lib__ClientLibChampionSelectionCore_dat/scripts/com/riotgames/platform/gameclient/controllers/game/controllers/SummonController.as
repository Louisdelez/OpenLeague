package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import blix.action.IAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.championselection.enum.ChampionSelectState;
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionWildCardEnums;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class SummonController extends EventDispatcher
   {
      
      private var participantChampionSelections:ParticipantChampionListView;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var lockInAfterChampionSummon:Boolean = false;
      
      private var lastSound:IAction;
      
      private var soundManager:ISoundProvider;
      
      private var gameService:GameService;
      
      private var pendingChamp:Champion = null;
      
      public function SummonController(param1:ChampionSelectionModel, param2:ParticipantChampionListView, param3:GameService, param4:ISoundProvider)
      {
         super();
         this.participantChampionSelections = param2;
         this.championSelectionModel = param1;
         this.soundManager = param4;
         this.gameService = param3;
      }
      
      public function summonOrUnsummonChampion(param1:Champion) : void
      {
         this.championSelectionModel.championSelectionIsBusy = true;
         this.summonChampion(param1);
      }
      
      private function onSummonChampionSuccess(param1:ResultEvent) : void
      {
      }
      
      private function updateChampionState() : void
      {
         var _loc1_:Champion = this.getSummonedChampion();
         var _loc2_:Boolean = false;
         if(Boolean(this.pendingChamp) && Boolean(_loc1_) && this.pendingChamp.skinName == _loc1_.skinName)
         {
            _loc2_ = true;
         }
         else
         {
            _loc2_ = false;
         }
         if(_loc1_ != null)
         {
            this.championSelectionModel.selectedChampion = this.participantChampionSelections.getSelectionByChampion(_loc1_);
         }
         if(_loc2_)
         {
            if(this.championSelectionModel.currentGame.gameType != GameType.TUTORIAL_GAME)
            {
               if(this.lastSound != null)
               {
                  if(!this.lastSound.getIsFinished())
                  {
                     this.lastSound.abort();
                  }
                  this.lastSound = null;
               }
               this.lastSound = this.soundManager.playSummonChampionBySkinname(_loc1_.skinName);
            }
            if(this.lockInAfterChampionSummon)
            {
               this.lockInChoices();
            }
         }
         this.lockInAfterChampionSummon = false;
         if(!_loc2_)
         {
            this.championSelectionModel.championSelectionIsBusy = false;
            this.logger.warn("0004 ChampionSelectionController.onSummonChampionSuccess: Player Was Unable To Summon His Selected Champion.");
         }
         this.pendingChamp = null;
      }
      
      public function lockInChoices() : void
      {
         var _loc1_:IResourceManager = null;
         var _loc2_:AlertAction = null;
         if(this.championSelectionModel.selectedChampion == null)
         {
            _loc1_ = ResourceManager.getInstance();
            _loc2_ = new AlertAction(ResourceManager.getInstance().getString("resources","championSelection_lockin_title"),_loc1_.getString("resources","championSelection_lockin_warning"));
            _loc2_.showNegative = true;
            _loc2_.setYesNoLabels();
            _loc2_.getCompleted().add(this.onLockinConfirmHandler);
            _loc2_.add();
         }
         else
         {
            this.championSelectionModel.championSelectionIsBusy = true;
            this.gameService.championSelectCompleted(this.onChampSelectCompleted,this.onServiceRequestComplete);
         }
      }
      
      private function onChampionSelectError(param1:ServerError) : void
      {
         if(param1.errorCode == "PG-0014")
         {
            this.pendingChamp = null;
            return;
         }
         this.championSelectionModel.currentPlayerSelection.addEventListener(PlayerSelection.CHAMPION_CHANGED,this.onChampionChanged,false,0,true);
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:String = _loc2_.getString("resources",param1.errorCode,param1.messageArguments);
         var _loc4_:AlertAction = new AlertAction(_loc2_.getString("resources","championSelection_selectChampionErrorTitle"),_loc3_);
         _loc4_.add();
         this.logger.warn("0006 SummonController.onChampionSelectError: " + _loc3_);
         this.pendingChamp = null;
      }
      
      private function summonChampion(param1:Champion) : Boolean
      {
         var _loc2_:Boolean = true;
         if(!Log.isDebug())
         {
         }
         if(param1 != null && Boolean(param1.isRandomChampion()) || param1 == null)
         {
            param1 = this.participantChampionSelections.findRandomUnselectedChampion();
            if(param1 == null)
            {
               this.championSelectionModel.championSelectionIsBusy = false;
               return false;
            }
         }
         var _loc3_:ParticipantChampionSelection = this.participantChampionSelections.getSelectionByChampion(param1);
         var _loc4_:Boolean = _loc3_.participant == null || Boolean(ChampionSelectState.tutorialPickOverride) || this.championSelectionModel.gameTypeConfig != null && Boolean(this.championSelectionModel.gameTypeConfig.duplicatePick);
         if(_loc4_)
         {
            this.pendingChamp = param1;
            this.championSelectionModel.currentPlayerSelection.addEventListener(PlayerSelection.CHAMPION_CHANGED,this.onChampionChanged,false,0,true);
            this.gameService.selectChampion(param1,this.onSummonChampionSuccess,this.onServiceRequestComplete,this.onChampionSelectError);
         }
         else
         {
            _loc2_ = false;
            this.championSelectionModel.championSelectionIsBusy = false;
            this.logger.error("0003 player attempting to summon a champion that already has a participant.");
         }
         return _loc2_;
      }
      
      private function onChampSelectCompleted(param1:ResultEvent) : void
      {
         if(param1.result is GameDTO)
         {
            this.championSelectionModel.currentGame = param1.result as GameDTO;
         }
         dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.CHAMP_SELECT_COMPLETE));
      }
      
      private function onLockinConfirmHandler(param1:AlertAction) : void
      {
         var _loc2_:Champion = null;
         if(param1.affirmativeResponse)
         {
            this.lockInAfterChampionSummon = true;
            _loc2_ = new Champion();
            _loc2_.active = true;
            if(this.championSelectionModel.gameTypeConfig != null && Boolean(this.championSelectionModel.gameTypeConfig.votePickGameTypeConfig))
            {
               _loc2_.setAsWildCardChampion(ChampionWildCardEnums.ID_ABSTAIN_CHAMPION);
            }
            else
            {
               _loc2_.setAsRandomChampion();
            }
            this.summonOrUnsummonChampion(_loc2_);
         }
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.championSelectionModel.championSelectionIsBusy = false;
      }
      
      private function onChampionChanged(param1:Event) : void
      {
         this.championSelectionModel.currentPlayerSelection.addEventListener(PlayerSelection.CHAMPION_CHANGED,this.onChampionChanged,false,0,true);
         this.updateChampionState();
      }
      
      private function getSummonedChampion() : Champion
      {
         var _loc2_:ParticipantChampionSelection = null;
         var _loc1_:Champion = null;
         for each(_loc2_ in this.championSelectionModel.championSelections)
         {
            if(_loc2_.participant != null && _loc2_.participant is PlayerParticipant && Boolean(PlayerParticipant(_loc2_.participant).isMe))
            {
               _loc1_ = _loc2_.champion;
               break;
            }
         }
         return _loc1_;
      }
   }
}

