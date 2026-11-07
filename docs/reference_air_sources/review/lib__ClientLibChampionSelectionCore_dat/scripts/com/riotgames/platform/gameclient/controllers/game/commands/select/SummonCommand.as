package com.riotgames.platform.gameclient.controllers.game.commands.select
{
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.controllers.game.commands.*;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ParticipantChampionListView;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.managers.ICursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class SummonCommand extends WaitCommand
   {
      
      private var participantChampionSelections:ParticipantChampionListView;
      
      private var pendingChamp:Champion = null;
      
      private var champion:Champion;
      
      private var gameService:GameService;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private const SUMMON_WAIT_STRING:String = "serverWait_summoningChampion";
      
      public function SummonCommand(param1:Champion, param2:ChampionSelectionModel, param3:ParticipantChampionListView, param4:GameService, param5:IResourceManager, param6:ICursorManager)
      {
         super(param5,param6);
         this.champion = param1;
         this.championSelectionModel = param2;
         this.participantChampionSelections = param3;
         this.gameService = param4;
      }
      
      override protected function logExecute() : void
      {
      }
      
      override protected function logResult(param1:Object) : void
      {
      }
      
      private function isSuccessfulSummon(param1:Champion) : Boolean
      {
         if(Boolean(this.pendingChamp) && Boolean(param1) && this.pendingChamp.skinName == param1.skinName)
         {
            return true;
         }
         return false;
      }
      
      private function summonChampion() : void
      {
         var _loc3_:IResourceManager = null;
         var _loc4_:AlertAction = null;
         if(this.champion != null && Boolean(this.champion.isRandomChampion()) || this.champion == null)
         {
            this.champion = this.participantChampionSelections.findRandomUnselectedChampion();
         }
         var _loc1_:ParticipantChampionSelection = this.participantChampionSelections.getSelectionByChampion(this.champion);
         var _loc2_:GameParticipant = _loc1_.participant;
         if(_loc2_ != null)
         {
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = new AlertAction(_loc3_.getString("resources","championSelection_selectChampionErrorTitle"),_loc3_.getString("resources",MessageDictionary.CANNOT_SUMMON_CHAMPION_ALREADY_SUMMONED));
            _loc4_.add();
            this.isBusy = false;
         }
         else
         {
            this.pendingChamp = this.champion;
            this.gameService.selectChampion(this.champion,onResult,onComplete,this.onError);
         }
      }
      
      override protected function onError(param1:Object = null) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","championSelection_selectChampionErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
         this.pendingChamp = null;
         super.onError(param1);
      }
      
      override public function execute() : void
      {
         this.summonChampion();
         super.execute();
      }
      
      private function getSummonedChampion(param1:GameDTO) : Champion
      {
         var _loc3_:PlayerChampionSelectionDTO = null;
         var _loc2_:Champion = null;
         for each(_loc3_ in param1.playerChampionSelections)
         {
            if(_loc3_.summonerInternalName == this.championSelectionModel.currentPlayerParticipant.summonerInternalName)
            {
               _loc2_ = this.participantChampionSelections.getSelectionByChampionId(_loc3_.championId).champion;
            }
         }
         return _loc2_;
      }
   }
}

