package com.riotgames.landing.featuredgames
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.landing.FeaturedGame;
   import com.riotgames.pvpnet.game.domain.GameVersionConfig;
   
   public class FeaturedGamesModel
   {
      
      public var featuredGames:Vector.<FeaturedGame>;
      
      public var clientRefreshInterval:int;
      
      private var _currentIndex:int = 0;
      
      private var _patchWorkChanged:Signal = new Signal();
      
      public function FeaturedGamesModel()
      {
         super();
         GameVersionConfig.instance.getInstallingPatchChanged().add(this._patchWorkChanged.dispatch);
         GameVersionConfig.instance.getUninstallingPatchChanged().add(this._patchWorkChanged.dispatch);
      }
      
      public function getPatchWorkChanged() : ISignal
      {
         return this._patchWorkChanged;
      }
      
      public function getReplaysEnabled() : Boolean
      {
         return !GameVersionConfig.instance.installingPatch && !GameVersionConfig.instance.uninstallingPatch;
      }
      
      public function hasFeaturedGames() : Boolean
      {
         return Boolean(this.featuredGames) && this.featuredGames.length > 0;
      }
      
      public function getCurrentFeaturedGame() : FeaturedGame
      {
         return this.featuredGames[this._currentIndex];
      }
      
      public function getNextFeaturedGame() : FeaturedGame
      {
         this.getNextIndex();
         return this.getCurrentFeaturedGame();
      }
      
      public function get currentIndex() : int
      {
         return this._currentIndex;
      }
      
      public function getFeaturedGameByIndex(param1:int) : FeaturedGame
      {
         if(param1 >= 0 && param1 < this.featuredGames.length)
         {
            this._currentIndex = param1;
         }
         return this.getCurrentFeaturedGame();
      }
      
      public function getPrevFeaturedGame() : FeaturedGame
      {
         this.getPrevIndex();
         return this.getCurrentFeaturedGame();
      }
      
      public function getNextIndex() : int
      {
         ++this._currentIndex;
         if(this._currentIndex > this.featuredGames.length - 1)
         {
            this._currentIndex = 0;
         }
         return this._currentIndex;
      }
      
      public function getPrevIndex() : int
      {
         --this._currentIndex;
         if(this._currentIndex < 0)
         {
            this._currentIndex = this.featuredGames.length - 1;
         }
         return this._currentIndex;
      }
   }
}

