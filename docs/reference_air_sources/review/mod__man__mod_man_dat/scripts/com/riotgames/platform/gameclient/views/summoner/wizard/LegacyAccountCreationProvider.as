package com.riotgames.platform.gameclient.views.summoner.wizard
{
   import blix.signals.ISignal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.controllers.summoner.ChooseSummonerIconController;
   import com.riotgames.platform.gameclient.controllers.summoner.EloQuestionaireController;
   import com.riotgames.platform.gameclient.controllers.summoner.PlayTutorialGameController;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerNameController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.accountcreation.IAccountCreationProvider;
   import com.riotgames.pvpnet.accountcreation.model.ChooseIconModel;
   import com.riotgames.pvpnet.accountcreation.model.EloQuestionnaireModel;
   import com.riotgames.pvpnet.accountcreation.model.PlayTutorialModel;
   import com.riotgames.pvpnet.accountcreation.model.SummonerNameModel;
   import com.riotgames.pvpnet.game.controllers.tutorial.CreateTutorialGameController;
   import com.riotgames.pvpnet.metrics.UserFlow;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import flash.display.BitmapData;
   import mx.collections.ArrayCollection;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LegacyAccountCreationProvider implements IAccountCreationProvider
   {
      
      public var playTutorialGameController:PlayTutorialGameController;
      
      public var createTutorialGameController:CreateTutorialGameController;
      
      private var _eloQuestionnaireModel:EloQuestionnaireModel = new EloQuestionnaireModel();
      
      public var eloQuestionnaireController:EloQuestionaireController;
      
      private var _chooseIconModel:ChooseIconModel = new ChooseIconModel();
      
      private var _playTutorialModel:PlayTutorialModel = new PlayTutorialModel();
      
      public var chooseSummonerIconController:ChooseSummonerIconController;
      
      private var _summonerNameModel:SummonerNameModel = new SummonerNameModel();
      
      public var summonerNameController:SummonerNameController;
      
      public function LegacyAccountCreationProvider()
      {
         super();
         this._eloQuestionnaireModel.getSkillLevelValueConfirmed().add(this.onEloSkillLevelValueConfirmed);
         this._eloQuestionnaireModel.getPendingSkillLevelValueChanged().add(this.onEloPendingSkillLevelValueChanged);
         this._chooseIconModel.getUserIconListRequested().add(this.onChooseIconUserListRequested);
         this._chooseIconModel.getPendingIconChanged().add(this.onPendingIconChanged);
         this._chooseIconModel.getChosenIconChanged().add(this.onChosenIconChanged);
         this._chooseIconModel.getChosenIconCancelled().add(this.onChosenIconCancelled);
         this._summonerNameModel.getNewSummonerNameChanged().add(this.onNewSummonerNameChanged);
         this._playTutorialModel.getTutorialTypeRequested().add(this.onPlayTutorialTypeRequested);
         this._playTutorialModel.getPlayTutorialAnswered().add(this.onPlayTutorialAnswered);
         ProviderLookup.publishProvider(IAccountCreationProvider,this);
      }
      
      private function handleUserIconListBuilt(param1:ArrayCollection) : void
      {
         this._chooseIconModel.userIconList = param1;
      }
      
      private function onEloPendingSkillLevelValueChanged(param1:String) : void
      {
      }
      
      public function requestLoadIcons() : void
      {
         this.onChooseIconUserListRequested();
      }
      
      private function acceptTutorial() : void
      {
         if(this.createTutorialGameController.isBasicTutorial == false)
         {
            this.playTutorialGameController.saveSummonerTutorialFlag();
            this.playTutorialGameController.showLobby();
         }
         this.playTutorialGameController.playTutorialGame();
      }
      
      private function onNewSummonerNameChanged(param1:ISignal, param2:String) : void
      {
         if(this._summonerNameModel.createSummonerMode)
         {
            ++this._summonerNameModel.numberOfTries;
            this.summonerNameController.createDefaultSummoner(param2,this.onNameProcessingComplete,this.onCreateDefaultSummonerError);
         }
         else
         {
            ++this._summonerNameModel.numberOfTries;
            this.summonerNameController.renameSummonerOnLogin(param2,this.onNameProcessingComplete,this.onRenameSummonerError);
         }
      }
      
      private function onChosenIconChanged(param1:int, param2:BitmapData) : void
      {
         var _loc3_:int = -1;
         if(Boolean(Session.instance) && Boolean(Session.instance.summoner))
         {
            _loc3_ = int(Session.instance.summoner.profileIconId);
         }
         UserFlow.track("client_chrome","summoner_icon_chosen",{
            "icon_changed_from":_loc3_,
            "icon_changed_to":param1
         },UserFlow.INPUT);
         if(param1 != -1)
         {
            AppConfig.instance.summonerIconSource = param2;
         }
         this.chooseSummonerIconController.saveSummonerIconId(param1,this._chooseIconModel.continueTutorialSequence);
      }
      
      private function showError(param1:String, param2:Array) : void
      {
         this._summonerNameModel.errorAlertShown = true;
         var _loc3_:IResourceManager = ResourceManager.getInstance();
         var _loc4_:AlertAction = new AlertAction(_loc3_.getString("resources","general_generalAlertErrorTitle"),_loc3_.getString("resources",param1,param2));
         _loc4_.getCompleted().addOnce(this.onErrorClose);
         _loc4_.add();
      }
      
      public function handleStoreIconFulfillment(param1:int, param2:Boolean) : void
      {
         if(this._chooseIconModel.userIconList == null)
         {
            return;
         }
         if(param2)
         {
            this.chooseSummonerIconController.removeIconFromList(param1,this._chooseIconModel.userIconList);
         }
         else
         {
            this.chooseSummonerIconController.addIconToList(param1,this._chooseIconModel.userIconList);
         }
         this._chooseIconModel.userIconList = this._chooseIconModel.userIconList;
      }
      
      private function onCreateDefaultSummonerError(param1:ServerError = null) : void
      {
         var _loc2_:String = param1 == null ? "summoner_wizard_createDefaultSummonerFailedErrorMessage" : param1.errorCode;
         var _loc3_:Array = param1 == null ? [] : param1.messageArguments;
         this.showError(_loc2_,_loc3_);
      }
      
      public function getEloQuestionnaireModel() : EloQuestionnaireModel
      {
         return this._eloQuestionnaireModel;
      }
      
      private function onPendingIconChanged(param1:int) : void
      {
      }
      
      private function onRenameSummonerError(param1:ServerError = null) : void
      {
         var _loc2_:String = param1 == null ? "summoner_wizard_renameSummonerFailedErrorMessage" : param1.errorCode;
         var _loc3_:Array = param1 == null ? [] : param1.messageArguments;
         this.showError(_loc2_,_loc3_);
      }
      
      public function getChooseIconModel() : ChooseIconModel
      {
         return this._chooseIconModel;
      }
      
      private function onNameProcessingComplete() : void
      {
         this._summonerNameModel.setSummonerRenamed();
      }
      
      public function getPlayTutorialModel() : PlayTutorialModel
      {
         return this._playTutorialModel;
      }
      
      private function declineTutorial() : void
      {
         if(this.createTutorialGameController.isBasicTutorial == true && Boolean(this.createTutorialGameController.isAdvancedTutorialEnabled()))
         {
            this.createTutorialGameController.isBasicTutorial = false;
            this._playTutorialModel.basicTutorialType = false;
            this.playTutorialGameController.viewMediator.showPlayTutorialGame();
         }
         else
         {
            this.playTutorialGameController.saveSummonerTutorialFlag();
            this.playTutorialGameController.showLobby();
         }
      }
      
      private function onChooseIconUserListRequested() : void
      {
         this.chooseSummonerIconController.buildUserIconList(this.handleUserIconListBuilt);
      }
      
      private function onPlayTutorialTypeRequested() : void
      {
         if(this.createTutorialGameController.isBasicTutorial)
         {
            this._playTutorialModel.basicTutorialType = true;
         }
         else
         {
            this._playTutorialModel.basicTutorialType = false;
         }
      }
      
      private function onEloSkillLevelValueConfirmed(param1:String) : void
      {
         this.eloQuestionnaireController.confirmQuestionaire(param1);
         this.eloQuestionnaireController.continueCreateSummonerFlow(param1);
      }
      
      public function getSummonerNameModel() : SummonerNameModel
      {
         return this._summonerNameModel;
      }
      
      private function onErrorClose() : void
      {
         this._summonerNameModel.errorAlertShown = false;
         if(!this._summonerNameModel.createSummonerMode)
         {
         }
      }
      
      private function onPlayTutorialAnswered(param1:Boolean) : void
      {
         if(param1)
         {
            this.acceptTutorial();
         }
         else
         {
            this.declineTutorial();
         }
      }
      
      private function onChosenIconCancelled() : void
      {
      }
   }
}

