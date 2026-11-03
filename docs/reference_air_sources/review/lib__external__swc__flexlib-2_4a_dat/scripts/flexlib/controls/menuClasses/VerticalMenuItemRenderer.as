package flexlib.controls.menuClasses
{
   import mx.controls.menuClasses.MenuItemRenderer;
   
   [ExcludeClass]
   public class VerticalMenuItemRenderer extends MenuItemRenderer
   {
      
      private var leftMargin:int = 5;
      
      public function VerticalMenuItemRenderer()
      {
         super();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(branchIcon))
         {
            branchIcon.scaleX = -1;
            branchIcon.x = leftMargin + branchIcon.width;
         }
      }
   }
}

