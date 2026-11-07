package com.riotgames.pvpnet.accountcreation.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.BitmapData;
   import mx.collections.ArrayCollection;
   
   public class ChooseIconModel
   {
      
      public var continueTutorialSequence:Boolean = true;
      
      private var _userIconList:ArrayCollection;
      
      private var _userIconListRequested:Signal = new Signal();
      
      private var _userIconListObtained:Signal = new Signal();
      
      private var _chosenIconChanged:Signal = new Signal();
      
      private var _chosenIconCancelled:Signal = new Signal();
      
      private var _pendingIconChanged:Signal = new Signal();
      
      public function ChooseIconModel()
      {
         super();
      }
      
      public function get userIconList() : ArrayCollection
      {
         if(this._userIconList == null)
         {
            this._userIconListRequested.dispatch();
         }
         return this._userIconList;
      }
      
      public function set userIconList(param1:ArrayCollection) : void
      {
         this._userIconList = param1;
         this._userIconListObtained.dispatch(param1);
      }
      
      public function getUserIconListRequested() : ISignal
      {
         return this._userIconListRequested;
      }
      
      public function getUserIconListObtained() : ISignal
      {
         return this._userIconListObtained;
      }
      
      public function getChosenIconChanged() : ISignal
      {
         return this._chosenIconChanged;
      }
      
      public function getChosenIconCancelled() : ISignal
      {
         return this._chosenIconCancelled;
      }
      
      public function getPendingIconChanged() : ISignal
      {
         return this._pendingIconChanged;
      }
      
      public function setPendingIcon(param1:int) : void
      {
         this._pendingIconChanged.dispatch(param1);
      }
      
      public function setChosenIcon(param1:int, param2:BitmapData = null) : void
      {
         this._chosenIconChanged.dispatch(param1,param2);
      }
      
      public function cancelChooseIcon() : void
      {
         this._chosenIconCancelled.dispatch();
      }
   }
}

