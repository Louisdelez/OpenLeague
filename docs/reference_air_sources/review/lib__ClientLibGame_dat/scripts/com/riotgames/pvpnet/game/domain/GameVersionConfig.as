package com.riotgames.pvpnet.game.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class GameVersionConfig implements IEventDispatcher
   {
      
      private static var _instance:GameVersionConfig;
      
      private var _installingPatch:Boolean = false;
      
      private var _installingPatchChanged:Signal = new Signal();
      
      private var _uninstallingPatch:Boolean = false;
      
      private var _uninstallingPatchChanged:Signal = new Signal();
      
      private var _uninstallingOldPatchOnUpdate:Boolean = false;
      
      private var _isWorkingChanged:Signal = new Signal();
      
      private var _patchProgress:Number = -1;
      
      private var _patchProgressChanged:Signal = new Signal();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GameVersionConfig()
      {
         super();
      }
      
      public static function get instance() : GameVersionConfig
      {
         if(_instance == null)
         {
            _instance = new GameVersionConfig();
         }
         return _instance;
      }
      
      [Bindable(event="propertyChange")]
      public function get installingPatch() : Boolean
      {
         return this._installingPatch;
      }
      
      private function set _1698066399installingPatch(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._installingPatch;
         if(_loc2_ != param1)
         {
            this._installingPatch = param1;
            this._installingPatchChanged.dispatch(this._installingPatchChanged,this._installingPatch);
            this._isWorkingChanged.dispatch();
         }
      }
      
      public function getInstallingPatchChanged() : ISignal
      {
         return this._installingPatchChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get uninstallingPatch() : Boolean
      {
         return this._uninstallingPatch;
      }
      
      private function set _1696160872uninstallingPatch(param1:Boolean) : void
      {
         var _loc2_:Boolean = this._uninstallingPatch;
         if(_loc2_ != param1)
         {
            this._uninstallingPatch = param1;
            this._uninstallingPatchChanged.dispatch(this._uninstallingPatchChanged,this._uninstallingPatch);
            this._isWorkingChanged.dispatch();
         }
      }
      
      public function getUninstallingPatchChanged() : ISignal
      {
         return this._uninstallingPatchChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get uninstallingOldPatchOnUpdate() : Boolean
      {
         return this._uninstallingOldPatchOnUpdate;
      }
      
      private function set _418297065uninstallingOldPatchOnUpdate(param1:Boolean) : void
      {
         this._uninstallingOldPatchOnUpdate = param1;
      }
      
      public function get isWorking() : Boolean
      {
         return this.installingPatch || this.uninstallingPatch;
      }
      
      public function getIsWorkingChanged() : ISignal
      {
         return this._isWorkingChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get patchProgress() : Number
      {
         return this._patchProgress;
      }
      
      private function set _933658261patchProgress(param1:Number) : void
      {
         this._patchProgress = param1;
         this._patchProgressChanged.dispatch(this._patchProgressChanged,this._patchProgress);
      }
      
      public function getPatchProgressChanged() : ISignal
      {
         return this._patchProgressChanged;
      }
      
      public function set uninstallingPatch(param1:Boolean) : void
      {
         var _loc2_:Object = this.uninstallingPatch;
         if(_loc2_ !== param1)
         {
            this._1696160872uninstallingPatch = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uninstallingPatch",_loc2_,param1));
            }
         }
      }
      
      public function set uninstallingOldPatchOnUpdate(param1:Boolean) : void
      {
         var _loc2_:Object = this.uninstallingOldPatchOnUpdate;
         if(_loc2_ !== param1)
         {
            this._418297065uninstallingOldPatchOnUpdate = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"uninstallingOldPatchOnUpdate",_loc2_,param1));
            }
         }
      }
      
      public function set patchProgress(param1:Number) : void
      {
         var _loc2_:Object = this.patchProgress;
         if(_loc2_ !== param1)
         {
            this._933658261patchProgress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"patchProgress",_loc2_,param1));
            }
         }
      }
      
      public function set installingPatch(param1:Boolean) : void
      {
         var _loc2_:Object = this.installingPatch;
         if(_loc2_ !== param1)
         {
            this._1698066399installingPatch = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installingPatch",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

