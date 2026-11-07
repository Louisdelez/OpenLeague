package com.riotgames.landing.news.newsitem
{
   import flash.net.URLRequest;
   
   public class NewsItemModel
   {
      
      public var title:String;
      
      public var content:String;
      
      public var imageRequest:URLRequest;
      
      public var clickUrlRequest:URLRequest;
      
      public var date:Date = new Date();
      
      public function NewsItemModel()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[NewsItemModel title=" + this.title + "]";
      }
   }
}

