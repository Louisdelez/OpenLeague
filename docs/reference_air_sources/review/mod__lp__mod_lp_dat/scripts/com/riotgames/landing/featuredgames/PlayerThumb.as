package com.riotgames.landing.featuredgames
{
   import blix.assets.proxy.FeaturedGamesSlider.PlayerThumbAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.loader.ImageX;
   import blix.context.Context;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class PlayerThumb extends SpriteProxy
   {
      
      private static const IMAGE_SIZE:uint = 59;
      
      private var image:ImageX;
      
      public function PlayerThumb(param1:Context)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:PlayerThumbAsset = new PlayerThumbAsset();
         this.image = new ImageX(this);
         setTimelineChild(_loc1_.imageContainerAsset,this.image);
         this.image.setVisible(false);
         this.image.setExplicitSize(IMAGE_SIZE,IMAGE_SIZE);
         this.image.getCompleted().add(this.showImage);
      }
      
      private function showImage() : void
      {
         this.image.setVisible(true);
      }
      
      public function loadImage(param1:String) : void
      {
         var _loc2_:LoaderContext = new LoaderContext();
         _loc2_.checkPolicyFile = true;
         if(param1)
         {
            this.image.load(new URLRequest(param1));
         }
      }
      
      public function unloadImage() : void
      {
         this.image.unload();
      }
      
      override public function destroy() : void
      {
         this.image.unload();
         super.destroy();
      }
   }
}

