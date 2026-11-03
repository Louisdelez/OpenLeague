package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.views.summoner.wizard.EloQuestionaire;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_gameclient_views_summoner_wizard_EloQuestionaireWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_gameclient_views_summoner_wizard_EloQuestionaireWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EloQuestionaire.watcherSetupUtil = new _com_riotgames_platform_gameclient_views_summoner_wizard_EloQuestionaireWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[9] = new PropertyWatcher("skillToolTip",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[11] = new PropertyWatcher("selected",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[2] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[1],bindings[2],bindings[3],bindings[4],bindings[5],bindings[6],bindings[8]],propertyGetter);
         watchers[3] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","eloQuestionaire_title"];
         },{"change":true},[bindings[1]],null);
         watchers[4] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","eloQuestionaire_instructions"];
         },{"change":true},[bindings[2]],null);
         watchers[5] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","eloQuestionaire_skill_beginner"];
         },{"change":true},[bindings[3]],null);
         watchers[6] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","eloQuestionaire_skill_rtsplayer"];
         },{"change":true},[bindings[4]],null);
         watchers[7] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","eloQuestionaire_skill_veteran"];
         },{"change":true},[bindings[5]],null);
         watchers[8] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","eloQuestionaire_skill_expert"];
         },{"change":true},[bindings[6]],null);
         watchers[10] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","eloQuestionaire_confirm"];
         },{"change":true},[bindings[8]],null);
         watchers[0] = new StaticPropertyWatcher("instance",null,[bindings[0]],null);
         watchers[9].updateParent(target);
         watchers[11].updateParent(target);
         watchers[2].updateParent(target);
         watchers[3].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[4].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[4]);
         watchers[5].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[5]);
         watchers[6].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[6]);
         watchers[7].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[7]);
         watchers[8].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[8]);
         watchers[10].parentWatcher = watchers[2];
         watchers[2].addChild(watchers[10]);
         watchers[0].updateParent(ImagePackLookup);
      }
   }
}

