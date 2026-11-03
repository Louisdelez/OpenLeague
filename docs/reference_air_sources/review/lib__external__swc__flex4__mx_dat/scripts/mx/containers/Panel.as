package mx.containers
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextLineMetrics;
   import flash.utils.getQualifiedClassName;
   import mx.automation.IAutomationObject;
   import mx.containers.utilityClasses.BoxLayout;
   import mx.containers.utilityClasses.CanvasLayout;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.containers.utilityClasses.IConstraintLayout;
   import mx.containers.utilityClasses.Layout;
   import mx.controls.Button;
   import mx.core.Container;
   import mx.core.ContainerLayout;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UIComponentCachePolicy;
   import mx.core.UITextField;
   import mx.core.UITextFormat;
   import mx.effects.EffectManager;
   import mx.events.CloseEvent;
   import mx.events.SandboxMouseEvent;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.styles.StyleProxy;
   
   [Alternative(replacement="spark.components.Panel",since="4.0")]
   [IconFile("Panel.png")]
   [AccessibilityClass(implementation="mx.accessibility.PanelAccImpl")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Effect(name="resizeStartEffect",event="resizeStart")]
   [Effect(name="resizeEndEffect",event="resizeEnd")]
   [Style(name="titleStyleName",type="String",inherit="no")]
   [Style(name="titleBackgroundSkin",type="Class",inherit="no")]
   [Style(name="statusStyleName",type="String",inherit="no")]
   [Style(name="shadowDistance",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="shadowDirection",type="String",enumeration="left,center,right",inherit="no",theme="halo")]
   [Style(name="roundedBottomCorners",type="Boolean",inherit="no",theme="halo")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="headerHeight",type="Number",format="Length",inherit="no")]
   [Style(name="headerColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="footerColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="dropShadowEnabled",type="Boolean",inherit="no",theme="halo")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
   [Style(name="controlBarStyleName",type="String",inherit="no")]
   [Style(name="borderThicknessTop",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderThicknessRight",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderThicknessLeft",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderThicknessBottom",type="Number",format="Length",inherit="no",theme="halo")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="halo, spark")]
   [Style(name="modalTransparencyDuration",type="Number",format="Time",inherit="yes")]
   [Style(name="modalTransparencyColor",type="uint",format="Color",inherit="yes")]
   [Style(name="modalTransparencyBlur",type="Number",inherit="yes")]
   [Style(name="modalTransparency",type="Number",inherit="yes")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="verticalAlign",type="String",enumeration="bottom,middle,top",inherit="no")]
   [Style(name="horizontalAlign",type="String",enumeration="left,center,right",inherit="no")]
   public class Panel extends Container implements IConstraintLayout, IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const HEADER_PADDING:Number = 14;
      
      private static var _closeButtonStyleFilters:Object = {
         "closeButtonUpSkin":"closeButtonUpSkin",
         "closeButtonOverSkin":"closeButtonOverSkin",
         "closeButtonDownSkin":"closeButtonDownSkin",
         "closeButtonDisabledSkin":"closeButtonDisabledSkin",
         "closeButtonSkin":"closeButtonSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private var layoutObject:Layout;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _showCloseButton:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleBarBackground:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleIconObject:Object = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var closeButton:Button;
      
      private var initializing:Boolean = true;
      
      private var panelViewMetrics:EdgeMetrics;
      
      private var regX:Number;
      
      private var regY:Number;
      
      private var checkedForAutoSetRoundedCorners:Boolean;
      
      private var autoSetRoundedCorners:Boolean;
      
      private var inCreateComponentsFromDescriptors:Boolean;
      
      private var _constraintColumns:Array = [];
      
      private var _constraintRows:Array = [];
      
      protected var controlBar:IUIComponent;
      
      private var _layout:String = "vertical";
      
      private var _status:String = "";
      
      private var _statusChanged:Boolean = false;
      
      protected var statusTextField:IUITextField;
      
      private var _title:String = "";
      
      private var _titleChanged:Boolean = false;
      
      protected var titleBar:UIComponent;
      
      private var _titleIcon:Class;
      
      private var _titleIconChanged:Boolean = false;
      
      protected var titleTextField:IUITextField;
      
      public function Panel()
      {
         super();
         addEventListener("resizeStart",EffectManager.eventHandler,false,EventPriority.EFFECT);
         addEventListener("resizeEnd",EffectManager.eventHandler,false,EventPriority.EFFECT);
         this.layoutObject = new BoxLayout();
         this.layoutObject.target = this;
         showInAutomationHierarchy = true;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.titleBar.y + this.titleTextField.y + this.titleTextField.baselinePosition;
      }
      
      override public function set cacheAsBitmap(value:Boolean) : void
      {
         super.cacheAsBitmap = value;
         if(cacheAsBitmap && !contentPane && cachePolicy != UIComponentCachePolicy.OFF && Boolean(getStyle("backgroundColor")))
         {
            createContentPane();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(this.titleTextField))
         {
            this.titleTextField.enabled = value;
         }
         if(Boolean(this.statusTextField))
         {
            this.statusTextField.enabled = value;
         }
         if(Boolean(this.controlBar))
         {
            this.controlBar.enabled = value;
         }
         if(Boolean(this.closeButton))
         {
            this.closeButton.enabled = value;
         }
      }
      
      protected function get closeButtonStyleFilters() : Object
      {
         return _closeButtonStyleFilters;
      }
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
      public function get constraintColumns() : Array
      {
         return this._constraintColumns;
      }
      
      public function set constraintColumns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != this._constraintColumns)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintColumn(value[i]).container = this;
            }
            this._constraintColumns = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
      [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
      public function get constraintRows() : Array
      {
         return this._constraintRows;
      }
      
      public function set constraintRows(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value != this._constraintRows)
         {
            n = int(value.length);
            for(i = 0; i < n; i++)
            {
               ConstraintRow(value[i]).container = this;
            }
            this._constraintRows = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get _controlBar() : IUIComponent
      {
         return this.controlBar;
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal,absolute",defaultValue="vertical")]
      [Bindable("layoutChanged")]
      public function get layout() : String
      {
         return this._layout;
      }
      
      public function set layout(value:String) : void
      {
         if(this._layout != value)
         {
            this._layout = value;
            if(Boolean(this.layoutObject))
            {
               this.layoutObject.target = null;
            }
            if(this._layout == ContainerLayout.ABSOLUTE)
            {
               this.layoutObject = new CanvasLayout();
            }
            else
            {
               this.layoutObject = new BoxLayout();
               if(this._layout == ContainerLayout.VERTICAL)
               {
                  BoxLayout(this.layoutObject).direction = BoxDirection.VERTICAL;
               }
               else
               {
                  BoxLayout(this.layoutObject).direction = BoxDirection.HORIZONTAL;
               }
            }
            if(Boolean(this.layoutObject))
            {
               this.layoutObject.target = this;
            }
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("layoutChanged"));
         }
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("statusChanged")]
      public function get status() : String
      {
         return this._status;
      }
      
      public function set status(value:String) : void
      {
         this._status = value;
         this._statusChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("statusChanged"));
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("titleChanged")]
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(value:String) : void
      {
         this._title = value;
         this._titleChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         dispatchEvent(new Event("titleChanged"));
      }
      
      [Inspectable(category="General",defaultValue="",format="EmbeddedFile")]
      [Bindable("titleIconChanged")]
      public function get titleIcon() : Class
      {
         return this._titleIcon;
      }
      
      public function set titleIcon(value:Class) : void
      {
         this._titleIcon = value;
         this._titleIconChanged = true;
         invalidateProperties();
         invalidateSize();
         dispatchEvent(new Event("titleIconChanged"));
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get usePadding() : Boolean
      {
         return this.layout != ContainerLayout.ABSOLUTE;
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         if(Boolean(this.controlBar) && child == this.controlBar)
         {
            return numChildren;
         }
         return super.getChildIndex(child);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Panel.createAccessibilityImplementation != null)
         {
            Panel.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         var titleBarBackgroundClass:Class = null;
         var backgroundUIComponent:IStyleClient = null;
         var backgroundStyleable:ISimpleStyleClient = null;
         super.createChildren();
         if(!this.titleBar)
         {
            this.titleBar = new UIComponent();
            this.titleBar.visible = false;
            this.titleBar.addEventListener(MouseEvent.MOUSE_DOWN,this.titleBar_mouseDownHandler);
            rawChildren.addChild(this.titleBar);
         }
         if(!this.titleBarBackground)
         {
            titleBarBackgroundClass = getStyle("titleBackgroundSkin");
            if(Boolean(titleBarBackgroundClass))
            {
               this.titleBarBackground = new titleBarBackgroundClass();
               backgroundUIComponent = this.titleBarBackground as IStyleClient;
               if(Boolean(backgroundUIComponent))
               {
                  backgroundUIComponent.setStyle("backgroundImage",undefined);
               }
               backgroundStyleable = this.titleBarBackground as ISimpleStyleClient;
               if(Boolean(backgroundStyleable))
               {
                  backgroundStyleable.styleName = this;
               }
               this.titleBar.addChild(DisplayObject(this.titleBarBackground));
            }
         }
         this.createTitleTextField(-1);
         this.createStatusTextField(-1);
         if(!this.closeButton)
         {
            this.closeButton = new Button();
            this.closeButton.styleName = new StyleProxy(this,this.closeButtonStyleFilters);
            this.closeButton.upSkinName = "closeButtonUpSkin";
            this.closeButton.overSkinName = "closeButtonOverSkin";
            this.closeButton.downSkinName = "closeButtonDownSkin";
            this.closeButton.disabledSkinName = "closeButtonDisabledSkin";
            this.closeButton.skinName = "closeButtonSkin";
            this.closeButton.explicitWidth = this.closeButton.explicitHeight = 16;
            this.closeButton.focusEnabled = false;
            this.closeButton.visible = false;
            this.closeButton.enabled = enabled;
            this.closeButton.addEventListener(MouseEvent.CLICK,this.closeButton_clickHandler);
            this.titleBar.addChild(this.closeButton);
            this.closeButton.owner = this;
         }
      }
      
      override protected function commitProperties() : void
      {
         var childIndex:int = 0;
         super.commitProperties();
         if(hasFontContextChanged())
         {
            if(Boolean(this.titleTextField))
            {
               childIndex = int(this.titleBar.getChildIndex(DisplayObject(this.titleTextField)));
               this.removeTitleTextField();
               this.createTitleTextField(childIndex);
               this._titleChanged = true;
            }
            if(Boolean(this.statusTextField))
            {
               childIndex = int(this.titleBar.getChildIndex(DisplayObject(this.statusTextField)));
               this.removeStatusTextField();
               this.createStatusTextField(childIndex);
               this._statusChanged = true;
            }
         }
         if(this._titleChanged)
         {
            this._titleChanged = false;
            this.titleTextField.text = this._title;
            if(initialized)
            {
               this.layoutChrome(unscaledWidth,unscaledHeight);
            }
         }
         if(this._titleIconChanged)
         {
            this._titleIconChanged = false;
            if(Boolean(this.titleIconObject))
            {
               this.titleBar.removeChild(DisplayObject(this.titleIconObject));
               this.titleIconObject = null;
            }
            if(Boolean(this._titleIcon))
            {
               this.titleIconObject = new this._titleIcon();
               this.titleBar.addChild(DisplayObject(this.titleIconObject));
            }
            if(initialized)
            {
               this.layoutChrome(unscaledWidth,unscaledHeight);
            }
         }
         if(this._statusChanged)
         {
            this._statusChanged = false;
            this.statusTextField.text = this._status;
            if(initialized)
            {
               this.layoutChrome(unscaledWidth,unscaledHeight);
            }
         }
      }
      
      override protected function measure() : void
      {
         var controlWidth:Number = NaN;
         super.measure();
         this.layoutObject.measure();
         var textSize:Rectangle = this.measureHeaderText();
         var textWidth:Number = textSize.width;
         var textHeight:Number = textSize.height;
         var bm:EdgeMetrics = EdgeMetrics.EMPTY;
         textWidth += bm.left + bm.right;
         var offset:Number = 5;
         textWidth += offset * 2;
         if(Boolean(this.titleIconObject))
         {
            textWidth += this.titleIconObject.width;
         }
         if(Boolean(this.closeButton))
         {
            textWidth += this.closeButton.getExplicitOrMeasuredWidth() + 6;
         }
         measuredMinWidth = Math.max(textWidth,measuredMinWidth);
         measuredWidth = Math.max(textWidth,measuredWidth);
         if(Boolean(this.controlBar) && Boolean(this.controlBar.includeInLayout))
         {
            controlWidth = this.controlBar.getExplicitOrMeasuredWidth() + bm.left + bm.right;
            measuredWidth = Math.max(measuredWidth,controlWidth);
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(border))
         {
            border.visible = true;
         }
         this.titleBar.visible = true;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var titleStyleName:String = null;
         var statusStyleName:String = null;
         var controlBarStyleName:String = null;
         var titleBackgroundSkinClass:Class = null;
         var backgroundUIComponent:IStyleClient = null;
         var backgroundStyleable:ISimpleStyleClient = null;
         var allStyles:Boolean = !styleProp || styleProp == "styleName";
         super.styleChanged(styleProp);
         if(allStyles || styleProp == "titleStyleName")
         {
            if(Boolean(this.titleTextField))
            {
               titleStyleName = getStyle("titleStyleName");
               this.titleTextField.styleName = titleStyleName;
            }
         }
         if(allStyles || styleProp == "statusStyleName")
         {
            if(Boolean(this.statusTextField))
            {
               statusStyleName = getStyle("statusStyleName");
               this.statusTextField.styleName = statusStyleName;
            }
         }
         if(allStyles || styleProp == "controlBarStyleName")
         {
            if(Boolean(this.controlBar) && this.controlBar is ISimpleStyleClient)
            {
               controlBarStyleName = getStyle("controlBarStyleName");
               ISimpleStyleClient(this.controlBar).styleName = controlBarStyleName;
            }
         }
         if(allStyles || styleProp == "titleBackgroundSkin")
         {
            if(Boolean(this.titleBar))
            {
               titleBackgroundSkinClass = getStyle("titleBackgroundSkin");
               if(Boolean(titleBackgroundSkinClass))
               {
                  if(Boolean(this.titleBarBackground))
                  {
                     this.titleBar.removeChild(DisplayObject(this.titleBarBackground));
                     this.titleBarBackground = null;
                  }
                  this.titleBarBackground = new titleBackgroundSkinClass();
                  backgroundUIComponent = this.titleBarBackground as IStyleClient;
                  if(Boolean(backgroundUIComponent))
                  {
                     backgroundUIComponent.setStyle("backgroundImage",undefined);
                  }
                  backgroundStyleable = this.titleBarBackground as ISimpleStyleClient;
                  if(Boolean(backgroundStyleable))
                  {
                     backgroundStyleable.styleName = this;
                  }
                  this.titleBar.addChildAt(DisplayObject(this.titleBarBackground),0);
               }
            }
         }
      }
      
      override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var titleBarWidth:Number = NaN;
         var g:Graphics = null;
         var leftOffset:Number = NaN;
         var rightOffset:Number = NaN;
         var h:Number = NaN;
         var offset:Number = NaN;
         var borderWidth:Number = NaN;
         var statusX:Number = NaN;
         var minX:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cw:Number = NaN;
         var ch:Number = NaN;
         super.layoutChrome(unscaledWidth,unscaledHeight);
         var em:EdgeMetrics = EdgeMetrics.EMPTY;
         var bt:Number = Number(getStyle("borderThickness"));
         if(getQualifiedClassName(border) == "mx.skins.halo::PanelSkin" && getStyle("borderStyle") != "default" && Boolean(bt))
         {
            em = new EdgeMetrics(bt,bt,bt,bt);
         }
         var bm:EdgeMetrics = em;
         var x:Number = Number(bm.left);
         var y:Number = Number(bm.top);
         var headerHeight:Number = this.getHeaderHeight();
         if(headerHeight > 0 && height >= headerHeight)
         {
            titleBarWidth = unscaledWidth - bm.left - bm.right;
            this.showTitleBar(true);
            this.titleBar.mouseChildren = true;
            this.titleBar.mouseEnabled = true;
            g = this.titleBar.graphics;
            g.clear();
            g.beginFill(16777215,0);
            g.drawRect(0,0,titleBarWidth,headerHeight);
            g.endFill();
            g.lineStyle(0,0,0);
            g.drawRect(0,0,titleBarWidth,unscaledHeight);
            this.titleBar.move(x,y);
            this.titleBar.setActualSize(titleBarWidth,headerHeight);
            if(Boolean(this.titleBarBackground))
            {
               this.titleBarBackground.move(0,0);
               IFlexDisplayObject(this.titleBarBackground).setActualSize(titleBarWidth,headerHeight);
            }
            this.closeButton.visible = this._showCloseButton;
            if(this._showCloseButton)
            {
               this.closeButton.setActualSize(this.closeButton.getExplicitOrMeasuredWidth(),this.closeButton.getExplicitOrMeasuredHeight());
               this.closeButton.move(unscaledWidth - x - bm.right - 10 - this.closeButton.getExplicitOrMeasuredWidth(),(headerHeight - this.closeButton.getExplicitOrMeasuredHeight()) / 2);
            }
            leftOffset = 10;
            rightOffset = 10;
            if(Boolean(this.titleIconObject))
            {
               h = Number(this.titleIconObject.height);
               offset = (headerHeight - h) / 2;
               this.titleIconObject.move(leftOffset,offset);
               leftOffset += this.titleIconObject.width + 4;
            }
            h = Number(this.titleTextField.getUITextFormat().measureText(this.titleTextField.text).height);
            offset = (headerHeight - h) / 2;
            borderWidth = bm.left + bm.right;
            this.titleTextField.move(leftOffset,offset - 1);
            this.titleTextField.setActualSize(Math.max(0,unscaledWidth - leftOffset - rightOffset - borderWidth),h + UITextField.TEXT_HEIGHT_PADDING);
            h = this.statusTextField.text != "" ? Number(this.statusTextField.getUITextFormat().measureText(this.statusTextField.text).height) : 0;
            offset = (headerHeight - h) / 2;
            statusX = unscaledWidth - rightOffset - 4 - borderWidth - this.statusTextField.textWidth;
            if(this._showCloseButton)
            {
               statusX -= this.closeButton.getExplicitOrMeasuredWidth() + 4;
            }
            this.statusTextField.move(statusX,offset - 1);
            this.statusTextField.setActualSize(this.statusTextField.textWidth + 8,this.statusTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING);
            minX = this.titleTextField.x + this.titleTextField.textWidth + 8;
            if(this.statusTextField.x < minX)
            {
               this.statusTextField.width = Math.max(this.statusTextField.width - (minX - this.statusTextField.x),0);
               this.statusTextField.x = minX;
            }
         }
         else if(Boolean(this.titleBar))
         {
            this.showTitleBar(false);
            this.titleBar.mouseChildren = false;
            this.titleBar.mouseEnabled = false;
         }
         if(Boolean(this.controlBar))
         {
            cx = Number(this.controlBar.x);
            cy = Number(this.controlBar.y);
            cw = Number(this.controlBar.width);
            ch = Number(this.controlBar.height);
            this.controlBar.setActualSize(unscaledWidth - (bm.left + bm.right),this.controlBar.getExplicitOrMeasuredHeight());
            this.controlBar.move(bm.left,unscaledHeight - bm.bottom - this.controlBar.getExplicitOrMeasuredHeight());
            if(this.controlBar.includeInLayout)
            {
               this.controlBar.visible = this.controlBar.y >= bm.top;
            }
            if(cx != this.controlBar.x || cy != this.controlBar.y || cw != this.controlBar.width || ch != this.controlBar.height)
            {
               invalidateDisplayList();
            }
         }
      }
      
      override public function createComponentsFromDescriptors(recurse:Boolean = true) : void
      {
         var oldChildDocument:Object = null;
         this.inCreateComponentsFromDescriptors = true;
         super.createComponentsFromDescriptors();
         if(numChildren == 0)
         {
            this.setControlBar(null);
            this.inCreateComponentsFromDescriptors = false;
            return;
         }
         var lastChild:IUIComponent = IUIComponent(getChildAt(numChildren - 1));
         if(lastChild is ControlBar)
         {
            oldChildDocument = lastChild.document;
            if(Boolean(contentPane))
            {
               contentPane.removeChild(DisplayObject(lastChild));
            }
            else
            {
               super.removeChild(DisplayObject(lastChild));
            }
            lastChild.document = oldChildDocument;
            rawChildren.addChild(DisplayObject(lastChild));
            this.setControlBar(lastChild);
         }
         else
         {
            this.setControlBar(null);
         }
         this.inCreateComponentsFromDescriptors = false;
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         super.addChildAt(child,index);
         if(!this.inCreateComponentsFromDescriptors && child is ControlBar)
         {
            this.createComponentsFromDescriptors();
         }
         return child;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         if(!this.inCreateComponentsFromDescriptors && child is ControlBar && numChildren > 0 && child == getChildAt(numChildren - 1))
         {
            rawChildren.removeChild(child);
            this.createComponentsFromDescriptors();
            return child;
         }
         return super.removeChild(child);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createTitleTextField(childIndex:int) : void
      {
         var titleStyleName:String = null;
         if(!this.titleTextField)
         {
            this.titleTextField = IUITextField(createInFontContext(UITextField));
            this.titleTextField.selectable = false;
            if(childIndex == -1)
            {
               this.titleBar.addChild(DisplayObject(this.titleTextField));
            }
            else
            {
               this.titleBar.addChildAt(DisplayObject(this.titleTextField),childIndex);
            }
            titleStyleName = getStyle("titleStyleName");
            this.titleTextField.styleName = titleStyleName;
            this.titleTextField.text = this.title;
            this.titleTextField.enabled = enabled;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeTitleTextField() : void
      {
         if(Boolean(this.titleBar) && Boolean(this.titleTextField))
         {
            this.titleBar.removeChild(DisplayObject(this.titleTextField));
            this.titleTextField = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createStatusTextField(childIndex:int) : void
      {
         var statusStyleName:String = null;
         if(Boolean(this.titleBar) && !this.statusTextField)
         {
            this.statusTextField = IUITextField(createInFontContext(UITextField));
            this.statusTextField.selectable = false;
            if(childIndex == -1)
            {
               this.titleBar.addChild(DisplayObject(this.statusTextField));
            }
            else
            {
               this.titleBar.addChildAt(DisplayObject(this.statusTextField),childIndex);
            }
            statusStyleName = getStyle("statusStyleName");
            this.statusTextField.styleName = statusStyleName;
            this.statusTextField.text = this.status;
            this.statusTextField.enabled = enabled;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeStatusTextField() : void
      {
         if(Boolean(this.titleBar) && Boolean(this.statusTextField))
         {
            this.titleBar.removeChild(DisplayObject(this.statusTextField));
            this.statusTextField = null;
         }
      }
      
      private function measureHeaderText(useDummyString:Boolean = false) : Rectangle
      {
         var textFormat:UITextFormat = null;
         var metrics:TextLineMetrics = null;
         var textWidth:Number = 20;
         var textHeight:Number = 14;
         if(Boolean(this.titleTextField) && Boolean(this.titleTextField.text))
         {
            this.titleTextField.validateNow();
            textFormat = this.titleTextField.getUITextFormat();
            metrics = textFormat.measureText(this.titleTextField.text,false);
            textWidth = metrics.width;
            textHeight = metrics.height;
         }
         else if(useDummyString)
         {
            if(Boolean(this.titleTextField))
            {
               textFormat = this.titleTextField.getUITextFormat();
               metrics = textFormat.measureText("Wj",false);
               textWidth = metrics.width;
               textHeight = metrics.height;
            }
         }
         if(Boolean(this.statusTextField) && Boolean(this.statusTextField.text))
         {
            this.statusTextField.validateNow();
            textFormat = this.statusTextField.getUITextFormat();
            metrics = textFormat.measureText(this.statusTextField.text,false);
            textWidth = Math.max(textWidth,metrics.width);
            textHeight = Math.max(textHeight,metrics.height);
         }
         return new Rectangle(0,0,Math.round(textWidth),Math.round(textHeight));
      }
      
      protected function getHeaderHeight() : Number
      {
         var headerHeight:Number = Number(getStyle("headerHeight"));
         if(isNaN(headerHeight))
         {
            headerHeight = this.measureHeaderText().height + HEADER_PADDING;
         }
         return headerHeight;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHeaderHeightProxy(useDummyString:Boolean = false) : Number
      {
         var headerHeight:Number = Number(getStyle("headerHeight"));
         if(isNaN(headerHeight))
         {
            headerHeight = this.measureHeaderText(useDummyString).height + HEADER_PADDING;
         }
         return headerHeight;
      }
      
      private function showTitleBar(show:Boolean) : void
      {
         var child:DisplayObject = null;
         this.titleBar.visible = show;
         var n:int = int(this.titleBar.numChildren);
         for(var i:int = 0; i < n; i++)
         {
            child = this.titleBar.getChildAt(i);
            child.visible = show;
         }
      }
      
      private function setControlBar(newControlBar:IUIComponent) : void
      {
         if(newControlBar == this.controlBar)
         {
            return;
         }
         this.controlBar = newControlBar;
         if(!this.checkedForAutoSetRoundedCorners)
         {
            this.checkedForAutoSetRoundedCorners = true;
            this.autoSetRoundedCorners = Boolean(styleDeclaration) ? styleDeclaration.getStyle("roundedBottomCorners") === undefined : true;
         }
         if(this.autoSetRoundedCorners)
         {
            setStyle("roundedBottomCorners",this.controlBar != null);
         }
         var controlBarStyleName:String = getStyle("controlBarStyleName");
         if(Boolean(controlBarStyleName) && this.controlBar is ISimpleStyleClient)
         {
            ISimpleStyleClient(this.controlBar).styleName = controlBarStyleName;
         }
         if(Boolean(this.controlBar))
         {
            this.controlBar.enabled = enabled;
         }
         if(this.controlBar is IAutomationObject)
         {
            IAutomationObject(this.controlBar).showInAutomationHierarchy = false;
         }
         invalidateViewMetricsAndPadding();
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function startDragging(event:MouseEvent) : void
      {
         this.regX = event.stageX - x;
         this.regY = event.stageY - y;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,this.systemManager_mouseMoveHandler,true);
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.stage_mouseLeaveHandler);
         systemManager.deployMouseShields(true);
      }
      
      protected function stopDragging() : void
      {
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.systemManager_mouseMoveHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.stage_mouseLeaveHandler);
         this.regX = NaN;
         this.regY = NaN;
         systemManager.deployMouseShields(false);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTitleBar() : UIComponent
      {
         return this.titleBar;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getTitleTextField() : IUITextField
      {
         return this.titleTextField;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getStatusTextField() : IUITextField
      {
         return this.statusTextField;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getControlBar() : IUIComponent
      {
         return this.controlBar;
      }
      
      private function titleBar_mouseDownHandler(event:MouseEvent) : void
      {
         if(event.target == this.closeButton)
         {
            return;
         }
         if(enabled && Boolean(isPopUp) && isNaN(this.regX))
         {
            this.startDragging(event);
         }
      }
      
      private function systemManager_mouseMoveHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         if(isNaN(this.regX) || isNaN(this.regY))
         {
            return;
         }
         move(event.stageX - this.regX,event.stageY - this.regY);
      }
      
      private function systemManager_mouseUpHandler(event:MouseEvent) : void
      {
         if(!isNaN(this.regX))
         {
            this.stopDragging();
         }
      }
      
      private function stage_mouseLeaveHandler(event:Event) : void
      {
         if(!isNaN(this.regX))
         {
            this.stopDragging();
         }
      }
      
      private function closeButton_clickHandler(event:MouseEvent) : void
      {
         dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      }
   }
}

