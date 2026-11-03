package mx.skins.spark
{
   public class ContainerBorderSkin extends BorderSkin
   {
      
      public function ContainerBorderSkin()
      {
         super();
      }
      
      override public function get contentItems() : Array
      {
         return null;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var cr:Number = Number(getStyle("cornerRadius"));
         if(cornerRadius != cr)
         {
            cornerRadius = cr;
         }
         if(isNaN(getStyle("backgroundColor")))
         {
            background.visible = false;
         }
         else
         {
            background.visible = true;
            bgFill.color = getStyle("backgroundColor");
            bgFill.alpha = getStyle("backgroundAlpha");
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
   }
}

