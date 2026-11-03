package
{
   import mx.controls.Image;
   
   [IconFile("flash_component_icon_small.png")]
   public class FlashComponentPlaceholder extends FlashContainerPlaceholder
   {
      
      [Embed(source="flash_component_icon.png")]
      private var _embed_mxml_flash_component_icon_png:Class = FlashComponentPlaceholder__embed_mxml_flash_component_icon_png;
      
      public function FlashComponentPlaceholder()
      {
         super();
      }
      
      override protected function createImage() : Image
      {
         image1 = new Image();
         image1.source = _embed_mxml_flash_component_icon_png;
         image1.scaleContent = false;
         image1.percentHeight = 100;
         image1.percentWidth = 100;
         image1.setStyle("horizontalAlign","center");
         image1.setStyle("verticalAlign","middle");
         return image1;
      }
   }
}

