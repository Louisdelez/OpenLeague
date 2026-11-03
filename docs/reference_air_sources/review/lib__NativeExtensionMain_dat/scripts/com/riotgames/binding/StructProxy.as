package com.riotgames.binding
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class StructProxy extends Proxy
   {
      
      private var _data:Object;
      
      private var _dataFields:Array;
      
      private var _type:StructType;
      
      private var _binding:AirLanguageBinding;
      
      public function StructProxy(param1:Object, param2:StructType, param3:AirLanguageBinding)
      {
         var _loc4_:String = null;
         super();
         this._data = new Object();
         this._dataFields = new Array();
         this._type = param2;
         this._binding = param3;
         for(_loc4_ in param1)
         {
            this._data[_loc4_] = param1[_loc4_];
            this._dataFields.push(_loc4_);
         }
      }
      
      public function get Data() : Object
      {
         return this._data;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:String = this._type.Name + "." + param1;
         rest.unshift(this);
         return this._binding.call(_loc3_,rest);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this._data[param1];
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in this._data;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 < this._dataFields.length ? int(param1 + 1) : 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._dataFields[param1 - 1];
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         var _loc2_:String = this._dataFields[param1 - 1];
         return this._data[_loc2_];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this._data[param1] = param2;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         return delete this._data[param1];
      }
   }
}

