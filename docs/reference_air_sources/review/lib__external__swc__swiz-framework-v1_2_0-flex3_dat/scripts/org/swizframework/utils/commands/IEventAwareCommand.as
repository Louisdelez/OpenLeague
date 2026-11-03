package org.swizframework.utils.commands
{
   import flash.events.Event;
   
   public interface IEventAwareCommand extends ICommand
   {
      
      function set event(param1:Event) : void;
   }
}

