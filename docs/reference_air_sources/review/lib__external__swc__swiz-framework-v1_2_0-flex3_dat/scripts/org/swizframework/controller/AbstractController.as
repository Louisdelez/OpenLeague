package org.swizframework.controller
{
   import flash.events.IEventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import mx.rpc.AsyncToken;
   import org.swizframework.core.IDispatcherAware;
   import org.swizframework.core.ISwiz;
   import org.swizframework.core.ISwizAware;
   import org.swizframework.utils.chain.AsyncCommandChainStep;
   import org.swizframework.utils.chain.CommandChain;
   import org.swizframework.utils.services.SwizResponder;
   import org.swizframework.utils.services.SwizURLRequest;
   
   public class AbstractController implements ISwizAware, IDispatcherAware
   {
      
      public var _swiz:ISwiz;
      
      private var _dispatcher:IEventDispatcher;
      
      public function AbstractController()
      {
         super();
      }
      
      public function set swiz(swiz:ISwiz) : void
      {
         this._swiz = swiz;
      }
      
      public function set dispatcher(dispatcher:IEventDispatcher) : void
      {
         this._dispatcher = dispatcher;
      }
      
      public function get dispatcher() : IEventDispatcher
      {
         return this._dispatcher;
      }
      
      protected function executeServiceCall(call:AsyncToken, resultHandler:Function, faultHandler:Function = null, handlerArgs:Array = null) : AsyncToken
      {
         if(faultHandler == null && this._swiz.config.defaultFaultHandler != null)
         {
            faultHandler = this._swiz.config.defaultFaultHandler;
         }
         call.addResponder(new SwizResponder(resultHandler,faultHandler,handlerArgs));
         return call;
      }
      
      protected function executeURLRequest(request:URLRequest, resultHandler:Function, faultHandler:Function = null, progressHandler:Function = null, httpStatusHandler:Function = null, handlerArgs:Array = null) : URLLoader
      {
         if(faultHandler == null && this._swiz.config.defaultFaultHandler != null)
         {
            faultHandler = this._swiz.config.defaultFaultHandler;
         }
         return new SwizURLRequest(request,resultHandler,faultHandler,progressHandler,httpStatusHandler,handlerArgs).loader;
      }
      
      protected function createCommand(delayedCall:Function, args:Array, resultHandler:Function, faultHandler:Function = null, handlerArgs:Array = null) : AsyncCommandChainStep
      {
         return new AsyncCommandChainStep(delayedCall,args,resultHandler,faultHandler,handlerArgs);
      }
      
      public function createChain(mode:String = "sequence") : CommandChain
      {
         return new CommandChain(mode);
      }
   }
}

