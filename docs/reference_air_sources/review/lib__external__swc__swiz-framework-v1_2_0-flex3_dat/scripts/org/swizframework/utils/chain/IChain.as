package org.swizframework.utils.chain
{
   import flash.events.IEventDispatcher;
   
   [Event(name="chainFail",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainComplete",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainStepError",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainStepComplete",type="org.swizframework.events.ChainEvent")]
   [Event(name="chainStart",type="org.swizframework.events.ChainEvent")]
   public interface IChain extends IEventDispatcher
   {
      
      function get position() : int;
      
      function set position(param1:int) : void;
      
      function get isComplete() : Boolean;
      
      function get stopOnError() : Boolean;
      
      function set stopOnError(param1:Boolean) : void;
      
      function hasNext() : Boolean;
      
      function stepComplete() : void;
      
      function stepError() : void;
      
      function addStep(param1:IChainStep) : IChain;
      
      function start() : void;
      
      function doProceed() : void;
   }
}

