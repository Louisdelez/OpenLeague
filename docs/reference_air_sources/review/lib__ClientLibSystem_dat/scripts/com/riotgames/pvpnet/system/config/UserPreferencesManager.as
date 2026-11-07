package com.riotgames.pvpnet.system.config
{
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.GlobalPrefs;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.gameclient.utils.FileSerializer;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.StringUtil;
   
   public class UserPreferencesManager extends EventDispatcher
   {
      
      private static var _userPrefs:UserPrefs;
      
      private static var _globalPrefs:GlobalPrefs;
      
      private static var _instance:UserPreferencesManager;
      
      public static const USER_PREFERENCES_LOADED:String = "loaded";
      
      public static const USER_PREFERENCES_SAVED:String = "saved";
      
      private static var _944752072userPrefsAvailableChangedSignal:Signal = new Signal();
      
      private static const PREFERENCES_PATH:String = "preferences";
      
      private static var _userPrefsAvailable:Boolean = false;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _1810693358hasLoadedUserPreferences:Boolean = false;
      
      protected var logger:ILogger = Log.getLogger("com.riotgames.gameclient.domain.UserPreferencesManager");
      
      public function UserPreferencesManager()
      {
         super();
      }
      
      public static function get instance() : UserPreferencesManager
      {
         if(_instance == null)
         {
            _instance = new UserPreferencesManager();
         }
         return _instance;
      }
      
      public static function get userPrefs() : UserPrefs
      {
         if(_userPrefs == null)
         {
            _userPrefs = new UserPrefs();
         }
         return _userPrefs;
      }
      
      public static function get globalPrefs() : GlobalPrefs
      {
         if(_globalPrefs == null)
         {
            _globalPrefs = new GlobalPrefs();
         }
         return _globalPrefs;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setGlobalPrefs(param1:GlobalPrefs) : void
      {
         _globalPrefs = param1;
      }
      
      public static function setUserPreferencesAvailable(param1:Boolean) : void
      {
         _userPrefsAvailable = param1;
         userPrefsAvailableChangedSignal.dispatch();
      }
      
      public static function get userPreferencesAvailable() : Boolean
      {
         return _userPrefsAvailable;
      }
      
      [Bindable(event="propertyChange")]
      public static function get userPrefsAvailableChangedSignal() : Signal
      {
         return UserPreferencesManager._944752072userPrefsAvailableChangedSignal;
      }
      
      public static function set userPrefsAvailableChangedSignal(param1:Signal) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = UserPreferencesManager._944752072userPrefsAvailableChangedSignal;
         if(_loc2_ !== param1)
         {
            UserPreferencesManager._944752072userPrefsAvailableChangedSignal = param1;
            _loc3_ = UserPreferencesManager.staticEventDispatcher;
            if(_loc3_ !== null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(UserPreferencesManager,"userPrefsAvailableChangedSignal",_loc2_,param1));
            }
         }
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public function loadUserPreferences(param1:String) : void
      {
         var prefFromDisk:UserPrefs = null;
         var summonerName:String = param1;
         try
         {
            prefFromDisk = FileSerializer.instance.readObjectFromFile(this.getPrefsFilePath(summonerName)) as UserPrefs;
            _userPrefs = prefFromDisk != null ? prefFromDisk : new UserPrefs();
            this.loadSharedPreferences(summonerName);
         }
         catch(error:IOError)
         {
            logger.warn("Failed to load preferences for " + summonerName + "." + error.message);
         }
         UserPreferencesManager.userPrefs.enableAnimations = UserPreferencesManager.globalPrefs.enableAnimations;
         this.updateGlobalPrefs();
         this.hasLoadedUserPreferences = true;
         this.dispatchEvent(new Event(UserPreferencesManager.USER_PREFERENCES_LOADED));
      }
      
      public function loadGlobalPreferences() : void
      {
         var _loc1_:GlobalPrefs = FileSerializer.instance.readObjectFromFile(this.getGlobalPrefsFilePath()) as GlobalPrefs;
         _globalPrefs = _loc1_;
         if(!_globalPrefs)
         {
            _globalPrefs = new GlobalPrefs();
         }
      }
      
      private function loadSharedPreferences(param1:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc2_:File = File.applicationDirectory.resolvePath(this.getSharedPrefsFilePath(param1));
         var _loc3_:String = _loc2_.nativePath;
         var _loc4_:FileStream = new FileStream();
         if(_loc2_.exists)
         {
            _loc4_.open(_loc2_,FileMode.READ);
            _loc5_ = _loc4_.readUTFBytes(_loc4_.bytesAvailable);
            _loc6_ = _loc5_.split(File.lineEnding);
            _loc4_.close();
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_.charAt(0) != "#")
               {
                  if(_loc7_.charAt(0) != "[")
                  {
                     _loc8_ = _loc7_.split("=");
                     if(_loc8_.length >= 2)
                     {
                        _loc9_ = _loc8_[0];
                        _loc10_ = StringUtil.trim(_loc8_[1]);
                        _loc11_ = 2;
                        while(_loc11_ < _loc8_.length)
                        {
                           _loc10_ += "=";
                           _loc10_ += _loc8_[_loc11_];
                           _loc11_++;
                        }
                        if(userPrefs.hasOwnProperty(_loc9_))
                        {
                           switch(_loc10_)
                           {
                              case "1":
                                 userPrefs[_loc9_] = true;
                                 break;
                              case "0":
                                 userPrefs[_loc9_] = false;
                                 break;
                              default:
                                 userPrefs[_loc9_] = _loc10_;
                           }
                        }
                     }
                  }
               }
            }
         }
         else
         {
            this.logger.info("Open Shared Properties File Failed: not found at " + _loc3_);
         }
      }
      
      private function saveSharedPreferences(param1:String, param2:String) : void
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:RegExp = null;
         var _loc14_:String = null;
         var _loc3_:File = File.applicationStorageDirectory.resolvePath(param2);
         var _loc4_:String = _loc3_.nativePath;
         var _loc5_:FileStream = new FileStream();
         if(_loc3_.exists)
         {
            _loc5_.open(_loc3_,FileMode.READ);
            _loc6_ = _loc5_.readUTFBytes(_loc5_.bytesAvailable);
            _loc7_ = _loc6_.split(File.lineEnding);
            _loc5_.close();
            for each(_loc8_ in _loc7_)
            {
               _loc9_ = _loc8_.split("=");
               if(_loc9_.length >= 2)
               {
                  _loc10_ = _loc9_[0];
                  _loc11_ = StringUtil.trim(_loc9_[1]);
                  if(userPrefs.hasOwnProperty(_loc10_))
                  {
                     switch(userPrefs[_loc10_])
                     {
                        case true:
                           _loc12_ = "1";
                           break;
                        case false:
                           _loc12_ = "0";
                           break;
                        default:
                           _loc12_ = userPrefs[_loc10_];
                     }
                  }
                  _loc5_.open(_loc3_,FileMode.WRITE);
                  if(userPrefs.hasOwnProperty(_loc10_))
                  {
                     _loc13_ = new RegExp(_loc10_ + "\\W" + _loc11_,"gism");
                     _loc14_ = _loc10_ + "=" + _loc12_;
                     _loc6_ = _loc6_.replace(_loc13_,_loc14_);
                  }
                  _loc5_.writeUTFBytes(_loc6_);
                  _loc5_.close();
               }
            }
         }
      }
      
      public function saveUserPreferences(param1:String) : void
      {
         var summonerName:String = param1;
         UserPreferencesManager.globalPrefs.enableAnimations = UserPreferencesManager.userPrefs.enableAnimations;
         this.updateGlobalPrefs();
         try
         {
            FileSerializer.instance.writeObjectToFile(UserPreferencesManager.userPrefs,this.getPrefsFilePath(summonerName));
            this.saveGlobalPreferences();
            this.saveSharedPreferences(summonerName,this.getSharedPrefsFilePath(summonerName));
         }
         catch(error:IOError)
         {
            logger.warn("Failed to save preferences for " + summonerName + "." + error.message);
         }
         this.dispatchEvent(new Event(UserPreferencesManager.USER_PREFERENCES_SAVED));
      }
      
      public function saveGlobalPreferences() : void
      {
         FileSerializer.instance.writeObjectToFile(UserPreferencesManager.globalPrefs,this.getGlobalPrefsFilePath());
      }
      
      private function updateGlobalPrefs() : void
      {
         if(!UserPreferencesManager.userPrefs || !UserPreferencesManager.globalPrefs)
         {
            return;
         }
         UserPreferencesManager.globalPrefs.mute = UserPreferencesManager.userPrefs.mute;
         UserPreferencesManager.globalPrefs.sfxVolume = UserPreferencesManager.userPrefs.sfxVolume;
         UserPreferencesManager.globalPrefs.musicMute = UserPreferencesManager.userPrefs.musicMute;
         UserPreferencesManager.globalPrefs.musicVolume = UserPreferencesManager.userPrefs.musicVolume;
      }
      
      public function getPrefsFile(param1:String, param2:String = null) : File
      {
         var _loc3_:File = null;
         if(param2 == null)
         {
            _loc3_ = File.applicationDirectory.resolvePath(PREFERENCES_PATH + "/" + param1 + ".properties");
         }
         else
         {
            _loc3_ = File.applicationDirectory.resolvePath(PREFERENCES_PATH + "/" + param2 + "/" + param1 + ".properties");
         }
         return _loc3_;
      }
      
      public function getGlobalPrefsFile() : File
      {
         return this.getPrefsFile("global","global");
      }
      
      private function getGlobalPrefsFilePath() : String
      {
         return this.getGlobalPrefsFile().nativePath;
      }
      
      private function getPrefsFilePath(param1:String) : String
      {
         return this.getPrefsFile(param1).nativePath;
      }
      
      private function getSharedPrefsFilePath(param1:String) : String
      {
         return this.getPrefsFile("shared_" + param1).nativePath;
      }
      
      [Bindable(event="propertyChange")]
      public function get hasLoadedUserPreferences() : Boolean
      {
         return this._1810693358hasLoadedUserPreferences;
      }
      
      public function set hasLoadedUserPreferences(param1:Boolean) : void
      {
         var _loc2_:Object = this._1810693358hasLoadedUserPreferences;
         if(_loc2_ !== param1)
         {
            this._1810693358hasLoadedUserPreferences = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasLoadedUserPreferences",_loc2_,param1));
            }
         }
      }
   }
}

