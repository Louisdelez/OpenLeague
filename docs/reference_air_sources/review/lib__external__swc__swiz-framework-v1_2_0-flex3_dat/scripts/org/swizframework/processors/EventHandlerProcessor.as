package org.swizframework.processors
{
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import org.swizframework.core.Bean;
   import org.swizframework.core.SwizConfig;
   import org.swizframework.metadata.EventHandlerMetadataTag;
   import org.swizframework.metadata.EventTypeExpression;
   import org.swizframework.reflection.ClassConstant;
   import org.swizframework.reflection.IMetadataTag;
   import org.swizframework.reflection.TypeCache;
   import org.swizframework.reflection.TypeDescriptor;
   import org.swizframework.utils.event.EventHandler;
   import org.swizframework.utils.logging.SwizLogger;
   
   public class EventHandlerProcessor extends BaseMetadataProcessor
   {
      
      protected static const EVENT_HANDLER:String = "EventHandler";
      
      protected static const MEDIATE:String = "Mediate";
      
      protected var logger:SwizLogger = SwizLogger.getLogger(this);
      
      protected var eventHandlersByEventType:Dictionary = new Dictionary();
      
      protected var eventHandlerClass:Class = EventHandler;
      
      public function EventHandlerProcessor(metadataNames:Array = null)
      {
         super(metadataNames == null ? [EVENT_HANDLER,MEDIATE] : metadataNames,EventHandlerMetadataTag);
      }
      
      override public function get priority() : int
      {
         return ProcessorPriority.EVENT_HANDLER;
      }
      
      override public function setUpMetadataTag(metadataTag:IMetadataTag, bean:Bean) : void
      {
         var expression:EventTypeExpression = null;
         var eventType:String = null;
         var eventHandlerTag:EventHandlerMetadataTag = metadataTag as EventHandlerMetadataTag;
         if(eventHandlerTag.name == MEDIATE)
         {
            this.logger.warn("[Mediate] has been deprecated in favor of [EventHandler]. Please update {0} accordingly.",bean);
         }
         if(this.validateEventHandlerMetadataTag(eventHandlerTag))
         {
            expression = new EventTypeExpression(eventHandlerTag.event,swiz);
            for each(eventType in expression.eventTypes)
            {
               this.addEventHandlerByEventType(eventHandlerTag,bean.source[eventHandlerTag.host.name],expression.eventClass,eventType);
            }
         }
         this.logger.debug("EventHandlerProcessor set up {0} on {1}",metadataTag.toString(),bean.toString());
      }
      
      override public function tearDownMetadataTag(metadataTag:IMetadataTag, bean:Bean) : void
      {
         var eventType:String = null;
         var eventHandlerTag:EventHandlerMetadataTag = metadataTag as EventHandlerMetadataTag;
         var expression:EventTypeExpression = new EventTypeExpression(eventHandlerTag.event,swiz);
         for each(eventType in expression.eventTypes)
         {
            this.removeEventHandlerByEventType(eventHandlerTag,bean.source[eventHandlerTag.host.name],expression.eventClass,eventType);
         }
         this.logger.debug("EventHandlerProcessor tore down {0} on {1}",metadataTag.toString(),bean.toString());
      }
      
      protected function addEventHandlerByEventType(eventHandlerTag:EventHandlerMetadataTag, method:Function, eventClass:Class, eventType:String) : void
      {
         var eventHandler:EventHandler = new this.eventHandlerClass(eventHandlerTag,method,eventClass);
         this.eventHandlersByEventType[eventType] = this.eventHandlersByEventType[eventType] || [];
         this.eventHandlersByEventType[eventType].push(eventHandler);
         var dispatcher:IEventDispatcher = null;
         if(eventHandlerTag.scope == SwizConfig.GLOBAL_DISPATCHER)
         {
            dispatcher = swiz.globalDispatcher;
         }
         else if(eventHandlerTag.scope == SwizConfig.LOCAL_DISPATCHER)
         {
            dispatcher = swiz.dispatcher;
         }
         else
         {
            dispatcher = swiz.config.defaultDispatcher == SwizConfig.LOCAL_DISPATCHER ? swiz.dispatcher : swiz.globalDispatcher;
         }
         dispatcher.addEventListener(eventType,eventHandler.handleEvent,eventHandlerTag.useCapture,eventHandlerTag.priority,true);
         this.logger.debug("EventHandlerProcessor added listener to dispatcher for {0}, {1}",eventType,String(eventHandler.method));
      }
      
      protected function removeEventHandlerByEventType(eventHandlerTag:EventHandlerMetadataTag, method:Function, eventClass:Class, eventType:String) : void
      {
         var eventHandlerIndex:int = 0;
         var eventHandler:EventHandler = null;
         var dispatcher:IEventDispatcher = null;
         if(eventHandlerTag.scope == SwizConfig.GLOBAL_DISPATCHER)
         {
            dispatcher = swiz.globalDispatcher;
         }
         else if(eventHandlerTag.scope == SwizConfig.LOCAL_DISPATCHER)
         {
            dispatcher = swiz.dispatcher;
         }
         else
         {
            dispatcher = swiz.config.defaultDispatcher == SwizConfig.LOCAL_DISPATCHER ? swiz.dispatcher : swiz.globalDispatcher;
         }
         if(this.eventHandlersByEventType[eventType] is Array)
         {
            eventHandlerIndex = 0;
            for each(eventHandler in this.eventHandlersByEventType[eventType])
            {
               if(eventHandler.method == method && eventHandler.eventClass == eventClass)
               {
                  dispatcher.removeEventListener(eventType,eventHandler.handleEvent,eventHandlerTag.useCapture);
                  this.eventHandlersByEventType[eventType].splice(eventHandlerIndex,1);
                  break;
               }
               eventHandlerIndex++;
            }
            if(this.eventHandlersByEventType[eventType].length == 0)
            {
               delete this.eventHandlersByEventType[eventType];
            }
         }
      }
      
      protected function parseEventTypeExpression(value:String) : String
      {
         if(swiz.config.strict && ClassConstant.isClassConstant(value))
         {
            return ClassConstant.getConstantValue(swiz.domain,ClassConstant.getClass(swiz.domain,value,swiz.config.eventPackages),ClassConstant.getConstantName(value));
         }
         return value;
      }
      
      protected function validateEventHandlerMetadataTag(eventHandlerTag:EventHandlerMetadataTag) : Boolean
      {
         var eventClass:Class = null;
         var descriptor:TypeDescriptor = null;
         var isDynamic:Boolean = false;
         var property:String = null;
         var variableList:XMLList = null;
         var accessorList:XMLList = null;
         if(eventHandlerTag.event == null || eventHandlerTag.event.length == 0)
         {
            throw new Error("Missing \"event\" property in [EventHandler] tag: " + eventHandlerTag.asTag);
         }
         if(ClassConstant.isClassConstant(eventHandlerTag.event))
         {
            eventClass = ClassConstant.getClass(swiz.domain,eventHandlerTag.event,swiz.config.eventPackages);
            if(eventClass == null)
            {
               throw new Error("Could not get a reference to class for " + eventHandlerTag.event + ". Did you specify its package in SwizConfig::eventPackages?");
            }
            descriptor = TypeCache.getTypeDescriptor(eventClass,swiz.domain);
            isDynamic = descriptor.description.@isDynamic.toString() == "true";
            if(!isDynamic)
            {
               for each(property in eventHandlerTag.properties)
               {
                  variableList = descriptor.description.factory.variable.(@name == property);
                  accessorList = descriptor.description.factory.accessor.(@name == property);
                  if(variableList.length() == 0 && accessorList.length() == 0)
                  {
                     throw new Error("Unable to handle event: " + property + " does not exist as a property of " + getQualifiedClassName(eventClass) + ".");
                  }
               }
            }
         }
         return true;
      }
   }
}

