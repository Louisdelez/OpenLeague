package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.sound.AudioProviderImpl;
   
   public class InitializeSoundProviderAction extends BasicAction
   {
      
      private var _clientConfig:ClientConfig;
      
      public function InitializeSoundProviderAction(param1:ClientConfig)
      {
         super(false);
         this._clientConfig = param1;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:AudioProviderImpl = new AudioProviderImpl(this._clientConfig);
         ProviderLookup.publishProvider(ISoundProvider,_loc1_);
         complete();
      }
   }
}

