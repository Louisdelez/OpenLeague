package
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.gameclient.application.Version;
   import com.riotgames.pvpnet.developerwindow.util.IDeveloperWindowPanel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import developer.DevPanelShellView;
   import flash.display.DisplayObject;
   import flash.net.SharedObject;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.modules.ModuleBase;
   
   public class DevPanelShell extends ModuleBase implements IDeveloperWindowPanel
   {
      
      private var _localCache:SharedObject;
      
      private var _devPanelView:DevPanelShellView;
      
      private var _clientConfig:ClientConfig = ClientConfig.instance;
      
      private var _934971452realms:ArrayCollection = new ArrayCollection();
      
      private var _serviceConfig:RiotServiceConfig = RiotServiceConfig.instance;
      
      public function DevPanelShell()
      {
         super();
         this._localCache = SharedObject.getLocal("DEV_PANEL_SHELL");
         this.populateRealmInfo();
      }
      
      public function getConnectionInfo() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["host"] = this._serviceConfig.host;
         _loc1_["xmpp_server_url"] = this._serviceConfig.xmpp_server_url;
         _loc1_["lobbyLandingURL"] = this._clientConfig.lobbyLandingURL;
         _loc1_["ladderURL"] = this._clientConfig.ladderURL;
         _loc1_["storyPageURL"] = this._clientConfig.storyPageURL;
         _loc1_["xmpp_accept_self_signed_cert"] = this._serviceConfig.xmpp_accept_self_signed_cert;
         _loc1_["remoting_port"] = this._serviceConfig.remoting_port;
         _loc1_["messaging_port"] = this._serviceConfig.messaging_port;
         _loc1_["messaging_channel"] = this._serviceConfig.messaging_channel;
         _loc1_["channel_protocol"] = this._serviceConfig.channel_protocol;
         _loc1_["lq_uri"] = this._serviceConfig.lq_uri;
         _loc1_["version"] = Version.CURRENT_VERSION;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get realms() : ArrayCollection
      {
         return this._934971452realms;
      }
      
      public function get view() : DisplayObject
      {
         if(this._devPanelView == null)
         {
            this._devPanelView = new DevPanelShellView();
            this._devPanelView.shellDevPanel = this;
         }
         this._devPanelView.updateValues();
         return this._devPanelView;
      }
      
      public function set realms(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._934971452realms;
         if(_loc2_ !== param1)
         {
            this._934971452realms = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"realms",_loc2_,param1));
         }
      }
      
      public function initializeDeveloperPanel(param1:Object) : void
      {
      }
      
      private function populateRealmInfo() : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc1_:Object = new Object();
         _loc1_["realmName"] = "QA12";
         _loc1_["host"] = "qa12lb.riotgames.com";
         _loc1_["xmpp_server_url"] = "qa12lb.riotgames.com";
         _loc1_["ladderURL"] = "http://www.leagueoflegends.com/ladders";
         _loc1_["storyPageURL"] = "http://www.leagueoflegends.com/story";
         _loc1_["xmpp_accept_self_signed_cert"] = "true";
         _loc1_["remoting_port"] = "2038";
         _loc1_["messaging_port"] = "2038";
         _loc1_["messaging_channel"] = "my-rtmp";
         _loc1_["channel_protocol"] = "rtmp";
         _loc1_["lq_uri"] = "http://qa12a:8088";
         _loc1_["version"] = Version.CURRENT_VERSION;
         this.realms.addItem(_loc1_);
         _loc1_ = new Object();
         _loc1_["realmName"] = "QA2";
         _loc1_["host"] = "qa2a.riotgames.com";
         _loc1_["xmpp_server_url"] = "qa2a.riotgames.com";
         _loc1_["ladderURL"] = "http://www.leagueoflegends.com/ladders";
         _loc1_["storyPageURL"] = "http://www.leagueoflegends.com/story";
         _loc1_["xmpp_accept_self_signed_cert"] = "true";
         _loc1_["remoting_port"] = "2038";
         _loc1_["messaging_port"] = "2038";
         _loc1_["messaging_channel"] = "my-rtmp";
         _loc1_["channel_protocol"] = "rtmp";
         _loc1_["lq_uri"] = "http://qa2a.riotgames.com:8088";
         _loc1_["version"] = Version.CURRENT_VERSION;
         this.realms.addItem(_loc1_);
         _loc1_ = new Object();
         _loc1_["realmName"] = "QA4";
         _loc1_["host"] = "qa4lb.riotgames.com";
         _loc1_["xmpp_server_url"] = "qa4lb.riotgames.com";
         _loc1_["ladderURL"] = "http://www.leagueoflegends.com/ladders";
         _loc1_["storyPageURL"] = "http://www.leagueoflegends.com/story";
         _loc1_["xmpp_accept_self_signed_cert"] = "true";
         _loc1_["remoting_port"] = "2038";
         _loc1_["messaging_port"] = "2038";
         _loc1_["messaging_channel"] = "my-rtmp";
         _loc1_["channel_protocol"] = "rtmp";
         _loc1_["lq_uri"] = "http://qa4a:8088";
         _loc1_["version"] = Version.CURRENT_VERSION;
         this.realms.addItem(_loc1_);
         _loc1_ = new Object();
         _loc1_["realmName"] = "QA6";
         _loc1_["host"] = "qa6lb.riotgames.com";
         _loc1_["xmpp_server_url"] = "qa6lb.riotgames.com";
         _loc1_["ladderURL"] = "http://www.leagueoflegends.com/ladders";
         _loc1_["storyPageURL"] = "http://www.leagueoflegends.com/story";
         _loc1_["xmpp_accept_self_signed_cert"] = "true";
         _loc1_["remoting_port"] = "2038";
         _loc1_["messaging_port"] = "2038";
         _loc1_["messaging_channel"] = "my-rtmp";
         _loc1_["channel_protocol"] = "rtmp";
         _loc1_["lq_uri"] = "http://qa6a:8088";
         _loc1_["version"] = Version.CURRENT_VERSION;
         this.realms.addItem(_loc1_);
         _loc1_ = new Object();
         _loc1_["realmName"] = "QA23";
         _loc1_["host"] = "qa23lb.riotgames.com";
         _loc1_["xmpp_server_url"] = "qa23lb.riotgames.com";
         _loc1_["ladderURL"] = "http://www.leagueoflegends.com/ladders";
         _loc1_["storyPageURL"] = "http://www.leagueoflegends.com/story";
         _loc1_["xmpp_accept_self_signed_cert"] = "true";
         _loc1_["remoting_port"] = "2038";
         _loc1_["messaging_port"] = "2038";
         _loc1_["messaging_channel"] = "my-rtmp";
         _loc1_["channel_protocol"] = "rtmp";
         _loc1_["lq_uri"] = "http://qa23a:8088";
         _loc1_["version"] = "3.9.00";
         this.realms.addItem(_loc1_);
         _loc1_ = new Object();
         _loc1_["realmName"] = "NA Live";
         _loc1_["host"] = "prod.na1.lol.riotgames.com";
         _loc1_["xmpp_server_url"] = "chat.na1.lol.riotgames.com";
         _loc1_["lobbyLandingURL"] = "http://landing.leagueoflegends.com/spectator_swf/landingPage.swf";
         _loc1_["ladderURL"] = "http://www.leagueoflegends.com/ladders";
         _loc1_["storyPageURL"] = "http://www.leagueoflegends.com/story";
         _loc1_["xmpp_accept_self_signed_cert"] = "false";
         _loc1_["remoting_port"] = "2099";
         _loc1_["messaging_port"] = "2099";
         _loc1_["messaging_channel"] = "my-rtmps";
         _loc1_["channel_protocol"] = "rtmps";
         _loc1_["lq_uri"] = "https://lq.na1.lol.riotgames.com";
         _loc1_["version"] = "3.12.0";
         this.realms.addItem(_loc1_);
         _loc1_ = new Object();
         _loc1_["realmName"] = "EUW Live";
         _loc1_["host"] = "prod.euw1.lol.riotgames.com";
         _loc1_["xmpp_server_url"] = "chat.euw1.lol.riotgames.com";
         _loc1_["lobbyLandingURL"] = "http://landing.leagueoflegends.com/spectator_swf/landingPage.swf";
         _loc1_["ladderURL"] = "http://www.leagueoflegends.com/ladders";
         _loc1_["storyPageURL"] = "http://www.leagueoflegends.com/story";
         _loc1_["xmpp_accept_self_signed_cert"] = "false";
         _loc1_["remoting_port"] = "2099";
         _loc1_["messaging_port"] = "2099";
         _loc1_["messaging_channel"] = "my-rtmps";
         _loc1_["channel_protocol"] = "rtmps";
         _loc1_["lq_uri"] = "https://lq.euw1.lol.riotgames.com";
         _loc1_["version"] = "3.12.0";
         this.realms.addItem(_loc1_);
         loop0:
         for each(_loc2_ in this._localCache.data)
         {
            var _loc6_:int = 0;
            var _loc7_:* = this.realms;
            do
            {
               for each(_loc1_ in _loc7_)
               {
               }
               continue loop0;
            }
            while(_loc1_["realmName"] != _loc2_["realmName"]);
            for(_loc3_ in _loc2_)
            {
               _loc1_[_loc3_] = _loc2_[_loc3_];
            }
         }
      }
      
      public function get displayName() : String
      {
         return "Shell";
      }
      
      public function saveValues(param1:Object) : void
      {
         this._serviceConfig.xmpp_server_url.values = [param1["xmpp_server_url"]];
         this._serviceConfig.xmpp_accept_self_signed_cert = param1["xmpp_accept_self_signed_cert"];
         this._serviceConfig.remoting_port = param1["remoting_port"];
         this._serviceConfig.messaging_port = param1["messaging_port"];
         this._serviceConfig.messaging_channel = param1["messaging_channel"];
         this._serviceConfig.channel_protocol = param1["channel_protocol"];
         this._serviceConfig.lq_uri.values = [param1["lq_uri"]];
         this._serviceConfig.resetRemotingUrl(param1["host"],param1["remoting_port"]);
         Version.CURRENT_VERSION = param1["version"];
         this._localCache.data[param1["realmName"]] = param1;
      }
   }
}

