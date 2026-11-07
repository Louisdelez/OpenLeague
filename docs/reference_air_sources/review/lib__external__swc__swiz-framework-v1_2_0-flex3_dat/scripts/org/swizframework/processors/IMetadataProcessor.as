package org.swizframework.processors
{
   import org.swizframework.core.Bean;
   
   public interface IMetadataProcessor extends IProcessor
   {
      
      function get metadataNames() : Array;
      
      function setUpMetadataTags(param1:Array, param2:Bean) : void;
      
      function tearDownMetadataTags(param1:Array, param2:Bean) : void;
   }
}

