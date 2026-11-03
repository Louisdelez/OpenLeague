package com.riotgames.rust.components.sidemenu
{
   public class SideBarMenuItem
   {
      
      private var _index:uint;
      
      private var _header:String;
      
      private var _name:String;
      
      private var _path:String;
      
      private var _viewGetterFunction:Function;
      
      private var _functionParam:Array;
      
      private var _added:Boolean = false;
      
      public function SideBarMenuItem(param1:uint, param2:String, param3:String, param4:String, param5:Function, param6:Array)
      {
         super();
         this._index = param1;
         this._header = param2;
         this._name = param3;
         this._path = param4;
         this._viewGetterFunction = param5;
         this._functionParam = param6;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function get header() : String
      {
         return this._header;
      }
      
      public function set header(param1:String) : void
      {
         this._header = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function set path(param1:String) : void
      {
         this._path = param1;
      }
      
      public function get viewGetterFunction() : Function
      {
         return this._viewGetterFunction;
      }
      
      public function set viewGetterFunction(param1:Function) : void
      {
         this._viewGetterFunction = param1;
      }
      
      public function get added() : Boolean
      {
         return this._added;
      }
      
      public function set added(param1:Boolean) : void
      {
         this._added = param1;
      }
      
      public function get functionParam() : Array
      {
         return this._functionParam;
      }
   }
}

