package com.riotgames.landing.news
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import com.riotgames.landing.news.newsitem.NewsItem;
   import com.riotgames.landing.news.newsitem.NewsItemModel;
   
   public class NewsContent extends SpriteProxy
   {
      
      private var _model:NewsListModel;
      
      private var _maxNewsItems:uint = 3;
      
      private var _newsItemLinkage:String = "assets.NewsItemAsset";
      
      private var newsItems:Vector.<NewsItem> = new Vector.<NewsItem>();
      
      private var newsItemLayout:LayoutContainer;
      
      public function NewsContent(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.newsItemLayout = new LayoutContainer(this);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(2);
         this.newsItemLayout.setLayoutAlgorithm(_loc1_);
      }
      
      public function setModel(param1:NewsListModel) : void
      {
         var _loc2_:NewsItem = null;
         var _loc3_:uint = 0;
         var _loc4_:NewsItemModel = null;
         var _loc5_:NewsItem = null;
         if(this._model != null)
         {
            for each(_loc2_ in this.newsItems)
            {
               removeChild(_loc2_);
               _loc2_.destroy();
            }
            this.newsItemLayout.removeAllElements();
            this.newsItems.length = 0;
         }
         this._model = param1;
         if(this._model != null)
         {
            _loc3_ = 0;
            for each(_loc4_ in this._model.newsItems)
            {
               _loc5_ = new NewsItem(this);
               _loc5_.setLinkage(this._newsItemLinkage);
               _loc5_.setModel(_loc4_);
               _loc5_.setVisible(_loc3_ < this._maxNewsItems);
               addChild(_loc5_);
               this.newsItems[_loc3_] = _loc5_;
               this.newsItemLayout.addElement(_loc5_);
               _loc3_++;
            }
         }
      }
      
      public function getMaxNewsItems() : uint
      {
         return this._maxNewsItems;
      }
      
      public function setMaxNewsItems(param1:uint) : void
      {
         var _loc3_:NewsItem = null;
         if(this._maxNewsItems == param1)
         {
            return;
         }
         this._maxNewsItems = param1;
         var _loc2_:uint = 0;
         for each(_loc3_ in this.newsItems)
         {
            _loc3_.setVisible(_loc2_ < this._maxNewsItems);
            _loc2_++;
         }
      }
      
      public function getNewsItemLinkage() : String
      {
         return this._newsItemLinkage;
      }
      
      public function setNewsItemLinkage(param1:String) : void
      {
         var _loc2_:NewsItem = null;
         if(this._newsItemLinkage == param1)
         {
            return;
         }
         this._newsItemLinkage = param1;
         for each(_loc2_ in this.newsItems)
         {
            _loc2_.setLinkage(this._newsItemLinkage);
         }
      }
   }
}

