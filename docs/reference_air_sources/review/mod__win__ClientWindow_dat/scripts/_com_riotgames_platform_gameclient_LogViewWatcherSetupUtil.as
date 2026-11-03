package
{
   import com.riotgames.platform.gameclient.LogView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_LogViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_LogViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LogView.watcherSetupUtil = new _com_riotgames_platform_gameclient_LogViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[39] = new PropertyWatcher("logFilter_txti",{"propertyChange":true},[bindings[28]],propertyGetter);
         watchers[40] = new PropertyWatcher("text",{
            "change":false,
            "textChanged":true
         },[bindings[28]],null);
         watchers[3] = new PropertyWatcher("logViewController",{"propertyChange":true},[bindings[17],bindings[16],bindings[2],bindings[20],bindings[24]],propertyGetter);
         watchers[29] = new PropertyWatcher("logFilters",{"propertyChange":true},[bindings[20]],null);
         watchers[4] = new PropertyWatcher("logMessages",{"propertyChange":true},[bindings[2],bindings[24]],null);
         watchers[35] = new PropertyWatcher("length",{"collectionChange":true},[bindings[24]],null);
         watchers[26] = new PropertyWatcher("logLevel",{"propertyChange":true},[bindings[17]],null);
         watchers[25] = new PropertyWatcher("logLevels",{"propertyChange":true},[bindings[16]],null);
         watchers[0] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[0],bindings[5],bindings[6],bindings[7],bindings[8],bindings[9],bindings[11],bindings[13],bindings[14],bindings[18],bindings[21],bindings[23],bindings[25],bindings[27],bindings[29],bindings[30]],propertyGetter);
         watchers[34] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_clearAllFiltersButtonLabel"];
         },{"change":true},[bindings[23]],null);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_windowTitle"];
         },{"change":true},[bindings[0]],null);
         watchers[38] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_addFilterButtonLabel"];
         },{"change":true},[bindings[27]],null);
         watchers[36] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_addFilterLabel"];
         },{"change":true},[bindings[25]],null);
         watchers[42] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_memorySnapshotButtonLabel"];
         },{"change":true},[bindings[29]],null);
         watchers[43] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_clearLogButtonLabel"];
         },{"change":true},[bindings[30]],null);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_searchLogFormHeadingLabel"];
         },{"change":true},[bindings[5]],null);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_searchLabel"];
         },{"change":true},[bindings[6]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_useRegExLabel"];
         },{"change":true},[bindings[7]],null);
         watchers[12] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_tailLogLabel"];
         },{"change":true},[bindings[8]],null);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_searchButtonLabel"];
         },{"change":true},[bindings[9]],null);
         watchers[17] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_resetButtonLabel"];
         },{"change":true},[bindings[11]],null);
         watchers[21] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_configureLogFormHeadingLabel"];
         },{"change":true},[bindings[13]],null);
         watchers[22] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_logLevelLabel"];
         },{"change":true},[bindings[14]],null);
         watchers[27] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_logFiltersLabel"];
         },{"change":true},[bindings[18]],null);
         watchers[30] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","viewLog_deleteFilterButtonLabel"];
         },{"change":true},[bindings[21]],null);
         watchers[23] = new PropertyWatcher("searchLog_itm",{"propertyChange":true},[bindings[19],bindings[26],bindings[15]],propertyGetter);
         watchers[18] = new PropertyWatcher("searchLog_frm",{"propertyChange":true},[bindings[12]],propertyGetter);
         watchers[20] = new PropertyWatcher("height",{"heightChanged":true},[bindings[12]],null);
         watchers[19] = new PropertyWatcher("y",{"yChanged":true},[bindings[12]],null);
         watchers[8] = new PropertyWatcher("search_btn",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[31] = new PropertyWatcher("logFilter_lst",{"propertyChange":true},[bindings[22]],propertyGetter);
         watchers[32] = new PropertyWatcher("selectedItems",{
            "valueCommit":true,
            "change":true
         },[bindings[22]],null);
         watchers[5] = new PropertyWatcher("message_lst",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[7] = new PropertyWatcher("height",{"heightChanged":true},[bindings[3]],null);
         watchers[6] = new PropertyWatcher("y",{"yChanged":true},[bindings[3]],null);
         watchers[14] = new PropertyWatcher("search_txti",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[15] = new PropertyWatcher("text",{
            "change":false,
            "textChanged":true
         },[bindings[10]],null);
         watchers[39].updateParent(target);
         watchers[39].addChild(watchers[40]);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[29]);
         watchers[3].addChild(watchers[4]);
         watchers[4].addChild(watchers[35]);
         watchers[3].addChild(watchers[26]);
         watchers[3].addChild(watchers[25]);
         watchers[0].updateParent(target);
         watchers[34].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[34]);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
         watchers[38].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[38]);
         watchers[36].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[36]);
         watchers[42].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[42]);
         watchers[43].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[43]);
         watchers[9].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[9]);
         watchers[10].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[10]);
         watchers[11].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[11]);
         watchers[12].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[12]);
         watchers[13].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[13]);
         watchers[17].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[17]);
         watchers[21].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[21]);
         watchers[22].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[22]);
         watchers[27].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[27]);
         watchers[30].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[30]);
         watchers[23].updateParent(target);
         watchers[18].updateParent(target);
         watchers[18].addChild(watchers[20]);
         watchers[18].addChild(watchers[19]);
         watchers[8].updateParent(target);
         watchers[31].updateParent(target);
         watchers[31].addChild(watchers[32]);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[7]);
         watchers[5].addChild(watchers[6]);
         watchers[14].updateParent(target);
         watchers[14].addChild(watchers[15]);
      }
   }
}

