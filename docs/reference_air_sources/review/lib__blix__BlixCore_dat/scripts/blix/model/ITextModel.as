package blix.model
{
   import blix.signals.ISignal;
   
   public interface ITextModel
   {
      
      function getTextChanged() : ISignal;
      
      function getText() : String;
   }
}

