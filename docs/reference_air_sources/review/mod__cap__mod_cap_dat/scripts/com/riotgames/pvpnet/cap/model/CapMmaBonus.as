package com.riotgames.pvpnet.cap.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class CapMmaBonus
   {
      
      private var _positionBonusActiveChanged:Signal = new Signal();
      
      private var _positionBonusActive:Boolean;
      
      private var _roleBonusActiveChanged:Signal = new Signal();
      
      private var _championBonusActiveChanged:Signal = new Signal();
      
      private var _bonusAllowed:Boolean = false;
      
      private var _bonusAllowedChanged:Signal = new Signal();
      
      private var _roleBonusActive:Boolean = false;
      
      private var _championBonusActive:Boolean = false;
      
      public function CapMmaBonus()
      {
         super();
      }
      
      public function get roleBonusActiveChanged() : ISignal
      {
         return this._roleBonusActiveChanged;
      }
      
      public function set championBonusActive(param1:Boolean) : void
      {
         this._championBonusActive = param1;
         this._championBonusActiveChanged.dispatch();
      }
      
      public function get bonusAllowed() : Boolean
      {
         return this._bonusAllowed;
      }
      
      public function set bonusAllowed(param1:Boolean) : void
      {
         this._bonusAllowed = param1;
      }
      
      public function set positionBonusActive(param1:Boolean) : void
      {
         this._positionBonusActive = param1;
         this._positionBonusActiveChanged.dispatch();
      }
      
      public function get championBonusActive() : Boolean
      {
         return this._championBonusActive;
      }
      
      public function set roleBonusActive(param1:Boolean) : void
      {
         this._roleBonusActive = param1;
         this._roleBonusActiveChanged.dispatch();
      }
      
      public function get positionBonusActive() : Boolean
      {
         return this._positionBonusActive;
      }
      
      public function hasBonus() : Boolean
      {
         return this._bonusAllowed && (this.championBonusActive || this.roleBonusActive || this.positionBonusActive);
      }
      
      public function get bonusAllowedChanged() : Signal
      {
         return this._bonusAllowedChanged;
      }
      
      public function get roleBonusActive() : Boolean
      {
         return this._roleBonusActive;
      }
      
      public function get positionBonusActiveChanged() : ISignal
      {
         return this._positionBonusActiveChanged;
      }
      
      public function get championBonusActiveChanged() : ISignal
      {
         return this._championBonusActiveChanged;
      }
   }
}

