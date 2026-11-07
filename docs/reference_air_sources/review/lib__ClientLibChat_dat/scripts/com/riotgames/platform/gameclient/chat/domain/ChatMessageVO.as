package com.riotgames.platform.gameclient.chat.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class ChatMessageVO implements IEventDispatcher
   {
      
      protected var _body:String;
      
      private var _1738367038rosterItem:RosterItemVO;
      
      private var _3575610type:String;
      
      private var _25573622timeStamp:Date;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ChatMessageVO()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set body(param1:String) : void
      {
         var _loc2_:Object = this.body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set timeStamp(param1:Date) : void
      {
         var _loc2_:Object = this._25573622timeStamp;
         if(_loc2_ !== param1)
         {
            this._25573622timeStamp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeStamp",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get body() : String
      {
         return this._body;
      }
      
      public function getContactDisplayName() : String
      {
         return this.rosterItem == null ? "" : this.rosterItem.displayName;
      }
      
      private function set _3029410body(param1:String) : void
      {
         this._body = ChatPersonalMessageVO.removeHTMLTags(param1);
         this.timeStamp = new Date();
      }
      
      public function toString() : String
      {
         return "[" + this.type + "] " + this.getContactDisplayName() + ": " + this.body;
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get timeStamp() : Date
      {
         return this._25573622timeStamp;
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function set rosterItem(param1:RosterItemVO) : void
      {
         var _loc2_:Object = this._1738367038rosterItem;
         if(_loc2_ !== param1)
         {
            this._1738367038rosterItem = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rosterItem",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rosterItem() : RosterItemVO
      {
         return this._1738367038rosterItem;
      }
   }
}

