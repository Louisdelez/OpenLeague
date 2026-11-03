package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.controls.RichTextEditor;
   import mx.core.IFlexModuleFactory;
   
   [ExcludeClass]
   public class _mx_controls_RichTextEditorWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _mx_controls_RichTextEditorWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RichTextEditor.watcherSetupUtil = new _mx_controls_RichTextEditorWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("linkTextInput",{"propertyChange":true},[param4[3]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[3]],null);
         param5[0] = new PropertyWatcher("fontFamilyArray",{"propertyChange":true},[param4[0]],param2);
         param5[1] = new PropertyWatcher("fontSizeArray",{"propertyChange":true},[param4[1]],param2);
         param5[2] = new PropertyWatcher("alignButtons",{"propertyChange":true},[param4[2]],param2);
         param5[3] = new PropertyWatcher("height",{"heightChanged":true},[param4[2]],null);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[0].updateParent(param1);
         param5[1].updateParent(param1);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
      }
   }
}

