package com.riotgames.platform.gameclient.summoner
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.PublicSummoner;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.rpc.events.ResultEvent;
   
   public class SummonerSearchController implements IEventDispatcher
   {
      
      private var _1715428172lastSearchSummoner:PublicSummoner;
      
      private var proxiedOnComplete:Function;
      
      private var proxiedOnError:Function;
      
      [Inject]
      public var summonerProfileController:SummonerProfileController;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var lastSearchSummonerName:String;
      
      public function SummonerSearchController()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      private function get lastSearchSummoner() : PublicSummoner
      {
         return this._1715428172lastSearchSummoner;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function isCurrentSummoner(param1:String) : Boolean
      {
         return this.summonerProfileController.summonerName == param1;
      }
      
      private function set lastSearchSummoner(param1:PublicSummoner) : void
      {
         var _loc2_:Object = this._1715428172lastSearchSummoner;
         if(_loc2_ !== param1)
         {
            this._1715428172lastSearchSummoner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastSearchSummoner",_loc2_,param1));
         }
      }
      
      public function searchForSummoner(param1:String, param2:Function, param3:Function) : void
      {
         this.proxiedOnError = param2;
         this.proxiedOnComplete = param3;
         this.lastSearchSummonerName = param1;
         this.serviceProxy.summonerService.getSummonerByName(param1,this.onGetSummonerByNameSuccess,this.onSummonerSearchComplete);
      }
      
      public function SummonerController() : void
      {
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      private function onSummonerSearchComplete(param1:Boolean) : void
      {
         if(this.proxiedOnComplete != null)
         {
            this.proxiedOnComplete(this.lastSearchSummoner);
         }
         this.proxiedOnError = null;
         this.proxiedOnComplete = null;
      }
      
      private function onGetSummonerByNameSuccess(param1:ResultEvent) : void
      {
         var _loc2_:ServerError = null;
         this.lastSearchSummoner = param1.result as PublicSummoner;
         if(this.lastSearchSummoner == null && this.proxiedOnError != null)
         {
            _loc2_ = new ServerError(null);
            _loc2_.errorCode = "summoner_search_summonerNotFoundInformationalMessage";
            _loc2_.messageArguments = [this.lastSearchSummonerName];
            this.proxiedOnError.apply(null,[_loc2_]);
         }
      }
   }
}

