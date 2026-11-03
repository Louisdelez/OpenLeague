package com.riotgames.rust.components.sidebar
{
   public class SidebarItem
   {
      
      private var _index:uint;
      
      private var _header:String;
      
      private var _name:String;
      
      private var _path:String;
      
      private var _closure:Function;
      
      private var _added:Boolean = false;
      
      public function SidebarItem(param1:uint, param2:String, param3:String, param4:String, param5:Function)
      {
         super();
         this._index = param1;
         this._header = param2;
         this._name = param3;
         this._path = param4;
         this._closure = param5;
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
      
      public function get closure() : Function
      {
         return this._closure;
      }
      
      public function set closure(param1:Function) : void
      {
         this._closure = param1;
      }
      
      public function get added() : Boolean
      {
         return this._added;
      }
      
      public function set added(param1:Boolean) : void
      {
         this._added = param1;
      }
   }
}

