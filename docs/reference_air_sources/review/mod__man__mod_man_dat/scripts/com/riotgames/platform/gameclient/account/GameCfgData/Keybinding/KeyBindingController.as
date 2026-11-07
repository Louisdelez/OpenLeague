package com.riotgames.platform.gameclient.account.GameCfgData.Keybinding
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.file.GameCfgData;
   import com.riotgames.platform.common.utils.file.GameCfgStack;
   import com.riotgames.platform.common.utils.file.GameIniFile;
   import com.riotgames.platform.common.utils.file.OutputAssetsDir;
   import com.riotgames.platform.gameclient.account.GameCfgData.Keybinding.Domain.KeybindingCategoryMap;
   import com.riotgames.platform.gameclient.account.GameCfgData.Keybinding.Domain.KeybindingID;
   import com.riotgames.platform.gameclient.account.GameCfgData.Keybinding.Domain.KeybindingMode;
   import com.riotgames.platform.gameclient.account.GameCfgData.PlayerPreferencesSyncController;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.utils.StringUtil;
   
   public class KeyBindingController implements IEventDispatcher
   {
      
      private var _keybindingModeIndex:int = 0;
      
      public var keybindingData:GameCfgStack;
      
      private var currentEditedKeyBindIndex:int = 0;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var iniOverrides:GameIniFile;
      
      private var _editKey:KeybindingID = null;
      
      public var serviceProxy:ServiceProxy;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public var playerPreferencesSyncController:PlayerPreferencesSyncController;
      
      public var clientConfig:ClientConfig;
      
      private var _1471786890keybindingModes:ArrayCollection;
      
      private var keybindingLocalization:Dictionary = new Dictionary();
      
      public function KeyBindingController()
      {
         super();
         this.init();
      }
      
      private static function GetHardcodedModes() : Array
      {
         var _loc1_:KeybindingMode = new KeybindingMode();
         _loc1_.id = 0;
         _loc1_.displayName = ResourceManager.getInstance().getString("resources","keybinding_category_game");
         var _loc2_:KeybindingMode = new KeybindingMode();
         _loc2_.id = 1;
         _loc2_.displayName = ResourceManager.getInstance().getString("resources","keybinding_category_spectator");
         return [_loc1_,_loc2_];
      }
      
      public function get keybindingCategories() : ArrayCollection
      {
         if(Boolean(this.keybindingModes) && this.keybindingModes.length > this.keybindingModeIndex)
         {
            return this.keybindingModes[this.keybindingModeIndex].keybindingCategories;
         }
         return null;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      private function init() : void
      {
         this.clientConfig = ClientConfig.instance;
         this.serviceProxy = ServiceProxy.instance;
      }
      
      [Bindable(event="propertyChange")]
      public function get keybindingModes() : ArrayCollection
      {
         return this._1471786890keybindingModes;
      }
      
      private function set _2059830345keybindingModeIndex(param1:int) : void
      {
         this._keybindingModeIndex = param1;
      }
      
      private function set _1887992843editKey(param1:KeybindingID) : void
      {
         this._editKey = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set keybindingModeIndex(param1:int) : void
      {
         var _loc2_:Object = this.keybindingModeIndex;
         if(_loc2_ !== param1)
         {
            this._2059830345keybindingModeIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"keybindingModeIndex",_loc2_,param1));
         }
      }
      
      public function set keybindingModes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1471786890keybindingModes;
         if(_loc2_ !== param1)
         {
            this._1471786890keybindingModes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"keybindingModes",_loc2_,param1));
         }
      }
      
      private function generateDataFromKeys(param1:Array) : String
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc2_:Boolean = true;
         var _loc3_:String = "";
         for each(_loc4_ in param1)
         {
            if(!_loc2_)
            {
               _loc3_ += ",";
            }
            _loc2_ = false;
            _loc5_ = true;
            _loc6_ = _loc4_.split("+");
            for each(_loc7_ in _loc6_)
            {
               _loc3_ += "[" + _loc7_ + "]";
            }
         }
         return _loc3_;
      }
      
      private function generateKeybindingCategories(param1:GameCfgStack, param2:Dictionary, param3:Array, param4:Array) : Array
      {
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < param3.length)
         {
            _loc7_ = (param4[_loc6_] as String).split(" ");
            _loc8_ = new Array();
            if(_loc7_.length > 0)
            {
               for each(_loc9_ in _loc7_)
               {
                  _loc10_ = param1.getDefaultData().findCategoryOfFirstOccuranceOfKey(_loc9_);
                  if(_loc10_.length > 0)
                  {
                     _loc11_ = this.getKeysFromData(this.keybindingData.readValue(_loc10_,_loc9_,""));
                     _loc8_.push(new KeybindingID(_loc9_,param2[_loc9_],_loc10_,_loc11_));
                  }
               }
               if(_loc8_.length > 0)
               {
                  _loc5_.push(new KeybindingCategoryMap(param3[_loc6_],_loc8_));
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getInputOverrideFilename() : String
      {
         var _loc1_:File = OutputAssetsDir.GetGameConfigFileDir();
         var _loc2_:File = _loc1_.resolvePath("input.ini");
         return _loc2_.nativePath;
      }
      
      private function readKeysFromDisk() : void
      {
         this.serviceProxy.localGameDataService.getKeybindingDefaults(this.clientConfig.locale,this.onKeybindingDefaultsRetrieved,null,null);
      }
      
      public function getSerializedOverrideData() : ArrayCollection
      {
         if(!this.iniOverrides)
         {
            this.iniOverrides = new GameIniFile();
         }
         this.iniOverrides.initializeFromFile(this.getInputOverrideFilename());
         return this.iniOverrides.getData().serializeForCloud();
      }
      
      private function onKeybindingCategoriesRetrieved(param1:Array) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            _loc7_ = int(_loc4_["modeIndex"]);
            if(_loc2_[_loc7_] == null)
            {
               _loc2_[_loc7_] = new Array();
               _loc3_[_loc7_] = new Array();
            }
            _loc2_[_loc7_].push(_loc4_["name"]);
            _loc3_[_loc7_].push(_loc4_["commands"]);
         }
         _loc5_ = GetHardcodedModes();
         _loc6_ = 0;
         while(_loc6_ < _loc2_.length && _loc6_ < _loc5_.length)
         {
            _loc5_[_loc6_].keybindingCategories = new ArrayCollection(this.generateKeybindingCategories(this.keybindingData,this.keybindingLocalization,_loc2_[_loc6_],_loc3_[_loc6_]));
            _loc6_++;
         }
         this.keybindingModes = new ArrayCollection(_loc5_);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function get keybindingModeIndex() : int
      {
         return this._keybindingModeIndex;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function updateFromDisk() : void
      {
         this.readKeysFromDisk();
         this.setCurrentlyEditedKey(null);
      }
      
      public function setCurrentlyEditedKey(param1:KeybindingID, param2:int = 0) : void
      {
         this.editKey = param1;
         this.currentEditedKeyBindIndex = param2;
      }
      
      public function updateKey(param1:KeybindingID) : void
      {
         this.keybindingData.setValue(param1.internalCategory,param1.internalName,this.generateDataFromKeys(param1.keysBound.toArray()));
      }
      
      public function get editKeyIndex() : int
      {
         return this.currentEditedKeyBindIndex;
      }
      
      public function closeKeybindingMenu() : void
      {
         this.setCurrentlyEditedKey(null);
      }
      
      [Bindable(event="propertyChange")]
      public function set editKey(param1:KeybindingID) : void
      {
         var _loc2_:Object = this.editKey;
         if(_loc2_ !== param1)
         {
            this._1887992843editKey = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"editKey",_loc2_,param1));
         }
      }
      
      private function onKeybindingDefaultsRetrieved(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:File = null;
         var _loc5_:File = null;
         var _loc2_:GameCfgData = new GameCfgData();
         for each(_loc3_ in param1)
         {
            _loc2_.setValue("GameEvents",_loc3_["internalName"],_loc3_["bindings"]);
            this.keybindingLocalization[_loc3_["internalName"]] = _loc3_["displayName"];
         }
         _loc4_ = OutputAssetsDir.GetGameConfigFileDir();
         _loc5_ = _loc4_.resolvePath("input.ini");
         this.iniOverrides = new GameIniFile();
         this.iniOverrides.initializeFromFile(this.getInputOverrideFilename());
         this.keybindingData = new GameCfgStack(_loc2_,this.iniOverrides.getData());
         this.serviceProxy.localGameDataService.getKeybindingCategories(this.clientConfig.locale,this.onKeybindingCategoriesRetrieved,null,null);
      }
      
      public function get editKey() : KeybindingID
      {
         return this._editKey;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function save() : void
      {
         this.iniOverrides.save();
         this.playerPreferencesSyncController.saveToServerIfNeeded(PlayerPreferencesSyncController.PREFERENCES_KEYBINDING);
      }
      
      public function getKeysFromData(param1:String) : Array
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:Array = param1.split(",");
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = _loc4_.split("]");
            _loc6_ = true;
            _loc7_ = "";
            for each(_loc8_ in _loc5_)
            {
               if(_loc8_.length > 1)
               {
                  if(!_loc6_)
                  {
                     _loc7_ += "+";
                  }
                  _loc7_ += StringUtil.trim(_loc8_).slice(1);
                  _loc6_ = false;
               }
            }
            _loc3_.push(_loc7_);
         }
         return _loc3_;
      }
   }
}

