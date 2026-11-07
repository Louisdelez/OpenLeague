package com.riotgames.pvpnet.system.logging
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.LogEvent;
   import mx.logging.LogEventLevel;
   import mx.logging.targets.LineFormattedTarget;
   
   public class MemoryTarget extends LineFormattedTarget implements IEventDispatcher
   {
      
      private var _messageLimit:int;
      
      private var _messageBuffer:ArrayCollection = new ArrayCollection();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MemoryTarget()
      {
         super();
      }
      
      public function get messageLimit() : int
      {
         return this._messageLimit;
      }
      
      public function set messageLimit(param1:int) : void
      {
         this._messageLimit = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get messageBuffer() : ArrayCollection
      {
         return this._messageBuffer;
      }
      
      private function set _2043207897messageBuffer(param1:ArrayCollection) : void
      {
         this._messageBuffer = param1;
      }
      
      override public function logEvent(param1:LogEvent) : void
      {
         var _loc7_:Date = null;
         var _loc2_:String = "";
         if(Boolean(includeDate) || Boolean(includeTime))
         {
            _loc7_ = new Date();
            if(includeDate)
            {
               _loc2_ = Number(_loc7_.getMonth() + 1).toString() + "/" + _loc7_.getDate().toString() + "/" + _loc7_.getFullYear() + fieldSeparator;
            }
            if(includeTime)
            {
               _loc2_ += this.padTime(_loc7_.getHours()) + ":" + this.padTime(_loc7_.getMinutes()) + ":" + this.padTime(_loc7_.getSeconds()) + "." + this.padTime(_loc7_.getMilliseconds(),true) + fieldSeparator;
            }
         }
         var _loc3_:String = "";
         if(includeLevel)
         {
            _loc3_ = "[" + LogEvent.getLevelString(param1.level) + "]" + fieldSeparator;
         }
         var _loc4_:String = includeCategory ? ILogger(param1.target).category + fieldSeparator : "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         switch(param1.level)
         {
            case LogEventLevel.INFO:
               _loc5_ = "<b>";
               _loc6_ = "</b>";
               break;
            case LogEventLevel.WARN:
               _loc5_ = "<font color=\'#FF6600\'>";
               _loc6_ = "</font>";
               break;
            case LogEventLevel.ERROR:
               _loc5_ = "<font color=\'#FF0000\'>";
               _loc6_ = "</font>";
               break;
            case LogEventLevel.FATAL:
               _loc5_ = "<font color=\'#FF0000\'><b>";
               _loc6_ = "</b></font>";
         }
         this.internalLog(_loc5_ + _loc2_ + _loc3_ + _loc4_ + param1.message + _loc6_);
      }
      
      private function padTime(param1:Number, param2:Boolean = false) : String
      {
         if(param2)
         {
            if(param1 < 10)
            {
               return "00" + param1.toString();
            }
            if(param1 < 100)
            {
               return "0" + param1.toString();
            }
            return param1.toString();
         }
         return param1 > 9 ? param1.toString() : "0" + param1.toString();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function internalLog(param1:String) : void
      {
         if(this._messageLimit > 0 && this._messageBuffer.length >= this._messageLimit)
         {
            this._messageBuffer.removeItemAt(0);
         }
         this._messageBuffer.addItem(param1);
      }
      
      public function set messageBuffer(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.messageBuffer;
         if(_loc2_ !== param1)
         {
            this._2043207897messageBuffer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageBuffer",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

