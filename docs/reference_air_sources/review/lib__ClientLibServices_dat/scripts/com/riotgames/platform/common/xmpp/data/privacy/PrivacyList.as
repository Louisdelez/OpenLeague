package com.riotgames.platform.common.xmpp.data.privacy
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class PrivacyList implements IEventDispatcher
   {
      
      private var _items:ArrayCollection = new ArrayCollection();
      
      private var itemsByJID:Array;
      
      private var _pendingAddItems:ArrayCollection = new ArrayCollection();
      
      private var _748916528isActive:Boolean = false;
      
      private var _name:String;
      
      private var _pendingRemoveItems:ArrayCollection = new ArrayCollection();
      
      private var _itemsChanged:Signal = new Signal();
      
      private var _965025207isDefault:Boolean = false;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function PrivacyList(param1:String)
      {
         super();
         this._name = param1;
      }
      
      public function get items() : ArrayCollection
      {
         return this._items;
      }
      
      public function isEmpty() : Boolean
      {
         return this.items.length == 0;
      }
      
      public function getPrivacyItem(param1:String, param2:String = "jid", param3:String = "deny") : PrivacyListItem
      {
         var _loc4_:PrivacyListItem = this.itemsByJID[param1] as PrivacyListItem;
         if(Boolean(_loc4_) && _loc4_.action == param3)
         {
            return _loc4_;
         }
         return null;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set items(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.items;
         if(_loc2_ !== param1)
         {
            this._100526016items = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"items",_loc2_,param1));
         }
      }
      
      public function getItemsChanged() : ISignal
      {
         return this._itemsChanged;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get isActive() : Boolean
      {
         return this._748916528isActive;
      }
      
      public function getPendingRemoveItemsAndClear() : Array
      {
         var _loc1_:Array = this._pendingRemoveItems.toArray();
         this._pendingRemoveItems.removeAll();
         return _loc1_;
      }
      
      public function removePrivacyListItem(param1:PrivacyListItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:PrivacyListItem = null;
         if(this.itemsByJID[param1.value] != null)
         {
            this._pendingRemoveItems.addItem(param1);
            _loc2_ = int(this.items.getItemIndex(param1));
            _loc3_ = _loc2_ + 1;
            while(_loc3_ < this.items.length)
            {
               _loc4_ = this.items.getItemAt(_loc3_) as PrivacyListItem;
               --_loc4_.order;
               _loc3_++;
            }
            this.items.removeItemAt(_loc2_);
            this.itemsByJID[param1.value] = null;
            delete this.itemsByJID[param1.value];
         }
      }
      
      public function addPrivacyListItem(param1:PrivacyListItem) : void
      {
         this._pendingAddItems.addItem(param1);
         param1.order = this.items.length + 1;
         this.items.addItem(param1);
         this.itemsByJID[param1.value] = param1;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function contains(param1:String, param2:String = "jid", param3:String = "deny") : Boolean
      {
         return this.getPrivacyItem(param1,param2,param3) != null;
      }
      
      public function set isActive(param1:Boolean) : void
      {
         var _loc2_:Object = this._748916528isActive;
         if(_loc2_ !== param1)
         {
            this._748916528isActive = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isActive",_loc2_,param1));
         }
      }
      
      private function set _100526016items(param1:ArrayCollection) : void
      {
         var _loc2_:PrivacyListItem = null;
         this.itemsByJID = new Array();
         if(param1 == null)
         {
            this._items = new ArrayCollection();
         }
         else
         {
            this._items = param1;
            for each(_loc2_ in param1)
            {
               this.itemsByJID[_loc2_.value] = _loc2_;
            }
         }
         this._itemsChanged.dispatch();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set isDefault(param1:Boolean) : void
      {
         var _loc2_:Object = this._965025207isDefault;
         if(_loc2_ !== param1)
         {
            this._965025207isDefault = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isDefault",_loc2_,param1));
         }
      }
      
      public function getPendingAddItemsAndClear() : Array
      {
         var _loc1_:Array = this._pendingAddItems.toArray();
         this._pendingAddItems.removeAll();
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get isDefault() : Boolean
      {
         return this._965025207isDefault;
      }
   }
}

