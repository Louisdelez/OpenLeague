package com.riotgames.championdetails
{
   import com.riotgames.championdetails.dao.IChampionDetailsDao;
   import com.riotgames.gameItems.dao.IGameItemDao;
   import com.riotgames.store.dao.IStoreCatalogDao;
   
   public class CDPServices
   {
      
      public var championDetailsDao:IChampionDetailsDao;
      
      public var storeCatalogDao:IStoreCatalogDao;
      
      public var gameItemDao:IGameItemDao;
      
      public function CDPServices()
      {
         super();
      }
   }
}

