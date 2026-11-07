package com.riotgames.binding
{
   public class StructType
   {
      
      private var _binding:AirLanguageBinding;
      
      private var _name:String;
      
      public function StructType(param1:String, param2:Object, param3:AirLanguageBinding)
      {
         super();
         this._name = param1;
         this._binding = param3;
      }
      
      public function get Name() : String
      {
         return this._name;
      }
      
      public function create(param1:Object) : *
      {
         return new StructProxy(param1,this,this._binding);
      }
   }
}

