package blix.layout
{
   import blix.layout.algorithms.ILayoutAlgorithm;
   import blix.signals.ISignal;
   import blix.view.ILayoutData;
   import blix.view.ILayoutElement;
   
   public interface ILayoutContainer extends ILayoutElement
   {
      
      function getLayoutAlgorithm() : ILayoutAlgorithm;
      
      function setLayoutAlgorithm(param1:ILayoutAlgorithm) : void;
      
      function getEntryAdded() : ISignal;
      
      function getEntryRemoved() : ISignal;
      
      function addElement(param1:ILayoutElement, param2:ILayoutData = null) : void;
      
      function addElementAt(param1:ILayoutElement, param2:int, param3:ILayoutData = null) : void;
      
      function getElementAt(param1:int) : ILayoutElement;
      
      function getElementIndex(param1:ILayoutElement) : int;
      
      function removeElement(param1:ILayoutElement) : Boolean;
      
      function removeElementAt(param1:int) : Boolean;
      
      function removeAllElements() : void;
   }
}

