package mx.messaging.channels
{
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import mx.core.mx_internal;
   import mx.messaging.FlexClient;
   import mx.messaging.config.ServerConfig;
   
   use namespace mx_internal;
   
   public class SecureRTMPChannel extends RTMPChannel
   {
      
      public function SecureRTMPChannel(param1:String = null, param2:String = null)
      {
         super(param1,param2);
      }
      
      override public function get protocol() : String
      {
         return "rtmps";
      }
      
      override protected function attemptConcurrentConnect() : void
      {
         _concurrentConnectTimer.delay = 15000;
         _concurrentConnectTimer.start();
      }
      
      override protected function concurrentConnectHandler(param1:TimerEvent) : void
      {
         _concurrentConnectTimer.stop();
         var _loc2_:NetConnection = buildTempNC();
         _loc2_.proxyType = "http";
         _tempNCs.push(_loc2_);
         var _loc3_:String = FlexClient.getInstance().id;
         if(_loc3_ == null)
         {
            _loc3_ = FlexClient.mx_internal::NULL_FLEXCLIENT_ID;
         }
         if(credentials != null)
         {
            _loc2_.connect(endpoint,ServerConfig.mx_internal::needsConfig(this),_loc3_,credentials,buildHandshakeMessage());
         }
         else
         {
            _loc2_.connect(endpoint,ServerConfig.mx_internal::needsConfig(this),_loc3_,"",buildHandshakeMessage());
         }
      }
   }
}

