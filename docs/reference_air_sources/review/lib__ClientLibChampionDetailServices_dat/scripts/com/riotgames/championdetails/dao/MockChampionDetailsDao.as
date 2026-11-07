package com.riotgames.championdetails.dao
{
   import blix.action.XmlLoaderAction;
   import blix.util.xml.XMLUtils;
   import flash.net.URLRequest;
   
   public class MockChampionDetailsDao implements IChampionDetailsDao
   {
      
      public function MockChampionDetailsDao()
      {
         super();
      }
      
      public function getChampionInfoById(param1:int, param2:Function, param3:Function) : void
      {
         var action:XmlLoaderAction = null;
         var championId:int = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         action = new XmlLoaderAction(new URLRequest("mockData/championInfo.txt"));
         action.getCompleted().addOnce(function():void
         {
            successHandler(XMLUtils.unmarshal(action.xml));
         });
         action.getErred().addOnce(function():void
         {
            failHandler(action.getError());
         });
         action.invoke();
      }
   }
}

