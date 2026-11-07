package com.riotgames.binding
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class ModuleProxy extends Proxy
   {
      
      private var _types:Object;
      
      private var _typeNames:Array;
      
      private var _binding:AirLanguageBinding;
      
      public function ModuleProxy(param1:Object, param2:AirLanguageBinding)
      {
         super();
         this._binding = param2;
         this.createTypes(param1);
      }
      
      private function createTypes(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this._types = new Object();
         this._typeNames = new Array();
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_];
            if("fields" in _loc3_)
            {
               this.createStructType(_loc2_,_loc3_);
            }
            else if("values" in _loc3_)
            {
               this.createEnumType(_loc2_,_loc3_);
            }
            else if("methods" in _loc3_)
            {
               this.createClassType(_loc2_,_loc3_);
            }
         }
      }
      
      private function createStructType(param1:String, param2:Object) : void
      {
         this._types[param1] = new StructType(param1,param2,this._bindings);
         this._typeNames.push(param1);
      }
      
      private function createEnumType(param1:String, param2:Object) : void
      {
         this._types[param1] = new EnumType(param1,param2,this._bindings);
         this._typeNames.push(param1);
      }
      
      private function createClassType(param1:String, param2:Object) : void
      {
         this._types[param1] = new ClassType(param1,param2,this._bindings);
         this._typeNames.push(param1);
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return this._binding.call(param1,rest);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this._types[param1];
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in this._types;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 < this._typeNames.length ? int(param1 + 1) : 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._typeNames[param1 - 1];
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         var _loc2_:String = this._typeNames[param1 - 1];
         return this._types[_loc2_];
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

