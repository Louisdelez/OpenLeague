package com.riotgames.platform.common
{
   import com.riotgames.platform.common.services.GasToken;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   
   public class RiotServiceConfig
   {
      
      private static var _instance:RiotServiceConfig;
      
      public static const DEFAULT_RANDOMIZE_MULTI_VALUE_PROPS:Boolean = true;
      
      public static const SERVICE_STATUS_API_NAMESPACE:String = "ServiceStatusAPI";
      
      public static const SERVICE_STATUS_API_ENABLED:String = "Enabled";
      
      public var binaryCache:Boolean = true;
      
      public var bgateway_port:String = "6967";
      
      public var xmpp_notifyOnDisconnect:Boolean;
      
      public var messaging_port:String = "2099";
      
      public var maestro_port:int = 8393;
      
      public var xmpp_muc_global_name:String = "lvl";
      
      public var gas_uri:String;
      
      public var gasToken:GasToken;
      
      public var servicesMode:uint;
      
      public var status_url:String = "http://status.leagueoflegends.com";
      
      public var bgateway:MultiValueProperty = new MultiValueProperty();
      
      public var host:MultiValueProperty = new MultiValueProperty();
      
      public var fallBackToOldLoginBehavior:Boolean = false;
      
      public var lq_uri:MultiValueProperty = new MultiValueProperty();
      
      public var xmpp_server_url_randomize:Boolean = true;
      
      public var updateCache:Boolean = false;
      
      public var rssFeedJoJURL:String = "";
      
      public var useCache:Boolean = false;
      
      public var xmpp_server_url:MultiValueProperty = new MultiValueProperty();
      
      public var xmpp_muc_conference_name:String = "conference";
      
      public var xmpp_accept_self_signed_cert:Boolean = false;
      
      public var xmpp_use_ssl:Boolean = true;
      
      public var messaging_channel:String = "my-rtmps";
      
      public var xmpp_muc_communities_name:String = "comm";
      
      public var channel_protocol:String = "rtmps";
      
      public var xmpp_resource:String = "xiff";
      
      public var xmpp_muc_server_url:String = "beta.lol.riotgames.com";
      
      public var host_randomize:Boolean = true;
      
      public var xmpp_muc_secure_conference_name:String = "sec";
      
      public var loginUsername:String;
      
      public var xmpp_auto_registration_enabled:Boolean = true;
      
      public var lq_uri_randomize:Boolean = true;
      
      public var asyncCache:Boolean = true;
      
      public var authenticationRetryBackoffFactor:Number = 1.4;
      
      public var sessionExpirationWarningMinutes:Number = 30;
      
      public var asyncTime:Number = -1;
      
      public var remoting_port:String = "2099";
      
      public var log_mac:Boolean = false;
      
      public var startMaestro:Boolean = true;
      
      public var maximumAuthenticationRetries:uint = 3;
      
      public var xmpp_muc_server_port:int = 0;
      
      public var rawHost:MultiValueProperty = new MultiValueProperty();
      
      public var xmpp_connection_type:String = "standard";
      
      public var xmpp_debug_mode:Boolean;
      
      public var messaging_dest:String = "messagingDestination";
      
      public var rssFeedStoreURL:String;
      
      public function RiotServiceConfig()
      {
         super();
         this.initializeMultivalueDefaults();
      }
      
      public static function get instance() : RiotServiceConfig
      {
         if(_instance == null)
         {
            _instance = new RiotServiceConfig();
         }
         return _instance;
      }
      
      private function initializeMultivalueDefaults() : void
      {
         this.host.values = ["beta.lol.riotgames.com"];
         this.rawHost.values = ["beta.lol.riotgames.com"];
         this.lq_uri.values = ["localhost"];
         this.xmpp_server_url.values = ["beta.lol.riotgames.com"];
         this.bgateway.values = ["localhost"];
      }
      
      public function resetRemotingUrl(param1:String, param2:String) : void
      {
         var _loc3_:Array = new Array();
         _loc3_.push(this.channel_protocol + "://" + param1 + ":" + param2);
         this.host.values = _loc3_;
         var _loc4_:Array = new Array();
         _loc4_.push(param1);
         this.rawHost.values = _loc4_;
      }
   }
}

