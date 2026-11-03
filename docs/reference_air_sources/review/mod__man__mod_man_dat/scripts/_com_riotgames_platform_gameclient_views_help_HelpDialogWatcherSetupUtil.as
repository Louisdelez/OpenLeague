package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.help.HelpDialog;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_help_HelpDialogWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_help_HelpDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         HelpDialog.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_help_HelpDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[24] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[16],bindings[15]],propertyGetter);
         watchers[25] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","helpURL"];
         },{"change":true},[bindings[15]],null);
         watchers[27] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","errorDialog_closeButtonLabel"];
         },{"change":true},[bindings[16]],null);
         watchers[26] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","helpURL"];
         },{"change":true},[bindings[15]],null);
         watchers[14] = new PropertyWatcher("helpContinueButton",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[5] = new PropertyWatcher("helpHeader_wh",{"propertyChange":true},[bindings[3],bindings[7]],propertyGetter);
         watchers[7] = new PropertyWatcher("height",{"heightChanged":true},[bindings[3],bindings[7]],null);
         watchers[6] = new PropertyWatcher("y",{"yChanged":true},[bindings[3],bindings[7]],null);
         watchers[12] = new PropertyWatcher("colRight",{"propertyChange":true},[bindings[8]],propertyGetter);
         watchers[13] = new PropertyWatcher("width",{"widthChanged":true},[bindings[8]],null);
         watchers[16] = new PropertyWatcher("htmlHelpPanel",{"propertyChange":true},[bindings[11],bindings[12]],propertyGetter);
         watchers[17] = new PropertyWatcher("alpha",{"alphaChanged":true},[bindings[11],bindings[12]],null);
         watchers[1] = new StaticPropertyWatcher("instance",null,[bindings[1]],null);
         watchers[3] = new PropertyWatcher("helpController",{"propertyChange":true},[bindings[2],bindings[5]],propertyGetter);
         watchers[10] = new PropertyWatcher("helpTopics",{"propertyChange":true},[bindings[5]],null);
         watchers[4] = new PropertyWatcher("helpHeaderText",{"propertyChange":true},[bindings[2]],null);
         watchers[8] = new PropertyWatcher("colLeft",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[9] = new PropertyWatcher("width",{"widthChanged":true},[bindings[4]],null);
         watchers[22] = new PropertyWatcher("clientConfig",{"propertyChange":true},[bindings[15]],propertyGetter);
         watchers[23] = new PropertyWatcher("helpURL",{"propertyChange":true},[bindings[15]],null);
         watchers[19] = new PropertyWatcher("parentApplication",{"initialize":true},[bindings[13],bindings[14]],propertyGetter);
         watchers[20] = new PropertyWatcher("scaleX",null,[bindings[13]],null);
         watchers[21] = new PropertyWatcher("scaleY",null,[bindings[14]],null);
         watchers[11] = new PropertyWatcher("helpContentText",{"propertyChange":true},[bindings[6]],propertyGetter);
         watchers[24].updateParent(target);
         watchers[25].parentWatcher = watchers[24];
         watchers[24].addChild(watchers[25]);
         watchers[27].parentWatcher = watchers[24];
         watchers[24].addChild(watchers[27]);
         watchers[26].parentWatcher = watchers[24];
         watchers[24].addChild(watchers[26]);
         watchers[14].updateParent(target);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[7]);
         watchers[5].addChild(watchers[6]);
         watchers[12].updateParent(target);
         watchers[12].addChild(watchers[13]);
         watchers[16].updateParent(target);
         watchers[16].addChild(watchers[17]);
         watchers[1].updateParent(ImagePackLookup);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[10]);
         watchers[3].addChild(watchers[4]);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[9]);
         watchers[22].updateParent(target);
         watchers[22].addChild(watchers[23]);
         watchers[19].updateParent(target);
         watchers[19].addChild(watchers[20]);
         watchers[19].addChild(watchers[21]);
         watchers[11].updateParent(target);
      }
   }
}

