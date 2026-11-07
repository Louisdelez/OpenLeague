package mx.skins.halo
{
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.states.SetProperty;
   import mx.states.State;
   
   public class WindowRestoreButtonSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      [Embed(source="../../../../assets/win_restore_up.png")]
      private static var winRestoreUpSkin:Class = WindowRestoreButtonSkin_winRestoreUpSkin;
      
      [Embed(source="../../../../assets/win_restore_down.png")]
      private static var winRestoreDownSkin:Class = WindowRestoreButtonSkin_winRestoreDownSkin;
      
      [Embed(source="../../../../assets/win_restore_over.png")]
      private static var winRestoreOverSkin:Class = WindowRestoreButtonSkin_winRestoreOverSkin;
      
      private var skinImage:Image;
      
      public function WindowRestoreButtonSkin()
      {
         super();
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
         upProp.value = winRestoreUpSkin;
         upState.overrides.push(upProp);
         states.push(upState);
         var downState:State = new State();
         downState.name = "down";
         var downProp:SetProperty = new SetProperty();
         downProp.name = "source";
         downProp.target = skinImage;
         downProp.value = winRestoreDownSkin;
         downState.overrides.push(downProp);
         states.push(downState);
         var overState:State = new State();
         overState.name = "over";
         var overProp:SetProperty = new SetProperty();
         overProp.name = "source";
         overProp.target = skinImage;
         overProp.value = winRestoreOverSkin;
         overState.overrides.push(overProp);
         states.push(overState);
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

