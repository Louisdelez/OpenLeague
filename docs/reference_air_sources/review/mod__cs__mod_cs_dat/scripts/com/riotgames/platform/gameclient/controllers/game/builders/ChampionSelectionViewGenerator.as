package com.riotgames.platform.gameclient.controllers.game.builders
{
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSelectionView;
   import com.riotgames.platform.gameclient.controllers.game.views.IChampionSelectionView;
   import com.riotgames.platform.gameclient.controllers.game.views.SpectatorChampionSelectionView;
   
   public class ChampionSelectionViewGenerator
   {
      
      public function ChampionSelectionViewGenerator()
      {
         super();
      }
      
      public static function generateView(param1:ChampionSelectionModel) : IChampionSelectionView
      {
         var _loc2_:IChampionSelectionView = null;
         if(param1.isSpectating)
         {
            _loc2_ = generateSpectatorView();
         }
         else
         {
            _loc2_ = generatePlayerView();
         }
         return _loc2_;
      }
      
      public static function generatePlayerView() : IChampionSelectionView
      {
         return new ChampionSelectionView();
      }
      
      public static function generateSpectatorView() : IChampionSelectionView
      {
         return new SpectatorChampionSelectionView();
      }
   }
}

