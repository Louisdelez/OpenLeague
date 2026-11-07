package flexlib.scheduling.timelineClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.UIComponent;
   
   public class TimelineViewer extends UIComponent
   {
      
      public var itemRenderer:IFactory;
      
      private var freeRenderers:Array;
      
      private var layout:TimelineLayout;
      
      private var visibleRenderers:Array;
      
      public function TimelineViewer()
      {
         super();
         itemRenderer = new ClassFactory(SimpleTimelineEntryRenderer);
         freeRenderers = new Array();
         visibleRenderers = new Array();
      }
      
      public function update(event:Event) : void
      {
         layout = event.target as TimelineLayout;
         invalidateDisplayList();
      }
      
      private function render(layout:TimelineLayout) : void
      {
         var oldRenderers:Array = null;
         var xPosition:Number = NaN;
         var item:TimelineLayoutItem = null;
         var renderer:ITimelineEntryRenderer = null;
         if(layout == null)
         {
            return;
         }
         oldRenderers = visibleRenderers;
         visibleRenderers = new Array();
         xPosition = layout.xPosition;
         for each(item in layout.items)
         {
            renderer = oldRenderers.pop();
            if(renderer != null)
            {
               renderer.x = item.x - xPosition;
               renderer.width = item.width;
               renderer.y = item.y;
               renderer.data = item.data;
            }
            else
            {
               renderer = getRenderer();
               renderer.x = item.x - xPosition;
               renderer.y = item.y;
               renderer.height = item.height;
               renderer.data = item.data;
               addChild(DisplayObject(renderer));
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
      
      private function getRenderer() : ITimelineEntryRenderer
      {
         if(freeRenderers.length > 0)
         {
            return freeRenderers.pop();
         }
         return itemRenderer.newInstance();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         render(layout);
      }
   }
}

