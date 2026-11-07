package com.riotgames.platform.gameclient.buddyImages
{
   import com.riotgames.platform.common.ImagePackLookup;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class BuddyImages
   {
      
      private static var stockIcons:ArrayCollection;
      
      private static const STOCK_ICON_RANGE_BEGIN:int = 0;
      
      private static const STOCK_ICON_RANGE_END:int = 28;
      
      private static var loadedIcons:Dictionary = new Dictionary();
      
      private static var logger:ILogger = Log.getLogger("static");
      
      public static const TENCENT_COLLECTION:String = "Tencent";
      
      private static var _uniqueCollection:String = "";
      
      public function BuddyImages()
      {
         super();
      }
      
      public static function removeSummonerIcon(param1:int, param2:ArrayCollection) : void
      {
         var _loc3_:SummonerIconData = loadSummonerIcon(param1);
         if(_loc3_ != null && Boolean(param2.contains(_loc3_)))
         {
            param2.removeItemAt(param2.getItemIndex(_loc3_));
         }
      }
      
      public static function get uniqueCollection() : String
      {
         return _uniqueCollection;
      }
      
      public static function getBlockedIconSource() : Object
      {
         return ImagePackLookup.instance.getClassFromSwfRef("e_BlockedIcon");
      }
      
      public static function getBlockedIcon() : BitmapData
      {
         return ImagePackLookup.instance.getBitmapData("e_BlockedIcon");
      }
      
      public static function getSummonerIconSafely(param1:int) : BitmapData
      {
         var data:SummonerIconData = null;
         var iconId:int = param1;
         var bitmapData:BitmapData = null;
         try
         {
            data = loadSummonerIcon(iconId);
            if(data != null && data.iconSource != null)
            {
               bitmapData = data.iconSource;
            }
         }
         catch(e:Error)
         {
            bitmapData = ImagePackLookup.instance.getProfileIconData(0);
            logger.error("Failed to load stock icon " + iconId);
         }
         return bitmapData;
      }
      
      public static function getUnblockedIconSource() : Object
      {
         return ImagePackLookup.instance.getClassFromSwfRef("e_UnblockedIcon");
      }
      
      private static function initStockIcons() : void
      {
         var iconId:int = 0;
         var iconData:SummonerIconData = null;
         stockIcons = new ArrayCollection();
         iconId = STOCK_ICON_RANGE_BEGIN;
         try
         {
            while(iconId <= STOCK_ICON_RANGE_END)
            {
               iconData = loadSummonerIcon(iconId);
               if(iconData != null)
               {
                  stockIcons.addItem(iconData);
               }
               iconId++;
            }
         }
         catch(e:Error)
         {
            logger.error("Failed to load stock icon " + iconId);
         }
      }
      
      public static function getUnblockedIcon() : BitmapData
      {
         return ImagePackLookup.instance.getBitmapData("e_UnblockedIcon");
      }
      
      public static function set uniqueCollection(param1:String) : void
      {
         if(_uniqueCollection != param1)
         {
            _uniqueCollection = param1;
            initStockIcons();
         }
      }
      
      public static function addSummonerIcon(param1:int, param2:ArrayCollection) : void
      {
         var _loc3_:SummonerIconData = loadSummonerIcon(param1);
         if(_loc3_ != null && !param2.contains(_loc3_))
         {
            param2.addItemAt(_loc3_,0);
         }
      }
      
      private static function loadSummonerIcon(param1:int) : SummonerIconData
      {
         var _loc3_:BitmapData = null;
         var _loc2_:SummonerIconData = loadedIcons[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new SummonerIconData();
            _loc2_.iconId = param1;
            loadedIcons[param1] = _loc2_;
            _loc3_ = ImagePackLookup.instance.getProfileIconData(param1,uniqueCollection);
            if(_loc3_ != null)
            {
               logger.warn("Couldn\'t find stock icon: " + param1);
               _loc2_.iconSource = _loc3_;
            }
            else
            {
               _loc2_.iconSource = ImagePackLookup.instance.getProfileIconData(0,uniqueCollection);
            }
         }
         return _loc2_;
      }
      
      public static function buildUserIconList(param1:ArrayCollection = null) : ArrayCollection
      {
         var userIconList:ArrayCollection;
         var iconId:int = 0;
         var i:int = 0;
         var iconObjectData:Object = null;
         var iconData:SummonerIconData = null;
         var ownedIconIds:ArrayCollection = param1;
         if(stockIcons == null)
         {
            initStockIcons();
         }
         userIconList = new ArrayCollection();
         userIconList.addAll(stockIcons);
         if(ownedIconIds != null)
         {
            iconId = -1;
            try
            {
               i = 0;
               while(i < ownedIconIds.length)
               {
                  iconObjectData = ownedIconIds.getItemAt(i);
                  if(iconObjectData.hasOwnProperty("iconId"))
                  {
                     iconId = iconObjectData.iconId as int;
                     iconData = loadSummonerIcon(iconId);
                     if(iconData != null && !userIconList.contains(iconData))
                     {
                        userIconList.addItemAt(iconData,0);
                     }
                  }
                  i++;
               }
            }
            catch(e:Error)
            {
               logger.error("Failed to load stock icon " + iconId);
            }
         }
         return userIconList;
      }
   }
}

