package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class Spell implements IEventDispatcher
   {
      
      private var _1714148973displayName:String;
      
      private var _1422950650active:Boolean;
      
      private var _3373707name:String;
      
      private var _984376926gameModes:ArrayCollection;
      
      private var _1724546052description:String;
      
      private var _2008194973spellId:int;
      
      private var _1386076078minLevel:int;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function Spell(param1:Object = null)
      {
         var obj:Object = param1;
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         if(obj != null)
         {
            try
            {
               this.spellId = obj.spellId;
               this.name = obj.name;
               this.displayName = obj.displayName;
               this.description = obj.description;
               this.minLevel = obj.minLevel;
               this.active = obj.active;
               if(obj.gameModes is Array)
               {
                  this.gameModes = new ArrayCollection(obj.gameModes);
               }
            }
            catch(e:Error)
            {
               spellId = minLevel = 0;
               name = displayName = description = null;
               gameModes = null;
            }
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set gameModes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._984376926gameModes;
         if(_loc2_ !== param1)
         {
            this._984376926gameModes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameModes",_loc2_,param1));
         }
      }
      
      public function set spellId(param1:int) : void
      {
         var _loc2_:Object = this._2008194973spellId;
         if(_loc2_ !== param1)
         {
            this._2008194973spellId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get active() : Boolean
      {
         return this._1422950650active;
      }
      
      [Bindable(event="propertyChange")]
      public function get minLevel() : int
      {
         return this._1386076078minLevel;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:Object = this._1422950650active;
         if(_loc2_ !== param1)
         {
            this._1422950650active = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"active",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this._1714148973displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameModes() : ArrayCollection
      {
         return this._984376926gameModes;
      }
      
      [Bindable(event="propertyChange")]
      public function get spellId() : int
      {
         return this._2008194973spellId;
      }
      
      public function set minLevel(param1:int) : void
      {
         var _loc2_:Object = this._1386076078minLevel;
         if(_loc2_ !== param1)
         {
            this._1386076078minLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minLevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
   }
}

