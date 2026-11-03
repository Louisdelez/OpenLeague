package com.riotgames.landing.featured
{
   import flash.net.URLRequest;
   
   public class FeaturedPanelModel
   {
      
      public var imageUrlRequest:URLRequest;
      
      public var clickUrlRequest:URLRequest;
      
      public var startTime:Date;
      
      public var endTime:Date;
      
      public function FeaturedPanelModel()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[FeaturedPanelModel imageUrl=\'" + this.imageUrlRequest.url + "\']";
      }
   }
}

