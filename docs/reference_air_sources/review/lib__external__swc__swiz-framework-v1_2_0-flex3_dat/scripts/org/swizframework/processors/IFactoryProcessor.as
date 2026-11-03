package org.swizframework.processors
{
   import org.swizframework.core.IBeanFactory;
   
   public interface IFactoryProcessor extends IProcessor
   {
      
      function setUpFactory(param1:IBeanFactory) : void;
   }
}

