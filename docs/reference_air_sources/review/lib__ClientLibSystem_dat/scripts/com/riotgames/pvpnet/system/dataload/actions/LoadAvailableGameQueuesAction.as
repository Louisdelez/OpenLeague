package com.riotgames.pvpnet.system.dataload.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.pvpnet.system.dataload.InitialClientData;
   import mx.collections.ArrayCollection;
   import mx.rpc.events.ResultEvent;
   
   public class LoadAvailableGameQueuesAction extends BasicAction
   {
      
      private var _initialClientData:InitialClientData;
      
      public function LoadAvailableGameQueuesAction(param1:InitialClientData)
      {
         super(false);
         this._initialClientData = param1;
      }
      
      override protected function doInvocation() : void
      {
         ServiceProxy.instance.matchMakerService.getAvailableQueues(this.onRetrieveGameQueuesSuccess,null,this.onRetrieveGameQueuesFailed);
      }
      
      private function onRetrieveGameQueuesSuccess(param1:ResultEvent) : void
      {
         var _loc2_:ArrayCollection = new ArrayCollection();
         if(param1 != null && param1.result != null && param1.result is ArrayCollection)
         {
            _loc2_ = param1.result as ArrayCollection;
         }
         this._initialClientData.availableGameQueues = _loc2_;
         complete();
      }
      
      private function onRetrieveGameQueuesFailed(param1:Object) : void
      {
         this._initialClientData.availableGameQueues = new ArrayCollection();
         complete();
      }
   }
}

