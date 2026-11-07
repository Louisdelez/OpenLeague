package
{
   import com.riotgames.platform.gameclient.views.Support.ReportPlayerView;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_Support_ReportPlayerViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_Support_ReportPlayerViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ReportPlayerView.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_Support_ReportPlayerViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[3] = new PropertyWatcher("player",{"propertyChange":true},[bindings[2]],propertyGetter);
         watchers[4] = new PropertyWatcher("summonerName",{"propertyChange":true},[bindings[2]],null);
         watchers[0] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[0],bindings[1],bindings[3],bindings[4],bindings[5],bindings[6],bindings[7]],propertyGetter);
         watchers[1] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","reportPlayerDialogHeader"];
         },{"change":true},[bindings[0]],null);
         watchers[2] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","reportPlayer_playerToReportFieldLabel"];
         },{"change":true},[bindings[1]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","reportPlayer_offenceSelectionLabel"];
         },{"change":true},[bindings[3]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","reportPlayer_additionalComments"];
         },{"change":true},[bindings[4]],null);
         watchers[7] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","reportPlayer_submitButtonLabel"];
         },{"change":true},[bindings[5]],null);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","common_button_cancel"];
         },{"change":true},[bindings[6]],null);
         watchers[9] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","preferences_cancelButtonLabel"];
         },{"change":true},[bindings[7]],null);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
         watchers[0].updateParent(target);
         watchers[1].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[1]);
         watchers[2].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[2]);
         watchers[5].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[5]);
         watchers[6].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[6]);
         watchers[7].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[7]);
         watchers[8].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[8]);
         watchers[9].parentWatcher = watchers[0];
         watchers[0].addChild(watchers[9]);
      }
   }
}

