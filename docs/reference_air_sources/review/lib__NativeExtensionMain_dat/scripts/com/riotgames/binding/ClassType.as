package com.riotgames.binding
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class ClassType extends Proxy
   {
      
      private var _instances:Object;
      
      private var _instanceNames:Array;
      
      private var _binding:AirLanguageBinding;
      
      private var _name:String;
      
      private var _constructorName:String;
      
      public function ClassType(param1:String, param2:Object, param3:AirLanguageBinding)
      {
         super();
         this._name = param1;
         this._binding = param3;
         var _loc4_:String = param1 + "." + param1;
         if(param2.methods.indexOf(_loc4_) != -1)
         {
            this._constructorName = _loc4_;
         }
      }
      
      public function get Name() : String
      {
         return this._name;
      }
      
      public function get Constructible() : Boolean
      {
         return this._constructorName != null;
      }
      
      public function create(... rest) : ObjectProxy
      {
         if(this._constructorName != null)
         {
            return this._binding.call(this._constructorName,rest) as ObjectProxy;
         }
         throw new TypeError("Objects of class " + this._name + " can\'t be instantiated.");
      }
      
      public function createProxy(param1:uint, param2:Boolean) : ObjectProxy
      {
         return new ObjectProxy(this,param1,param2,this._binding);
      }
      
      private function refreshInstances() : void
      {
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         this.refreshInstances();
         return this._instances[param1];
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in this._instances;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 == 0)
         {
            this.refreshInstances();
         }
         return param1 < this._instanceNames.length ? int(param1 + 1) : 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return this._instanceNames[param1 - 1];
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         var _loc2_:String = this._instanceNames[param1 - 1];
         return this._instances[_loc2_];
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

