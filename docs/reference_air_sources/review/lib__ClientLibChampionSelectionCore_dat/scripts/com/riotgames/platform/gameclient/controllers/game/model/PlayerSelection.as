package com.riotgames.platform.gameclient.controllers.game.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.championselection.IPlayerSelectionModel;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.Spell;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class PlayerSelection extends EventDispatcher implements IPlayerSelectionModel
   {
      
      public static const OBSCURED_VISUAL_NAME:String = "VizObscure";
      
      public static const SPELL_1_CHANGED:String = "spell1Changed";
      
      public static const SPELL_2_CHANGED:String = "spell2Changed";
      
      public static const TRADE_AVAILABLE_CHANGED:String = "tradeAvailableChanged";
      
      public static const TRADE_ACTIVE_CHANGED:String = "tradeActiveChanged";
      
      public static const CHAMPION_TRADE_CHANGED:String = "championTradeChanged";
      
      public static const GAME_STATE_CHANGED:String = "gameStateChanged";
      
      public static const SELECTION_STATE_CHANGED:String = "selectionStateChanged";
      
      public static const SELECTION_STATE_TEXT_CHANGED:String = "selectionStateTextChanged";
      
      public static const CHAMPION_CHANGED:String = "championChanged";
      
      public static const BADGES_CHANGED:String = "badgesChanged";
      
      public static const IS_IN_SYNC_CHANGED:String = "isInSyncChanged";
      
      public static const SELECTED_SKIN_CHANGED:String = "selectedSkinChanged";
      
      public static const PARTICIPANT_CHANGED:String = "participantChanged";
      
      private var _selectionState:String = "";
      
      private var _selectedSkin:ChampionSkin;
      
      private var _isInSync:Boolean = false;
      
      private var _selectedSkinChanged:Signal = new Signal();
      
      private var _spell1:Spell = null;
      
      private var _spell2:Spell = null;
      
      private var _gameState:String = "";
      
      private var _tradeActive:Boolean = false;
      
      private var _championChanged:Signal = new Signal();
      
      private var _badges:int = 0;
      
      private var _selectionStateText:String = "";
      
      private var _spell2Changed:Signal = new Signal();
      
      private var _defaultChampionVisualName:String;
      
      private var _champion:Champion;
      
      private var _tradeAvailable:Boolean = false;
      
      private var _spell1Changed:Signal = new Signal();
      
      private var _participant:GameParticipant;
      
      private var _championTrade:ChampionTrade;
      
      public function PlayerSelection(param1:GameParticipant)
      {
         super();
         this.participant = param1;
      }
      
      [Bindable(event="spell1Changed")]
      public function get spell1() : Spell
      {
         return this._spell1;
      }
      
      public function set tradeAvailable(param1:Boolean) : void
      {
         if(this._tradeAvailable == param1)
         {
            return;
         }
         this._tradeAvailable = param1;
         dispatchEvent(new Event(TRADE_AVAILABLE_CHANGED));
      }
      
      public function get championChanged() : ISignal
      {
         return this._championChanged;
      }
      
      [Bindable(event="spell2Changed")]
      public function get spell2() : Spell
      {
         return this._spell2;
      }
      
      public function set spell1(param1:Spell) : void
      {
         if(this._spell1 == param1)
         {
            return;
         }
         this._spell1 = param1;
         dispatchEvent(new Event(SPELL_1_CHANGED));
         this._spell1Changed.dispatch();
      }
      
      public function set spell2(param1:Spell) : void
      {
         if(this._spell2 == param1)
         {
            return;
         }
         this._spell2 = param1;
         dispatchEvent(new Event(SPELL_2_CHANGED));
         this._spell2Changed.dispatch();
      }
      
      [Bindable(event="tradeActiveChanged")]
      public function get tradeActive() : Boolean
      {
         return this._tradeActive;
      }
      
      public function set tradeActive(param1:Boolean) : void
      {
         if(this._tradeActive == param1)
         {
            return;
         }
         this._tradeActive = param1;
         dispatchEvent(new Event(TRADE_ACTIVE_CHANGED));
      }
      
      [Bindable(event="badgesChanged")]
      public function get badges() : int
      {
         return this._badges;
      }
      
      [Bindable(event="isInSyncChanged")]
      public function get isInSync() : Boolean
      {
         return this._isInSync;
      }
      
      [Bindable(event="selectionStateTextChanged")]
      public function get selectionStateText() : String
      {
         return this._selectionStateText;
      }
      
      [Bindable("participantChanged")]
      public function get participant() : GameParticipant
      {
         return this._participant;
      }
      
      [Bindable("selectedSkinChanged")]
      public function get selectedSkin() : ChampionSkin
      {
         return this._selectedSkin;
      }
      
      public function set defaultChampionVisualName(param1:String) : void
      {
         this._defaultChampionVisualName = param1;
      }
      
      [Bindable(event="gameStateChanged")]
      public function get gameState() : String
      {
         return this._gameState;
      }
      
      [Bindable(event="tradeAvailableChanged")]
      public function get tradeAvailable() : Boolean
      {
         return this._tradeAvailable;
      }
      
      public function get spell2Changed() : ISignal
      {
         return this._spell2Changed;
      }
      
      public function set isInSync(param1:Boolean) : void
      {
         if(this._isInSync == param1)
         {
            return;
         }
         this._isInSync = param1;
         dispatchEvent(new Event(IS_IN_SYNC_CHANGED));
      }
      
      public function get defaultChampionVisualName() : String
      {
         return this._defaultChampionVisualName;
      }
      
      public function get selectedSkinChanged() : ISignal
      {
         return this._selectedSkinChanged;
      }
      
      public function set badges(param1:int) : void
      {
         if(this._badges == param1)
         {
            return;
         }
         this._badges = param1;
         dispatchEvent(new Event(BADGES_CHANGED));
      }
      
      public function set selectionState(param1:String) : void
      {
         if(this._selectionState == param1)
         {
            return;
         }
         this._selectionState = param1;
         dispatchEvent(new Event(SELECTION_STATE_CHANGED));
      }
      
      [Bindable(event="selectionStateChanged")]
      public function get selectionState() : String
      {
         return this._selectionState;
      }
      
      public function set participant(param1:GameParticipant) : void
      {
         if(this._participant == param1)
         {
            return;
         }
         this._participant = param1;
         dispatchEvent(new Event(PARTICIPANT_CHANGED));
      }
      
      public function set champion(param1:Champion) : void
      {
         if(this.champion == param1)
         {
            return;
         }
         this._champion = param1;
         dispatchEvent(new Event(CHAMPION_CHANGED));
      }
      
      public function get spell1Changed() : ISignal
      {
         return this._spell1Changed;
      }
      
      [Bindable("championChanged")]
      public function get champion() : Champion
      {
         return this._champion;
      }
      
      public function set selectionStateText(param1:String) : void
      {
         if(this._selectionStateText == param1)
         {
            return;
         }
         this._selectionStateText = param1;
         dispatchEvent(new Event(SELECTION_STATE_TEXT_CHANGED));
      }
      
      public function set championTrade(param1:ChampionTrade) : void
      {
         if(this._championTrade == param1)
         {
            return;
         }
         this._championTrade = param1;
         dispatchEvent(new Event(CHAMPION_TRADE_CHANGED));
      }
      
      public function set selectedSkin(param1:ChampionSkin) : void
      {
         if(this._selectedSkin == param1)
         {
            return;
         }
         this._selectedSkin = param1;
         dispatchEvent(new Event(SELECTED_SKIN_CHANGED));
      }
      
      [Bindable(event="championTradeChanged")]
      public function get championTrade() : ChampionTrade
      {
         return this._championTrade;
      }
      
      public function set gameState(param1:String) : void
      {
         if(this._gameState == param1)
         {
            return;
         }
         this._gameState = param1;
         dispatchEvent(new Event(GAME_STATE_CHANGED));
      }
   }
}

