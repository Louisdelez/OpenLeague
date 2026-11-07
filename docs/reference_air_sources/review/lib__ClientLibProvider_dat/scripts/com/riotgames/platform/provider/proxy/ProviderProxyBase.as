package com.riotgames.platform.provider.proxy
{
   import blix.signals.ISignal;
   import blix.signals.SignalPromise;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class ProviderProxyBase implements IProviderProxy
   {
      
      protected var impl:*;
      
      protected var _queueRequests:Boolean = true;
      
      private var _loaded:Boolean = false;
      
      private var _queuedRequests:Vector.<ProxyQueuedRequest> = new Vector.<ProxyQueuedRequest>();
      
      private var _errorFlag:Boolean = false;
      
      protected var _hasRequestedLoad:Boolean = false;
      
      protected var _providerId:String;
      
      private var _signalsDict:Dictionary = new Dictionary();
      
      public function ProviderProxyBase(param1:Class, param2:Boolean = true)
      {
         super();
         this._providerId = getQualifiedClassName(param1);
         ProviderLookup.instance.getSpecificProviderPublished(this._providerId).add(this.providerPublishedHandler);
         ProviderLookup.instance.getSpecificProviderFailed(this._providerId).add(this.providerFailedHandler);
         if(param2)
         {
            this._hasRequestedLoad = true;
            ProviderLookup.instance.requestProvider(this._providerId);
         }
      }
      
      private function providerPublishedHandler(param1:IProvider) : void
      {
         this._setProviderImpl(param1);
      }
      
      private function providerFailedHandler(param1:Error) : void
      {
         this._setProviderError(param1);
      }
      
      final public function get proxyLoaded() : Boolean
      {
         return this._loaded;
      }
      
      protected function _setProviderImpl(param1:IProvider) : void
      {
         var _loc2_:String = null;
         var _loc3_:SignalPromise = null;
         if(param1 == null)
         {
            return;
         }
         this._loaded = true;
         this.impl = param1;
         for(_loc2_ in this._signalsDict)
         {
            _loc3_ = this._signalsDict[_loc2_];
            if(!(this.impl as Object).hasOwnProperty(_loc2_))
            {
               throw new Error("Provider Proxy is requesting a signal that does not exist on the implementation: " + _loc2_);
            }
            _loc3_.setSignalTarget(this.impl[_loc2_]());
         }
         this.processQueuedRequests();
      }
      
      protected function _setProviderError(param1:Error) : void
      {
         this._errorFlag = true;
         this._queuedRequests.length = 0;
      }
      
      public function _proxy_isImplReady() : Boolean
      {
         return this.impl != null;
      }
      
      public function _proxy_isError() : Boolean
      {
         return this._errorFlag;
      }
      
      protected function _invoke(param1:String, param2:Array = null) : *
      {
         var _loc3_:Function = null;
         if(!this._hasRequestedLoad)
         {
            ProviderLookup.instance.requestProvider(this._providerId);
            this._hasRequestedLoad = true;
         }
         if(Boolean(this.impl))
         {
            _loc3_ = this.impl[param1];
            return _loc3_.apply(null,param2);
         }
         if(this._errorFlag)
         {
            return;
         }
         if(this._queueRequests)
         {
            this._queuedRequests.push(new ProxyQueuedRequest(param1,param2,ProxyQueuedRequest.MODE_FUNCTION));
         }
      }
      
      protected function _getSignal(param1:String) : ISignal
      {
         var _loc2_:SignalPromise = null;
         if(!(param1 in this._signalsDict))
         {
            _loc2_ = new SignalPromise();
            if(this.impl != null)
            {
               _loc2_.setSignalTarget(this.impl[param1]());
            }
            this._signalsDict[param1] = _loc2_;
         }
         return this._signalsDict[param1];
      }
      
      protected function _invokeSetter(param1:String, param2:*) : void
      {
         if(Boolean(this.impl))
         {
            this.impl[param1] = param2;
         }
         else
         {
            if(this._errorFlag)
            {
               return;
            }
            if(this._queueRequests)
            {
               this._queuedRequests.push(new ProxyQueuedRequest(param1,[param2],ProxyQueuedRequest.MODE_SETTER));
            }
         }
      }
      
      protected function _invokeGetter(param1:String) : *
      {
         if(Boolean(this.impl))
         {
            return this.impl[param1];
         }
         if(this._errorFlag)
         {
            return;
         }
      }
      
      protected function processQueuedRequests() : void
      {
         var _loc1_:ProxyQueuedRequest = null;
         for each(_loc1_ in this._queuedRequests)
         {
            _loc1_.execute(this.impl);
         }
         this._queuedRequests.length = 0;
      }
   }
}

class ProxyQueuedRequest
{
   
   public static const MODE_FUNCTION:int = 0;
   
   public static const MODE_SETTER:int = 2;
   
   private var mode:int = 0;
   
   private var member:String;
   
   private var args:Array;
   
   public function ProxyQueuedRequest(param1:String, param2:Array, param3:int)
   {
      super();
      this.member = param1;
      this.args = param2;
      this.mode = param3;
   }
   
   public function execute(param1:*) : void
   {
      var _loc2_:* = undefined;
      var _loc3_:Function = null;
      switch(this.mode)
      {
         case MODE_FUNCTION:
            _loc3_ = param1[this.member];
            if(_loc3_ is Function)
            {
               _loc2_ = _loc3_.apply(null,this.args);
               break;
            }
            throw new Error("Invalid Function to call");
            break;
         case MODE_SETTER:
            param1[this.member] = this.args[0];
      }
   }
}
