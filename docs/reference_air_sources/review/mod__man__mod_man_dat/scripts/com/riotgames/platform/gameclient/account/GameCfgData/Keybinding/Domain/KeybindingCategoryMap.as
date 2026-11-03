package com.riotgames.platform.gameclient.account.GameCfgData.Keybinding.Domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class KeybindingCategoryMap implements IEventDispatcher
   {
      
      private var _1192738032keybindingsInCategory:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _426048681categoryName:String;
      
      public function KeybindingCategoryMap(param1:String, param2:Array)
      {
         super();
         this.categoryName = param1;
         this.keybindingsInCategory = new ArrayCollection(param2);
      }
      
      public function set keybindingsInCategory(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1192738032keybindingsInCategory;
         if(_loc2_ !== param1)
         {
            this._1192738032keybindingsInCategory = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"keybindingsInCategory",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get categoryName() : String
      {
         return this._426048681categoryName;
      }
      
      public function toString() : String
      {
         return this.categoryName;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get keybindingsInCategory() : ArrayCollection
      {
         return this._1192738032keybindingsInCategory;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set categoryName(param1:String) : void
      {
         var _loc2_:Object = this._426048681categoryName;
         if(_loc2_ !== param1)
         {
            this._426048681categoryName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"categoryName",_loc2_,param1));
         }
      }
   }
}

