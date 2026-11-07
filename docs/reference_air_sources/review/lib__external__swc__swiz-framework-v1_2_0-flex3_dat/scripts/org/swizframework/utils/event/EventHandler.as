package org.swizframework.utils.event
{
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import mx.rpc.AsyncToken;
   import org.swizframework.metadata.EventHandlerMetadataTag;
   import org.swizframework.reflection.MetadataHostMethod;
   import org.swizframework.reflection.MethodParameter;
   import org.swizframework.utils.async.AsyncTokenOperation;
   import org.swizframework.utils.async.IAsynchronousEvent;
   import org.swizframework.utils.async.IAsynchronousOperation;
   
   public class EventHandler
   {
      
      protected var _metadataTag:EventHandlerMetadataTag;
      
      protected var _method:Function;
      
      protected var _eventClass:Class;
      
      public function EventHandler(metadataTag:EventHandlerMetadataTag, method:Function, eventClass:Class)
      {
         super();
         this._metadataTag = metadataTag;
         this._method = method;
         this._eventClass = eventClass;
      }
      
      public function get metadataTag() : EventHandlerMetadataTag
      {
         return this._metadataTag;
      }
      
      public function get method() : Function
      {
         return this._method;
      }
      
      public function get eventClass() : Class
      {
         return this._eventClass;
      }
      
      public function handleEvent(event:Event) : void
      {
         if(this.eventClass != null && !(event is this.eventClass))
         {
            return;
         }
         var result:* = null;
         if(this.metadataTag.properties != null)
         {
            if(this.validateEvent(event,this.metadataTag.properties))
            {
               result = this.method.apply(null,this.getEventArgs(event,this.metadataTag.properties));
            }
         }
         else
         {
            if(this.getRequiredParameterCount() > 1)
            {
               throw new Error("Unable to handle event: " + this.metadataTag.host.name + "() requires " + this.getRequiredParameterCount() + " parameters, and no properties were specified.");
            }
            if(this.getParameterCount() > 0 && event is this.getParameterType(0))
            {
               result = this.method.apply(null,[event]);
            }
            else
            {
               result = this.method.apply();
            }
         }
         if(event is IAsynchronousEvent && IAsynchronousEvent(event).step != null)
         {
            if(result is IAsynchronousOperation)
            {
               IAsynchronousEvent(event).step.addAsynchronousOperation(result as IAsynchronousOperation);
            }
            else if(result is AsyncToken)
            {
               IAsynchronousEvent(event).step.addAsynchronousOperation(new AsyncTokenOperation(result as AsyncToken));
            }
         }
         if(this.metadataTag.stopPropagation)
         {
            event.stopPropagation();
         }
         if(this.metadataTag.stopImmediatePropagation)
         {
            event.stopImmediatePropagation();
         }
      }
      
      protected function validateEvent(event:Event, properties:Array) : Boolean
      {
         var property:String = null;
         for each(property in properties)
         {
            if(!(property in event))
            {
               throw new Error("Unable to handle event: " + property + " does not exist as a property of " + getQualifiedClassName(event) + ".");
            }
         }
         return true;
      }
      
      protected function getEventArgs(event:Event, properties:Array) : Array
      {
         var property:String = null;
         var args:Array = [];
         for each(property in properties)
         {
            args[args.length] = event[property];
         }
         return args;
      }
      
      protected function getParameterCount() : int
      {
         return (this.metadataTag.host as MetadataHostMethod).parameters.length;
      }
      
      protected function getRequiredParameterCount() : int
      {
         var parameter:MethodParameter = null;
         var requiredParameterCount:int = 0;
         var parameters:Array = (this.metadataTag.host as MetadataHostMethod).parameters;
         for each(parameter in parameters)
         {
            if(parameter.optional)
            {
               break;
            }
            requiredParameterCount++;
         }
         return requiredParameterCount;
      }
      
      protected function getParameterType(parameterIndex:int) : Class
      {
         var parameters:Array = (this.metadataTag.host as MetadataHostMethod).parameters;
         if(parameterIndex < parameters.length)
         {
            return (parameters[parameterIndex] as MethodParameter).type;
         }
         return null;
      }
   }
}

