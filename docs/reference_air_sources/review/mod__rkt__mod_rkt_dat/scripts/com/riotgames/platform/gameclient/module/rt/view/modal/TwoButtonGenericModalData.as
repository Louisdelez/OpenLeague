package com.riotgames.platform.gameclient.module.rt.view.modal
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class TwoButtonGenericModalData implements IEventDispatcher
   {
      
      private var _2093243301leftButtonLabel:String = "";
      
      private var _606121342leftButtonCallback:Function = null;
      
      private var _954925063message:String = "";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _792590637rightButtonCallback:Function = null;
      
      private var _1990208730rightButtonLabel:String = "";
      
      private var _110371416title:String = "";
      
      private var _961131206callbackProperty:Object = null;
      
      public function TwoButtonGenericModalData()
      {
         super();
      }
      
      public static function InitializeData(param1:TwoButtonGenericModalData, param2:String, param3:String, param4:String = "", param5:Function = null, param6:String = "", param7:Function = null, param8:Object = null) : void
      {
         param1.title = param2;
         param1.message = param3;
         param1.leftButtonLabel = param4;
         param1.leftButtonCallback = param5;
         param1.rightButtonLabel = param6;
         param1.rightButtonCallback = param7;
         param1.callbackProperty = param8;
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
      public function get message() : String
      {
         return this._954925063message;
      }
      
      [Bindable(event="propertyChange")]
      public function get callbackProperty() : Object
      {
         return this._961131206callbackProperty;
      }
      
      public function set leftButtonCallback(param1:Function) : void
      {
         var _loc2_:Object = this._606121342leftButtonCallback;
         if(_loc2_ !== param1)
         {
            this._606121342leftButtonCallback = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftButtonCallback",_loc2_,param1));
         }
      }
      
      public function set rightButtonLabel(param1:String) : void
      {
         var _loc2_:Object = this._1990208730rightButtonLabel;
         if(_loc2_ !== param1)
         {
            this._1990208730rightButtonLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightButtonLabel",_loc2_,param1));
         }
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get rightButtonCallback() : Function
      {
         return this._792590637rightButtonCallback;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftButtonLabel() : String
      {
         return this._2093243301leftButtonLabel;
      }
      
      public function set rightButtonCallback(param1:Function) : void
      {
         var _loc2_:Object = this._792590637rightButtonCallback;
         if(_loc2_ !== param1)
         {
            this._792590637rightButtonCallback = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightButtonCallback",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightButtonLabel() : String
      {
         return this._1990208730rightButtonLabel;
      }
      
      public function set callbackProperty(param1:Object) : void
      {
         var _loc2_:Object = this._961131206callbackProperty;
         if(_loc2_ !== param1)
         {
            this._961131206callbackProperty = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"callbackProperty",_loc2_,param1));
         }
      }
      
      public function set leftButtonLabel(param1:String) : void
      {
         var _loc2_:Object = this._2093243301leftButtonLabel;
         if(_loc2_ !== param1)
         {
            this._2093243301leftButtonLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftButtonLabel",_loc2_,param1));
         }
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftButtonCallback() : Function
      {
         return this._606121342leftButtonCallback;
      }
   }
}

