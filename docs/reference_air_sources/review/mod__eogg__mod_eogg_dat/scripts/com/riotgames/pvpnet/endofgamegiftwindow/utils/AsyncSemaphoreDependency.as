package com.riotgames.pvpnet.endofgamegiftwindow.utils
{
   public class AsyncSemaphoreDependency
   {
      
      private var _initFunction:Function;
      
      private var _args:Array;
      
      public function AsyncSemaphoreDependency(param1:Function, param2:Array)
      {
         super();
         this._initFunction = param1;
         this._args = param2;
      }
      
      public function get initFunction() : Function
      {
         return this._initFunction;
      }
      
      public function get args() : Array
      {
         return this._args;
      }
   }
}

