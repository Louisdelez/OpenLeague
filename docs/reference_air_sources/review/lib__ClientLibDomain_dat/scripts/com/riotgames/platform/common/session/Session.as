package com.riotgames.platform.common.session
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.object.compare;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.riotgames.platform.gameclient.domain.AccountSummary;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerCatalog;
   import com.riotgames.platform.gameclient.domain.SummonerDefaultSpells;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.gameclient.domain.SummonerLevelAndPoints;
   import com.riotgames.platform.gameclient.domain.SummonerTalentsAndPoints;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.util.url.Base64Url;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import mx.events.PropertyChangeEvent;
   import mx.utils.ObjectUtil;
   
   public class Session implements IEventDispatcher
   {
      
      private static var _instance:Session;
      
      private var _110541305token:String = null;
      
      private var _password:ByteArray;
      
      private var _levelUpInfoChanged:Signal = new Signal();
      
      private var _1289303952clientHeartBeatEnabled:Boolean = false;
      
      private var _1504184367passwordResetLockout:Boolean = false;
      
      private var _summonerTalentsAndPoints:SummonerTalentsAndPoints;
      
      private var _cipher:ICipher;
      
      private var _coopGameRewardResetTime:int;
      
      private var _sessionSummonerUpdated:Signal = new Signal();
      
      private var _summonerDefaultSpells:SummonerDefaultSpells;
      
      private var _firstWinOfDayResetTime:int;
      
      private var _summonerChanged:Signal = new Signal();
      
      private var _1139713863accountSummary:AccountSummary = null;
      
      private var _sessionUpdated:Signal = new Signal();
      
      private var _summonerDefaultSpellsChanged:Signal = new Signal();
      
      private var _rankedRestrictedGamesRemaining:Number = -1;
      
      private var _summonerTalentsAndPointsChanged:Signal = new Signal();
      
      private var _summonerLevelAndPoints:SummonerLevelAndPoints;
      
      private var restorePointSummonerTalentsAndPoints:SummonerTalentsAndPoints = null;
      
      private var _364335383restorePointSummonerCatalog:SummonerCatalog;
      
      private var _coopGameRewardTimeRemaining:int;
      
      private var _summonerCatalog:SummonerCatalog;
      
      private var _summoner:Summoner;
      
      private var _329221358userToken:String = null;
      
      private var _summonerLevelAndPointsChanged:Signal = new Signal();
      
      private var _customGameRewardTimeRemaining:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _levelUpInfo:LevelUpInfo;
      
      private var _useGasTokenForChatPassword:Boolean = false;
      
      private var _summonerLevel:SummonerLevel;
      
      private var _summonerLevelChanged:Signal = new Signal();
      
      private var _1252723281maxNumberOfAllowedMasteryPages:int = 1;
      
      private var _customGameRewardResetTimeRemaining:int;
      
      private var _gasToken:ByteArray;
      
      public function Session()
      {
         super();
      }
      
      public static function get instance() : Session
      {
         if(_instance == null)
         {
            _instance = new Session();
         }
         return _instance;
      }
      
      public function getCipher() : ICipher
      {
         var _loc1_:ByteArray = null;
         if(this._cipher == null)
         {
            _loc1_ = new ByteArray();
            _loc1_.writeUTFBytes("simple-password-cipher");
            this._cipher = Crypto.getCipher("simple-aes128-ctr",_loc1_);
         }
         return this._cipher;
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerCatalog(param1:SummonerCatalog) : void
      {
         var _loc2_:Object = this.summonerCatalog;
         if(_loc2_ !== param1)
         {
            this._951118571summonerCatalog = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerCatalog",_loc2_,param1));
         }
      }
      
      public function restoreTalentsAndPoints() : void
      {
         if(Boolean(this.restorePointSummonerTalentsAndPoints))
         {
            this.summonerTalentsAndPoints = this.restorePointSummonerTalentsAndPoints;
         }
         else
         {
            this.setRestorePointForTalentsAndPoints();
         }
      }
      
      public function set token(param1:String) : void
      {
         var _loc2_:Object = this._110541305token;
         if(_loc2_ !== param1)
         {
            this._110541305token = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"token",_loc2_,param1));
         }
      }
      
      public function applyAllSummonerData(param1:AllSummonerData) : void
      {
         var _loc2_:LevelUpInfo = this._levelUpInfo;
         this.summoner = param1.summoner;
         this.summonerLevelAndPoints = param1.summonerLevelAndPoints;
         this.summonerLevel = param1.summonerLevel;
         this.summonerTalentsAndPoints = param1.summonerTalentsAndPoints;
         this.summonerDefaultSpells = param1.summonerDefaultSpells;
         this.updateLevelUpInfoLastPercentCompleteForNextLevel(_loc2_,this._levelUpInfo);
         this._sessionSummonerUpdated.dispatch();
      }
      
      public function getSummonerId() : Number
      {
         return this.summoner.sumId;
      }
      
      public function getSummonerDefaultSpellsChanged() : ISignal
      {
         return this._summonerDefaultSpellsChanged;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function get sessionSummonerUpdated() : ISignal
      {
         return this._sessionSummonerUpdated;
      }
      
      private function updateLevelUpInfo() : void
      {
         var _loc1_:LevelUpInfo = null;
         var _loc2_:LevelUpInfo = null;
         if(this.summoner != null && this.summonerLevel != null && this.summonerLevelAndPoints != null)
         {
            _loc1_ = new LevelUpInfo();
            _loc1_.summonerName = this.summoner.name;
            _loc1_.currentLevel = this.summonerLevel.summonerLevel;
            _loc1_.nextLevel = _loc1_.currentLevel + 1;
            _loc1_.totalExperiencePoints = this.summonerLevelAndPoints.expPoints;
            _loc1_.pointsNeededToLevelUp = this.summonerLevel.expToNextLevel - _loc1_.totalExperiencePoints;
            if(!compare(_loc1_,this._levelUpInfo))
            {
               _loc2_ = this._levelUpInfo;
               this._levelUpInfo = _loc1_;
               this._levelUpInfo.lastPercentCompleteForNextLevel = this._levelUpInfo.percentCompleteForNextLevel;
               this._levelUpInfoChanged.dispatch(_loc2_,this._levelUpInfo);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set firstWinOfDayTimeRemaining(param1:int) : void
      {
         var _loc2_:Object = this.firstWinOfDayTimeRemaining;
         if(_loc2_ !== param1)
         {
            this._2139860080firstWinOfDayTimeRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstWinOfDayTimeRemaining",_loc2_,param1));
         }
      }
      
      public function get coopGameRewardResetTimeRemaining() : int
      {
         return Math.max(0,this._coopGameRewardResetTime - getTimer());
      }
      
      private function updateLevelUpInfoLastPercentCompleteForNextLevel(param1:LevelUpInfo, param2:LevelUpInfo) : void
      {
         var _loc3_:Number = 0;
         if(Boolean(param1))
         {
            _loc3_ = param1.percentCompleteForNextLevel;
            if(param1.percentCompleteForNextLevel == param2.percentCompleteForNextLevel)
            {
               if(!isNaN(param1.lastPercentCompleteForNextLevel))
               {
                  _loc3_ = param1.percentCompleteForNextLevel;
               }
            }
         }
         else
         {
            _loc3_ = param2.percentCompleteForNextLevel;
         }
         param2.lastPercentCompleteForNextLevel = _loc3_;
      }
      
      public function get useGasTokenForChatPassword() : Boolean
      {
         return this._useGasTokenForChatPassword;
      }
      
      [Bindable(event="propertyChange")]
      public function set password(param1:String) : void
      {
         var _loc2_:Object = this.password;
         if(_loc2_ !== param1)
         {
            this._1216985755password = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"password",_loc2_,param1));
         }
      }
      
      public function get summonerDefaultSpells() : SummonerDefaultSpells
      {
         return this._summonerDefaultSpells;
      }
      
      public function get sessionUpdated() : ISignal
      {
         return this._sessionUpdated;
      }
      
      private function set _1612277088gasToken(param1:String) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         this.getCipher().encrypt(_loc2_);
         this._gasToken = _loc2_;
      }
      
      private function set _1216985755password(param1:String) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         this.getCipher().encrypt(_loc2_);
         this._password = _loc2_;
      }
      
      private function set _1232274276summonerLevelAndPoints(param1:SummonerLevelAndPoints) : void
      {
         this._summonerLevelAndPoints = param1;
         this.updateLevelUpInfo();
         this._summonerLevelAndPointsChanged.dispatch();
      }
      
      public function get customGameRewardResetTimeRemaining() : int
      {
         return Math.max(0,this._customGameRewardResetTimeRemaining - getTimer());
      }
      
      private function set _458633768coopGameRewardResetTimeRemaining(param1:int) : void
      {
         this._coopGameRewardResetTime = getTimer() + param1;
      }
      
      public function get summoner() : Summoner
      {
         return this._summoner;
      }
      
      [Bindable(event="propertyChange")]
      public function set gasToken(param1:String) : void
      {
         var _loc2_:Object = this.gasToken;
         if(_loc2_ !== param1)
         {
            this._1612277088gasToken = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gasToken",_loc2_,param1));
         }
      }
      
      public function getSummonerChanged() : ISignal
      {
         return this._summonerChanged;
      }
      
      private function set _2111041115rankedRestrictedGamesRemaining(param1:Number) : *
      {
         this._rankedRestrictedGamesRemaining = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set coopGameRewardResetTimeRemaining(param1:int) : void
      {
         var _loc2_:Object = this.coopGameRewardResetTimeRemaining;
         if(_loc2_ !== param1)
         {
            this._458633768coopGameRewardResetTimeRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"coopGameRewardResetTimeRemaining",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function get coopGameRewardTimeRemaining() : int
      {
         return this._coopGameRewardTimeRemaining;
      }
      
      public function getLevelUpInfoChanged() : ISignal
      {
         return this._levelUpInfoChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get maxNumberOfAllowedMasteryPages() : int
      {
         return this._1252723281maxNumberOfAllowedMasteryPages;
      }
      
      public function set passwordResetLockout(param1:Boolean) : void
      {
         var _loc2_:Object = this._1504184367passwordResetLockout;
         if(_loc2_ !== param1)
         {
            this._1504184367passwordResetLockout = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"passwordResetLockout",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get passwordResetLockout() : Boolean
      {
         return this._1504184367passwordResetLockout;
      }
      
      public function get rankedRestrictedGamesRemaining() : Number
      {
         return this._rankedRestrictedGamesRemaining;
      }
      
      public function get summonerLevelAndPoints() : SummonerLevelAndPoints
      {
         return this._summonerLevelAndPoints;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function set customGameRewardTimeRemaining(param1:int) : void
      {
         var _loc2_:Object = this.customGameRewardTimeRemaining;
         if(_loc2_ !== param1)
         {
            this._159962807customGameRewardTimeRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"customGameRewardTimeRemaining",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function set useGasTokenForChatPassword(param1:Boolean) : void
      {
         var _loc2_:Object = this.useGasTokenForChatPassword;
         if(_loc2_ !== param1)
         {
            this._898640181useGasTokenForChatPassword = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"useGasTokenForChatPassword",_loc2_,param1));
         }
      }
      
      public function set accountSummary(param1:AccountSummary) : void
      {
         var _loc2_:Object = this._1139713863accountSummary;
         if(_loc2_ !== param1)
         {
            this._1139713863accountSummary = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountSummary",_loc2_,param1));
         }
      }
      
      public function getSummonerLevelChanged() : ISignal
      {
         return this._summonerLevelChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientHeartBeatEnabled() : Boolean
      {
         return this._1289303952clientHeartBeatEnabled;
      }
      
      public function setRestorePointForTalentsAndPoints() : void
      {
         this.restorePointSummonerTalentsAndPoints = ObjectUtil.copy(this.summonerTalentsAndPoints) as SummonerTalentsAndPoints;
      }
      
      private function set _951118571summonerCatalog(param1:SummonerCatalog) : void
      {
         this._summonerCatalog = param1;
         this.restorePointSummonerCatalog = ObjectUtil.copy(param1) as SummonerCatalog;
      }
      
      public function getSummonerTalentsAndPointsChanged() : ISignal
      {
         return this._summonerTalentsAndPointsChanged;
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerTalentsAndPoints(param1:SummonerTalentsAndPoints) : void
      {
         var _loc2_:Object = this.summonerTalentsAndPoints;
         if(_loc2_ !== param1)
         {
            this._2145603135summonerTalentsAndPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerTalentsAndPoints",_loc2_,param1));
         }
      }
      
      public function getChatPassword() : String
      {
         var _loc1_:String = this.gasToken;
         if(this.useGasTokenForChatPassword && Boolean(_loc1_))
         {
            return Base64Url.encode(_loc1_);
         }
         return "AIR_" + this.password;
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerDefaultSpells(param1:SummonerDefaultSpells) : void
      {
         var _loc2_:Object = this.summonerDefaultSpells;
         if(_loc2_ !== param1)
         {
            this._560666430summonerDefaultSpells = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerDefaultSpells",_loc2_,param1));
         }
      }
      
      public function loadServerSession(param1:ServerSessionObject) : void
      {
         this.token = param1.token;
         this.accountSummary = param1.accountSummary;
         this.password = param1.password;
         param1.password = param1.password.replace(/\w/g,"**");
         this._sessionUpdated.dispatch();
      }
      
      public function get firstWinOfDayTimeRemaining() : int
      {
         return Math.max(0,this._firstWinOfDayResetTime - getTimer());
      }
      
      public function get isLoggedIn() : Boolean
      {
         return this.token != null;
      }
      
      private function set _2139860080firstWinOfDayTimeRemaining(param1:int) : void
      {
         this._firstWinOfDayResetTime = getTimer() + param1;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function set _1751869106summoner(param1:Summoner) : void
      {
         this._summoner = param1;
         if(this._summoner != null)
         {
            this._summoner.isMe = true;
         }
         this.updateLevelUpInfo();
         this._summonerChanged.dispatch();
      }
      
      [Bindable(event="propertyChange")]
      public function set customGameRewardResetTimeRemaining(param1:int) : void
      {
         var _loc2_:Object = this.customGameRewardResetTimeRemaining;
         if(_loc2_ !== param1)
         {
            this._1311231924customGameRewardResetTimeRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"customGameRewardResetTimeRemaining",_loc2_,param1));
         }
      }
      
      private function set _898640181useGasTokenForChatPassword(param1:Boolean) : void
      {
         this._useGasTokenForChatPassword = param1;
      }
      
      public function get password() : String
      {
         if(this._password == null || this._password.length == 0)
         {
            return null;
         }
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeBytes(this._password,0,this._password.bytesAvailable);
         _loc1_.position = 0;
         this.getCipher().decrypt(_loc1_);
         _loc1_.position = 0;
         return _loc1_.readUTFBytes(_loc1_.length);
      }
      
      public function get gasToken() : String
      {
         if(this._gasToken == null || this._gasToken.length == 0)
         {
            return null;
         }
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeBytes(this._gasToken,0,this._gasToken.bytesAvailable);
         _loc1_.position = 0;
         this.getCipher().decrypt(_loc1_);
         _loc1_.position = 0;
         return _loc1_.readUTFBytes(_loc1_.length);
      }
      
      public function set maxNumberOfAllowedMasteryPages(param1:int) : void
      {
         var _loc2_:Object = this._1252723281maxNumberOfAllowedMasteryPages;
         if(_loc2_ !== param1)
         {
            this._1252723281maxNumberOfAllowedMasteryPages = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxNumberOfAllowedMasteryPages",_loc2_,param1));
         }
      }
      
      public function get levelUpInfo() : LevelUpInfo
      {
         return this._levelUpInfo;
      }
      
      private function set _560666430summonerDefaultSpells(param1:SummonerDefaultSpells) : void
      {
         this._summonerDefaultSpells = param1;
         this._summonerDefaultSpellsChanged.dispatch();
      }
      
      [Bindable(event="propertyChange")]
      public function set summoner(param1:Summoner) : void
      {
         var _loc2_:Object = this.summoner;
         if(_loc2_ !== param1)
         {
            this._1751869106summoner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summoner",_loc2_,param1));
         }
      }
      
      private function set _1311231924customGameRewardResetTimeRemaining(param1:int) : void
      {
         this._customGameRewardResetTimeRemaining = getTimer() + param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerLevel(param1:SummonerLevel) : void
      {
         var _loc2_:Object = this.summonerLevel;
         if(_loc2_ !== param1)
         {
            this._1545882922summonerLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set coopGameRewardTimeRemaining(param1:int) : void
      {
         var _loc2_:Object = this.coopGameRewardTimeRemaining;
         if(_loc2_ !== param1)
         {
            this._1439701851coopGameRewardTimeRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"coopGameRewardTimeRemaining",_loc2_,param1));
         }
      }
      
      public function get customGameRewardTimeRemaining() : int
      {
         return this._customGameRewardTimeRemaining;
      }
      
      [Bindable(event="propertyChange")]
      public function get accountSummary() : AccountSummary
      {
         return this._1139713863accountSummary;
      }
      
      private function set _2145603135summonerTalentsAndPoints(param1:SummonerTalentsAndPoints) : void
      {
         this._summonerTalentsAndPoints = param1;
         this._summonerTalentsAndPointsChanged.dispatch();
      }
      
      private function set _1439701851coopGameRewardTimeRemaining(param1:int) : void
      {
         this._coopGameRewardTimeRemaining = param1;
      }
      
      public function get summonerTalentsAndPoints() : SummonerTalentsAndPoints
      {
         return this._summonerTalentsAndPoints;
      }
      
      [Bindable(event="propertyChange")]
      public function set rankedRestrictedGamesRemaining(param1:Number) : void
      {
         var _loc2_:Object = this.rankedRestrictedGamesRemaining;
         if(_loc2_ !== param1)
         {
            this._2111041115rankedRestrictedGamesRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedRestrictedGamesRemaining",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerLevelAndPoints(param1:SummonerLevelAndPoints) : void
      {
         var _loc2_:Object = this.summonerLevelAndPoints;
         if(_loc2_ !== param1)
         {
            this._1232274276summonerLevelAndPoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevelAndPoints",_loc2_,param1));
         }
      }
      
      public function set restorePointSummonerCatalog(param1:SummonerCatalog) : void
      {
         var _loc2_:Object = this._364335383restorePointSummonerCatalog;
         if(_loc2_ !== param1)
         {
            this._364335383restorePointSummonerCatalog = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"restorePointSummonerCatalog",_loc2_,param1));
         }
      }
      
      public function set userToken(param1:String) : void
      {
         var _loc2_:Object = this._329221358userToken;
         if(_loc2_ !== param1)
         {
            this._329221358userToken = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userToken",_loc2_,param1));
         }
      }
      
      public function set clientHeartBeatEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1289303952clientHeartBeatEnabled;
         if(_loc2_ !== param1)
         {
            this._1289303952clientHeartBeatEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientHeartBeatEnabled",_loc2_,param1));
         }
      }
      
      public function get summonerLevel() : SummonerLevel
      {
         return this._summonerLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get restorePointSummonerCatalog() : SummonerCatalog
      {
         return this._364335383restorePointSummonerCatalog;
      }
      
      private function set _159962807customGameRewardTimeRemaining(param1:int) : void
      {
         this._customGameRewardTimeRemaining = param1;
      }
      
      public function get summonerCatalog() : SummonerCatalog
      {
         return this._summonerCatalog;
      }
      
      [Bindable(event="propertyChange")]
      public function get userToken() : String
      {
         return this._329221358userToken;
      }
      
      private function set _1545882922summonerLevel(param1:SummonerLevel) : void
      {
         this._summonerLevel = param1;
         this.updateLevelUpInfo();
         this._summonerLevelChanged.dispatch();
      }
      
      [Bindable(event="propertyChange")]
      public function get token() : String
      {
         return this._110541305token;
      }
      
      public function getSummonerLevelAndPointsChanged() : ISignal
      {
         return this._summonerLevelAndPointsChanged;
      }
   }
}

