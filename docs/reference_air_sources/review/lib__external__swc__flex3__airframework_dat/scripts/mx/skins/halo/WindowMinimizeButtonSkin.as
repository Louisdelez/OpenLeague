package mx.skins.halo
{
   import flash.system.Capabilities;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.states.SetProperty;
   import mx.states.State;
   
   public class WindowMinimizeButtonSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      [Embed(source="../../../../assets/mac_min_up.png")]
      private static var macMinUpSkin:Class = WindowMinimizeButtonSkin_macMinUpSkin;
      
      [Embed(source="../../../../assets/win_min_up.png")]
      private static var winMinUpSkin:Class = WindowMinimizeButtonSkin_winMinUpSkin;
      
      [Embed(source="../../../../assets/mac_min_over.png")]
      private static var macMinOverSkin:Class = WindowMinimizeButtonSkin_macMinOverSkin;
      
      [Embed(source="../../../../assets/win_min_over.png")]
      private static var winMinOverSkin:Class = WindowMinimizeButtonSkin_winMinOverSkin;
      
      [Embed(source="../../../../assets/mac_min_down.png")]
      private static var macMinDownSkin:Class = WindowMinimizeButtonSkin_macMinDownSkin;
      
      [Embed(source="../../../../assets/win_min_down.png")]
      private static var winMinDownSkin:Class = WindowMinimizeButtonSkin_winMinDownSkin;
      
      [Embed(source="../../../../assets/mac_min_dis.png")]
      private static var macMinDisabledSkin:Class = WindowMinimizeButtonSkin_macMinDisabledSkin;
      
      [Embed(source="../../../../assets/win_min_dis.png")]
      private static var winMinDisabledSkin:Class = WindowMinimizeButtonSkin_winMinDisabledSkin;
      
      private var isMac:Boolean;
      
      private var skinImage:Image;
      
      public function WindowMinimizeButtonSkin()
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
         upProp.value = isMac ? macMinUpSkin : winMinUpSkin;
         upState.overrides.push(upProp);
         states.push(upState);
         var downState:State = new State();
         downState.name = "down";
         var downProp:SetProperty = new SetProperty();
         downProp.name = "source";
         downProp.target = skinImage;
         downProp.value = isMac ? macMinDownSkin : winMinDownSkin;
         downState.overrides.push(downProp);
         states.push(downState);
         var overState:State = new State();
         overState.name = "over";
         var overProp:SetProperty = new SetProperty();
         overProp.name = "source";
         overProp.target = skinImage;
         overProp.value = isMac ? macMinOverSkin : winMinOverSkin;
         overState.overrides.push(overProp);
         states.push(overState);
         var disabledState:State = new State();
         disabledState.name = "disabled";
         var disabledProp:SetProperty = new SetProperty();
         disabledProp.name = "source";
         disabledProp.target = skinImage;
         disabledProp.value = isMac ? macMinDisabledSkin : winMinDisabledSkin;
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

