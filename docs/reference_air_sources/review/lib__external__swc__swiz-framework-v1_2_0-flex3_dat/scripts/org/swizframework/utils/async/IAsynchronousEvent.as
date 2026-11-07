package org.swizframework.utils.async
{
   import org.swizframework.utils.chain.IAsyncChainStep;
   
   public interface IAsynchronousEvent
   {
      
      function get step() : IAsyncChainStep;
      
      function set step(param1:IAsyncChainStep) : void;
   }
}

