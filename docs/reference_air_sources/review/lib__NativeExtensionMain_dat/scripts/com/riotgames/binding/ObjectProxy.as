package com.riotgames.binding
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class ObjectProxy extends Proxy
   {
      
      private var _type:ClassType;
      
      private var _pointer:uint;
      
      private var _owned:Boolean;
      
      private var _binding:AirLanguageBinding;
      
      public function ObjectProxy(param1:ClassType, param2:uint, param3:Boolean, param4:AirLanguageBinding)
      {
         super();
         this._type = param1;
         this._pointer = param2;
         this._owned = param3;
         this._binding = param4;
      }
      
      public function get Type() : ClassType
      {
         return this._type;
      }
      
      public function get Pointer() : uint
      {
         return this._pointer;
      }
      
      public function get Owned() : Boolean
      {
         return this._owned;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:String = this._type.Name + "." + param1;
         rest.unshift(this);
         return this._binding.call(_loc3_,rest);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return undefined;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return false;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return null;
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return undefined;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         return false;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
      }
      
      public function dispose() : void
      {
         var _loc1_:String = null;
         if(this._owned && this._type.Constructible)
         {
            _loc1_ = this._type.Name + ".~" + this._type.Name;
            this._binding.call(_loc1_,[this]);
         }
      }
   }
}

