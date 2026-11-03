package com.riotgames.platform.gameclient.controllers.game.views.mutators
{
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSelectionView;
   
   public class ChampionSelectionMutatorSupport implements IChampionSelectionMutatorSupport
   {
      
      private var skinRentalsMutatorSupport:IChampionSelectionMutatorSupport = new SkinRentalsMutatorSupport();
      
      public function ChampionSelectionMutatorSupport()
      {
         super();
      }
      
      public function mutateChampionSelectionView(param1:ChampionSelectionView, param2:IContext, param3:ChampionSelectionModel) : void
      {
         this.skinRentalsMutatorSupport.mutateChampionSelectionView(param1,param2,param3);
      }
   }
}

