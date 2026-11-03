package org.swizframework.processors
{
   import org.swizframework.core.Bean;
   
   public interface IBeanProcessor extends IProcessor
   {
      
      function setUpBean(param1:Bean) : void;
      
      function tearDownBean(param1:Bean) : void;
   }
}

