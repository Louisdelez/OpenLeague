package org.swizframework.processors
{
   import org.swizframework.core.ISwiz;
   
   public interface IProcessor
   {
      
      function init(param1:ISwiz) : void;
      
      function get priority() : int;
   }
}

