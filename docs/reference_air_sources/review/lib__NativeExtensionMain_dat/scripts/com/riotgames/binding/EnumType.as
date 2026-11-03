package com.riotgames.binding
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class EnumType extends Proxy
   {
      
      private var _values:Object;
      
      private var _names:Array;
      
      private var _binding:AirLanguageBinding;
      
      private var _name:String;
      
      public function EnumType(param1:String, param2:Object, param3:AirLanguageBinding)
      {
         var _loc4_:Object = null;
         super();
         this._values = new Object();
         this._names = new Array();
         this._name = param1;
         this._binding = param3;
         for each(_loc4_ in param2.values)
         {
            this._values[_loc4_.name] = _loc4_.value;
            this._names.push(_loc4_.name);
         }
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this._values[param1];
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in this._values;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 < this._names.length ? int(param1 + 1) : 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._names[param1 - 1];
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         var _loc2_:String = this._names[param1 - 1];
         return this._values[_loc2_];
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         return false;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
      }
   }
}

