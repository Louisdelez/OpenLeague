package
{
   import com.riotgames.pvpnet.invite.legacy.renderer.InviteBayPlayersViewRenderer;
   import flash.display.Sprite;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_pvpnet_invite_legacy_renderer_InviteBayPlayersViewRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_pvpnet_invite_legacy_renderer_InviteBayPlayersViewRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InviteBayPlayersViewRenderer.watcherSetupUtil = new _com_riotgames_pvpnet_invite_legacy_renderer_InviteBayPlayersViewRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var bindings:Array = param3;
         var watchers:Array = param4;
         watchers[0] = new PropertyWatcher("duoQueueRestricted",{"propertyChange":true},[bindings[0],bindings[1],bindings[11]],propertyGetter);
         watchers[11] = new PropertyWatcher("isAddBuddy",{"propertyChange":true},[bindings[7],bindings[10]],propertyGetter);
         watchers[3] = new PropertyWatcher("player_img",{"propertyChange":true},[bindings[3]],propertyGetter);
         watchers[4] = new PropertyWatcher("height",{"heightChanged":true},[bindings[3]],null);
         watchers[2] = new PropertyWatcher("height",{"heightChanged":true},[bindings[2]],propertyGetter);
         watchers[1] = new PropertyWatcher("rankedRestricted",{"propertyChange":true},[bindings[0],bindings[1],bindings[11]],propertyGetter);
         watchers[12] = new PropertyWatcher("resourceManager",{"unused":true},[bindings[8]],propertyGetter);
         watchers[13] = new FunctionReturnWatcher("getString",target,function():Array
         {
            return ["resources","invitePlayers_removePlayerButton_tooltip",[target.data.displayName]];
         },{"change":true},[bindings[8]],null);
         watchers[5] = new PropertyWatcher("playerImgSource",{"propertyChange":true},[bindings[4]],propertyGetter);
         watchers[6] = new PropertyWatcher("data",{"dataChange":true},[bindings[5],bindings[8]],propertyGetter);
         watchers[7] = new PropertyWatcher("displayName",null,[bindings[5],bindings[8]],null);
         watchers[8] = new PropertyWatcher("stoneCanvas",{"propertyChange":true},[bindings[6],bindings[9]],propertyGetter);
         watchers[10] = new PropertyWatcher("width",{"widthChanged":true},[bindings[6],bindings[9]],null);
         watchers[9] = new PropertyWatcher("x",{"xChanged":true},[bindings[6],bindings[9]],null);
         watchers[0].updateParent(target);
         watchers[11].updateParent(target);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
         watchers[2].updateParent(target);
         watchers[1].updateParent(target);
         watchers[12].updateParent(target);
         watchers[13].parentWatcher = watchers[12];
         watchers[12].addChild(watchers[13]);
         watchers[5].updateParent(target);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[8].updateParent(target);
         watchers[8].addChild(watchers[10]);
         watchers[8].addChild(watchers[9]);
      }
   }
}

