package com.riotgames.landing.news.newsitem
{
   import blix.components.button.ButtonX;
   import blix.components.loader.ImageX;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.util.callback.preventRepeatedCalls;
   import com.riotgames.landing.navigate;
   import flash.events.MouseEvent;
   
   public class NewsItem extends ButtonX
   {
      
      protected var _model:NewsItemModel;
      
      protected var title:Text;
      
      protected var content:Text;
      
      protected var imageLoader:ImageX;
      
      public function NewsItem(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.title = new Text(this);
         setTimelineChildByName("titleText",this.title);
         this.content = new Text(this);
         setTimelineChildByName("contentText",this.content);
         this.imageLoader = new ImageX(this);
         setTimelineChildByName("imageHolder",this.imageLoader);
         addEventListener(MouseEvent.CLICK,this.newsItemClickHandler);
      }
      
      private function newsItemClickHandler(param1:MouseEvent) : void
      {
         if(preventRepeatedCalls(this.newsItemClickHandler,[param1],2000))
         {
            return;
         }
         if(this._model == null)
         {
            return;
         }
         navigate(this,this._model.clickUrlRequest);
      }
      
      public function getModel() : NewsItemModel
      {
         return this._model;
      }
      
      public function setModel(param1:NewsItemModel) : void
      {
         if(this._model != null)
         {
            this.title.setText(null);
            this.content.setText(null);
         }
         this._model = param1;
         if(this._model != null)
         {
            this.title.setText(this._model.title);
            this.content.setText(this._model.content);
            if(this._model.imageRequest != null)
            {
               this.imageLoader.load(this._model.imageRequest);
            }
         }
      }
   }
}

