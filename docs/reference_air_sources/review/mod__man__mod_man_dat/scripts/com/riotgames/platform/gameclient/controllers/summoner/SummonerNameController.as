package com.riotgames.platform.gameclient.controllers.summoner
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.domain.inventory.InventoryType;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import com.riotgames.platform.gameclient.domain.summoner.customization.SummonerCustomizationDTO;
   import com.riotgames.platform.gameclient.domain.summoner.customization.SummonerCustomizationType;
   import com.riotgames.platform.gameclient.domain.summoner.customization.SummonerNameChangeDTO;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class SummonerNameController
   {
      
      private var pendingName:String;
      
      public var applicationController:IAppController;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var proxiedOnComplete:Function;
      
      public var session:Session = Session.instance;
      
      public var inventoryController:IInventoryController;
      
      public var wordFilter:WordFilter = WordFilter.instance;
      
      [Inject]
      public var viewMediator:ViewMediator;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var proxiedOnError:Function;
      
      public function SummonerNameController(param1:IInventoryController = null)
      {
         super();
         this.inventoryController = param1;
         if(!param1)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         }
      }
      
      private function onRenameSummonerSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.result);
         if(_loc2_)
         {
            this.renameSummoner(this.pendingName,true);
         }
         else if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[]);
            this.proxiedOnError = null;
         }
      }
      
      private function onServiceComplete(param1:Boolean) : void
      {
         if(this.proxiedOnComplete != null)
         {
            this.proxiedOnComplete.apply(null);
            this.proxiedOnComplete = null;
         }
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventoryController = param1.getInventoryController();
      }
      
      private function onServiceError(param1:ServerError) : void
      {
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[param1]);
         }
         this.proxiedOnError = null;
      }
      
      public function createDefaultSummoner(param1:String, param2:Function, param3:Function) : void
      {
         this.proxiedOnComplete = param2;
         this.proxiedOnError = param3;
         if(!this.validateSummonerName(param1))
         {
            return;
         }
         this.serviceProxy.summonerService.createDefaultSummoner(param1,this.onCreateDefaultSummonerSuccess,this.onServiceComplete,this.onServiceError);
      }
      
      public function processStoreFulfillmentNotification(param1:StoreFulfillmentNotification) : void
      {
         var _loc2_:SummonerCustomizationDTO = null;
         var _loc3_:String = null;
         var _loc4_:SummonerNameChangeDTO = null;
         if(param1.inventoryType == InventoryType.SUMMONER_CUSTOMIZATION)
         {
            _loc2_ = param1.data as SummonerCustomizationDTO;
            _loc3_ = _loc2_.getCustomizationType();
            if(SummonerCustomizationType.NAME_CHANGE == _loc3_)
            {
               _loc4_ = _loc2_ as SummonerNameChangeDTO;
               UserPreferencesManager.instance.saveUserPreferences(_loc4_.newName);
               this.viewMediator.showExitAlert("session_sessionSummonerNameChangeMessage","session_sessionSummonerNameChangeTitle");
            }
            else
            {
               this.logger.warn("Inventory.handleSummonerCustomizationFulfillment: Unknown customization type: " + _loc3_);
            }
         }
      }
      
      public function renameSummoner(param1:String, param2:Boolean = false) : void
      {
         this.session.summoner.name = param1;
         this.applicationController.onSummonerRenamed(param2);
      }
      
      private function validateSummonerName(param1:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(this.wordFilter.containsOffensiveWords(param1,true))
         {
            this.applyError(MessageDictionary.SUMMONER_NAME_CONTAINS_OFFENSIVE_WORDS);
            return false;
         }
         if(this.wordFilter.containsRestrictedWords(param1,true))
         {
            this.applyError(MessageDictionary.SUMMONER_NAME_CONTAINS_RESTRICTED_WORDS);
            return false;
         }
         var _loc2_:Array = this.wordFilter.getInvalidCharacters(param1);
         if(_loc2_)
         {
            _loc3_ = "";
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ += _loc2_[_loc4_];
               if(_loc4_ < _loc2_.length - 1 && _loc2_.length > 1)
               {
                  _loc3_ += ", ";
               }
               _loc4_++;
            }
            this.applyError(MessageDictionary.SUMMONER_NAME_CONTAINS_INVALID_CHARS,[_loc3_]);
            return false;
         }
         return true;
      }
      
      private function onCreateDefaultSummonerSuccess(param1:ResultEvent) : void
      {
         var _loc2_:AllSummonerData = AllSummonerData(param1.result);
         if(_loc2_ != null)
         {
            this.session.summoner = _loc2_.summoner;
            this.session.summonerLevelAndPoints = _loc2_.summonerLevelAndPoints;
            this.session.summonerLevel = _loc2_.summonerLevel;
            this.session.summonerDefaultSpells = _loc2_.summonerDefaultSpells;
            this.session.summonerTalentsAndPoints = _loc2_.summonerTalentsAndPoints;
            this.applicationController.onSummonerCreated();
            this.inventoryController.loadUserInventory();
         }
         else if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[]);
            this.proxiedOnError = null;
         }
      }
      
      private function applyError(param1:String, param2:Array = null) : void
      {
         var _loc3_:ServerError = new ServerError(null);
         _loc3_.errorCode = param1;
         _loc3_.messageArguments = param2;
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[_loc3_]);
         }
         if(this.proxiedOnComplete != null)
         {
            this.proxiedOnComplete.apply(null);
         }
      }
      
      public function renameSummonerOnLogin(param1:String, param2:Function, param3:Function) : void
      {
         this.pendingName = param1;
         this.proxiedOnComplete = param2;
         this.proxiedOnError = param3;
         if(!this.validateSummonerName(param1))
         {
            return;
         }
         this.serviceProxy.summonerService.playerChangeSummonerName(this.session.summoner.sumId,param1,this.onRenameSummonerSuccess,this.onServiceComplete,this.onServiceError);
      }
   }
}

