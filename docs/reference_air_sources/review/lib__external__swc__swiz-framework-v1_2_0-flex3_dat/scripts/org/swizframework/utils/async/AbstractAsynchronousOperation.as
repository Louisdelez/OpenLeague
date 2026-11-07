package org.swizframework.utils.async
{
   import mx.rpc.IResponder;
   
   public class AbstractAsynchronousOperation
   {
      
      protected var concluded:Boolean = false;
      
      [ArrayElementType("mx.rpc.IResponder")]
      protected var responders:Array = [];
      
      public function AbstractAsynchronousOperation()
      {
         super();
      }
      
      public function addResponder(responder:IResponder) : void
      {
         this.responders.push(responder);
      }
      
      public function complete(data:Object) : void
      {
         var responder:IResponder = null;
         if(!this.concluded)
         {
            for each(responder in this.responders)
            {
               responder.result(data);
            }
            this.concluded = true;
         }
      }
      
      public function fail(info:Object) : void
      {
         var responder:IResponder = null;
         if(!this.concluded)
         {
            for each(responder in this.responders)
            {
               responder.fault(info);
            }
            this.concluded = true;
         }
      }
   }
}

