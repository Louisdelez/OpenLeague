package mx.skins.halo
{
   import flash.system.Capabilities;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.states.SetProperty;
   import mx.states.State;
   
   public class WindowCloseButtonSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      [Embed(source="../../../../assets/mac_close_up.png")]
      private static var macCloseUpSkin:Class = WindowCloseButtonSkin_macCloseUpSkin;
      
      [Embed(source="../../../../assets/win_close_up.png")]
      private static var winCloseUpSkin:Class = WindowCloseButtonSkin_winCloseUpSkin;
      
      [Embed(source="../../../../assets/mac_close_over.png")]
      private static var macCloseOverSkin:Class = WindowCloseButtonSkin_macCloseOverSkin;
      
      [Embed(source="../../../../assets/win_close_over.png")]
      private static var winCloseOverSkin:Class = WindowCloseButtonSkin_winCloseOverSkin;
      
      [Embed(source="../../../../assets/mac_close_down.png")]
      private static var macCloseDownSkin:Class = WindowCloseButtonSkin_macCloseDownSkin;
      
      [Embed(source="../../../../assets/win_close_down.png")]
      private static var winCloseDownSkin:Class = WindowCloseButtonSkin_winCloseDownSkin;
      
      private var isMac:Boolean;
      
      private var skinImage:Image;
      
      public function WindowCloseButtonSkin()
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
         upProp.value = isMac ? macCloseUpSkin : winCloseUpSkin;
         upState.overrides.push(upProp);
         states.push(upState);
         var downState:State = new State();
         downState.name = "down";
         var downProp:SetProperty = new SetProperty();
         downProp.name = "source";
         downProp.target = skinImage;
         downProp.value = isMac ? macCloseDownSkin : winCloseDownSkin;
         downState.overrides.push(downProp);
         states.push(downState);
         var overState:State = new State();
         overState.name = "over";
         var overProp:SetProperty = new SetProperty();
         overProp.name = "source";
         overProp.target = skinImage;
         overProp.value = isMac ? macCloseOverSkin : winCloseOverSkin;
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

