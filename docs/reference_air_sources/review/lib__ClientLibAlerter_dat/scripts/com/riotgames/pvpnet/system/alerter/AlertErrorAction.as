package com.riotgames.pvpnet.system.alerter
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class AlertErrorAction extends AlertAction
   {
      
      public var stackTrace:String;
      
      public function AlertErrorAction(param1:String, param2:String, param3:String)
      {
         super(param1,param2);
         this.stackTrace = param3;
         showAffirmative = false;
         showNegative = true;
         var _loc4_:IResourceManager = ResourceManager.getInstance();
         affirmativeLabel = _loc4_.getString("resources","errorDialog_sendErrorReportButtonLabel");
         negativeLabel = _loc4_.getString("resources","errorDialog_dontSendErrorReportButtonLabel");
      }
   }
}

