package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.common.domain.inventory.InventoryType;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.RuneQuantity;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.domain.store.RentalUpdateNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreAccountBalanceNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import com.riotgames.platform.gameclient.events.InventoryEvent;
   import com.riotgames.pvpnet.accountcreation.AccountCreationProviderProxy;
   import com.riotgames.pvpnet.accountcreation.IAccountCreationProvider;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   
   public class FullfillmentDelegate extends EventDispatcher
   {
      
      protected var accountCreationProvider:IAccountCreationProvider = AccountCreationProviderProxy.instance;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var inventory:IInventory;
      
      public var runeBookController:IRuneBookController;
      
      public function FullfillmentDelegate(param1:IInventory, param2:IRuneBookController)
      {
         super();
         this.inventory = param1;
         this.runeBookController = param2;
      }
      
      public function handleRuneBookPageFulfillment(param1:SpellBookDTO) : void
      {
         this.inventory.runeBook = param1;
         this.runeBookController.hydrateSpellBook(param1);
         RuneBookUtils.localizeRuneBook(this.inventory.runeBook);
      }
      
      public function processIpFulfillment(param1:int) : void
      {
         if(param1 >= 0)
         {
            this.inventory.lastIpPoints = this.inventory.influencePoints;
            this.inventory.influencePoints = param1;
         }
      }
      
      public function processAccountBalanceNotification(param1:StoreAccountBalanceNotification) : void
      {
         this.updateAccountBalance(param1.ip,param1.rp);
      }
      
      public function createFirstRuneAlert() : void
      {
         var _loc1_:AlertParameters = new AlertParameters();
         _loc1_.location = AlertLocation.PROFILE_BUTTON;
         _loc1_.title = "store_alert_title_congratulations";
         _loc1_.message = "store_alert_message_first_rune_purchased";
         dispatchEvent(new InventoryEvent(InventoryEvent.SHOW_ALERT,_loc1_));
      }
      
      public function processRpFulfillment(param1:int) : void
      {
         if(param1 >= 0)
         {
            this.inventory.riotPoints = param1;
         }
      }
      
      public function processStoreFulfillmentNotification(param1:StoreFulfillmentNotification) : void
      {
         this.updateAccountBalance(param1.ip,param1.rp);
         switch(param1.inventoryType)
         {
            case InventoryType.BOOST:
               this.handleActiveBoostsFulfillment(param1.data as ActiveBoosts);
               break;
            case InventoryType.CHAMPION:
               this.handleChampionFulfillment(param1.data as Champion);
               break;
            case InventoryType.CHAMPION_SKIN:
               this.handleChampionSkinFulfillment(param1.data as ChampionSkin);
               break;
            case InventoryType.RUNE:
               this.handleRuneQuantityFullfillment(param1.data as RuneQuantity);
               break;
            case InventoryType.GRAB_BAG:
               this.runeBookController.addRunesToInventory((param1.data as ArrayCollection).toArray());
               break;
            case InventoryType.SPELL_BOOK_PAGE:
               this.handleRuneBookPageFulfillment(param1.data as SpellBookDTO);
               break;
            case InventoryType.SUMMONER_ICON:
               this.handleSummonerIconFulfilment(param1.data,param1.notificationType);
               break;
            case InventoryType.IP:
            case InventoryType.RP:
            case InventoryType.UNKNOWN:
               this.logger.warn("Inventory.processStoreFulfillmentNotification: An unsupported store fulfillment notification of type " + param1.inventoryType + " was received.");
               dispatchEvent(new InventoryEvent(InventoryEvent.BAD_FULFILLMENT,param1.inventoryType));
         }
      }
      
      public function updateAccountBalance(param1:int, param2:int) : void
      {
         this.processIpFulfillment(param1);
         this.processRpFulfillment(param2);
         dispatchEvent(new InventoryEvent(InventoryEvent.ACCOUNT_BALANCE_UPDATED));
      }
      
      public function handleSummonerIconFulfilment(param1:Object, param2:String) : void
      {
         var refund:Boolean = false;
         var newIcon:Object = param1;
         var notificationType:String = param2;
         try
         {
            refund = notificationType != "fulfillment";
            this.accountCreationProvider.handleStoreIconFulfillment(newIcon.itemId,refund);
         }
         catch(e:*)
         {
            logger.error("Error invoking accountCreationProvider.handleStoreIconFulfillment.");
         }
      }
      
      public function handleActiveBoostsFulfillment(param1:ActiveBoosts) : void
      {
         this.inventory.activeBoosts = param1;
      }
      
      public function processRawFulfillment(param1:Object) : void
      {
         if(param1 is Champion)
         {
            this.handleChampionFulfillment(param1 as Champion);
         }
         else if(param1 is ChampionSkin)
         {
            this.handleChampionSkinFulfillment(param1 as ChampionSkin);
         }
         else
         {
            this.logger.error("Unknown raw fulfillment item");
            dispatchEvent(new InventoryEvent(InventoryEvent.BAD_FULFILLMENT,param1));
         }
      }
      
      public function handleChampionFulfillment(param1:Champion) : void
      {
         var _loc2_:Champion = InventoryUtils.findChampionById(param1.championId,this.inventory.championRegistry);
         if(_loc2_)
         {
            _loc2_.owned = param1.owned;
            _loc2_.purchaseDate = param1.purchaseDate;
            _loc2_.endDate = param1.endDate;
            _loc2_.winCountRemaining = param1.winCountRemaining;
            this.inventory.champions.refresh();
         }
      }
      
      public function processRentalUpdateNotification(param1:RentalUpdateNotification) : void
      {
         switch(param1.inventoryType)
         {
            case InventoryType.BOOST:
               this.handleActiveBoostsFulfillment(param1.data as ActiveBoosts);
               break;
            case InventoryType.CHAMPION:
               this.handleChampionFulfillment(param1.data as Champion);
               break;
            case InventoryType.CHAMPION_SKIN:
               this.handleChampionSkinFulfillment(param1.data as ChampionSkin);
         }
      }
      
      public function createChampIconAvailableAlert(param1:Number) : void
      {
         var _loc2_:AlertParameters = new AlertParameters();
         _loc2_.location = AlertLocation.SUMMONER_ICON;
         _loc2_.title = "store_alert_title_congratulations";
         _loc2_.message = "store_alert_summoner_icon_unlocked_skin_" + param1;
         dispatchEvent(new InventoryEvent(InventoryEvent.SHOW_ALERT,_loc2_));
      }
      
      public function handleChampionSkinFulfillment(param1:ChampionSkin) : void
      {
         var existingSkin:ChampionSkin = null;
         var skinIsAlreadyOwned:Boolean = false;
         var iconAlert:String = null;
         var ename:String = null;
         var championSkin:ChampionSkin = param1;
         var existingChamp:Champion = InventoryUtils.findChampionById(championSkin.championId,this.inventory.championRegistry);
         if(existingChamp != null)
         {
            existingSkin = existingChamp.getChampionSkin(championSkin.skinId);
            if(existingSkin != null)
            {
               skinIsAlreadyOwned = Boolean(existingSkin.owned);
               if(!skinIsAlreadyOwned)
               {
                  dispatchEvent(new InventoryEvent(InventoryEvent.SKIN_PURCHASE_PENDING,existingSkin));
               }
               existingSkin.owned = championSkin.owned;
               existingSkin.purchaseDate = championSkin.purchaseDate;
               existingSkin.endDate = championSkin.endDate;
               existingSkin.winCountRemaining = championSkin.winCountRemaining;
               existingChamp.championSkins.refresh();
               this.accountCreationProvider.requestLoadIcons();
               if(skinIsAlreadyOwned == false)
               {
                  iconAlert = ResourceManager.getInstance().getString("resources","store_alert_summoner_icon_unlocked_skin_" + existingSkin.skinId);
                  if(iconAlert != null)
                  {
                     this.createChampIconAvailableAlert(existingSkin.skinId);
                  }
               }
               try
               {
                  ename = "NAME HAS NOT BEEN LOCALIZED";
                  ename = existingSkin.name;
               }
               catch(er:Error)
               {
               }
            }
         }
      }
      
      public function handleRuneFulfillment(param1:SummonerRune) : void
      {
         this.inventory.summonerRuneInventory.addRune(param1);
      }
      
      public function handleRuneQuantityFullfillment(param1:RuneQuantity) : void
      {
         if(!this.inventory.summonerRuneInventory || !this.inventory.summonerRuneInventory.summonerRunes || this.inventory.summonerRuneInventory.summonerRunes.length == 0)
         {
            this.createFirstRuneAlert();
         }
         this.runeBookController.addRunesToInventory([param1]);
      }
   }
}

