package com.riotgames.pvpnet.celebration
{
   import blix.context.IContext;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.celebration.views.CelebrationDialog;
   import com.riotgames.pvpnet.celebration.views.FirstTimeLeaverDialogue;
   import com.riotgames.pvpnet.celebration.views.ICelebrationDialog;
   import com.riotgames.pvpnet.celebration.views.SummonerIconCeremonyDialogue;
   import com.riotgames.pvpnet.celebration.views.TierPromotionDialog;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.net.URLRequest;
   
   public class CelebrationDialogFactory extends RiotModuleView
   {
      
      public function CelebrationDialogFactory(param1:IContext, param2:RiotModuleInfo)
      {
         super(param1);
         loadAssets(new URLRequest(param2.getPath() + "assets/celebrationAssets.swf"));
      }
      
      public function getCelebrationDialog() : ICelebrationDialog
      {
         return new CelebrationDialog(this);
      }
      
      public function getTeamBuilderCelebrationDialog() : ICelebrationDialog
      {
         return new SummonerIconCeremonyDialogue(this);
      }
      
      public function getTierPromotionDialog() : TierPromotionDialog
      {
         return new TierPromotionDialog(this);
      }
      
      public function getFirstTimeLeaverDialogue() : ICelebrationDialog
      {
         return new FirstTimeLeaverDialogue(this);
      }
   }
}

