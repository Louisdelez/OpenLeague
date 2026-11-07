package blix.validation
{
   import blix.signals.ISignal;
   
   public interface IValidator
   {
      
      function getValidated() : ISignal;
      
      function getErrors() : Vector.<ValidationError>;
      
      function validate() : Vector.<ValidationError>;
   }
}

