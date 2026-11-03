package com.riotgames.binding
{
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public dynamic class AirLanguageBinding extends EventDispatcher
   {
      
      private var _context:ExtensionContext;
      
      private var _module:ModuleProxy;
      
      private var _error:String;
      
      private var _callbacks:Dictionary = new Dictionary();
      
      private var _asyncTokens:Dictionary = new Dictionary();
      
      private var _asyncEvents:Dictionary = new Dictionary();
      
      public function AirLanguageBinding(param1:String)
      {
         super();
         this._context = ExtensionContext.createExtensionContext(param1,"");
         this._context.addEventListener(StatusEvent.STATUS,this.onStatus);
         var _loc2_:Object = this.callInternal("Help",[]);
         this._module = new ModuleProxy(_loc2_,this);
         this.initializeAsyncEvents(_loc2_);
      }
      
      private function initializeAsyncEvents(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            if("async" in _loc2_)
            {
               this._asyncEvents[_loc2_.async.success] = "success";
               this._asyncEvents[_loc2_.async.failure] = "failure";
               this._asyncEvents[_loc2_.async.cancel] = "cancel";
            }
         }
      }
      
      public function dispose() : void
      {
         this._context.removeEventListener(StatusEvent.STATUS,this.onStatus);
         this._context.dispose();
      }
      
      public function get Module() : ModuleProxy
      {
         return this._module;
      }
      
      internal function get Context() : ExtensionContext
      {
         return this._context;
      }
      
      public function call(param1:String, param2:Array) : *
      {
         var _loc3_:* = this.callInternal(param1,param2);
         this._callbacks = new Dictionary();
         return _loc3_;
      }
      
      private function callInternal(param1:String, param2:Array) : *
      {
         this._error = null;
         this.processParameters(param2);
         var _loc3_:* = this._context.call(param1,this,param2);
         if(this._error != null)
         {
            throw new TypeError(this._error);
         }
         return _loc3_;
      }
      
      private function processParameters(param1:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:uint = 0;
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_ is Function)
            {
               _loc5_ = _loc3_ + 1;
               this._callbacks[_loc5_] = _loc4_;
               param1[_loc3_] = _loc5_;
            }
            _loc3_++;
         }
      }
      
      public function getClassInfo(param1:Object) : Object
      {
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc2_:XML = describeType(param1);
         var _loc3_:Array = new Array();
         if(_loc2_.@isDynamic == "true")
         {
            for(_loc4_ in param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         else
         {
            for each(_loc5_ in _loc2_..variables.@name)
            {
               _loc3_.push(_loc5_.toString());
            }
         }
         return {
            "name":_loc2_.@name.toString(),
            "properties":_loc3_
         };
      }
      
      public function createStructProxy(param1:String, param2:Object) : StructProxy
      {
         return new StructProxy(param2,this._module[param1],this);
      }
      
      public function createObjectProxy(param1:String, param2:uint, param3:Boolean) : ObjectProxy
      {
         var _loc4_:ClassType = param1 != null ? this._module[param1] : null;
         return new ObjectProxy(_loc4_,param2,param3,this);
      }
      
      public function createAsyncToken(param1:uint) : BindingAsyncToken
      {
         var _loc2_:BindingAsyncToken = new BindingAsyncToken(param1);
         this._asyncTokens[param1] = _loc2_;
         return _loc2_;
      }
      
      public function setError(param1:String) : String
      {
         return this._error = param1;
      }
      
      public function dispatchCallback(param1:uint, ... rest) : void
      {
         var _loc3_:Function = this._callbacks[param1];
         if(_loc3_ != null)
         {
            _loc3_.apply(null,rest);
         }
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1.code == "event")
         {
            _loc2_ = this.call("Events",[]);
            for each(_loc3_ in _loc2_)
            {
               this.dispatchEvent(new BindingEvent(_loc3_.name,_loc3_.data));
               if("asyncToken" in _loc3_.data)
               {
                  this.handleAsyncEvent(_loc3_.name,_loc3_.data);
               }
            }
         }
      }
      
      private function handleAsyncEvent(param1:String, param2:Object) : void
      {
         var _loc3_:BindingAsyncToken = this._asyncTokens[param2.asyncToken];
         if(_loc3_ != null)
         {
            switch(this._asyncEvents[param1])
            {
               case "success":
                  _loc3_.NotifySuccess(param2);
                  break;
               case "failure":
                  _loc3_.NotifyFailure(param2.error);
                  break;
               case "cancel":
                  _loc3_.NotifyCancellation();
            }
         }
         delete this._asyncTokens[param2.asyncToken];
      }
   }
}

