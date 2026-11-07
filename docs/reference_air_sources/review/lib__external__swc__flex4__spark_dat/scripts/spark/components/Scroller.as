package spark.components
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.core.EventPriority;
   import mx.core.FlexGlobals;
   import mx.core.IFactory;
   import mx.core.IInvalidating;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.InteractionMode;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.TouchInteractionEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.IStyleClient;
   import spark.components.supportClasses.GroupBase;
   import spark.components.supportClasses.ScrollerLayout;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.components.supportClasses.TouchScrollHelper;
   import spark.core.IGraphicElement;
   import spark.core.IViewport;
   import spark.core.NavigationUnit;
   import spark.effects.Animate;
   import spark.effects.ThrowEffect;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.events.CaretBoundsChangeEvent;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.utils.MouseEventUtil;
   
   [IconFile("Scroller.png")]
   [DefaultProperty("viewport")]
   [ResourceBundle("components")]
   [Style(name="verticalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="touchDelay",type="Number",format="Time",inherit="yes",minValue="0.0")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="liveScrolling",type="Boolean",inherit="no")]
   [Style(name="horizontalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="downColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark, mobile")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Event(name="mouseWheelChanging",type="mx.events.FlexMouseEvent")]
   [Style(name="unfocusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="inactiveTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="focusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="wordSpacing",type="Object",inherit="yes")]
   [Style(name="whiteSpaceCollapse",type="String",enumeration="collapse,preserve",inherit="yes")]
   [Style(name="textRotation",type="String",enumeration="auto,rotate0,rotate90,rotate180,rotate270",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes",minValue="0.0")]
   [Style(name="tabStops",type="String",inherit="yes")]
   [Style(name="paragraphStartIndent",type="Number",format="length",inherit="yes")]
   [Style(name="paragraphSpaceBefore",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphSpaceAfter",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphEndIndent",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="listStyleType",type="String",enumeration="upperAlpha,lowerAlpha,upperRoman,lowerRoman,none,disc,circle,square,box,check,diamond,hyphen,arabicIndic,bengali,decimal,decimalLeadingZero,devanagari,gujarati,gurmukhi,kannada,persian,thai,urdu,cjkEarthlyBranch,cjkHeavenlyStem,hangul,hangulConstant,hiragana,hiraganaIroha,katakana,katakanaIroha,lowerGreek,lowerLatin,upperGreek,upperLatin",inherit="yes")]
   [Style(name="listStylePosition",type="String",enumeration="inside,outside",inherit="yes")]
   [Style(name="listAutoPadding",type="Number",format="length",inherit="yes",minValue="-1000",maxValue="1000")]
   [Style(name="leadingModel",type="String",enumeration="auto,romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,ascentDescentUp,box",inherit="yes")]
   [Style(name="firstBaselineOffset",type="Object",inherit="yes")]
   [Style(name="clearFloats",type="String",enumeration="start,end,left,right,both,none",inherit="yes")]
   [Style(name="breakOpportunity",type="String",enumeration="auto,all,any,none",inherit="yes")]
   [Style(name="blockProgression",type="String",enumeration="tb,rl",inherit="yes")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   public class Scroller extends SkinnableComponent implements IFocusManagerComponent, IVisualElementContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const PULL_TENSION_RATIO:Number = 0.5;
      
      private static const ZERO_POINT:Point = new Point(0,0);
      
      private static const MAX_DRAG_RATE:Number = 30;
      
      private static const HORIZONTAL_SCROLL_POSITION:String = "horizontalScrollPosition";
      
      private static const VERTICAL_SCROLL_POSITION:String = "verticalScrollPosition";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var dragEventThinning:Boolean = true;
      
      private static const TEXT_SELECTION_AUTO_SCROLL_FPS:int = 10;
      
      private static var _skinParts:Object = {
         "horizontalScrollBarFactory":false,
         "horizontalScrollBar":false,
         "verticalScrollBar":false,
         "verticalScrollBarFactory":false
      };
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var minSlopInches:Number = 0.079365;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var throwEffectDecelFactor:Number = 0.998;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var pageDragDistanceThreshold:Number = 0.5;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var pageThrowVelocityThreshold:Number = 0.8;
      
      private var scrollRangesChanged:Boolean = false;
      
      private var pageScrollingChanged:Boolean = false;
      
      private var snappingModeChanged:Boolean = false;
      
      private var _pullEnabled:Boolean = true;
      
      private var _bounceEnabled:Boolean = true;
      
      private var touchScrollHelper:TouchScrollHelper;
      
      private var hspBeforeTouchScroll:Number;
      
      private var vspBeforeTouchScroll:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var throwEffect:ThrowEffect;
      
      private var throwFinalVSP:Number;
      
      private var throwFinalHSP:Number;
      
      private var throwReachedMaximumScrollPosition:Boolean;
      
      private var stoppedPreemptively:Boolean = false;
      
      private var captureNextClick:Boolean = false;
      
      private var captureNextMouseDown:Boolean = false;
      
      private var hideScrollBarAnimation:Animate;
      
      private var hideScrollBarAnimationPrematurelyStopped:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var inTouchInteraction:Boolean = false;
      
      private var minVerticalScrollPosition:Number = 0;
      
      private var maxVerticalScrollPosition:Number = 0;
      
      private var minHorizontalScrollPosition:Number = 0;
      
      private var maxHorizontalScrollPosition:Number = 0;
      
      private var snapElementAnimation:Animate;
      
      private var currentPageScrollPosition:Number;
      
      private var lastSnappedElement:int = -1;
      
      private var orientationChangeSnapElement:int = -1;
      
      private var previousOrientationPageCount:int = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var ensureElementIsVisibleForSoftKeyboard:Boolean = true;
      
      private var lastFocusedElement:IVisualElement;
      
      private var aspectRatio:String;
      
      private var oldSoftKeyboardHeight:Number = NaN;
      
      private var oldSoftKeyboardWidth:Number = NaN;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var preventThrows:Boolean = false;
      
      private var lastFocusedElementCaretBounds:Rectangle;
      
      private var captureNextCaretBoundsChange:Boolean = false;
      
      private var _42694078horizontalScrollBar:HScrollBar;
      
      [SkinPart(required="false",type="spark.components.HScrollBar")]
      public var horizontalScrollBarFactory:IFactory;
      
      private var _horizontalScrollInProgress:Boolean = false;
      
      private var _1618627376verticalScrollBar:VScrollBar;
      
      [SkinPart(required="false",type="spark.components.VScrollBar")]
      public var verticalScrollBarFactory:IFactory;
      
      private var _verticalScrollInProgress:Boolean = false;
      
      private var _viewport:IViewport;
      
      private var _minViewportInset:Number = 0;
      
      private var _measuredSizeIncludesScrollBars:Boolean = true;
      
      private var _pageScrollingEnabled:Boolean = false;
      
      private var _scrollSnappingMode:String = "none";
      
      private var settingScrollPosition:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var textSelectionAutoScrollEnabled:Boolean = false;
      
      private var textSelectionAutoScrollTimer:Timer;
      
      private var minTextSelectionVScrollPos:int = 0;
      
      private var maxTextSelectionVScrollPos:int = -1;
      
      private var minTextSelectionHScrollPos:int = 0;
      
      private var maxTextSelectionHScrollPos:int = -1;
      
      public function Scroller()
      {
         super();
         hasFocusableChildren = true;
         focusEnabled = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get pullEnabled() : Boolean
      {
         return this._pullEnabled;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set pullEnabled(value:Boolean) : void
      {
         if(this._pullEnabled == value)
         {
            return;
         }
         this._pullEnabled = value;
         this.scrollRangesChanged = true;
         invalidateProperties();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get bounceEnabled() : Boolean
      {
         return this._bounceEnabled;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set bounceEnabled(value:Boolean) : void
      {
         if(this._bounceEnabled == value)
         {
            return;
         }
         this._bounceEnabled = value;
         this.scrollRangesChanged = true;
         invalidateProperties();
      }
      
      private function ensureDeferredHScrollBarCreated() : void
      {
         if(!this.horizontalScrollBar && Boolean(this.horizontalScrollBarFactory))
         {
            this.horizontalScrollBar = HScrollBar(createDynamicPartInstance("horizontalScrollBarFactory"));
            Group(this.skin).addElement(this.horizontalScrollBar);
            this.partAdded("horizontalScrollBar",this.horizontalScrollBar);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get horizontalScrollInProgress() : Boolean
      {
         return this._horizontalScrollInProgress;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set horizontalScrollInProgress(value:Boolean) : void
      {
         this._horizontalScrollInProgress = value;
         if(value && getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            this.ensureDeferredHScrollBarCreated();
         }
      }
      
      private function ensureDeferredVScrollBarCreated() : void
      {
         if(!this.verticalScrollBar && Boolean(this.verticalScrollBarFactory))
         {
            this.verticalScrollBar = VScrollBar(createDynamicPartInstance("verticalScrollBarFactory"));
            Group(this.skin).addElement(this.verticalScrollBar);
            this.partAdded("verticalScrollBar",this.verticalScrollBar);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get verticalScrollInProgress() : Boolean
      {
         return this._verticalScrollInProgress;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set verticalScrollInProgress(value:Boolean) : void
      {
         this._verticalScrollInProgress = value;
         if(value && getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            this.ensureDeferredVScrollBarCreated();
         }
      }
      
      [Bindable(event="viewportChanged")]
      public function get viewport() : IViewport
      {
         return this._viewport;
      }
      
      public function set viewport(value:IViewport) : void
      {
         if(value == this._viewport)
         {
            return;
         }
         this.uninstallViewport();
         this._viewport = value;
         this.installViewport();
         dispatchEvent(new Event("viewportChanged"));
      }
      
      private function installViewport() : void
      {
         if(Boolean(skin) && Boolean(this.viewport))
         {
            this.viewport.clipAndEnableScrolling = true;
            Group(skin).addElementAt(this.viewport,0);
            this.viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.viewport_propertyChangeHandler);
            this.viewport.addEventListener(Event.RESIZE,this.viewport_resizeHandler);
         }
         if(Boolean(this.verticalScrollBar))
         {
            this.verticalScrollBar.viewport = this.viewport;
         }
         if(Boolean(this.horizontalScrollBar))
         {
            this.horizontalScrollBar.viewport = this.viewport;
         }
      }
      
      private function uninstallViewport() : void
      {
         if(Boolean(this.horizontalScrollBar))
         {
            this.horizontalScrollBar.viewport = null;
         }
         if(Boolean(this.verticalScrollBar))
         {
            this.verticalScrollBar.viewport = null;
         }
         if(Boolean(skin) && Boolean(this.viewport))
         {
            this.viewport.clipAndEnableScrolling = false;
            Group(skin).removeElement(this.viewport);
            this.viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.viewport_propertyChangeHandler);
            this.viewport.removeEventListener(Event.RESIZE,this.viewport_resizeHandler);
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get minViewportInset() : Number
      {
         return this._minViewportInset;
      }
      
      public function set minViewportInset(value:Number) : void
      {
         if(value == this._minViewportInset)
         {
            return;
         }
         this._minViewportInset = value;
         this.invalidateSkin();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get measuredSizeIncludesScrollBars() : Boolean
      {
         return this._measuredSizeIncludesScrollBars;
      }
      
      public function set measuredSizeIncludesScrollBars(value:Boolean) : void
      {
         if(value == this._measuredSizeIncludesScrollBars)
         {
            return;
         }
         this._measuredSizeIncludesScrollBars = value;
         this.invalidateSkin();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get pageScrollingEnabled() : Boolean
      {
         return this._pageScrollingEnabled;
      }
      
      public function set pageScrollingEnabled(value:Boolean) : void
      {
         if(value == this._pageScrollingEnabled)
         {
            return;
         }
         this._pageScrollingEnabled = value;
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            if(this.canScrollHorizontally && this.canScrollVertically)
            {
               throw new Error(resourceManager.getString("components","operationSupportedForOneAxisOnly"));
            }
            this.scrollRangesChanged = true;
            this.pageScrollingChanged = true;
            invalidateProperties();
         }
      }
      
      [Inspectable(category="General",enumeration="none,leadingEdge,center,trailingEdge",defaultValue="none")]
      public function get scrollSnappingMode() : String
      {
         return this._scrollSnappingMode;
      }
      
      public function set scrollSnappingMode(value:String) : void
      {
         if(value == this._scrollSnappingMode)
         {
            return;
         }
         this._scrollSnappingMode = value;
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            if(this.canScrollHorizontally && this.canScrollVertically)
            {
               throw new Error(resourceManager.getString("components","operationSupportedForOneAxisOnly"));
            }
            this.scrollRangesChanged = true;
            this.snappingModeChanged = true;
            invalidateProperties();
         }
      }
      
      public function ensureElementIsVisible(element:IVisualElement) : void
      {
         this.ensureElementPositionIsVisible(element);
      }
      
      private function ensureElementPositionIsVisible(element:IVisualElement, elementLocalBounds:Rectangle = null, entireElementVisible:Boolean = true, doValidateNow:Boolean = true) : void
      {
         var delta:Point = null;
         var topLevelApp:Application = null;
         var eltBounds:Rectangle = null;
         var adjustForSoftKeyboard:Boolean = false;
         var keyboardTopLocal:Number = NaN;
         var scrollerHeight:Number = NaN;
         var dy:Number = NaN;
         var dx:Number = NaN;
         var focusThickness:Number = NaN;
         var possibleDescendant:DisplayObject = element as DisplayObject;
         if(element is IGraphicElement)
         {
            possibleDescendant = IGraphicElement(element).parent as DisplayObject;
         }
         if(!possibleDescendant || !contains(possibleDescendant))
         {
            return;
         }
         var layout:LayoutBase = this.viewportLayout;
         if(Boolean(layout))
         {
            if(Boolean(this.throwEffect) && Boolean(this.throwEffect.isPlaying))
            {
               this.throwEffect.stop();
               this.snapContentScrollPosition();
            }
            delta = layout.getScrollPositionDeltaToAnyElement(element,elementLocalBounds,entireElementVisible);
            topLevelApp = FlexGlobals.topLevelApplication as Application;
            adjustForSoftKeyboard = Boolean(topLevelApp) && !topLevelApp.resizeForSoftKeyboard && (Boolean(stage) && stage.softKeyboardRect.height > 0);
            if(adjustForSoftKeyboard)
            {
               eltBounds = layout.getChildElementBounds(element);
               keyboardTopLocal = Number(this.globalToLocal(stage.softKeyboardRect.topLeft).y);
               scrollerHeight = Number(this.getLayoutBoundsHeight());
               if(keyboardTopLocal >= 0 && keyboardTopLocal < scrollerHeight && eltBounds.bottom - this.viewport.verticalScrollPosition > keyboardTopLocal)
               {
                  dy = 0;
                  if(eltBounds.height > keyboardTopLocal)
                  {
                     dy = eltBounds.top;
                  }
                  else
                  {
                     dy = eltBounds.bottom - keyboardTopLocal;
                  }
                  dx = Boolean(delta) ? delta.x : 0;
                  delta = new Point(dx,dy - this.viewport.verticalScrollPosition);
               }
            }
            if(Boolean(delta))
            {
               this.viewport.horizontalScrollPosition += delta.x;
               this.viewport.verticalScrollPosition += delta.y;
               if(!elementLocalBounds)
               {
                  if(!eltBounds)
                  {
                     eltBounds = layout.getChildElementBounds(element);
                  }
                  focusThickness = 0;
                  if(element is IStyleClient)
                  {
                     focusThickness = Number(IStyleClient(element).getStyle("focusThickness"));
                  }
                  if(Boolean(focusThickness))
                  {
                     if(this.viewport.verticalScrollPosition > eltBounds.top - focusThickness)
                     {
                        this.viewport.verticalScrollPosition = eltBounds.top - focusThickness;
                     }
                     else if(this.viewport.verticalScrollPosition + height < eltBounds.bottom + focusThickness)
                     {
                        this.viewport.verticalScrollPosition = eltBounds.bottom + focusThickness - height;
                     }
                     if(this.viewport.horizontalScrollPosition > eltBounds.left - focusThickness)
                     {
                        this.viewport.horizontalScrollPosition = eltBounds.left - focusThickness;
                     }
                     else if(this.viewport.horizontalScrollPosition + width < eltBounds.right + focusThickness)
                     {
                        this.viewport.horizontalScrollPosition = eltBounds.right + focusThickness - width;
                     }
                  }
               }
               if(doValidateNow && this.viewport is UIComponent)
               {
                  UIComponent(this.viewport).validateNow();
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function snapElement(elementIndex:int, animate:Boolean) : Animate
      {
         var snapScrollPosition:Number = NaN;
         var scrollProperty:String = null;
         var snapMotionPath:Vector.<MotionPath> = null;
         var layout:LayoutBase = this.viewportLayout;
         if(!layout)
         {
            throw new Error(resourceManager.getString("components","operationRequiresViewportLayout"));
         }
         var elementBounds:Rectangle = layout.getElementBounds(elementIndex);
         switch(this.scrollSnappingMode)
         {
            case ScrollSnappingMode.NONE:
               throw new Error(resourceManager.getString("components","operationRequiresSnappingMode"));
            case ScrollSnappingMode.LEADING_EDGE:
               if(this.canScrollHorizontally)
               {
                  snapScrollPosition = elementBounds.left;
               }
               else if(this.canScrollVertically)
               {
                  snapScrollPosition = elementBounds.top;
               }
               break;
            case ScrollSnappingMode.CENTER:
               if(this.canScrollHorizontally)
               {
                  snapScrollPosition = elementBounds.left + elementBounds.width / 2 - this.viewport.width / 2;
               }
               else if(this.canScrollVertically)
               {
                  snapScrollPosition = elementBounds.top + elementBounds.height / 2 - this.viewport.height / 2;
               }
               break;
            case ScrollSnappingMode.TRAILING_EDGE:
               if(this.canScrollHorizontally)
               {
                  snapScrollPosition = elementBounds.right - this.viewport.width;
               }
               else if(this.canScrollVertically)
               {
                  snapScrollPosition = elementBounds.bottom - this.viewport.height;
               }
         }
         if(this.canScrollHorizontally)
         {
            scrollProperty = HORIZONTAL_SCROLL_POSITION;
         }
         else if(this.canScrollVertically)
         {
            scrollProperty = VERTICAL_SCROLL_POSITION;
         }
         this.stopAnimations();
         if(animate)
         {
            if(!this.snapElementAnimation)
            {
               this.snapElementAnimation = new Animate();
               this.snapElementAnimation.duration = 300;
               this.snapElementAnimation.target = this.viewport;
            }
            snapMotionPath = Vector.<MotionPath>([new SimpleMotionPath(scrollProperty,null,snapScrollPosition)]);
            this.snapElementAnimation.motionPaths = snapMotionPath;
            this.snapElementAnimation.play();
            if(this.pageScrollingEnabled)
            {
               this.currentPageScrollPosition = snapScrollPosition;
            }
            return this.snapElementAnimation;
         }
         this.viewport[scrollProperty] = snapScrollPosition;
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function stopAnimations() : void
      {
         if(Boolean(this.throwEffect) && Boolean(this.throwEffect.isPlaying))
         {
            this.throwEffect.stop();
         }
         if(Boolean(this.snapElementAnimation) && Boolean(this.snapElementAnimation.isPlaying))
         {
            this.snapElementAnimation.stop();
         }
      }
      
      private function getCurrentPageCount() : int
      {
         var viewportWidth:Number = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
         var viewportHeight:Number = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
         var pageCount:int = 0;
         if(this.canScrollHorizontally && viewportWidth != 0)
         {
            pageCount = Math.ceil(this.viewport.contentWidth / viewportWidth);
         }
         else if(this.canScrollVertically && viewportHeight != 0)
         {
            pageCount = Math.ceil(this.viewport.contentHeight / viewportHeight);
         }
         return pageCount;
      }
      
      private function checkScrollPosition() : void
      {
         var velocity:Point = null;
         var viewportWidth:Number = NaN;
         var viewportHeight:Number = NaN;
         this.determineScrollRanges();
         var orientationChange:Boolean = this.aspectRatio != FlexGlobals.topLevelApplication.aspectRatio;
         this.aspectRatio = FlexGlobals.topLevelApplication.aspectRatio;
         var needRethrow:Boolean = false;
         if(!this.pageScrollingEnabled)
         {
            if(this.throwReachedMaximumScrollPosition && (this.throwFinalVSP < this.maxVerticalScrollPosition || this.throwFinalHSP < this.maxHorizontalScrollPosition))
            {
               needRethrow = true;
            }
            if(this.throwFinalVSP > this.maxVerticalScrollPosition || this.throwFinalHSP > this.maxHorizontalScrollPosition)
            {
               needRethrow = true;
            }
         }
         if(this.scrollSnappingMode != ScrollSnappingMode.NONE || this.pageScrollingEnabled)
         {
            if(this.canScrollHorizontally)
            {
               if(this.getSnappedPosition(this.throwFinalHSP,HORIZONTAL_SCROLL_POSITION) != this.throwFinalHSP)
               {
                  needRethrow = true;
               }
            }
            if(this.canScrollVertically)
            {
               if(this.getSnappedPosition(this.throwFinalVSP,VERTICAL_SCROLL_POSITION) != this.throwFinalVSP)
               {
                  needRethrow = true;
               }
            }
         }
         if(Boolean(this.throwEffect) && Boolean(this.throwEffect.isPlaying) && needRethrow)
         {
            if(orientationChange)
            {
               this.throwEffect.stop();
               this.snapContentScrollPosition();
            }
            else
            {
               velocity = this.throwEffect.getCurrentVelocity();
               this.stoppedPreemptively = true;
               this.throwEffect.stop();
               this.stoppedPreemptively = false;
               if(this.setUpThrowEffect(-velocity.x,-velocity.y))
               {
                  this.throwEffect.play();
               }
            }
         }
         else if(!this.inTouchInteraction)
         {
            if(orientationChange && this.orientationChangeSnapElement != -1)
            {
               if(this.scrollSnappingMode == ScrollSnappingMode.NONE && this.pageScrollingEnabled)
               {
                  if(this.previousOrientationPageCount == this.getCurrentPageCount())
                  {
                     viewportWidth = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
                     viewportHeight = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
                     if(this.canScrollHorizontally)
                     {
                        this.viewport.horizontalScrollPosition = this.orientationChangeSnapElement * viewportWidth;
                        this.currentPageScrollPosition = this.viewport.horizontalScrollPosition;
                     }
                     else if(this.canScrollVertically)
                     {
                        this.viewport.verticalScrollPosition = this.orientationChangeSnapElement * viewportHeight;
                        this.currentPageScrollPosition = this.viewport.verticalScrollPosition;
                     }
                  }
               }
               else
               {
                  this.snapElement(this.orientationChangeSnapElement,false);
               }
               this.orientationChangeSnapElement = -1;
            }
            this.snapContentScrollPosition();
         }
      }
      
      private function handleSizeChange() : void
      {
         this.checkScrollPosition();
         if(this.pageScrollingEnabled && isNaN(this.currentPageScrollPosition))
         {
            this.determineCurrentPageScrollPosition();
         }
      }
      
      private function determineLeadingEdgeSnappingScrollRanges() : void
      {
         var maxPositionItemIndex:int = 0;
         var maxPositionItemBounds:Rectangle = null;
         var viewportWidth:Number = NaN;
         var viewportHeight:Number = NaN;
         var layout:LayoutBase = this.viewportLayout;
         var firstItemIndex:int = layout.getElementNearestScrollPosition(new Point(0,0),"topLeft");
         var firstItemBounds:Rectangle = layout.getElementBounds(firstItemIndex);
         if(this.canScrollHorizontally)
         {
            this.minHorizontalScrollPosition = firstItemBounds.left;
            viewportWidth = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
            maxPositionItemIndex = layout.getElementNearestScrollPosition(new Point(this.viewport.contentWidth - viewportWidth,0),"topLeft");
            do
            {
               maxPositionItemBounds = layout.getElementBounds(maxPositionItemIndex);
               if(this.viewport.contentWidth - maxPositionItemBounds.left <= viewportWidth)
               {
                  break;
               }
            }
            while(++maxPositionItemIndex < layout.target.numElements);
            this.maxHorizontalScrollPosition = maxPositionItemBounds.left;
         }
         else if(this.canScrollVertically)
         {
            this.minVerticalScrollPosition = firstItemBounds.top;
            viewportHeight = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
            maxPositionItemIndex = layout.getElementNearestScrollPosition(new Point(0,this.viewport.contentHeight - viewportHeight),"topLeft");
            do
            {
               maxPositionItemBounds = layout.getElementBounds(maxPositionItemIndex);
               if(this.viewport.contentHeight - maxPositionItemBounds.top <= viewportHeight)
               {
                  break;
               }
            }
            while(++maxPositionItemIndex < layout.target.numElements);
            this.maxVerticalScrollPosition = maxPositionItemBounds.top;
         }
      }
      
      private function determineCenterSnappingScrollRanges() : void
      {
         var leadingItemIndex:int = 0;
         var leadingItemBounds:Rectangle = null;
         var trailingItemIndex:int = 0;
         var trailingItemBounds:Rectangle = null;
         var viewportWidth:Number = NaN;
         var viewportHeight:Number = NaN;
         var layout:LayoutBase = this.viewportLayout;
         leadingItemIndex = layout.getElementNearestScrollPosition(new Point(0,0),"center");
         leadingItemBounds = layout.getElementBounds(leadingItemIndex);
         if(this.canScrollHorizontally)
         {
            viewportWidth = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
            trailingItemIndex = layout.getElementNearestScrollPosition(new Point(this.viewport.contentWidth,0),"center");
            trailingItemBounds = layout.getElementBounds(trailingItemIndex);
            this.minVerticalScrollPosition = this.maxVerticalScrollPosition = 0;
            this.minHorizontalScrollPosition = leadingItemBounds.left + leadingItemBounds.width / 2 - viewportWidth / 2;
            this.maxHorizontalScrollPosition = trailingItemBounds.left + trailingItemBounds.width / 2 - viewportWidth / 2;
         }
         else if(this.canScrollVertically)
         {
            viewportHeight = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
            trailingItemIndex = layout.getElementNearestScrollPosition(new Point(0,this.viewport.contentHeight),"center");
            trailingItemBounds = layout.getElementBounds(trailingItemIndex);
            this.minHorizontalScrollPosition = this.maxHorizontalScrollPosition = 0;
            this.minVerticalScrollPosition = leadingItemBounds.top + leadingItemBounds.height / 2 - viewportHeight / 2;
            this.maxVerticalScrollPosition = trailingItemBounds.top + trailingItemBounds.height / 2 - viewportHeight / 2;
         }
      }
      
      private function determineTrailingEdgeSnappingScrollRanges() : void
      {
         var snappedItemIndex:int = 0;
         var snappedItemBounds:Rectangle = null;
         var lastItemIndex:int = 0;
         var lastItemBounds:Rectangle = null;
         var viewportWidth:Number = NaN;
         var viewportHeight:Number = NaN;
         var layout:LayoutBase = this.viewportLayout;
         if(this.canScrollHorizontally)
         {
            viewportWidth = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
            lastItemIndex = layout.getElementNearestScrollPosition(new Point(this.viewport.contentWidth,0),"bottomRight");
            lastItemBounds = layout.getElementBounds(lastItemIndex);
            this.maxHorizontalScrollPosition = lastItemBounds.right - viewportWidth;
            snappedItemIndex = layout.getElementNearestScrollPosition(new Point(viewportWidth,0),"bottomRight");
            do
            {
               snappedItemBounds = layout.getElementBounds(snappedItemIndex);
               if(snappedItemBounds.right <= viewportWidth)
               {
                  break;
               }
            }
            while(--snappedItemIndex >= 0);
            this.minHorizontalScrollPosition = snappedItemBounds.right - viewportWidth;
         }
         else if(this.canScrollVertically)
         {
            viewportHeight = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
            lastItemIndex = layout.getElementNearestScrollPosition(new Point(0,this.viewport.contentHeight),"bottomRight");
            lastItemBounds = layout.getElementBounds(lastItemIndex);
            this.maxVerticalScrollPosition = lastItemBounds.bottom - viewportHeight;
            snappedItemIndex = layout.getElementNearestScrollPosition(new Point(0,viewportHeight),"bottomRight");
            do
            {
               snappedItemBounds = layout.getElementBounds(snappedItemIndex);
               if(snappedItemBounds.bottom <= viewportHeight)
               {
                  break;
               }
            }
            while(--snappedItemIndex >= 0);
            this.minVerticalScrollPosition = snappedItemBounds.bottom - viewportHeight;
         }
      }
      
      private function determineScrollRanges() : void
      {
         var viewportHeight:Number = NaN;
         var viewportWidth:Number = NaN;
         var remaining:Number = NaN;
         var layout:LayoutBase = null;
         this.minVerticalScrollPosition = this.maxVerticalScrollPosition = 0;
         this.minHorizontalScrollPosition = this.maxHorizontalScrollPosition = 0;
         if(Boolean(this.viewport))
         {
            viewportHeight = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
            viewportWidth = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
            if(!this.bounceEnabled && !this.pullEnabled)
            {
               this.minVerticalScrollPosition = this.minHorizontalScrollPosition = -Number.MAX_VALUE;
               this.maxVerticalScrollPosition = this.maxHorizontalScrollPosition = Number.MAX_VALUE;
            }
            else if(this.scrollSnappingMode == ScrollSnappingMode.NONE)
            {
               this.maxVerticalScrollPosition = this.viewport.contentHeight > viewportHeight ? this.viewport.contentHeight - viewportHeight : 0;
               if(this.pageScrollingEnabled && this.canScrollVertically && viewportHeight != 0)
               {
                  remaining = this.viewport.contentHeight % viewportHeight;
                  if(Boolean(remaining))
                  {
                     this.maxVerticalScrollPosition += viewportHeight - remaining;
                  }
               }
               this.maxHorizontalScrollPosition = this.viewport.contentWidth > viewportWidth ? this.viewport.contentWidth - viewportWidth : 0;
               if(this.pageScrollingEnabled && this.canScrollHorizontally && viewportWidth != 0)
               {
                  remaining = this.viewport.contentWidth % viewportWidth;
                  if(Boolean(remaining))
                  {
                     this.maxHorizontalScrollPosition += viewportWidth - remaining;
                  }
               }
            }
            else
            {
               layout = this.viewportLayout;
               if(!layout || layout.target.numElements == 0)
               {
                  return;
               }
               if(this.canScrollHorizontally && viewportWidth == 0 || this.canScrollVertically && viewportHeight == 0)
               {
                  return;
               }
               switch(this.scrollSnappingMode)
               {
                  case ScrollSnappingMode.LEADING_EDGE:
                     this.determineLeadingEdgeSnappingScrollRanges();
                     break;
                  case ScrollSnappingMode.CENTER:
                     this.determineCenterSnappingScrollRanges();
                     break;
                  case ScrollSnappingMode.TRAILING_EDGE:
                     this.determineTrailingEdgeSnappingScrollRanges();
               }
            }
         }
         if(Boolean(this.verticalScrollBar))
         {
            this.verticalScrollBar.contentMinimum = this.minVerticalScrollPosition;
            this.verticalScrollBar.contentMaximum = this.maxVerticalScrollPosition;
         }
         if(Boolean(this.horizontalScrollBar))
         {
            this.horizontalScrollBar.contentMinimum = this.minHorizontalScrollPosition;
            this.horizontalScrollBar.contentMaximum = this.maxHorizontalScrollPosition;
         }
      }
      
      private function determineCurrentPageScrollPosition() : void
      {
         if(this.canScrollHorizontally)
         {
            this.viewport.horizontalScrollPosition = this.getSnappedPosition(this.viewport.horizontalScrollPosition,HORIZONTAL_SCROLL_POSITION);
            this.currentPageScrollPosition = this.viewport.horizontalScrollPosition;
         }
         else if(this.canScrollVertically)
         {
            this.viewport.verticalScrollPosition = this.getSnappedPosition(this.viewport.verticalScrollPosition,VERTICAL_SCROLL_POSITION);
            this.currentPageScrollPosition = this.viewport.verticalScrollPosition;
         }
      }
      
      private function handleSizeChangeOnUpdateComplete(event:FlexEvent) : void
      {
         this.viewport.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.handleSizeChangeOnUpdateComplete);
         this.handleSizeChange();
      }
      
      private function viewport_resizeHandler(event:Event) : void
      {
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            this.viewport.addEventListener(FlexEvent.UPDATE_COMPLETE,this.handleSizeChangeOnUpdateComplete);
         }
      }
      
      private function viewport_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         switch(event.property)
         {
            case "contentWidth":
            case "contentHeight":
               this.invalidateSkin();
               if(getStyle("interactionMode") == InteractionMode.TOUCH)
               {
                  this.viewport.addEventListener(FlexEvent.UPDATE_COMPLETE,this.handleSizeChangeOnUpdateComplete);
               }
               break;
            case VERTICAL_SCROLL_POSITION:
            case HORIZONTAL_SCROLL_POSITION:
               if(getStyle("interactionMode") == InteractionMode.TOUCH)
               {
                  if(!this.inTouchInteraction && (!this.snapElementAnimation || !this.snapElementAnimation.isPlaying))
                  {
                     if(!this.settingScrollPosition)
                     {
                        this.settingScrollPosition = true;
                        this.viewport[event.property] = this.getSnappedPosition(Number(event.newValue),String(event.property));
                        this.settingScrollPosition = false;
                     }
                     if(this.canScrollHorizontally && event.property == HORIZONTAL_SCROLL_POSITION)
                     {
                        this.currentPageScrollPosition = this.viewport.horizontalScrollPosition;
                     }
                     if(this.canScrollVertically && event.property == VERTICAL_SCROLL_POSITION)
                     {
                        this.currentPageScrollPosition = this.viewport.verticalScrollPosition;
                     }
                  }
                  else if(Boolean(this.throwEffect) && Boolean(this.throwEffect.isPlaying) && this.throwEffect.isSnapping)
                  {
                     if(Math.abs(this.viewport.horizontalScrollPosition - this.throwEffect.finalPosition.x) < 1 && Math.abs(this.viewport.verticalScrollPosition - this.throwEffect.finalPosition.y) < 1)
                     {
                        this.throwEffect.stop();
                        this.snapContentScrollPosition();
                     }
                  }
               }
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var elt:IVisualElement = null;
         super.focusInHandler(event);
         if(Boolean(this.viewport) && this.ensureElementIsVisibleForSoftKeyboard)
         {
            elt = focusManager.getFocus() as IVisualElement;
            this.lastFocusedElement = elt;
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         this.lastFocusedElement = null;
      }
      
      private function orientationChangingHandler(event:Event) : void
      {
         var viewportWidth:Number = NaN;
         var viewportHeight:Number = NaN;
         this.orientationChangeSnapElement = -1;
         if(this.scrollSnappingMode == ScrollSnappingMode.NONE && this.pageScrollingEnabled)
         {
            viewportWidth = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
            viewportHeight = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
            if(this.canScrollHorizontally && viewportWidth != 0)
            {
               this.orientationChangeSnapElement = this.currentPageScrollPosition / viewportWidth;
            }
            else if(this.canScrollVertically && viewportHeight != 0)
            {
               this.orientationChangeSnapElement = this.currentPageScrollPosition / viewportHeight;
            }
            this.previousOrientationPageCount = this.getCurrentPageCount();
         }
         else if(this.scrollSnappingMode != ScrollSnappingMode.NONE)
         {
            if(this.canScrollHorizontally)
            {
               this.getSnappedPosition(this.viewport.horizontalScrollPosition,HORIZONTAL_SCROLL_POSITION);
            }
            else if(this.canScrollVertically)
            {
               this.getSnappedPosition(this.viewport.verticalScrollPosition,VERTICAL_SCROLL_POSITION);
            }
            this.orientationChangeSnapElement = this.lastSnappedElement;
         }
         if(Boolean(this.viewportLayout))
         {
            this.viewportLayout.clearVirtualLayoutCache();
         }
      }
      
      public function get numElements() : int
      {
         return Boolean(this.viewport) ? 1 : 0;
      }
      
      public function getElementAt(index:int) : IVisualElement
      {
         if(Boolean(this.viewport) && index == 0)
         {
            return this.viewport;
         }
         throw new RangeError(resourceManager.getString("components","indexOutOfRange",[index]));
      }
      
      public function getElementIndex(element:IVisualElement) : int
      {
         if(element != null && element == this.viewport)
         {
            return 0;
         }
         throw ArgumentError(resourceManager.getString("components","elementNotFoundInScroller",[element]));
      }
      
      public function addElement(element:IVisualElement) : IVisualElement
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      public function addElementAt(element:IVisualElement, index:int) : IVisualElement
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      public function removeElement(element:IVisualElement) : IVisualElement
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      public function removeElementAt(index:int) : IVisualElement
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      public function removeAllElements() : void
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      public function setElementIndex(element:IVisualElement, index:int) : void
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      public function swapElements(element1:IVisualElement, element2:IVisualElement) : void
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      public function swapElementsAt(index1:int, index2:int) : void
      {
         throw new ArgumentError(resourceManager.getString("components","operationNotSupported"));
      }
      
      private function invalidateSkin() : void
      {
         if(Boolean(skin))
         {
            skin.invalidateSize();
            skin.invalidateDisplayList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get scrollerLayout() : ScrollerLayout
      {
         if(Boolean(skin))
         {
            return Group(skin).layout as ScrollerLayout;
         }
         return null;
      }
      
      private function get canScrollHorizontally() : Boolean
      {
         var layout:ScrollerLayout = this.scrollerLayout;
         if(Boolean(layout))
         {
            return layout.canScrollHorizontally;
         }
         return false;
      }
      
      private function get canScrollVertically() : Boolean
      {
         var layout:ScrollerLayout = this.scrollerLayout;
         if(Boolean(layout))
         {
            return layout.canScrollVertically;
         }
         return false;
      }
      
      private function get viewportLayout() : LayoutBase
      {
         if(this.viewport is GroupBase)
         {
            return GroupBase(this.viewport).layout;
         }
         if(this.viewport is SkinnableContainer)
         {
            return SkinnableContainer(this.viewport).layout;
         }
         return null;
      }
      
      private function installTouchListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,this.touchInteractionStartingHandler);
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END,this.touchInteractionEndHandler);
         addEventListener(MouseEvent.CLICK,this.touchScrolling_captureMouseHandler,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.touchScrolling_captureMouseHandler,true);
      }
      
      private function uninstallTouchListeners() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,this.touchInteractionStartingHandler);
         removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
         removeEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END,this.touchInteractionEndHandler);
         removeEventListener(MouseEvent.CLICK,this.touchScrolling_captureMouseHandler,true);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.touchScrolling_captureMouseHandler,true);
      }
      
      private function determineNewPageScrollPosition(velocityX:Number, velocityY:Number) : void
      {
         var minVelocityPixels:Number = this.pageThrowVelocityThreshold * Capabilities.screenDPI / 1000;
         if(this.canScrollHorizontally)
         {
            if(velocityX < -minVelocityPixels || this.viewport.horizontalScrollPosition >= this.currentPageScrollPosition + this.viewport.width * this.pageDragDistanceThreshold)
            {
               this.currentPageScrollPosition = Math.min(this.currentPageScrollPosition + this.viewport.width,this.maxHorizontalScrollPosition);
            }
            else if(velocityX > minVelocityPixels || this.viewport.horizontalScrollPosition <= this.currentPageScrollPosition - this.viewport.width * this.pageDragDistanceThreshold)
            {
               this.currentPageScrollPosition = Math.max(this.currentPageScrollPosition - this.viewport.width,this.minHorizontalScrollPosition);
            }
            this.currentPageScrollPosition = this.getSnappedPosition(this.currentPageScrollPosition,HORIZONTAL_SCROLL_POSITION);
         }
         else if(this.canScrollVertically)
         {
            if(velocityY < -minVelocityPixels || this.viewport.verticalScrollPosition >= this.currentPageScrollPosition + this.viewport.height * this.pageDragDistanceThreshold)
            {
               this.currentPageScrollPosition = Math.min(this.currentPageScrollPosition + this.viewport.height,this.maxVerticalScrollPosition);
            }
            else if(velocityY > minVelocityPixels || this.viewport.verticalScrollPosition <= this.currentPageScrollPosition - this.viewport.height * this.pageDragDistanceThreshold)
            {
               this.currentPageScrollPosition = Math.max(this.currentPageScrollPosition - this.viewport.height,this.minVerticalScrollPosition);
            }
            this.currentPageScrollPosition = this.getSnappedPosition(this.currentPageScrollPosition,VERTICAL_SCROLL_POSITION);
         }
      }
      
      private function setUpThrowEffect(velocityX:Number, velocityY:Number) : Boolean
      {
         var PAGING_VELOCITY_FACTOR:Number = NaN;
         if(!this.throwEffect)
         {
            this.throwEffect = new ThrowEffect();
            this.throwEffect.target = this.viewport;
            this.throwEffect.addEventListener(EffectEvent.EFFECT_END,this.throwEffect_effectEndHandler);
         }
         var minHSP:Number = this.minHorizontalScrollPosition;
         var minVSP:Number = this.minVerticalScrollPosition;
         var maxHSP:Number = this.maxHorizontalScrollPosition;
         var maxVSP:Number = this.maxVerticalScrollPosition;
         if(this.pageScrollingEnabled)
         {
            this.determineNewPageScrollPosition(velocityX,velocityY);
            PAGING_VELOCITY_FACTOR = 0.25;
            velocityX *= PAGING_VELOCITY_FACTOR;
            velocityY *= PAGING_VELOCITY_FACTOR;
            if(this.canScrollHorizontally)
            {
               minHSP = maxHSP = this.currentPageScrollPosition;
            }
            else if(this.canScrollVertically)
            {
               minVSP = maxVSP = this.currentPageScrollPosition;
            }
         }
         this.throwEffect.propertyNameX = this.canScrollHorizontally ? HORIZONTAL_SCROLL_POSITION : null;
         this.throwEffect.propertyNameY = this.canScrollVertically ? VERTICAL_SCROLL_POSITION : null;
         this.throwEffect.startingVelocityX = velocityX;
         this.throwEffect.startingVelocityY = velocityY;
         this.throwEffect.startingPositionX = this.viewport.horizontalScrollPosition;
         this.throwEffect.startingPositionY = this.viewport.verticalScrollPosition;
         this.throwEffect.minPositionX = minHSP;
         this.throwEffect.minPositionY = minVSP;
         this.throwEffect.maxPositionX = maxHSP;
         this.throwEffect.maxPositionY = maxVSP;
         this.throwEffect.decelerationFactor = this.throwEffectDecelFactor;
         this.throwEffect.finalPositionFilterFunction = this.scrollSnappingMode == ScrollSnappingMode.NONE ? null : this.getSnappedPosition;
         this.throwReachedMaximumScrollPosition = false;
         if(this.throwEffect.setup())
         {
            this.throwFinalHSP = this.throwEffect.finalPosition.x;
            if(this.canScrollHorizontally && this.bounceEnabled && this.throwFinalHSP == this.maxHorizontalScrollPosition)
            {
               this.throwReachedMaximumScrollPosition = true;
            }
            this.throwFinalVSP = this.throwEffect.finalPosition.y;
            if(this.canScrollVertically && this.bounceEnabled && this.throwFinalVSP == this.maxVerticalScrollPosition)
            {
               this.throwReachedMaximumScrollPosition = true;
            }
            return true;
         }
         this.touchScrollHelper.endTouchScroll();
         return false;
      }
      
      private function getSnappedPosition(position:Number, propertyName:String) : Number
      {
         var nearestElementBounds:Rectangle = null;
         var offset:Number = NaN;
         var layout:LayoutBase = this.viewportLayout;
         var nearestElementIndex:int = -1;
         var viewportWidth:Number = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
         var viewportHeight:Number = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
         if(this.scrollSnappingMode == ScrollSnappingMode.NONE && this.pageScrollingEnabled)
         {
            if(this.canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION && viewportWidth != 0 && this.viewport.contentWidth != 0)
            {
               offset = position % viewportWidth;
               if(offset < viewportWidth / 2)
               {
                  position -= offset;
               }
               else
               {
                  position += viewportWidth - offset;
               }
               position = Math.min(Math.max(this.minHorizontalScrollPosition,position),this.maxHorizontalScrollPosition);
            }
            else if(this.canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION && viewportHeight != 0 && this.viewport.contentHeight != 0)
            {
               offset = position % viewportHeight;
               if(offset < viewportHeight / 2)
               {
                  position -= offset;
               }
               else
               {
                  position += viewportHeight - offset;
               }
               position = Math.min(Math.max(this.minVerticalScrollPosition,position),this.maxVerticalScrollPosition);
            }
         }
         if(Boolean(layout) && layout.target.numElements > 0)
         {
            switch(this._scrollSnappingMode)
            {
               case ScrollSnappingMode.LEADING_EDGE:
                  if(this.canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION)
                  {
                     nearestElementIndex = layout.getElementNearestScrollPosition(new Point(position,0),"topLeft");
                     nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                     position = nearestElementBounds.left;
                  }
                  else if(this.canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION)
                  {
                     nearestElementIndex = layout.getElementNearestScrollPosition(new Point(0,position),"topLeft");
                     nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                     position = nearestElementBounds.top;
                  }
                  break;
               case ScrollSnappingMode.CENTER:
                  if(this.canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION)
                  {
                     nearestElementIndex = layout.getElementNearestScrollPosition(new Point(position + viewportWidth / 2,0),"center");
                     nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                     position = nearestElementBounds.left + nearestElementBounds.width / 2 - viewportWidth / 2;
                  }
                  else if(this.canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION)
                  {
                     nearestElementIndex = layout.getElementNearestScrollPosition(new Point(0,position + viewportHeight / 2),"center");
                     nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                     position = nearestElementBounds.top + nearestElementBounds.height / 2 - viewportHeight / 2;
                  }
                  break;
               case ScrollSnappingMode.TRAILING_EDGE:
                  if(this.canScrollHorizontally && propertyName == HORIZONTAL_SCROLL_POSITION)
                  {
                     nearestElementIndex = layout.getElementNearestScrollPosition(new Point(position + viewportWidth,0),"bottomRight");
                     nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                     position = nearestElementBounds.right - viewportWidth;
                  }
                  else if(this.canScrollVertically && propertyName == VERTICAL_SCROLL_POSITION)
                  {
                     nearestElementIndex = layout.getElementNearestScrollPosition(new Point(0,position + viewportHeight),"bottomRight");
                     nearestElementBounds = layout.getElementBounds(nearestElementIndex);
                     position = nearestElementBounds.bottom - viewportHeight;
                  }
            }
         }
         this.lastSnappedElement = nearestElementIndex;
         return Math.round(position);
      }
      
      private function hideScrollBars() : void
      {
         var alphaMP:Vector.<MotionPath> = null;
         if(!this.hideScrollBarAnimation)
         {
            this.hideScrollBarAnimation = new Animate();
            this.hideScrollBarAnimation.addEventListener(EffectEvent.EFFECT_END,this.hideScrollBarAnimation_effectEndHandler);
            this.hideScrollBarAnimation.duration = 500;
            alphaMP = Vector.<MotionPath>([new SimpleMotionPath("alpha",1,0)]);
            this.hideScrollBarAnimation.motionPaths = alphaMP;
         }
         var targets:Array = [];
         if(Boolean(this.horizontalScrollBar) && Boolean(this.horizontalScrollBar.visible))
         {
            targets.push(this.horizontalScrollBar);
         }
         if(Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible))
         {
            targets.push(this.verticalScrollBar);
         }
         this.hideScrollBarAnimationPrematurelyStopped = false;
         this.hideScrollBarAnimation.play(targets);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Application.softKeyboardBehavior == "none")
         {
            addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.softKeyboardActivateHandler,false,EventPriority.DEFAULT,true);
            addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.softKeyboardActivateCaptureHandler,true,EventPriority.DEFAULT,true);
            addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.softKeyboardDeactivateHandler,false,EventPriority.DEFAULT,true);
            addEventListener(CaretBoundsChangeEvent.CARET_BOUNDS_CHANGE,this.caretBoundsChangeHandler);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var liveScrolling:* = undefined;
         super.styleChanged(styleProp);
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         if(allStyles || styleProp == "horizontalScrollPolicy" || styleProp == "verticalScrollPolicy")
         {
            this.invalidateSkin();
         }
         if(allStyles || styleProp == "interactionMode")
         {
            if(getStyle("interactionMode") == InteractionMode.TOUCH)
            {
               this.installTouchListeners();
               this.scrollRangesChanged = true;
               invalidateProperties();
               if(!this.touchScrollHelper)
               {
                  this.touchScrollHelper = new TouchScrollHelper();
                  this.touchScrollHelper.target = this;
                  this.touchScrollHelper.dragFunction = this.performDrag;
                  this.touchScrollHelper.throwFunction = this.performThrow;
               }
               if(Boolean(this.horizontalScrollBar))
               {
                  this.horizontalScrollBar.mouseEnabled = false;
                  this.horizontalScrollBar.mouseChildren = false;
               }
               if(Boolean(this.verticalScrollBar))
               {
                  this.verticalScrollBar.mouseEnabled = false;
                  this.verticalScrollBar.mouseChildren = false;
               }
            }
            else
            {
               this.ensureDeferredHScrollBarCreated();
               this.ensureDeferredHScrollBarCreated();
               this.uninstallTouchListeners();
               if(Boolean(this.horizontalScrollBar))
               {
                  this.horizontalScrollBar.mouseEnabled = true;
                  this.horizontalScrollBar.mouseChildren = true;
               }
               if(Boolean(this.verticalScrollBar))
               {
                  this.verticalScrollBar.mouseEnabled = true;
                  this.verticalScrollBar.mouseChildren = true;
               }
            }
         }
         if(allStyles || styleProp == "liveScrolling")
         {
            liveScrolling = getStyle("liveScrolling");
            if(liveScrolling === true || liveScrolling === false)
            {
               if(Boolean(this.verticalScrollBar))
               {
                  this.verticalScrollBar.setStyle("liveDragging",Boolean(liveScrolling));
               }
               if(Boolean(this.horizontalScrollBar))
               {
                  this.horizontalScrollBar.setStyle("liveDragging",Boolean(liveScrolling));
               }
            }
         }
      }
      
      override protected function attachSkin() : void
      {
         super.attachSkin();
         if(getStyle("interactionMode") != InteractionMode.TOUCH)
         {
            this.ensureDeferredHScrollBarCreated();
            this.ensureDeferredVScrollBarCreated();
         }
         Group(skin).layout = new ScrollerLayout();
         this.installViewport();
         skin.addEventListener(MouseEvent.MOUSE_WHEEL,this.skin_mouseWheelHandler);
      }
      
      override protected function detachSkin() : void
      {
         this.uninstallViewport();
         Group(skin).layout = null;
         skin.removeEventListener(MouseEvent.MOUSE_WHEEL,this.skin_mouseWheelHandler);
         super.detachSkin();
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var liveScrolling:* = undefined;
         super.partAdded(partName,instance);
         liveScrolling = getStyle("liveScrolling");
         var liveScrollingSet:Boolean = liveScrolling === true || liveScrolling === false;
         var inTouchMode:Boolean = getStyle("interactionMode") == InteractionMode.TOUCH;
         if(instance == this.verticalScrollBar)
         {
            this.verticalScrollBar.viewport = this.viewport;
            if(liveScrollingSet)
            {
               this.verticalScrollBar.setStyle("liveDragging",Boolean(liveScrolling));
            }
            this.verticalScrollBar.contentMinimum = this.minVerticalScrollPosition;
            this.verticalScrollBar.contentMaximum = this.maxVerticalScrollPosition;
            if(inTouchMode)
            {
               this.verticalScrollBar.mouseEnabled = false;
               this.verticalScrollBar.mouseChildren = false;
            }
         }
         else if(instance == this.horizontalScrollBar)
         {
            this.horizontalScrollBar.viewport = this.viewport;
            if(liveScrollingSet)
            {
               this.horizontalScrollBar.setStyle("liveDragging",Boolean(liveScrolling));
            }
            this.horizontalScrollBar.contentMinimum = this.minHorizontalScrollPosition;
            this.horizontalScrollBar.contentMaximum = this.maxHorizontalScrollPosition;
            if(inTouchMode)
            {
               this.horizontalScrollBar.mouseEnabled = false;
               this.horizontalScrollBar.mouseChildren = false;
            }
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.verticalScrollBar)
         {
            this.verticalScrollBar.viewport = null;
         }
         else if(instance == this.horizontalScrollBar)
         {
            this.horizontalScrollBar.viewport = null;
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.scrollRangesChanged)
         {
            this.determineScrollRanges();
            this.scrollRangesChanged = false;
         }
         if(this.pageScrollingChanged)
         {
            this.stopAnimations();
            this.determineCurrentPageScrollPosition();
            this.pageScrollingChanged = false;
         }
         if(this.snappingModeChanged)
         {
            this.stopAnimations();
            this.snapContentScrollPosition();
            this.snappingModeChanged = false;
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var vspDelta:Number = NaN;
         var hspDelta:Number = NaN;
         super.keyDownHandler(event);
         var vp:IViewport = this.viewport;
         if(!vp || event.isDefaultPrevented())
         {
            return;
         }
         if(getFocus() is TextField)
         {
            return;
         }
         if(Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible))
         {
            vspDelta = NaN;
            switch(event.keyCode)
            {
               case Keyboard.UP:
                  vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.UP);
                  break;
               case Keyboard.DOWN:
                  vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.DOWN);
                  break;
               case Keyboard.PAGE_UP:
                  vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.PAGE_UP);
                  break;
               case Keyboard.PAGE_DOWN:
                  vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.PAGE_DOWN);
                  break;
               case Keyboard.HOME:
                  vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.HOME);
                  break;
               case Keyboard.END:
                  vspDelta = vp.getVerticalScrollPositionDelta(NavigationUnit.END);
            }
            if(!isNaN(vspDelta))
            {
               vp.verticalScrollPosition += vspDelta;
               event.preventDefault();
            }
         }
         if(Boolean(this.horizontalScrollBar) && Boolean(this.horizontalScrollBar.visible))
         {
            hspDelta = NaN;
            switch(event.keyCode)
            {
               case Keyboard.LEFT:
                  hspDelta = layoutDirection == LayoutDirection.LTR ? vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT) : vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT);
                  break;
               case Keyboard.RIGHT:
                  hspDelta = layoutDirection == LayoutDirection.LTR ? vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT) : vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT);
                  break;
               case Keyboard.HOME:
                  hspDelta = vp.getHorizontalScrollPositionDelta(NavigationUnit.HOME);
                  break;
               case Keyboard.END:
                  hspDelta = vp.getHorizontalScrollPositionDelta(NavigationUnit.END);
                  break;
               case Keyboard.PAGE_UP:
                  if(!this.verticalScrollBar || !this.verticalScrollBar.visible)
                  {
                     hspDelta = Boolean(LayoutDirection.LTR) ? vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT) : vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT);
                  }
                  break;
               case Keyboard.PAGE_DOWN:
                  if(!this.verticalScrollBar || !this.verticalScrollBar.visible)
                  {
                     hspDelta = Boolean(LayoutDirection.LTR) ? vp.getHorizontalScrollPositionDelta(NavigationUnit.RIGHT) : vp.getHorizontalScrollPositionDelta(NavigationUnit.LEFT);
                  }
            }
            if(!isNaN(hspDelta))
            {
               vp.horizontalScrollPosition += hspDelta;
               event.preventDefault();
            }
         }
      }
      
      private function skin_mouseWheelHandler(event:MouseEvent) : void
      {
         var navigationUnit:uint = 0;
         var vStep:int = 0;
         var vspDelta:Number = NaN;
         var hStep:int = 0;
         var hspDelta:Number = NaN;
         var vp:IViewport = this.viewport;
         if(event.isDefaultPrevented() || !vp || !vp.visible)
         {
            return;
         }
         var changingEvent:FlexMouseEvent = MouseEventUtil.createMouseWheelChangingEvent(event);
         if(!dispatchEvent(changingEvent))
         {
            event.preventDefault();
            return;
         }
         var delta:int = int(changingEvent.delta);
         var nSteps:uint = Math.abs(event.delta);
         if(Boolean(this.verticalScrollBar) && Boolean(this.verticalScrollBar.visible))
         {
            navigationUnit = delta < 0 ? NavigationUnit.DOWN : NavigationUnit.UP;
            for(vStep = 0; vStep < nSteps; vStep++)
            {
               vspDelta = vp.getVerticalScrollPositionDelta(navigationUnit);
               if(!isNaN(vspDelta))
               {
                  vp.verticalScrollPosition += vspDelta;
                  if(vp is IInvalidating)
                  {
                     IInvalidating(vp).validateNow();
                  }
               }
            }
            event.preventDefault();
         }
         else if(Boolean(this.horizontalScrollBar) && Boolean(this.horizontalScrollBar.visible))
         {
            navigationUnit = delta < 0 ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
            for(hStep = 0; hStep < nSteps; hStep++)
            {
               hspDelta = vp.getHorizontalScrollPositionDelta(navigationUnit);
               if(!isNaN(hspDelta))
               {
                  vp.horizontalScrollPosition += hspDelta;
                  if(vp is IInvalidating)
                  {
                     IInvalidating(vp).validateNow();
                  }
               }
            }
            event.preventDefault();
         }
      }
      
      private function touchInteractionStartingHandler(event:TouchInteractionEvent) : void
      {
         if(event.relatedObject != this && this.inTouchInteraction)
         {
            event.preventDefault();
         }
      }
      
      private function touchInteractionStartHandler(event:TouchInteractionEvent) : void
      {
         if(event.relatedObject != this)
         {
            this.touchScrollHelper.stopScrollWatch();
         }
         else
         {
            this.captureNextClick = true;
            this.captureNextMouseDown = true;
            this.preventThrows = false;
            this.hspBeforeTouchScroll = this.viewport.horizontalScrollPosition;
            this.vspBeforeTouchScroll = this.viewport.verticalScrollPosition;
            if(this.canScrollHorizontally)
            {
               this.horizontalScrollInProgress = true;
            }
            if(this.canScrollVertically)
            {
               this.verticalScrollInProgress = true;
            }
            skin.invalidateDisplayList();
            if(Boolean(this.hideScrollBarAnimation) && Boolean(this.hideScrollBarAnimation.isPlaying))
            {
               this.hideScrollBarAnimationPrematurelyStopped = true;
               this.hideScrollBarAnimation.stop();
            }
            if(Boolean(this.horizontalScrollBar))
            {
               this.horizontalScrollBar.alpha = this.maxHorizontalScrollPosition == 0 && this.minHorizontalScrollPosition == 0 ? 0 : 1;
            }
            if(Boolean(this.verticalScrollBar))
            {
               this.verticalScrollBar.alpha = this.maxVerticalScrollPosition == 0 && this.minVerticalScrollPosition == 0 ? 0 : 1;
            }
            this.inTouchInteraction = true;
         }
      }
      
      private function snapContentScrollPosition(snapHorizontal:Boolean = true, snapVertical:Boolean = true) : void
      {
         if(snapHorizontal && this.viewport.contentWidth != 0)
         {
            this.viewport.horizontalScrollPosition = this.getSnappedPosition(Math.min(Math.max(this.minHorizontalScrollPosition,this.viewport.horizontalScrollPosition),this.maxHorizontalScrollPosition),HORIZONTAL_SCROLL_POSITION);
         }
         if(snapVertical && this.viewport.contentHeight != 0)
         {
            this.viewport.verticalScrollPosition = this.getSnappedPosition(Math.min(Math.max(this.minVerticalScrollPosition,this.viewport.verticalScrollPosition),this.maxVerticalScrollPosition),VERTICAL_SCROLL_POSITION);
         }
      }
      
      private function stopThrowEffectOnMouseDown() : void
      {
         if(Boolean(this.throwEffect) && Boolean(this.throwEffect.isPlaying))
         {
            this.stoppedPreemptively = true;
            this.throwEffect.stop();
            this.snapContentScrollPosition();
            this.hspBeforeTouchScroll = this.viewport.horizontalScrollPosition;
            this.vspBeforeTouchScroll = this.viewport.verticalScrollPosition;
         }
      }
      
      private function touchScrolling_captureMouseHandler(event:MouseEvent) : void
      {
         var THRESHOLD_INCHES:Number = NaN;
         var captureThreshold:Number = NaN;
         switch(event.type)
         {
            case MouseEvent.MOUSE_DOWN:
               THRESHOLD_INCHES = 0.01984;
               captureThreshold = Math.round(THRESHOLD_INCHES * Capabilities.screenDPI);
               captureThreshold = Number(globalToLocal(new Point(captureThreshold,0)).subtract(globalToLocal(ZERO_POINT)).x);
               if(this.captureNextMouseDown && (Math.abs(this.viewport.verticalScrollPosition - this.throwFinalVSP) > captureThreshold || Math.abs(this.viewport.horizontalScrollPosition - this.throwFinalHSP) > captureThreshold))
               {
                  this.stopThrowEffectOnMouseDown();
                  this.touchScrollHelper.startScrollWatch(event,this.canScrollHorizontally,this.canScrollVertically,Math.round(this.minSlopInches * Capabilities.screenDPI),dragEventThinning ? MAX_DRAG_RATE : NaN);
                  event.stopImmediatePropagation();
               }
               else if(Boolean(this.throwEffect) && Boolean(this.throwEffect.isPlaying))
               {
                  this.throwEffect.stop();
                  this.snapContentScrollPosition();
               }
               break;
            case MouseEvent.CLICK:
               if(!this.captureNextClick)
               {
                  return;
               }
               event.stopImmediatePropagation();
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         this.stopThrowEffectOnMouseDown();
         if(Boolean(this.snapElementAnimation) && Boolean(this.snapElementAnimation.isPlaying))
         {
            this.snapElementAnimation.stop();
            if(this.pageScrollingEnabled)
            {
               this.determineCurrentPageScrollPosition();
            }
         }
         this.captureNextClick = false;
         this.touchScrollHelper.startScrollWatch(event,this.canScrollHorizontally,this.canScrollVertically,Math.round(this.minSlopInches * Capabilities.screenDPI),dragEventThinning ? MAX_DRAG_RATE : NaN);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function performDrag(dragX:Number, dragY:Number) : void
      {
         var viewportHeight:Number = NaN;
         if(this.textSelectionAutoScrollEnabled)
         {
            this.setUpTextSelectionAutoScroll();
            return;
         }
         var localDragDeltas:Point = globalToLocal(new Point(dragX,dragY)).subtract(globalToLocal(ZERO_POINT));
         dragX = localDragDeltas.x;
         dragY = localDragDeltas.y;
         var xMove:int = 0;
         var yMove:int = 0;
         if(this.canScrollHorizontally)
         {
            xMove = dragX;
         }
         if(this.canScrollVertically)
         {
            yMove = dragY;
         }
         var newHSP:Number = this.hspBeforeTouchScroll - xMove;
         var newVSP:Number = this.vspBeforeTouchScroll - yMove;
         var viewportWidth:Number = isNaN(this.viewport.width) ? 0 : Number(this.viewport.width);
         if(this.pullEnabled)
         {
            if(newHSP < this.minHorizontalScrollPosition)
            {
               newHSP = Math.round(this.minHorizontalScrollPosition + (newHSP - this.minHorizontalScrollPosition) * PULL_TENSION_RATIO);
            }
            if(newHSP > this.maxHorizontalScrollPosition)
            {
               newHSP = Math.round(this.maxHorizontalScrollPosition + (newHSP - this.maxHorizontalScrollPosition) * PULL_TENSION_RATIO);
            }
            viewportHeight = isNaN(this.viewport.height) ? 0 : Number(this.viewport.height);
            if(newVSP < this.minVerticalScrollPosition)
            {
               newVSP = Math.round(this.minVerticalScrollPosition + (newVSP - this.minVerticalScrollPosition) * PULL_TENSION_RATIO);
            }
            if(newVSP > this.maxVerticalScrollPosition)
            {
               newVSP = Math.round(this.maxVerticalScrollPosition + (newVSP - this.maxVerticalScrollPosition) * PULL_TENSION_RATIO);
            }
            newHSP = Math.min(Math.max(newHSP,-viewportWidth),this.maxHorizontalScrollPosition + viewportWidth);
            newVSP = Math.min(Math.max(newVSP,-viewportHeight),this.maxVerticalScrollPosition + viewportHeight);
         }
         this.viewport.horizontalScrollPosition = newHSP;
         this.viewport.verticalScrollPosition = newVSP;
      }
      
      private function throwEffect_effectEndHandler(event:EffectEvent) : void
      {
         if(this.stoppedPreemptively)
         {
            return;
         }
         this.touchScrollHelper.endTouchScroll();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function performThrow(velocityX:Number, velocityY:Number) : void
      {
         if(this.textSelectionAutoScrollEnabled)
         {
            this.stopTextSelectionAutoScroll();
            this.touchScrollHelper.endTouchScroll();
            return;
         }
         if(this.preventThrows || !stage)
         {
            this.touchScrollHelper.endTouchScroll();
            return;
         }
         this.stoppedPreemptively = false;
         var throwVelocity:Point = new Point(velocityX,velocityY);
         throwVelocity.x *= 100000;
         throwVelocity.y *= 100000;
         throwVelocity = this.globalToLocal(throwVelocity).subtract(this.globalToLocal(new Point(0,0)));
         throwVelocity.x /= 100000;
         throwVelocity.y /= 100000;
         if(this.setUpThrowEffect(throwVelocity.x,throwVelocity.y))
         {
            this.throwEffect.play();
         }
      }
      
      private function touchInteractionEndHandler(event:TouchInteractionEvent) : void
      {
         if(event.relatedObject == this)
         {
            this.captureNextMouseDown = false;
            this.hideScrollBars();
            this.inTouchInteraction = false;
         }
      }
      
      private function hideScrollBarAnimation_effectEndHandler(event:EffectEvent) : void
      {
         if(this.hideScrollBarAnimationPrematurelyStopped)
         {
            return;
         }
         this.horizontalScrollInProgress = false;
         this.verticalScrollInProgress = false;
         skin.invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function enableTextSelectionAutoScroll(enable:Boolean, minHScrollPosition:int = 0, maxHScrollPosition:int = -1, minVScrollPosition:int = 0, maxVScrollPosition:int = -1) : void
      {
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            this.textSelectionAutoScrollEnabled = enable;
            this.minTextSelectionHScrollPos = minHScrollPosition;
            this.maxTextSelectionHScrollPos = maxHScrollPosition;
            this.minTextSelectionVScrollPos = minVScrollPosition;
            this.maxTextSelectionVScrollPos = maxVScrollPosition;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setUpTextSelectionAutoScroll() : void
      {
         if(!this.textSelectionAutoScrollTimer)
         {
            this.textSelectionAutoScrollTimer = new Timer(1000 / TEXT_SELECTION_AUTO_SCROLL_FPS);
            this.textSelectionAutoScrollTimer.addEventListener(TimerEvent.TIMER,this.textSelectionAutoScrollTimerHandler);
            this.textSelectionAutoScrollTimer.start();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function stopTextSelectionAutoScroll() : void
      {
         if(Boolean(this.textSelectionAutoScrollTimer))
         {
            this.textSelectionAutoScrollTimer.stop();
            this.textSelectionAutoScrollTimer.removeEventListener(TimerEvent.TIMER,this.textSelectionAutoScrollTimerHandler);
            this.textSelectionAutoScrollTimer = null;
         }
      }
      
      private function textSelectionAutoScrollTimerHandler(event:TimerEvent) : void
      {
         var SLOW_SCROLL_THRESHOLD:int = 12;
         var SLOW_SCROLL_SPEED:int = 20;
         var FAST_SCROLL_THRESHOLD:int = 3;
         var FAST_SCROLL_DELTA:int = 30;
         var newVSP:Number = this.viewport.verticalScrollPosition;
         var newHSP:Number = this.viewport.horizontalScrollPosition;
         if(this.canScrollHorizontally)
         {
            if(mouseX > width - SLOW_SCROLL_THRESHOLD)
            {
               newHSP += SLOW_SCROLL_SPEED;
               if(mouseX > width - FAST_SCROLL_THRESHOLD)
               {
                  newHSP += FAST_SCROLL_DELTA;
               }
               if(this.maxTextSelectionHScrollPos != -1 && newHSP > this.maxTextSelectionHScrollPos)
               {
                  newHSP = this.maxTextSelectionHScrollPos;
               }
            }
            if(mouseX < SLOW_SCROLL_THRESHOLD)
            {
               newHSP -= SLOW_SCROLL_SPEED;
               if(mouseX < FAST_SCROLL_THRESHOLD)
               {
                  newHSP -= FAST_SCROLL_DELTA;
               }
               if(newHSP < this.minTextSelectionHScrollPos)
               {
                  newHSP = this.minTextSelectionHScrollPos;
               }
            }
         }
         if(this.canScrollVertically)
         {
            if(mouseY > height - SLOW_SCROLL_THRESHOLD)
            {
               newVSP += SLOW_SCROLL_SPEED;
               if(mouseY > height - FAST_SCROLL_THRESHOLD)
               {
                  newVSP += FAST_SCROLL_DELTA;
               }
               if(this.maxTextSelectionVScrollPos != -1 && newVSP > this.maxTextSelectionVScrollPos)
               {
                  newVSP = this.maxTextSelectionVScrollPos;
               }
            }
            if(mouseY < SLOW_SCROLL_THRESHOLD)
            {
               newVSP -= SLOW_SCROLL_SPEED;
               if(mouseY < FAST_SCROLL_THRESHOLD)
               {
                  newVSP -= FAST_SCROLL_DELTA;
               }
               if(newVSP < this.minTextSelectionVScrollPos)
               {
                  newVSP = this.minTextSelectionVScrollPos;
               }
            }
         }
         if(newHSP != this.viewport.horizontalScrollPosition)
         {
            this.viewport.horizontalScrollPosition = newHSP;
         }
         if(newVSP != this.viewport.verticalScrollPosition)
         {
            this.viewport.verticalScrollPosition = newVSP;
         }
      }
      
      private function addedToStageHandler(event:Event) : void
      {
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            systemManager.stage.addEventListener("orientationChanging",this.orientationChangingHandler,true);
         }
      }
      
      private function removedFromStageHandler(event:Event) : void
      {
         if(getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            systemManager.stage.removeEventListener("orientationChanging",this.orientationChangingHandler,true);
         }
      }
      
      private function softKeyboardActivateHandler(event:SoftKeyboardEvent) : void
      {
         var isSoftKeyboardActive:Boolean = false;
         this.preventThrows = true;
         var keyboardRect:Rectangle = stage.softKeyboardRect;
         if(keyboardRect.width > 0 && keyboardRect.height > 0)
         {
            if(Boolean(this.lastFocusedElement) && Boolean(this.ensureElementIsVisibleForSoftKeyboard) && (keyboardRect.height != this.oldSoftKeyboardHeight || keyboardRect.width != this.oldSoftKeyboardWidth))
            {
               if(this.lastFocusedElementCaretBounds == null)
               {
                  this.ensureElementIsVisible(this.lastFocusedElement);
               }
               else
               {
                  isSoftKeyboardActive = this.oldSoftKeyboardHeight > 0 || this.oldSoftKeyboardWidth > 0;
                  this.ensureElementPositionIsVisible(this.lastFocusedElement,this.lastFocusedElementCaretBounds,!isSoftKeyboardActive);
                  this.lastFocusedElementCaretBounds = null;
               }
            }
            this.oldSoftKeyboardHeight = keyboardRect.height;
            this.oldSoftKeyboardWidth = keyboardRect.width;
         }
      }
      
      private function softKeyboardActivateCaptureHandler(event:SoftKeyboardEvent) : void
      {
         var keyboardRect:Rectangle = stage.softKeyboardRect;
         if(keyboardRect.width > 0 && keyboardRect.height > 0)
         {
            this.captureNextCaretBoundsChange = true;
         }
      }
      
      private function softKeyboardDeactivateHandler(event:SoftKeyboardEvent) : void
      {
         this.adjustScrollPositionAfterSoftKeyboardDeactivate();
         this.oldSoftKeyboardHeight = NaN;
         this.oldSoftKeyboardWidth = NaN;
         this.preventThrows = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function adjustScrollPositionAfterSoftKeyboardDeactivate() : void
      {
         if(Boolean(this.throwEffect) && Boolean(this.throwEffect.isPlaying))
         {
            this.throwEffect.stop();
         }
         this.snapContentScrollPosition();
      }
      
      private function caretBoundsChangeHandler(event:CaretBoundsChangeEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         event.preventDefault();
         if(this.captureNextCaretBoundsChange)
         {
            this.lastFocusedElementCaretBounds = event.newCaretBounds;
            this.captureNextCaretBoundsChange = false;
            return;
         }
         this.ensureElementPositionIsVisible(this.lastFocusedElement,event.newCaretBounds,false,false);
      }
      
      [Bindable(event="propertyChange")]
      [SkinPart(required="false")]
      public function get horizontalScrollBar() : HScrollBar
      {
         return this._42694078horizontalScrollBar;
      }
      
      public function set horizontalScrollBar(param1:HScrollBar) : void
      {
         var _loc2_:Object = this._42694078horizontalScrollBar;
         if(_loc2_ !== param1)
         {
            this._42694078horizontalScrollBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalScrollBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [SkinPart(required="false")]
      public function get verticalScrollBar() : VScrollBar
      {
         return this._1618627376verticalScrollBar;
      }
      
      public function set verticalScrollBar(param1:VScrollBar) : void
      {
         var _loc2_:Object = this._1618627376verticalScrollBar;
         if(_loc2_ !== param1)
         {
            this._1618627376verticalScrollBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalScrollBar",_loc2_,param1));
            }
         }
      }
   }
}

