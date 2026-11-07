package mx.skins.halo
{
   import flash.system.Capabilities;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.states.SetProperty;
   import mx.states.State;
   
   public class WindowCloseButtonSkin extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var macCloseUpSkin:Class = WindowCloseButtonSkin_macCloseUpSkin;
      
      private static var winCloseUpSkin:Class = WindowCloseButtonSkin_winCloseUpSkin;
      
      private static var macCloseOverSkin:Class = WindowCloseButtonSkin_macCloseOverSkin;
      
      private static var winCloseOverSkin:Class = WindowCloseButtonSkin_winCloseOverSkin;
      
      private static var macCloseDownSkin:Class = WindowCloseButtonSkin_macCloseDownSkin;
      
      private static var winCloseDownSkin:Class = WindowCloseButtonSkin_winCloseDownSkin;
      
      private var isMac:Boolean;
      
      private var skinImage:Image;
      
      public function WindowCloseButtonSkin()
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
         upProp.value = this.isMac ? macCloseUpSkin : winCloseUpSkin;
         upState.overrides.push(upProp);
         states.push(upState);
         var downState:State = new State();
         downState.name = "down";
         var downProp:SetProperty = new SetProperty();
         downProp.name = "source";
         downProp.target = this.skinImage;
         downProp.value = this.isMac ? macCloseDownSkin : winCloseDownSkin;
         downState.overrides.push(downProp);
         states.push(downState);
         var overState:State = new State();
         overState.name = "over";
         var overProp:SetProperty = new SetProperty();
         overProp.name = "source";
         overProp.target = this.skinImage;
         overProp.value = this.isMac ? macCloseOverSkin : winCloseOverSkin;
         overState.overrides.push(overProp);
         states.push(overState);
      }
   }
}

