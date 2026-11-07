package mx.skins.halo
{
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.states.SetProperty;
   import mx.states.State;
   
   public class WindowRestoreButtonSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var winRestoreUpSkin:Class = WindowRestoreButtonSkin_winRestoreUpSkin;
      
      private static var winRestoreDownSkin:Class = WindowRestoreButtonSkin_winRestoreDownSkin;
      
      private static var winRestoreOverSkin:Class = WindowRestoreButtonSkin_winRestoreOverSkin;
      
      private var skinImage:Image;
      
      public function WindowRestoreButtonSkin()
      {
         super();
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
         upProp.value = winRestoreUpSkin;
         upState.overrides.push(upProp);
         states.push(upState);
         var downState:State = new State();
         downState.name = "down";
         var downProp:SetProperty = new SetProperty();
         downProp.name = "source";
         downProp.target = this.skinImage;
         downProp.value = winRestoreDownSkin;
         downState.overrides.push(downProp);
         states.push(downState);
         var overState:State = new State();
         overState.name = "over";
         var overProp:SetProperty = new SetProperty();
         overProp.name = "source";
         overProp.target = this.skinImage;
         overProp.value = winRestoreOverSkin;
         overState.overrides.push(overProp);
         states.push(overState);
      }
   }
}

