package com.riotgames.platform.gameclient.commands.featuredgame
{
   import blix.action.SequenceAction;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   
   internal class QueryMetadataAndUpdateGameOptionsAction extends SequenceAction
   {
      
      public function QueryMetadataAndUpdateGameOptionsAction(param1:GameQueueManager, param2:Array)
      {
         super();
         then(new FeaturedGameMetadataQueryAction());
         then(new UpdateGameOptionsForMetadataAction(param1,param2));
      }
      
      override protected function doInvocation() : void
      {
         if(!FeaturedGameMetadataActions.serviceEnabled)
         {
            complete();
            return;
         }
         super.doInvocation();
      }
   }
}

