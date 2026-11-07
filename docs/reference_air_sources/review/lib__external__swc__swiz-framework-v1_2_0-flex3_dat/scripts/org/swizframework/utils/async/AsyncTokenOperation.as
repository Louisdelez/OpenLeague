package org.swizframework.utils.async
{
   import mx.rpc.AsyncToken;
   import org.swizframework.utils.services.SwizResponder;
   
   public class AsyncTokenOperation extends AbstractAsynchronousOperation implements IAsynchronousOperation
   {
      
      public function AsyncTokenOperation(token:AsyncToken)
      {
         super();
         token.addResponder(new SwizResponder(this.resultHandler,this.faultHandler));
      }
      
      protected function resultHandler(data:Object) : void
      {
         complete(data);
      }
      
      protected function faultHandler(info:Object) : void
      {
         fail(info);
      }
   }
}

