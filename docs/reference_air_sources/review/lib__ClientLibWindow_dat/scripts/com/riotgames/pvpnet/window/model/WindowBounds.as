package com.riotgames.pvpnet.window.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.geom.Rectangle;
   
   public class WindowBounds extends Rectangle
   {
      
      public var isDirty:Boolean = false;
      
      private var _changed:Signal = new Signal();
      
      private var _isUpdatingChanged:Signal = new Signal();
      
      private var _isUpdating:Boolean = false;
      
      public function WindowBounds(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      public function getIsUpdatingChanged() : ISignal
      {
         return this._isUpdatingChanged;
      }
      
      public function getIsUpdating() : Boolean
      {
         return this._isUpdating;
      }
      
      public function setIsUpdating(param1:Boolean) : void
      {
         if(this._isUpdating == param1)
         {
            return;
         }
         this._isUpdating = param1;
         this._isUpdatingChanged.dispatch(this);
      }
      
      public function getChanged() : ISignal
      {
         return this._changed;
      }
      
      public function notifyChanged() : void
      {
         this._changed.dispatch(this);
      }
   }
}

