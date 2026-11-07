package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.maestro.IMaestroProvider;
   import com.riotgames.util.logging.getLogger;
   import mx.logging.ILogger;
   
   public class InitializeGameConnectionAction extends BasicAction
   {
      
      private var _gameConnectionController:IMaestroProvider;
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var logger:ILogger;
      
      public function InitializeGameConnectionAction(param1:IMaestroProvider)
      {
         super(false);
         this._gameConnectionController = param1;
         this.logger = getLogger(this);
      }
      
      override protected function doInvocation() : void
      {
         if(RiotServiceConfig.instance.startMaestro)
         {
            try
            {
               this._gameConnectionController.start(RiotServiceConfig.instance.maestro_port);
            }
            catch(error:Error)
            {
               logger.error("initialize: error starting Maestro=",error);
            }
         }
         ProviderLookup.publishProvider(IMaestroProvider,this._gameConnectionController);
         complete();
      }
   }
}

