package com.riotgames.pvpnet.system.config.cdc
{
   import com.riotgames.platform.common.event.BroadcastMessageEvent;
   import com.riotgames.platform.common.services.MessageRouterService;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.platform.gameclient.CDC.ClientDynamicConfigurationNotification;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.pvpnet.system.messaging.BroadcastMessageControllerProxy;
   import mx.messaging.events.MessageEvent;
   
   public class DynamicClientConfigManager
   {
      
      private static var _initialized:Boolean = false;
      
      private static var _namespaceMap:Object = {};
      
      public function DynamicClientConfigManager()
      {
         super();
      }
      
      public static function initialize(param1:MessageRouterService) : void
      {
         if(_initialized)
         {
            return;
         }
         if(param1 != null)
         {
            ServiceProxy.instance.messageRouterService.addClientNotificationMessageListener(onClientNotificationMessageReceived);
            BroadcastMessageControllerProxy.instance.addMessageListener(ClientNotificationType.DYNAMIC_CONFIGURATION,onBroadcastMessageReceived);
            _initialized = true;
         }
      }
      
      public static function getConfiguration(param1:String, param2:String, param3:Object, param4:Function = null) : ConfigurationModel
      {
         var _loc5_:ConfigurationModel = null;
         var _loc6_:String = param1.toLowerCase();
         var _loc7_:String = param2.toLowerCase();
         if(!_namespaceMap.hasOwnProperty(_loc6_))
         {
            _namespaceMap[_loc6_] = {};
         }
         else
         {
            _loc5_ = _namespaceMap[_loc6_][_loc7_];
         }
         if(_loc5_ == null)
         {
            _loc5_ = new ConfigurationModel(param1,param2,param3);
            _namespaceMap[_loc6_][_loc7_] = _loc5_;
         }
         if(param4 != null)
         {
            _loc5_.getChangedSignal().add(param4);
         }
         return _loc5_;
      }
      
      private static function onClientNotificationMessageReceived(param1:MessageEvent) : void
      {
         onMessageReceived(param1.message.body as ClientDynamicConfigurationNotification,true);
      }
      
      private static function onBroadcastMessageReceived(param1:BroadcastMessageEvent) : void
      {
         onMessageReceived(param1.notification as ClientDynamicConfigurationNotification,false);
      }
      
      public static function getNamespace(param1:String) : Object
      {
         return _namespaceMap[param1.toLowerCase()];
      }
      
      private static function onMessageReceived(param1:ClientDynamicConfigurationNotification, param2:Boolean) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:ConfigurationModel = null;
         var _loc3_:JSONDecoder = new JSONDecoder();
         if(param1 == null)
         {
            return;
         }
         var _loc4_:Object = _loc3_.decode(param1.configs);
         for(_loc5_ in _loc4_)
         {
            _loc6_ = _loc5_.toLowerCase();
            if(!_namespaceMap.hasOwnProperty(_loc6_))
            {
               _namespaceMap[_loc6_] = {};
            }
            for(_loc7_ in _loc4_[_loc5_])
            {
               _loc8_ = _loc7_.toLowerCase();
               if(!_namespaceMap[_loc6_].hasOwnProperty(_loc8_))
               {
                  _namespaceMap[_loc6_][_loc8_] = new ConfigurationModel(_loc5_,_loc7_,_loc4_[_loc5_][_loc7_]);
               }
               else
               {
                  _loc9_ = _namespaceMap[_loc6_][_loc8_];
                  _loc9_.setValue(_loc4_[_loc5_][_loc7_],param2);
               }
            }
         }
      }
   }
}

