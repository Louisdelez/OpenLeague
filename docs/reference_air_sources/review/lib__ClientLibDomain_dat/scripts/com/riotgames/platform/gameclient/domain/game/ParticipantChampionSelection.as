package com.riotgames.platform.gameclient.domain.game
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ParticipantChampionSelection extends EventDispatcher
   {
      
      private var _champion:Champion;
      
      private var _championChanged:Signal = new Signal();
      
      private var _gameTypeConfig:GameTypeConfig;
      
      private var _disabledForGame:Boolean = false;
      
      private var _participantChanged:Signal = new Signal();
      
      private var _ownedByYourTeam:Boolean = false;
      
      private var _ownedByEnemyTeam:Boolean = false;
      
      private var _participant:GameParticipant;
      
      private var _banned:Boolean = false;
      
      private var _bannedChanged:Signal = new Signal();
      
      public function ParticipantChampionSelection(param1:GameTypeConfig, param2:Champion)
      {
         super();
         this._gameTypeConfig = param1;
         this.champion = param2;
      }
      
      private function set _1431766121champion(param1:Champion) : void
      {
         if(this._champion != param1)
         {
            this._champion = param1;
            this._championChanged.dispatch(param1);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set disabledForGame(param1:Boolean) : void
      {
         var _loc2_:Object = this.disabledForGame;
         if(_loc2_ !== param1)
         {
            this._689740351disabledForGame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disabledForGame",_loc2_,param1));
         }
      }
      
      private function set _1922186452ownedByYourTeam(param1:Boolean) : void
      {
         this._ownedByYourTeam = param1;
      }
      
      public function getBannedChanged() : ISignal
      {
         return this._bannedChanged;
      }
      
      public function get ownedByEnemyTeam() : Boolean
      {
         return this._ownedByEnemyTeam;
      }
      
      [Bindable(event="propertyChange")]
      public function set champion(param1:Champion) : void
      {
         var _loc2_:Object = this.champion;
         if(_loc2_ !== param1)
         {
            this._1431766121champion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champion",_loc2_,param1));
         }
      }
      
      private function set _836332663ownedByEnemyTeam(param1:Boolean) : void
      {
         this._ownedByEnemyTeam = param1;
      }
      
      public function getChampionChanged() : ISignal
      {
         return this._championChanged;
      }
      
      private function set _689740351disabledForGame(param1:Boolean) : void
      {
         this._disabledForGame = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set ownedByEnemyTeam(param1:Boolean) : void
      {
         var _loc2_:Object = this.ownedByEnemyTeam;
         if(_loc2_ !== param1)
         {
            this._836332663ownedByEnemyTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownedByEnemyTeam",_loc2_,param1));
         }
      }
      
      public function get banned() : Boolean
      {
         return this._banned;
      }
      
      [Bindable(event="propertyChange")]
      public function set ownedByYourTeam(param1:Boolean) : void
      {
         var _loc2_:Object = this.ownedByYourTeam;
         if(_loc2_ !== param1)
         {
            this._1922186452ownedByYourTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownedByYourTeam",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set participant(param1:GameParticipant) : void
      {
         var _loc2_:Object = this.participant;
         if(_loc2_ !== param1)
         {
            this._767422259participant = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"participant",_loc2_,param1));
         }
      }
      
      public function reset() : void
      {
         this.participant = null;
         this.banned = false;
      }
      
      public function get champion() : Champion
      {
         return this._champion;
      }
      
      public function get ownedByYourTeam() : Boolean
      {
         return this._ownedByYourTeam;
      }
      
      private function set _767422259participant(param1:GameParticipant) : void
      {
         if(this._participant != param1)
         {
            this._participant = param1;
            this._participantChanged.dispatch(param1);
         }
      }
      
      private function set _1396343010banned(param1:Boolean) : void
      {
         if(param1 != this._banned)
         {
            this._banned = param1;
            this._bannedChanged.dispatch(param1);
         }
      }
      
      public function get participant() : GameParticipant
      {
         return this._participant;
      }
      
      public function get gameTypeConfig() : GameTypeConfig
      {
         return this._gameTypeConfig;
      }
      
      public function getParticipantChanged() : ISignal
      {
         return this._participantChanged;
      }
      
      override public function toString() : String
      {
         return RiotResourceLoader.getChampionResourceString("name",this.champion.skinName,"**" + this.champion.displayName);
      }
      
      [Bindable(event="propertyChange")]
      public function set banned(param1:Boolean) : void
      {
         var _loc2_:Object = this.banned;
         if(_loc2_ !== param1)
         {
            this._1396343010banned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"banned",_loc2_,param1));
         }
      }
      
      public function get disabledForGame() : Boolean
      {
         return this._disabledForGame;
      }
   }
}

