package org.swizframework.core
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.system.ApplicationDomain;
   import org.swizframework.events.SwizEvent;
   import org.swizframework.processors.DispatcherProcessor;
   import org.swizframework.processors.EventHandlerProcessor;
   import org.swizframework.processors.IProcessor;
   import org.swizframework.processors.InjectProcessor;
   import org.swizframework.processors.PostConstructProcessor;
   import org.swizframework.processors.PreDestroyProcessor;
   import org.swizframework.processors.ProcessorPriority;
   import org.swizframework.processors.SwizInterfaceProcessor;
   import org.swizframework.processors.ViewProcessor;
   import org.swizframework.utils.logging.AbstractSwizLoggingTarget;
   import org.swizframework.utils.logging.SwizLogger;
   
   [ExcludeClass]
   [DefaultProperty("beanProviders")]
   public class Swiz extends EventDispatcher implements ISwiz
   {
      
      protected var logger:SwizLogger = SwizLogger.getLogger(this);
      
      protected var _dispatcher:IEventDispatcher;
      
      protected var _globalDispatcher:IEventDispatcher;
      
      protected var _domain:ApplicationDomain;
      
      protected var _config:ISwizConfig;
      
      protected var _beanFactory:IBeanFactory;
      
      protected var _beanProviders:Array;
      
      protected var _loggingTargets:Array;
      
      protected var _processors:Array = [new InjectProcessor(),new DispatcherProcessor(),new EventHandlerProcessor(),new SwizInterfaceProcessor(),new PostConstructProcessor(),new PreDestroyProcessor(),new ViewProcessor()];
      
      protected var _parentSwiz:ISwiz;
      
      protected var _catchViews:Boolean = true;
      
      public function Swiz(dispatcher:IEventDispatcher = null, config:ISwizConfig = null, beanFactory:IBeanFactory = null, beanProviders:Array = null, customProcessors:Array = null)
      {
         super();
         this.dispatcher = dispatcher;
         this.config = config;
         this.beanFactory = beanFactory;
         this.beanProviders = beanProviders;
         this.customProcessors = customProcessors;
      }
      
      public function get dispatcher() : IEventDispatcher
      {
         return this._dispatcher;
      }
      
      public function set dispatcher(value:IEventDispatcher) : void
      {
         this._dispatcher = value;
         this.logger.info("Swiz dispatcher set to {0}",value);
      }
      
      public function get globalDispatcher() : IEventDispatcher
      {
         return this._globalDispatcher;
      }
      
      public function set globalDispatcher(value:IEventDispatcher) : void
      {
         this._globalDispatcher = value;
         this.logger.info("Swiz global dispatcher set to {0}",value);
      }
      
      public function get domain() : ApplicationDomain
      {
         return this._domain;
      }
      
      public function set domain(value:ApplicationDomain) : void
      {
         this._domain = value;
         this.logger.info("Swiz domain set to {0}",value);
      }
      
      public function get config() : ISwizConfig
      {
         return this._config;
      }
      
      public function set config(value:ISwizConfig) : void
      {
         this._config = value;
      }
      
      public function get beanFactory() : IBeanFactory
      {
         return this._beanFactory;
      }
      
      public function set beanFactory(value:IBeanFactory) : void
      {
         this._beanFactory = value;
      }
      
      [ArrayElementType("org.swizframework.core.IBeanProvider")]
      public function get beanProviders() : Array
      {
         return this._beanProviders;
      }
      
      public function set beanProviders(value:Array) : void
      {
         this._beanProviders = value;
      }
      
      [ArrayElementType("org.swizframework.processors.IProcessor")]
      public function get processors() : Array
      {
         return this._processors;
      }
      
      public function set customProcessors(value:Array) : void
      {
         var processor:IProcessor = null;
         var i:int = 0;
         var found:Boolean = false;
         var j:int = 0;
         if(value != null)
         {
            for(i = 0; i < value.length; i++)
            {
               processor = IProcessor(value[i]);
               if(processor.priority == ProcessorPriority.DEFAULT)
               {
                  this._processors.push(processor);
               }
               else
               {
                  found = false;
                  for(j = 0; j < this._processors.length; j++)
                  {
                     if(IProcessor(this._processors[j]).priority == processor.priority)
                     {
                        this._processors[j] = processor;
                        found = true;
                        break;
                     }
                  }
                  if(!found)
                  {
                     this._processors.push(processor);
                  }
               }
            }
         }
      }
      
      public function get parentSwiz() : ISwiz
      {
         return this._parentSwiz;
      }
      
      public function set parentSwiz(parentSwiz:ISwiz) : void
      {
         this._parentSwiz = parentSwiz;
      }
      
      [ArrayElementType("org.swizframework.utils.logging.AbstractSwizLoggingTarget")]
      public function get loggingTargets() : Array
      {
         return this._loggingTargets;
      }
      
      public function set loggingTargets(value:Array) : void
      {
         var loggingTarget:AbstractSwizLoggingTarget = null;
         this._loggingTargets = value;
         for each(loggingTarget in value)
         {
            SwizLogger.addLoggingTarget(loggingTarget);
         }
      }
      
      public function registerWindow(window:IEventDispatcher, windowSwiz:ISwiz = null) : void
      {
         var newSwiz:ISwiz = windowSwiz != null ? windowSwiz : new Swiz(window);
         newSwiz.parentSwiz = this;
         if(windowSwiz == null)
         {
            newSwiz.init();
         }
      }
      
      public function get catchViews() : Boolean
      {
         return this._catchViews;
      }
      
      public function set catchViews(value:Boolean) : void
      {
         this._catchViews = value;
      }
      
      public function init() : void
      {
         SwizManager.addSwiz(this);
         if(this.dispatcher == null)
         {
            this.dispatcher = this;
         }
         if(this.config == null)
         {
            this.config = new SwizConfig();
         }
         if(this.beanFactory == null)
         {
            this.beanFactory = new BeanFactory();
         }
         this.dispatchSwizCreatedEvent();
         if(this.parentSwiz != null)
         {
            this._beanFactory.parentBeanFactory = this._parentSwiz.beanFactory;
            if(this.domain == null)
            {
               this.domain = this.parentSwiz.domain;
            }
            this.globalDispatcher = this.parentSwiz.globalDispatcher;
            this.config.eventPackages = this.config.eventPackages.concat(this._parentSwiz.config.eventPackages);
            this.config.viewPackages = this.config.viewPackages.concat(this._parentSwiz.config.viewPackages);
         }
         if(this.domain == null)
         {
            this.domain = ApplicationDomain.currentDomain;
         }
         if(this.globalDispatcher == null)
         {
            this.globalDispatcher = this.dispatcher;
         }
         this.constructProviders();
         this.initializeProcessors();
         this.beanFactory.setUp(this);
         this.logger.info("Swiz initialized");
      }
      
      public function tearDown() : void
      {
         SwizManager.tearDownAllWiredViewsForSwizInstance(this);
         this.beanFactory.tearDown();
         this.parentSwiz = null;
         SwizManager.removeSwiz(this);
      }
      
      protected function initializeProcessors() : void
      {
         var processor:IProcessor = null;
         this.processors.sortOn("priority",Array.DESCENDING | Array.NUMERIC);
         for each(processor in this.processors)
         {
            processor.init(this);
         }
         this.logger.debug("Processors initialized");
      }
      
      protected function constructProviders() : void
      {
         var providerClass:Class = null;
         var providerInst:IBeanProvider = null;
         if(this.beanProviders == null)
         {
            return;
         }
         for(var i:int = 0; i < this.beanProviders.length; i++)
         {
            if(this.beanProviders[i] is Class)
            {
               providerClass = this.beanProviders[i] as Class;
               providerInst = new providerClass();
               this.beanProviders[i] = providerInst;
            }
            else
            {
               providerInst = this.beanProviders[i];
            }
            providerInst.initialize(this.domain);
         }
      }
      
      protected function dispatchSwizCreatedEvent() : void
      {
         this.dispatcher.dispatchEvent(new SwizEvent(SwizEvent.CREATED,this));
         this.dispatcher.addEventListener(SwizEvent.CREATED,this.handleSwizCreatedEvent);
         this.logger.info("Dispatched Swiz Created Event to find parent");
      }
      
      protected function handleSwizCreatedEvent(event:SwizEvent) : void
      {
         if(event.swiz != null && event.swiz.parentSwiz == null)
         {
            event.swiz.parentSwiz = this;
         }
         this.logger.info("Received SwizCreationEvent, set self to parent.");
      }
   }
}

