package flexlib.scheduling
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import flexlib.scheduling.scheduleClasses.LayoutScrollEvent;
   import flexlib.scheduling.scheduleClasses.Schedule;
   import flexlib.scheduling.scheduleClasses.ScheduleNavigator;
   import flexlib.scheduling.scheduleClasses.layout.IEntryLayout;
   import flexlib.scheduling.scheduleClasses.schedule_internal;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.IFactory;
   import mx.core.ScrollControlBase;
   import mx.core.UIComponent;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.events.ScrollEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   use namespace schedule_internal;
   
   [Style(name="verticalGridLineAlpha",type="Number",inherit="yes")]
   [Style(name="verticalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="verticalGridLineThickness",type="Number",format="Length",inherit="yes")]
   [Style(name="horizontalGridLineAlpha",type="Number",inherit="yes")]
   [Style(name="horizontalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="horizontalGridLineThickness",type="Number",format="Length",inherit="yes")]
   [Style(name="dottedGridLines",type="Boolean",inherit="yes")]
   [Style(name="entryStyleName",type="String",inherit="yes")]
   [Style(name="moveEasingFunction",type="Function",inherit="yes")]
   [Style(name="moveDuration",type="Number",format="Time",inherit="yes")]
   [Event(name="pixelScroll",type="flexlib.scheduling.scheduleClasses.LayoutScrollEvent")]
   [Event(name="itemScroll",type="flexlib.scheduling.scheduleClasses.LayoutScrollEvent")]
   public class ScheduleViewer extends ScrollControlBase
   {
      
      private static var classConstructed:Boolean = classConstruct();
      
      private var content:UIComponent;
      
      private var _timeRanges:IList;
      
      private var _minimumTimeRangeWidth:Number;
      
      private var navigator:ScheduleNavigator;
      
      private var schedule:Schedule;
      
      protected var collection:ICollectionView;
      
      public function ScheduleViewer()
      {
         super();
         schedule = new Schedule(this);
         navigator = new ScheduleNavigator(this);
         navigator.addEventListener(ScheduleNavigator.INVALIDATE_DISPLAY_LIST,onInvalidateDisplayList);
         schedule.navigator = navigator;
         schedule.initialize();
      }
      
      private static function classConstruct() : Boolean
      {
         var newStyleDeclaration:CSSStyleDeclaration = null;
         if(!StyleManager.getStyleDeclaration("ScheduleViewer"))
         {
            newStyleDeclaration = new CSSStyleDeclaration();
            newStyleDeclaration.setStyle("moveDuration",1000);
            newStyleDeclaration.setStyle("dottedGridLines",true);
            newStyleDeclaration.setStyle("horizontalGridLineThickness",1);
            newStyleDeclaration.setStyle("horizontalGridLineColor",0);
            newStyleDeclaration.setStyle("horizontalGridLineAlpha",0.5);
            newStyleDeclaration.setStyle("verticalGridLineThickness",1);
            newStyleDeclaration.setStyle("verticalGridLineColor",0);
            newStyleDeclaration.setStyle("verticalGridLineAlpha",0.5);
            StyleManager.setStyleDeclaration("ScheduleViewer",newStyleDeclaration,true);
         }
         return true;
      }
      
      [Bindable]
      public function get timeRanges() : IList
      {
         return _timeRanges;
      }
      
      [Bindable(event="propertyChange")]
      public function set timeRanges(value:IList) : void
      {
         var oldValue:Object = null;
         oldValue = this.timeRanges;
         if(oldValue !== value)
         {
            this._746987523timeRanges = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeRanges",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set backgroundLayout(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.backgroundLayout;
         if(oldValue !== value)
         {
            this._1491280376backgroundLayout = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundLayout",oldValue,value));
         }
      }
      
      private function set _683600801rowHeight(value:Number) : void
      {
         schedule.entryLayoutImpl.rowHeight = value;
         schedule.entryLayoutImpl.createLayout();
         invalidateDisplayList();
      }
      
      [Bindable]
      public function get horizontalLinesLayout() : IFactory
      {
         return schedule.horizontalLinesLayout;
      }
      
      [Bindable]
      public function get selectedItem() : IScheduleEntry
      {
         return schedule.entryViewer.selectedItem;
      }
      
      [Bindable]
      public function get verticalLinesViewer() : IFactory
      {
         return schedule.verticalLinesViewer;
      }
      
      [Bindable(event="propertyChange")]
      public function set horizontalLinesLayout(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.horizontalLinesLayout;
         if(oldValue !== value)
         {
            this._142239675horizontalLinesLayout = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalLinesLayout",oldValue,value));
         }
      }
      
      private function set _260391140minimumTimeRangeWidth(value:Number) : void
      {
         _minimumTimeRangeWidth = value;
         schedule.backgroundLayoutImpl.minimumTimeRangeWidth = _minimumTimeRangeWidth;
         schedule.verticalLinesLayoutImpl.minimumTimeRangeWidth = _minimumTimeRangeWidth;
         invalidateDisplayList();
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(Boolean(verticalScrollBar))
         {
            event.stopPropagation();
            navigator.mouseWheelHandler(event);
         }
      }
      
      private function set _1333721663xPosition(value:Number) : void
      {
         navigator.xPosition = value;
      }
      
      [Bindable]
      public function get contentWidth() : Number
      {
         return navigator.contentWidth;
      }
      
      [Bindable]
      public function get yPosition() : Number
      {
         return navigator.yPosition;
      }
      
      public function gotoEntry(entry:IScheduleEntry) : void
      {
         navigator.gotoEntry(entry);
      }
      
      private function set _3744723zoom(value:Number) : void
      {
         navigator.zoom = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set yOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.yOffset;
         if(oldValue !== value)
         {
            this._1922149780yOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yOffset",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set entryLayout(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.entryLayout;
         if(oldValue !== value)
         {
            this._1356639684entryLayout = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"entryLayout",oldValue,value));
         }
      }
      
      [Bindable]
      public function get minimumTimeRangeWidth() : Number
      {
         return _minimumTimeRangeWidth;
      }
      
      private function set _1356639684entryLayout(value:IFactory) : void
      {
         schedule.entryLayout = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set selectedItem(value:IScheduleEntry) : void
      {
         var oldValue:Object = null;
         oldValue = this.selectedItem;
         if(oldValue !== value)
         {
            this._1754784690selectedItem = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedItem",oldValue,value));
         }
      }
      
      [Bindable]
      public function get allowMultipleSelection() : Boolean
      {
         return schedule.entryViewer.allowMultipleSelection;
      }
      
      private function set _2129778896startDate(value:Date) : void
      {
         schedule.entryLayoutImpl.startDate = value;
         invalidateDisplayList();
      }
      
      [Bindable(event="propertyChange")]
      public function set verticalLinesViewer(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.verticalLinesViewer;
         if(oldValue !== value)
         {
            this._1047065445verticalLinesViewer = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalLinesViewer",oldValue,value));
         }
      }
      
      private function set _1642973933allowMultipleSelection(value:Boolean) : void
      {
         schedule.entryViewer.allowMultipleSelection = value;
      }
      
      protected function modelChangedHandler(event:CollectionEvent) : void
      {
         var entryLayoutImpl:IEntryLayout = null;
         if(schedule.isViewlayersInitialized)
         {
            entryLayoutImpl = IEntryLayout(schedule.entryLayoutImpl);
            if(event.kind == CollectionEventKind.ADD)
            {
               entryLayoutImpl.addItem(event);
            }
            else if(event.kind == CollectionEventKind.REMOVE)
            {
               entryLayoutImpl.removeItem(event);
            }
            else if(event.kind == CollectionEventKind.REPLACE)
            {
               entryLayoutImpl.replaceItem(event);
            }
            else if(event.kind == CollectionEventKind.UPDATE)
            {
               entryLayoutImpl.updateItem(event);
            }
            else if(event.kind == CollectionEventKind.REFRESH)
            {
               entryLayoutImpl.refreshItem(event);
            }
            else if(event.kind == CollectionEventKind.RESET)
            {
               entryLayoutImpl.resetItem(event);
            }
            else if(event.kind == CollectionEventKind.MOVE)
            {
               entryLayoutImpl.moveItem(event);
            }
            invalidateDisplayList();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set yPosition(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.yPosition;
         if(oldValue !== value)
         {
            this._1153791170yPosition = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yPosition",oldValue,value));
         }
      }
      
      [Bindable]
      public function get xPositionWithOffset() : Number
      {
         return navigator.xPositionWithOffset;
      }
      
      private function set _1559225515entryRenderer(value:IFactory) : void
      {
         schedule.entryRenderer = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set pixelScrollEnabled(value:Boolean) : void
      {
         var oldValue:Object = null;
         oldValue = this.pixelScrollEnabled;
         if(oldValue !== value)
         {
            this._2047120078pixelScrollEnabled = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pixelScrollEnabled",oldValue,value));
         }
      }
      
      public function moveToEntry(entry:IScheduleEntry) : void
      {
         navigator.moveToEntry(entry);
      }
      
      [Bindable(event="propertyChange")]
      public function set contentWidth(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.contentWidth;
         if(oldValue !== value)
         {
            this._824110285contentWidth = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentWidth",oldValue,value));
         }
      }
      
      [Bindable]
      public function get verticalLinesLayout() : IFactory
      {
         return schedule.verticalLinesLayout;
      }
      
      [Bindable]
      public function get xPosition() : Number
      {
         return navigator.xPosition;
      }
      
      override protected function commitProperties() : void
      {
         if(!schedule.isViewlayersInitialized)
         {
            schedule.isViewlayersInitialized = true;
            if(isNaN(contentWidth) && width != 0)
            {
               contentWidth = width;
            }
            schedule.initializeRuntimeViewLayers();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set minimumTimeRangeWidth(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.minimumTimeRangeWidth;
         if(oldValue !== value)
         {
            this._260391140minimumTimeRangeWidth = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minimumTimeRangeWidth",oldValue,value));
         }
      }
      
      [Bindable]
      public function get backgroundLayout() : IFactory
      {
         return schedule.backgroundLayout;
      }
      
      [Bindable]
      public function get selectedItems() : Array
      {
         return schedule.entryViewer.selectedItems;
      }
      
      private function set _1607727319endDate(value:Date) : void
      {
         schedule.entryLayoutImpl.endDate = value;
         invalidateDisplayList();
      }
      
      private function set _1153791170yPosition(value:Number) : void
      {
         navigator.yPosition = value;
      }
      
      private function set _2047120078pixelScrollEnabled(value:Boolean) : void
      {
         navigator.pixelScrollEnabled = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set allowMultipleSelection(value:Boolean) : void
      {
         var oldValue:Object = null;
         oldValue = this.allowMultipleSelection;
         if(oldValue !== value)
         {
            this._1642973933allowMultipleSelection = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowMultipleSelection",oldValue,value));
         }
      }
      
      [Bindable]
      public function get entryLayout() : IFactory
      {
         return schedule.entryLayout;
      }
      
      private function set _150851373horizontalLinesViewer(value:IFactory) : void
      {
         schedule.horizontalLinesViewer = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set xOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.xOffset;
         if(oldValue !== value)
         {
            this._1485313835xOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xOffset",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set endDate(value:Date) : void
      {
         var oldValue:Object = null;
         oldValue = this.endDate;
         if(oldValue !== value)
         {
            this._1607727319endDate = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endDate",oldValue,value));
         }
      }
      
      private function set _1436249573selectedItems(value:Array) : void
      {
         schedule.entryViewer.selectedItems = value;
      }
      
      private function set _1922149780yOffset(value:Number) : void
      {
         navigator.yOffset = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set backgroundItems(value:IList) : void
      {
         var oldValue:Object = null;
         oldValue = this.backgroundItems;
         if(oldValue !== value)
         {
            this._1292807986backgroundItems = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundItems",oldValue,value));
         }
      }
      
      private function set _1491280376backgroundLayout(value:IFactory) : void
      {
         schedule.backgroundLayout = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set startDate(value:Date) : void
      {
         var oldValue:Object = null;
         oldValue = this.startDate;
         if(oldValue !== value)
         {
            this._2129778896startDate = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"startDate",oldValue,value));
         }
      }
      
      [Bindable]
      public function get yOffset() : Number
      {
         return navigator.yOffset;
      }
      
      [Bindable(event="propertyChange")]
      public function set horizontalLinesViewer(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.horizontalLinesViewer;
         if(oldValue !== value)
         {
            this._150851373horizontalLinesViewer = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalLinesViewer",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set entryRenderer(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.entryRenderer;
         if(oldValue !== value)
         {
            this._1559225515entryRenderer = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"entryRenderer",oldValue,value));
         }
      }
      
      private function set _1340156493verticalLinesLayout(value:IFactory) : void
      {
         schedule.verticalLinesLayout = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set yPositionWithOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.yPositionWithOffset;
         if(oldValue !== value)
         {
            this._973577051yPositionWithOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yPositionWithOffset",oldValue,value));
         }
      }
      
      [Bindable]
      public function get pixelScrollEnabled() : Boolean
      {
         return navigator.pixelScrollEnabled;
      }
      
      public function gotoTime(milliseconds:Number) : void
      {
         navigator.gotoTime(milliseconds);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addEventListener(ScrollEvent.SCROLL,navigator.onScroll);
         addEventListener(LayoutScrollEvent.PIXEL_SCROLL,scrollHandler);
         content = new UIComponent();
         schedule.content = content;
         addChild(content);
         content.mask = maskShape;
         schedule.initializeCompileTimeViewLayers();
         content.addChild(schedule.backgroundViewer);
         content.addChild(schedule.entryViewer);
         invalidateProperties();
      }
      
      [Bindable]
      public function get endDate() : Date
      {
         return schedule.entryLayoutImpl.endDate;
      }
      
      [Bindable]
      public function get xOffset() : Number
      {
         return navigator.xOffset;
      }
      
      [Bindable]
      public function get horizontalLinesViewer() : IFactory
      {
         return schedule.horizontalLinesViewer;
      }
      
      [Bindable]
      public function get backgroundItems() : IList
      {
         return schedule.backgroundLayoutImpl.backgroundItems;
      }
      
      [Bindable(event="propertyChange")]
      public function set xPositionWithOffset(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.xPositionWithOffset;
         if(oldValue !== value)
         {
            this._1818048922xPositionWithOffset = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xPositionWithOffset",oldValue,value));
         }
      }
      
      schedule_internal function get verticalScrollBar() : ScrollBar
      {
         return verticalScrollBar;
      }
      
      private function set _142239675horizontalLinesLayout(value:IFactory) : void
      {
         schedule.horizontalLinesLayout = value;
      }
      
      public function moveToTime(milliseconds:Number) : void
      {
         navigator.moveToTime(milliseconds);
      }
      
      [Bindable]
      public function get startDate() : Date
      {
         return schedule.entryLayoutImpl.startDate;
      }
      
      private function set _1292807986backgroundItems(value:IList) : void
      {
         schedule.backgroundLayoutImpl.backgroundItems = value;
      }
      
      [Bindable]
      public function get entryRenderer() : IFactory
      {
         return schedule.entryRenderer;
      }
      
      [Bindable(event="propertyChange")]
      public function set rowHeight(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.rowHeight;
         if(oldValue !== value)
         {
            this._683600801rowHeight = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowHeight",oldValue,value));
         }
      }
      
      private function set _1818048922xPositionWithOffset(value:Number) : void
      {
         navigator.xPositionWithOffset = value;
      }
      
      [Bindable]
      public function get yPositionWithOffset() : Number
      {
         return navigator.yPositionWithOffset;
      }
      
      [Bindable(event="propertyChange")]
      public function set verticalLinesLayout(value:IFactory) : void
      {
         var oldValue:Object = null;
         oldValue = this.verticalLinesLayout;
         if(oldValue !== value)
         {
            this._1340156493verticalLinesLayout = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalLinesLayout",oldValue,value));
         }
      }
      
      public function set dataProvider(value:Object) : void
      {
         var event:CollectionEvent = null;
         var tmp:Array = null;
         if(Boolean(collection))
         {
            collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE,modelChangedHandler);
         }
         if(value is ICollectionView)
         {
            collection = ICollectionView(value);
         }
         else if(value is Array)
         {
            collection = new ArrayCollection(value as Array);
         }
         else
         {
            tmp = [];
            if(value != null)
            {
               tmp.push(value);
            }
            collection = new ArrayCollection(tmp);
         }
         collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,modelChangedHandler);
         event = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         schedule.initializeEntryLayout();
         modelChangedHandler(event);
         dispatchEvent(event);
      }
      
      [Bindable(event="propertyChange")]
      public function set xPosition(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.xPosition;
         if(oldValue !== value)
         {
            this._1333721663xPosition = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xPosition",oldValue,value));
         }
      }
      
      private function set _1485313835xOffset(value:Number) : void
      {
         navigator.xOffset = value;
      }
      
      [Bindable]
      public function get rowHeight() : Number
      {
         return schedule.entryLayoutImpl.rowHeight;
      }
      
      private function set _973577051yPositionWithOffset(value:Number) : void
      {
         navigator.yPositionWithOffset = value;
      }
      
      private function onInvalidateDisplayList(event:Event) : void
      {
         invalidateDisplayList();
      }
      
      [Bindable(event="propertyChange")]
      public function set zoom(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.zoom;
         if(oldValue !== value)
         {
            this._3744723zoom = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"zoom",oldValue,value));
         }
      }
      
      private function set _1047065445verticalLinesViewer(value:IFactory) : void
      {
         schedule.verticalLinesViewer = value;
      }
      
      public function get dataProvider() : Object
      {
         return collection;
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         navigator.scrollHandler(event);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var entryStyleName:String = null;
         super.styleChanged(styleProp);
         if(styleProp != null)
         {
            if(Object(schedule.horizontalLinesViewerImpl).hasOwnProperty(styleProp))
            {
               schedule.horizontalLinesViewerImpl[styleProp] = getStyle(styleProp);
            }
            if(Object(schedule.verticalLinesViewerImpl).hasOwnProperty(styleProp))
            {
               schedule.verticalLinesViewerImpl[styleProp] = getStyle(styleProp);
            }
         }
         entryStyleName = getStyle("entryStyleName");
         if(Boolean(entryStyleName))
         {
            schedule.entryViewer.setStyle("entryStyleName",entryStyleName);
         }
      }
      
      [Bindable]
      public function get zoom() : Number
      {
         return navigator.zoom;
      }
      
      private function set _1754784690selectedItem(value:IScheduleEntry) : void
      {
         schedule.entryViewer.selectedItem = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set selectedItems(value:Array) : void
      {
         var oldValue:Object = null;
         oldValue = this.selectedItems;
         if(oldValue !== value)
         {
            this._1436249573selectedItems = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedItems",oldValue,value));
         }
      }
      
      private function set _824110285contentWidth(value:Number) : void
      {
         navigator.contentWidth = value;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         schedule.entryLayoutImpl.viewportWidth = unscaledWidth;
         schedule.entryLayoutImpl.viewportHeight = unscaledHeight;
         schedule.entryLayoutImpl.update();
         navigator.updateItemScroll();
         setScrollBarProperties(schedule.entryLayoutImpl.contentWidth + navigator.contentWidthOffset,unscaledWidth,schedule.entryLayoutImpl.contentHeight + navigator.contentHeightOffset,unscaledHeight);
      }
      
      private function set _746987523timeRanges(value:IList) : void
      {
         _timeRanges = value;
         schedule.backgroundLayoutImpl.timeRanges = _timeRanges;
         schedule.verticalLinesLayoutImpl.timeRanges = _timeRanges;
         invalidateDisplayList();
      }
   }
}

