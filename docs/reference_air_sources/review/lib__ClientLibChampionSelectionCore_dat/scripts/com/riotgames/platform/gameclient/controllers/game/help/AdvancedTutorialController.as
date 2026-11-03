package com.riotgames.platform.gameclient.controllers.game.help
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertStyle;
   import com.riotgames.platform.gameclient.controllers.game.EventQueue;
   import com.riotgames.platform.gameclient.controllers.game.GlowLocation;
   import com.riotgames.platform.gameclient.controllers.game.builders.IChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.enums.MenuStates;
   import com.riotgames.platform.gameclient.controllers.game.enums.TutorialDialogConstants;
   import com.riotgames.platform.gameclient.controllers.game.mediators.HelpMediator;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class AdvancedTutorialController extends EventDispatcher
   {
      
      private var tutorialStates:HelpMediator;
      
      private var alerter:IAlerterProvider;
      
      private var displayChampionIDs:Array;
      
      private var championIntroNumber:int = 0;
      
      [ArrayElementType("flash.geom.Point")]
      private var championTooltipPositions:Array = [new Point(148,220),new Point(217,220),new Point(280,220)];
      
      private var commandFactory:IChampionSelectionCommandFactory;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var waitingForSpellSelect:Boolean = false;
      
      private var timeLeftWarningShown:Boolean = false;
      
      [ArrayElementType("String")]
      private var tutorialChampions:Array;
      
      private var spellSelectAlreadyOpened:Boolean = false;
      
      public function AdvancedTutorialController(param1:IAlerterProvider, param2:ChampionSelectionModel, param3:HelpMediator, param4:IChampionSelectionCommandFactory, param5:Array = null, param6:Array = null)
      {
         super();
         this.alerter = param1;
         this.championSelectionModel = param2;
         this.tutorialStates = param3;
         this.tutorialChampions = param5;
         this.commandFactory = param4;
         if(this.tutorialChampions == null)
         {
            this.tutorialChampions = ["Garen","Ryze","Ashe"];
         }
         if(param6 != null)
         {
            this.championTooltipPositions = param6;
         }
         if(this.championTooltipPositions.length != this.tutorialChampions.length)
         {
            throw new Error("There must be a tooltip position entry for each tutorial champion entry");
         }
      }
      
      private function onMakeChoicesExit() : void
      {
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onPickModeChanged);
      }
      
      private function onSummonerSpellsInfoExit() : void
      {
      }
      
      private function onChampionRosterEnter() : void
      {
         if(this.championSelectionModel.selectedChampion == null)
         {
            this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_CHAMPIONS);
            this.tutorialStates.showTipDialog(TutorialDialogConstants.SELECT_CHAMPION,213,220,ArrowedAlertStyle.POINT_UP);
            this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_SELECT_CHAMPION);
            this.championSelectionModel.addEventListener(ChampionSelectionModel.SELECTED_CHAMPION_CHANGED,this.onSelectedChampionChanged,false,0,true);
         }
         else
         {
            this.tutorialStates.advanceState();
         }
      }
      
      private function updateTutorialState() : void
      {
         this.championSelectionModel.enemyTeamVisible = true;
         this.championSelectionModel.progressBarVisible = false;
         this.updateMenuStates();
         this.championSelectionModel.friendlyTeammatesVisible = this.championSelectionModel.friendlyTeamActive;
      }
      
      private function onGameStartingEnter() : void
      {
         this.tutorialStates.showTipDialog(TutorialDialogConstants.GAME_STARTING,500,250,ArrowedAlertStyle.NO_ARROW);
      }
      
      private function onGreetingEnter() : void
      {
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_WELCOME);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.GREETING,500,250,ArrowedAlertStyle.NO_ARROW);
      }
      
      private function checkForOutOfTime() : void
      {
         if(this.championSelectionModel.timeRemainingSeconds == 0 && this.championSelectionModel.championSelectionState == GameState.CHAMPION_SELECTION)
         {
            dispatchEvent(new Event("logout"));
         }
      }
      
      private function onSelectSpellsEnter() : void
      {
         this.tutorialStates.showTipDialog(TutorialDialogConstants.SPELL_SELECT,-335,10,ArrowedAlertStyle.NO_ARROW,true);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_SELECT_SPELLS);
      }
      
      private function onMakeChoicesEnter() : void
      {
         this.championSelectionModel.lockInActive = true;
         this.tutorialStates.turnOnComponentGlow(GlowLocation.LOCK_IN_BUTTON);
         this.tutorialStates.showTipDialog(TutorialDialogConstants.MAKE_CHOICES,500,10,ArrowedAlertStyle.NO_ARROW);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_MAKE_CHOICES);
         if(this.championSelectionModel.currentPickMode == GameParticipant.PICK_MODE_DONE)
         {
            this.tutorialStates.advanceState();
         }
         else
         {
            this.championSelectionModel.addEventListener(ChampionSelectionModel.CURRENT_PICK_MODE_CHANGED,this.onPickModeChanged,false,0,true);
         }
      }
      
      private function onRunePageEnter() : void
      {
         this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_RUNES);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.RUNE_PAGES,220,260,ArrowedAlertStyle.POINT_DOWN);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_RUNE_PAGES);
      }
      
      private function onPickModeChanged(param1:Event) : void
      {
         if(this.championSelectionModel.currentPickMode == GameParticipant.PICK_MODE_DONE)
         {
            this.tutorialStates.advanceState();
         }
      }
      
      private function onSelectedChampionChanged(param1:Event) : void
      {
         if(this.championSelectionModel.selectedChampion != null)
         {
            if(this.championSelectionModel.championSelectionIsBusy)
            {
               this.championSelectionModel.addEventListener(ChampionSelectionModel.CHAMPION_SELECTION_IS_BUSY_CHANGED,this.onChampionSelectionIsBusyChanged,false,0,true);
            }
            else
            {
               this.tutorialStates.advanceState();
            }
         }
      }
      
      public function openSpellSelect() : void
      {
         if(!this.spellSelectAlreadyOpened)
         {
            this.tutorialStates.advanceState();
         }
      }
      
      private function onIntroduceNextChampion() : void
      {
         var _loc1_:Number = Number(this.championTooltipPositions[this.championIntroNumber].x);
         var _loc2_:Number = Number(this.championTooltipPositions[this.championIntroNumber].y);
         if(this.displayChampionIDs[this.championIntroNumber] == 86)
         {
            this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.GAREN,_loc1_,_loc2_,ArrowedAlertStyle.POINT_UP);
            this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_GAREN_INTRO);
         }
         else if(this.displayChampionIDs[this.championIntroNumber] == 22)
         {
            this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.ASHE,_loc1_,_loc2_,ArrowedAlertStyle.POINT_UP);
            this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_ASHE_INTRO);
         }
         else if(this.displayChampionIDs[this.championIntroNumber] == 13)
         {
            this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.RYZE,_loc1_,_loc2_,ArrowedAlertStyle.POINT_UP);
            this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_RYZE_INTRO);
         }
         ++this.championIntroNumber;
      }
      
      private function pushRemainingStates() : void
      {
         this.tutorialStates.pushNewState(this.onChampionRosterEnter,this.onChampionRosterExit);
         this.tutorialStates.pushNewState(this.onTeammateSelectionEnter,null);
         this.tutorialStates.pushNewState(this.onChatWindowEnter,null);
         this.tutorialStates.pushNewState(this.onSummonerSpellsInfoEnter,this.onSummonerSpellsInfoExit);
         this.tutorialStates.pushNewState(this.onSelectSpellsEnter,this.onSelectSpellsExit);
         this.tutorialStates.pushNewState(this.onStatBonusEnter,null);
         this.tutorialStates.pushNewState(this.onMasteriesEnter,null);
         this.tutorialStates.pushNewState(this.onRunePageEnter,null);
         this.tutorialStates.pushNewState(this.onSkinSelectionEnter,null);
         this.tutorialStates.pushNewState(this.onLockInEnter,null);
         this.tutorialStates.pushNewState(this.onMakeChoicesEnter,this.onMakeChoicesExit);
         this.tutorialStates.pushNewState(this.onGameStartingEnter,null);
      }
      
      private function onSelectSpellsExit() : void
      {
      }
      
      public function skipToEnd() : void
      {
         this.tutorialStates.skipToEnd();
         this.tutorialStates.pushNewState(this.onMakeChoicesEnter,this.onMakeChoicesExit);
         this.tutorialStates.advanceState();
         this.championSelectionModel.championsActive = this.championSelectionModel.spellsActive = this.championSelectionModel.masteriesActive = this.championSelectionModel.runesActive = this.championSelectionModel.lockInActive = this.championSelectionModel.friendlyTeamActive = true;
      }
      
      private function onLockInEnter() : void
      {
         this.tutorialStates.turnOnComponentGlow(GlowLocation.LOCK_IN_BUTTON);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.LOCKIN,720,250,ArrowedAlertStyle.POINT_DOWN);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_LOCK_IN);
      }
      
      private function filterHardcodedChamps(param1:Champion) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.tutorialChampions)
         {
            if(param1.skinName == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function onSummonerSpellsInfoEnter() : void
      {
         this.championSelectionModel.spellsActive = true;
         this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_SPELLS);
         this.tutorialStates.showTipDialog(TutorialDialogConstants.SPELLS,475,250,ArrowedAlertStyle.POINT_DOWN);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_SPELLS);
      }
      
      private function onChampionsIntroEnter() : void
      {
         this.championSelectionModel.showChampionGrid = true;
         this.championSelectionModel.championsActive = true;
         this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_CHAMPIONS);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.CHAMPION_ROSTER,213,220,ArrowedAlertStyle.POINT_UP);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_CHAMPION_ROSTER_INTRO);
      }
      
      public function closeSpellSelect() : void
      {
         if(!this.spellSelectAlreadyOpened)
         {
            this.tutorialStates.advanceState();
         }
         this.spellSelectAlreadyOpened = true;
      }
      
      private function initializePopulateStates() : void
      {
         this.tutorialStates.clear();
         this.tutorialStates.pushNewState(this.onGreetingEnter,null);
         this.tutorialStates.pushNewState(this.onChampionSelectionIntroEnter,null);
         this.tutorialStates.pushNewState(this.onTimeLimitEnter,null);
         this.tutorialStates.pushNewState(this.onChampionsIntroEnter,this.onChampionsIntroExit);
      }
      
      private function onGameTimerChanged(param1:Event) : void
      {
         var _loc2_:AlertAction = null;
         if(this.timeLeftWarningShown == false && this.championSelectionModel.timeRemainingSeconds != 0 && this.championSelectionModel.timeRemainingSeconds <= 60)
         {
            this.timeLeftWarningShown = true;
            _loc2_ = new AlertAction(RiotResourceLoader.getString(TutorialDialogConstants.TIMEOUT_TITLE),RiotResourceLoader.getString(TutorialDialogConstants.TIMEOUT_MESSAGE));
            _loc2_.add();
         }
         else if(this.championSelectionModel.timeRemainingSeconds == 0 && this.championSelectionModel.championSelectionState == GameState.CHAMPION_SELECTION)
         {
            setTimeout(this.checkForOutOfTime,500);
         }
      }
      
      private function onStatBonusEnter() : void
      {
         this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_RUNESBOX);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.STAT_BONUSES,220,250,ArrowedAlertStyle.POINT_DOWN);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_STAT_BONUSES);
      }
      
      private function onSkinSelectionEnter() : void
      {
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.SKIN_SELECTION,490,400,ArrowedAlertStyle.NO_ARROW);
         this.championSelectionModel.mainMenuState = MenuStates.MAIN_MENU_STATE_SKINS_ACTIVE;
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_SKINS);
      }
      
      private function onTimeLimitEnter() : void
      {
         this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_TIMER);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_TIME_LIMIT);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.TIME_LIMIT,140,85,ArrowedAlertStyle.POINT_UP);
      }
      
      private function onChampionSelectionIsBusyChanged(param1:Event) : void
      {
         if(this.championSelectionModel.championSelectionIsBusy == false)
         {
            this.tutorialStates.advanceState();
         }
      }
      
      private function onChampionRosterExit() : void
      {
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.SELECTED_CHAMPION_CHANGED,this.onSelectedChampionChanged);
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.CHAMPION_SELECTION_IS_BUSY_CHANGED,this.onChampionSelectionIsBusyChanged);
      }
      
      private function onNewState(param1:Event) : void
      {
         this.updateTutorialState();
      }
      
      private function onMasteriesEnter() : void
      {
         this.championSelectionModel.runesActive = this.championSelectionModel.masteriesActive = true;
         this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_MASTERIES);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.MASTERIES,220,290,ArrowedAlertStyle.POINT_DOWN);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_MASTERIES);
      }
      
      private function onChampionsIntroExit() : void
      {
         var _loc3_:Champion = null;
         this.displayChampionIDs = new Array();
         var _loc1_:int = int(this.championSelectionModel.championSelections.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.championSelectionModel.championSelections.getItemAt(_loc2_).champion;
            this.displayChampionIDs.push(_loc3_.championId);
            this.tutorialStates.pushNewState(this.onIntroduceNextChampion,null);
            _loc2_++;
         }
         this.pushRemainingStates();
      }
      
      private function updateMenuStates() : void
      {
         var _loc1_:ICommand = this.commandFactory.getUpdateMenuStatesCommand(this.championSelectionModel);
         _loc1_.execute();
      }
      
      private function onTeammateSelectionEnter() : void
      {
         this.championSelectionModel.friendlyTeamActive = true;
         this.championSelectionModel.friendlyTeammatesVisible = true;
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.TEAMMATE,230,200,ArrowedAlertStyle.POINT_LEFT);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_TEAMMATE);
      }
      
      private function onChampionSelectionIntroEnter() : void
      {
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_CHAMPION_SELECTION_INTRO);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.CHAMPION_SELECTION,500,250,ArrowedAlertStyle.NO_ARROW);
      }
      
      private function onChatWindowEnter() : void
      {
         this.tutorialStates.turnOnComponentGlow(GlowLocation.CHAMPION_SELECT_CHAT);
         this.tutorialStates.showConfirmationDialog(TutorialDialogConstants.CHAT,590,350,ArrowedAlertStyle.POINT_DOWN);
         this.tutorialStates.playVoiceOver(AudioKeys.TUTORIAL_CHAT);
      }
      
      private function createTutorialChampions() : void
      {
         var _loc1_:ICommand = this.commandFactory.getSetVisibleChampionsCommand(this.championSelectionModel,this.championSelectionModel.championSelectionState,false,true,false);
         _loc1_.execute();
         this.championSelectionModel.championSelections.customFilterFunction = this.filterHardcodedChamps;
         this.championSelectionModel.championSelections.refresh();
      }
      
      public function activate() : void
      {
         this.championSelectionModel.showChampionGrid = false;
         this.initializePopulateStates();
         this.tutorialStates.addEventListener(EventQueue.EVENT_NEW_STATE_ENTERED,this.onNewState);
         this.tutorialStates.advanceState();
         this.championSelectionModel.addEventListener(ChampionSelectionModel.TIME_REMAINING_SECONDS_CHANGED,this.onGameTimerChanged,false,0,true);
         this.createTutorialChampions();
         this.updateTutorialState();
      }
      
      public function destroy() : void
      {
         this.tutorialStates.cleanup();
         this.tutorialStates = null;
      }
   }
}

