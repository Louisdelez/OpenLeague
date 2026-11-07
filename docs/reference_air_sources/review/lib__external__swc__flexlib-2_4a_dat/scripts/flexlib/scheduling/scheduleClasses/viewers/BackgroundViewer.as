package flexlib.scheduling.scheduleClasses.viewers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flexlib.scheduling.scheduleClasses.layout.BackgroundLayout;
   import flexlib.scheduling.scheduleClasses.layout.BackgroundLayoutItem;
   import flexlib.scheduling.scheduleClasses.renderers.BackgroundLayoutItemRenderer;
   import mx.core.UIComponent;
   
   public class BackgroundViewer extends UIComponent
   {
      
      private var freeRenderers:Array;
      
      private var layout:BackgroundLayout;
      
      private var visibleRenderers:Array;
      
      public function BackgroundViewer()
      {
         super();
         freeRenderers = new Array();
         visibleRenderers = new Array();
      }
      
      public function update(event:Event) : void
      {
         layout = event.target as BackgroundLayout;
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(Boolean(layout))
         {
            measuredWidth = layout.contentWidth;
            measuredHeight = 100;
         }
      }
      
      private function render(layout:BackgroundLayout) : void
      {
         var oldRenderers:Array = null;
         var item:BackgroundLayoutItem = null;
         var renderer:BackgroundLayoutItemRenderer = null;
         if(layout == null)
         {
            return;
         }
         oldRenderers = visibleRenderers;
         visibleRenderers = new Array();
         for each(item in layout.items)
         {
            renderer = oldRenderers.pop();
            if(renderer != null)
            {
               renderer.x = item.x - layout.xPosition;
               renderer.width = item.width;
               renderer.height = item.height;
               renderer.setStyle("backgroundColor",item.backgroundColor);
               renderer.toolTip = item.toolTip;
            }
            else
            {
               renderer = getRenderer();
               renderer.x = item.x - layout.xPosition;
               renderer.width = item.width;
               renderer.height = item.height;
               renderer.setStyle("backgroundColor",item.backgroundColor);
               renderer.toolTip = item.toolTip;
               addChild(renderer);
            }
            visibleRenderers.push(renderer);
         }
         removeUnusedRenderers(oldRenderers);
      }
      
      private function removeUnusedRenderers(oldRenderers:Array) : void
      {
         var freeRenderer:DisplayObject = null;
         for each(freeRenderer in oldRenderers)
         {
            freeRenderers.push(removeChild(freeRenderer));
         }
      }
      
      private function getRenderer() : BackgroundLayoutItemRenderer
      {
         if(freeRenderers.length > 0)
         {
            return freeRenderers.pop();
         }
         return new BackgroundLayoutItemRenderer();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         render(layout);
      }
   }
}

