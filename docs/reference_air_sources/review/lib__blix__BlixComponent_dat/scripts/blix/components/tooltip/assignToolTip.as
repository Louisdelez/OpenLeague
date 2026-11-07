package blix.components.tooltip
{
   import blix.assets.proxy.InteractiveObjectProxy;
   
   public function assignToolTip(param1:InteractiveObjectProxy, param2:*, param3:IToolTipHandler = null) : void
   {
      var _loc4_:IToolTipManager = param1.getDependency(IToolTipManager);
      if(_loc4_ != null)
      {
         _loc4_.assignToolTip(param1,param2,param3);
      }
   }
}

