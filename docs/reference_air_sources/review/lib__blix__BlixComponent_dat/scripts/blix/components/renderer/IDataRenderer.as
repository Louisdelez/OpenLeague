package blix.components.renderer
{
   import blix.IDestructible;
   import blix.assets.proxy.IDisplayChild;
   import blix.view.IValidatable;
   import blix.view.IView;
   
   public interface IDataRenderer extends IView, IValidatable, IDisplayChild, IDestructible
   {
      
      function getData() : *;
      
      function setData(param1:*) : void;
   }
}

