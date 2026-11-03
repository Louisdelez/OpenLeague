package mx.controls.buttonBarClasses
{
   import mx.controls.Button;
   import mx.core.UITextFormat;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class ButtonBarButton extends Button
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var inLayoutContents:Boolean = false;
      
      public function ButtonBarButton()
      {
         super();
      }
      
      override mx_internal function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         inLayoutContents = true;
         super.mx_internal::layoutContents(unscaledWidth,unscaledHeight,offset);
         inLayoutContents = false;
      }
      
      override public function determineTextFormatFromStyles() : UITextFormat
      {
         if(inLayoutContents && selected)
         {
            return textField.getUITextFormat();
         }
         return super.determineTextFormatFromStyles();
      }
   }
}

