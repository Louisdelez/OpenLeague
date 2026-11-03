package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.logging.getLogger;
   import flash.system.Capabilities;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import mx.logging.ILogger;
   
   public class InitializeIMEAction extends BasicAction
   {
      
      private var logger:ILogger;
      
      public function InitializeIMEAction()
      {
         super(false);
         this.logger = getLogger(this);
      }
      
      override protected function doInvocation() : void
      {
         if(Capabilities.hasIME)
         {
            if(ClientConfig.instance.ime != null)
            {
               try
               {
                  IME.enabled = true;
               }
               catch(error:Error)
               {
                  logger.error("RiotApplication.initializeIME: Unable to enable IME support for IME Conversion Mode " + ClientConfig.instance.ime);
               }
               if(IME.enabled)
               {
                  try
                  {
                     IME.conversionMode = IMEConversionMode[ClientConfig.instance.ime];
                  }
                  catch(error:Error)
                  {
                     logger.warn("RiotApplication.initializeIME: Unable to initialize the IME Conversion Mode " + ClientConfig.instance.ime + ": " + error);
                  }
               }
            }
            else
            {
               IME.enabled = false;
               this.logger.info("RiotApplication.initializeIME: Disabling IME support since IME conversion mode not specified.");
            }
         }
         complete();
      }
   }
}

