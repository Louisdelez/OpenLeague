package com.riotgames.platform.gameclient.controllers.game
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ArrowedAlertParameters implements IEventDispatcher
   {
      
      private var _120x:Number;
      
      private var _2004253111modalParent:Boolean = false;
      
      private var _1377687758button:Boolean;
      
      private var _121y:Number;
      
      private var _1079700061closeCallback:Function;
      
      private var _109780401style:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _954925063message:String;
      
      public function ArrowedAlertParameters()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get y() : Number
      {
         return this._121y;
      }
      
      public function set closeCallback(param1:Function) : void
      {
         var _loc2_:Object = this._1079700061closeCallback;
         if(_loc2_ !== param1)
         {
            this._1079700061closeCallback = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"closeCallback",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get message() : String
      {
         return this._954925063message;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get closeCallback() : Function
      {
         return this._1079700061closeCallback;
      }
      
      public function set style(param1:String) : void
      {
         var _loc2_:Object = this._109780401style;
         if(_loc2_ !== param1)
         {
            this._109780401style = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"style",_loc2_,param1));
         }
      }
      
      public function set button(param1:Boolean) : void
      {
         var _loc2_:Object = this._1377687758button;
         if(_loc2_ !== param1)
         {
            this._1377687758button = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"button",_loc2_,param1));
         }
      }
      
      public function set modalParent(param1:Boolean) : void
      {
         var _loc2_:Object = this._2004253111modalParent;
         if(_loc2_ !== param1)
         {
            this._2004253111modalParent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modalParent",_loc2_,param1));
         }
      }
      
      public function set x(param1:Number) : void
      {
         var _loc2_:Object = this._120x;
         if(_loc2_ !== param1)
         {
            this._120x = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"x",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get style() : String
      {
         return this._109780401style;
      }
      
      public function set y(param1:Number) : void
      {
         var _loc2_:Object = this._121y;
         if(_loc2_ !== param1)
         {
            this._121y = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"y",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get x() : Number
      {
         return this._120x;
      }
      
      [Bindable(event="propertyChange")]
      public function get button() : Boolean
      {
         return this._1377687758button;
      }
      
      [Bindable(event="propertyChange")]
      public function get modalParent() : Boolean
      {
         return this._2004253111modalParent;
      }
   }
}

