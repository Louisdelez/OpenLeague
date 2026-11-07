package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.GeneratedContentLoader;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   
   public class LoadGeneratedContentAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function LoadGeneratedContentAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         GeneratedContentLoader.instance.load(this.onGeneratedContentLoaded);
      }
      
      private function onGeneratedContentLoaded() : void
      {
         complete();
      }
   }
}

