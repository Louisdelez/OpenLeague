package org.swizframework.core
{
   public interface ISwizConfig
   {
      
      function get strict() : Boolean;
      
      function set strict(param1:Boolean) : void;
      
      function get setUpEventType() : String;
      
      function set setUpEventType(param1:String) : void;
      
      function get setUpEventPriority() : int;
      
      function set setUpEventPriority(param1:int) : void;
      
      function get setUpEventPhase() : uint;
      
      function set setUpEventPhase(param1:uint) : void;
      
      function get tearDownEventType() : String;
      
      function set tearDownEventType(param1:String) : void;
      
      function get tearDownEventPriority() : int;
      
      function set tearDownEventPriority(param1:int) : void;
      
      function get tearDownEventPhase() : uint;
      
      function set tearDownEventPhase(param1:uint) : void;
      
      function get eventPackages() : Array;
      
      function set eventPackages(param1:*) : void;
      
      function get viewPackages() : Array;
      
      function set viewPackages(param1:*) : void;
      
      function get defaultFaultHandler() : Function;
      
      function set defaultFaultHandler(param1:Function) : void;
      
      function get defaultDispatcher() : String;
      
      function set defaultDispatcher(param1:String) : void;
   }
}

