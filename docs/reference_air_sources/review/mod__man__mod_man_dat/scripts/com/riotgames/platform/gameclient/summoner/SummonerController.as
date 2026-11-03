package com.riotgames.platform.gameclient.summoner
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class SummonerController extends EventDispatcher
   {
      
      private var onChangeTalentsSuccess:Function = null;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session = Session.instance;
      
      [Inject]
      public var summonerProfileController:SummonerProfileController = null;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public function SummonerController()
      {
         super();
      }
      
      public function checkSummonerName(param1:String, param2:Function) : void
      {
         this.serviceProxy.summonerService.checkSummonerName(param1,param2,null);
      }
      
      public function loadSummonerCatalog(param1:Function) : void
      {
         this.serviceProxy.summonerService.getSummonerCatalog(param1,null);
      }
   }
}

