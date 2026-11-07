package org.swizframework.utils.chain
{
   import flash.events.IEventDispatcher;
   import org.swizframework.core.IDispatcherAware;
   
   public class ChainUtil implements IDispatcherAware
   {
      
      private var _dispatcher:IEventDispatcher;
      
      public function ChainUtil()
      {
         super();
      }
      
      public function set dispatcher(dispatcher:IEventDispatcher) : void
      {
         this._dispatcher = dispatcher;
      }
      
      public function createCommand(delayedCall:Function, args:Array, resultHandler:Function, faultHandler:Function = null, resultHandlerArgs:Array = null) : AsyncCommandChainStep
      {
         return new AsyncCommandChainStep(delayedCall,args,resultHandler,faultHandler,resultHandlerArgs);
      }
      
      public function createChain(mode:String = "sequence") : CommandChain
      {
         return new CommandChain(mode);
      }
   }
}

