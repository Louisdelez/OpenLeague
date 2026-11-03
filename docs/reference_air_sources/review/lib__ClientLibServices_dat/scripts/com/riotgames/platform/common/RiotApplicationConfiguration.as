package com.riotgames.platform.common
{
   import com.riotgames.platform.common.utils.MultiValueProperty;
   
   public interface RiotApplicationConfiguration
   {
      
      function set START_MAESTRO_PROP(param1:Boolean) : void;
      
      function get RSS_FEED_JOJ_URL_PROP() : String;
      
      function get GET_CLIENT_IP_URL() : String;
      
      function get ASYNC_CACHE_PROP() : Boolean;
      
      function get SERVICES_MODE() : uint;
      
      function get MESSAGING_DEST_PROP() : String;
      
      function get sessionExpirationWarningMinutes() : Number;
      
      function get RSS_FEED_STORE_URL_PROP() : String;
      
      function get BINARY_CACHE_PROP() : Boolean;
      
      function get CHANNEL_PROTOCOL_PROP() : String;
      
      function get REMOTING_URL_PROP() : MultiValueProperty;
      
      function get LQ_URI_PROP() : MultiValueProperty;
      
      function get ASYNC_TIME_PROP() : Number;
      
      function get GET_CLIENT_IP_TIMEOUT_SECONDS() : Number;
      
      function get UPDATE_CACHE_PROP() : Boolean;
      
      function get XMPP_HOST_PROP() : MultiValueProperty;
      
      function get USE_CACHE_PROP() : Boolean;
      
      function get MESSAGING_CHANNEL_PROP() : String;
      
      function get START_MAESTRO_PROP() : Boolean;
      
      function set loginUsername(param1:String) : void;
      
      function get loginUsername() : String;
   }
}

