package
{
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.PropertyWatcher;
   import mx.controls.RichTextEditor;
   import mx.core.IFlexModuleFactory;
   
   [Mixin]
   [ExcludeClass]
   public class _mx_controls_RichTextEditorWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _mx_controls_RichTextEditorWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RichTextEditor.watcherSetupUtil = new _mx_controls_RichTextEditorWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[4] = new PropertyWatcher("linkTextInput",{"propertyChange":true},[param3[3]],param2);
         param4[5] = new PropertyWatcher("height",{"heightChanged":true},[param3[3]],null);
         param4[1] = new PropertyWatcher("fontSizeArray",{"propertyChange":true},[param3[1]],param2);
         param4[2] = new PropertyWatcher("alignButtons",{"propertyChange":true},[param3[2]],param2);
         param4[3] = new PropertyWatcher("height",{"heightChanged":true},[param3[2]],null);
         param4[0] = new PropertyWatcher("fontFamilyArray",{"propertyChange":true},[param3[0]],param2);
         param4[4].updateParent(param1);
         param4[4].addChild(param4[5]);
         param4[1].updateParent(param1);
         param4[2].updateParent(param1);
         param4[2].addChild(param4[3]);
         param4[0].updateParent(param1);
      }
   }
}

