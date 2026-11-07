package mx.skins.halo
{
   import flash.system.Capabilities;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.states.SetProperty;
   import mx.states.State;
   
   public class WindowMinimizeButtonSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var macMinUpSkin:Class = WindowMinimizeButtonSkin_macMinUpSkin;
      
      private static var winMinUpSkin:Class = WindowMinimizeButtonSkin_winMinUpSkin;
      
      private static var macMinOverSkin:Class = WindowMinimizeButtonSkin_macMinOverSkin;
      
      private static var winMinOverSkin:Class = WindowMinimizeButtonSkin_winMinOverSkin;
      
      private static var macMinDownSkin:Class = WindowMinimizeButtonSkin_macMinDownSkin;
      
      private static var winMinDownSkin:Class = WindowMinimizeButtonSkin_winMinDownSkin;
      
      private static var macMinDisabledSkin:Class = WindowMinimizeButtonSkin_macMinDisabledSkin;
      
      private static var winMinDisabledSkin:Class = WindowMinimizeButtonSkin_winMinDisabledSkin;
      
      private var isMac:Boolean;
      
      private var skinImage:Image;
      
      public function WindowMinimizeButtonSkin()
      {
         super();
         this.isMac = Capabilities.os.substring(0,3) == "Mac";
      }
      
      override public function get measuredHeight() : Number
      {
         if(Boolean(this.skinImage.measuredHeight))
         {
            return this.skinImage.measuredHeight;
         }
         return 13;
      }
      
      override public function get measuredWidth() : Number
      {
         if(Boolean(this.skinImage.measuredWidth))
         {
            return this.skinImage.measuredWidth;
         }
         return 12;
      }
      
      override protected function createChildren() : void
      {
         this.skinImage = new Image();
         addChild(this.skinImage);
         this.initializeStates();
         this.skinImage.setActualSize(12,13);
         this.skinImage.move(0,0);
      }
      
      private function initializeStates() : void
      {
         var upState:State = new State();
         upState.name = "up";
         var upProp:SetProperty = new SetProperty();
         upProp.name = "source";
         upProp.target = this.skinImage;
         upProp.value = this.isMac ? macMinUpSkin : winMinUpSkin;
         upState.overrides.push(upProp);
         states.push(upState);
         var downState:State = new State();
         downState.name = "down";
         var downProp:SetProperty = new SetProperty();
         downProp.name = "source";
         downProp.target = this.skinImage;
         downProp.value = this.isMac ? macMinDownSkin : winMinDownSkin;
         downState.overrides.push(downProp);
         states.push(downState);
         var overState:State = new State();
         overState.name = "over";
         var overProp:SetProperty = new SetProperty();
         overProp.name = "source";
         overProp.target = this.skinImage;
         overProp.value = this.isMac ? macMinOverSkin : winMinOverSkin;
         overState.overrides.push(overProp);
         states.push(overState);
         var disabledState:State = new State();
         disabledState.name = "disabled";
         var disabledProp:SetProperty = new SetProperty();
         disabledProp.name = "source";
         disabledProp.target = this.skinImage;
         disabledProp.value = this.isMac ? macMinDisabledSkin : winMinDisabledSkin;
         disabledState.overrides.push(disabledProp);
         states.push(disabledState);
      }
   }
}

