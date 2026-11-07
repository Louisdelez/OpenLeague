package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.domain.PlayerComplaint;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessageResponse;
   import com.riotgames.platform.gameclient.services.ClientFacadeService;
   
   public class ClientFacadeServiceImpl extends BaseLcdsService implements ClientFacadeService
   {
      
      public function ClientFacadeServiceImpl()
      {
         super();
      }
      
      public function getLoginDataPacketForUser(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("clientFacadeService","getLoginDataPacketForUser",[],param1,param2,null,null);
      }
      
      public function ackLeaverBusterWarning() : void
      {
         invokeServiceWithoutSession("clientFacadeService","ackLeaverBusterWarning",null,null);
      }
      
      public function abandonLeaverBusterLowPriorityQueue(param1:String) : void
      {
         invokeServiceWithoutSession("clientFacadeService","abandonLeaverBusterLowPriorityQueue",[param1],null);
      }
      
      public function reportPlayer(param1:PlayerComplaint, param2:Function) : void
      {
         invokeServiceWithoutSession("clientFacadeService","reportPlayer",[param1],null,param2,null,null);
      }
      
      public function acknowlageMessage(param1:SimpleDialogMessageResponse, param2:Function) : void
      {
         invokeServiceWithoutSession("clientFacadeService","callPersistenceMessaging",[param1],null,param2,null,null);
      }
   }
}

