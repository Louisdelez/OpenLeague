package com.riotgames.platform.gameclient.controllers.game.views.mutators
{
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSelectionView;
   
   public interface IChampionSelectionMutatorSupport
   {
      
      function mutateChampionSelectionView(param1:ChampionSelectionView, param2:IContext, param3:ChampionSelectionModel) : void;
   }
}

