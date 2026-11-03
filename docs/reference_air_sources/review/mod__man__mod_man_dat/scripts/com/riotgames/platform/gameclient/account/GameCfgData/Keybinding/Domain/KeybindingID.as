package com.riotgames.platform.gameclient.account.GameCfgData.Keybinding.Domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class KeybindingID implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public var internalName:String;
      
      public var displayName:String;
      
      private var _1118391318keysBound:ArrayCollection;
      
      public var internalCategory:String;
      
      public function KeybindingID(param1:String, param2:String, param3:String, param4:Array)
      {
         super();
         this.internalCategory = param3;
         this.internalName = param1;
         this.keysBound = new ArrayCollection(param4);
         this.displayName = param2;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function toString() : String
      {
         return this.displayName ? this.displayName : this.internalName;
      }
      
      [Bindable(event="propertyChange")]
      public function get keysBound() : ArrayCollection
      {
         return this._1118391318keysBound;
      }
      
      public function set keysBound(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1118391318keysBound;
         if(_loc2_ !== param1)
         {
            this._1118391318keysBound = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"keysBound",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
   }
}

