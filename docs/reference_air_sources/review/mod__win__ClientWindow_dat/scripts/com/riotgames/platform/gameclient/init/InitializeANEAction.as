package com.riotgames.platform.gameclient.init
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.MetricsProxy;
   import com.riotgames.pvpnet.nativeextensionmain.NativeExtensionMain;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.logging.getLogger;
   import mx.logging.ILogger;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class InitializeANEAction extends BasicAction
   {
      
      private static var aneInitialized:Boolean = false;
      
      protected var logger:ILogger = getLogger(this);
      
      public function InitializeANEAction()
      {
         super(true);
      }
      
      override protected function doInvocation() : void
      {
         if(aneInitialized == false && Boolean(ClientConfig.instance.useANE))
         {
            try
            {
               NativeExtensionMain.InitLolNativeExtension();
               aneInitialized = true;
               this.aneHookWindowMessages();
            }
            catch(e:ArgumentError)
            {
               logger.error("ANE Initialization error: " + e.toString());
               err(e);
            }
            catch(e:TypeError)
            {
               logger.error("ANE Initialization error: " + e.toString());
               err(e);
            }
         }
         complete();
      }
      
      private function aneHookWindowMessages() : void
      {
         var windowTitle:String;
         var data:Object = null;
         var ret_val:* = undefined;
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         if(aneInitialized == false)
         {
            return;
         }
         windowTitle = resourceManager.getString("resources","main_window_title");
         try
         {
            data = {};
            ret_val = NativeExtensionMain.testAneFunction();
            data["ane_return_value"] = ret_val;
            MetricsProxy.instance.track("front_end_ane_test",data);
         }
         catch(e:ArgumentError)
         {
            logger.error("ANE call error: " + e.toString());
            err(e);
         }
      }
   }
}

