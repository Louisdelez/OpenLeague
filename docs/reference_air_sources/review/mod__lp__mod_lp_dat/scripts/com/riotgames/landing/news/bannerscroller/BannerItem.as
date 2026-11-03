package com.riotgames.landing.news.bannerscroller
{
   import blix.assets.proxy.NewsPanel.BannerScroller.BannerItemAsset;
   import blix.components.loader.ImageX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   
   public class BannerItem extends StatefulView
   {
      
      protected static const HIDE_STATE:String = "hide";
      
      protected static const SHOW_STATE:String = "show";
      
      private var _model:BannerItemModel;
      
      private var _hasBegunLoading:Boolean;
      
      public var image:ImageX;
      
      public var title:Text;
      
      public var subTitle:Text;
      
      public function BannerItem(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:BannerItemAsset = new BannerItemAsset();
         this.subTitle = new Text(this);
         setTimelineChild(_loc1_.inner.subTitleAsset,this.subTitle);
         this.title = new Text(this);
         setTimelineChild(_loc1_.inner.titleAsset,this.title);
         this.image = new ImageX(this);
         setTimelineChild(_loc1_.inner.contentContainerAsset,this.image);
         this.hide();
      }
      
      public function getModel() : BannerItemModel
      {
         return this._model;
      }
      
      public function setModel(param1:BannerItemModel) : void
      {
         if(this._model == param1)
         {
            return;
         }
         if(this._model != null)
         {
            this.image.unload();
            this.title.setText(null);
            this.subTitle.setText(null);
         }
         this._model = param1;
         if(this._model != null)
         {
            this.title.setText(this._model.title);
            this.subTitle.setText(this._model.subTitle);
         }
      }
      
      public function beginLoad() : void
      {
         if(this._hasBegunLoading)
         {
            return;
         }
         this._hasBegunLoading = true;
         this.image.load(this._model.imageUrlRequest);
      }
      
      public function show() : void
      {
         setWeight(1);
         setCurrentState(SHOW_STATE);
      }
      
      public function hide() : void
      {
         setWeight(-1);
         setCurrentState(HIDE_STATE);
      }
   }
}

