package com.riotgames.platform.gameclient.module.metrics.commands
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class DradisTrackAction extends BasicAction
   {
      
      private static const ENDPOINT:String = "messages";
      
      public var finishedWithLoaderSignal:Signal = new Signal();
      
      private var json:String;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var loader:URLLoader;
      
      private var _hasInitialized:Boolean;
      
      private var endpointURI:String;
      
      public function DradisTrackAction(param1:String, param2:URLLoader, param3:String)
      {
         super(false);
         this.endpointURI = param1;
         this.loader = param2;
         this.json = param3;
      }
      
      protected function buildRequest(param1:URLRequest) : void
      {
         param1.url = this.endpointURI + "/" + ENDPOINT;
         param1.method = URLRequestMethod.POST;
      }
      
      protected function buildRequestHeaders(param1:URLRequest) : void
      {
         var _loc2_:URLRequestHeader = new URLRequestHeader("Content-type","application/json");
         param1.requestHeaders.push(_loc2_);
      }
      
      protected function onError(param1:Object = null) : void
      {
      }
      
      public function getFinishedWithLoaderSignal() : ISignal
      {
         return this.finishedWithLoaderSignal;
      }
      
      private function onLoaderResult(param1:Object = null) : void
      {
         this.removeEventListeners(this.loader);
         this.onResult();
         this.onComplete();
         complete();
         this.finishedWithLoaderSignal.dispatch(this.loader);
         this.loader = null;
      }
      
      private function setupEventListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,this.onLoaderResult);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoaderError);
      }
      
      private function onLoaderError(param1:Object = null) : void
      {
         this.removeEventListeners(this.loader);
         this.onError(param1);
         this.onComplete(param1);
         var _loc2_:Error = new Error(param1);
         err(_loc2_);
      }
      
      protected function onComplete(param1:Object = null) : void
      {
      }
      
      override protected function doInvocation() : void
      {
         this._hasInitialized = false;
         var _loc1_:URLRequest = new URLRequest();
         this.buildRequest(_loc1_);
         this.buildRequestHeaders(_loc1_);
         _loc1_.data = this.json;
         this.setupEventListeners(this.loader);
         this.loader.load(_loc1_);
      }
      
      protected function onResult(param1:Object = null) : void
      {
      }
      
      private function removeEventListeners(param1:IEventDispatcher) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.onLoaderResult);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoaderError);
      }
   }
}

