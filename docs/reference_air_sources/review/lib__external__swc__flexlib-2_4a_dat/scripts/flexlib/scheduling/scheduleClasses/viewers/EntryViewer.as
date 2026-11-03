package flexlib.scheduling.scheduleClasses.viewers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import flexlib.scheduling.scheduleClasses.layout.EntryLayoutItem;
   import flexlib.scheduling.scheduleClasses.layout.IEntryLayout;
   import flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent;
   import flexlib.scheduling.scheduleClasses.renderers.GradientScheduleEntryRenderer;
   import flexlib.scheduling.scheduleClasses.renderers.IScheduleEntryRenderer;
   import flexlib.scheduling.scheduleClasses.utils.Selection;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.UIComponent;
   
   [Style(name="entryStyleName",type="String",inherit="yes")]
   public class EntryViewer extends UIComponent
   {
      
      private var selection:Selection;
      
      private var isShiftKey:Boolean;
      
      private var freeRenderers:Array;
      
      private var layout:IEntryLayout;
      
      public var entryRenderer:IFactory;
      
      private var isCtrlKey:Boolean;
      
      private var visibleRenderers:Dictionary;
      
      public function EntryViewer()
      {
         super();
         entryRenderer = new ClassFactory(GradientScheduleEntryRenderer);
         freeRenderers = new Array();
         visibleRenderers = new Dictionary();
         selection = new Selection();
         addEventListener(MouseEvent.MOUSE_UP,onClickEntry);
         addEventListener(Event.ACTIVATE,addKeyListeners);
         addEventListener(Event.DEACTIVATE,removeKeyListeners);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         super.keyDownHandler(event);
         if(event.ctrlKey)
         {
            isCtrlKey = true;
         }
      }
      
      public function get selectedItem() : IScheduleEntry
      {
         return IScheduleEntry(selection.selectedItem);
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         super.keyUpHandler(event);
         if(!event.ctrlKey)
         {
            isCtrlKey = false;
         }
      }
      
      public function set selectedItem(value:IScheduleEntry) : void
      {
         selection.selectedItem = value;
         invalidateDisplayList();
      }
      
      public function update(event:LayoutUpdateEvent) : void
      {
         layout = IEntryLayout(event.layout);
         invalidateDisplayList();
      }
      
      public function get allowMultipleSelection() : Boolean
      {
         return selection.allowMultipleSelection;
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(layout == null)
         {
            return;
         }
         measuredWidth = layout.contentWidth;
         measuredHeight = layout.contentHeight;
      }
      
      private function removeKeyListeners(event:Event) : void
      {
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
      }
      
      private function findRendererInParentChain(target:Object) : IScheduleEntryRenderer
      {
         while(target != null)
         {
            if(target is IScheduleEntryRenderer)
            {
               return target as IScheduleEntryRenderer;
            }
            target = target.parent;
         }
         return null;
      }
      
      private function render(layout:IEntryLayout) : void
      {
         var oldRenderers:Dictionary = null;
         var item:EntryLayoutItem = null;
         var renderer:IScheduleEntryRenderer = null;
         var style:Object = null;
         if(layout == null)
         {
            return;
         }
         oldRenderers = visibleRenderers;
         visibleRenderers = new Dictionary();
         for each(item in layout.items)
         {
            renderer = oldRenderers[item];
            if(renderer != null)
            {
               renderer.x = item.x / item.zoom - layout.xPosition;
               renderer.y = item.y - layout.yPosition + 2;
               renderer.width = item.width / item.zoom;
               renderer.height = item.height - 4;
               delete oldRenderers[item];
            }
            else
            {
               renderer = getRenderer();
               style = getStyle("entryStyleName");
               if(style != null)
               {
                  renderer.styleName = style;
               }
               renderer.x = item.x / item.zoom - layout.xPosition;
               renderer.y = item.y - layout.yPosition + 2;
               renderer.width = item.width / item.zoom;
               renderer.height = item.height - 4;
               addChild(DisplayObject(renderer));
               renderer.data = item.data;
            }
            visibleRenderers[item] = renderer;
         }
         removeUnusedRenderers(oldRenderers);
         updateSelection();
      }
      
      private function removeUnusedRenderers(oldRenderers:Dictionary) : void
      {
         var freeRenderer:DisplayObject = null;
         for each(freeRenderer in oldRenderers)
         {
            freeRenderers.push(removeChild(freeRenderer));
         }
      }
      
      private function selectOrDeselect(entry:IScheduleEntry) : void
      {
         if(selection.hasItem(entry))
         {
            selection.removeItem(entry);
         }
         else
         {
            selection.addItem(entry);
         }
      }
      
      private function addKeyListeners(event:Event) : void
      {
         if(stage == null)
         {
            return;
         }
         stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
         stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
      }
      
      public function get selectedItems() : Array
      {
         return selection.selectedItems;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         selection.allowMultipleSelection = value;
      }
      
      private function getRenderer() : IScheduleEntryRenderer
      {
         if(freeRenderers.length > 0)
         {
            return freeRenderers.pop();
         }
         return entryRenderer.newInstance();
      }
      
      private function createSelections(entry:IScheduleEntry) : void
      {
         var hasZeroItems:Boolean = false;
         if(entry == null)
         {
            return;
         }
         if(!allowMultipleSelection)
         {
            selectOrDeselect(entry);
         }
         else
         {
            hasZeroItems = selection.selectedItems.length == 0;
            if(hasZeroItems)
            {
               selection.addItem(entry);
            }
            else if(!isCtrlKey)
            {
               selection.clear();
               selectOrDeselect(entry);
            }
            else
            {
               selectOrDeselect(entry);
            }
         }
         updateSelection();
         dispatchEvent(new Event("change"));
      }
      
      private function updateSelection() : void
      {
         var renderer:IScheduleEntryRenderer = null;
         for each(renderer in visibleRenderers)
         {
            renderer.selected = selection.hasItem(renderer.data);
         }
      }
      
      private function onClickEntry(event:MouseEvent) : void
      {
         var renderer:IScheduleEntryRenderer = null;
         var entry:IScheduleEntry = null;
         event.stopPropagation();
         renderer = findRendererInParentChain(event.target);
         if(renderer == null)
         {
            return;
         }
         entry = renderer.entry;
         createSelections(entry);
      }
      
      public function set selectedItems(value:Array) : void
      {
         selection.selectedItems = value;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         render(layout);
      }
   }
}

