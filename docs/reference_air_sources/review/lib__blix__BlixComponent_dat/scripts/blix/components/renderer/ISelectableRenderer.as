package blix.components.renderer
{
   import blix.signals.ISignal;
   
   public interface ISelectableRenderer extends IItemRenderer
   {
      
      function getSelectionRequested() : ISignal;
      
      function getSelected() : Boolean;
      
      function setSelected(param1:Boolean) : void;
   }
}

