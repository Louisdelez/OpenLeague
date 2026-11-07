package mx.skins.halo
{
   import flash.system.Capabilities;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.states.SetProperty;
   import mx.states.State;
   
   public class WindowMaximizeButtonSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      [Embed(source="../../../../assets/mac_max_up.png")]
      private static var macMaxUpSkin:Class = WindowMaximizeButtonSkin_macMaxUpSkin;
      
      [Embed(source="../../../../assets/win_max_up.png")]
      private static var winMaxUpSkin:Class = WindowMaximizeButtonSkin_winMaxUpSkin;
      
      [Embed(source="../../../../assets/mac_max_over.png")]
      private static var macMaxOverSkin:Class = WindowMaximizeButtonSkin_macMaxOverSkin;
      
      [Embed(source="../../../../assets/win_max_over.png")]
      private static var winMaxOverSkin:Class = WindowMaximizeButtonSkin_winMaxOverSkin;
      
      [Embed(source="../../../../assets/mac_max_down.png")]
      private static var macMaxDownSkin:Class = WindowMaximizeButtonSkin_macMaxDownSkin;
      
      [Embed(source="../../../../assets/win_max_down.png")]
      private static var winMaxDownSkin:Class = WindowMaximizeButtonSkin_winMaxDownSkin;
      
      [Embed(source="../../../../assets/mac_max_dis.png")]
      private static var macMaxDisabledSkin:Class = WindowMaximizeButtonSkin_macMaxDisabledSkin;
      
      [Embed(source="../../../../assets/win_max_dis.png")]
      private static var winMaxDisabledSkin:Class = WindowMaximizeButtonSkin_winMaxDisabledSkin;
      
      [Embed(source="../../../../assets/win_restore_up.png")]
      private static var winRestoreUpSkin:Class = WindowMaximizeButtonSkin_winRestoreUpSkin;
      
      [Embed(source="../../../../assets/win_restore_down.png")]
      private static var winRestoreDownSkin:Class = WindowMaximizeButtonSkin_winRestoreDownSkin;
      
      [Embed(source="../../../../assets/win_restore_over.png")]
      private static var winRestoreOverSkin:Class = WindowMaximizeButtonSkin_winRestoreOverSkin;
      
      private var isMac:Boolean;
      
      private var skinImage:Image;
      
      public function WindowMaximizeButtonSkin()
      {
         super();
         isMac = Capabilities.os.substring(0,3) == "Mac";
      }
      
      override public function get measuredWidth() : Number
      {
         if(Boolean(skinImage.measuredWidth))
         {
            return skinImage.measuredWidth;
         }
         return 12;
      }
      
      private function initializeStates() : void
      {
         var upState:State = new State();
         upState.name = "up";
         var upProp:SetProperty = new SetProperty();
         upProp.name = "source";
         upProp.target = skinImage;
         upProp.value = isMac ? macMaxUpSkin : winMaxUpSkin;
         upState.overrides.push(upProp);
         states.push(upState);
         var downState:State = new State();
         downState.name = "down";
         var downProp:SetProperty = new SetProperty();
         downProp.name = "source";
         downProp.target = skinImage;
         downProp.value = isMac ? macMaxDownSkin : winMaxDownSkin;
         downState.overrides.push(downProp);
         states.push(downState);
         var overState:State = new State();
         overState.name = "over";
         var overProp:SetProperty = new SetProperty();
         overProp.name = "source";
         overProp.target = skinImage;
         overProp.value = isMac ? macMaxOverSkin : winMaxOverSkin;
         overState.overrides.push(overProp);
         states.push(overState);
         var disabledState:State = new State();
         disabledState.name = "disabled";
         var disabledProp:SetProperty = new SetProperty();
         disabledProp.name = "source";
         disabledProp.target = skinImage;
         disabledProp.value = isMac ? macMaxDisabledSkin : winMaxDisabledSkin;
         disabledState.overrides.push(disabledProp);
         states.push(disabledState);
      }
      
      override protected function createChildren() : void
      {
         skinImage = new Image();
         addChild(skinImage);
         initializeStates();
         skinImage.setActualSize(12,13);
         skinImage.move(0,0);
      }
      
      override public function get measuredHeight() : Number
      {
         if(Boolean(skinImage.measuredHeight))
         {
            return skinImage.measuredHeight;
         }
         return 13;
      }
   }
}

