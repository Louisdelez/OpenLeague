package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.InventoryService;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertErrorAction;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.Fault;
   import mx.rpc.events.ResultEvent;
   
   public class RuneCombinerDelegate
   {
      
      private var onRuneCombinerNotAvailable:Function;
      
      private var _alerter:IAlerterProvider;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var onRuneCombinerReady:Function;
      
      private var _inventoryService:InventoryService;
      
      private var onRuneCombineSuccess:Function;
      
      private var onRuneCombineError:Function;
      
      private var _isBusy:Boolean = false;
      
      private var _runesToCombine:ArrayCollection;
      
      private var _combinerList:ArrayCollection = null;
      
      public function RuneCombinerDelegate(param1:InventoryService, param2:IAlerterProvider, param3:Function)
      {
         super();
         if(!param2 || !param1)
         {
            throw new Error("RuneCombinerDelegate requires an InventoryService and Alerter");
         }
         this.onRuneCombinerNotAvailable = param3;
         this.inventoryService = param1;
         this.alerter = param2;
      }
      
      public function combineRunes(param1:ArrayCollection, param2:Function, param3:Function) : void
      {
         this.onRuneCombineSuccess = param2;
         this.onRuneCombineError = param3;
         if(!(param1 && param1.length > 0))
         {
            return;
         }
         if(this.combinerList == null)
         {
            this._runesToCombine = param1;
            return;
         }
         var _loc4_:int = -1;
         var _loc5_:Rune = param1.getItemAt(0) as Rune;
         var _loc6_:int = int(_loc5_.tier);
         _loc4_ = int(RuneBookUtils.getRuneCombiner(_loc6_,param1,this.combinerList));
         this.useRuneCombiner(_loc4_,param1,this.onUseRuneCombinerComplete,this.onUseRuneCombinerSuccess,this.onUseRuneCombinerError);
      }
      
      public function get isBusy() : Boolean
      {
         return this._isBusy;
      }
      
      public function onGetAllRuneCombinersSuccess(param1:ResultEvent) : void
      {
         this._isBusy = false;
         this.combinerList = param1.result as ArrayCollection;
         this.combineRunes(this.runesToCombine,this.onRuneCombineSuccess,this.onRuneCombineError);
         this.onRuneCombinerNotAvailable = null;
      }
      
      public function get alerter() : IAlerterProvider
      {
         return this._alerter;
      }
      
      public function onGetAllRuneCombinersError() : void
      {
         if(this.onRuneCombinerNotAvailable != null)
         {
            this.onRuneCombinerNotAvailable();
            this.onRuneCombinerNotAvailable = null;
         }
      }
      
      public function onUseRuneCombinerComplete(param1:Boolean) : void
      {
      }
      
      public function get combinerList() : ArrayCollection
      {
         return this._combinerList;
      }
      
      public function set alerter(param1:IAlerterProvider) : void
      {
         this._alerter = param1;
      }
      
      public function onUseRuneCombinerSuccess(param1:ResultEvent) : void
      {
         var _loc2_:ArrayCollection = null;
         this._isBusy = false;
         if(Boolean(param1) && param1.result is ArrayCollection)
         {
            _loc2_ = param1.result as ArrayCollection;
            this._runesToCombine = null;
            if(this.onRuneCombineSuccess != null)
            {
               this.onRuneCombineSuccess(_loc2_);
            }
            return;
         }
         throw new Fault("","onUseRuneCombinerSuccess: Unexpected result");
      }
      
      public function get runesToCombine() : ArrayCollection
      {
         return this._runesToCombine;
      }
      
      public function useRuneCombiner(param1:int, param2:ArrayCollection, param3:Function, param4:Function, param5:Function) : Boolean
      {
         if(Boolean(param1 > 0) && Boolean(param2) && param2.length > 0)
         {
            this._isBusy = true;
            this.inventoryService.useRuneCombiner(param1,param2,param3,param4,param5);
            return true;
         }
         return false;
      }
      
      public function setBusy(param1:Boolean) : void
      {
         this._isBusy = param1;
      }
      
      public function onUseRuneCombinerError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:AlertAction = null;
         var _loc4_:IResourceManager = null;
         var _loc5_:String = null;
         this._runesToCombine = null;
         this._isBusy = false;
         if(Boolean(param1) && Boolean(param1.errorCode))
         {
            _loc4_ = ResourceManager.getInstance();
            _loc5_ = "";
            if(_loc4_)
            {
               _loc5_ = _loc4_.getString("resources","runeCombiner_combineErrorTitle");
            }
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = new AlertAction(_loc5_,_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
            _loc3_.add();
         }
         else
         {
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = new AlertErrorAction(_loc2_.getString("resources","runeCombiner_combineErrorTitle"),"",_loc2_.getString("resources","runeCombiner_combineGenericError"));
            _loc3_.add();
         }
         if(Boolean(param1) && Boolean(this.logger))
         {
            if(param1.exception)
            {
               this.logger.error("Rune Combiner error:" + param1.errorCode + " : " + param1.exception.toString());
            }
            else
            {
               this.logger.error("Rune Combiner error:" + param1.errorCode + " : " + "unspecified");
            }
         }
         else if(this.logger)
         {
            this.logger.error("Rune Combiner error: unknown error");
         }
         if(this.onRuneCombineError != null)
         {
            this.onRuneCombineError();
         }
      }
      
      public function set combinerList(param1:ArrayCollection) : void
      {
         if(this._combinerList == param1)
         {
            return;
         }
         this._combinerList = param1;
      }
      
      public function set inventoryService(param1:InventoryService) : void
      {
         this._inventoryService = param1;
      }
      
      public function get inventoryService() : InventoryService
      {
         return this._inventoryService;
      }
      
      public function getAllRuneCombiners() : void
      {
         this._isBusy = true;
         this.inventoryService.getAllRuneCombiners(this.onGetAllRuneCombinersSuccess,null,this.onGetAllRuneCombinersError);
      }
   }
}

