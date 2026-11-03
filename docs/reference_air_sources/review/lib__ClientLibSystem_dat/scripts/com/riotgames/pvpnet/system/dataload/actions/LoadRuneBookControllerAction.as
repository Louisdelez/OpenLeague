package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   
   public class LoadRuneBookControllerAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function LoadRuneBookControllerAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         ProviderLookup.getProvider(IRuneBookController,this.onRunebookControllerRetrieved);
      }
      
      private function onRunebookControllerRetrieved(param1:IRuneBookController) : void
      {
         this._initialClientData.runeBookController = param1;
         complete();
      }
   }
}

