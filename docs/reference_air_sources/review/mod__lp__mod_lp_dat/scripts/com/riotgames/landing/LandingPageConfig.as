package com.riotgames.landing
{
   public class LandingPageConfig
   {
      
      public var resourcesPath:String;
      
      public var aggregatorUrl:String;
      
      public var realm:String;
      
      public var imageRoot:String;
      
      public var baseUrl:String;
      
      public var featuredGamesUrl:String;
      
      public var championData:Object;
      
      public var observerModeEnabled:Boolean = false;
      
      public function LandingPageConfig()
      {
         super();
         this.aggregatorUrl = "http://ll.leagueoflegends.com/landingpage/data/";
         this.imageRoot = "app:/assets/storeImages/";
         this.realm = "na";
         this.resourcesPath = "landingPageResources_{locale}.swf";
      }
   }
}

