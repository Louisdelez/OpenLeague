package com.riotgames.platform.gameclient.controllers.game.mediators
{
   import blix.context.IContext;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.championselection.GameEvent;
   import com.riotgames.platform.gameclient.championselection.GameSelectionData;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertController;
   import com.riotgames.platform.gameclient.controllers.game.commands.ISpellSelectDialog;
   import com.riotgames.platform.gameclient.controllers.game.controllers.ChampionSelectionControllerNew;
   import com.riotgames.platform.gameclient.controllers.game.controllers.SelectRunePageCommand;
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.ItemSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.MasterySelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.RunePageSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.event.SpellSelectEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.controllers.game.toMove.components.TalentsSelection;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSelectionView;
   import com.riotgames.platform.gameclient.controllers.game.views.IChampionSelectionView;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.SpellSelectDialog;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.services.SpellBookService;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.metrics.ChampSelectTracker;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.core.Application;
   import mx.core.ClassFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   
   public class ChampionSelectionViewMediator extends EventDispatcher implements IChampionSelectionViewMediator
   {
      
      private var arrowedAlertController:ArrowedAlertController;
      
      private var championSelectionController:ChampionSelectionControllerNew;
      
      public var spellSelectDialog:ISpellSelectDialog;
      
      private var championView:IChampionSelectionView;
      
      private var context:IContext;
      
      private var parentDisplay:DisplayObjectContainer;
      
      private var spellSelectDialogFactory:ClassFactory = new ClassFactory(SpellSelectDialog);
      
      private var running:Boolean = false;
      
      private var spellBookService:SpellBookService;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      public var spellSelectionIndex:int;
      
      public var masteriesPopup:TalentsSelection;
      
      private var game:GameDTO;
      
      public function ChampionSelectionViewMediator(param1:ChampionSelectionControllerNew, param2:IChampionSelectionView, param3:ChampionSelectionModel, param4:IContext, param5:IEventDispatcher = null)
      {
         super(param5);
         this.championSelectionController = param1;
         this.championSelectionModel = param3;
         this.championView = param2;
         this.context = param4;
         this.addListeners();
      }
      
      private function addViewListeners() : void
      {
         this.championView.addEventListener(ChampionSelectionEvent.QUIT_GAME,this.onQuitGameRequested);
         this.championView.addEventListener(ItemSelectEvent.SELECT,this.onChampionClicked);
         this.championView.addEventListener(ChampionSelectionEvent.CHAMPION_LIST_SELECTED,this.onChampionListSelected);
         this.championView.addEventListener(ChampionSelectionEvent.SKINS_SELECTED,this.onSkinsSelected);
         this.championView.addEventListener(SpellSelectEvent.CHANGE_SPELL_1_REQUESTED,this.onSpell1Selected);
         this.championView.addEventListener(SpellSelectEvent.CHANGE_SPELL_2_REQUESTED,this.onSpell2Selected);
         this.championView.addEventListener(SpellSelectEvent.OPEN_SPELL_SELECT,this.onSpellSelected);
         this.championView.addEventListener(ChampionSelectionEvent.SKIN_SELECTED,this.onNewSkinSelected);
         this.championView.addEventListener(ChampionSelectionEvent.REROLL_REQUESTED,this.onRerollRequested);
         this.championView.addEventListener(ChampionSelectionEvent.LOCK_IN_CHOICES,this.onLockInChoicesClicked);
         this.championView.addEventListener(ChampionSelectionEvent.TRADE_REQUESTED,this.onTradeRequested);
         this.championView.addEventListener(ChampionSelectionEvent.TRADE_ACCEPTED,this.onTradeAccepted);
         this.championView.addEventListener(ChampionSelectionEvent.TRADE_REFUSED,this.onTradeRefused);
         this.championView.addEventListener(ChampionSelectionEvent.TRADE_CANCELED,this.onTradeCanceled);
         this.championView.addEventListener(RunePageSelectEvent.PAGE_SELECTED,this.onPageSelected);
         this.championView.addEventListener(MasterySelectionEvent.OPEN_MASTERIES,this.onOpenMasteriesRequested);
         this.championView.addEventListener(MasterySelectionEvent.PAGE_SELECTED,this.onMasteryPageSelected);
         this.championView.addEventListener(GameEvent.BROWSE_REQUESTED,this.dispatchGameEvent);
         this.championView.addEventListener(ChampionSelectionEvent.VIEW_PROFILE,this.onViewProfileRequested);
         this.championView.addEventListener(ChampionSelectionEvent.VIEW_PARTICIPANT_CHAMPION,this.onViewParticipantChampion);
      }
      
      public function destroy() : void
      {
         this.cleanupChampionSelection();
      }
      
      private function onSpell1Selected(param1:SpellSelectEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.showSpellSelectDialog(1);
      }
      
      private function onSpell2Selected(param1:SpellSelectEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.showSpellSelectDialog(2);
      }
      
      private function onQuitGameRequested(param1:ChampionSelectionEvent) : void
      {
         if(this.championSelectionController)
         {
            this.championSelectionController.quitGame();
         }
      }
      
      private function onViewProfileRequested(param1:ChampionSelectionEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.BROWSE_REQUESTED,null,param1.participantChampionSelection.participant.summonerName,true));
      }
      
      private function onAbortChampionSelection(param1:GameEvent) : void
      {
         this.cleanupChampionSelection();
         this.dispatchGameEvent(param1);
      }
      
      private function onTradeAccepted(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.acceptTrade();
      }
      
      public function closeSpellSelectDialog() : ISpellSelectDialog
      {
         if(this.spellSelectDialog != null)
         {
            PopUpManager.removePopUp(this.spellSelectDialog as IFlexDisplayObject);
            this.championSelectionController.closeTutorialSpellSelect();
            this.spellSelectDialog.removeEventListener(SpellSelectEvent.SPELLS_SELECTED,this.onSpellsSelected);
            this.spellSelectDialog.removeEventListener(Event.CLOSE,this.onSpellSelectClose);
            this.spellSelectDialog = null;
         }
         return this.spellSelectDialog;
      }
      
      private function onNewSkinSelected(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.useSkin(param1.participantChampionSelection.selectedSkin);
      }
      
      private function hideMasteries() : void
      {
         if(this.masteriesPopup)
         {
            PopUpManager.removePopUp(this.masteriesPopup);
         }
         this.masteriesPopup = null;
         if(this.championSelectionController != null)
         {
            this.championSelectionController.setMasteryPage(this.getSelectedPage());
         }
      }
      
      private function addListeners() : void
      {
         this.addViewListeners();
         this.addControllerListeners();
      }
      
      private function addControllerListeners() : void
      {
         this.championSelectionController.addEventListener(GameEvent.ABORT_CHAMPION_SELECTION,this.onAbortChampionSelection);
         this.championSelectionController.addEventListener(GameEvent.END_CHAMPION_SELECTION,this.onAbortChampionSelection);
         this.championSelectionController.addEventListener(GameEvent.COMPLETE_CHAMPION_SELECT,this.dispatchGameEvent);
         this.championSelectionController.getRerollUpdated().add(this.onRerollUpdated);
      }
      
      private function onLockInChoicesClicked(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.lockInChoices();
      }
      
      private function onChampionClicked(param1:ItemSelectEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.selectChampion(param1.data.champion);
      }
      
      private function cleanupChampionController() : void
      {
         if(!this.championSelectionController)
         {
            return;
         }
         this.championSelectionController.removeEventListener(GameEvent.ABORT_CHAMPION_SELECTION,this.onAbortChampionSelection);
         this.championSelectionController.removeEventListener(GameEvent.END_CHAMPION_SELECTION,this.onAbortChampionSelection);
         this.championSelectionController.removeEventListener(GameEvent.COMPLETE_CHAMPION_SELECT,this.dispatchGameEvent);
         this.championSelectionController.leaveChampionSelection();
         this.championSelectionController.getRerollUpdated().remove(this.onRerollUpdated);
         this.championSelectionController = null;
      }
      
      protected function onSpellSelectClose(param1:Event) : void
      {
         this.closeSpellSelectDialog();
      }
      
      private function onTradeRequested(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.requestTrade(param1.participantChampionSelection);
      }
      
      private function onSkinsSelected(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.switchToSkins();
      }
      
      public function showSpellSelectDialog(param1:int) : ISpellSelectDialog
      {
         if(this.spellSelectDialog != null)
         {
            return null;
         }
         this.spellSelectionIndex = param1;
         this.spellSelectDialog = this.spellSelectDialogFactory.newInstance() as ISpellSelectDialog;
         this.spellSelectDialog.spellProvider = this.championSelectionModel.allSpells;
         if(param1 == 0)
         {
            this.spellSelectDialog.chooseBoth = true;
            ChampSelectTracker.instance.spellsSelected(ChampSelectTracker.CHOOSE_SPELL_BOTH);
         }
         else
         {
            this.spellSelectDialog.spellIndex = param1;
            if(param1 == 1)
            {
               ChampSelectTracker.instance.spellsSelected(ChampSelectTracker.CHOOSE_SPELL_1);
            }
            else
            {
               ChampSelectTracker.instance.spellsSelected(ChampSelectTracker.CHOOSE_SPELL_2);
            }
         }
         this.spellSelectDialog.addEventListener(SpellSelectEvent.SPELLS_SELECTED,this.onSpellsSelected);
         this.spellSelectDialog.addEventListener(Event.CLOSE,this.onSpellSelectClose);
         PopUpManager.addPopUp(this.spellSelectDialog as IFlexDisplayObject,this.parentDisplay,true);
         var _loc2_:Number = Number(Application.application.scaleX);
         var _loc3_:Number = Number(Application.application.scaleY);
         this.spellSelectDialog.scaleX = _loc2_;
         this.spellSelectDialog.scaleY = _loc3_;
         this.spellSelectDialog.x = SpellSelectDialog.DIALOG_BASE_X * _loc2_;
         this.spellSelectDialog.y = SpellSelectDialog.DIALOG_BASE_Y * _loc3_;
         this.championSelectionController.openTutorialSpellSelect();
         return this.spellSelectDialog;
      }
      
      private function onTalentsFinished(param1:Event) : void
      {
         this.hideMasteries();
      }
      
      private function getSelectedPage() : MasteryPageInfoSummary
      {
         var _loc1_:MasteryPageInfoSummary = null;
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.masteryPages))
         {
            for each(_loc1_ in this.championSelectionModel.masteryPages)
            {
               if(_loc1_.isCurrent)
               {
                  return _loc1_;
               }
            }
         }
         return null;
      }
      
      private function setupView(param1:GameSelectionData) : void
      {
         this.championView.championSelectionModel = this.championSelectionModel;
         if(this.championView is ChampionSelectionView)
         {
            (this.championView as ChampionSelectionView).chatController = this.context.getDependency(ChatController);
         }
         if(this.championView.parent != param1.parentDisplay)
         {
            param1.parentDisplay.addChild(this.championView as UIComponent);
         }
         this.championView.glowComponentController = param1.glowController;
      }
      
      public function startChampionSelect(param1:GameSelectionData) : void
      {
         if(this.running)
         {
            return;
         }
         this.running = true;
         this.parentDisplay = param1.parentDisplay;
         this.game = param1.game;
         this.spellBookService = this.context.getDependency(ServiceProxy).spellBookService;
         this.arrowedAlertController = param1.arrowedAlertController;
         this.championSelectionController.startup();
         this.setupView(param1);
      }
      
      public function isSameGame(param1:GameDTO) : Boolean
      {
         if(Boolean(param1) && Boolean(this.game) && param1.id == this.game.id)
         {
            return true;
         }
         return false;
      }
      
      private function onTradeRefused(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.refuseTrade();
      }
      
      private function onRerollUpdated() : void
      {
         this.championView.updateRerollButton();
      }
      
      private function onPageSelected(param1:RunePageSelectEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         if(param1.runePage == null)
         {
            return;
         }
         var _loc2_:SelectRunePageCommand = new SelectRunePageCommand(this.championSelectionModel,this.championSelectionModel.runeBook,this.spellBookService,param1.runePage);
         _loc2_.execute();
      }
      
      private function onSpellSelected(param1:SpellSelectEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.showSpellSelectDialog(0);
      }
      
      protected function onSpellsSelected(param1:SpellSelectEvent) : void
      {
         if(param1.spell2 != null)
         {
            this.championSelectionController.confirmSpells(param1.spell1,param1.spell2);
         }
         else if(this.spellSelectionIndex == 1)
         {
            this.championSelectionController.confirmSpells(param1.spell1,null);
         }
         else
         {
            this.championSelectionController.confirmSpells(null,param1.spell1);
         }
      }
      
      private function onRerollRequested(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.useReroll();
      }
      
      private function showMasteries() : void
      {
         this.masteriesPopup = new TalentsSelection();
         this.masteriesPopup.addEventListener(TalentsSelection.TALENTS_FINISHED_EVENT,this.onTalentsFinished);
         PopUpManager.addPopUp(this.masteriesPopup,this.parentDisplay);
         PopUpManager.centerPopUp(this.masteriesPopup);
      }
      
      private function cleanupChampionSelection() : void
      {
         var _loc1_:PlayerSelection = null;
         if(Boolean(this.championSelectionModel) && Boolean(this.championSelectionModel.championSelections))
         {
            this.championSelectionModel.championSelections.source = null;
            this.championSelectionModel.championSelections = null;
         }
         if(this.championSelectionModel)
         {
            if(this.championSelectionModel)
            {
               for each(_loc1_ in this.championSelectionModel.currentTeamSelections)
               {
                  if(Boolean(_loc1_) && Boolean(_loc1_.championTrade))
                  {
                     _loc1_.championTrade.pendingTrade = false;
                     _loc1_.championTrade = null;
                  }
               }
            }
            this.championSelectionModel.currentGame = null;
            this.championSelectionModel.enemyTeam = null;
            this.championSelectionModel.enemyTeamSelections = null;
            this.championSelectionModel.currentTeam = null;
            this.championSelectionModel.currentTeamSelections = null;
         }
         this.hideMasteries();
         this.closeSpellSelectDialog();
         this.cleanupChampionView();
         this.cleanupChampionController();
         this.spellSelectDialog = null;
         this.parentDisplay = null;
         this.game = null;
         this.spellBookService = null;
         this.championSelectionModel = null;
      }
      
      private function onChampionListSelected(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.switchToChampions();
      }
      
      private function onOpenMasteriesRequested(param1:MasterySelectionEvent) : void
      {
         this.showMasteries();
      }
      
      private function onMasteryPageSelected(param1:MasterySelectionEvent) : void
      {
         this.championSelectionController.setMasteryPage(param1.masteryPageInfoSummary);
      }
      
      private function cleanupChampionView() : void
      {
         if(!this.championView)
         {
            return;
         }
         this.championView.cleanupView();
         this.championView.championSelectionModel = null;
         this.championView.glowComponentController = null;
         this.championView.removeEventListener(ChampionSelectionEvent.QUIT_GAME,this.onQuitGameRequested);
         this.championView.removeEventListener(ItemSelectEvent.SELECT,this.onChampionClicked);
         this.championView.removeEventListener(ChampionSelectionEvent.CHAMPION_LIST_SELECTED,this.onChampionListSelected);
         this.championView.removeEventListener(ChampionSelectionEvent.SKINS_SELECTED,this.onSkinsSelected);
         this.championView.removeEventListener(SpellSelectEvent.CHANGE_SPELL_1_REQUESTED,this.onSpell1Selected);
         this.championView.removeEventListener(SpellSelectEvent.CHANGE_SPELL_2_REQUESTED,this.onSpell2Selected);
         this.championView.removeEventListener(SpellSelectEvent.OPEN_SPELL_SELECT,this.onSpellSelected);
         this.championView.removeEventListener(ChampionSelectionEvent.SKIN_SELECTED,this.onNewSkinSelected);
         this.championView.removeEventListener(ChampionSelectionEvent.REROLL_REQUESTED,this.onRerollRequested);
         this.championView.removeEventListener(ChampionSelectionEvent.LOCK_IN_CHOICES,this.onLockInChoicesClicked);
         this.championView.removeEventListener(ChampionSelectionEvent.TRADE_REQUESTED,this.onTradeRequested);
         this.championView.removeEventListener(ChampionSelectionEvent.TRADE_ACCEPTED,this.onTradeAccepted);
         this.championView.removeEventListener(ChampionSelectionEvent.TRADE_REFUSED,this.onTradeRefused);
         this.championView.removeEventListener(ChampionSelectionEvent.TRADE_CANCELED,this.onTradeCanceled);
         this.championView.removeEventListener(RunePageSelectEvent.PAGE_SELECTED,this.onPageSelected);
         this.championView.removeEventListener(MasterySelectionEvent.OPEN_MASTERIES,this.onOpenMasteriesRequested);
         this.championView.removeEventListener(MasterySelectionEvent.PAGE_SELECTED,this.onMasteryPageSelected);
         this.championView.removeEventListener(GameEvent.BROWSE_REQUESTED,this.dispatchGameEvent);
         this.championView.removeEventListener(ChampionSelectionEvent.VIEW_PROFILE,this.onViewProfileRequested);
         this.championView.removeEventListener(ChampionSelectionEvent.VIEW_PARTICIPANT_CHAMPION,this.onViewParticipantChampion);
         if(Boolean(this.parentDisplay) && this.parentDisplay.contains(this.championView as UIComponent))
         {
            this.parentDisplay.removeChild(this.championView as UIComponent);
         }
         this.championView = null;
      }
      
      private function onViewParticipantChampion(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionController.showChampionDetailsPage(param1.participantChampionSelection.champion);
      }
      
      private function dispatchGameEvent(param1:GameEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onTradeCanceled(param1:ChampionSelectionEvent) : void
      {
         this.championSelectionModel.isAFK = false;
         this.championSelectionController.cancelTrade();
      }
   }
}

