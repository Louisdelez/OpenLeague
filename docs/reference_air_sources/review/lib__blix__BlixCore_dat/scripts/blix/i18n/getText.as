package blix.i18n
{
   import blix.context.IContext;
   import blix.model.TextModel;
   
   public function getText(param1:IContext, param2:String, param3:String = null) : TextModel
   {
      var _loc4_:ILocalizationManager = param1.getDependency(ILocalizationManager);
      if(_loc4_ == null)
      {
         return null;
      }
      return _loc4_.getText(param2,param3);
   }
}

