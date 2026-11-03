package flexlib.containers
{
   import flash.events.MouseEvent;
   import mx.containers.TitleWindow;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   
   [ExcludeClass]
   public class PopUpToolBar extends TitleWindow
   {
      
      public function PopUpToolBar()
      {
         super();
      }
      
      public function getTitleBar() : UIComponent
      {
         return super.titleBar;
      }
      
      override protected function startDragging(event:MouseEvent) : void
      {
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var child:IUIComponent = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(numChildren))
         {
            child = IUIComponent(getChildAt(0));
            child.setActualSize(unscaledWidth,child.getExplicitOrMeasuredHeight());
         }
      }
   }
}

