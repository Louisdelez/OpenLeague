package com.riotgames.landing.news.bannerscroller.thumb
{
   import blix.assets.proxy.NewsPanel.BannerScroller.BannerThumbAsset;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.loader.ImageX;
   import blix.context.IContext;
   import com.riotgames.landing.news.bannerscroller.BannerItemModel;
   import flash.geom.Rectangle;
   import flash.system.LoaderContext;
   
   public class BannerThumb extends ButtonX
   {
      
      public static const IMAGE_HEIGHT:uint = 48;
      
      protected var _model:BannerItemModel;
      
      public var thumbLoader:ImageX;
      
      public var sizer:SpriteProxy;
      
      public function BannerThumb(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:BannerThumbAsset = new BannerThumbAsset();
         this.sizer = _loc1_.sizer.create(this);
         this.sizer.getLayoutInvalidated().add(invalidateLayout);
         this.thumbLoader = new ImageX(this);
         setTimelineChild(_loc1_.contentContainerAsset,this.thumbLoader);
      }
      
      public function getModel() : BannerItemModel
      {
         return this._model;
      }
      
      public function setModel(param1:BannerItemModel) : void
      {
         var _loc2_:LoaderContext = null;
         if(this._model != null)
         {
            this.thumbLoader.unload();
         }
         this._model = param1;
         if(this._model != null)
         {
            _loc2_ = new LoaderContext();
            _loc2_.checkPolicyFile = true;
            this.thumbLoader.load(this._model.thumbUrlRequest,_loc2_);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.thumbLoader.setExplicitSize(this.sizer.getWidth(),this.sizer.getHeight());
         return new Rectangle(0,0,this.sizer.getWidth(),this.sizer.getHeight());
      }
      
      override public function destroy() : void
      {
         this.setModel(null);
         super.destroy();
      }
   }
}

