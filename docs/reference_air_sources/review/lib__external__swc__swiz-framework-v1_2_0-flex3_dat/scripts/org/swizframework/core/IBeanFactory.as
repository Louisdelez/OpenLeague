package org.swizframework.core
{
   public interface IBeanFactory
   {
      
      function setUp(param1:ISwiz) : void;
      
      function tearDown() : void;
      
      function setUpBean(param1:Bean) : void;
      
      function addBean(param1:Bean, param2:Boolean = true) : Bean;
      
      function addBeanProvider(param1:IBeanProvider, param2:Boolean = true) : void;
      
      function tearDownBean(param1:Bean) : void;
      
      function removeBean(param1:Bean) : void;
      
      function removeBeanProvider(param1:IBeanProvider) : void;
      
      function get beans() : Array;
      
      function getBeanByName(param1:String) : Bean;
      
      function getBeanByType(param1:Class) : Bean;
      
      function get parentBeanFactory() : IBeanFactory;
      
      function set parentBeanFactory(param1:IBeanFactory) : void;
   }
}

