package com.riotgames.pvpnet.game.controllers.contextalert
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.contextAlert.AlertParser;
   
   public class StoreAlertParser extends AlertParser
   {
      
      private var inventoryController:IInventoryController;
      
      private var session:Session;
      
      public function StoreAlertParser(param1:IInventoryController, param2:Session, param3:Function)
      {
         super(param3);
         this.inventoryController = param1;
         this.session = param2;
      }
      
      override protected function fillCommandDictionary() : void
      {
         super.fillCommandDictionary();
         commandDictionary["minIP"] = this.handleMinIP;
         commandDictionary["storeAlert"] = this.handleNewStoreAlert;
         commandDictionary["minRunes"] = this.handleMinRunes;
         commandDictionary["maxRunes"] = this.handleMaxRunes;
         commandDictionary["minChampions"] = this.handleMinChampions;
         commandDictionary["maxChampions"] = this.handleMaxChampions;
         commandDictionary["minLevel"] = this.handleMinLevel;
      }
      
      private function handleMinIP(param1:XML) : Boolean
      {
         var _loc2_:int = int(getInt(param1));
         return this.inventoryController.inventory.lastIpPoints < _loc2_ && this.inventoryController.inventory.influencePoints >= _loc2_;
      }
      
      private function handleMinRunes(param1:XML) : Boolean
      {
         var _loc2_:int = int(getInt(param1));
         var _loc3_:int = int(getInt(param1,"tier"));
         if(_loc3_ <= 0 && _loc3_ > 3)
         {
            this.error("expected Rune Tier between 1 and 3, but got: " + _loc3_,param1);
         }
         return this.inventoryController.getRuneCount(_loc3_) >= _loc2_;
      }
      
      private function handleMaxRunes(param1:XML) : Boolean
      {
         var _loc2_:int = int(getInt(param1));
         var _loc3_:int = int(getInt(param1,"tier"));
         if(_loc3_ <= 0 && _loc3_ > 3)
         {
            this.error("expected Rune Tier between 1 and 3, but got: " + _loc3_,param1);
         }
         return this.inventoryController.getRuneCount(_loc3_) <= _loc2_;
      }
      
      private function handleMinChampions(param1:XML) : Boolean
      {
         var _loc2_:int = int(getInt(param1));
         return this.inventoryController.getAvailableChampionCount(false) >= _loc2_;
      }
      
      private function handleMaxChampions(param1:XML) : Boolean
      {
         var _loc2_:int = int(getInt(param1));
         return this.inventoryController.getAvailableChampionCount(false) <= _loc2_;
      }
      
      private function handleMinLevel(param1:XML) : Boolean
      {
         var _loc2_:int = int(getInt(param1));
         return this.session.summonerLevel.summonerLevel >= _loc2_;
      }
      
      private function handleNewStoreAlert(param1:XML) : Boolean
      {
         return true;
      }
   }
}

