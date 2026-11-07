package spark.components
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.IList;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IInvalidating;
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.managers.LayoutManager;
   import mx.utils.MatrixUtil;
   import spark.components.supportClasses.GroupBase;
   import spark.events.RendererExistenceEvent;
   import spark.layouts.supportClasses.LayoutBase;
   
   [IconFile("DataGroup.png")]
   [DefaultProperty("dataProvider")]
   [ResourceBundle("components")]
   [Exclude(name="getChildIndex",kind="method")]
   [Exclude(name="getChildAt",kind="method")]
   [Exclude(name="numChildren",kind="property")]
   [Exclude(name="swapChildrenAt",kind="method")]
   [Exclude(name="swapChildren",kind="method")]
   [Exclude(name="setChildIndex",kind="method")]
   [Exclude(name="removeChildAt",kind="method")]
   [Exclude(name="removeChild",kind="method")]
   [Exclude(name="addChildAt",kind="method")]
   [Exclude(name="addChild",kind="method")]
   [Event(name="rendererRemove",type="spark.events.RendererExistenceEvent")]
   [Event(name="rendererAdd",type="spark.events.RendererExistenceEvent")]
   public class DataGroup extends GroupBase implements IItemRendererOwner
   {
      
      private static const LAYERING_ENABLED:uint = 1;
      
      private static const LAYERING_DIRTY:uint = 2;
      
      private var _layeringFlags:uint = 0;
      
      private var rendererToFactoryMap:Dictionary = new Dictionary(true);
      
      private var freeRendererMap:Dictionary = new Dictionary();
      
      private var addedVirtualRenderer:Boolean = false;
      
      private var _typicalItem:Object = null;
      
      private var explicitTypicalItem:Object = null;
      
      private var typicalItemChanged:Boolean = false;
      
      private var typicalLayoutElement:ILayoutElement = null;
      
      private var useVirtualLayoutChanged:Boolean = false;
      
      private var _itemRenderer:IFactory;
      
      private var itemRendererChanged:Boolean;
      
      private var _itemRendererFunction:Function;
      
      private var _rendererUpdateDelegate:IItemRendererOwner;
      
      private var _dataProvider:IList;
      
      private var dataProviderChanged:Boolean;
      
      private var renderersBeingUpdated:Boolean = false;
      
      private var indexToRenderer:Array = [];
      
      private var virtualRendererIndices:Vector.<int> = null;
      
      private var oldVirtualRendererIndices:Vector.<int> = null;
      
      private var virtualLayoutUnderway:Boolean = false;
      
      public function DataGroup()
      {
         super();
         this._rendererUpdateDelegate = this;
      }
      
      private static function sortDecreasing(x:int, y:int) : Number
      {
         return y - x;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(this.numElements == 0)
         {
            return super.baselinePosition;
         }
         return this.getElementAt(0).baselinePosition + this.getElementAt(0).y;
      }
      
      [Inspectable(category="Data")]
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(value:Object) : void
      {
         if(this._typicalItem === value)
         {
            return;
         }
         this._typicalItem = this.explicitTypicalItem = value;
         this.invalidateTypicalItemRenderer();
      }
      
      private function setTypicalLayoutElement(element:ILayoutElement) : void
      {
         this.typicalLayoutElement = element;
         if(Boolean(layout))
         {
            layout.typicalLayoutElement = element;
         }
      }
      
      public function invalidateTypicalItemRenderer() : void
      {
         this.typicalItemChanged = true;
         invalidateProperties();
      }
      
      private function initializeTypicalItem() : void
      {
         if(this._typicalItem === null)
         {
            this.setTypicalLayoutElement(null);
            return;
         }
         var renderer:IVisualElement = this.createRendererForItem(this._typicalItem,false);
         var obj:DisplayObject = DisplayObject(renderer);
         if(!obj)
         {
            this.setTypicalLayoutElement(null);
            return;
         }
         super.addChild(obj);
         this.setUpItemRenderer(renderer,0,this._typicalItem);
         if(obj is IInvalidating)
         {
            IInvalidating(obj).validateNow();
         }
         this.setTypicalLayoutElement(renderer);
         super.removeChild(obj);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createItemRendererFor(index:int) : IVisualElement
      {
         var item:Object = null;
         if(index < 0 || this.dataProvider == null || index >= this.dataProvider.length)
         {
            return null;
         }
         item = this.dataProvider.getItemAt(index);
         var renderer:IVisualElement = this.createRendererForItem(item);
         super.addChild(DisplayObject(renderer));
         this.setUpItemRenderer(renderer,index,item);
         if(renderer is IInvalidating)
         {
            IInvalidating(renderer).validateNow();
         }
         super.removeChild(DisplayObject(renderer));
         return renderer;
      }
      
      private function ensureTypicalLayoutElement() : void
      {
         var isTextFlowClass:Boolean = false;
         if(Boolean(layout.typicalLayoutElement))
         {
            return;
         }
         var list:IList = this.dataProvider;
         if(Boolean(list) && list.length > 0)
         {
            this._typicalItem = list.getItemAt(0);
            isTextFlowClass = getQualifiedClassName(this._typicalItem) == "flashx.textLayout.elements::TextFlow";
            if(isTextFlowClass)
            {
               this._typicalItem = this._typicalItem["deepCopy"]();
            }
            this.initializeTypicalItem();
         }
      }
      
      override public function set layout(value:LayoutBase) : void
      {
         var oldLayout:LayoutBase = layout;
         if(value == oldLayout)
         {
            return;
         }
         if(Boolean(oldLayout))
         {
            oldLayout.typicalLayoutElement = null;
            oldLayout.removeEventListener("useVirtualLayoutChanged",this.layout_useVirtualLayoutChangedHandler);
         }
         if(Boolean(oldLayout) && Boolean(value) && oldLayout.useVirtualLayout != value.useVirtualLayout)
         {
            this.changeUseVirtualLayout();
         }
         super.layout = value;
         if(Boolean(value))
         {
            if(Boolean(this.typicalLayoutElement))
            {
               value.typicalLayoutElement = this.typicalLayoutElement;
            }
            else
            {
               this.typicalLayoutElement = value.typicalLayoutElement;
            }
            value.addEventListener("useVirtualLayoutChanged",this.layout_useVirtualLayoutChangedHandler);
         }
      }
      
      private function changeUseVirtualLayout() : void
      {
         this.removeDataProviderListener();
         this.removeAllItemRenderers();
         this.useVirtualLayoutChanged = true;
         invalidateProperties();
      }
      
      private function layout_useVirtualLayoutChangedHandler(event:Event) : void
      {
         this.changeUseVirtualLayout();
      }
      
      [Inspectable(category="Data")]
      public function get itemRenderer() : IFactory
      {
         return this._itemRenderer;
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         this._itemRenderer = value;
         this.removeDataProviderListener();
         this.removeAllItemRenderers();
         invalidateProperties();
         this.itemRendererChanged = true;
         this.typicalItemChanged = true;
      }
      
      [Inspectable(category="Data")]
      public function get itemRendererFunction() : Function
      {
         return this._itemRendererFunction;
      }
      
      public function set itemRendererFunction(value:Function) : void
      {
         this._itemRendererFunction = value;
         this.removeDataProviderListener();
         this.removeAllItemRenderers();
         invalidateProperties();
         this.itemRendererChanged = true;
         this.typicalItemChanged = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get rendererUpdateDelegate() : IItemRendererOwner
      {
         return this._rendererUpdateDelegate;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set rendererUpdateDelegate(value:IItemRendererOwner) : void
      {
         this._rendererUpdateDelegate = value;
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataProviderChanged")]
      public function get dataProvider() : IList
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(value:IList) : void
      {
         if(this._dataProvider == value)
         {
            return;
         }
         this.removeDataProviderListener();
         this._dataProvider = value;
         this.dataProviderChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("dataProviderChanged"));
      }
      
      private function removeRendererAt(index:int) : void
      {
         var item:Object = null;
         var renderer:IVisualElement = this.indexToRenderer[index] as IVisualElement;
         if(Boolean(renderer))
         {
            if(renderer is IDataRenderer && (this.itemRenderer != null || this.itemRendererFunction != null))
            {
               item = IDataRenderer(renderer).data;
            }
            else
            {
               item = renderer;
            }
            this.itemRemoved(item,index);
         }
      }
      
      private function removeAllItemRenderers() : void
      {
         var index:int = 0;
         var freeRenderers:Vector.<IVisualElement> = null;
         var renderer:IVisualElement = null;
         if(this.indexToRenderer.length == 0)
         {
            return;
         }
         if(Boolean(this.virtualRendererIndices) && this.virtualRendererIndices.length > 0)
         {
            for each(index in this.virtualRendererIndices.concat().sort(sortDecreasing))
            {
               this.removeRendererAt(index);
            }
            this.virtualRendererIndices.length = 0;
            this.oldVirtualRendererIndices.length = 0;
            freeRenderers = this.allFreeRenderers();
            for each(renderer in freeRenderers)
            {
               super.removeChild(renderer as DisplayObject);
            }
            this.resetFreeRenderers();
         }
         else
         {
            for(index = this.indexToRenderer.length - 1; index >= 0; index--)
            {
               this.removeRendererAt(index);
            }
         }
         this.indexToRenderer = [];
         if(Boolean(layout))
         {
            layout.clearVirtualLayoutCache();
            layout.typicalLayoutElement = null;
         }
      }
      
      public function itemToLabel(item:Object) : String
      {
         if(item !== null)
         {
            return item.toString();
         }
         return " ";
      }
      
      public function getItemIndicesInView() : Vector.<int>
      {
         var visibleIndices:Vector.<int> = null;
         var eltR:Rectangle = null;
         var perspectiveProjection:PerspectiveProjection = null;
         var index:int = 0;
         var elt:IVisualElement = null;
         var allIndices:Vector.<int> = null;
         if(Boolean(layout) && layout.useVirtualLayout)
         {
            return Boolean(this.virtualRendererIndices) ? this.virtualRendererIndices.concat() : new Vector.<int>(0);
         }
         if(!this.dataProvider)
         {
            return new Vector.<int>(0);
         }
         var scrollR:Rectangle = scrollRect;
         var dataProviderLength:int = int(this.dataProvider.length);
         if(Boolean(scrollR))
         {
            visibleIndices = new Vector.<int>();
            eltR = new Rectangle();
            perspectiveProjection = transform.perspectiveProjection;
            for(index = 0; index < dataProviderLength; index++)
            {
               elt = this.getElementAt(index);
               if(!(!elt || !elt.visible))
               {
                  if(Boolean(elt.hasLayoutMatrix3D) && Boolean(perspectiveProjection))
                  {
                     eltR.x = 0;
                     eltR.y = 0;
                     eltR.width = elt.getLayoutBoundsWidth(false);
                     eltR.height = elt.getLayoutBoundsHeight(false);
                     MatrixUtil.projectBounds(eltR,elt.getLayoutMatrix3D(),perspectiveProjection);
                  }
                  else
                  {
                     eltR.x = elt.getLayoutBoundsX();
                     eltR.y = elt.getLayoutBoundsY();
                     eltR.width = elt.getLayoutBoundsWidth();
                     eltR.height = elt.getLayoutBoundsHeight();
                  }
                  if(scrollR.intersects(eltR))
                  {
                     visibleIndices.push(index);
                  }
               }
            }
            return visibleIndices;
         }
         allIndices = new Vector.<int>(dataProviderLength);
         for(index = 0; index < dataProviderLength; index++)
         {
            allIndices[index] = index;
         }
         return allIndices;
      }
      
      private function itemToRendererFactory(item:Object) : IFactory
      {
         if(this.itemRendererFunction != null)
         {
            return this.itemRendererFunction(item);
         }
         return this.itemRenderer;
      }
      
      private function createRenderer(factory:IFactory) : IVisualElement
      {
         var element:IVisualElement = factory.newInstance() as IVisualElement;
         this.rendererToFactoryMap[element] = factory;
         return element;
      }
      
      private function allocateRenderer(factory:IFactory) : IVisualElement
      {
         var element:IVisualElement = null;
         var renderers:Vector.<IVisualElement> = this.freeRendererMap[factory] as Vector.<IVisualElement>;
         if(Boolean(renderers))
         {
            element = renderers.pop();
            if(renderers.length == 0)
            {
               delete this.freeRendererMap[factory];
            }
            if(Boolean(element))
            {
               return element;
            }
         }
         return null;
      }
      
      private function freeRenderer(renderer:IVisualElement) : void
      {
         if(!renderer)
         {
            return;
         }
         var factory:IFactory = this.rendererToFactoryMap[renderer];
         if(!factory)
         {
            return;
         }
         var freeRenderers:Vector.<IVisualElement> = this.freeRendererMap[factory];
         if(!freeRenderers)
         {
            freeRenderers = new Vector.<IVisualElement>();
            this.freeRendererMap[factory] = freeRenderers;
         }
         freeRenderers.push(renderer);
      }
      
      private function allFreeRenderers() : Vector.<IVisualElement>
      {
         var v:Vector.<IVisualElement> = null;
         var e:IVisualElement = null;
         var rv:Vector.<IVisualElement> = new Vector.<IVisualElement>();
         for each(v in this.freeRendererMap)
         {
            for each(e in v)
            {
               rv.push(e);
            }
         }
         return rv;
      }
      
      private function resetFreeRenderers() : void
      {
         this.rendererToFactoryMap = new Dictionary(true);
         this.freeRendererMap = new Dictionary();
      }
      
      private function throwCreateRendererFailedError(item:Object) : void
      {
         var err:String = null;
         if(this.itemIsRenderer(item))
         {
            err = resourceManager.getString("components","cannotDisplayVisualElement");
         }
         else
         {
            err = resourceManager.getString("components","unableToCreateRenderer",[item]);
         }
         throw new Error(err);
      }
      
      private function itemIsRenderer(item:Object) : Boolean
      {
         return item is IVisualElement && item is DisplayObject;
      }
      
      private function createVirtualRendererForItem(item:Object, failRTE:Boolean = true) : IVisualElement
      {
         var renderer:IVisualElement = null;
         var rendererFactory:IFactory = this.itemToRendererFactory(item);
         if(Boolean(rendererFactory))
         {
            renderer = this.allocateRenderer(rendererFactory);
         }
         if(!renderer && Boolean(rendererFactory))
         {
            renderer = this.createRenderer(rendererFactory);
            this.addedVirtualRenderer = true;
         }
         if(!renderer && this.itemIsRenderer(item))
         {
            renderer = IVisualElement(item);
            this.addedVirtualRenderer = true;
         }
         if(!renderer && failRTE)
         {
            this.throwCreateRendererFailedError(item);
         }
         return renderer;
      }
      
      private function createRendererForItem(item:Object, failRTE:Boolean = true) : IVisualElement
      {
         var renderer:IVisualElement = null;
         var rendererFactory:IFactory = this.itemToRendererFactory(item);
         if(Boolean(rendererFactory))
         {
            renderer = this.createRenderer(rendererFactory);
         }
         if(!renderer && this.itemIsRenderer(item))
         {
            renderer = IVisualElement(item);
         }
         if(!renderer && failRTE)
         {
            this.throwCreateRendererFailedError(item);
         }
         return renderer;
      }
      
      private function createItemRenderers() : void
      {
         var item:Object = null;
         var renderer:IVisualElement = null;
         if(!this.dataProvider)
         {
            this.removeAllItemRenderers();
            return;
         }
         if(Boolean(layout) && layout.useVirtualLayout)
         {
            if(this.virtualRendererIndices != null && this.virtualRendererIndices.length > 0)
            {
               this.startVirtualLayout();
               this.finishVirtualLayout();
            }
            this.invalidateSize();
            invalidateDisplayList();
            return;
         }
         var dataProviderLength:int = int(this.dataProvider.length);
         for(var index:int = this.indexToRenderer.length - 1; index >= dataProviderLength; index--)
         {
            this.removeRendererAt(index);
         }
         for(index = 0; index < this.indexToRenderer.length; index++)
         {
            item = this.dataProvider.getItemAt(index);
            renderer = this.indexToRenderer[index] as IVisualElement;
            if(Boolean(renderer) && (!this.itemIsRenderer(item) || item == renderer))
            {
               this.setUpItemRenderer(renderer,index,item);
            }
            else
            {
               this.removeRendererAt(index);
               this.itemAdded(item,index);
            }
         }
         for(index = int(this.indexToRenderer.length); index < dataProviderLength; index++)
         {
            this.itemAdded(this.dataProvider.getItemAt(index),index);
         }
      }
      
      override protected function commitProperties() : void
      {
         if(this.itemRendererChanged || this.useVirtualLayoutChanged || this.dataProviderChanged)
         {
            this.itemRendererChanged = false;
            this.useVirtualLayoutChanged = false;
            if(Boolean(layout))
            {
               layout.clearVirtualLayoutCache();
            }
            this.createItemRenderers();
            this.addDataProviderListener();
            if(this.dataProviderChanged)
            {
               this.dataProviderChanged = false;
               verticalScrollPosition = horizontalScrollPosition = 0;
            }
            maskChanged = true;
         }
         super.commitProperties();
         if(Boolean(this._layeringFlags & LAYERING_DIRTY))
         {
            if(Boolean(layout) && layout.useVirtualLayout)
            {
               invalidateDisplayList();
            }
            else
            {
               this.manageDisplayObjectLayers();
            }
         }
         if(this.typicalItemChanged)
         {
            this.typicalItemChanged = false;
            this.initializeTypicalItem();
         }
      }
      
      private function setUpItemRenderer(renderer:IVisualElement, itemIndex:int, data:Object) : void
      {
         if(!renderer)
         {
            return;
         }
         this.renderersBeingUpdated = true;
         this._rendererUpdateDelegate.updateRenderer(renderer,itemIndex,data);
         this.renderersBeingUpdated = false;
      }
      
      public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object) : void
      {
         renderer.owner = this;
         if(renderer is IItemRenderer)
         {
            IItemRenderer(renderer).itemIndex = itemIndex;
         }
         if(renderer is IItemRenderer)
         {
            IItemRenderer(renderer).label = this.itemToLabel(data);
         }
         if(renderer is IDataRenderer && renderer !== data)
         {
            IDataRenderer(renderer).data = data;
         }
      }
      
      private function sortItemAt(index:int, layers:Object, insertIndex:int) : int
      {
         var renderer:IVisualElement = null;
         renderer = this.getElementAt(index);
         var layer:Number = Number(renderer.depth);
         if(layer != 0)
         {
            if(layer > 0)
            {
               if(layers.topLayerItems == null)
               {
                  layers.topLayerItems = new Vector.<IVisualElement>();
               }
               layers.topLayerItems.push(renderer);
            }
            else
            {
               if(layers.bottomLayerItems == null)
               {
                  layers.bottomLayerItems = new Vector.<IVisualElement>();
               }
               layers.bottomLayerItems.push(renderer);
            }
            return insertIndex;
         }
         super.setChildIndex(renderer as DisplayObject,insertIndex);
         return insertIndex + 1;
      }
      
      private function manageDisplayObjectLayers() : void
      {
         var myItemRenderer:IVisualElement = null;
         var i:int = 0;
         var index:int = 0;
         this._layeringFlags &= ~LAYERING_DIRTY;
         var insertIndex:uint = 0;
         var layers:Object = {
            "topLayerItems":null,
            "bottomLayerItems":null
         };
         if(Boolean(layout) && layout.useVirtualLayout)
         {
            for each(index in this.virtualRendererIndices)
            {
               insertIndex = uint(this.sortItemAt(index,layers,insertIndex));
            }
         }
         else
         {
            for(index = 0; index < this.numElements; index++)
            {
               insertIndex = uint(this.sortItemAt(index,layers,insertIndex));
            }
         }
         var topLayerItems:Vector.<IVisualElement> = layers.topLayerItems;
         var bottomLayerItems:Vector.<IVisualElement> = layers.bottomLayerItems;
         var keepLayeringEnabled:Boolean = false;
         var len:int = this.numElements;
         if(topLayerItems != null)
         {
            keepLayeringEnabled = true;
            GroupBase.sortOnLayer(topLayerItems);
            len = int(topLayerItems.length);
            for(i = 0; i < len; i++)
            {
               myItemRenderer = topLayerItems[i];
               super.setChildIndex(myItemRenderer as DisplayObject,insertIndex++);
            }
         }
         if(bottomLayerItems != null)
         {
            keepLayeringEnabled = true;
            insertIndex = 0;
            GroupBase.sortOnLayer(bottomLayerItems);
            len = int(bottomLayerItems.length);
            for(i = 0; i < len; i++)
            {
               myItemRenderer = bottomLayerItems[i];
               super.setChildIndex(myItemRenderer as DisplayObject,insertIndex++);
            }
         }
         if(keepLayeringEnabled == false)
         {
            this._layeringFlags &= ~LAYERING_ENABLED;
         }
      }
      
      override public function get numElements() : int
      {
         return Boolean(this.dataProvider) ? int(this.dataProvider.length) : 0;
      }
      
      private function startVirtualLayout() : void
      {
         var index:int = 0;
         if(!this.virtualRendererIndices)
         {
            this.virtualRendererIndices = new Vector.<int>();
         }
         if(!this.oldVirtualRendererIndices)
         {
            this.oldVirtualRendererIndices = new Vector.<int>();
         }
         this.oldVirtualRendererIndices.length = 0;
         for each(index in this.virtualRendererIndices)
         {
            this.oldVirtualRendererIndices.push(index);
         }
         this.virtualRendererIndices.length = 0;
         this.ensureTypicalLayoutElement();
      }
      
      private function finishVirtualLayout() : void
      {
         var vrIndex:int = 0;
         var depthSortRequired:Boolean = false;
         var elt:IVisualElement = null;
         var item:Object = null;
         if(this.oldVirtualRendererIndices.length == 0)
         {
            return;
         }
         for each(vrIndex in this.oldVirtualRendererIndices)
         {
            if(this.virtualRendererIndices.indexOf(vrIndex) == -1)
            {
               elt = this.indexToRenderer[vrIndex] as IVisualElement;
               delete this.indexToRenderer[vrIndex];
               item = this.dataProvider.length > vrIndex ? this.dataProvider.getItemAt(vrIndex) : null;
               if(item != elt && elt is IDataRenderer)
               {
                  elt.includeInLayout = false;
                  elt.visible = false;
                  this.freeRenderer(elt);
               }
               else if(Boolean(elt))
               {
                  dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE,false,false,elt,vrIndex,item));
                  super.removeChild(DisplayObject(elt));
               }
            }
         }
         depthSortRequired = false;
         for each(vrIndex in this.virtualRendererIndices)
         {
            elt = this.indexToRenderer[vrIndex] as IVisualElement;
            if(!(!elt || !elt.visible || !elt.includeInLayout))
            {
               if(!(elt.width == 0 || elt.height == 0))
               {
                  if(elt.depth != 0)
                  {
                     depthSortRequired = true;
                     break;
                  }
               }
            }
         }
         if(depthSortRequired)
         {
            this.manageDisplayObjectLayers();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearFreeRenderers() : void
      {
         this.resetFreeRenderers();
      }
      
      override public function invalidateSize() : void
      {
         if(!this.virtualLayoutUnderway)
         {
            super.invalidateSize();
         }
      }
      
      override protected function measure() : void
      {
         if(Boolean(layout) && layout.useVirtualLayout)
         {
            this.ensureTypicalLayoutElement();
         }
         super.measure();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         drawBackground();
         if(Boolean(layout) && layout.useVirtualLayout)
         {
            this.virtualLayoutUnderway = true;
            this.startVirtualLayout();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.virtualLayoutUnderway)
         {
            this.finishVirtualLayout();
            this.virtualLayoutUnderway = false;
         }
      }
      
      override public function getElementAt(index:int) : IVisualElement
      {
         if(index < 0 || index >= this.indexToRenderer.length)
         {
            return null;
         }
         return this.indexToRenderer[index];
      }
      
      override public function getVirtualElementAt(index:int, eltWidth:Number = NaN, eltHeight:Number = NaN) : IVisualElement
      {
         var item:Object = null;
         if(index < 0 || this.dataProvider == null || index >= this.dataProvider.length)
         {
            return null;
         }
         var elt:IVisualElement = this.indexToRenderer[index];
         if(this.virtualLayoutUnderway)
         {
            if(this.virtualRendererIndices.indexOf(index) == -1)
            {
               this.virtualRendererIndices.push(index);
            }
            this.addedVirtualRenderer = false;
            if(!elt)
            {
               item = this.dataProvider.getItemAt(index);
               elt = this.createVirtualRendererForItem(item);
               elt.visible = true;
               elt.includeInLayout = true;
               this.indexToRenderer[index] = elt;
               this.addItemRendererToDisplayList(DisplayObject(elt));
               this.setUpItemRenderer(elt,index,item);
            }
            else
            {
               this.addItemRendererToDisplayList(DisplayObject(elt));
            }
            if(elt is ILayoutManagerClient)
            {
               LayoutManager.getInstance().validateClient(elt as ILayoutManagerClient,true);
            }
            if(!isNaN(eltWidth) || !isNaN(eltHeight))
            {
               elt.setLayoutBoundsSize(eltWidth,eltHeight);
            }
            if(this.addedVirtualRenderer)
            {
               dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD,false,false,elt,index,item));
            }
         }
         return elt;
      }
      
      override public function getElementIndex(element:IVisualElement) : int
      {
         if(this.dataProvider == null || element == null)
         {
            return -1;
         }
         return this.indexToRenderer.indexOf(element);
      }
      
      override public function invalidateLayering() : void
      {
         this._layeringFlags |= LAYERING_ENABLED | LAYERING_DIRTY;
         invalidateProperties();
      }
      
      private function resetRendererItemIndex(index:int) : void
      {
         var renderer:IItemRenderer = this.indexToRenderer[index] as IItemRenderer;
         if(Boolean(renderer))
         {
            renderer.itemIndex = index;
         }
      }
      
      private function resetRenderersIndices() : void
      {
         var index:int = 0;
         var indexToRendererLength:int = 0;
         if(this.indexToRenderer.length == 0)
         {
            return;
         }
         if(Boolean(layout) && layout.useVirtualLayout)
         {
            for each(index in this.virtualRendererIndices)
            {
               this.resetRendererItemIndex(index);
            }
         }
         else
         {
            indexToRendererLength = int(this.indexToRenderer.length);
            for(index = 0; index < indexToRendererLength; index++)
            {
               this.resetRendererItemIndex(index);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function itemAdded(item:Object, index:int) : void
      {
         var virtualRendererIndicesLength:int = 0;
         var i:int = 0;
         var vrIndex:int = 0;
         if(Boolean(layout))
         {
            layout.elementAdded(index);
         }
         if(Boolean(layout) && layout.useVirtualLayout)
         {
            if(Boolean(this.virtualRendererIndices))
            {
               virtualRendererIndicesLength = int(this.virtualRendererIndices.length);
               for(i = 0; i < virtualRendererIndicesLength; i++)
               {
                  vrIndex = this.virtualRendererIndices[i];
                  if(vrIndex >= index)
                  {
                     this.virtualRendererIndices[i] = vrIndex + 1;
                  }
               }
               this.indexToRenderer.splice(index,0,null);
            }
            this.invalidateSize();
            invalidateDisplayList();
            return;
         }
         var myItemRenderer:IVisualElement = this.createRendererForItem(item);
         this.indexToRenderer.splice(index,0,myItemRenderer);
         this.addItemRendererToDisplayList(myItemRenderer as DisplayObject,index);
         this.setUpItemRenderer(myItemRenderer,index,item);
         dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD,false,false,myItemRenderer,index,item));
         this.invalidateSize();
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function itemRemoved(item:Object, index:int) : void
      {
         var vrItemIndex:int = 0;
         var virtualRendererIndicesLength:int = 0;
         var i:int = 0;
         var vrIndex:int = 0;
         if(Boolean(layout))
         {
            layout.elementRemoved(index);
         }
         if(Boolean(this.virtualRendererIndices) && this.virtualRendererIndices.length > 0)
         {
            vrItemIndex = -1;
            virtualRendererIndicesLength = int(this.virtualRendererIndices.length);
            for(i = 0; i < virtualRendererIndicesLength; i++)
            {
               vrIndex = this.virtualRendererIndices[i];
               if(vrIndex == index)
               {
                  vrItemIndex = i;
               }
               else if(vrIndex > index)
               {
                  this.virtualRendererIndices[i] = vrIndex - 1;
               }
            }
            if(vrItemIndex != -1)
            {
               this.virtualRendererIndices.splice(vrItemIndex,1);
            }
         }
         var oldRenderer:IVisualElement = this.indexToRenderer[index];
         if(this.indexToRenderer.length > index)
         {
            this.indexToRenderer.splice(index,1);
         }
         dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE,false,false,oldRenderer,index,item));
         if(oldRenderer is IDataRenderer && oldRenderer !== item)
         {
            IDataRenderer(oldRenderer).data = null;
         }
         var child:DisplayObject = oldRenderer as DisplayObject;
         if(Boolean(child))
         {
            super.removeChild(child);
         }
         this.invalidateSize();
         invalidateDisplayList();
      }
      
      private function addItemRendererToDisplayList(child:DisplayObject, index:int = -1) : void
      {
         var childParent:Object = child.parent;
         var overlayCount:int = Boolean(_overlay) ? _overlay.numDisplayObjects : 0;
         var childIndex:int = index != -1 ? index : int(super.numChildren - overlayCount);
         if(childParent == this)
         {
            super.setChildIndex(child,childIndex - 1);
            return;
         }
         if(childParent is DataGroup)
         {
            DataGroup(childParent)._removeChild(child);
         }
         if(Boolean(this._layeringFlags & LAYERING_ENABLED) || child is IVisualElement && (child as IVisualElement).depth != 0)
         {
            this.invalidateLayering();
         }
         super.addChildAt(child,childIndex);
      }
      
      private function addDataProviderListener() : void
      {
         if(Boolean(this._dataProvider))
         {
            this._dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.dataProvider_collectionChangeHandler,false,0,true);
         }
      }
      
      private function removeDataProviderListener() : void
      {
         if(Boolean(this._dataProvider))
         {
            this._dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.dataProvider_collectionChangeHandler);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dataProvider_collectionChangeHandler(event:CollectionEvent) : void
      {
         var i:int = 0;
         var pe:PropertyChangeEvent = null;
         var index:int = 0;
         var renderer:IVisualElement = null;
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.adjustAfterAdd(event.items,event.location);
               break;
            case CollectionEventKind.REPLACE:
               this.adjustAfterReplace(event.items,event.location);
               break;
            case CollectionEventKind.REMOVE:
               this.adjustAfterRemove(event.items,event.location);
               break;
            case CollectionEventKind.MOVE:
               this.adjustAfterMove(event.items[0],event.location,event.oldLocation);
               break;
            case CollectionEventKind.REFRESH:
               this.removeDataProviderListener();
               this.dataProviderChanged = true;
               invalidateProperties();
               break;
            case CollectionEventKind.RESET:
               this.removeDataProviderListener();
               this.dataProviderChanged = true;
               invalidateProperties();
               break;
            case CollectionEventKind.UPDATE:
               if(this.renderersBeingUpdated)
               {
                  break;
               }
               for(i = 0; i < event.items.length; i++)
               {
                  pe = event.items[i];
                  if(Boolean(pe))
                  {
                     index = int(this.dataProvider.getItemIndex(pe.source));
                     renderer = this.indexToRenderer[index];
                     this.setUpItemRenderer(renderer,index,pe.source);
                  }
               }
         }
      }
      
      private function adjustAfterAdd(items:Array, location:int) : void
      {
         var length:int = int(items.length);
         for(var i:int = 0; i < length; i++)
         {
            this.itemAdded(items[i],location + i);
         }
         this.resetRenderersIndices();
      }
      
      private function adjustAfterRemove(items:Array, location:int) : void
      {
         var length:int = int(items.length);
         for(var i:int = length - 1; i >= 0; i--)
         {
            this.itemRemoved(items[i],location + i);
         }
         this.resetRenderersIndices();
      }
      
      private function adjustAfterMove(item:Object, location:int, oldLocation:int) : void
      {
         this.itemRemoved(item,oldLocation);
         this.itemAdded(item,location);
         this.resetRenderersIndices();
      }
      
      private function adjustAfterReplace(items:Array, location:int) : void
      {
         var length:int = int(items.length);
         for(var i:int = length - 1; i >= 0; i--)
         {
            this.itemRemoved(items[i].oldValue,location + i);
         }
         for(i = length - 1; i >= 0; i--)
         {
            this.itemAdded(items[i].newValue,location);
         }
      }
      
      private function _removeChild(child:DisplayObject) : DisplayObject
      {
         return super.removeChild(child);
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","addChildDataGroupError"));
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","addChildAtDataGroupError"));
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","removeChildDataGroupError"));
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         throw new Error(resourceManager.getString("components","removeChildAtDataGroupError"));
      }
      
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         throw new Error(resourceManager.getString("components","setChildIndexDataGroupError"));
      }
      
      override public function swapChildren(child1:DisplayObject, child2:DisplayObject) : void
      {
         throw new Error(resourceManager.getString("components","swapChildrenDataGroupError"));
      }
      
      override public function swapChildrenAt(index1:int, index2:int) : void
      {
         throw new Error(resourceManager.getString("components","swapChildrenAtDataGroupError"));
      }
   }
}

