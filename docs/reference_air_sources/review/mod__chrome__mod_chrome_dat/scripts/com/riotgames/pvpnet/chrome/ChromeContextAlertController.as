package com.riotgames.pvpnet.chrome
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.IChromeContextAlertProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.contextAlert.AlertParser;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.gameclient.domain.inventory.ActiveBoosts;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.chrome.model.ChromeModel;
   import com.riotgames.pvpnet.game.controllers.contextalert.StoreAlertParser;
   import com.riotgames.pvpnet.system.alerter.AlertErrorAction;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.util.logging.ErrorUtil;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   
   public class ChromeContextAlertController implements IChromeContextAlertProvider
   {
      
      private static const MAX_RENTAL_PROMPTS_TO_SHOW:int = 3;
      
      private static const XP_BOOST_NAME:String = "boost_expired_XP_boost";
      
      private static const IP_BOOST_NAME:String = "boost_expired_IP_boost";
      
      private static const TIMED_BOOST_MESSAGE:String = "boost_expired_time_message";
      
      private static const WINS_BOOST_MESSAGE:String = "boost_expired_wins_message";
      
      private var _logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _alertQueue:Vector.<AlertParameters> = new Vector.<AlertParameters>();
      
      private var _activeAlert:AlertParameters = null;
      
      private var _activeAlertChanged:Signal = new Signal();
      
      private var _alertDismissedByUser:Signal = new Signal();
      
      private var _model:ChromeModel;
      
      private var _navigatorVisible:Boolean;
      
      private var storeParser:AlertParser = null;
      
      private var _inventory:IInventory;
      
      private var storeScript:XML = null;
      
      public function ChromeContextAlertController(param1:ChromeModel)
      {
         super();
         this._model = param1;
         ProviderLookup.publishProvider(IChromeContextAlertProvider,this);
      }
      
      public function getActiveAlert() : AlertParameters
      {
         return this._activeAlert;
      }
      
      public function showAlertForParameters(param1:AlertParameters) : void
      {
         if(param1 == this._activeAlert || this._alertQueue.indexOf(param1) != -1)
         {
            return;
         }
         this._alertQueue.push(param1);
         if(!this._activeAlert)
         {
            this.advanceThroughQueue();
         }
      }
      
      public function getActiveAlertChanged() : ISignal
      {
         return this._activeAlertChanged;
      }
      
      public function getAlertDismissedByUser() : ISignal
      {
         return this._alertDismissedByUser;
      }
      
      public function removeAlert(param1:AlertParameters) : void
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            return;
         }
         if(this._activeAlert == param1)
         {
            this.advanceThroughQueue();
         }
         else
         {
            _loc2_ = this._alertQueue.indexOf(param1);
            if(_loc2_ != -1)
            {
               this._alertQueue.splice(_loc2_,1);
            }
         }
      }
      
      public function dismissAlert(param1:AlertParameters) : void
      {
         this.removeAlert(param1);
         this._alertDismissedByUser.dispatch(param1);
      }
      
      private function setActiveAlert(param1:AlertParameters) : void
      {
         if(param1 == this._activeAlert)
         {
            return;
         }
         this._activeAlert = param1;
         this._model.contextAlert = this._activeAlert;
         this._activeAlertChanged.dispatch(this._activeAlert);
      }
      
      private function advanceThroughQueue() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:AlertParameters = null;
         if(this._alertQueue.length > 0)
         {
            _loc1_ = 0;
            _loc2_ = false;
            for each(_loc3_ in this._alertQueue)
            {
               if(!_loc3_.requiresThickChromeState || Boolean(_loc3_.requiresThickChromeState) && this._navigatorVisible)
               {
                  this._alertQueue.splice(_loc1_,1);
                  this.setActiveAlert(_loc3_);
                  return;
               }
               _loc1_++;
            }
            this.setActiveAlert(null);
         }
         else
         {
            this.setActiveAlert(null);
         }
      }
      
      public function navigatorVisibleChanged(param1:Boolean) : void
      {
         this._navigatorVisible = param1;
         if(!this._activeAlert && this._navigatorVisible)
         {
            this.advanceThroughQueue();
         }
         else if(Boolean(this._activeAlert) && Boolean(!this._navigatorVisible) && Boolean(this._activeAlert.requiresThickChromeState))
         {
            this.removeAlert(this._activeAlert);
         }
      }
      
      private function loadScriptFromFile(param1:IInventoryController, param2:Session, param3:IAlerterProvider) : void
      {
         var xmlScript:XML = null;
         var alertAction:AlertErrorAction = null;
         var inventoryController:IInventoryController = param1;
         var session:Session = param2;
         var alerter:IAlerterProvider = param3;
         var file:File = File.applicationDirectory.resolvePath("assets/data/alerts/storeAlerts.xml");
         var fileStream:FileStream = new FileStream();
         try
         {
            fileStream.open(file,FileMode.READ);
            xmlScript = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
            fileStream.close();
         }
         catch(e:Error)
         {
            _logger.error(ErrorUtil.makeErrorMessage(e,"ContextAlertController:loadScriptFromFile Could not load storeAlerts.xml"));
            alertAction = new AlertErrorAction(e.name,e.message,"");
            alertAction.add();
         }
         this.storeScript = xmlScript;
         this.storeParser = new StoreAlertParser(inventoryController,session,this.showAlertForParameters);
      }
      
      public function runExpiredBoostScript(param1:ActiveBoosts) : void
      {
         var _loc2_:UserPrefs = UserPreferencesManager.userPrefs;
         if(!_loc2_ || !param1)
         {
            return;
         }
         var _loc3_:Number = new Date().getTime();
         if(Boolean(_loc2_.hadIPTimeBoost) && param1.ipBoostEndDate < _loc3_)
         {
            this.showBoostExpiredAlert(IP_BOOST_NAME,TIMED_BOOST_MESSAGE);
         }
         if(Boolean(_loc2_.hadXPTimeBoost) && param1.xpBoostEndDate < _loc3_)
         {
            this.showBoostExpiredAlert(XP_BOOST_NAME,TIMED_BOOST_MESSAGE);
         }
         if(Boolean(_loc2_.hadIPWinBoost) && param1.ipBoostPerWinCount == 0)
         {
            this.showBoostExpiredAlert(IP_BOOST_NAME,WINS_BOOST_MESSAGE);
         }
         if(Boolean(_loc2_.hadXPWinBoost) && param1.xpBoostPerWinCount == 0)
         {
            this.showBoostExpiredAlert(XP_BOOST_NAME,WINS_BOOST_MESSAGE);
         }
         _loc2_.hadIPTimeBoost = param1.ipBoostEndDate > _loc3_;
         _loc2_.hadXPTimeBoost = param1.xpBoostEndDate > _loc3_;
         _loc2_.hadIPWinBoost = param1.ipBoostPerWinCount > 0;
         _loc2_.hadXPWinBoost = param1.xpBoostPerWinCount > 0;
      }
      
      private function showBoostExpiredAlert(param1:String, param2:String) : void
      {
         var _loc3_:String = ResourceManager.getInstance().getString("resources",param1);
         var _loc4_:AlertParameters = new AlertParameters();
         _loc4_.location = AlertLocation.STORE_BUTTON;
         _loc4_.title = "boost_expired_alert_title";
         _loc4_.message = ResourceManager.getInstance().getString("resources",param2,[_loc3_]);
         this.showAlertForParameters(_loc4_);
      }
      
      public function runStoreScript() : void
      {
         if(!this.storeParser || !this.storeScript)
         {
            this._logger.error("0001 ContextAlertController:runEndOfGameScript storeParse not yet initialized.");
            return;
         }
         this.storeParser.execute(this.storeScript);
      }
      
      public function initialize(param1:IInventoryController, param2:Session, param3:IAlerterProvider) : void
      {
         if(!this.storeParser)
         {
            this._inventory = param1.inventory;
            this.loadScriptFromFile(param1,param2,param3);
         }
      }
   }
}

