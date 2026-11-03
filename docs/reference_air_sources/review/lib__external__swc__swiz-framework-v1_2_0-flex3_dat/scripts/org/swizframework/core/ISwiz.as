package org.swizframework.core
{
   import flash.events.IEventDispatcher;
   import flash.system.ApplicationDomain;
   
   public interface ISwiz
   {
      
      function get catchViews() : Boolean;
      
      function set catchViews(param1:Boolean) : void;
      
      function get dispatcher() : IEventDispatcher;
      
      function set dispatcher(param1:IEventDispatcher) : void;
      
      function get globalDispatcher() : IEventDispatcher;
      
      function set globalDispatcher(param1:IEventDispatcher) : void;
      
      function get domain() : ApplicationDomain;
      
      function set domain(param1:ApplicationDomain) : void;
      
      function get config() : ISwizConfig;
      
      function set config(param1:ISwizConfig) : void;
      
      [ArrayElementType("org.swizframework.core.IBeanProvider")]
      function get beanProviders() : Array;
      
      function set beanProviders(param1:Array) : void;
      
      function get beanFactory() : IBeanFactory;
      
      function set beanFactory(param1:IBeanFactory) : void;
      
      [ArrayElementType("org.swizframework.processors.IProcessor")]
      function get processors() : Array;
      
      function set customProcessors(param1:Array) : void;
      
      function get parentSwiz() : ISwiz;
      
      function set parentSwiz(param1:ISwiz) : void;
      
      [ArrayElementType("org.swizframework.utils.logging.AbstractSwizLoggingTarget")]
      function get loggingTargets() : Array;
      
      function set loggingTargets(param1:Array) : void;
      
      function init() : void;
      
      function tearDown() : void;
      
      function registerWindow(param1:IEventDispatcher, param2:ISwiz = null) : void;
   }
}

