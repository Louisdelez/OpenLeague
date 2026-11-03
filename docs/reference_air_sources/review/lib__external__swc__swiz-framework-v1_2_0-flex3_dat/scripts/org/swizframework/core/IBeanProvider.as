package org.swizframework.core
{
   import flash.system.ApplicationDomain;
   
   public interface IBeanProvider
   {
      
      function get beans() : Array;
      
      function addBean(param1:Bean) : void;
      
      function removeBean(param1:Bean) : void;
      
      function initialize(param1:ApplicationDomain) : void;
   }
}

