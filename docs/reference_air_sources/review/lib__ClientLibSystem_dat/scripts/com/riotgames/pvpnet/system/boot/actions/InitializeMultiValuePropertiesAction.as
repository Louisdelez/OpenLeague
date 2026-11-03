package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.RiotServiceConfig;
   
   public class InitializeMultiValuePropertiesAction extends BasicAction
   {
      
      public function InitializeMultiValuePropertiesAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         RiotServiceConfig.instance.host.randomize = RiotServiceConfig.instance.host_randomize;
         RiotServiceConfig.instance.lq_uri.randomize = RiotServiceConfig.instance.lq_uri_randomize;
         RiotServiceConfig.instance.xmpp_server_url.randomize = RiotServiceConfig.instance.xmpp_server_url_randomize;
         var _loc1_:Array = RiotServiceConfig.instance.host.values;
         RiotServiceConfig.instance.rawHost.values = _loc1_;
         var _loc2_:Array = new Array();
         var _loc3_:int = int(_loc1_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(RiotServiceConfig.instance.channel_protocol + "://" + _loc1_[_loc4_] + ":" + RiotServiceConfig.instance.remoting_port);
            _loc4_++;
         }
         RiotServiceConfig.instance.host.values = _loc2_;
         complete();
      }
   }
}

