package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryParser;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import mx.utils.Base64Encoder;
   
   public class MatchHistoryServiceAction extends BasicAction
   {
      
      public static const BASE_URL:String = "https://acs.leagueoflegends.com";
      
      public static const BASE_TEST_URL:String = "https://acs.test.leagueoflegends.com";
      
      public static const VERSION:String = "v1";
      
      private static const AUTHORIZATION_HEADER_NAME:String = "AUTHORIZATION";
      
      private static const REGION_HEADER_NAME:String = "REGION";
      
      private static const GAS_HEADER_VALUE:String = "GasTokenRaw";
      
      private static const PBE_PLATFORMID:String = "PBE1";
      
      private var _request:URLRequest;
      
      private var _urlLoader:URLLoader;
      
      private var _parser:MatchHistoryParser;
      
      private var _result:Object;
      
      public function MatchHistoryServiceAction()
      {
         super(false);
      }
      
      override protected function doInvocation() : void
      {
         var _loc2_:String = null;
         var _loc3_:URLRequestHeader = null;
         super.doInvocation();
         if(ClientConfig.instance.platformId == PBE_PLATFORMID)
         {
            this._request = new URLRequest(this.buildEndpointURL(BASE_TEST_URL + "/" + VERSION));
         }
         else
         {
            this._request = new URLRequest(this.buildEndpointURL(BASE_URL + "/" + VERSION));
         }
         this._request.method = URLRequestMethod.GET;
         if(Session.instance.gasToken)
         {
            _loc2_ = this.getBase64GasToken();
            _loc3_ = new URLRequestHeader(AUTHORIZATION_HEADER_NAME,GAS_HEADER_VALUE + " " + _loc2_);
            this._request.requestHeaders.push(_loc3_);
         }
         var _loc1_:URLRequestHeader = new URLRequestHeader(REGION_HEADER_NAME,ClientConfig.instance.platformId);
         this._request.requestHeaders.push(_loc1_);
         this._urlLoader = new URLLoader();
         this.addEventListeners(this._urlLoader);
         this._urlLoader.load(this._request);
      }
      
      private function getBase64GasToken() : String
      {
         var _loc1_:String = Session.instance.gasToken;
         var _loc2_:Base64Encoder = new Base64Encoder();
         _loc2_.insertNewLines = false;
         _loc2_.encode(_loc1_);
         return _loc2_.toString();
      }
      
      protected function buildEndpointURL(param1:String) : String
      {
         return param1;
      }
      
      protected function parseData(param1:String) : Object
      {
         return null;
      }
      
      private function addEventListeners(param1:URLLoader) : void
      {
         param1.addEventListener(Event.COMPLETE,this.handleRequestComplete);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.handleRequestError);
      }
      
      private function removeEventListeners(param1:URLLoader) : void
      {
         param1.addEventListener(Event.COMPLETE,this.handleRequestComplete);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.handleRequestError);
      }
      
      private function handleRequestComplete(param1:Event) : void
      {
         var result:Object = null;
         var event:Event = param1;
         var loader:URLLoader = event.currentTarget as URLLoader;
         var json:String = loader.data as String;
         this.removeEventListeners(loader);
         try
         {
            result = this.parseData(json);
         }
         catch(e:Error)
         {
            err(e);
            return;
         }
         this._result = result;
         this.complete();
      }
      
      protected function handleData(param1:Object) : void
      {
      }
      
      override protected function onCompleted() : void
      {
         this.handleData(this._result);
      }
      
      override public function complete() : void
      {
         if(getIsFinished())
         {
            return;
         }
         _hasCompleted = true;
         this.onCompleted();
         _completed.dispatch(this._result);
         destroy();
      }
      
      override public function err(param1:Error) : void
      {
         super.err(param1);
         destroy();
      }
      
      override public function abort() : void
      {
         super.abort();
         destroy();
      }
      
      private function handleRequestError(param1:IOErrorEvent) : void
      {
         var _loc2_:URLLoader = param1.currentTarget as URLLoader;
         this.removeEventListeners(_loc2_);
         this.err(new Error(param1.text));
      }
   }
}

