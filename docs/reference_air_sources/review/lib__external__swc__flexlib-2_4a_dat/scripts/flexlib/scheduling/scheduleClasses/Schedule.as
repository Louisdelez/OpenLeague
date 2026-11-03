package flexlib.scheduling.scheduleClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flexlib.scheduling.ScheduleViewer;
   import flexlib.scheduling.scheduleClasses.layout.BackgroundLayout;
   import flexlib.scheduling.scheduleClasses.layout.BestFitLayout;
   import flexlib.scheduling.scheduleClasses.layout.HorizontalLinesLayout;
   import flexlib.scheduling.scheduleClasses.layout.IBackgroundLayout;
   import flexlib.scheduling.scheduleClasses.layout.IEntryLayout;
   import flexlib.scheduling.scheduleClasses.layout.IHorizontalLinesLayout;
   import flexlib.scheduling.scheduleClasses.layout.IVerticalLinesLayout;
   import flexlib.scheduling.scheduleClasses.layout.LayoutUpdateEvent;
   import flexlib.scheduling.scheduleClasses.layout.VerticalLinesLayout;
   import flexlib.scheduling.scheduleClasses.viewers.BackgroundViewer;
   import flexlib.scheduling.scheduleClasses.viewers.EntryViewer;
   import flexlib.scheduling.scheduleClasses.viewers.HorizontalLinesViewer;
   import flexlib.scheduling.scheduleClasses.viewers.IHorizontalLinesViewer;
   import flexlib.scheduling.scheduleClasses.viewers.IVerticalLinesViewer;
   import flexlib.scheduling.scheduleClasses.viewers.VerticalLinesViewer;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   
   public class Schedule implements IEventDispatcher
   {
      
      public var horizontalLinesLayoutImpl:IHorizontalLinesLayout;
      
      public var isViewlayersInitialized:Boolean;
      
      public var entryViewer:EntryViewer;
      
      private var _horizontalLinesViewer:IFactory;
      
      public var backgroundLayoutImpl:IBackgroundLayout;
      
      private var owner:ScheduleViewer;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _entryLayoutImpl:IEntryLayout;
      
      private var _horizontalLinesLayout:IFactory;
      
      public var navigator:ScheduleNavigator;
      
      public var verticalLinesViewerImpl:IVerticalLinesViewer;
      
      private var _backgroundLayout:IFactory;
      
      public var backgroundViewer:BackgroundViewer;
      
      private var _verticalLinesViewer:IFactory;
      
      public var horizontalLinesViewerImpl:IHorizontalLinesViewer;
      
      public var verticalLinesLayoutImpl:IVerticalLinesLayout;
      
      private var _verticalLinesLayout:IFactory;
      
      public var content:UIComponent;
      
      private var _entryLayout:IFactory;
      
      public function Schedule(owner:ScheduleViewer)
      {
         super();
         this.owner = owner;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return _bindingEventDispatcher.hasEventListener(type);
      }
      
      private function createVerticalLinesViewer() : void
      {
         if(_verticalLinesViewer == null)
         {
            verticalLinesViewer = new ClassFactory(VerticalLinesViewer);
            verticalLinesViewerImpl = IVerticalLinesViewer(_verticalLinesViewer.newInstance());
         }
         else
         {
            verticalLinesViewerImpl = IVerticalLinesViewer(_verticalLinesViewer.newInstance());
         }
      }
      
      private function set _1356639684entryLayout(value:IFactory) : void
      {
         if(value != null && value != _entryLayout)
         {
            _entryLayout = value;
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return _bindingEventDispatcher.willTrigger(type);
      }
      
      public function initialize() : void
      {
         isViewlayersInitialized = false;
         createEntryLayout();
         createEntryViewer();
         createBackgroundLayout();
         createHorizontalLinesLayout();
         createHorizontalLinesViewer();
         createVerticalLinesLayout();
         createVerticalLinesViewer();
      }
      
      private function createHorizontalLinesViewer() : void
      {
         if(_horizontalLinesViewer == null)
         {
            horizontalLinesViewer = new ClassFactory(HorizontalLinesViewer);
            horizontalLinesViewerImpl = IHorizontalLinesViewer(_horizontalLinesViewer.newInstance());
         }
         else
         {
            horizontalLinesViewerImpl = IHorizontalLinesViewer(_horizontalLinesViewer.newInstance());
         }
      }
      
      public function initializeEntryLayout() : void
      {
         if(owner.dataProvider != null)
         {
            entryLayoutImpl.dataProvider = IList(owner.dataProvider);
         }
      }
      
      private function set _1559225515entryRenderer(value:IFactory) : void
      {
         if(value != null && value != entryViewer.entryRenderer)
         {
            entryViewer.entryRenderer = value;
         }
      }
      
      public function initializeRuntimeViewLayers() : void
      {
         createEntryLayout();
         createBackgroundLayout();
         createHorizontalLinesLayout();
         createHorizontalLinesViewer();
         createVerticalLinesLayout();
         createVerticalLinesViewer();
         entryLayoutImpl.addEventListener(LayoutUpdateEvent.UPDATE,entryViewer.update);
         backgroundLayoutImpl.addEventListener(LayoutUpdateEvent.UPDATE,backgroundViewer.update);
         horizontalLinesLayoutImpl.addEventListener(LayoutUpdateEvent.UPDATE,horizontalLinesViewerImpl.update);
         verticalLinesLayoutImpl.addEventListener(LayoutUpdateEvent.UPDATE,verticalLinesViewerImpl.update);
         entryLayoutImpl.addEventListener(LayoutUpdateEvent.UPDATE,backgroundLayoutImpl.update);
         entryLayoutImpl.addEventListener(LayoutUpdateEvent.UPDATE,horizontalLinesLayoutImpl.update);
         entryLayoutImpl.addEventListener(LayoutUpdateEvent.UPDATE,verticalLinesLayoutImpl.update);
         initializeViewLayerProperties();
      }
      
      private function createEntryViewer() : void
      {
         if(entryViewer == null)
         {
            entryViewer = new EntryViewer();
         }
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
      public function get verticalLinesViewer() : IFactory
      {
         return _verticalLinesViewer;
      }
      
      private function createVerticalLinesLayout() : void
      {
         var timeRanges:IList = null;
         var minimumTimeRangeWidth:Number = NaN;
         if(_verticalLinesLayout == null)
         {
            verticalLinesLayout = new ClassFactory(VerticalLinesLayout);
            verticalLinesLayoutImpl = IVerticalLinesLayout(_verticalLinesLayout.newInstance());
         }
         else
         {
            timeRanges = verticalLinesLayoutImpl.timeRanges;
            minimumTimeRangeWidth = verticalLinesLayoutImpl.minimumTimeRangeWidth;
            verticalLinesLayoutImpl = IVerticalLinesLayout(_verticalLinesLayout.newInstance());
            verticalLinesLayoutImpl.timeRanges = timeRanges;
            verticalLinesLayoutImpl.minimumTimeRangeWidth = minimumTimeRangeWidth;
         }
      }
      
      private function createEntryLayout() : void
      {
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var startDate:Date = null;
         var endDate:Date = null;
         var rowHeight:Number = NaN;
         if(_entryLayout == null)
         {
            entryLayout = new ClassFactory(BestFitLayout);
            entryLayoutImpl = IEntryLayout(_entryLayout.newInstance());
         }
         else
         {
            contentWidth = Number(entryLayoutImpl.contentWidth);
            contentHeight = Number(entryLayoutImpl.contentHeight);
            startDate = entryLayoutImpl.startDate;
            endDate = entryLayoutImpl.endDate;
            rowHeight = entryLayoutImpl.rowHeight;
            entryLayoutImpl = IEntryLayout(_entryLayout.newInstance());
            entryLayoutImpl.contentWidth = contentWidth;
            entryLayoutImpl.contentHeight = contentHeight;
            entryLayoutImpl.startDate = startDate;
            entryLayoutImpl.endDate = endDate;
            entryLayoutImpl.rowHeight = rowHeight;
         }
      }
      
      private function set _1047065445verticalLinesViewer(value:IFactory) : void
      {
         if(value != null && value != _verticalLinesViewer)
         {
            _verticalLinesViewer = value;
         }
      }
      
      private function createHorizontalLinesLayout() : void
      {
         if(_horizontalLinesLayout == null)
         {
            horizontalLinesLayout = new ClassFactory(HorizontalLinesLayout);
            horizontalLinesLayoutImpl = IHorizontalLinesLayout(_horizontalLinesLayout.newInstance());
         }
         else
         {
            horizontalLinesLayoutImpl = IHorizontalLinesLayout(_horizontalLinesLayout.newInstance());
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
      
      private function createBackgroundLayout() : void
      {
         var backgroundItems:IList = null;
         var timeRanges:IList = null;
         var minimumTimeRangeWidth:Number = NaN;
         if(_horizontalLinesLayout == null)
         {
            backgroundLayout = new ClassFactory(BackgroundLayout);
            backgroundLayoutImpl = IBackgroundLayout(_backgroundLayout.newInstance());
         }
         else
         {
            backgroundItems = backgroundLayoutImpl.backgroundItems;
            timeRanges = backgroundLayoutImpl.timeRanges;
            minimumTimeRangeWidth = backgroundLayoutImpl.minimumTimeRangeWidth;
            backgroundLayoutImpl = IBackgroundLayout(_backgroundLayout.newInstance());
            backgroundLayoutImpl.backgroundItems = backgroundItems;
            backgroundLayoutImpl.timeRanges = timeRanges;
            backgroundLayoutImpl.minimumTimeRangeWidth = minimumTimeRangeWidth;
         }
      }
      
      [Bindable]
      public function get horizontalLinesViewer() : IFactory
      {
         return _horizontalLinesViewer;
      }
      
      private function set _142239675horizontalLinesLayout(value:IFactory) : void
      {
         if(value != null && value != _horizontalLinesLayout)
         {
            _horizontalLinesLayout = value;
         }
      }
      
      private function set _1340156493verticalLinesLayout(value:IFactory) : void
      {
         if(value != null && value != _verticalLinesLayout)
         {
            _verticalLinesLayout = value;
         }
      }
      
      [Bindable]
      public function get entryLayout() : IFactory
      {
         return _entryLayout;
      }
      
      [Bindable]
      public function get verticalLinesLayout() : IFactory
      {
         return _verticalLinesLayout;
      }
      
      [Bindable]
      public function get horizontalLinesLayout() : IFactory
      {
         return _horizontalLinesLayout;
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return _bindingEventDispatcher.dispatchEvent(event);
      }
      
      private function set _150851373horizontalLinesViewer(value:IFactory) : void
      {
         if(value != null && value != _horizontalLinesViewer)
         {
            _horizontalLinesViewer = value;
         }
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
      
      private function initializeViewLayerProperties() : void
      {
         var entryViewerIndex:int = 0;
         if(entryRenderer == null)
         {
            entryRenderer = entryViewer.entryRenderer;
         }
         else
         {
            entryViewer.entryRenderer = entryRenderer;
         }
         horizontalLinesViewerImpl.dottedGridLines = owner.getStyle("dottedGridLines");
         horizontalLinesViewerImpl.horizontalGridLineThickness = owner.getStyle("horizontalGridLineThickness");
         horizontalLinesViewerImpl.horizontalGridLineColor = owner.getStyle("horizontalGridLineColor");
         horizontalLinesViewerImpl.horizontalGridLineAlpha = owner.getStyle("horizontalGridLineAlpha");
         verticalLinesViewerImpl.dottedGridLines = owner.getStyle("dottedGridLines");
         verticalLinesViewerImpl.verticalGridLineThickness = owner.getStyle("verticalGridLineThickness");
         verticalLinesViewerImpl.verticalGridLineColor = owner.getStyle("verticalGridLineColor");
         verticalLinesViewerImpl.verticalGridLineAlpha = owner.getStyle("verticalGridLineAlpha");
         entryViewerIndex = int(content.getChildIndex(entryViewer));
         content.addChildAt(UIComponent(horizontalLinesViewerImpl),entryViewerIndex);
         content.addChildAt(UIComponent(verticalLinesViewerImpl),entryViewerIndex);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         _bindingEventDispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false) : void
      {
         _bindingEventDispatcher.addEventListener(type,listener,useCapture,priority,weakRef);
      }
      
      [Bindable]
      public function get entryRenderer() : IFactory
      {
         return entryViewer.entryRenderer;
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
      
      public function initializeCompileTimeViewLayers() : void
      {
         backgroundViewer = new BackgroundViewer();
         createEntryViewer();
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
      
      [Bindable]
      public function get backgroundLayout() : IFactory
      {
         return _backgroundLayout;
      }
      
      private function set _1491280376backgroundLayout(value:IFactory) : void
      {
         if(value != null && value != _backgroundLayout)
         {
            _backgroundLayout = value;
         }
      }
      
      public function get entryLayoutImpl() : IEntryLayout
      {
         return _entryLayoutImpl;
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
      
      public function set entryLayoutImpl(value:IEntryLayout) : void
      {
         navigator.entryLayoutImpl = value;
         _entryLayoutImpl = value;
      }
   }
}

