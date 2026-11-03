package com.riotgames.util.url
{
   import flash.net.URLVariables;
   
   public class UrlVo
   {
      
      public var urlVariables:URLVariables = new URLVariables();
      
      public var baseUrl:String;
      
      public function UrlVo(param1:String = null)
      {
         super();
         if(param1)
         {
            this.parseUrl(param1);
         }
      }
      
      public function parseUrl(param1:String) : void
      {
         var _loc2_:int = param1.indexOf("?");
         if(_loc2_ != -1)
         {
            this.urlVariables = new URLVariables(param1.substring(_loc2_ + 1));
            this.baseUrl = param1.substring(0,_loc2_);
         }
         else
         {
            this.urlVariables = new URLVariables();
            this.baseUrl = param1;
         }
      }
      
      public function clone() : UrlVo
      {
         var _loc2_:String = null;
         var _loc1_:UrlVo = new UrlVo();
         _loc1_.baseUrl = this.baseUrl;
         if(Boolean(this.urlVariables))
         {
            _loc1_.urlVariables = new URLVariables();
            for(_loc2_ in this.urlVariables)
            {
               _loc1_.urlVariables[_loc2_] = this.urlVariables[_loc2_];
            }
         }
         return _loc1_;
      }
      
      public function appendQuery(param1:URLVariables) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            this.urlVariables[_loc2_] = param1[_loc2_];
         }
      }
      
      public function toUrl() : String
      {
         if(!this.baseUrl)
         {
            return null;
         }
         var _loc1_:String = this.urlVariables.toString();
         if(!_loc1_)
         {
            return this.baseUrl;
         }
         return this.baseUrl + "?" + this.urlVariables.toString();
      }
   }
}

