package com.riotgames.platform.gameclient.controllers.game.views.itemRenderers
{
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.pvpnet.championselection.views.ChampionSelectRenderer;
   import flash.events.MouseEvent;
   
   public class BannableChampionSelectRenderer extends ChampionSelectRenderer
   {
      
      public function BannableChampionSelectRenderer()
      {
         super();
      }
      
      override protected function handleRendererRollOver(param1:MouseEvent) : void
      {
         super.handleRendererRollOver(param1);
         var _loc2_:ParticipantChampionSelection = data as ParticipantChampionSelection;
         if(Boolean(borderOverlay) && !_loc2_.participant)
         {
            borderOverlay.banned.currentState = ChampionSelectRenderer.BANNED_STATE_ON;
         }
      }
      
      override protected function handleRendererRollOut(param1:MouseEvent) : void
      {
         super.handleRendererRollOut(param1);
         if(Boolean(data) && !data.banned)
         {
            borderOverlay.banned.currentState = ChampionSelectRenderer.BANNED_STATE_OFF;
         }
      }
   }
}

