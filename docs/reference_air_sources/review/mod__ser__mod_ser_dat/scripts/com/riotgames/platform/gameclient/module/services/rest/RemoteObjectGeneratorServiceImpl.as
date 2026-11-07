package com.riotgames.platform.gameclient.module.services.rest
{
   import com.riotgames.platform.common.services.RemoteObjectGeneratorService;
   import com.riotgames.platform.gameclient.module.services.RemoteObjectGenerator;
   
   public class RemoteObjectGeneratorServiceImpl implements RemoteObjectGeneratorService
   {
      
      public var remoteObjectGenerator:RemoteObjectGenerator;
      
      public function RemoteObjectGeneratorServiceImpl()
      {
         super();
      }
      
      public function authenticateChannel(param1:String, param2:String) : void
      {
         this.remoteObjectGenerator.authenticateChannel(this.remoteObjectGenerator.defaultChannelSet,param1,param2);
      }
      
      public function addChannelSetListener(param1:String, param2:Function) : void
      {
         this.remoteObjectGenerator.addChannelSetListener(param1,param2);
      }
      
      public function removeChannelSetListener(param1:String, param2:Function) : void
      {
         this.remoteObjectGenerator.removeChannelSetListener(param1,param2);
      }
      
      public function expireAuthenticationChannel() : void
      {
         this.remoteObjectGenerator.expireDefaultAuthenticationChannel();
      }
   }
}

