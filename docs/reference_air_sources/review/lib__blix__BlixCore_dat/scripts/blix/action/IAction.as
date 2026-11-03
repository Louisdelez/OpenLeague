package blix.action
{
   import blix.signals.ISignal;
   
   public interface IAction
   {
      
      function getIsOptional() : Boolean;
      
      function getIsFinished() : Boolean;
      
      function getErred() : ISignal;
      
      function getHasErred() : Boolean;
      
      function getError() : Error;
      
      function getInvoking() : ISignal;
      
      function getIsInvoking() : Boolean;
      
      function getInvoked() : ISignal;
      
      function getHasBeenInvoked() : Boolean;
      
      function getCompleted() : ISignal;
      
      function getHasCompleted() : Boolean;
      
      function getAborted() : ISignal;
      
      function getHasAborted() : Boolean;
      
      function abort() : void;
      
      function invoke() : void;
      
      function reset() : void;
   }
}

