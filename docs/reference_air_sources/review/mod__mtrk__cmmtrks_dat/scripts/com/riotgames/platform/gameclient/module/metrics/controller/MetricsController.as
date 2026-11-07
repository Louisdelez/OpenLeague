package com.riotgames.platform.gameclient.module.metrics.controller
{
   import blix.util.UIDUtil;
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.util.Hex;
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.URLLoaderPool;
   import com.riotgames.platform.gameclient.application.Version;
   import com.riotgames.platform.gameclient.module.metrics.commands.DradisTrackAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracker.IMetricsSubmitter;
   import com.riotgames.pvpnet.tracker.ITreeOfTrackers;
   import com.riotgames.pvpnet.tracker.Tracker;
   import com.riotgames.pvpnet.tracker.model.RiotDradisRecord;
   import flash.net.InterfaceAddress;
   import flash.net.NetworkInfo;
   import flash.net.NetworkInterface;
   import flash.net.URLLoader;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   
   public class MetricsController implements IMetricsProvider, IMetricsSubmitter
   {
      
      protected var currentriotDataServiceDataSendProbability:Number = NaN;
      
      protected var session:Session;
      
      private var client_ip:String;
      
      protected var defferedSendMessages:Array = new Array();
      
      protected var accountId:String;
      
      protected var tracking:Boolean = false;
      
      private var isEngineer:Boolean = false;
      
      private var client_os_type:String = "";
      
      protected var platformID:String = "";
      
      protected var loaderPool:URLLoaderPool;
      
      protected var sessionId:String;
      
      private var summonerLevel:Number;
      
      protected var version:String;
      
      private var summonerID:Number = NaN;
      
      protected var clientConfig:ClientConfig;
      
      private var client_ip2:String;
      
      protected var hashedAccountId:String;
      
      protected var dradisEndpointURI:String;
      
      public function MetricsController()
      {
         super();
         this.init();
      }
      
      public function submitJSON(param1:String) : void
      {
         var _loc2_:DradisTrackAction = new DradisTrackAction(this.dradisEndpointURI,this.loaderPool.getURLLoader(),param1);
         _loc2_.getFinishedWithLoaderSignal().add(this.onFinishedWithURLLoader);
         _loc2_.invoke();
      }
      
      private function prepareSessionId() : void
      {
         if(!this.sessionId)
         {
            this.sessionId = UIDUtil.createUid();
         }
      }
      
      private function prepareLevelData() : void
      {
         if(Boolean(this.session) && Boolean(this.session.summonerLevel))
         {
            this.summonerLevel = this.session.summonerLevel.summonerLevel;
         }
         if(Boolean(this.session) && Boolean(this.session.summoner))
         {
            this.summonerID = this.session.summoner.sumId;
         }
      }
      
      protected function init() : void
      {
         try
         {
            this.clientConfig = ClientConfig.instance;
            this.session = Session.instance;
            this.version = Version.CURRENT_VERSION;
            this.loaderPool = new URLLoaderPool(3);
            this.configure();
         }
         catch(er:Error)
         {
            trace(er.getStackTrace());
         }
      }
      
      public function willTrack() : Boolean
      {
         var _loc1_:Boolean = this.platformID != this.clientConfig.platformId;
         var _loc2_:Boolean = this.currentriotDataServiceDataSendProbability != this.clientConfig.riotDataServiceDataSendProbability;
         if(_loc1_ || _loc2_)
         {
            this.configure();
         }
         return this.tracking;
      }
      
      public function createNewTrackerByName(param1:String) : ITreeOfTrackers
      {
         return new Tracker(param1);
      }
      
      public function onFinishedWithURLLoader(param1:URLLoader) : void
      {
         this.loaderPool.returnURLLoader(param1);
      }
      
      public function track(param1:String, param2:Object = null, param3:Boolean = false, param4:Number = 1) : void
      {
         var _loc5_:RiotDradisRecord = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:RiotDradisRecord = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         if(!this.dradisEndpointURI)
         {
            return;
         }
         if(this.willTrack() || param3 && this.currentriotDataServiceDataSendProbability > 0)
         {
            _loc5_ = this.prepareDradisRecord(param1,param2,param4);
            if(this.platformID == "not_initialized")
            {
               this.defferedSendMessages.push(_loc5_);
            }
            else if(this.defferedSendMessages.length > 0)
            {
               _loc6_ = [];
               while(this.defferedSendMessages.length > 0)
               {
                  _loc9_ = this.defferedSendMessages.shift();
                  _loc9_.region = this.platformID;
                  _loc10_ = _loc9_.toJSONString();
                  _loc6_.push(_loc10_);
               }
               _loc7_ = _loc5_.toJSONString();
               _loc6_.push(_loc7_);
               _loc8_ = "[" + _loc6_.join(",") + "]";
               this.submitJSON(_loc8_);
            }
            else
            {
               _loc11_ = _loc5_.toJSONString();
               this.submitJSON(_loc11_);
            }
         }
      }
      
      public function configure() : void
      {
         var netInterfaces:Vector.<NetworkInterface>;
         var i:NetworkInterface = null;
         var addresses:Vector.<InterfaceAddress> = null;
         var j:InterfaceAddress = null;
         this.platformID = this.clientConfig.platformId;
         this.dradisEndpointURI = this.clientConfig.ekg_uri;
         netInterfaces = NetworkInfo.networkInfo.findInterfaces();
         if(Boolean(netInterfaces) && netInterfaces.length > 0)
         {
            for each(i in netInterfaces)
            {
               if(i.active)
               {
                  addresses = i.addresses;
                  for each(j in addresses)
                  {
                     if(j.broadcast != "" && j.broadcast.indexOf("192.168") == -1 && j.broadcast.indexOf("169.") == -1)
                     {
                        if(j.ipVersion == "IPv4")
                        {
                           if(this.client_ip == null)
                           {
                              this.client_ip = j.address;
                           }
                           else if(j.address != this.client_ip)
                           {
                              this.client_ip2 = j.address;
                           }
                        }
                     }
                  }
               }
            }
         }
         if(Capabilities.os.indexOf("Windows") >= 0)
         {
            this.client_os_type = "windows";
         }
         else if(Capabilities.os.indexOf("Mac") >= 0)
         {
            this.client_os_type = "mac";
         }
         else if(Capabilities.os.indexOf("Linux") >= 0)
         {
            this.client_os_type = "linux";
         }
         else
         {
            try
            {
               this.client_os_type = Capabilities.os.split(" ")[0];
            }
            catch(er:Error)
            {
            }
         }
         if(this.clientConfig.debugDradis)
         {
            this.dradisEndpointURI = "http://test-lb-362440615.us-west-2.elb.amazonaws.com";
            this.clientConfig.riotDataServiceDataSendProbability = this.currentriotDataServiceDataSendProbability = 1;
            this.isEngineer = true;
            this.tracking = true;
         }
         else
         {
            this.currentriotDataServiceDataSendProbability = this.clientConfig.riotDataServiceDataSendProbability;
            this.tracking = Math.random() <= this.currentriotDataServiceDataSendProbability;
         }
      }
      
      private function prepareHashedAccountId() : void
      {
         var _loc1_:MD5 = null;
         var _loc2_:ByteArray = null;
         var _loc3_:ByteArray = null;
         if(Boolean(this.session && this.session.summoner) && Boolean(this.session.summoner.acctId) && this.hashedAccountId == null)
         {
            this.accountId = this.session.summoner.acctId.toString();
            _loc1_ = new MD5();
            _loc2_ = new ByteArray();
            _loc2_.writeUTFBytes(this.accountId);
            _loc3_ = _loc1_.hash(_loc2_);
            this.hashedAccountId = Hex.fromArray(_loc3_);
         }
      }
      
      public function prepareDradisRecord(param1:String, param2:Object, param3:Number) : RiotDradisRecord
      {
         this.prepareSessionId();
         this.prepareHashedAccountId();
         this.prepareLevelData();
         return new RiotDradisRecord(param1,this.platformID,this.sessionId,this.currentriotDataServiceDataSendProbability * param3,this.accountId,this.version,this.summonerID,this.summonerLevel,param2,this.client_os_type,Capabilities.os,this.clientConfig.locale,this.client_ip,this.client_ip2,this.isEngineer);
      }
   }
}

