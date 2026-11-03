package com.riotgames.platform.gameclient.controllers.game
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ArrowedAlertController implements IEventDispatcher
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _activeAlert:ArrowedAlertParameters = null;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ArrowedAlertController()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function okPressed() : void
      {
         var _loc1_:Function = this.activeAlert.closeCallback;
         this.hideAlert();
         if(_loc1_ != null)
         {
            _loc1_();
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function set activeAlert(param1:ArrowedAlertParameters) : void
      {
         var _loc2_:Object = this.activeAlert;
         if(_loc2_ !== param1)
         {
            this._1079276042activeAlert = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"activeAlert",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      private function set _1079276042activeAlert(param1:ArrowedAlertParameters) : void
      {
         this._activeAlert = param1;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function get activeAlert() : ArrowedAlertParameters
      {
         return this._activeAlert;
      }
      
      public function hideAlert() : void
      {
         if(this.activeAlert != null)
         {
            this.activeAlert = null;
         }
      }
      
      public function showAlert(param1:ArrowedAlertParameters) : void
      {
         this.hideAlert();
         this.logger.debug("Showing new Arrowed Alert: message: " + param1.message);
         this.activeAlert = param1;
      }
   }
}

