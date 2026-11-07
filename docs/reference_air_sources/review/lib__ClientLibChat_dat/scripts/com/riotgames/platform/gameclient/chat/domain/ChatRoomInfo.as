package com.riotgames.platform.gameclient.chat.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ChatRoomInfo implements IEventDispatcher
   {
      
      private var _1867885268subject:String;
      
      private var _occupantCount:int;
      
      private var _1958325103obfuscatedName:String;
      
      private var _occupantCountChanged:Signal = new Signal();
      
      private var _1363513447isIndexed:Boolean;
      
      private var _219265106isPublicRoom:Boolean;
      
      private var _173302091roomType:String;
      
      private var _1087895369roomIndex:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ChatRoomInfo(param1:String, param2:Boolean, param3:int, param4:String, param5:Boolean, param6:String)
      {
         super();
         this.subject = param1;
         this.isIndexed = param2;
         this.roomIndex = param3;
         this.roomType = param4;
         this.isPublicRoom = param5;
         this.obfuscatedName = param6;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set isIndexed(param1:Boolean) : void
      {
         var _loc2_:Object = this._1363513447isIndexed;
         if(_loc2_ !== param1)
         {
            this._1363513447isIndexed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isIndexed",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isPublicRoom() : Boolean
      {
         return this._219265106isPublicRoom;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set subject(param1:String) : void
      {
         var _loc2_:Object = this._1867885268subject;
         if(_loc2_ !== param1)
         {
            this._1867885268subject = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subject",_loc2_,param1));
         }
      }
      
      public function get occupantCount() : int
      {
         return this._occupantCount;
      }
      
      public function set isPublicRoom(param1:Boolean) : void
      {
         var _loc2_:Object = this._219265106isPublicRoom;
         if(_loc2_ !== param1)
         {
            this._219265106isPublicRoom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isPublicRoom",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set occupantCount(param1:int) : void
      {
         var _loc2_:Object = this.occupantCount;
         if(_loc2_ !== param1)
         {
            this._1569401170occupantCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"occupantCount",_loc2_,param1));
         }
      }
      
      public function set obfuscatedName(param1:String) : void
      {
         var _loc2_:Object = this._1958325103obfuscatedName;
         if(_loc2_ !== param1)
         {
            this._1958325103obfuscatedName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"obfuscatedName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isIndexed() : Boolean
      {
         return this._1363513447isIndexed;
      }
      
      public function set roomType(param1:String) : void
      {
         var _loc2_:Object = this._173302091roomType;
         if(_loc2_ !== param1)
         {
            this._173302091roomType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"roomType",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subject() : String
      {
         return this._1867885268subject;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      private function set _1569401170occupantCount(param1:int) : void
      {
         if(param1 != this._occupantCount)
         {
            this._occupantCount = param1;
            this._occupantCountChanged.dispatch();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get roomIndex() : int
      {
         return this._1087895369roomIndex;
      }
      
      [Bindable(event="propertyChange")]
      public function get roomType() : String
      {
         return this._173302091roomType;
      }
      
      public function set roomIndex(param1:int) : void
      {
         var _loc2_:Object = this._1087895369roomIndex;
         if(_loc2_ !== param1)
         {
            this._1087895369roomIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"roomIndex",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get obfuscatedName() : String
      {
         return this._1958325103obfuscatedName;
      }
      
      public function getOccupantCountChanged() : ISignal
      {
         return this._occupantCountChanged;
      }
   }
}

