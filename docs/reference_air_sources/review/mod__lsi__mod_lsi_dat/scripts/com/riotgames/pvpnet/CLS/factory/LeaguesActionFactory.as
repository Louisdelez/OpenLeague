package com.riotgames.pvpnet.CLS.factory
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.pvpnet.CLS.commands.GetDropInSpectateAvailabilityServiceCall;
   import com.riotgames.pvpnet.CLS.commands.RetrieveInProgressGameSpectatorInfoCall;
   
   public class LeaguesActionFactory implements ILeaguesActionFactory
   {
      
      private var service:ILcdsProxyServiceMessenger;
      
      private var encoder:IEncode;
      
      private var decoder:IDecode;
      
      public function LeaguesActionFactory(param1:ILcdsProxyServiceMessenger, param2:IEncode, param3:IDecode)
      {
         super();
         this.service = param1;
         this.encoder = param2;
         this.decoder = param3;
      }
      
      public function getRetrieveInProgressGameSpectatorInfoAction(param1:String) : IAction
      {
         return new RetrieveInProgressGameSpectatorInfoCall(this.service,this.encoder,this.decoder,param1);
      }
      
      public function getRetrieveDropInSpectateAvailabilityAction(param1:Vector.<String>) : IAction
      {
         return new GetDropInSpectateAvailabilityServiceCall(this.service,this.encoder,this.decoder,param1);
      }
   }
}

