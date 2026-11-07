package
{
   import com.riotgames.platform.gameclient.account.PreferencesView;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_account_PreferencesViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_account_PreferencesViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         PreferencesView.watcherSetupUtil = new _com_riotgames_platform_gameclient_account_PreferencesViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[2] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[35],bindings[2],bindings[3],bindings[36],bindings[6],bindings[7],bindings[42],bindings[40],bindings[10],bindings[13],bindings[14],bindings[16],bindings[18],bindings[20],bindings[23],bindings[24],bindings[26],bindings[28],bindings[30]],propertyGetter);
         watchers[34] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_submitLogFilesButtonLabel"];
         },{"change":true},[bindings[35]],null);
         watchers[35] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_submitLogFilesButton_toolTip"];
         },{"change":true},[bindings[36]],null);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_formHeadingLabel"];
         },{"change":true},[bindings[2]],null);
         watchers[38] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_saveButtonLabel"];
         },{"change":true},[bindings[40]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_cancelButtonLabel"];
         },{"change":true},[bindings[3]],null);
         watchers[39] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_cancelButtonLabel"];
         },{"change":true},[bindings[42]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_chatPrefHeadingLabel"];
         },{"change":true},[bindings[6]],null);
         watchers[7] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_chatFilterLabel"];
         },{"change":true},[bindings[7]],null);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_chatFriendOnlinePromptsLabel"];
         },{"change":true},[bindings[10]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_soundPrefHeadingLabel"];
         },{"change":true},[bindings[13]],null);
         watchers[16] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_volumeLabel"];
         },{"change":true},[bindings[14]],null);
         watchers[18] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_soundsLabel"];
         },{"change":true},[bindings[16]],null);
         watchers[20] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_musicVolumeLabel"];
         },{"change":true},[bindings[18]],null);
         watchers[22] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_musicLabel"];
         },{"change":true},[bindings[20]],null);
         watchers[25] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_transitionsFilterLabel"];
         },{"change":true},[bindings[24]],null);
         watchers[24] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_generalPrefHeadingLabel"];
         },{"change":true},[bindings[23]],null);
         watchers[27] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_newbieTipsFilterLabel"];
         },{"change":true},[bindings[26]],null);
         watchers[29] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_suppressNotificationPopups"];
         },{"change":true},[bindings[28]],null);
         watchers[31] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_linkClickWarning"];
         },{"change":true},[bindings[30]],null);
         watchers[11] = new StaticPropertyWatcher("userPrefs",null,[bindings[17],bindings[19],bindings[21],bindings[25],bindings[9],bindings[27],bindings[11],bindings[29],bindings[31],bindings[15]],null);
         watchers[26] = new PropertyWatcher("enableAnimations",{"propertyChange":true},[bindings[25]],null);
         watchers[14] = new PropertyWatcher("friendOnlinePrompts",{"propertyChange":true},[bindings[11]],null);
         watchers[28] = new PropertyWatcher("newbieTipsEnabled",{"propertyChange":true},[bindings[27]],null);
         watchers[23] = new PropertyWatcher("musicMute",{"propertyChange":true},[bindings[21]],null);
         watchers[12] = new PropertyWatcher("EnableChatFilter",{"propertyChange":true},[bindings[9]],null);
         watchers[30] = new PropertyWatcher("suppressNotificationPopups",{"propertyChange":true},[bindings[29]],null);
         watchers[19] = new PropertyWatcher("mute",{"propertyChange":true},[bindings[17]],null);
         watchers[8] = new PropertyWatcher("clientConfig",{"propertyChange":true},[bindings[34],bindings[33],bindings[8]],propertyGetter);
         watchers[33] = new PropertyWatcher("enableSendingLogFiles",{"propertyChange":true},[bindings[34],bindings[33]],null);
         watchers[9] = new PropertyWatcher("clientMode",{"propertyChange":true},[bindings[8]],null);
         watchers[37] = new PropertyWatcher("dirty",{"propertyChange":true},[bindings[39]],propertyGetter);
         watchers[2].updateParent(target);
         watchers[34].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[34]);
         watchers[35].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[35]);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[38].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[38]);
         watchers[4].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[4]);
         watchers[39].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[39]);
         watchers[6].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[6]);
         watchers[7].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[7]);
         watchers[13].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[13]);
         watchers[15].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[15]);
         watchers[16].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[16]);
         watchers[18].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[18]);
         watchers[20].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[20]);
         watchers[22].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[22]);
         watchers[25].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[25]);
         watchers[24].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[24]);
         watchers[27].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[27]);
         watchers[29].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[29]);
         watchers[31].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[31]);
         watchers[11].updateParent(UserPreferencesManager);
         watchers[11].addChild(watchers[26]);
         watchers[11].addChild(watchers[14]);
         watchers[11].addChild(watchers[28]);
         watchers[11].addChild(watchers[23]);
         watchers[11].addChild(watchers[12]);
         watchers[11].addChild(watchers[30]);
         watchers[11].addChild(watchers[19]);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[33]);
         watchers[8].addChild(watchers[9]);
         watchers[37].updateParent(target);
      }
   }
}

