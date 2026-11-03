package mx.core
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import mx.binding.BindingManager;
   import mx.containers.utilityClasses.PostScaleAdapter;
   import mx.controls.HScrollBar;
   import mx.controls.VScrollBar;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.geom.RoundedRectangle;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.ILayoutManagerClient;
   import mx.managers.ISystemManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.styles.StyleProtoChain;
   
   [ResourceBundle("core")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="verticalScrollBarStyleName",type="String",inherit="no")]
   [Style(name="horizontalScrollBarStyleName",type="String",inherit="no")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="disabledOverlayAlpha",type="Number",inherit="no")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark")]
   [Style(name="backgroundAttachment",type="String",inherit="no")]
   [Style(name="accentColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="halo, spark")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="halo, spark")]
   [Style(name="shadowDistance",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="shadowDirection",type="String",enumeration="left,center,right",inherit="no",theme="halo")]
   [Style(name="dropShadowColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="dropShadowEnabled",type="Boolean",inherit="no",theme="halo")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderThickness",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderStyle",type="String",enumeration="inset,outset,solid,none",inherit="no")]
   [Style(name="borderSkin",type="Class",inherit="no")]
   [Style(name="borderSides",type="String",inherit="no",theme="halo")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo, spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark")]
   [Style(name="backgroundSize",type="String",inherit="no",theme="halo")]
   [Style(name="backgroundImage",type="Object",format="File",inherit="no",theme="halo")]
   [Style(name="backgroundDisabledColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="barColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Event(name="scroll",type="mx.events.ScrollEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="childRemove",type="mx.events.ChildExistenceChangedEvent")]
   [Event(name="childIndexChange",type="mx.events.IndexChangedEvent")]
   [Event(name="childAdd",type="mx.events.ChildExistenceChangedEvent")]
   public class Container extends UIComponent implements IContainer, IDataRenderer, IFocusManagerContainer, IListItemRenderer, IRawChildrenContainer, IChildList, IVisualElementContainer, INavigatorContent
   {
      
      private static var haloBorder:Class;
      
      private static var sparkBorder:Class;
      
      private static var sparkContainerBorder:Class;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const MULTIPLE_PROPERTIES:String = "<MULTIPLE>";
      
      private static var didLookup:Boolean = false;
      
      protected var actualCreationPolicy:String;
      
      private var numChildrenBefore:int;
      
      private var recursionFlag:Boolean = true;
      
      private var forceLayout:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var doingLayout:Boolean = false;
      
      private var changedStyles:String = null;
      
      private var _creatingContentPane:Boolean = false;
      
      protected var whiteBox:Shape;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var contentPane:Sprite = null;
      
      private var scrollPropertiesChanged:Boolean = false;
      
      private var scrollPositionChanged:Boolean = true;
      
      private var horizontalScrollPositionPending:Number;
      
      private var verticalScrollPositionPending:Number;
      
      private var scrollableWidth:Number = 0;
      
      private var scrollableHeight:Number = 0;
      
      private var viewableWidth:Number = 0;
      
      private var viewableHeight:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var border:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var blocker:Sprite;
      
      private var mouseEventReferenceCount:int = 0;
      
      private var richEditableTextClass:Class;
      
      private var _focusPane:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _numChildren:int = 0;
      
      private var _autoLayout:Boolean = true;
      
      private var _childDescriptors:Array;
      
      private var _childRepeaters:Array;
      
      private var _clipContent:Boolean = true;
      
      private var _createdComponents:Array;
      
      private var _creationIndex:int = -1;
      
      private var creationPolicyNone:Boolean = false;
      
      private var _defaultButton:IFlexDisplayObject;
      
      private var _data:Object;
      
      private var _firstChildIndex:int = 0;
      
      private var _horizontalLineScrollSize:Number = 5;
      
      private var _horizontalPageScrollSize:Number = 0;
      
      private var _horizontalScrollBar:ScrollBar;
      
      private var _horizontalScrollPosition:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _horizontalScrollPolicy:String = "auto";
      
      private var _icon:Class = null;
      
      private var _label:String = "";
      
      private var _numChildrenCreated:int = -1;
      
      private var _rawChildren:ContainerRawChildrenList;
      
      private var _verticalLineScrollSize:Number = 5;
      
      private var _verticalPageScrollSize:Number = 0;
      
      private var _verticalScrollBar:ScrollBar;
      
      private var _verticalScrollPosition:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _verticalScrollPolicy:String = "auto";
      
      private var _viewMetrics:EdgeMetrics;
      
      private var _viewMetricsAndPadding:EdgeMetrics;
      
      private var _forceClippingCount:int;
      
      public function Container()
      {
         super();
         tabEnabled = false;
         tabFocusEnabled = false;
         showInAutomationHierarchy = false;
         if(ApplicationDomain.currentDomain.hasDefinition("spark.components.RichEditableText"))
         {
            this.richEditableTextClass = Class(ApplicationDomain.currentDomain.getDefinition("spark.components.RichEditableText"));
         }
      }
      
      private static function getDefinition(name:String) : Class
      {
         var result:Object = null;
         try
         {
            result = getDefinitionByName(name);
         }
         catch(e:Error)
         {
         }
         return result as Class;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLayoutChildAt(index:int) : IUIComponent
      {
         return PostScaleAdapter.getCompatibleIUIComponent(this.getChildAt(index));
      }
      
      public function get creatingContentPane() : Boolean
      {
         return this._creatingContentPane;
      }
      
      public function set creatingContentPane(value:Boolean) : void
      {
         this._creatingContentPane = value;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         var lineMetrics:TextLineMetrics = measureText("Wj");
         if(height < 2 * this.viewMetrics.top + 4 + lineMetrics.ascent)
         {
            return int(height + (lineMetrics.ascent - height) / 2);
         }
         return this.viewMetrics.top + 2 + lineMetrics.ascent;
      }
      
      override public function get contentMouseX() : Number
      {
         if(Boolean(this.contentPane))
         {
            return this.contentPane.mouseX;
         }
         return super.contentMouseX;
      }
      
      override public function get contentMouseY() : Number
      {
         if(Boolean(this.contentPane))
         {
            return this.contentPane.mouseY;
         }
         return super.contentMouseY;
      }
      
      override public function set doubleClickEnabled(value:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:InteractiveObject = null;
         super.doubleClickEnabled = value;
         if(Boolean(this.contentPane))
         {
            n = this.contentPane.numChildren;
            for(i = 0; i < n; i++)
            {
               child = this.contentPane.getChildAt(i) as InteractiveObject;
               if(Boolean(child))
               {
                  child.doubleClickEnabled = value;
               }
            }
         }
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(this.horizontalScrollBar))
         {
            this.horizontalScrollBar.enabled = value;
         }
         if(Boolean(this.verticalScrollBar))
         {
            this.verticalScrollBar.enabled = value;
         }
         invalidateProperties();
         if(Boolean(this.border) && this.border is IInvalidating)
         {
            IInvalidating(this.border).invalidateDisplayList();
         }
      }
      
      override public function get focusPane() : Sprite
      {
         return this._focusPane;
      }
      
      override public function set focusPane(o:Sprite) : void
      {
         var oldInvalidateSizeFlag:Boolean = Boolean(invalidateSizeFlag);
         var oldInvalidateDisplayListFlag:Boolean = Boolean(invalidateDisplayListFlag);
         invalidateSizeFlag = true;
         invalidateDisplayListFlag = true;
         if(Boolean(o))
         {
            this.rawChildren.addChild(o);
            o.x = 0;
            o.y = 0;
            o.scrollRect = null;
            this._focusPane = o;
         }
         else
         {
            this.rawChildren.removeChild(this._focusPane);
            this._focusPane = null;
         }
         if(Boolean(o) && Boolean(this.contentPane))
         {
            o.x = this.contentPane.x;
            o.y = this.contentPane.y;
            o.scrollRect = this.contentPane.scrollRect;
         }
         invalidateSizeFlag = oldInvalidateSizeFlag;
         invalidateDisplayListFlag = oldInvalidateDisplayListFlag;
      }
      
      override public function set moduleFactory(moduleFactory:IFlexModuleFactory) : void
      {
         super.moduleFactory = moduleFactory;
         styleManager.registerInheritingStyle("_creationPolicy");
      }
      
      final §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get $numChildren() : int
      {
         return super.numChildren;
      }
      
      override public function get numChildren() : int
      {
         return Boolean(this.contentPane) ? this.contentPane.numChildren : this._numChildren;
      }
      
      [Inspectable(defaultValue="true")]
      public function get autoLayout() : Boolean
      {
         return this._autoLayout;
      }
      
      public function set autoLayout(value:Boolean) : void
      {
         var p:IInvalidating = null;
         this._autoLayout = value;
         if(value)
         {
            invalidateSize();
            invalidateDisplayList();
            p = parent as IInvalidating;
            if(Boolean(p))
            {
               p.invalidateSize();
               p.invalidateDisplayList();
            }
         }
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         return Boolean(this.border) && this.border is IRectangularBorder ? IRectangularBorder(this.border).borderMetrics : EdgeMetrics.EMPTY;
      }
      
      public function get childDescriptors() : Array
      {
         return this._childDescriptors;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get childRepeaters() : Array
      {
         return this._childRepeaters;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set childRepeaters(value:Array) : void
      {
         this._childRepeaters = value;
      }
      
      [Inspectable(defaultValue="true")]
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(value:Boolean) : void
      {
         if(this._clipContent != value)
         {
            this._clipContent = value;
            invalidateDisplayList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get createdComponents() : Array
      {
         return this._createdComponents;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set createdComponents(value:Array) : void
      {
         this._createdComponents = value;
      }
      
      [Deprecated]
      [Inspectable(defaultValue="undefined")]
      public function get creationIndex() : int
      {
         return this._creationIndex;
      }
      
      public function set creationIndex(value:int) : void
      {
         this._creationIndex = value;
      }
      
      [Inspectable(enumeration="all,auto,none")]
      public function get creationPolicy() : String
      {
         if(this.creationPolicyNone)
         {
            return ContainerCreationPolicy.NONE;
         }
         return getStyle("_creationPolicy");
      }
      
      public function set creationPolicy(value:String) : void
      {
         var styleValue:String = value;
         if(value == ContainerCreationPolicy.NONE)
         {
            this.creationPolicyNone = true;
            styleValue = ContainerCreationPolicy.AUTO;
         }
         else
         {
            this.creationPolicyNone = false;
         }
         setStyle("_creationPolicy",styleValue);
         this.setActualCreationPolicies(value);
      }
      
      [Inspectable(category="General")]
      public function get defaultButton() : IFlexDisplayObject
      {
         return this._defaultButton;
      }
      
      public function set defaultButton(value:IFlexDisplayObject) : void
      {
         this._defaultButton = value;
         ContainerGlobals.focusedContainer = null;
      }
      
      public function get deferredContentCreated() : Boolean
      {
         return processedDescriptors;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get firstChildIndex() : int
      {
         return this._firstChildIndex;
      }
      
      [Inspectable(defaultValue="5")]
      [Bindable("horizontalLineScrollSizeChanged")]
      public function get horizontalLineScrollSize() : Number
      {
         return this._horizontalLineScrollSize;
      }
      
      public function set horizontalLineScrollSize(value:Number) : void
      {
         this.scrollPropertiesChanged = true;
         this._horizontalLineScrollSize = value;
         invalidateDisplayList();
         dispatchEvent(new Event("horizontalLineScrollSizeChanged"));
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("horizontalPageScrollSizeChanged")]
      public function get horizontalPageScrollSize() : Number
      {
         return this._horizontalPageScrollSize;
      }
      
      public function set horizontalPageScrollSize(value:Number) : void
      {
         this.scrollPropertiesChanged = true;
         this._horizontalPageScrollSize = value;
         invalidateDisplayList();
         dispatchEvent(new Event("horizontalPageScrollSizeChanged"));
      }
      
      public function get horizontalScrollBar() : ScrollBar
      {
         return this._horizontalScrollBar;
      }
      
      public function set horizontalScrollBar(value:ScrollBar) : void
      {
         this._horizontalScrollBar = value;
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get horizontalScrollPosition() : Number
      {
         if(!isNaN(this.horizontalScrollPositionPending))
         {
            return this.horizontalScrollPositionPending;
         }
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(value:Number) : void
      {
         if(this._horizontalScrollPosition == value)
         {
            return;
         }
         this._horizontalScrollPosition = value;
         this.scrollPositionChanged = true;
         if(!initialized)
         {
            this.horizontalScrollPositionPending = value;
         }
         invalidateDisplayList();
         dispatchEvent(new Event("viewChanged"));
      }
      
      [Inspectable(category="General",enumeration="off,on,auto",defaultValue="auto")]
      [Bindable("horizontalScrollPolicyChanged")]
      public function get horizontalScrollPolicy() : String
      {
         return this._horizontalScrollPolicy;
      }
      
      public function set horizontalScrollPolicy(value:String) : void
      {
         if(this._horizontalScrollPolicy != value)
         {
            this._horizontalScrollPolicy = value;
            invalidateDisplayList();
            dispatchEvent(new Event("horizontalScrollPolicyChanged"));
         }
      }
      
      [Inspectable(category="General",defaultValue="",format="EmbeddedFile")]
      [Bindable("iconChanged")]
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function set icon(value:Class) : void
      {
         this._icon = value;
         dispatchEvent(new Event("iconChanged"));
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this._label = value;
         dispatchEvent(new Event("labelChanged"));
      }
      
      public function get maxHorizontalScrollPosition() : Number
      {
         return Boolean(this.horizontalScrollBar) ? this.horizontalScrollBar.maxScrollPosition : Math.max(this.scrollableWidth - this.viewableWidth,0);
      }
      
      public function get maxVerticalScrollPosition() : Number
      {
         return Boolean(this.verticalScrollBar) ? this.verticalScrollBar.maxScrollPosition : Math.max(this.scrollableHeight - this.viewableHeight,0);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get numChildrenCreated() : int
      {
         return this._numChildrenCreated;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set numChildrenCreated(value:int) : void
      {
         this._numChildrenCreated = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get numRepeaters() : int
      {
         return Boolean(this.childRepeaters) ? int(this.childRepeaters.length) : 0;
      }
      
      public function get rawChildren() : IChildList
      {
         if(!this._rawChildren)
         {
            this._rawChildren = new ContainerRawChildrenList(this);
         }
         return this._rawChildren;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get usePadding() : Boolean
      {
         return true;
      }
      
      [Inspectable(defaultValue="5")]
      [Bindable("verticalLineScrollSizeChanged")]
      public function get verticalLineScrollSize() : Number
      {
         return this._verticalLineScrollSize;
      }
      
      public function set verticalLineScrollSize(value:Number) : void
      {
         this.scrollPropertiesChanged = true;
         this._verticalLineScrollSize = value;
         invalidateDisplayList();
         dispatchEvent(new Event("verticalLineScrollSizeChanged"));
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("verticalPageScrollSizeChanged")]
      public function get verticalPageScrollSize() : Number
      {
         return this._verticalPageScrollSize;
      }
      
      public function set verticalPageScrollSize(value:Number) : void
      {
         this.scrollPropertiesChanged = true;
         this._verticalPageScrollSize = value;
         invalidateDisplayList();
         dispatchEvent(new Event("verticalPageScrollSizeChanged"));
      }
      
      public function get verticalScrollBar() : ScrollBar
      {
         return this._verticalScrollBar;
      }
      
      public function set verticalScrollBar(value:ScrollBar) : void
      {
         this._verticalScrollBar = value;
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get verticalScrollPosition() : Number
      {
         if(!isNaN(this.verticalScrollPositionPending))
         {
            return this.verticalScrollPositionPending;
         }
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(value:Number) : void
      {
         if(this._verticalScrollPosition == value)
         {
            return;
         }
         this._verticalScrollPosition = value;
         this.scrollPositionChanged = true;
         if(!initialized)
         {
            this.verticalScrollPositionPending = value;
         }
         invalidateDisplayList();
         dispatchEvent(new Event("viewChanged"));
      }
      
      [Inspectable(category="General",enumeration="off,on,auto",defaultValue="auto")]
      [Bindable("verticalScrollPolicyChanged")]
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function set verticalScrollPolicy(value:String) : void
      {
         if(this._verticalScrollPolicy != value)
         {
            this._verticalScrollPolicy = value;
            invalidateDisplayList();
            dispatchEvent(new Event("verticalScrollPolicyChanged"));
         }
      }
      
      public function get viewMetrics() : EdgeMetrics
      {
         var bm:EdgeMetrics = this.borderMetrics;
         var verticalScrollBarIncluded:Boolean = this.verticalScrollBar != null && (this.doingLayout || this.verticalScrollPolicy == ScrollPolicy.ON);
         var horizontalScrollBarIncluded:Boolean = this.horizontalScrollBar != null && (this.doingLayout || this.horizontalScrollPolicy == ScrollPolicy.ON);
         if(!verticalScrollBarIncluded && !horizontalScrollBarIncluded)
         {
            return bm;
         }
         if(!this._viewMetrics)
         {
            this._viewMetrics = bm.clone();
         }
         else
         {
            this._viewMetrics.left = bm.left;
            this._viewMetrics.right = bm.right;
            this._viewMetrics.top = bm.top;
            this._viewMetrics.bottom = bm.bottom;
         }
         if(verticalScrollBarIncluded)
         {
            this._viewMetrics.right += this.verticalScrollBar.minWidth;
         }
         if(horizontalScrollBarIncluded)
         {
            this._viewMetrics.bottom += this.horizontalScrollBar.minHeight;
         }
         return this._viewMetrics;
      }
      
      public function get viewMetricsAndPadding() : EdgeMetrics
      {
         if(Boolean(this._viewMetricsAndPadding) && (Boolean(!this.horizontalScrollBar || this.horizontalScrollPolicy == ScrollPolicy.ON)) && (!this.verticalScrollBar || this.verticalScrollPolicy == ScrollPolicy.ON))
         {
            return this._viewMetricsAndPadding;
         }
         if(!this._viewMetricsAndPadding)
         {
            this._viewMetricsAndPadding = new EdgeMetrics();
         }
         var o:EdgeMetrics = this._viewMetricsAndPadding;
         var vm:EdgeMetrics = this.viewMetrics;
         o.left = vm.left + getStyle("paddingLeft");
         o.right = vm.right + getStyle("paddingRight");
         o.top = vm.top + getStyle("paddingTop");
         o.bottom = vm.bottom + getStyle("paddingBottom");
         return o;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         if(type == MouseEvent.CLICK || type == MouseEvent.DOUBLE_CLICK || type == MouseEvent.MOUSE_DOWN || type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_OVER || type == MouseEvent.MOUSE_OUT || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_WHEEL)
         {
            if(this.mouseEventReferenceCount < 2147483647 && this.mouseEventReferenceCount++ == 0)
            {
               setStyle("mouseShield",true);
               setStyle("mouseShieldChildren",true);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         if(type == MouseEvent.CLICK || type == MouseEvent.DOUBLE_CLICK || type == MouseEvent.MOUSE_DOWN || type == MouseEvent.MOUSE_MOVE || type == MouseEvent.MOUSE_OVER || type == MouseEvent.MOUSE_OUT || type == MouseEvent.MOUSE_UP || type == MouseEvent.MOUSE_WHEEL)
         {
            if(this.mouseEventReferenceCount > 0 && --this.mouseEventReferenceCount == 0)
            {
               setStyle("mouseShield",false);
               setStyle("mouseShieldChildren",false);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         return this.addChildAt(child,this.numChildren);
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         var formerParent:DisplayObjectContainer = child.parent;
         if(Boolean(formerParent) && !(formerParent is Loader))
         {
            if(formerParent == this)
            {
               index = index == this.numChildren ? int(index - 1) : index;
            }
            formerParent.removeChild(child);
         }
         this.addingChild(child);
         if(Boolean(this.contentPane))
         {
            this.contentPane.addChildAt(child,index);
         }
         else
         {
            $addChildAt(child,this._firstChildIndex + index);
         }
         this.childAdded(child);
         if(child is UIComponent && Boolean(UIComponent(child).isDocument))
         {
            BindingManager.setEnabled(child,true);
         }
         return child;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         var n:int = 0;
         var i:int = 0;
         if(child is IDeferredInstantiationUIComponent && Boolean(IDeferredInstantiationUIComponent(child).descriptor))
         {
            if(Boolean(this.createdComponents))
            {
               n = int(this.createdComponents.length);
               for(i = 0; i < n; i++)
               {
                  if(this.createdComponents[i] === child)
                  {
                     this.createdComponents.splice(i,1);
                  }
               }
            }
         }
         this.removingChild(child);
         if(child is UIComponent && Boolean(UIComponent(child).isDocument))
         {
            BindingManager.setEnabled(child,false);
         }
         if(Boolean(this.contentPane))
         {
            this.contentPane.removeChild(child);
         }
         else
         {
            $removeChild(child);
         }
         this.childRemoved(child);
         return child;
      }
      
      override public function removeChildAt(index:int) : DisplayObject
      {
         return this.removeChild(this.getChildAt(index));
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         if(Boolean(this.contentPane))
         {
            return this.contentPane.getChildAt(index);
         }
         return super.getChildAt(this._firstChildIndex + index);
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         var child:DisplayObject = null;
         var index:int = 0;
         if(Boolean(this.contentPane))
         {
            return this.contentPane.getChildByName(name);
         }
         child = super.getChildByName(name);
         if(!child)
         {
            return null;
         }
         index = super.getChildIndex(child) - this._firstChildIndex;
         if(index < 0 || index >= this._numChildren)
         {
            return null;
         }
         return child;
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         var index:int = 0;
         if(Boolean(this.contentPane))
         {
            return this.contentPane.getChildIndex(child);
         }
         return int(super.getChildIndex(child) - this._firstChildIndex);
      }
      
      override public function setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         var oldIndex:int = 0;
         var eventOldIndex:int = oldIndex;
         var eventNewIndex:int = newIndex;
         if(Boolean(this.contentPane))
         {
            this.contentPane.setChildIndex(child,newIndex);
            if(this._autoLayout || this.forceLayout)
            {
               invalidateDisplayList();
            }
         }
         else
         {
            oldIndex = super.getChildIndex(child);
            newIndex += this._firstChildIndex;
            if(newIndex == oldIndex)
            {
               return;
            }
            super.setChildIndex(child,newIndex);
            invalidateDisplayList();
            eventOldIndex = oldIndex - this._firstChildIndex;
            eventNewIndex = newIndex - this._firstChildIndex;
         }
         var event:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHILD_INDEX_CHANGE);
         event.relatedObject = child;
         event.oldIndex = eventOldIndex;
         event.newIndex = eventNewIndex;
         dispatchEvent(event);
         dispatchEvent(new Event("childrenChanged"));
      }
      
      override public function contains(child:DisplayObject) : Boolean
      {
         if(Boolean(this.contentPane))
         {
            return this.contentPane.contains(child);
         }
         return super.contains(child);
      }
      
      public function get numElements() : int
      {
         return this.numChildren;
      }
      
      public function getElementAt(index:int) : IVisualElement
      {
         return this.getChildAt(index) as IVisualElement;
      }
      
      public function getElementIndex(element:IVisualElement) : int
      {
         if(!(element is DisplayObject))
         {
            throw ArgumentError(element + " is not found in this Container");
         }
         return this.getChildIndex(element as DisplayObject);
      }
      
      public function addElement(element:IVisualElement) : IVisualElement
      {
         if(!(element is DisplayObject))
         {
            throw ArgumentError(element + " is not supported in this Container");
         }
         return this.addChild(element as DisplayObject) as IVisualElement;
      }
      
      public function addElementAt(element:IVisualElement, index:int) : IVisualElement
      {
         if(!(element is DisplayObject))
         {
            throw ArgumentError(element + " is not supported in this Container");
         }
         return this.addChildAt(element as DisplayObject,index) as IVisualElement;
      }
      
      public function removeElement(element:IVisualElement) : IVisualElement
      {
         if(!(element is DisplayObject))
         {
            throw ArgumentError(element + " is not found in this Container");
         }
         return this.removeChild(element as DisplayObject) as IVisualElement;
      }
      
      public function removeElementAt(index:int) : IVisualElement
      {
         return this.removeChildAt(index) as IVisualElement;
      }
      
      public function removeAllElements() : void
      {
         for(var i:int = this.numElements - 1; i >= 0; i--)
         {
            this.removeElementAt(i);
         }
      }
      
      public function setElementIndex(element:IVisualElement, index:int) : void
      {
         if(!(element is DisplayObject))
         {
            throw ArgumentError(element + " is not found in this Container");
         }
         return this.setChildIndex(element as DisplayObject,index);
      }
      
      public function swapElements(element1:IVisualElement, element2:IVisualElement) : void
      {
         if(!(element1 is DisplayObject))
         {
            throw ArgumentError(element1 + " is not found in this Container");
         }
         if(!(element2 is DisplayObject))
         {
            throw ArgumentError(element2 + " is not found in this Container");
         }
         swapChildren(element1 as DisplayObject,element2 as DisplayObject);
      }
      
      public function swapElementsAt(index1:int, index2:int) : void
      {
         swapChildrenAt(index1,index2);
      }
      
      override public function initialize() : void
      {
         var props:* = undefined;
         var message:String = null;
         if(Boolean(documentDescriptor) && !processedDescriptors)
         {
            props = documentDescriptor.properties;
            if(Boolean(props) && Boolean(props.childDescriptors))
            {
               if(Boolean(this._childDescriptors))
               {
                  message = resourceManager.getString("core","multipleChildSets_ClassAndInstance");
                  throw new Error(message);
               }
               this._childDescriptors = props.childDescriptors;
            }
         }
         super.initialize();
      }
      
      override protected function createChildren() : void
      {
         var mainApp:* = undefined;
         super.createChildren();
         this.createBorder();
         this.createOrDestroyScrollbars(this.horizontalScrollPolicy == ScrollPolicy.ON,this.verticalScrollPolicy == ScrollPolicy.ON,this.horizontalScrollPolicy == ScrollPolicy.ON || this.verticalScrollPolicy == ScrollPolicy.ON);
         if(this.actualCreationPolicy == null)
         {
            if(this.creationPolicy != null)
            {
               this.actualCreationPolicy = this.creationPolicy;
            }
            if(this.actualCreationPolicy == ContainerCreationPolicy.QUEUED)
            {
               this.actualCreationPolicy = ContainerCreationPolicy.AUTO;
            }
         }
         if(this.actualCreationPolicy == ContainerCreationPolicy.NONE)
         {
            this.actualCreationPolicy = ContainerCreationPolicy.AUTO;
         }
         else if(this.actualCreationPolicy == ContainerCreationPolicy.QUEUED)
         {
            mainApp = Boolean(parentApplication) ? parentApplication : FlexGlobals.topLevelApplication;
            if("addToCreationQueue" in mainApp)
            {
               mainApp.addToCreationQueue(this,this._creationIndex,null,this);
            }
            else
            {
               this.createComponentsFromDescriptors();
            }
         }
         else if(this.recursionFlag)
         {
            this.createComponentsFromDescriptors();
         }
         if(this.autoLayout == false)
         {
            this.forceLayout = true;
         }
         UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE,this.layoutCompleteHandler,false,0,true);
      }
      
      override protected function initializationComplete() : void
      {
      }
      
      override public function invalidateLayoutDirection() : void
      {
         var rawNumChildren:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         super.invalidateLayoutDirection();
         if(Boolean(this._rawChildren))
         {
            rawNumChildren = this._rawChildren.numChildren;
            for(i = 0; i < rawNumChildren; i++)
            {
               child = this._rawChildren.getChildAt(i);
               if(!(child is IStyleClient) && child is ILayoutDirectionElement)
               {
                  ILayoutDirectionElement(child).invalidateLayoutDirection();
               }
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var styleProp:String = null;
         super.commitProperties();
         if(Boolean(this.changedStyles))
         {
            styleProp = this.changedStyles == MULTIPLE_PROPERTIES ? null : this.changedStyles;
            super.notifyStyleChangeInChildren(styleProp,true);
            this.changedStyles = null;
         }
         this.createOrDestroyBlocker();
      }
      
      override public function validateSize(recursive:Boolean = false) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         if(this.autoLayout == false && this.forceLayout == false)
         {
            if(recursive)
            {
               n = super.numChildren;
               for(i = 0; i < n; i++)
               {
                  child = super.getChildAt(i);
                  if(child is ILayoutManagerClient)
                  {
                     ILayoutManagerClient(child).validateSize(true);
                  }
               }
            }
            adjustSizesForScaleChanges();
         }
         else
         {
            super.validateSize(recursive);
         }
      }
      
      override public function validateDisplayList() : void
      {
         var vm:EdgeMetrics = null;
         var w:Number = NaN;
         var h:Number = NaN;
         var bgColor:Object = null;
         var blockerAlpha:Number = NaN;
         var widthToBlock:Number = NaN;
         var heightToBlock:Number = NaN;
         if(this._autoLayout || this.forceLayout)
         {
            this.doingLayout = true;
            super.validateDisplayList();
            this.doingLayout = false;
         }
         else
         {
            this.layoutChrome(unscaledWidth,unscaledHeight);
         }
         invalidateDisplayListFlag = true;
         if(this.createContentPaneAndScrollbarsIfNeeded())
         {
            if(this._autoLayout || this.forceLayout)
            {
               this.doingLayout = true;
               super.validateDisplayList();
               this.doingLayout = false;
            }
            this.createContentPaneAndScrollbarsIfNeeded();
         }
         if(this.clampScrollPositions())
         {
            this.scrollChildren();
         }
         if(Boolean(this.contentPane))
         {
            vm = this.viewMetrics;
            if(Boolean(effectOverlay))
            {
               effectOverlay.x = 0;
               effectOverlay.y = 0;
               effectOverlay.width = unscaledWidth;
               effectOverlay.height = unscaledHeight;
            }
            if(Boolean(this.horizontalScrollBar) || Boolean(this.verticalScrollBar))
            {
               if(Boolean(this.verticalScrollBar) && this.verticalScrollPolicy == ScrollPolicy.ON)
               {
                  vm.right -= this.verticalScrollBar.minWidth;
               }
               if(Boolean(this.horizontalScrollBar) && this.horizontalScrollPolicy == ScrollPolicy.ON)
               {
                  vm.bottom -= this.horizontalScrollBar.minHeight;
               }
               if(Boolean(this.horizontalScrollBar))
               {
                  w = unscaledWidth - vm.left - vm.right;
                  if(Boolean(this.verticalScrollBar))
                  {
                     w -= this.verticalScrollBar.minWidth;
                  }
                  this.horizontalScrollBar.setActualSize(w,this.horizontalScrollBar.minHeight);
                  this.horizontalScrollBar.move(vm.left,unscaledHeight - vm.bottom - this.horizontalScrollBar.minHeight);
               }
               if(Boolean(this.verticalScrollBar))
               {
                  h = unscaledHeight - vm.top - vm.bottom;
                  if(Boolean(this.horizontalScrollBar))
                  {
                     h -= this.horizontalScrollBar.minHeight;
                  }
                  this.verticalScrollBar.setActualSize(this.verticalScrollBar.minWidth,h);
                  this.verticalScrollBar.move(unscaledWidth - vm.right - this.verticalScrollBar.minWidth,vm.top);
               }
               if(Boolean(this.whiteBox))
               {
                  this.whiteBox.x = this.verticalScrollBar.x;
                  this.whiteBox.y = this.horizontalScrollBar.y;
               }
            }
            this.contentPane.x = vm.left;
            this.contentPane.y = vm.top;
            if(Boolean(this.focusPane))
            {
               this.focusPane.x = vm.left;
               this.focusPane.y = vm.top;
            }
            this.scrollChildren();
         }
         invalidateDisplayListFlag = false;
         if(Boolean(this.blocker))
         {
            vm = this.viewMetrics;
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
            {
               vm = EdgeMetrics.EMPTY;
            }
            bgColor = enabled ? null : getStyle("backgroundDisabledColor");
            if(bgColor === null || isNaN(Number(bgColor)))
            {
               bgColor = getStyle("backgroundColor");
            }
            if(bgColor === null || isNaN(Number(bgColor)))
            {
               bgColor = 16777215;
            }
            blockerAlpha = Number(getStyle("disabledOverlayAlpha"));
            if(isNaN(blockerAlpha))
            {
               blockerAlpha = 0.6;
            }
            this.blocker.x = vm.left;
            this.blocker.y = vm.top;
            widthToBlock = unscaledWidth - (vm.left + vm.right);
            heightToBlock = unscaledHeight - (vm.top + vm.bottom);
            this.blocker.graphics.clear();
            this.blocker.graphics.beginFill(uint(bgColor),blockerAlpha);
            this.blocker.graphics.drawRect(0,0,widthToBlock,heightToBlock);
            this.blocker.graphics.endFill();
            this.rawChildren.setChildIndex(this.blocker,this.rawChildren.numChildren - 1);
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var backgroundColor:Object = null;
         var backgroundAlpha:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.layoutChrome(unscaledWidth,unscaledHeight);
         if(this.scrollPositionChanged)
         {
            this.clampScrollPositions();
            this.scrollChildren();
            this.scrollPositionChanged = false;
         }
         if(this.scrollPropertiesChanged)
         {
            if(Boolean(this.horizontalScrollBar))
            {
               this.horizontalScrollBar.lineScrollSize = this.horizontalLineScrollSize;
               this.horizontalScrollBar.pageScrollSize = this.horizontalPageScrollSize;
            }
            if(Boolean(this.verticalScrollBar))
            {
               this.verticalScrollBar.lineScrollSize = this.verticalLineScrollSize;
               this.verticalScrollBar.pageScrollSize = this.verticalPageScrollSize;
            }
            this.scrollPropertiesChanged = false;
         }
         if(Boolean(this.contentPane) && Boolean(this.contentPane.scrollRect))
         {
            backgroundColor = enabled ? null : getStyle("backgroundDisabledColor");
            if(backgroundColor === null || isNaN(Number(backgroundColor)))
            {
               backgroundColor = getStyle("backgroundColor");
            }
            backgroundAlpha = Number(getStyle("backgroundAlpha"));
            if(!this._clipContent || isNaN(Number(backgroundColor)) || backgroundColor === "" || !(Boolean(this.horizontalScrollBar) || Boolean(this.verticalScrollBar)) && !cacheAsBitmap)
            {
               backgroundColor = null;
            }
            else if(Boolean(getStyle("backgroundImage")) || Boolean(getStyle("background")))
            {
               backgroundColor = null;
            }
            else if(backgroundAlpha != 1)
            {
               backgroundColor = null;
            }
            this.contentPane.opaqueBackground = backgroundColor;
            this.contentPane.cacheAsBitmap = backgroundColor != null;
         }
      }
      
      override public function contentToGlobal(point:Point) : Point
      {
         if(Boolean(this.contentPane))
         {
            return this.contentPane.localToGlobal(point);
         }
         return localToGlobal(point);
      }
      
      override public function globalToContent(point:Point) : Point
      {
         if(Boolean(this.contentPane))
         {
            return this.contentPane.globalToLocal(point);
         }
         return globalToLocal(point);
      }
      
      override public function contentToLocal(point:Point) : Point
      {
         if(!this.contentPane)
         {
            return point;
         }
         point = this.contentToGlobal(point);
         return globalToLocal(point);
      }
      
      override public function localToContent(point:Point) : Point
      {
         if(!this.contentPane)
         {
            return point;
         }
         point = localToGlobal(point);
         return this.globalToContent(point);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var horizontalScrollBarStyleName:String = null;
         var verticalScrollBarStyleName:String = null;
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         if(allStyles || Boolean(styleManager.isSizeInvalidatingStyle(styleProp)))
         {
            invalidateDisplayList();
         }
         if(allStyles || styleProp == "borderSkin")
         {
            if(Boolean(this.border))
            {
               this.rawChildren.removeChild(DisplayObject(this.border));
               this.border = null;
               this.createBorder();
            }
         }
         if(allStyles || styleProp == "borderStyle" || styleProp == "backgroundColor" || styleProp == "backgroundImage" || styleProp == "mouseShield" || styleProp == "mouseShieldChildren")
         {
            this.createBorder();
         }
         super.styleChanged(styleProp);
         if(allStyles || Boolean(styleManager.isSizeInvalidatingStyle(styleProp)))
         {
            this.invalidateViewMetricsAndPadding();
         }
         if(allStyles || styleProp == "horizontalScrollBarStyleName")
         {
            if(Boolean(this.horizontalScrollBar) && this.horizontalScrollBar is ISimpleStyleClient)
            {
               horizontalScrollBarStyleName = getStyle("horizontalScrollBarStyleName");
               ISimpleStyleClient(this.horizontalScrollBar).styleName = horizontalScrollBarStyleName;
            }
         }
         if(allStyles || styleProp == "verticalScrollBarStyleName")
         {
            if(Boolean(this.verticalScrollBar) && this.verticalScrollBar is ISimpleStyleClient)
            {
               verticalScrollBarStyleName = getStyle("verticalScrollBarStyleName");
               ISimpleStyleClient(this.verticalScrollBar).styleName = verticalScrollBarStyleName;
            }
         }
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         var child:ISimpleStyleClient = null;
         var n:int = super.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(this.contentPane) || Boolean(i < this._firstChildIndex) || i >= this._firstChildIndex + this._numChildren)
            {
               child = super.getChildAt(i) as ISimpleStyleClient;
               if(Boolean(child))
               {
                  child.styleChanged(styleProp);
                  if(child is IStyleClient)
                  {
                     IStyleClient(child).notifyStyleChangeInChildren(styleProp,recursive);
                  }
               }
            }
         }
         if(recursive)
         {
            this.changedStyles = this.changedStyles != null || styleProp == null ? MULTIPLE_PROPERTIES : styleProp;
            invalidateProperties();
         }
      }
      
      override public function regenerateStyleCache(recursive:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         super.regenerateStyleCache(recursive);
         if(Boolean(this.contentPane))
         {
            n = this.contentPane.numChildren;
            for(i = 0; i < n; i++)
            {
               child = this.getChildAt(i);
               if(child is UIComponent)
               {
                  if(UIComponent(child).inheritingStyles != StyleProtoChain.STYLE_UNINITIALIZED)
                  {
                     UIComponent(child).regenerateStyleCache(recursive);
                  }
               }
               else if(child is IUITextField && Boolean(IUITextField(child).inheritingStyles))
               {
                  StyleProtoChain.initTextField(IUITextField(child));
               }
            }
         }
      }
      
      override protected function attachOverlay() : void
      {
         this.rawChildren_addChild(effectOverlay);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function fillOverlay(overlay:UIComponent, color:uint, targetArea:RoundedRectangle = null) : void
      {
         var vm:EdgeMetrics = this.viewMetrics;
         var cornerRadius:Number = 0;
         if(!targetArea)
         {
            targetArea = new RoundedRectangle(vm.left,vm.top,unscaledWidth - vm.right - vm.left,unscaledHeight - vm.bottom - vm.top,cornerRadius);
         }
         if(isNaN(targetArea.x) || isNaN(targetArea.y) || isNaN(targetArea.width) || isNaN(targetArea.height) || isNaN(targetArea.cornerRadius))
         {
            return;
         }
         var g:Graphics = overlay.graphics;
         g.clear();
         g.beginFill(color);
         g.drawRoundRect(targetArea.x,targetArea.y,targetArea.width,targetArea.height,targetArea.cornerRadius * 2,targetArea.cornerRadius * 2);
         g.endFill();
      }
      
      override public function executeBindings(recurse:Boolean = false) : void
      {
         var bindingsHost:Object = Boolean(descriptor) && Boolean(descriptor.document) ? descriptor.document : parentDocument;
         BindingManager.executeBindings(bindingsHost,id,this);
         if(recurse)
         {
            this.executeChildBindings(recurse);
         }
      }
      
      override public function prepareToPrint(target:IFlexDisplayObject) : Object
      {
         var rect:Rectangle = Boolean(this.contentPane) && Boolean(this.contentPane.scrollRect) ? this.contentPane.scrollRect : null;
         if(Boolean(rect))
         {
            this.contentPane.scrollRect = null;
         }
         super.prepareToPrint(target);
         return rect;
      }
      
      override public function finishPrint(obj:Object, target:IFlexDisplayObject) : void
      {
         if(Boolean(obj))
         {
            this.contentPane.scrollRect = Rectangle(obj);
         }
         super.finishPrint(obj,target);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addingChild(child:DisplayObject) : void
      {
         var uiChild:IUIComponent = IUIComponent(child);
         super.addingChild(child);
         invalidateSize();
         invalidateDisplayList();
         if(!this.contentPane)
         {
            if(this._numChildren == 0)
            {
               this._firstChildIndex = super.numChildren;
            }
            ++this._numChildren;
         }
         if(Boolean(this.contentPane) && !this.autoLayout)
         {
            this.forceLayout = true;
            UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE,this.layoutCompleteHandler,false,0,true);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childAdded(child:DisplayObject) : void
      {
         var event:ChildExistenceChangedEvent = null;
         if(hasEventListener("childrenChanged"))
         {
            dispatchEvent(new Event("childrenChanged"));
         }
         if(hasEventListener(ChildExistenceChangedEvent.CHILD_ADD))
         {
            event = new ChildExistenceChangedEvent(ChildExistenceChangedEvent.CHILD_ADD);
            event.relatedObject = child;
            dispatchEvent(event);
         }
         if(child.hasEventListener(FlexEvent.ADD))
         {
            child.dispatchEvent(new FlexEvent(FlexEvent.ADD));
         }
         super.childAdded(child);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removingChild(child:DisplayObject) : void
      {
         var event:ChildExistenceChangedEvent = null;
         super.removingChild(child);
         if(child.hasEventListener(FlexEvent.REMOVE))
         {
            child.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
         }
         if(hasEventListener(ChildExistenceChangedEvent.CHILD_REMOVE))
         {
            event = new ChildExistenceChangedEvent(ChildExistenceChangedEvent.CHILD_REMOVE);
            event.relatedObject = child;
            dispatchEvent(event);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childRemoved(child:DisplayObject) : void
      {
         super.childRemoved(child);
         invalidateSize();
         invalidateDisplayList();
         if(!this.contentPane)
         {
            --this._numChildren;
            if(this._numChildren == 0)
            {
               this._firstChildIndex = super.numChildren;
            }
         }
         if(Boolean(this.contentPane) && !this.autoLayout)
         {
            this.forceLayout = true;
            UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE,this.layoutCompleteHandler,false,0,true);
         }
         if(hasEventListener("childrenChanged"))
         {
            dispatchEvent(new Event("childrenChanged"));
         }
      }
      
      [Bindable("childrenChanged")]
      public function getChildren() : Array
      {
         var results:Array = [];
         var n:int = this.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            results.push(this.getChildAt(i));
         }
         return results;
      }
      
      public function removeAllChildren() : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setDocumentDescriptor(desc:UIComponentDescriptor) : void
      {
         var message:String = null;
         if(processedDescriptors)
         {
            return;
         }
         if(Boolean(_documentDescriptor) && Boolean(_documentDescriptor.properties.childDescriptors))
         {
            if(Boolean(desc.properties.childDescriptors))
            {
               message = resourceManager.getString("core","multipleChildSets_ClassAndSubclass");
               throw new Error(message);
            }
         }
         else
         {
            _documentDescriptor = desc;
            _documentDescriptor.document = this;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setActualCreationPolicies(policy:String) : void
      {
         var child:IFlexDisplayObject = null;
         var childContainer:Container = null;
         this.actualCreationPolicy = policy;
         var childPolicy:String = policy;
         if(policy == ContainerCreationPolicy.QUEUED)
         {
            childPolicy = ContainerCreationPolicy.AUTO;
         }
         var n:int = this.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IFlexDisplayObject(this.getChildAt(i));
            if(child is Container)
            {
               childContainer = Container(child);
               if(childContainer.creationPolicy == null)
               {
                  childContainer.setActualCreationPolicies(childPolicy);
               }
            }
         }
      }
      
      public function createComponentsFromDescriptors(recurse:Boolean = true) : void
      {
         var component:IFlexDisplayObject = null;
         this.numChildrenBefore = this.numChildren;
         this.createdComponents = [];
         var n:int = Boolean(this.childDescriptors) ? int(this.childDescriptors.length) : 0;
         for(var i:int = 0; i < n; i++)
         {
            component = this.createComponentFromDescriptor(this.childDescriptors[i],recurse);
            this.createdComponents.push(component);
         }
         if(this.creationPolicy == ContainerCreationPolicy.QUEUED || this.creationPolicy == ContainerCreationPolicy.NONE)
         {
            UIComponentGlobals.layoutManager.usePhasedInstantiation = false;
         }
         this.numChildrenCreated = this.numChildren - this.numChildrenBefore;
         processedDescriptors = true;
         dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
      }
      
      public function createDeferredContent() : void
      {
         this.createComponentsFromDescriptors(true);
      }
      
      public function createComponentFromDescriptor(descriptor:ComponentDescriptor, recurse:Boolean) : IFlexDisplayObject
      {
         var p:String = null;
         var rChild:IRepeaterClient = null;
         var scChild:IStyleClient = null;
         var eventName:String = null;
         var eventHandler:String = null;
         var childDescriptor:UIComponentDescriptor = UIComponentDescriptor(descriptor);
         var childProperties:Object = childDescriptor.properties;
         if((this.numChildrenBefore != 0 || this.numChildrenCreated != -1) && childDescriptor.instanceIndices == null && this.hasChildMatchingDescriptor(childDescriptor))
         {
            return null;
         }
         UIComponentGlobals.layoutManager.usePhasedInstantiation = true;
         var childType:Class = childDescriptor.type;
         var child:IDeferredInstantiationUIComponent = new childType();
         child.id = childDescriptor.id;
         if(Boolean(child.id) && child.id != "")
         {
            child.name = child.id;
         }
         child.descriptor = childDescriptor;
         if(Boolean(childProperties.childDescriptors) && child is Container)
         {
            Container(child)._childDescriptors = childProperties.childDescriptors;
            delete childProperties.childDescriptors;
         }
         for(p in childProperties)
         {
            child[p] = childProperties[p];
         }
         if(child is Container)
         {
            Container(child).recursionFlag = recurse;
         }
         if(Boolean(childDescriptor.instanceIndices))
         {
            if(child is IRepeaterClient)
            {
               rChild = IRepeaterClient(child);
               rChild.instanceIndices = childDescriptor.instanceIndices;
               rChild.repeaters = childDescriptor.repeaters;
               rChild.repeaterIndices = childDescriptor.repeaterIndices;
            }
         }
         if(child is IStyleClient)
         {
            scChild = IStyleClient(child);
            if(childDescriptor.stylesFactory != null)
            {
               if(!scChild.styleDeclaration)
               {
                  scChild.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
               }
               scChild.styleDeclaration.factory = childDescriptor.stylesFactory;
            }
         }
         var childEvents:Object = childDescriptor.events;
         if(Boolean(childEvents))
         {
            for(eventName in childEvents)
            {
               eventHandler = childEvents[eventName];
               child.addEventListener(eventName,childDescriptor.document[eventHandler]);
            }
         }
         var childEffects:Array = childDescriptor.effects;
         if(Boolean(childEffects))
         {
            child.registerEffects(childEffects);
         }
         if(child is IRepeaterClient)
         {
            IRepeaterClient(child).initializeRepeaterArrays(this);
         }
         child.createReferenceOnParentDocument(IFlexDisplayObject(childDescriptor.document));
         if(!child.document)
         {
            child.document = childDescriptor.document;
         }
         if(child is IRepeater)
         {
            if(!this.childRepeaters)
            {
               this.childRepeaters = [];
            }
            this.childRepeaters.push(child);
            child.executeBindings();
            IRepeater(child).initializeRepeater(this,recurse);
         }
         else
         {
            this.addChild(DisplayObject(child));
            child.executeBindings();
            if(this.creationPolicy == ContainerCreationPolicy.QUEUED || this.creationPolicy == ContainerCreationPolicy.NONE)
            {
               child.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
            }
         }
         return child;
      }
      
      private function hasChildMatchingDescriptor(descriptor:UIComponentDescriptor) : Boolean
      {
         var i:int = 0;
         var child:IUIComponent = null;
         var id:String = descriptor.id;
         if(id != null && id in document && document[id] == null)
         {
            return false;
         }
         var n:int = this.numChildren;
         for(i = 0; i < n; i++)
         {
            child = IUIComponent(this.getChildAt(i));
            if(child is IDeferredInstantiationUIComponent && IDeferredInstantiationUIComponent(child).descriptor == descriptor)
            {
               return true;
            }
         }
         if(Boolean(this.childRepeaters))
         {
            n = int(this.childRepeaters.length);
            for(i = 0; i < n; i++)
            {
               if(IDeferredInstantiationUIComponent(this.childRepeaters[i]).descriptor == descriptor)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_addChild(child:DisplayObject) : DisplayObject
      {
         if(this._numChildren == 0)
         {
            ++this._firstChildIndex;
         }
         super.addingChild(child);
         $addChild(child);
         super.childAdded(child);
         dispatchEvent(new Event("childrenChanged"));
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         if(this._firstChildIndex < index && index < this._firstChildIndex + this._numChildren + 1)
         {
            ++this._numChildren;
         }
         else if(index <= this._firstChildIndex)
         {
            ++this._firstChildIndex;
         }
         super.addingChild(child);
         $addChildAt(child,index);
         super.childAdded(child);
         dispatchEvent(new Event("childrenChanged"));
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_removeChild(child:DisplayObject) : DisplayObject
      {
         var index:int = this.rawChildren_getChildIndex(child);
         return this.rawChildren_removeChildAt(index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_removeChildAt(index:int) : DisplayObject
      {
         var child:DisplayObject = super.getChildAt(index);
         super.removingChild(child);
         $removeChildAt(index);
         super.childRemoved(child);
         if(this._firstChildIndex < index && index < this._firstChildIndex + this._numChildren)
         {
            --this._numChildren;
         }
         else if(this._numChildren == 0 || index < this._firstChildIndex)
         {
            --this._firstChildIndex;
         }
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("childrenChanged"));
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildAt(index:int) : DisplayObject
      {
         return super.getChildAt(index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildByName(name:String) : DisplayObject
      {
         return super.getChildByName(name);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getChildIndex(child:DisplayObject) : int
      {
         return super.getChildIndex(child);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_setChildIndex(child:DisplayObject, newIndex:int) : void
      {
         var oldIndex:int = super.getChildIndex(child);
         super.setChildIndex(child,newIndex);
         if(oldIndex < this._firstChildIndex && newIndex >= this._firstChildIndex)
         {
            --this._firstChildIndex;
         }
         else if(oldIndex >= this._firstChildIndex && newIndex <= this._firstChildIndex)
         {
            ++this._firstChildIndex;
         }
         dispatchEvent(new Event("childrenChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_getObjectsUnderPoint(pt:Point) : Array
      {
         return super.getObjectsUnderPoint(pt);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function rawChildren_contains(child:DisplayObject) : Boolean
      {
         return super.contains(child);
      }
      
      protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(Boolean(this.border))
         {
            this.updateBackgroundImageRect();
            this.border.move(0,0);
            this.border.setActualSize(unscaledWidth,unscaledHeight);
         }
      }
      
      protected function createBorder() : void
      {
         var borderClass:Class = null;
         if(!this.border && this.isBorderNeeded())
         {
            borderClass = getStyle("borderSkin");
            if(borderClass != null)
            {
               this.border = new borderClass();
               this.border.name = "border";
               if(this.border is IUIComponent)
               {
                  IUIComponent(this.border).enabled = enabled;
               }
               if(this.border is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.border).styleName = this;
               }
               this.rawChildren.addChildAt(DisplayObject(this.border),0);
               invalidateDisplayList();
            }
         }
      }
      
      private function isBorderNeeded() : Boolean
      {
         var c:Class = getStyle("borderSkin");
         if(!didLookup)
         {
            haloBorder = getDefinition("mx.skins.halo::HaloBorder");
            sparkBorder = getDefinition("mx.skins.spark::BorderSkin");
            sparkContainerBorder = getDefinition("mx.skins.spark::ContainerBorderSkin");
            didLookup = true;
         }
         if(!(c == haloBorder || c == sparkBorder || c == sparkContainerBorder))
         {
            return true;
         }
         var v:Object = getStyle("borderStyle");
         if(Boolean(v))
         {
            if(v != "none" || Boolean(v == "none") && Boolean(getStyle("mouseShield")))
            {
               return true;
            }
         }
         v = getStyle("contentBackgroundColor");
         if(c == sparkBorder && v !== null)
         {
            return true;
         }
         v = getStyle("backgroundColor");
         if(v !== null && v !== "")
         {
            return true;
         }
         v = getStyle("backgroundImage");
         return v != null && v != "";
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invalidateViewMetricsAndPadding() : void
      {
         this._viewMetricsAndPadding = null;
      }
      
      private function createOrDestroyBlocker() : void
      {
         var o:DisplayObject = null;
         var sm:ISystemManager = null;
         if(enabled)
         {
            if(Boolean(this.blocker))
            {
               this.rawChildren.removeChild(this.blocker);
               this.blocker = null;
            }
         }
         else if(!this.blocker)
         {
            this.blocker = new FlexSprite();
            this.blocker.name = "blocker";
            this.blocker.mouseEnabled = true;
            this.rawChildren.addChild(this.blocker);
            this.blocker.addEventListener(MouseEvent.CLICK,this.blocker_clickHandler);
            o = Boolean(focusManager) ? DisplayObject(focusManager.getFocus()) : null;
            while(Boolean(o))
            {
               if(o == this)
               {
                  sm = systemManager;
                  if(Boolean(sm) && Boolean(sm.stage))
                  {
                     sm.stage.focus = null;
                  }
                  break;
               }
               o = o.parent;
            }
         }
      }
      
      private function updateBackgroundImageRect() : void
      {
         var rectBorder:IRectangularBorder = this.border as IRectangularBorder;
         if(!rectBorder)
         {
            return;
         }
         if(this.viewableWidth == 0 && this.viewableHeight == 0)
         {
            rectBorder.backgroundImageBounds = null;
            return;
         }
         var vm:EdgeMetrics = this.viewMetrics;
         var bkWidth:Number = Boolean(this.viewableWidth) ? this.viewableWidth : unscaledWidth - vm.left - vm.right;
         var bkHeight:Number = Boolean(this.viewableHeight) ? this.viewableHeight : unscaledHeight - vm.top - vm.bottom;
         if(getStyle("backgroundAttachment") == "fixed")
         {
            rectBorder.backgroundImageBounds = new Rectangle(vm.left,vm.top,bkWidth,bkHeight);
         }
         else
         {
            rectBorder.backgroundImageBounds = new Rectangle(vm.left,vm.top,Math.max(this.scrollableWidth,bkWidth),Math.max(this.scrollableHeight,bkHeight));
         }
      }
      
      private function createContentPaneAndScrollbarsIfNeeded() : Boolean
      {
         var bounds:Rectangle = null;
         var changed:Boolean = false;
         if(this._clipContent)
         {
            bounds = this.getScrollableRect();
            changed = this.createScrollbarsIfNeeded(bounds);
            if(Boolean(this.border))
            {
               this.updateBackgroundImageRect();
            }
            return changed;
         }
         changed = this.createOrDestroyScrollbars(false,false,false);
         bounds = this.getScrollableRect();
         this.scrollableWidth = bounds.right;
         this.scrollableHeight = bounds.bottom;
         if(changed && Boolean(this.border))
         {
            this.updateBackgroundImageRect();
         }
         return changed;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getScrollableRect() : Rectangle
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var width:Number = NaN;
         var height:Number = NaN;
         var child:DisplayObject = null;
         var uic:IUIComponent = null;
         var left:Number = 0;
         var top:Number = 0;
         var right:Number = 0;
         var bottom:Number = 0;
         var n:int = this.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = this.getChildAt(i);
            if(child is IUIComponent)
            {
               if(!IUIComponent(child).includeInLayout)
               {
                  continue;
               }
               uic = PostScaleAdapter.getCompatibleIUIComponent(child);
               width = Number(uic.width);
               height = Number(uic.height);
               x = Number(uic.x);
               y = Number(uic.y);
            }
            else
            {
               width = child.width;
               height = child.height;
               x = child.x;
               y = child.y;
            }
            left = Math.min(left,x);
            top = Math.min(top,y);
            if(!isNaN(width))
            {
               right = Math.max(right,x + width);
            }
            if(!isNaN(height))
            {
               bottom = Math.max(bottom,y + height);
            }
         }
         var vm:EdgeMetrics = this.viewMetrics;
         var bounds:Rectangle = new Rectangle();
         bounds.left = left;
         bounds.top = top;
         bounds.right = right;
         bounds.bottom = bottom;
         if(this.usePadding)
         {
            bounds.right += getStyle("paddingRight");
            bounds.bottom += getStyle("paddingBottom");
         }
         return bounds;
      }
      
      private function createScrollbarsIfNeeded(bounds:Rectangle) : Boolean
      {
         var newScrollableWidth:Number = bounds.right;
         var newScrollableHeight:Number = bounds.bottom;
         var newViewableWidth:Number = Number(unscaledWidth);
         var newViewableHeight:Number = Number(unscaledHeight);
         var hasNegativeCoords:Boolean = bounds.left < 0 || bounds.top < 0;
         var vm:EdgeMetrics = this.viewMetrics;
         if(scaleX != 1)
         {
            newViewableWidth += 1 / Math.abs(scaleX);
         }
         if(scaleY != 1)
         {
            newViewableHeight += 1 / Math.abs(scaleY);
         }
         newViewableWidth = Math.floor(newViewableWidth);
         newViewableHeight = Math.floor(newViewableHeight);
         newScrollableWidth = Math.floor(newScrollableWidth);
         newScrollableHeight = Math.floor(newScrollableHeight);
         if(Boolean(this.horizontalScrollBar) && this.horizontalScrollPolicy != ScrollPolicy.ON)
         {
            newViewableHeight -= this.horizontalScrollBar.minHeight;
         }
         if(Boolean(this.verticalScrollBar) && this.verticalScrollPolicy != ScrollPolicy.ON)
         {
            newViewableWidth -= this.verticalScrollBar.minWidth;
         }
         newViewableWidth -= vm.left + vm.right;
         newViewableHeight -= vm.top + vm.bottom;
         var needHorizontal:Boolean = this.horizontalScrollPolicy == ScrollPolicy.ON;
         var needVertical:Boolean = this.verticalScrollPolicy == ScrollPolicy.ON;
         var needContentPane:Boolean = needHorizontal || needVertical || hasNegativeCoords || effectOverlay != null || vm.left > 0 || vm.top > 0;
         if(newViewableWidth < newScrollableWidth)
         {
            needContentPane = true;
            if(this.horizontalScrollPolicy == ScrollPolicy.AUTO && unscaledHeight - vm.top - vm.bottom >= 18 && unscaledWidth - vm.left - vm.right >= 32)
            {
               needHorizontal = true;
            }
         }
         if(newViewableHeight < newScrollableHeight)
         {
            needContentPane = true;
            if(this.verticalScrollPolicy == ScrollPolicy.AUTO && unscaledWidth - vm.left - vm.right >= 18 && unscaledHeight - vm.top - vm.bottom >= 32)
            {
               needVertical = true;
            }
         }
         if(Boolean(needHorizontal && needVertical && this.horizontalScrollPolicy == ScrollPolicy.AUTO && this.verticalScrollPolicy == ScrollPolicy.AUTO && this.horizontalScrollBar && this.verticalScrollBar) && Boolean(newViewableWidth + this.verticalScrollBar.minWidth >= newScrollableWidth) && newViewableHeight + this.horizontalScrollBar.minHeight >= newScrollableHeight)
         {
            needHorizontal = needVertical = false;
         }
         else if(Boolean(needHorizontal && !needVertical && this.verticalScrollBar) && Boolean(this.horizontalScrollPolicy == ScrollPolicy.AUTO) && newViewableWidth + this.verticalScrollBar.minWidth >= newScrollableWidth)
         {
            needHorizontal = false;
         }
         var changed:Boolean = this.createOrDestroyScrollbars(needHorizontal,needVertical,needContentPane);
         if(this.scrollableWidth != newScrollableWidth || this.viewableWidth != newViewableWidth || changed)
         {
            if(Boolean(this.horizontalScrollBar))
            {
               this.horizontalScrollBar.setScrollProperties(newViewableWidth,0,newScrollableWidth - newViewableWidth,this.horizontalPageScrollSize);
               this.scrollPositionChanged = true;
            }
            this.viewableWidth = newViewableWidth;
            this.scrollableWidth = newScrollableWidth;
         }
         if(this.scrollableHeight != newScrollableHeight || this.viewableHeight != newViewableHeight || changed)
         {
            if(Boolean(this.verticalScrollBar))
            {
               this.verticalScrollBar.setScrollProperties(newViewableHeight,0,newScrollableHeight - newViewableHeight,this.verticalPageScrollSize);
               this.scrollPositionChanged = true;
            }
            this.viewableHeight = newViewableHeight;
            this.scrollableHeight = newScrollableHeight;
         }
         return changed;
      }
      
      private function createOrDestroyScrollbars(needHorizontal:Boolean, needVertical:Boolean, needContentPane:Boolean) : Boolean
      {
         var fm:IFocusManager = null;
         var horizontalScrollBarStyleName:String = null;
         var verticalScrollBarStyleName:String = null;
         var g:Graphics = null;
         var changed:Boolean = false;
         if(needHorizontal || needVertical || needContentPane)
         {
            this.createContentPane();
         }
         if(needHorizontal)
         {
            if(!this.horizontalScrollBar)
            {
               this.horizontalScrollBar = new HScrollBar();
               this.horizontalScrollBar.name = "horizontalScrollBar";
               horizontalScrollBarStyleName = getStyle("horizontalScrollBarStyleName");
               if(Boolean(horizontalScrollBarStyleName) && this.horizontalScrollBar is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.horizontalScrollBar).styleName = horizontalScrollBarStyleName;
               }
               this.rawChildren.addChild(DisplayObject(this.horizontalScrollBar));
               this.horizontalScrollBar.lineScrollSize = this.horizontalLineScrollSize;
               this.horizontalScrollBar.pageScrollSize = this.horizontalPageScrollSize;
               this.horizontalScrollBar.addEventListener(ScrollEvent.SCROLL,this.horizontalScrollBar_scrollHandler);
               this.horizontalScrollBar.enabled = enabled;
               if(this.horizontalScrollBar is IInvalidating)
               {
                  IInvalidating(this.horizontalScrollBar).validateNow();
               }
               invalidateDisplayList();
               this.invalidateViewMetricsAndPadding();
               changed = true;
               if(!this.verticalScrollBar)
               {
                  this.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
               }
            }
         }
         else if(Boolean(this.horizontalScrollBar))
         {
            this.horizontalScrollBar.removeEventListener(ScrollEvent.SCROLL,this.horizontalScrollBar_scrollHandler);
            this.rawChildren.removeChild(DisplayObject(this.horizontalScrollBar));
            this.horizontalScrollBar = null;
            this.viewableWidth = this.scrollableWidth = 0;
            if(this._horizontalScrollPosition != 0)
            {
               this._horizontalScrollPosition = 0;
               this.scrollPositionChanged = true;
            }
            invalidateDisplayList();
            this.invalidateViewMetricsAndPadding();
            changed = true;
            fm = focusManager;
            if(!this.verticalScrollBar && (!fm || fm.getFocus() != this))
            {
               this.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            }
         }
         if(needVertical)
         {
            if(!this.verticalScrollBar)
            {
               this.verticalScrollBar = new VScrollBar();
               this.verticalScrollBar.name = "verticalScrollBar";
               verticalScrollBarStyleName = getStyle("verticalScrollBarStyleName");
               if(Boolean(verticalScrollBarStyleName) && this.verticalScrollBar is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.verticalScrollBar).styleName = verticalScrollBarStyleName;
               }
               this.rawChildren.addChild(DisplayObject(this.verticalScrollBar));
               this.verticalScrollBar.lineScrollSize = this.verticalLineScrollSize;
               this.verticalScrollBar.pageScrollSize = this.verticalPageScrollSize;
               this.verticalScrollBar.addEventListener(ScrollEvent.SCROLL,this.verticalScrollBar_scrollHandler);
               this.verticalScrollBar.enabled = enabled;
               if(this.verticalScrollBar is IInvalidating)
               {
                  IInvalidating(this.verticalScrollBar).validateNow();
               }
               invalidateDisplayList();
               this.invalidateViewMetricsAndPadding();
               changed = true;
               if(!this.horizontalScrollBar)
               {
                  this.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
               }
               this.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
            }
         }
         else if(Boolean(this.verticalScrollBar))
         {
            this.verticalScrollBar.removeEventListener(ScrollEvent.SCROLL,this.verticalScrollBar_scrollHandler);
            this.rawChildren.removeChild(DisplayObject(this.verticalScrollBar));
            this.verticalScrollBar = null;
            this.viewableHeight = this.scrollableHeight = 0;
            if(this._verticalScrollPosition != 0)
            {
               this._verticalScrollPosition = 0;
               this.scrollPositionChanged = true;
            }
            invalidateDisplayList();
            this.invalidateViewMetricsAndPadding();
            changed = true;
            fm = focusManager;
            if(!this.horizontalScrollBar && (!fm || fm.getFocus() != this))
            {
               this.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            }
            this.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
         if(Boolean(this.horizontalScrollBar) && Boolean(this.verticalScrollBar))
         {
            if(!this.whiteBox)
            {
               this.whiteBox = new FlexShape();
               this.whiteBox.name = "whiteBox";
               g = this.whiteBox.graphics;
               g.beginFill(16777215);
               g.drawRect(0,0,this.verticalScrollBar.minWidth,this.horizontalScrollBar.minHeight);
               g.endFill();
               this.rawChildren.addChild(this.whiteBox);
            }
         }
         else if(Boolean(this.whiteBox))
         {
            this.rawChildren.removeChild(this.whiteBox);
            this.whiteBox = null;
         }
         return changed;
      }
      
      private function clampScrollPositions() : Boolean
      {
         var changed:Boolean = false;
         if(this._horizontalScrollPosition < 0)
         {
            this._horizontalScrollPosition = 0;
            changed = true;
         }
         else if(this._horizontalScrollPosition > this.maxHorizontalScrollPosition)
         {
            this._horizontalScrollPosition = this.maxHorizontalScrollPosition;
            changed = true;
         }
         if(Boolean(this.horizontalScrollBar) && this.horizontalScrollBar.scrollPosition != this._horizontalScrollPosition)
         {
            this.horizontalScrollBar.scrollPosition = this._horizontalScrollPosition;
         }
         if(this._verticalScrollPosition < 0)
         {
            this._verticalScrollPosition = 0;
            changed = true;
         }
         else if(this._verticalScrollPosition > this.maxVerticalScrollPosition)
         {
            this._verticalScrollPosition = this.maxVerticalScrollPosition;
            changed = true;
         }
         if(Boolean(this.verticalScrollBar) && this.verticalScrollBar.scrollPosition != this._verticalScrollPosition)
         {
            this.verticalScrollBar.scrollPosition = this._verticalScrollPosition;
         }
         return changed;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createContentPane() : void
      {
         var childIndex:int = 0;
         var child:IUIComponent = null;
         if(Boolean(this.contentPane))
         {
            return;
         }
         this.creatingContentPane = true;
         var n:int = this.numChildren;
         var newPane:Sprite = new FlexSprite();
         newPane.name = "contentPane";
         if(Boolean(this.border))
         {
            childIndex = this.rawChildren.getChildIndex(DisplayObject(this.border)) + 1;
            if(this.border is IRectangularBorder && Boolean(IRectangularBorder(this.border).hasBackgroundImage))
            {
               childIndex++;
            }
         }
         else
         {
            childIndex = 0;
         }
         this.rawChildren.addChildAt(newPane,childIndex);
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(super.getChildAt(this._firstChildIndex));
            newPane.addChild(DisplayObject(child));
            child.parentChanged(newPane);
            --this._numChildren;
         }
         this.contentPane = newPane;
         this.creatingContentPane = false;
         this.contentPane.visible = true;
      }
      
      protected function scrollChildren() : void
      {
         if(!this.contentPane)
         {
            return;
         }
         var vm:EdgeMetrics = this.viewMetrics;
         var x:Number = 0;
         var y:Number = 0;
         var w:Number = unscaledWidth - vm.left - vm.right;
         var h:Number = unscaledHeight - vm.top - vm.bottom;
         if(this._clipContent)
         {
            x += this._horizontalScrollPosition;
            if(Boolean(this.horizontalScrollBar))
            {
               w = this.viewableWidth;
            }
            y += this._verticalScrollPosition;
            if(Boolean(this.verticalScrollBar))
            {
               h = this.viewableHeight;
            }
         }
         else
         {
            w = this.scrollableWidth;
            h = this.scrollableHeight;
         }
         var sr:Rectangle = this.getScrollableRect();
         if(x == 0 && y == 0 && w >= sr.right && h >= sr.bottom && sr.left >= 0 && sr.top >= 0 && this._forceClippingCount <= 0)
         {
            this.contentPane.scrollRect = null;
            this.contentPane.opaqueBackground = null;
            this.contentPane.cacheAsBitmap = false;
         }
         else
         {
            this.contentPane.scrollRect = new Rectangle(x,y,w,h);
         }
         if(Boolean(this.focusPane))
         {
            this.focusPane.scrollRect = this.contentPane.scrollRect;
         }
         if(Boolean(this.border) && Boolean(this.border is IRectangularBorder) && Boolean(IRectangularBorder(this.border).hasBackgroundImage))
         {
            IRectangularBorder(this.border).layoutBackgroundImage();
         }
      }
      
      private function dispatchScrollEvent(direction:String, oldPosition:Number, newPosition:Number, detail:String) : void
      {
         var event:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
         event.direction = direction;
         event.position = newPosition;
         event.delta = newPosition - oldPosition;
         event.detail = detail;
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set forceClipping(value:Boolean) : void
      {
         if(this._clipContent)
         {
            if(value)
            {
               ++this._forceClippingCount;
            }
            else
            {
               --this._forceClippingCount;
            }
            this.createContentPane();
            this.scrollChildren();
         }
      }
      
      public function executeChildBindings(recurse:Boolean) : void
      {
         var child:IUIComponent = null;
         var n:int = this.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = IUIComponent(this.getChildAt(i));
            if(child is IDeferredInstantiationUIComponent)
            {
               IDeferredInstantiationUIComponent(child).executeBindings(recurse);
            }
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var direction:String = null;
         var oldPos:Number = NaN;
         var keyCode:uint = 0;
         var focusObj:Object = getFocus();
         if(focusObj is TextField || Boolean(this.richEditableTextClass) && Boolean(focusObj is this.richEditableTextClass))
         {
            return;
         }
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(Boolean(this.verticalScrollBar))
         {
            direction = ScrollEventDirection.VERTICAL;
            oldPos = this.verticalScrollPosition;
            switch(event.keyCode)
            {
               case Keyboard.DOWN:
                  this.verticalScrollPosition += this.verticalLineScrollSize;
                  this.dispatchScrollEvent(direction,oldPos,this.verticalScrollPosition,ScrollEventDetail.LINE_DOWN);
                  event.stopPropagation();
                  break;
               case Keyboard.UP:
                  this.verticalScrollPosition -= this.verticalLineScrollSize;
                  this.dispatchScrollEvent(direction,oldPos,this.verticalScrollPosition,ScrollEventDetail.LINE_UP);
                  event.stopPropagation();
                  break;
               case Keyboard.PAGE_UP:
                  this.verticalScrollPosition -= this.verticalPageScrollSize;
                  this.dispatchScrollEvent(direction,oldPos,this.verticalScrollPosition,ScrollEventDetail.PAGE_UP);
                  event.stopPropagation();
                  break;
               case Keyboard.PAGE_DOWN:
                  this.verticalScrollPosition += this.verticalPageScrollSize;
                  this.dispatchScrollEvent(direction,oldPos,this.verticalScrollPosition,ScrollEventDetail.PAGE_DOWN);
                  event.stopPropagation();
                  break;
               case Keyboard.HOME:
                  this.verticalScrollPosition = this.verticalScrollBar.minScrollPosition;
                  this.dispatchScrollEvent(direction,oldPos,this.verticalScrollPosition,ScrollEventDetail.AT_TOP);
                  event.stopPropagation();
                  break;
               case Keyboard.END:
                  this.verticalScrollPosition = this.verticalScrollBar.maxScrollPosition;
                  this.dispatchScrollEvent(direction,oldPos,this.verticalScrollPosition,ScrollEventDetail.AT_BOTTOM);
                  event.stopPropagation();
            }
         }
         if(Boolean(this.horizontalScrollBar))
         {
            direction = ScrollEventDirection.HORIZONTAL;
            oldPos = this.horizontalScrollPosition;
            keyCode = uint(mapKeycodeForLayoutDirection(event));
            switch(keyCode)
            {
               case Keyboard.LEFT:
                  this.horizontalScrollPosition -= this.horizontalLineScrollSize;
                  this.dispatchScrollEvent(direction,oldPos,this.horizontalScrollPosition,ScrollEventDetail.LINE_LEFT);
                  event.stopPropagation();
                  break;
               case Keyboard.RIGHT:
                  this.horizontalScrollPosition += this.horizontalLineScrollSize;
                  this.dispatchScrollEvent(direction,oldPos,this.horizontalScrollPosition,ScrollEventDetail.LINE_RIGHT);
                  event.stopPropagation();
            }
         }
      }
      
      private function mouseWheelHandler(event:MouseEvent) : void
      {
         var scrollDirection:int = 0;
         var lineScrollSize:int = 0;
         var scrollAmount:Number = NaN;
         var oldPosition:Number = NaN;
         if(Boolean(this.verticalScrollBar) && !event.isDefaultPrevented())
         {
            scrollDirection = event.delta <= 0 ? 1 : -1;
            lineScrollSize = Boolean(this.verticalScrollBar) ? int(this.verticalScrollBar.lineScrollSize) : 1;
            scrollAmount = Math.max(Math.abs(event.delta),lineScrollSize);
            oldPosition = this.verticalScrollPosition;
            this.verticalScrollPosition += 3 * scrollAmount * scrollDirection;
            this.dispatchScrollEvent(ScrollEventDirection.VERTICAL,oldPosition,this.verticalScrollPosition,event.delta <= 0 ? ScrollEventDetail.LINE_UP : ScrollEventDetail.LINE_DOWN);
            event.preventDefault();
         }
      }
      
      private function layoutCompleteHandler(event:FlexEvent) : void
      {
         UIComponentGlobals.layoutManager.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.layoutCompleteHandler);
         this.forceLayout = false;
         var needToScrollChildren:Boolean = false;
         if(!isNaN(this.horizontalScrollPositionPending))
         {
            if(this.horizontalScrollPositionPending < 0)
            {
               this.horizontalScrollPositionPending = 0;
            }
            else if(this.horizontalScrollPositionPending > this.maxHorizontalScrollPosition)
            {
               this.horizontalScrollPositionPending = this.maxHorizontalScrollPosition;
            }
            if(Boolean(this.horizontalScrollBar) && this.horizontalScrollBar.scrollPosition != this.horizontalScrollPositionPending)
            {
               this._horizontalScrollPosition = this.horizontalScrollPositionPending;
               this.horizontalScrollBar.scrollPosition = this.horizontalScrollPositionPending;
               needToScrollChildren = true;
            }
            this.horizontalScrollPositionPending = NaN;
         }
         if(!isNaN(this.verticalScrollPositionPending))
         {
            if(this.verticalScrollPositionPending < 0)
            {
               this.verticalScrollPositionPending = 0;
            }
            else if(this.verticalScrollPositionPending > this.maxVerticalScrollPosition)
            {
               this.verticalScrollPositionPending = this.maxVerticalScrollPosition;
            }
            if(Boolean(this.verticalScrollBar) && this.verticalScrollBar.scrollPosition != this.verticalScrollPositionPending)
            {
               this._verticalScrollPosition = this.verticalScrollPositionPending;
               this.verticalScrollBar.scrollPosition = this.verticalScrollPositionPending;
               needToScrollChildren = true;
            }
            this.verticalScrollPositionPending = NaN;
         }
         if(needToScrollChildren)
         {
            this.scrollChildren();
         }
      }
      
      private function creationCompleteHandler(event:FlexEvent) : void
      {
         --this.numChildrenCreated;
         if(this.numChildrenCreated <= 0)
         {
            dispatchEvent(new FlexEvent("childrenCreationComplete"));
         }
      }
      
      private function horizontalScrollBar_scrollHandler(event:Event) : void
      {
         var oldPos:Number = NaN;
         if(event is ScrollEvent)
         {
            oldPos = this.horizontalScrollPosition;
            this.horizontalScrollPosition = this.horizontalScrollBar.scrollPosition;
            this.dispatchScrollEvent(ScrollEventDirection.HORIZONTAL,oldPos,this.horizontalScrollPosition,ScrollEvent(event).detail);
         }
      }
      
      private function verticalScrollBar_scrollHandler(event:Event) : void
      {
         var oldPos:Number = NaN;
         if(event is ScrollEvent)
         {
            oldPos = this.verticalScrollPosition;
            this.verticalScrollPosition = this.verticalScrollBar.scrollPosition;
            this.dispatchScrollEvent(ScrollEventDirection.VERTICAL,oldPos,this.verticalScrollPosition,ScrollEvent(event).detail);
         }
      }
      
      private function blocker_clickHandler(event:Event) : void
      {
         event.stopPropagation();
      }
   }
}

