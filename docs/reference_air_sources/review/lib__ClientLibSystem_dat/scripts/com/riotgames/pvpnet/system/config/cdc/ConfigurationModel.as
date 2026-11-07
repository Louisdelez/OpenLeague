package com.riotgames.pvpnet.system.config.cdc
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class ConfigurationModel
   {
      
      private var _namespace:String;
      
      private var _key:String;
      
      private var _value:Object;
      
      private var _changedSignal:Signal = new Signal();
      
      public function ConfigurationModel(param1:String, param2:String, param3:Object)
      {
         super();
         this._namespace = param1;
         this._key = param2;
         this._value = param3;
      }
      
      public function getNamespace() : String
      {
         return this._namespace;
      }
      
      public function getKey() : String
      {
         return this._key;
      }
      
      public function getValue() : Object
      {
         return this._value;
      }
      
      public function setValue(param1:Object, param2:Boolean = false) : void
      {
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this._changedSignal.dispatch(param2);
      }
      
      public function getNumber() : Number
      {
         return this._value as Number;
      }
      
      public function getInt() : int
      {
         return this._value as int;
      }
      
      public function getBoolean() : Boolean
      {
         if(this._value == "true")
         {
            return true;
         }
         return this._value as Boolean;
      }
      
      public function getString() : String
      {
         return this._value as String;
      }
      
      public function getChangedSignal() : ISignal
      {
         return this._changedSignal;
      }
   }
}

