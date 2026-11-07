package spark.components.supportClasses
{
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.collections.IList;
   import mx.core.ISelectableList;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.managers.IFocusManagerComponent;
   import spark.components.ButtonBarButton;
   import spark.components.IItemRenderer;
   import spark.events.IndexChangeEvent;
   import spark.events.RendererExistenceEvent;
   
   [AccessibilityClass(implementation="spark.accessibility.ButtonBarBaseAccImpl")]
   [Style(name="iconPlacement",type="String",enumeration="top,bottom,right,left",inherit="no")]
   public class ButtonBarBase extends ListBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {"dataGroup":false};
      
      private var enableFocusHighlight:Boolean = true;
      
      private var inCollectionChangeHandler:Boolean = false;
      
      private var inKeyUpHandler:Boolean = false;
      
      private var pressedIndex:Number;
      
      private var _iconField:String = "icon";
      
      private var iconFieldOrFunctionChanged:Boolean;
      
      private var _iconFunction:Function;
      
      private var requireSelectionChanged:Boolean;
      
      public function ButtonBarBase()
      {
         super();
         tabChildren = false;
         tabEnabled = true;
         tabFocusEnabled = true;
         setCurrentCaretIndex(0);
      }
      
      [Inspectable(category="Data")]
      override public function set dataProvider(value:IList) : void
      {
         if(dataProvider is ISelectableList)
         {
            dataProvider.removeEventListener(FlexEvent.VALUE_COMMIT,this.dataProvider_changeHandler);
            dataProvider.removeEventListener(IndexChangedEvent.CHANGE,this.dataProvider_changeHandler);
         }
         if(value is ISelectableList)
         {
            value.addEventListener(FlexEvent.VALUE_COMMIT,this.dataProvider_changeHandler,false,0,true);
            value.addEventListener(IndexChangedEvent.CHANGE,this.dataProvider_changeHandler,false,0,true);
         }
         super.dataProvider = value;
         if(value is ISelectableList)
         {
            selectedIndex = ISelectableList(dataProvider).selectedIndex;
         }
      }
      
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(value:String) : void
      {
         if(value == this._iconField)
         {
            return;
         }
         this._iconField = value;
         this.iconFieldOrFunctionChanged = true;
         invalidateProperties();
      }
      
      public function get iconFunction() : Function
      {
         return this._iconFunction;
      }
      
      public function set iconFunction(value:Function) : void
      {
         if(value == this._iconFunction)
         {
            return;
         }
         this._iconFunction = value;
         this.iconFieldOrFunctionChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      override public function set requireSelection(value:Boolean) : void
      {
         if(value == requireSelection)
         {
            return;
         }
         super.requireSelection = value;
         this.requireSelectionChanged = true;
         invalidateProperties();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ButtonBarBase.createAccessibilityImplementation != null)
         {
            ButtonBarBase.createAccessibilityImplementation(this);
         }
      }
      
      override protected function dataProvider_collectionChangeHandler(event:Event) : void
      {
         this.inCollectionChangeHandler = true;
         super.dataProvider_collectionChangeHandler(event);
         this.inCollectionChangeHandler = false;
      }
      
      override protected function adjustSelection(newIndex:int, add:Boolean = false) : void
      {
         if(this.inCollectionChangeHandler && dataProvider is ISelectableList)
         {
            return;
         }
         super.adjustSelection(newIndex,add);
      }
      
      override protected function commitProperties() : void
      {
         var n:int = 0;
         var i:int = 0;
         var renderer:ButtonBarButton = null;
         super.commitProperties();
         if(this.requireSelectionChanged && Boolean(dataGroup))
         {
            this.requireSelectionChanged = false;
            n = dataGroup.numElements;
            for(i = 0; i < n; i++)
            {
               renderer = dataGroup.getElementAt(i) as ButtonBarButton;
               if(Boolean(renderer))
               {
                  renderer.allowDeselection = !requireSelection;
               }
            }
         }
         if(this.iconFieldOrFunctionChanged)
         {
            this.updateRendererIcons();
            this.iconFieldOrFunctionChanged = false;
         }
         this.enableFocusHighlight = true;
      }
      
      private function getItemRenderer(index:int) : IVisualElement
      {
         if(!dataGroup || index < 0 || index >= dataGroup.numElements)
         {
            return null;
         }
         return dataGroup.getElementAt(index);
      }
      
      override protected function itemShowingCaret(index:int, showsCaret:Boolean) : void
      {
         var hasFocus:Boolean = false;
         super.itemShowingCaret(index,showsCaret);
         var renderer:IVisualElement = this.getItemRenderer(index);
         if(Boolean(renderer))
         {
            hasFocus = Boolean(focusManager) && focusManager.getFocus() == this;
            renderer.depth = showsCaret ? 1 : 0;
            if(renderer is IItemRenderer)
            {
               IItemRenderer(renderer).showsCaret = showsCaret && this.enableFocusHighlight && hasFocus;
            }
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var renderer:IVisualElement = this.getItemRenderer(caretIndex);
         if(Boolean(renderer))
         {
            renderer.depth = isFocused ? 1 : 0;
            if(renderer is IItemRenderer)
            {
               IItemRenderer(renderer).showsCaret = isFocused;
            }
         }
      }
      
      override protected function itemSelected(index:int, selected:Boolean) : void
      {
         super.itemSelected(index,selected);
         var renderer:IItemRenderer = this.getItemRenderer(index) as IItemRenderer;
         if(Boolean(renderer))
         {
            if(selected)
            {
               setCurrentCaretIndex(index);
            }
            renderer.selected = selected;
         }
         if(dataProvider is ISelectableList && selected)
         {
            ISelectableList(dataProvider).selectedIndex = index;
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(!styleProp || styleProp == "styleName" || styleProp == "iconPlacement")
         {
            this.iconFieldOrFunctionChanged = true;
            invalidateProperties();
         }
         super.styleChanged(styleProp);
      }
      
      override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object) : void
      {
         this.itemToIcon(renderer,data);
         super.updateRenderer(renderer,itemIndex,data);
      }
      
      private function itemToIcon(renderer:IVisualElement, item:Object) : void
      {
         if(!(renderer is ButtonBase))
         {
            return;
         }
         var iconPlacement:String = getStyle("iconPlacement");
         if(Boolean(iconPlacement))
         {
            ButtonBase(renderer).setStyle("iconPlacement",iconPlacement);
         }
         if(this._iconFunction != null)
         {
            ButtonBase(renderer).setStyle("icon",this._iconFunction(item));
            return;
         }
         if(Boolean(this._iconField) && Boolean(this._iconField.length > 0) && item is Object)
         {
            try
            {
               if(item[this._iconField] != null)
               {
                  ButtonBase(renderer).setStyle("icon",item[this._iconField]);
                  return;
               }
            }
            catch(e:Error)
            {
            }
         }
         ButtonBase(renderer).clearStyle("icon");
      }
      
      private function updateRendererIcons() : void
      {
         var renderer:IItemRenderer = null;
         if(!dataGroup)
         {
            return;
         }
         var count:int = dataGroup.numElements;
         for(var i:int = 0; i < count; i++)
         {
            renderer = dataGroup.getElementAt(i) as IItemRenderer;
            if(Boolean(renderer) && Boolean(renderer.data))
            {
               this.itemToIcon(renderer,renderer.data);
            }
         }
      }
      
      private function dataProvider_changeHandler(event:Event) : void
      {
         var newSelectedIndex:int = int(ISelectableList(dataProvider).selectedIndex);
         if(selectedIndex != newSelectedIndex)
         {
            selectedIndex = newSelectedIndex;
            commitSelection(false);
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent) : void
      {
         super.dataGroup_rendererAddHandler(event);
         var renderer:IVisualElement = event.renderer;
         if(Boolean(renderer))
         {
            renderer.addEventListener(MouseEvent.CLICK,this.item_clickHandler);
            if(renderer is IFocusManagerComponent)
            {
               IFocusManagerComponent(renderer).focusEnabled = false;
            }
            if(renderer is ButtonBarButton)
            {
               ButtonBarButton(renderer).allowDeselection = !requireSelection;
            }
         }
      }
      
      override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent) : void
      {
         super.dataGroup_rendererRemoveHandler(event);
         var renderer:IVisualElement = event.renderer;
         if(Boolean(renderer))
         {
            renderer.removeEventListener(MouseEvent.CLICK,this.item_clickHandler);
         }
      }
      
      private function item_clickHandler(event:MouseEvent) : void
      {
         var newIndex:int = 0;
         if(event.currentTarget is IItemRenderer)
         {
            newIndex = IItemRenderer(event.currentTarget).itemIndex;
         }
         else
         {
            newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
         }
         var oldSelectedIndex:int = selectedIndex;
         if(newIndex == selectedIndex)
         {
            if(!requireSelection)
            {
               setSelectedIndex(NO_SELECTION,true);
            }
         }
         else
         {
            setSelectedIndex(newIndex,true);
         }
         if(this.enableFocusHighlight && selectedIndex != oldSelectedIndex)
         {
            this.enableFocusHighlight = this.inKeyUpHandler;
         }
      }
      
      private function adjustCaretIndex(delta:int) : void
      {
         if(!dataGroup || caretIndex < 0)
         {
            return;
         }
         var oldCaretIndex:int = caretIndex;
         var length:int = dataGroup.numElements;
         if(arrowKeysWrapFocus)
         {
            setCurrentCaretIndex((caretIndex + delta + length) % length);
         }
         else
         {
            setCurrentCaretIndex(Math.min(length - 1,Math.max(0,caretIndex + delta)));
         }
         if(oldCaretIndex != caretIndex)
         {
            dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE,false,false,oldCaretIndex,caretIndex));
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var renderer:IItemRenderer = null;
         if(event.eventPhase == EventPhase.BUBBLING_PHASE)
         {
            return;
         }
         if(!enabled || !dataGroup || event.isDefaultPrevented())
         {
            return;
         }
         if(!isNaN(this.pressedIndex))
         {
            event.preventDefault();
            return;
         }
         super.keyDownHandler(event);
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event,true));
         switch(keyCode)
         {
            case Keyboard.UP:
            case Keyboard.LEFT:
               this.adjustCaretIndex(-1);
               event.preventDefault();
               break;
            case Keyboard.DOWN:
            case Keyboard.RIGHT:
               this.adjustCaretIndex(1);
               event.preventDefault();
               break;
            case Keyboard.SPACE:
               renderer = this.getItemRenderer(caretIndex) as IItemRenderer;
               if(Boolean(renderer) && (!renderer.selected && requireSelection || !requireSelection))
               {
                  renderer.dispatchEvent(event);
                  this.pressedIndex = caretIndex;
               }
         }
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         var renderer:IItemRenderer = null;
         if(event.eventPhase == EventPhase.BUBBLING_PHASE)
         {
            return;
         }
         if(!enabled)
         {
            return;
         }
         super.keyUpHandler(event);
         switch(event.keyCode)
         {
            case Keyboard.SPACE:
               this.inKeyUpHandler = true;
               if(!isNaN(this.pressedIndex))
               {
                  renderer = this.getItemRenderer(this.pressedIndex) as IItemRenderer;
                  if(Boolean(renderer) && (!renderer.selected && requireSelection || !requireSelection))
                  {
                     renderer.dispatchEvent(event);
                     this.pressedIndex = NaN;
                  }
               }
               this.inKeyUpHandler = false;
         }
      }
   }
}

