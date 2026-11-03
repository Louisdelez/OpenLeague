package
{
   import developer.DevPanelShellView;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _developer_DevPanelShellViewWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _developer_DevPanelShellViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DevPanelShellView.watcherSetupUtil = new _developer_DevPanelShellViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[8] = new PropertyWatcher("channel_protocol",{"propertyChange":true},[param3[7]],param2);
         param4[0] = new PropertyWatcher("shellDevPanel",{"propertyChange":true},[param3[0]],param2);
         param4[1] = new PropertyWatcher("realms",{"propertyChange":true},[param3[0]],null);
         param4[2] = new PropertyWatcher("host",{"propertyChange":true},[param3[1]],param2);
         param4[5] = new PropertyWatcher("remoting_port",{"propertyChange":true},[param3[4]],param2);
         param4[4] = new PropertyWatcher("xmpp_accept_self_signed_cert",{"propertyChange":true},[param3[3]],param2);
         param4[3] = new PropertyWatcher("xmpp_server_url",{"propertyChange":true},[param3[2]],param2);
         param4[6] = new PropertyWatcher("messaging_port",{"propertyChange":true},[param3[5]],param2);
         param4[9] = new PropertyWatcher("lq_uri",{"propertyChange":true},[param3[8]],param2);
         param4[7] = new PropertyWatcher("messaging_channel",{"propertyChange":true},[param3[6]],param2);
         param4[10] = new PropertyWatcher("version",{"propertyChange":true},[param3[9]],param2);
         param4[8].updateParent(param1);
         param4[0].updateParent(param1);
         param4[0].addChild(param4[1]);
         param4[2].updateParent(param1);
         param4[5].updateParent(param1);
         param4[4].updateParent(param1);
         param4[3].updateParent(param1);
         param4[6].updateParent(param1);
         param4[9].updateParent(param1);
         param4[7].updateParent(param1);
         param4[10].updateParent(param1);
      }
   }
}

