package com.riotgames.pvpnet.cap.model
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.championselection.IPlayerSelectionModel;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import flash.geom.Point;
   
   public class CapPlayerSelection implements IPlayerSelectionModel, IPlayerSpellModel, IDestructible
   {
      
      public static const CAPTAIN_INDEX:int = 0;
      
      public static const NO_INDEX:int = -1;
      
      public static const INTRO_STATE:String = "intro";
      
      public static const FIND_PLAYERS_STATE:String = "findPlayers";
      
      public static const CHOOSE_ROLE_STATE:String = "chooseRole";
      
      public static const CHOSEN_ROLE_STATE:String = "chosenRole";
      
      public static const CAPTAIN_SPECCING_STATE:String = "captainSpeccing";
      
      public static const SEARCHING_STATE:String = "searching";
      
      public static const FOUND_STATE:String = "found";
      
      public static const PENALTY_STATE:String = "kicked";
      
      public static const ACCEPTED_STATE:String = "accepted";
      
      public static const READY_STATE:String = "ready";
      
      public static const CHAMP_SELECTED_STATE:String = "champ_selected";
      
      public static const ROLE_POSITION_SELECTED_STATE:String = "lane_selected";
      
      public static const ROLE_LOCKED_STATE:String = "role_locked";
      
      public static const EMPTY_STATUS:String = "EMPTY";
      
      public static const CANDIDATE_FOUND_STATUS:String = "CANDIDATE_FOUND";
      
      public static const CANDIDATE_ACCEPTED_STATUS:String = "CANDIDATE_ACCEPTED";
      
      public static const POPULATED_STATUS:String = "POPULATED";
      
      private var _visibleChanged:Signal = new Signal();
      
      private var _advertisedRoleChanged:Signal = new Signal();
      
      private var _positionChanged:Signal = new Signal();
      
      private var _timeToApprove:int = -1;
      
      private var _penaltyTimeInSecondsChanged:Signal = new Signal();
      
      private var _isCaptainChanged:Signal = new Signal();
      
      private var _isCaptain:Boolean = false;
      
      private var _mapCoordinates:Point = new Point(0,0);
      
      private var _penaltyTimeInSeconds:int = 0;
      
      private var _spell1:Spell = null;
      
      private var _spell2:Spell = null;
      
      private var _isSoloPlayerChanged:Signal = new Signal();
      
      private var _visible:Boolean = false;
      
      private var _currentStateChanged:Signal = new Signal();
      
      private var _isInvitedPlayerChanged:Signal = new Signal();
      
      private var _runePage:SpellBookPageDTO;
      
      private var _spell2Changed:Signal = new Signal();
      
      private var _runePageChanged:Signal = new Signal();
      
      private var _rolePositionLocked:Boolean = false;
      
      private var _rolePositionLockedChanged:Signal = new Signal();
      
      private var _role:CapRole = null;
      
      private var _advertisedRole:CapRole = null;
      
      private var _isReady:Boolean = false;
      
      private var _skin:ChampionSkin;
      
      private var _mmaBonus:CapMmaBonus = new CapMmaBonus();
      
      public var summonerIconId:int;
      
      public var kicked:Boolean = false;
      
      private var _spell1Changed:Signal = new Signal();
      
      private var _currentState:String = "intro";
      
      private var _isPopulatedChanged:Signal = new Signal();
      
      private var _position:CapPosition = null;
      
      private var _isCandidateChanged:Signal = new Signal();
      
      private var _roleChanged:Signal = new Signal();
      
      public var isLocalPlayer:Boolean = false;
      
      private var _mapCoordinatesChanged:Signal = new Signal();
      
      private var _isCandidate:Boolean = false;
      
      private var _summonerNameChanged:Signal = new Signal();
      
      private var _skinChanged:Signal = new Signal();
      
      private var _slotIdChanged:Signal = new Signal();
      
      private var _masteryPage:MasteryPageInfoSummary;
      
      private var _champion:Champion = null;
      
      private var _championChanged:Signal = new Signal();
      
      private var _timeToApproveChanged:Signal = new Signal();
      
      private var _errorText:String = "";
      
      private var _slotId:int = -1;
      
      private var _summonerName:String = null;
      
      private var _masteryPageChanged:Signal = new Signal();
      
      private var _isPopulated:Boolean;
      
      private var _isInvitedPlayer:Boolean = false;
      
      private var _isReadyChanged:Signal = new Signal();
      
      private var _errorTextChanged:Signal = new Signal();
      
      public function CapPlayerSelection()
      {
         super();
      }
      
      public function get currentStateChanged() : ISignal
      {
         return this._currentStateChanged;
      }
      
      public function set mapCoordinates(param1:Point) : void
      {
         this._mapCoordinates = param1;
         this._mapCoordinatesChanged.dispatch();
      }
      
      public function get advertisedRoleChanged() : ISignal
      {
         return this._advertisedRoleChanged;
      }
      
      public function get spell2() : Spell
      {
         return this._spell2;
      }
      
      public function get championChanged() : ISignal
      {
         return this._championChanged;
      }
      
      public function get visibleChanged() : ISignal
      {
         return this._visibleChanged;
      }
      
      public function set spell2(param1:Spell) : void
      {
         this._spell2 = param1;
         this._spell2Changed.dispatch();
      }
      
      public function set skin(param1:ChampionSkin) : void
      {
         if(this._skin == param1)
         {
            return;
         }
         this._skin = param1;
         this._skinChanged.dispatch();
      }
      
      public function get timeToApprove() : int
      {
         return this._timeToApprove;
      }
      
      public function set isCandidate(param1:Boolean) : void
      {
         this._isCandidate = param1;
         this._isCandidateChanged.dispatch();
      }
      
      public function get spell1() : Spell
      {
         return this._spell1;
      }
      
      public function set masteryPage(param1:MasteryPageInfoSummary) : void
      {
         this._masteryPage = param1;
         this._masteryPageChanged.dispatch();
      }
      
      public function destroy() : void
      {
         this._advertisedRoleChanged.removeAll();
         this._championChanged.removeAll();
         this._currentStateChanged.removeAll();
         this._isCaptainChanged.removeAll();
         this._isInvitedPlayerChanged.removeAll();
         this._rolePositionLockedChanged.removeAll();
         this._isReadyChanged.removeAll();
         this._isCandidateChanged.removeAll();
         this._positionChanged.removeAll();
         this._roleChanged.removeAll();
         this._skinChanged.removeAll();
         this._slotIdChanged.removeAll();
         this._spell1Changed.removeAll();
         this._spell2Changed.removeAll();
         this._summonerNameChanged.removeAll();
         this._visibleChanged.removeAll();
         this._errorTextChanged.removeAll();
         this.clearValues();
      }
      
      public function set spell1(param1:Spell) : void
      {
         this._spell1 = param1;
         this._spell1Changed.dispatch();
      }
      
      public function set currentState(param1:String) : void
      {
         this._currentState = param1;
         this._currentStateChanged.dispatch();
      }
      
      public function get isInvitedPlayerChanged() : ISignal
      {
         return this._isInvitedPlayerChanged;
      }
      
      public function set timeToApprove(param1:int) : void
      {
         this._timeToApprove = param1;
         this._timeToApproveChanged.dispatch();
      }
      
      public function get position() : CapPosition
      {
         return this._position;
      }
      
      public function get isInvitedPlayer() : Boolean
      {
         return this._isInvitedPlayer;
      }
      
      public function get advertisedRole() : CapRole
      {
         return this._advertisedRole;
      }
      
      public function get timeToApproveTimeChanged() : ISignal
      {
         return this._timeToApproveChanged;
      }
      
      public function get spell2Changed() : ISignal
      {
         return this._spell2Changed;
      }
      
      public function get masteryPageChanged() : ISignal
      {
         return this._masteryPageChanged;
      }
      
      public function set isReady(param1:Boolean) : void
      {
         if(this._isReady == param1)
         {
            return;
         }
         this._isReady = param1;
         this._isReadyChanged.dispatch(param1,this);
      }
      
      public function get roleChanged() : ISignal
      {
         return this._roleChanged;
      }
      
      public function set isPopulated(param1:Boolean) : void
      {
         if(this._isPopulated == param1)
         {
            return;
         }
         this._isPopulated = param1;
         this._isPopulatedChanged.dispatch(this);
      }
      
      public function set position(param1:CapPosition) : void
      {
         if(this._position == param1)
         {
            return;
         }
         var _loc2_:CapPosition = this._position;
         this._position = param1;
         this._positionChanged.dispatch(this,_loc2_,this._position);
      }
      
      public function get positionChanged() : ISignal
      {
         return this._positionChanged;
      }
      
      public function set isInvitedPlayer(param1:Boolean) : void
      {
         this._isInvitedPlayer = param1;
         this._isInvitedPlayerChanged.dispatch();
         this._isSoloPlayerChanged.dispatch();
      }
      
      public function get champion() : Champion
      {
         return this._champion;
      }
      
      public function set rolePositionLocked(param1:Boolean) : void
      {
         this._rolePositionLocked = param1;
         this._rolePositionLockedChanged.dispatch();
      }
      
      public function get spell1Changed() : ISignal
      {
         return this._spell1Changed;
      }
      
      public function set advertisedRole(param1:CapRole) : void
      {
         this._advertisedRole = param1;
         this._advertisedRoleChanged.dispatch();
      }
      
      public function isSolo() : Boolean
      {
         return !this.isCaptain && !this.isInvitedPlayer;
      }
      
      public function get penaltyTimeInSeconds() : int
      {
         return this._penaltyTimeInSeconds;
      }
      
      public function set slotId(param1:int) : void
      {
         this._slotId = param1;
         this._isCaptainChanged.dispatch();
         this._slotIdChanged.dispatch();
         this._isSoloPlayerChanged.dispatch();
      }
      
      public function get role() : CapRole
      {
         return this._role;
      }
      
      public function get isCandidate() : Boolean
      {
         return this._isCandidate;
      }
      
      public function get summonerNameChanged() : ISignal
      {
         return this._summonerNameChanged;
      }
      
      public function get skin() : ChampionSkin
      {
         return this._skin;
      }
      
      public function get skinChanged() : ISignal
      {
         return this._skinChanged;
      }
      
      public function clearValuesForSolo() : void
      {
         this.isPopulated = false;
         this.errorText = null;
         this.champion = null;
         this.spell1 = null;
         this.spell2 = null;
         this.summonerIconId = -1;
         this.rolePositionLocked = false;
         this.isReady = false;
         this.isCandidate = false;
         this.isInvitedPlayer = false;
         this.summonerName = null;
         this.role = null;
         this.currentState = CapPlayerSelection.SEARCHING_STATE;
         this.timeToApprove = -1;
         this.penaltyTimeInSeconds = 0;
         this.kicked = false;
      }
      
      public function get isSoloChanged() : ISignal
      {
         return this._isSoloPlayerChanged;
      }
      
      public function get masteryPage() : MasteryPageInfoSummary
      {
         return this._masteryPage;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set penaltyTimeInSeconds(param1:int) : void
      {
         this._penaltyTimeInSeconds = param1;
         this._penaltyTimeInSecondsChanged.dispatch();
      }
      
      public function get runePageChanged() : ISignal
      {
         return this._runePageChanged;
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
      
      public function get errorText() : String
      {
         return this._errorText;
      }
      
      public function get isCaptain() : Boolean
      {
         return this.slotId == CAPTAIN_INDEX;
      }
      
      public function get errorTextChanged() : ISignal
      {
         return this._errorTextChanged;
      }
      
      public function get rolePositionLocked() : Boolean
      {
         return this._rolePositionLocked;
      }
      
      public function set errorText(param1:String) : void
      {
         this._errorText = param1;
         this._errorTextChanged.dispatch();
      }
      
      public function get mapCoordinatesChanged() : ISignal
      {
         return this._mapCoordinatesChanged;
      }
      
      public function get slotId() : int
      {
         return this._slotId;
      }
      
      public function get slotIdChanged() : ISignal
      {
         return this._slotIdChanged;
      }
      
      public function get isCaptainChanged() : ISignal
      {
         return this._isCaptainChanged;
      }
      
      public function get rolePositionLockedChanged() : ISignal
      {
         return this._rolePositionLockedChanged;
      }
      
      public function clearValues() : void
      {
         this._currentState = CapPlayerSelection.INTRO_STATE;
         this.slotId = NO_INDEX;
         this.visible = false;
         this.isPopulated = false;
         this._role = null;
         this._position = null;
         this._errorText = null;
         this._spell1 = null;
         this._spell2 = null;
         this.summonerIconId = -1;
         this._rolePositionLocked = false;
         this._isReady = false;
         this._skin = null;
         this._isCandidate = false;
         this._isInvitedPlayer = false;
         this._summonerName = null;
         this.role = this.role;
         this.position = this.position;
         this.currentState = this.currentState;
         this.errorText = this.errorText;
         this.champion = null;
         this.spell1 = this.spell1;
         this.spell2 = this.spell2;
         this.rolePositionLocked = this.rolePositionLocked;
         this._isReady = this.isReady;
         this.isCandidate = this.isCandidate;
         this.isInvitedPlayer = this.isInvitedPlayer;
         this.summonerName = this.summonerName;
         this.kicked = false;
      }
      
      public function get penaltyTimeInSecondsChanged() : ISignal
      {
         return this._penaltyTimeInSecondsChanged;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function get isPopulated() : Boolean
      {
         return this._isPopulated;
      }
      
      public function set champion(param1:Champion) : void
      {
         if(this._champion == param1)
         {
            return;
         }
         this._champion = param1;
         this._championChanged.dispatch();
      }
      
      public function get isReadyChanged() : ISignal
      {
         return this._isReadyChanged;
      }
      
      public function get mmaBonus() : CapMmaBonus
      {
         return this._mmaBonus;
      }
      
      public function get isPopulatedChanged() : ISignal
      {
         return this._isPopulatedChanged;
      }
      
      public function get runePage() : SpellBookPageDTO
      {
         return this._runePage;
      }
      
      public function set runePage(param1:SpellBookPageDTO) : void
      {
         this._runePage = param1;
         this._runePageChanged.dispatch();
      }
      
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:Boolean = param1 != this._visible;
         this._visible = param1;
         if(_loc2_)
         {
            this._visibleChanged.dispatch();
         }
      }
      
      public function set role(param1:CapRole) : void
      {
         this._role = param1;
         this._roleChanged.dispatch();
      }
      
      public function set summonerName(param1:String) : void
      {
         var _loc2_:String = this._summonerName;
         this._summonerName = param1;
         this._summonerNameChanged.dispatch(_loc2_,param1);
      }
      
      public function get summonerName() : String
      {
         return this._summonerName;
      }
      
      public function get isCandidateChanged() : ISignal
      {
         return this._isCandidateChanged;
      }
      
      public function get mapCoordinates() : Point
      {
         return this._mapCoordinates;
      }
   }
}

