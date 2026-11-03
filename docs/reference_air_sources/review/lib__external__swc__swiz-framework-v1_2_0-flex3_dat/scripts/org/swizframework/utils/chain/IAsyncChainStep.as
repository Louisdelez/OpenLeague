package org.swizframework.utils.chain
{
   import org.swizframework.utils.async.IAsynchronousOperation;
   
   public interface IAsyncChainStep extends IChainStep
   {
      
      function addAsynchronousOperation(param1:IAsynchronousOperation) : void;
   }
}

