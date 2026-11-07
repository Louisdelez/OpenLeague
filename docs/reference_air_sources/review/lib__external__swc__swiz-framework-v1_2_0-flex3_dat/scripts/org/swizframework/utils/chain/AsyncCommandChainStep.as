package org.swizframework.utils.chain
{
   import mx.rpc.AsyncToken;
   import mx.rpc.IResponder;
   
   public class AsyncCommandChainStep extends CommandChainStep implements IResponder
   {
      
      protected var asyncMethod:Function;
      
      protected var asyncMethodArgs:Array;
      
      protected var resultHandler:Function;
      
      protected var faultHandler:Function;
      
      protected var handlerArgs:Array;
      
      public function AsyncCommandChainStep(asyncMethod:Function, asyncMethodArgs:Array = null, resultHandler:Function = null, faultHandler:Function = null, handlerArgs:Array = null)
      {
         super();
         this.asyncMethodArgs = asyncMethodArgs;
         this.asyncMethod = asyncMethod;
         this.resultHandler = resultHandler;
         this.faultHandler = faultHandler;
         this.handlerArgs = handlerArgs;
      }
      
      override public function execute() : void
      {
         var token:AsyncToken = null;
         if(this.asyncMethodArgs != null)
         {
            token = this.asyncMethod.apply(null,this.asyncMethodArgs);
         }
         else
         {
            token = this.asyncMethod();
         }
         token.addResponder(this);
      }
      
      override public function doProceed() : void
      {
         this.execute();
      }
      
      public function result(data:Object) : void
      {
         if(this.resultHandler != null)
         {
            if(this.handlerArgs == null)
            {
               this.resultHandler(data);
            }
            else
            {
               this.resultHandler.apply(this,[data].concat(this.handlerArgs));
            }
         }
         complete();
      }
      
      public function fault(info:Object) : void
      {
         if(this.faultHandler != null)
         {
            if(this.handlerArgs == null)
            {
               this.faultHandler(info);
            }
            else
            {
               try
               {
                  this.faultHandler(info);
               }
               catch(e:Error)
               {
                  faultHandler.apply(null,[info].concat(handlerArgs));
               }
            }
         }
         error();
      }
   }
}

