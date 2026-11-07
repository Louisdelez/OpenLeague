package com.riotgames.landing
{
   import blix.context.IContext;
   
   public interface ILandingPageContext extends IContext
   {
      
      function getConfig() : LandingPageConfig;
      
      function navigateViaJson(param1:String) : void;
      
      function spectateFeaturedGame(param1:FeaturedGame) : void;
      
      function ready() : void;
   }
}

