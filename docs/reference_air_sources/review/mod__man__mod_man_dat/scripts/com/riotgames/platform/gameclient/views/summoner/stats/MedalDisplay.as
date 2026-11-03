package com.riotgames.platform.gameclient.views.summoner.stats
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.rust.components.FlashFlexComponent;
   import com.riotgames.rust.context.RustContext;
   import flash.display.Sprite;
   
   public class MedalDisplay extends FlashFlexComponent
   {
      
      private var medalIcon:StatefulView;
      
      public function MedalDisplay()
      {
         var _loc1_:RustContext = new RustContext();
         _loc1_.loadAssets("../../assets/swfs/medals/medals.swf");
         super(_loc1_,"");
         this.medalIcon = new StatefulView(this._view);
         this.setMedal(LeagueTier.NULL,LeagueRank.DEFAULT);
         this.view.addChild(this.medalIcon);
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context,new Sprite());
      }
      
      private function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
      
      public function setMedal(param1:LeagueTier, param2:LeagueRank) : void
      {
         this.medalIcon.setLinkage(param1.value());
         this.medalIcon.setCurrentState(param2.value());
      }
   }
}

