package org.swizframework.utils.async
{
   import mx.rpc.IResponder;
   
   public interface IAsynchronousOperation
   {
      
      function addResponder(param1:IResponder) : void;
      
      function complete(param1:Object) : void;
      
      function fail(param1:Object) : void;
   }
}

