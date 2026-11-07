package mx.controls.buttonBarClasses
{
   import mx.controls.Button;
   import mx.core.UITextFormat;
   
   [ExcludeClass]
   public class ButtonBarButton extends Button
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var inLayoutContents:Boolean = false;
      
      public function ButtonBarButton()
      {
         super();
      }
      
      override public function determineTextFormatFromStyles() : UITextFormat
      {
         if(this.inLayoutContents && selected)
         {
            return textField.getUITextFormat();
         }
         return super.determineTextFormatFromStyles();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         this.inLayoutContents = true;
         super.layoutContents(unscaledWidth,unscaledHeight,offset);
         this.inLayoutContents = false;
      }
   }
}

