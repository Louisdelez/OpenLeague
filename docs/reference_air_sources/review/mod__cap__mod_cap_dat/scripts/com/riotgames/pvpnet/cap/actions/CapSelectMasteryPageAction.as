package com.riotgames.pvpnet.cap.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public class CapSelectMasteryPageAction extends BasicAction
   {
      
      public var player:CapPlayerSelection;
      
      public var masteryPage:MasteryPageInfoSummary;
      
      public var masteriesProvider:IMasteriesProvider;
      
      public function CapSelectMasteryPageAction(param1:MasteryPageInfoSummary, param2:IMasteriesProvider, param3:CapPlayerSelection)
      {
         super(false);
         this.masteryPage = param1;
         this.masteriesProvider = param2;
         this.player = param3;
      }
      
      override protected function doInvocation() : void
      {
         this.masteriesProvider.setSelectedPageByID(this.masteryPage.pageID);
         this.player.masteryPage = this.masteryPage;
         complete();
      }
   }
}

