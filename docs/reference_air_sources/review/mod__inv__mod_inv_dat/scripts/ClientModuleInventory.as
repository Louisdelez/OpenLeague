package
{
   import blix.signals.ISignal;
   import blix.signals.OnceSignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IRerollProvider;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.gameclient.domain.inventory.ChampionDelegate;
   import com.riotgames.platform.gameclient.domain.inventory.FullfillmentDelegate;
   import com.riotgames.platform.gameclient.domain.inventory.Inventory;
   import com.riotgames.platform.gameclient.domain.inventory.InventoryController;
   import com.riotgames.platform.gameclient.domain.inventory.RuneBookController;
   import com.riotgames.platform.gameclient.domain.inventory.reroll.RerollProvider;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import flash.events.Event;
   import mx.modules.ModuleBase;
   
   public class ClientModuleInventory extends ModuleBase implements IProviderModule, IInventoryProvider
   {
      
      private var _inventoryController:IInventoryController;
      
      private var _inventory:Inventory;
      
      private var _inventoryInitialized:Signal = new OnceSignal();
      
      public function ClientModuleInventory()
      {
         super();
      }
      
      public function getInventoryController() : IInventoryController
      {
         return this._inventoryController;
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._inventory = new Inventory();
         this._inventory.addEventListener("inventoryInitialized",this.onInventoryInitialized);
         var _loc2_:RuneBookController = new RuneBookController(this._inventory);
         var _loc3_:ChampionDelegate = new ChampionDelegate(this._inventory);
         var _loc4_:FullfillmentDelegate = new FullfillmentDelegate(this._inventory,_loc2_);
         var _loc5_:RerollProvider = new RerollProvider();
         this._inventoryController = new InventoryController(this._inventory,_loc2_,_loc3_,_loc4_);
         ProviderLookup.publishProvider(IRuneBookController,_loc2_);
         ProviderLookup.publishProvider(IInventoryProvider,this);
         ProviderLookup.publishProvider(IRerollProvider,_loc5_);
      }
      
      public function getInventory() : IInventory
      {
         return this._inventory;
      }
      
      public function getInventoryInitialized() : ISignal
      {
         return this._inventoryInitialized;
      }
      
      private function onInventoryInitialized(param1:Event) : void
      {
         this._inventoryInitialized.dispatch();
      }
   }
}

