package blix.components.tooltip
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.InteractiveObjectProxy;
   
   public interface IToolTipHandler
   {
      
      function createToolTip(param1:DisplayObjectContainerProxy, param2:*, param3:InteractiveObjectProxy) : void;
      
      function destroyToolTip() : void;
      
      function getShowDelay() : Number;
      
      function getHideDelay() : Number;
      
      function getPreserveToolTip() : Boolean;
   }
}

