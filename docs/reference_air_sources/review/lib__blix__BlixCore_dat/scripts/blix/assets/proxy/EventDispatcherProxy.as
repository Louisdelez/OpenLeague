package blix.assets.proxy
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   
   [Event(name="deactivate",type="flash.events.Event")]
   [Event(name="activate",type="flash.events.Event")]
   public class EventDispatcherProxy implements IEventDispatcher
   {
      
      private static const USE_CAPTURE_TRUE:uint = 1;
      
      private static const USE_CAPTURE_FALSE:uint = 2;
      
      private var _dispatcher:IEventDispatcher;
      
      private var _targetDispatcher:IEventDispatcher;
      
      private var typeDict:Dictionary = new Dictionary();
      
      public function EventDispatcherProxy(param1:IEventDispatcher = null)
      {
         super();
         this._dispatcher = new EventDispatcher(param1);
      }
      
      public function setDispatcher(param1:IEventDispatcher) : void
      {
         if(this._targetDispatcher == param1)
         {
            return;
         }
         if(this._targetDispatcher != null)
         {
            this.removeAllListenersFromDispatcher();
         }
         this._targetDispatcher = param1;
         if(this._targetDispatcher != null)
         {
            this.addAllListenersToDispatcher();
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(this._dispatcher == null)
         {
            return;
         }
         this.typeDict[param1] |= param3 ? USE_CAPTURE_TRUE : USE_CAPTURE_FALSE;
         if(this._targetDispatcher != null)
         {
            this._targetDispatcher.addEventListener(param1,this._dispatcher.dispatchEvent,param3);
         }
         this._dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(this._dispatcher == null)
         {
            return;
         }
         this.typeDict[param1] ^= param3 ? USE_CAPTURE_TRUE : USE_CAPTURE_FALSE;
         if(this._targetDispatcher != null)
         {
            this._targetDispatcher.removeEventListener(param1,this._dispatcher.dispatchEvent,param3);
         }
         this._dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         if(this._targetDispatcher != null)
         {
            return this._targetDispatcher.willTrigger(param1);
         }
         return this._dispatcher.willTrigger(param1);
      }
      
      public function removeAllListeners() : void
      {
         this.removeAllListenersFromDispatcher();
         this._dispatcher = new EventDispatcher(this);
      }
      
      protected function removeAllListenersFromDispatcher() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         if(this._targetDispatcher != null)
         {
            for(_loc1_ in this.typeDict)
            {
               _loc2_ = uint(this.typeDict[_loc1_]);
               if(Boolean(_loc2_ & USE_CAPTURE_TRUE))
               {
                  this._targetDispatcher.removeEventListener(_loc1_,this._dispatcher.dispatchEvent,true);
               }
               if(Boolean(_loc2_ & USE_CAPTURE_FALSE))
               {
                  this._targetDispatcher.removeEventListener(_loc1_,this._dispatcher.dispatchEvent,false);
               }
            }
         }
      }
      
      protected function addAllListenersToDispatcher() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         if(this._targetDispatcher != null && this._dispatcher != null)
         {
            for(_loc1_ in this.typeDict)
            {
               _loc2_ = uint(this.typeDict[_loc1_]);
               if(Boolean(_loc2_ & USE_CAPTURE_TRUE))
               {
                  this._targetDispatcher.addEventListener(_loc1_,this._dispatcher.dispatchEvent,true);
               }
               if(Boolean(_loc2_ & USE_CAPTURE_FALSE))
               {
                  this._targetDispatcher.addEventListener(_loc1_,this._dispatcher.dispatchEvent,false);
               }
            }
         }
      }
      
      public function destroy() : void
      {
         this.removeAllListenersFromDispatcher();
         this._targetDispatcher = null;
         this._dispatcher = null;
      }
   }
}

