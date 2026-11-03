package blix.signals
{
   public interface IOnceSignal extends ISignal
   {
      
      function getHasDispatched() : Boolean;
   }
}

