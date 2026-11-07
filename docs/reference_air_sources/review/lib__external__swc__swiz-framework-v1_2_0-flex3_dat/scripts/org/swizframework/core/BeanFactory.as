package org.swizframework.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.EventPhase;
   import flash.system.ApplicationDomain;
   import flash.utils.getQualifiedClassName;
   import org.swizframework.events.BeanEvent;
   import org.swizframework.events.SwizEvent;
   import org.swizframework.processors.IBeanProcessor;
   import org.swizframework.processors.IFactoryProcessor;
   import org.swizframework.processors.IMetadataProcessor;
   import org.swizframework.processors.IProcessor;
   import org.swizframework.reflection.TypeCache;
   import org.swizframework.utils.ModuleTypeUtil;
   import org.swizframework.utils.logging.SwizLogger;
   
   public class BeanFactory extends EventDispatcher implements IBeanFactory
   {
      
      protected var logger:SwizLogger = SwizLogger.getLogger(this);
      
      protected const ignoredClasses:RegExp = /^mx\.|^spark\.|^flash\.|^fl\.|__/;
      
      protected var swiz:ISwiz;
      
      protected var _parentBeanFactory:IBeanFactory;
      
      protected var _beans:Array = [];
      
      protected var removedDisplayObjects:Array = [];
      
      protected var isListeningForEnterFrame:Boolean = false;
      
      public var waitForSetup:Boolean = false;
      
      public function BeanFactory()
      {
         super();
      }
      
      public static function constructBean(obj:*, name:String, domain:ApplicationDomain) : Bean
      {
         var bean:Bean = null;
         if(obj is Bean)
         {
            bean = Bean(obj);
         }
         else
         {
            bean = new Bean();
            bean.source = obj;
         }
         bean.name = bean.name || name;
         bean.typeDescriptor = TypeCache.getTypeDescriptor(bean.type,domain);
         return bean;
      }
      
      public function get beans() : Array
      {
         return this._beans;
      }
      
      public function setUp(swiz:ISwiz) : void
      {
         var beanProvider:IBeanProvider = null;
         this.swiz = swiz;
         swiz.dispatcher.addEventListener(BeanEvent.ADD_BEAN,this.handleBeanEvent);
         swiz.dispatcher.addEventListener(BeanEvent.SET_UP_BEAN,this.handleBeanEvent);
         swiz.dispatcher.addEventListener(BeanEvent.TEAR_DOWN_BEAN,this.handleBeanEvent);
         swiz.dispatcher.addEventListener(BeanEvent.REMOVE_BEAN,this.handleBeanEvent);
         for each(beanProvider in swiz.beanProviders)
         {
            this.addBeanProvider(beanProvider,false);
         }
         this.runFactoryProcessors();
         this.completeBeanFactorySetup();
      }
      
      public function completeBeanFactorySetup() : void
      {
         var bean:Bean = null;
         if(this.waitForSetup)
         {
            return;
         }
         this.logger.info("BeanFactory completing setup");
         for each(bean in this.beans)
         {
            if(!(bean is Prototype))
            {
               this.setUpBean(bean);
            }
         }
         this.logger.info("BeanFactory initialized");
         if(this.swiz.catchViews == false)
         {
            return;
         }
         this.swiz.dispatcher.addEventListener(this.swiz.config.setUpEventType,this.setUpEventHandler,this.swiz.config.setUpEventPhase == EventPhase.CAPTURING_PHASE,this.swiz.config.setUpEventPriority,true);
         this.logger.debug("Set up event type set to {0}",this.swiz.config.setUpEventType);
         this.logger.debug("Set up event phase set to {0}",this.swiz.config.setUpEventPhase == EventPhase.CAPTURING_PHASE ? "capture phase" : "bubbling phase");
         this.logger.debug("Set up event priority set to {0}",this.swiz.config.setUpEventPriority);
         if("systemManager" in this.swiz.dispatcher && this.swiz.dispatcher["systemManager"] != null && !this.swiz.dispatcher["systemManager"].hasEventListener(this.swiz.config.setUpEventType))
         {
            this.swiz.dispatcher["systemManager"].addEventListener(this.swiz.config.setUpEventType,this.setUpEventHandlerSysMgr,this.swiz.config.setUpEventPhase == EventPhase.CAPTURING_PHASE,this.swiz.config.setUpEventPriority,true);
            this.swiz.dispatcher["systemManager"].addEventListener(this.swiz.config.tearDownEventType,this.tearDownEventHandler,this.swiz.config.tearDownEventPhase == EventPhase.CAPTURING_PHASE,this.swiz.config.tearDownEventPriority,true);
         }
         this.swiz.dispatcher.addEventListener(this.swiz.config.tearDownEventType,this.tearDownEventHandler,this.swiz.config.tearDownEventPhase == EventPhase.CAPTURING_PHASE,this.swiz.config.tearDownEventPriority,true);
         this.logger.debug("Tear down event type set to {0}",this.swiz.config.tearDownEventType);
         this.logger.debug("Tear down event phase set to {0}",this.swiz.config.tearDownEventPhase == EventPhase.CAPTURING_PHASE ? "capture phase" : "bubbling phase");
         this.logger.debug("Tear down event priority set to {0}",this.swiz.config.tearDownEventPriority);
         if(Boolean(this.swiz.dispatcher))
         {
            if(this.swiz.dispatcher is DisplayObject)
            {
               SwizManager.setUp(DisplayObject(this.swiz.dispatcher));
            }
            else
            {
               this.setUpBean(this.createBeanFromSource(this.swiz.dispatcher));
            }
         }
         this.swiz.dispatcher.dispatchEvent(new SwizEvent(SwizEvent.LOAD_COMPLETE,this.swiz));
      }
      
      public function tearDown() : void
      {
         var beanProvider:IBeanProvider = null;
         for each(beanProvider in this.swiz.beanProviders)
         {
            this.removeBeanProvider(beanProvider);
         }
         this.swiz.dispatcher.removeEventListener(BeanEvent.ADD_BEAN,this.handleBeanEvent);
         this.swiz.dispatcher.removeEventListener(BeanEvent.SET_UP_BEAN,this.handleBeanEvent);
         this.swiz.dispatcher.removeEventListener(BeanEvent.TEAR_DOWN_BEAN,this.handleBeanEvent);
         this.swiz.dispatcher.removeEventListener(BeanEvent.REMOVE_BEAN,this.handleBeanEvent);
         this.swiz.dispatcher.removeEventListener(this.swiz.config.setUpEventType,this.setUpEventHandler,this.swiz.config.setUpEventPhase == EventPhase.CAPTURING_PHASE);
         this.swiz.dispatcher.removeEventListener(this.swiz.config.tearDownEventType,this.tearDownEventHandler,this.swiz.config.tearDownEventPhase == EventPhase.CAPTURING_PHASE);
         if("systemManager" in this.swiz.dispatcher && this.swiz.dispatcher["systemManager"] != null && Boolean(this.swiz.dispatcher["systemManager"].hasEventListener(this.swiz.config.setUpEventType)))
         {
            this.swiz.dispatcher["systemManager"].removeEventListener(this.swiz.config.setUpEventType,this.setUpEventHandlerSysMgr,this.swiz.config.setUpEventPhase == EventPhase.CAPTURING_PHASE);
            this.swiz.dispatcher["systemManager"].removeEventListener(this.swiz.config.tearDownEventType,this.tearDownEventHandler,this.swiz.config.tearDownEventPhase == EventPhase.CAPTURING_PHASE);
         }
         this.logger.info("BeanFactory torn down");
      }
      
      protected function createBeanFromSource(source:Object, beanName:String = null) : Bean
      {
         var bean:Bean = this.getBeanForSource(source);
         if(bean == null)
         {
            bean = constructBean(source,beanName,this.swiz.domain);
         }
         return bean;
      }
      
      protected function getBeanForSource(source:Object) : Bean
      {
         var bean:Bean = null;
         for each(bean in this.beans)
         {
            if(!(bean is Prototype && (Prototype(bean).singleton == false || Prototype(bean).initialized == false)))
            {
               if(bean.source === source)
               {
                  return bean;
               }
            }
         }
         return null;
      }
      
      public function addBeanProvider(beanProvider:IBeanProvider, autoSetUpBeans:Boolean = true) : void
      {
         var bean:Bean = null;
         for each(bean in beanProvider.beans)
         {
            this.addBean(bean,false);
         }
         if(autoSetUpBeans)
         {
            for each(bean in beanProvider.beans)
            {
               if(!(bean is Prototype))
               {
                  this.setUpBean(bean);
               }
            }
         }
      }
      
      public function addBean(bean:Bean, autoSetUpBean:Boolean = true) : Bean
      {
         bean.beanFactory = this;
         this.beans.push(bean);
         if(autoSetUpBean && !(bean is Prototype))
         {
            this.setUpBean(bean);
         }
         return bean;
      }
      
      public function removeBeanProvider(beanProvider:IBeanProvider) : void
      {
         var bean:Bean = null;
         for each(bean in beanProvider.beans)
         {
            this.removeBean(bean);
         }
      }
      
      public function removeBean(bean:Bean) : void
      {
         if(this.beans.indexOf(bean) > -1)
         {
            this.beans.splice(this.beans.indexOf(bean),1);
         }
         this.tearDownBean(bean);
         bean.beanFactory = null;
         bean.typeDescriptor = null;
         bean.source = null;
         bean = null;
      }
      
      public function getBeanByName(name:String) : Bean
      {
         var bean:Bean = null;
         var foundBean:Bean = null;
         for each(bean in this.beans)
         {
            if(bean.name == name)
            {
               foundBean = bean;
               break;
            }
         }
         if(foundBean != null && !(foundBean is Prototype) && !foundBean.initialized)
         {
            this.setUpBean(foundBean);
         }
         else if(foundBean == null && this.parentBeanFactory != null)
         {
            foundBean = this.parentBeanFactory.getBeanByName(name);
         }
         return foundBean;
      }
      
      public function getBeanByType(beanType:Class) : Bean
      {
         var foundBean:Bean = null;
         var bean:Bean = null;
         var beanTypeName:String = getQualifiedClassName(beanType);
         for each(bean in this.beans)
         {
            if(bean.typeDescriptor.satisfiesType(beanTypeName))
            {
               if(foundBean != null)
               {
                  throw new Error("AmbiguousReferenceError. More than one bean was found with type: " + beanType);
               }
               foundBean = bean;
            }
         }
         if(foundBean != null && !(foundBean is Prototype) && !foundBean.initialized)
         {
            this.setUpBean(foundBean);
         }
         else if(foundBean == null && this.parentBeanFactory != null)
         {
            foundBean = this.parentBeanFactory.getBeanByType(beanType);
         }
         return foundBean;
      }
      
      public function set parentBeanFactory(beanFactory:IBeanFactory) : void
      {
         this._parentBeanFactory = beanFactory;
      }
      
      public function get parentBeanFactory() : IBeanFactory
      {
         return this._parentBeanFactory;
      }
      
      public function runFactoryProcessors() : void
      {
         var processor:IProcessor = null;
         for each(processor in this.swiz.processors)
         {
            if(processor is IFactoryProcessor)
            {
               IFactoryProcessor(processor).setUpFactory(this);
            }
         }
      }
      
      public function setUpBean(bean:Bean) : void
      {
         var processor:IProcessor = null;
         var metadataProcessor:IMetadataProcessor = null;
         var metadataTags:Array = null;
         var metadataName:String = null;
         if(bean.initialized)
         {
            return;
         }
         this.logger.debug("BeanFactory::setUpBean( {0} )",bean);
         bean.initialized = true;
         for each(processor in this.swiz.processors)
         {
            if(!(processor is IFactoryProcessor))
            {
               if(processor is IMetadataProcessor)
               {
                  metadataProcessor = IMetadataProcessor(processor);
                  metadataTags = [];
                  for each(metadataName in metadataProcessor.metadataNames)
                  {
                     metadataTags = metadataTags.concat(bean.typeDescriptor.getMetadataTagsByName(metadataName));
                  }
                  metadataProcessor.setUpMetadataTags(metadataTags,bean);
               }
               if(processor is IBeanProcessor)
               {
                  IBeanProcessor(processor).setUpBean(bean);
               }
            }
         }
      }
      
      public function tearDownBean(bean:Bean) : void
      {
         var processor:IProcessor = null;
         var metadataProcessor:IMetadataProcessor = null;
         var metadataTags:Array = null;
         var metadataName:String = null;
         for each(processor in this.swiz.processors)
         {
            if(!(processor is IFactoryProcessor))
            {
               if(processor is IMetadataProcessor)
               {
                  metadataProcessor = IMetadataProcessor(processor);
                  metadataTags = [];
                  for each(metadataName in metadataProcessor.metadataNames)
                  {
                     metadataTags = metadataTags.concat(bean.typeDescriptor.getMetadataTagsByName(metadataName));
                  }
                  metadataProcessor.tearDownMetadataTags(metadataTags,bean);
               }
               if(processor is IBeanProcessor)
               {
                  IBeanProcessor(processor).tearDownBean(bean);
               }
            }
         }
         bean.initialized = false;
      }
      
      protected function handleBeanEvent(event:BeanEvent) : void
      {
         var existingBean:Bean = this.getBeanForSource(event.source);
         switch(event.type)
         {
            case BeanEvent.ADD_BEAN:
               if(Boolean(existingBean))
               {
                  this.logger.warn("{0} already exists as a bean. Ignoring ADD_BEAN request.",event.source.toString());
               }
               else
               {
                  this.addBean(constructBean(event.source,event.beanName,this.swiz.domain));
               }
               break;
            case BeanEvent.SET_UP_BEAN:
               if(Boolean(existingBean))
               {
                  if(existingBean.initialized)
                  {
                     this.logger.warn("{0} is already set up as a bean. Ignoring SET_UP_BEAN request.",event.source.toString());
                  }
                  else
                  {
                     this.setUpBean(existingBean);
                  }
               }
               else
               {
                  this.setUpBean(constructBean(event.source,event.beanName,this.swiz.domain));
               }
               break;
            case BeanEvent.TEAR_DOWN_BEAN:
               if(Boolean(existingBean))
               {
                  this.tearDownBean(existingBean);
               }
               else
               {
                  this.tearDownBean(constructBean(event.source,null,this.swiz.domain));
               }
               break;
            case BeanEvent.REMOVE_BEAN:
               if(Boolean(existingBean))
               {
                  this.removeBean(existingBean);
               }
               else
               {
                  this.logger.warn("Could not find bean with {0} as its source. Ignoring REMOVE_BEAN request.",event.source.toString());
               }
         }
      }
      
      protected function isPotentialInjectionTarget(instance:Object) : Boolean
      {
         var viewPackage:String = null;
         var className:String = getQualifiedClassName(instance);
         if(!this.swiz.domain.hasDefinition(className))
         {
            return false;
         }
         if(this.swiz.config.viewPackages.length > 0)
         {
            for each(viewPackage in this.swiz.config.viewPackages)
            {
               if(className.indexOf(viewPackage) == 0 && className.indexOf("__") < 0)
               {
                  return true;
               }
            }
            return false;
         }
         return !this.ignoredClasses.test(className);
      }
      
      protected function setUpEventHandler(event:Event) : void
      {
         var i:int = 0;
         if(event.target is ISetUpValidator && !ISetUpValidator(event.target).allowSetUp())
         {
            return;
         }
         if(this.isPotentialInjectionTarget(event.target))
         {
            i = this.removedDisplayObjects.indexOf(event.target);
            if(i != -1)
            {
               this.removedDisplayObjects.splice(i,1);
               if(this.removedDisplayObjects.length == 0)
               {
                  this.swiz.dispatcher.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
                  this.isListeningForEnterFrame = false;
               }
               return;
            }
            SwizManager.setUp(DisplayObject(event.target));
         }
      }
      
      protected function setUpEventHandlerSysMgr(event:Event) : void
      {
         if(!Sprite(this.swiz.dispatcher).contains(DisplayObject(event.target)))
         {
            this.setUpEventHandler(event);
         }
      }
      
      protected function tearDownEventHandler(event:Event) : void
      {
         if(event.target is ITearDownValidator && !ITearDownValidator(event.target).allowTearDown())
         {
            return;
         }
         if(!this.isPotentialInjectionTarget(event.target))
         {
            return;
         }
         if(Boolean(SwizManager.wiredViews[event.target]))
         {
            this.addRemovedDisplayObject(DisplayObject(event.target));
         }
         if(event.target is ModuleTypeUtil.MODULE_TYPE)
         {
            this.addRemovedDisplayObject(DisplayObject(event.target));
         }
      }
      
      protected function addRemovedDisplayObject(displayObject:DisplayObject) : void
      {
         if(this.removedDisplayObjects.indexOf(displayObject) == -1)
         {
            this.removedDisplayObjects.push(displayObject);
         }
         if(!this.isListeningForEnterFrame)
         {
            this.swiz.dispatcher.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler,false,0,true);
            this.isListeningForEnterFrame = true;
         }
      }
      
      protected function enterFrameHandler(event:Event) : void
      {
         this.swiz.dispatcher.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this.isListeningForEnterFrame = false;
         var displayObject:DisplayObject = DisplayObject(this.removedDisplayObjects.shift());
         while(Boolean(displayObject))
         {
            SwizManager.tearDown(displayObject);
            displayObject = DisplayObject(this.removedDisplayObjects.shift());
         }
      }
   }
}

