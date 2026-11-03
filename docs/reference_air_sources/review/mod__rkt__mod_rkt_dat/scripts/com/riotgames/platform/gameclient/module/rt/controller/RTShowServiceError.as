package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTShowServiceError extends RTSimpleCommand
   {
      
      public static const SHOW_ERROR:String = "SHOW_ERROR";
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function RTShowServiceError()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = "UNKNOWN";
         var _loc3_:Object = param1.getBody();
         if(_loc3_)
         {
            if(_loc3_.errorCode is String && _loc3_.errorCode.length > 0)
            {
               _loc2_ = _loc3_.errorCode;
            }
         }
         var _loc4_:String = RTResource.getString("RT_" + _loc2_);
         if(_loc4_.indexOf("**") != -1)
         {
            this.logger.warn("Unknown ranked teams error code: " + _loc2_);
            _loc4_ = RTResource.getString("RT_UNKNOWN");
         }
         var _loc5_:String = RTResource.getString("ranked_team_error_header");
         var _loc6_:AlertAction = new AlertAction(_loc5_,_loc4_);
         _loc6_.add();
         sendNotification(RTLogCommand.ERROR,_loc4_);
      }
   }
}

