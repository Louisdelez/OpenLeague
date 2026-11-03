package blix.components.tooltip
{
   import blix.assets.proxy.InteractiveObjectProxy;
   
   public interface IToolTipManager
   {
      
      function assignToolTip(param1:InteractiveObjectProxy, param2:*, param3:IToolTipHandler = null) : void;
      
      function unassignToolTip(param1:InteractiveObjectProxy) : Boolean;
   }
}

