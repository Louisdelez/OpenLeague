package com.riotgames.pvpnet.game.variants
{
   import mx.collections.ArrayCollection;
   
   internal class BaseGameFlowVariant
   {
      
      protected var _key:String;
      
      protected var _gameMutators:ArrayCollection;
      
      protected var _gameMode:String;
      
      public function BaseGameFlowVariant()
      {
         super();
      }
      
      public function initializeContext(param1:ArrayCollection, param2:String) : void
      {
         this._gameMutators = param1;
         this._gameMode = param2;
      }
      
      internal function get key() : String
      {
         return this._key;
      }
   }
}

