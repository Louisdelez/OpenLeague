package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.PlayerComplaint;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessageResponse;
   
   public interface ClientFacadeService
   {
      
      function reportPlayer(param1:PlayerComplaint, param2:Function) : void;
      
      function ackLeaverBusterWarning() : void;
      
      function abandonLeaverBusterLowPriorityQueue(param1:String) : void;
      
      function acknowlageMessage(param1:SimpleDialogMessageResponse, param2:Function) : void;
      
      function getLoginDataPacketForUser(param1:Function, param2:Function) : void;
   }
}

