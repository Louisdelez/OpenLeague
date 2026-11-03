package org.swizframework.utils.commands
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import org.swizframework.core.Bean;
   import org.swizframework.core.ISwiz;
   import org.swizframework.core.ISwizAware;
   import org.swizframework.core.Prototype;
   import org.swizframework.reflection.TypeCache;
   
   public class CommandMap implements ISwizAware
   {
      
      protected var _swiz:ISwiz;
      
      protected var map:Dictionary = new Dictionary();
      
      public function CommandMap()
      {
         super();
      }
      
      public function set swiz(swiz:ISwiz) : void
      {
         this._swiz = swiz;
         this.mapCommands();
      }
      
      protected function handleCommandEvent(event:Event) : void
      {
         var indexesToClear:Array = null;
         var mappings:Array = null;
         var i:int = 0;
         var commandMapping:CommandMapping = null;
         var commandPrototype:Bean = null;
         var command:Object = null;
         var j:int = 0;
         if(this.map[event.type] != null)
         {
            indexesToClear = [];
            mappings = this.map[event.type] as Array;
            for(i = 0; i < mappings.length; i++)
            {
               commandMapping = CommandMapping(mappings[i]);
               if(!(event is commandMapping.eventClass))
               {
                  return;
               }
               commandPrototype = this._swiz.beanFactory.getBeanByType(commandMapping.commandClass);
               if(commandPrototype == null)
               {
                  throw new Error("Command bean not found for mapped event type.");
               }
               if(!(commandPrototype is Prototype))
               {
                  throw new Error("Commands must be provided as Prototype beans.");
               }
               command = Prototype(commandPrototype).source;
               if(!(command is ICommand))
               {
                  throw new Error("Commands must implement org.swizframework.utils.commands.ICommand.");
               }
               if(command is IEventAwareCommand)
               {
                  IEventAwareCommand(command).event = event;
               }
               ICommand(command).execute();
               if(commandMapping.oneTime)
               {
                  indexesToClear.push(i);
               }
            }
            if(indexesToClear.length > 0)
            {
               for(j = indexesToClear.length - 1; j > -1; j--)
               {
                  mappings.splice(indexesToClear[j],1);
               }
               if(indexesToClear.length == 0)
               {
                  delete this.map[event.type];
               }
            }
         }
      }
      
      protected function mapCommands() : void
      {
      }
      
      protected function mapCommand(eventType:String, commandClass:Class, eventClass:Class = null, oneTime:Boolean = false) : void
      {
         var mappings:Array = null;
         var cm:CommandMapping = null;
         var commandPrototype:Prototype = null;
         if(this.map[eventType] == null)
         {
            this.map[eventType] = [new CommandMapping(eventType,commandClass,eventClass,oneTime)];
         }
         else
         {
            mappings = this.map[eventType] as Array;
            for each(cm in mappings)
            {
               if(cm.commandClass == commandClass)
               {
                  throw new Error(cm.commandClass + " already mapped to " + eventType);
               }
            }
            mappings.push(new CommandMapping(eventType,commandClass,eventClass,oneTime));
         }
         if(this._swiz.beanFactory.getBeanByType(commandClass) == null)
         {
            commandPrototype = new Prototype(commandClass);
            commandPrototype.typeDescriptor = TypeCache.getTypeDescriptor(commandClass,this._swiz.domain);
            this._swiz.beanFactory.addBean(commandPrototype,false);
         }
         this._swiz.dispatcher.addEventListener(eventType,this.handleCommandEvent,false,0,true);
      }
   }
}

import flash.events.Event;

class CommandMapping
{
   
   public var eventType:String;
   
   public var commandClass:Class;
   
   public var eventClass:Class;
   
   public var oneTime:Boolean;
   
   public function CommandMapping(eventType:String, commandClass:Class, eventClass:Class = null, oneTime:Boolean = false)
   {
      super();
      this.eventType = eventType;
      this.commandClass = commandClass;
      this.eventClass = eventClass || Event;
      this.oneTime = oneTime;
   }
}
