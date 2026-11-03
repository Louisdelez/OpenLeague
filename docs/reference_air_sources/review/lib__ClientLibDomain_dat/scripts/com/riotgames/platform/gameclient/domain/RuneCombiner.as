package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.inventory.loot.RuneCombiner")]
   public class RuneCombiner implements IEventDispatcher
   {
      
      private var _1706961100inputTier:int;
      
      private var _3373707name:String;
      
      private var _1360680805inputCount:int;
      
      private var _3355id:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function RuneCombiner()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set inputCount(param1:int) : void
      {
         var _loc2_:Object = this._1360680805inputCount;
         if(_loc2_ !== param1)
         {
            this._1360680805inputCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inputCount",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get inputTier() : int
      {
         return this._1706961100inputTier;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set inputTier(param1:int) : void
      {
         var _loc2_:Object = this._1706961100inputTier;
         if(_loc2_ !== param1)
         {
            this._1706961100inputTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inputTier",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inputCount() : int
      {
         return this._1360680805inputCount;
      }
      
      public function toString() : String
      {
         return "Combiner " + this.id + " - requires " + this.inputCount + " tier " + this.inputTier + " rune(s)";
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set id(param1:Number) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
   }
}

