package com.riotgames.landing.onsale
{
   import flash.net.URLRequest;
   
   public class ItemPanelModel
   {
      
      public var imageUrl:String;
      
      public var title:String;
      
      public var subTitle:String;
      
      public var rpOriginalCost:Number;
      
      public var ipOriginalCost:Number;
      
      public var rpCost:Number;
      
      public var ipCost:Number;
      
      public var infoUrlRequest:URLRequest;
      
      public var buyUrlRequest:URLRequest;
      
      public var saleDiscount:String;
      
      public var saleEndDate:Date;
      
      public function ItemPanelModel()
      {
         super();
      }
   }
}

