package org.swizframework.utils.chain
{
   public interface IChainStep
   {
      
      function get chain() : IChain;
      
      function set chain(param1:IChain) : void;
      
      function get isComplete() : Boolean;
      
      function complete() : void;
      
      function error() : void;
   }
}

