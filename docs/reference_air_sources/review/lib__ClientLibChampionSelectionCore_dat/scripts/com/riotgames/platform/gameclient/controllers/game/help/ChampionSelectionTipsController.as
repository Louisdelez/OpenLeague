package com.riotgames.platform.gameclient.controllers.game.help
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.popup.ITipPopupManager;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.TeamColors;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.util.string.RiotStringUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class ChampionSelectionTipsController extends EventDispatcher
   {
      
      private static const TOOLTIP_X_POS:Number = 744;
      
      private static const TOOLTIP_Y_POS:Number = 413;
      
      public static const CS_BIG_FONT_SIZE:uint = 25;
      
      public static const CS_ORANGE:String = "#E38914";
      
      public static const EVENT_NEW_TURN:String = "newTurnEvent";
      
      public static const STATE_YOUR_BAN_TURN_1:String = "banTurn1";
      
      public static const STATE_YOUR_BAN_TURN_2:String = "banTurn2";
      
      public static const STATE_YOUR_BAN_TURN_3:String = "banTurn3";
      
      public static const STATE_POTENTIAL_BANNER:String = "potentialBanner";
      
      public static const STATE_NOT_BANNING:String = "notBanning";
      
      public static const STATE_YOUR_PICK_TURN:String = "pickTurn";
      
      public static const STATE_PICK_LOCK_IN:String = "lockInPick";
      
      public static const STATE_UPCOMING_TURN:String = "upcomingTurn";
      
      public static const STATE_TURN_DONE:String = "turnOver";
      
      public static const STATE_POST_PICK:String = "postPick";
      
      public static const STATE_POST_PICK_REROLL:String = "postPickReroll";
      
      public static const STATE_GAME_STARTING:String = "gameStarting";
      
      public static const TOOLTIP_NEWBIE:String = "newbie";
      
      public static const TOOLTIP_RANKED:String = "ranked";
      
      private var shownPickWaitingTip:Boolean = false;
      
      private var shownNotBanningTip:Boolean = false;
      
      private var tipHeader:String;
      
      private var tipPopupManager:ITipPopupManager;
      
      private var firstBanPickTurn:Number = -1;
      
      protected var soundManager:ISoundProvider;
      
      private var shownPostPickTip:Boolean = false;
      
      private var parent:DisplayObject;
      
      private var shownPickConfirmedTip:Boolean = false;
      
      private var turnEndingSoonPickTurn:int = -1;
      
      private var shownLockInTip:Boolean = false;
      
      private var shownActivePickTip:Boolean = false;
      
      private var championSelectionModel:ChampionSelectionModel;
      
      private var shownRerollTip:Boolean = false;
      
      private var shownSecondBanTip:Boolean = false;
      
      private var shownActiveBanTip:Boolean = false;
      
      private var timeoutId:uint;
      
      private var shownPotentialBanTip:Boolean = false;
      
      private var _currentState:String = "";
      
      public function ChampionSelectionTipsController(param1:DisplayObject, param2:ITipPopupManager, param3:ChampionSelectionModel, param4:ISoundProvider)
      {
         super();
         this.championSelectionModel = param3;
         this.soundManager = param4;
         this.parent = param1;
         this.tipPopupManager = param2;
         this.activate();
      }
      
      private function hasChampionPicked() : Boolean
      {
         return this.championSelectionModel.selectedChampion != null && !this.championSelectionModel.selectedChampion.champion.isRandomChampion();
      }
      
      private function get draftPick() : Boolean
      {
         return this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_DRAFT_MODE_SINGLE_PICK || this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_TOURNAMENT || this.championSelectionModel.gameTypeConfig.id == GameTypeConfig.PICK_ID_SIM_BAN || this.championSelectionModel.gameTypeConfig.id == GameTypeConfig.PICK_ID_SIM_BAN_SHORT_TIMER;
      }
      
      public function destroy() : void
      {
         clearTimeout(this.timeoutId);
         this.timeoutId = 0;
         this.tipPopupManager.removeAllPopups();
         this.championSelectionModel.removeEventListener(ChampionSelectionModel.TIME_REMAINING_SECONDS_CHANGED,this.onGameTimerChanged);
      }
      
      private function showNotBanningTip() : void
      {
         var _loc1_:String = null;
         if(!this.votePick)
         {
            _loc1_ = RiotResourceLoader.getString("championSelection_newbietip_notBanningTip");
            this.showTip(this.tipHeader,_loc1_);
         }
      }
      
      private function updateStateDescription() : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc1_:uint = CS_BIG_FONT_SIZE;
         var _loc2_:String = CS_ORANGE;
         var _loc3_:String = "</font>";
         var _loc4_:String = "<font size=\'" + _loc1_ + "\'>";
         var _loc5_:String = "<font size=\'" + _loc1_ + "\' color=\'" + _loc2_ + "\'>";
         var _loc6_:String = "<font color=\'" + _loc2_ + "\'>";
         var _loc7_:String = "";
         switch(this.currentState)
         {
            case STATE_YOUR_BAN_TURN_1:
               _loc7_ = _loc4_;
               _loc7_ += RiotResourceLoader.getString("championSelection_messageCenter_banTurn1",null,[_loc6_,_loc3_]);
               _loc7_ += _loc3_;
               _loc7_ += this.findBanProgress();
               _loc7_ += this.findTimerWarning();
               break;
            case STATE_YOUR_BAN_TURN_2:
               _loc7_ = _loc4_;
               _loc7_ += RiotResourceLoader.getString("championSelection_messageCenter_banTurn2",null,[_loc6_,_loc3_]);
               _loc7_ += _loc3_;
               _loc7_ += this.findBanProgress();
               _loc7_ += this.findTimerWarning();
               break;
            case STATE_YOUR_BAN_TURN_3:
               _loc7_ = _loc4_;
               _loc7_ += RiotResourceLoader.getString("championSelection_messageCenter_banTurn3",null,[_loc6_,_loc3_]);
               _loc7_ += _loc3_;
               _loc7_ += this.findBanProgress();
               _loc7_ += this.findTimerWarning();
               break;
            case STATE_POTENTIAL_BANNER:
               _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_potentialBanner",null,[this.findCurrentActivePlayers()]);
               _loc7_ += this.findBanProgress();
               break;
            case STATE_NOT_BANNING:
               if(this.championSelectionModel.isSpectating)
               {
                  _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_spectator_notBanner",null,[this.findCurrentActivePlayers()]);
               }
               else
               {
                  _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_notBanner",null,[this.findCurrentActivePlayers()]);
               }
               _loc7_ += this.findBanProgress();
               break;
            case STATE_YOUR_PICK_TURN:
               _loc7_ = _loc4_;
               _loc8_ = this.votePick ? "championSelection_messageCenter_vote" : "championSelection_messageCenter_yourTurn";
               _loc7_ += RiotResourceLoader.getString(_loc8_,null,[_loc6_,_loc3_]);
               _loc7_ += _loc3_;
               _loc7_ += this.findTimerWarning();
               break;
            case STATE_PICK_LOCK_IN:
               _loc7_ = _loc4_;
               _loc9_ = this.votePick ? "championSelection_messageCenter_vote" : "championSelection_messageCenter_lockIn";
               _loc7_ += RiotResourceLoader.getString(_loc9_,null,[_loc6_,_loc3_]);
               _loc7_ += _loc3_;
               _loc7_ += this.findTimerWarning();
               break;
            case STATE_UPCOMING_TURN:
               if(this.championSelectionModel.isSpectating)
               {
                  _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_turnDone",null,[this.findCurrentActivePlayers()]);
               }
               else if(!this.championSelectionModel.isOccludingActivePickTurns)
               {
                  _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_upcomingTurn",null,[this.findCurrentActivePlayers()]);
               }
               break;
            case STATE_TURN_DONE:
               if(!this.championSelectionModel.isOccludingActivePickTurns)
               {
                  _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_turnDone",null,[this.findCurrentActivePlayers()]);
               }
               break;
            case STATE_POST_PICK_REROLL:
               if(this.championSelectionModel.timeRemainingSeconds <= 0)
               {
                  _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_gameStartSoon");
               }
               else
               {
                  _loc7_ = RiotResourceLoader.getString("championSelection_messageCenter_postPickARAM","**Your champion has been randomly selected.");
               }
               break;
            case STATE_POST_PICK:
               if(this.championSelectionModel.timeRemainingSeconds <= 0)
               {
                  _loc7_ = "<font color=\'#FF5555\'>";
                  _loc7_ += RiotResourceLoader.getString("championSelection_messageCenter_gameStartSoon");
                  _loc7_ += "</font>";
               }
               else if(this.championSelectionModel.isSpectating)
               {
                  _loc7_ = "<font color=\'#FF5555\'>";
                  _loc7_ += RiotResourceLoader.getString("championSelection_messageCenter_spectatorWait","**Waiting for all players to select champions");
                  _loc7_ += "</font>";
               }
               else
               {
                  _loc10_ = this.getSpecialPickOutcome();
                  if(!RiotStringUtil.isEmpty(_loc10_))
                  {
                     _loc11_ = RiotResourceLoader.getString("championSelection_messageCenter_pickOutcome_" + _loc10_,null,[_loc6_,_loc3_]);
                     _loc7_ = _loc4_ + _loc11_ + _loc3_;
                  }
                  else
                  {
                     _loc7_ = "";
                  }
               }
               break;
            case STATE_GAME_STARTING:
               _loc7_ = this.championSelectionModel.currentGame.queuePosition > 1 ? RiotResourceLoader.getString("championSelection_queuedPositionWaitLabel",null,[this.championSelectionModel.currentGame.queuePosition]) : RiotResourceLoader.getString("championSelection_queuedPosition1Label");
               if(this.championSelectionModel.currentGame.queuePosition == 1)
               {
                  this.soundManager.stopBackgroundMusic();
                  this.soundManager.play(AudioKeys.SOUND_GAME_STARTING);
               }
         }
         this.championSelectionModel.stateDescriptionText = _loc7_;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      private function showPickConfirmedTip() : void
      {
         var _loc1_:String = RiotResourceLoader.getString("championSelection_newbietip_pickConfirmedTip");
         this.showTip(this.tipHeader,_loc1_);
      }
      
      private function updateTips() : void
      {
         if(!this.championSelectionModel.currentGame || this.championSelectionModel.isSpectating)
         {
            return;
         }
         if(this.turnEndingSoonPickTurn > -1 && this.turnEndingSoonPickTurn != this.championSelectionModel.pickTurn)
         {
            this.soundManager.stop(AudioKeys.SOUND_TURN_ENDING_SOON);
         }
         if(Boolean(GameType.IsTutorial(this.championSelectionModel.currentGame.gameType)) || this.aramPick)
         {
            this.checkAllRandomTips();
            this.updateStateDescription();
            return;
         }
         var _loc1_:Boolean = this.checkBanTips();
         _loc1_ = !_loc1_ && this.checkPickTips();
         _loc1_ = !_loc1_ && this.checkPostPickTips();
         if(this.championSelectionModel.timeRemainingSeconds <= 0)
         {
            this.currentState = STATE_GAME_STARTING;
         }
         this.updateStateDescription();
      }
      
      private function checkPickTips() : Boolean
      {
         if(this.championSelectionModel.championSelectionState != GameState.CHAMPION_SELECTION)
         {
            return false;
         }
         if(this.championSelectionModel.currentPickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            if(this.hasChampionPicked())
            {
               this.currentState = STATE_PICK_LOCK_IN;
               if(!this.shownLockInTip)
               {
                  this.shownLockInTip = true;
                  this.showLockInTip();
               }
            }
            else
            {
               this.currentState = STATE_YOUR_PICK_TURN;
               if(!this.shownActivePickTip)
               {
                  this.shownActivePickTip = true;
                  this.showActivePickTip();
                  this.dispatchNewTurnEvent();
               }
            }
         }
         else if(this.hasChampionPicked())
         {
            this.currentState = STATE_TURN_DONE;
            if(!this.shownPickConfirmedTip && !this.votePick)
            {
               this.shownPickConfirmedTip = true;
               this.showPickConfirmedTip();
            }
         }
         else
         {
            this.currentState = STATE_UPCOMING_TURN;
            if(!this.shownPickWaitingTip)
            {
               this.shownPickWaitingTip = true;
               this.showPickWaitingTip();
            }
         }
         return true;
      }
      
      private function get votePick() : Boolean
      {
         return this.championSelectionModel.gameTypeConfig.votePickGameTypeConfig;
      }
      
      private function findCurrentActivePlayers() : String
      {
         var _loc3_:GameParticipant = null;
         var _loc4_:GameParticipant = null;
         var _loc1_:Boolean = true;
         var _loc2_:String = "";
         for each(_loc3_ in this.championSelectionModel.currentTeam)
         {
            if(_loc3_.pickMode == GameParticipant.PICK_MODE_ACTIVE)
            {
               if(!_loc1_)
               {
                  _loc2_ += ",";
               }
               else
               {
                  _loc1_ = false;
               }
               _loc2_ += " " + "<font color=\'" + TeamColors.FRIENDLY_TEAM_COLOR + "\'>" + _loc3_.summonerName + "</font>";
            }
         }
         for each(_loc4_ in this.championSelectionModel.enemyTeam)
         {
            if(_loc4_.pickMode == GameParticipant.PICK_MODE_ACTIVE)
            {
               if(!_loc1_)
               {
                  _loc2_ += ",";
               }
               else
               {
                  _loc1_ = false;
               }
               _loc2_ += " " + "<font color=\'" + TeamColors.ENEMY_TEAM_COLOR + "\'>" + _loc4_.summonerName + "</font>";
            }
         }
         return _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function set currentState(param1:String) : void
      {
         var _loc2_:Object = this.currentState;
         if(_loc2_ !== param1)
         {
            this._1457822360currentState = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentState",_loc2_,param1));
         }
      }
      
      private function showPotentialBan() : void
      {
         var _loc1_:String = null;
         if(!this.votePick)
         {
            _loc1_ = RiotResourceLoader.getString("championSelection_newbietip_potentialBannerTip");
            this.showTip(this.tipHeader,_loc1_);
         }
      }
      
      private function checkBanTips() : Boolean
      {
         if(this.championSelectionModel.championSelectionState != GameState.PRE_CHAMPION_SELECTION)
         {
            return false;
         }
         if(this.championSelectionModel.currentPickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            switch(this.championSelectionModel.pickTurn)
            {
               case 1:
                  this.showBanTip1();
                  this.currentState = STATE_YOUR_BAN_TURN_1;
                  this.dispatchNewTurnEvent();
                  return true;
               case 2:
                  this.showBanTip1();
                  this.currentState = STATE_YOUR_BAN_TURN_1;
                  this.dispatchNewTurnEvent();
                  return true;
               case 3:
                  this.showBanTip2();
                  this.currentState = STATE_YOUR_BAN_TURN_2;
                  this.dispatchNewTurnEvent();
                  return true;
               case 4:
                  this.showBanTip2();
                  this.currentState = STATE_YOUR_BAN_TURN_2;
                  this.dispatchNewTurnEvent();
                  return true;
               case 5:
                  this.showBanTip3();
                  this.currentState = STATE_YOUR_BAN_TURN_3;
                  this.dispatchNewTurnEvent();
                  return true;
               case 6:
                  this.showBanTip3();
                  this.currentState = STATE_YOUR_BAN_TURN_3;
                  this.dispatchNewTurnEvent();
                  return true;
            }
         }
         else if(this.isPotentialBanner())
         {
            this.currentState = STATE_POTENTIAL_BANNER;
            switch(this.championSelectionModel.pickTurn)
            {
               case 1:
                  this.showPotentialBan();
                  return true;
               case 2:
                  this.showPotentialBan();
                  return true;
               default:
                  this.tipPopupManager.removeAllPopups();
            }
         }
         else
         {
            this.currentState = STATE_NOT_BANNING;
            if(!this.shownNotBanningTip)
            {
               this.shownNotBanningTip = true;
               this.showNotBanningTip();
               return true;
            }
         }
         return false;
      }
      
      private function onGameTimerChanged(param1:Event) : void
      {
         if(this.championSelectionModel.timeRemainingSeconds > 0 && this.championSelectionModel.timeRemainingSeconds <= 10 && this.championSelectionModel.pickTurn != this.turnEndingSoonPickTurn && this.championSelectionModel.currentPickMode == GameParticipant.PICK_MODE_ACTIVE)
         {
            this.turnEndingSoonPickTurn = this.championSelectionModel.pickTurn;
            this.soundManager.play(AudioKeys.SOUND_TURN_ENDING_SOON);
         }
         if(this.championSelectionModel.timeRemainingSeconds <= 0 && this.championSelectionModel.championSelectionState == GameState.POST_CHAMPION_SELECTION)
         {
            this.updateTips();
         }
      }
      
      private function showPostPickTip() : void
      {
         var _loc3_:String = null;
         var _loc1_:String = this.tipHeader;
         var _loc2_:String = RiotResourceLoader.getString("championSelection_newbietip_postPickTip",null,[this.championSelectionModel.timeRemainingSeconds]);
         if(this.votePick)
         {
            _loc3_ = this.getSpecialPickOutcome();
            if(!RiotStringUtil.isEmpty(_loc3_))
            {
               _loc1_ = RiotResourceLoader.getString("championSelection_newbietip_votePick_resultTitle_" + _loc3_);
               _loc2_ = RiotResourceLoader.getString("championSelection_newbietip_votePick_resultDescr_" + _loc3_);
            }
         }
         this.soundManager.play(AudioKeys.SOUND_PHASE_CHANGE);
         this.showTip(_loc1_,_loc2_);
      }
      
      private function showLockInTip() : void
      {
         var _loc1_:String = this.votePick ? "championSelection_newbietip_votePick_voting" : "championSelection_newbietip_lockInTip";
         this.showTip(this.tipHeader,RiotResourceLoader.getString(_loc1_),TOOLTIP_NEWBIE,989);
      }
      
      private function showRerollTip() : void
      {
         var _loc1_:String = RiotResourceLoader.getString("championSelection_newbietip_rerollTip");
         this.showTip(this.tipHeader,_loc1_,TOOLTIP_NEWBIE,989);
      }
      
      private function showActivePickTip() : void
      {
         var _loc1_:String = this.votePick ? "championSelection_newbietip_votePick_voting" : "championSelection_newbietip_pickActiveTip";
         this.showTip(this.tipHeader,RiotResourceLoader.getString(_loc1_),TOOLTIP_NEWBIE,989);
      }
      
      public function updateGame() : void
      {
         this.updateTips();
      }
      
      private function showTip(param1:String, param2:String, param3:String = "newbie", param4:Number = -1, param5:Number = -1) : void
      {
         if(!UserPreferencesManager.userPrefs.newbieTipsEnabled && param3 == TOOLTIP_NEWBIE)
         {
            return;
         }
         var _loc6_:Number = param4;
         var _loc7_:Number = param5;
         if(_loc6_ < 0)
         {
            _loc6_ = TOOLTIP_X_POS;
         }
         if(_loc7_ < 0)
         {
            _loc7_ = TOOLTIP_Y_POS;
         }
         this.tipPopupManager.createTipPopup(this.parent,param3,param1,param2,_loc6_,_loc7_);
      }
      
      private function isPotentialBanner() : Boolean
      {
         var _loc1_:ArrayCollection = this.championSelectionModel.currentTeam;
         var _loc2_:GameParticipant = _loc1_.getItemAt(0) as GameParticipant;
         return _loc2_.isMe;
      }
      
      private function checkPostPickTips() : Boolean
      {
         if(this.championSelectionModel.championSelectionState != GameState.POST_CHAMPION_SELECTION)
         {
            return false;
         }
         if(!this.shownPostPickTip)
         {
            this.shownPostPickTip = true;
            this.showPostPickTip();
            this.currentState = STATE_POST_PICK;
            return true;
         }
         return false;
      }
      
      private function set _1457822360currentState(param1:String) : void
      {
         this._currentState = param1;
      }
      
      private function get aramPick() : Boolean
      {
         return this.championSelectionModel.gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_ALL_RANDOM;
      }
      
      private function showBanTip1() : void
      {
         var _loc1_:String = null;
         if(!this.votePick)
         {
            _loc1_ = RiotResourceLoader.getString("championSelection_newbietip_banTip1");
            this.showTip(this.tipHeader,_loc1_);
         }
      }
      
      private function showBanTip2() : void
      {
         var _loc1_:String = null;
         if(!this.votePick)
         {
            _loc1_ = RiotResourceLoader.getString("championSelection_newbietip_banTip2");
            this.showTip(this.tipHeader,_loc1_);
         }
      }
      
      private function findBanProgress() : String
      {
         var _loc1_:uint = uint(this.championSelectionModel.gameTypeConfig.maxAllowableBans);
         var _loc2_:uint = uint(this.championSelectionModel.pickTurn);
         var _loc3_:String = " (" + _loc2_ + "/" + _loc1_ + ")";
         return RiotResourceLoader.getString("championSelection_messageCenter_banProgress",null,[_loc3_]);
      }
      
      private function showPickWaitingTip() : void
      {
         var _loc1_:String = RiotResourceLoader.getString("championSelection_newbietip_pickWaitingTip");
         this.showTip(this.tipHeader,_loc1_);
      }
      
      private function getSpecialPickOutcome() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = null;
         if(this.championSelectionModel.currentGame != null && this.championSelectionModel.currentPlayerParticipant != null)
         {
            _loc2_ = int(this.championSelectionModel.currentGame.getTeamForPlayer(this.championSelectionModel.currentPlayerParticipant.summonerName));
            switch(_loc2_)
            {
               case 1:
                  _loc1_ = this.championSelectionModel.currentGame.teamOnePickOutcome;
                  break;
               case 2:
                  _loc1_ = this.championSelectionModel.currentGame.teamTwoPickOutcome;
            }
         }
         return _loc1_;
      }
      
      private function findTimerWarning() : String
      {
         var _loc1_:String = null;
         if(this.championSelectionModel.timeRemainingSeconds <= 0)
         {
            _loc1_ = "<p></p><font color=\'#FF5555\'>";
            _loc1_ += RiotResourceLoader.getString("championSelection_messageCenter_timerWarning");
            return _loc1_ + "</font>";
         }
         return "";
      }
      
      private function showBanTip3() : void
      {
         var _loc1_:String = null;
         if(!this.votePick)
         {
            _loc1_ = RiotResourceLoader.getString("championSelection_newbietip_banTip3");
            this.showTip(this.tipHeader,_loc1_);
         }
      }
      
      public function activate() : void
      {
         var _loc1_:String = null;
         if(this.championSelectionModel.currentGame.gameType == "RANKED_GAME" && Boolean(UserPreferencesManager.userPrefs.rankedChampionSelectTipsEnabled))
         {
            this.tipHeader = RiotResourceLoader.getString("championSelection_rankedheader_queueDodge");
            _loc1_ = RiotResourceLoader.getString("championSelection_rankedtip_queueDodge");
            this.showTip(this.tipHeader,_loc1_,TOOLTIP_RANKED,-1,210);
         }
         if(this.draftPick)
         {
            this.tipHeader = RiotResourceLoader.getString("championSelection_newbieheader_draftPick");
         }
         else if(this.aramPick)
         {
            this.tipHeader = RiotResourceLoader.getString("championSelection_newbieheader_allRandom");
         }
         else if(this.votePick)
         {
            this.tipHeader = RiotResourceLoader.getString("championSelection_newbieheader_votePick");
         }
         else
         {
            this.tipHeader = RiotResourceLoader.getString("championSelection_newbieheader_blindPick");
         }
         this.championSelectionModel.addEventListener(ChampionSelectionModel.TIME_REMAINING_SECONDS_CHANGED,this.onGameTimerChanged,false,0,true);
         this.timeoutId = setTimeout(this.updateTips,50);
      }
      
      private function dispatchNewTurnEvent() : void
      {
         dispatchEvent(new Event(EVENT_NEW_TURN));
      }
      
      private function checkAllRandomTips() : void
      {
         if(Boolean(!this.shownRerollTip) && Boolean(this.championSelectionModel) && this.championSelectionModel.allowReroll)
         {
            this.shownRerollTip = true;
            this.showRerollTip();
            this.currentState = STATE_POST_PICK_REROLL;
         }
      }
   }
}

