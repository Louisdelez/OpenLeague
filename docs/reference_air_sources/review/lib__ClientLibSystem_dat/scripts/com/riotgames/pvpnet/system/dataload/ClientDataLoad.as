package com.riotgames.pvpnet.system.dataload
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import blix.action.SequenceAction;
   import com.riotgames.pvpnet.system.dataload.actions.AddMessageListenersAction;
   import com.riotgames.pvpnet.system.dataload.actions.CheckChatRestrictionAction;
   import com.riotgames.pvpnet.system.dataload.actions.CheckRankedRestrictionAction;
   import com.riotgames.pvpnet.system.dataload.actions.InitializeCelebration;
   import com.riotgames.pvpnet.system.dataload.actions.InitializeClientDataAction;
   import com.riotgames.pvpnet.system.dataload.actions.InitializeInventoryControllerProviderAction;
   import com.riotgames.pvpnet.system.dataload.actions.InitializeInventoryProviderAction;
   import com.riotgames.pvpnet.system.dataload.actions.InitializeItemSets;
   import com.riotgames.pvpnet.system.dataload.actions.LoadAvailableGameQueuesAction;
   import com.riotgames.pvpnet.system.dataload.actions.LoadGeneratedContentAction;
   import com.riotgames.pvpnet.system.dataload.actions.LoadLoginDataPacketAction;
   import com.riotgames.pvpnet.system.dataload.actions.LoadRuneBookControllerAction;
   import com.riotgames.pvpnet.system.dataload.actions.LoadSummonerActiveBoostsAction;
   
   public class ClientDataLoad extends BasicAction
   {
      
      private var _initialClientData:InitialClientData = new InitialClientData();
      
      private var _bootSequence:SequenceAction;
      
      public function ClientDataLoad()
      {
         super(false);
         this._bootSequence = new SequenceAction();
         this._bootSequence.getCompleted().add(this.bootSequenceCompleted);
         this._bootSequence.getErred().add(this.bootSequenceErred);
         this.setupBootSequence();
      }
      
      override protected function doInvocation() : void
      {
         this._bootSequence.invoke();
      }
      
      protected function customizeBootSequence(param1:SequenceAction) : void
      {
      }
      
      private function setupBootSequence() : void
      {
         this._bootSequence.then(new AddMessageListenersAction(this._initialClientData));
         this._bootSequence.and(new LoadLoginDataPacketAction(this._initialClientData));
         this._bootSequence.and(new LoadGeneratedContentAction(this._initialClientData));
         this._bootSequence.and(new InitializeInventoryProviderAction(this._initialClientData));
         this._bootSequence.and(new InitializeInventoryControllerProviderAction(this._initialClientData));
         this._bootSequence.and(new LoadRuneBookControllerAction(this._initialClientData));
         this._bootSequence.and(new LoadAvailableGameQueuesAction(this._initialClientData));
         this.customizeBootSequence(this._bootSequence);
         this._bootSequence.then(new InitializeCelebration(this._initialClientData));
         this._bootSequence.then(new LoadSummonerActiveBoostsAction(this._initialClientData));
         this._bootSequence.then(new InitializeClientDataAction(this._initialClientData));
         this._bootSequence.then(new CheckChatRestrictionAction(this._initialClientData));
         this._bootSequence.then(new CheckRankedRestrictionAction(this._initialClientData));
         this._bootSequence.then(new InitializeItemSets());
      }
      
      private function bootSequenceCompleted() : void
      {
         complete();
      }
      
      private function bootSequenceErred(param1:IAction) : void
      {
         err(new Error("Data load sequence failed: " + param1.getError().message));
      }
   }
}

