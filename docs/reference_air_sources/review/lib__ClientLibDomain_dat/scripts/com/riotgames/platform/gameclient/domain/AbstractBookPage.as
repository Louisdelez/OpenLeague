package com.riotgames.platform.gameclient.domain
{
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class AbstractBookPage extends AbstractDomainObject implements IEventDispatcher
   {
      
      public var summonerId:Number;
      
      protected var entries:ArrayCollection;
      
      public var pageId:Number;
      
      private var _1368729290createDate:Date;
      
      public var nameChanged:Signal = new Signal();
      
      private var _name:String = "";
      
      public var current:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AbstractBookPage()
      {
         super();
         this.entries = new ArrayCollection();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get createDate() : Date
      {
         return this._1368729290createDate;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function setEntries(param1:ArrayCollection) : void
      {
         this.entries = param1;
      }
      
      public function set createDate(param1:Date) : void
      {
         var _loc2_:Object = this._1368729290createDate;
         if(_loc2_ !== param1)
         {
            this._1368729290createDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createDate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this.name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function getEntries() : ArrayCollection
      {
         return this.entries;
      }
      
      private function set _3373707name(param1:String) : void
      {
         this._name = param1;
         this.nameChanged.dispatch();
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

