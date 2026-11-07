package com.riotgames.pvpnet.endofgamegiftwindow.utils
{
   import blix.IDestructible;
   
   public class AsyncSemaphore implements IDestructible
   {
      
      private var _dependencyList:Vector.<AsyncSemaphoreDependency>;
      
      private var _numberOfLocks:int;
      
      private var _allCompleteCallback:Function;
      
      public function AsyncSemaphore(param1:Vector.<AsyncSemaphoreDependency>, param2:Function)
      {
         super();
         this._dependencyList = param1;
         this._numberOfLocks = this._dependencyList.length;
         this._allCompleteCallback = param2;
      }
      
      public function captureLocks() : void
      {
         var _loc2_:AsyncSemaphoreDependency = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._dependencyList.length)
         {
            _loc2_ = this._dependencyList[_loc1_];
            _loc2_.initFunction.apply(null,_loc2_.args);
            _loc1_++;
         }
      }
      
      public function destroy() : void
      {
         this._allCompleteCallback = null;
      }
      
      public function releaseLock() : void
      {
         --this._numberOfLocks;
         this.checkAllLocksReleased();
      }
      
      private function checkAllLocksReleased() : void
      {
         if(this._numberOfLocks == 0)
         {
            this._allCompleteCallback.apply();
         }
      }
   }
}

