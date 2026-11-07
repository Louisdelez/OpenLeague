package
{
   import com.riotgames.platform.gameclient.views.application.SubmitLogsDialog;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_application_SubmitLogsDialogWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_application_SubmitLogsDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SubmitLogsDialog.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_application_SubmitLogsDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[20] = new PropertyWatcher("problemDescription_txta",{"propertyChange":true},[bindings[19]],propertyGetter);
         watchers[9] = new PropertyWatcher("doesClipboardContainBitmap",{"propertyChange":true},[bindings[8],bindings[9]],propertyGetter);
         watchers[0] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[0],bindings[1],bindings[2],bindings[3],bindings[4],bindings[5],bindings[6],bindings[7],bindings[10],bindings[11],bindings[13],bindings[14],bindings[16]],propertyGetter);
         watchers[17] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_closeButton_toolTip"];
         },{"change":true},[bindings[16]],null);
         watchers[16] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_closeButton_toolTip"];
         },{"change":true},[bindings[14]],null);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogsDialogHeader"];
         },{"change":true},[bindings[0]],null);
         watchers[2] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_emailAddressLabel"];
         },{"change":true},[bindings[1]],null);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_subjectLabel"];
         },{"change":true},[bindings[2]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_descriptionOfProblemLabel"];
         },{"change":true},[bindings[3]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_includeScreenSnapshotLabel"];
         },{"change":true},[bindings[4]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_includeScreenSnapshot_toolTip"];
         },{"change":true},[bindings[5]],null);
         watchers[7] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_includeClipboardImageLabel"];
         },{"change":true},[bindings[6]],null);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_includeClipboardImage_toolTip"];
         },{"change":true},[bindings[7]],null);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_submitLogsButtonLabel"];
         },{"change":true},[bindings[10]],null);
         watchers[11] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","submitLogs_submitLogsButton_toolTip"];
         },{"change":true},[bindings[11]],null);
         watchers[15] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_cancel"];
         },{"change":true},[bindings[13]],null);
         watchers[19] = new PropertyWatcher("subject_txti",{"propertyChange":true},[bindings[18]],propertyGetter);
         watchers[12] = new PropertyWatcher("submitLogs_frm",{"propertyChange":true},[bindings[12],bindings[15]],propertyGetter);
         watchers[14] = new PropertyWatcher("height",{"heightChanged":true},[bindings[12],bindings[15]],null);
         watchers[13] = new PropertyWatcher("y",{"yChanged":true},[bindings[12],bindings[15]],null);
         watchers[18] = new PropertyWatcher("emailAddress_txti",{"propertyChange":true},[bindings[17]],propertyGetter);
         watchers[20].updateParent(target);
         watchers[9].updateParent(target);
         watchers[0].updateParent(target);
         watchers[17].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[17]);
         watchers[16].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[16]);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
         watchers[2].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[2]);
         watchers[3].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[3]);
         watchers[4].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[4]);
         watchers[5].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[5]);
         watchers[6].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[6]);
         watchers[7].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[7]);
         watchers[8].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[8]);
         watchers[10].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[10]);
         watchers[11].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[11]);
         watchers[15].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[15]);
         watchers[19].updateParent(target);
         watchers[12].updateParent(target);
         watchers[12].addChild(watchers[14]);
         watchers[12].addChild(watchers[13]);
         watchers[18].updateParent(target);
      }
   }
}

