package blix.components.tooltip
{
   import blix.assets.proxy.InteractiveObjectProxy;
   
   public function unassignToolTip(param1:InteractiveObjectProxy) : Boolean
   {
      var _loc2_:IToolTipManager = param1.getDependency(IToolTipManager);
      if(_loc2_ != null)
      {
         return _loc2_.unassignToolTip(param1);
      }
      return false;
   }
}

