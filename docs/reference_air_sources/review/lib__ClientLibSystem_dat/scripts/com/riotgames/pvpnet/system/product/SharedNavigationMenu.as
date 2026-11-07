package com.riotgames.pvpnet.system.product
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   
   public class SharedNavigationMenu
   {
      
      public static var menuItems:Vector.<NavigationMenuListItem>;
      
      private static var navigationItems:Array = [{
         "labelKey":"summoner_summonerInfo_profileLabel",
         "navigation":"/profile"
      },{
         "labelKey":"summonerProfile_page_match_history",
         "navigation":"/matchHistory"
      }];
      
      public function SharedNavigationMenu()
      {
         super();
      }
      
      public static function initialize() : void
      {
         var _loc1_:Object = null;
         menuItems = new Vector.<NavigationMenuListItem>();
         for each(_loc1_ in navigationItems)
         {
            menuItems.push(new NavigationMenuListItem(RiotResourceLoader.getString(_loc1_.labelKey,"NavigationItem"),_loc1_.navigation));
         }
      }
   }
}

