package com.riotgames.pvpnet.system.boot.actions
{
   import blix.action.LoaderAction;
   import blix.action.MultiAction;
   import com.riotgames.util.logging.getLogger;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import mx.logging.ILogger;
   
   public class InitializeSharedAssetsAction extends MultiAction
   {
      
      private var logger:ILogger = getLogger(this);
      
      public function InitializeSharedAssetsAction()
      {
         super();
         this.addSharedSwf("app:/assets/shared/chrome.swf");
         this.addSharedSwf("app:/assets/shared/components.swf");
         this.addSharedSwf("app:/assets/shared/buttons.swf");
         this.addSharedSwf("app:/assets/shared/widgets.swf");
      }
      
      private function addSharedSwf(param1:String) : void
      {
         var action:LoaderAction;
         var sharedSwfPath:String = param1;
         var context:LoaderContext = new LoaderContext();
         context.applicationDomain = ApplicationDomain.currentDomain;
         action = new LoaderAction(new URLRequest(sharedSwfPath),context);
         addAction(action);
         action.getInvoked().add(function():void
         {
            logger.info("Loading shared swf: " + sharedSwfPath);
         });
      }
   }
}

