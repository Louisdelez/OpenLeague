package spark.primitives.supportClasses
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   import flash.geom.Vector3D;
   import mx.core.AdvancedLayoutFeatures;
   import mx.core.DesignLayer;
   import mx.core.IInvalidating;
   import mx.core.ILayoutDirectionElement;
   import mx.core.ILayoutElement;
   import mx.core.IMXMLObject;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.BaseFilter;
   import mx.filters.IBitmapFilter;
   import mx.geom.Transform;
   import mx.geom.TransformOffsets;
   import mx.graphics.shaderClasses.ColorBurnShader;
   import mx.graphics.shaderClasses.ColorDodgeShader;
   import mx.graphics.shaderClasses.ColorShader;
   import mx.graphics.shaderClasses.ExclusionShader;
   import mx.graphics.shaderClasses.HueShader;
   import mx.graphics.shaderClasses.LuminosityShader;
   import mx.graphics.shaderClasses.SaturationShader;
   import mx.graphics.shaderClasses.SoftLightShader;
   import mx.managers.ILayoutManagerClient;
   import mx.utils.MatrixUtil;
   import spark.components.supportClasses.InvalidatingSprite;
   import spark.core.DisplayObjectSharingMode;
   import spark.core.IGraphicElement;
   import spark.core.IGraphicElementContainer;
   import spark.utils.FTETextUtil;
   import spark.utils.MaskUtil;
   
   public class GraphicElement extends EventDispatcher implements IGraphicElement, IInvalidating, ILayoutElement, IVisualElement, IMXMLObject
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const DEFAULT_MAX_WIDTH:Number = 10000;
      
      private static const DEFAULT_MAX_HEIGHT:Number = 10000;
      
      private static const DEFAULT_MIN_WIDTH:Number = 0;
      
      private static const DEFAULT_MIN_HEIGHT:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var _strokeExtents:Rectangle = new Rectangle();
      
      private var displayObjectChanged:Boolean;
      
      private var _colorTransform:ColorTransform;
      
      private var colorTransformChanged:Boolean;
      
      private var _drawnDisplayObject:InvalidatingSprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var invalidatePropertiesFlag:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var invalidateSizeFlag:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var invalidateDisplayListFlag:Boolean = false;
      
      protected var layoutFeatures:AdvancedLayoutFeatures;
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var _alpha:Number = 1;
      
      private var _effectiveAlpha:Number = 1;
      
      private var alphaChanged:Boolean = false;
      
      private var _alwaysCreateDisplayObject:Boolean;
      
      private var _baseline:Object;
      
      private var _blendMode:String = "auto";
      
      private var blendModeChanged:Boolean;
      
      private var blendShaderChanged:Boolean;
      
      private var blendModeExplicitlySet:Boolean = false;
      
      private var _bottom:Object;
      
      private var _owner:DisplayObjectContainer;
      
      private var _designLayer:DesignLayer;
      
      private var _parent:IGraphicElementContainer;
      
      private var _explicitHeight:Number;
      
      private var _explicitWidth:Number;
      
      private var _filters:Array = [];
      
      private var filtersChanged:Boolean;
      
      private var _clonedFilters:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _height:Number = 0;
      
      private var _horizontalCenter:Object;
      
      private var _id:String;
      
      private var _left:Object;
      
      private var _mask:DisplayObject;
      
      private var maskChanged:Boolean;
      
      private var _maskType:String = "clip";
      
      private var maskTypeChanged:Boolean;
      
      private var _luminosityInvert:Boolean = false;
      
      private var luminositySettingsChanged:Boolean;
      
      private var _luminosityClip:Boolean = false;
      
      private var _maxHeight:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _maxWidth:Number;
      
      private var _measuredHeight:Number = 0;
      
      private var _measuredWidth:Number = 0;
      
      private var _measuredX:Number = 0;
      
      private var _measuredY:Number = 0;
      
      private var _minHeight:Number;
      
      private var _minWidth:Number;
      
      private var _percentHeight:Number;
      
      private var _percentWidth:Number;
      
      private var _right:Object;
      
      private var _top:Object;
      
      private var _transform:flash.geom.Transform;
      
      private var _verticalCenter:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _width:Number = 0;
      
      private var _visible:Boolean = true;
      
      protected var _effectiveVisibility:Boolean = true;
      
      private var visibleChanged:Boolean;
      
      private var _displayObject:DisplayObject;
      
      private var _includeInLayout:Boolean = true;
      
      private var _displayObjectSharingMode:String;
      
      private var _layoutDirection:String = null;
      
      public function GraphicElement()
      {
         super();
      }
      
      public function get postLayoutTransformOffsets() : TransformOffsets
      {
         return this.layoutFeatures == null ? null : this.layoutFeatures.postLayoutTransformOffsets;
      }
      
      public function set postLayoutTransformOffsets(value:TransformOffsets) : void
      {
         if(value != null)
         {
            this.allocateLayoutFeatures();
         }
         if(this.layoutFeatures.postLayoutTransformOffsets != null)
         {
            this.layoutFeatures.postLayoutTransformOffsets.removeEventListener(Event.CHANGE,this.transformOffsetsChangedHandler);
         }
         this.layoutFeatures.postLayoutTransformOffsets = value;
         if(this.layoutFeatures.postLayoutTransformOffsets != null)
         {
            this.layoutFeatures.postLayoutTransformOffsets.addEventListener(Event.CHANGE,this.transformOffsetsChangedHandler);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function allocateLayoutFeatures() : void
      {
         if(this.layoutFeatures != null)
         {
            return;
         }
         this.layoutFeatures = new AdvancedLayoutFeatures();
         this.layoutFeatures.layoutX = this._x;
         this.layoutFeatures.layoutY = this._y;
         this.layoutFeatures.layoutWidth = this._width;
      }
      
      private function invalidateTransform(changeInvalidatesLayering:Boolean = true, invalidateLayout:Boolean = true) : void
      {
         if(changeInvalidatesLayering)
         {
            this.invalidateDisplayObjectSharing();
         }
         if(this.layoutFeatures != null)
         {
            this.layoutFeatures.updatePending = true;
         }
         if(this.displayObjectSharingMode != DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
         {
            this.invalidateDisplayList();
         }
         else
         {
            this.invalidateProperties();
         }
         if(invalidateLayout)
         {
            this.invalidateParentSizeAndDisplayList();
         }
      }
      
      private function transformOffsetsChangedHandler(e:Event) : void
      {
         this.invalidateTransform();
      }
      
      [Inspectable(category="General",minValue="0.0",maxValue="1.0")]
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(value:Number) : void
      {
         if(this._alpha == value)
         {
            return;
         }
         var previous:Boolean = this.needsDisplayObject;
         this._alpha = value;
         if(Boolean(this.designLayer))
         {
            value *= this.designLayer.effectiveAlpha;
         }
         if(this._blendMode == "auto")
         {
            if(value > 0 && value < 1 && (this._effectiveAlpha == 0 || this._effectiveAlpha == 1) || (value == 0 || value == 1) && (this._effectiveAlpha > 0 && this._effectiveAlpha < 1))
            {
               this.blendModeChanged = true;
            }
         }
         this._effectiveAlpha = value;
         var mxTransform:mx.geom.Transform = this._transform as mx.geom.Transform;
         if(Boolean(mxTransform))
         {
            mxTransform.applyColorTransformAlpha = false;
         }
         if(previous != this.needsDisplayObject)
         {
            this.invalidateDisplayObjectSharing();
         }
         this.alphaChanged = true;
         this.invalidateProperties();
      }
      
      public function get alwaysCreateDisplayObject() : Boolean
      {
         return this._alwaysCreateDisplayObject;
      }
      
      public function set alwaysCreateDisplayObject(value:Boolean) : void
      {
         var previous:Boolean = false;
         if(value != this._alwaysCreateDisplayObject)
         {
            previous = this.needsDisplayObject;
            this._alwaysCreateDisplayObject = value;
            if(previous != this.needsDisplayObject)
            {
               this.invalidateDisplayObjectSharing();
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get baseline() : Object
      {
         return this._baseline;
      }
      
      public function set baseline(value:Object) : void
      {
         if(this._baseline == value)
         {
            return;
         }
         this._baseline = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get baselinePosition() : Number
      {
         var parentUIC:UIComponent = this.parent as UIComponent;
         if(Boolean(parentUIC))
         {
            if(!parentUIC.validateBaselinePosition())
            {
               return NaN;
            }
            return FTETextUtil.calculateFontBaseline(parentUIC,this.height,parentUIC.moduleFactory);
         }
         return 0;
      }
      
      [Inspectable(category="General",enumeration="auto,add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity",defaultValue="auto")]
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(value:String) : void
      {
         if(value == this._blendMode)
         {
            return;
         }
         var oldValue:String = this._blendMode;
         this._blendMode = value;
         this.blendModeChanged = true;
         if(this.isAIMBlendMode(value))
         {
            this.blendShaderChanged = true;
         }
         if((oldValue == BlendMode.NORMAL || value == BlendMode.NORMAL) && !(oldValue == BlendMode.NORMAL && value == BlendMode.NORMAL))
         {
            this.invalidateDisplayObjectSharing();
         }
         this.invalidateProperties();
      }
      
      [Inspectable(category="General")]
      public function get bottom() : Object
      {
         return this._bottom;
      }
      
      public function set bottom(value:Object) : void
      {
         if(this._bottom == value)
         {
            return;
         }
         this._bottom = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get owner() : DisplayObjectContainer
      {
         return Boolean(this._owner) ? this._owner : this.parent;
      }
      
      public function set owner(value:DisplayObjectContainer) : void
      {
         this._owner = value;
      }
      
      [Inspectable(environment="none")]
      public function get designLayer() : DesignLayer
      {
         return this._designLayer;
      }
      
      public function set designLayer(value:DesignLayer) : void
      {
         if(Boolean(this._designLayer))
         {
            this._designLayer.removeEventListener("layerPropertyChange",this.layer_PropertyChange,false);
         }
         this._designLayer = value;
         if(Boolean(this._designLayer))
         {
            this._designLayer.addEventListener("layerPropertyChange",this.layer_PropertyChange,false,0,true);
         }
         this._effectiveAlpha = Boolean(this._designLayer) ? this._alpha * this._designLayer.effectiveAlpha : this._alpha;
         this._effectiveVisibility = Boolean(this._designLayer) ? this._visible && Boolean(this._designLayer.effectiveVisibility) : this._visible;
         this.alphaChanged = true;
         this.visibleChanged = true;
         this.invalidateProperties();
      }
      
      public function get parent() : DisplayObjectContainer
      {
         return this._parent as DisplayObjectContainer;
      }
      
      public function parentChanged(value:IGraphicElementContainer) : void
      {
         this._parent = value;
         this.invalidateLayoutDirection();
         if(Boolean(this.parent))
         {
            if(this.invalidatePropertiesFlag)
            {
               IGraphicElementContainer(this.parent).invalidateGraphicElementProperties(this);
            }
            if(this.invalidateSizeFlag)
            {
               IGraphicElementContainer(this.parent).invalidateGraphicElementSize(this);
            }
            if(this.invalidateDisplayListFlag)
            {
               IGraphicElementContainer(this.parent).invalidateGraphicElementDisplayList(this);
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      public function set explicitHeight(value:Number) : void
      {
         if(this._explicitHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this.percentHeight = NaN;
         }
         this._explicitHeight = value;
         this.invalidateSize();
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get explicitMaxHeight() : Number
      {
         return this.maxHeight;
      }
      
      public function set explicitMaxHeight(value:Number) : void
      {
         this.maxHeight = value;
      }
      
      public function get explicitMaxWidth() : Number
      {
         return this.maxWidth;
      }
      
      public function set explicitMaxWidth(value:Number) : void
      {
         this.maxWidth = value;
      }
      
      public function get explicitMinHeight() : Number
      {
         return this.minHeight;
      }
      
      public function set explicitMinHeight(value:Number) : void
      {
         this.minHeight = value;
      }
      
      public function get explicitMinWidth() : Number
      {
         return this.minWidth;
      }
      
      public function set explicitMinWidth(value:Number) : void
      {
         this.minWidth = value;
      }
      
      [Inspectable(category="General")]
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      public function set explicitWidth(value:Number) : void
      {
         if(this._explicitWidth == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this.percentWidth = NaN;
         }
         this._explicitWidth = value;
         this.invalidateSize();
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get filters() : Array
      {
         return this._filters.slice();
      }
      
      public function set filters(value:Array) : void
      {
         var edFilter:IEventDispatcher = null;
         var i:int = 0;
         var len:int = Boolean(this._filters) ? int(this._filters.length) : 0;
         var newLen:int = Boolean(value) ? int(value.length) : 0;
         if(len == 0 && newLen == 0)
         {
            return;
         }
         for(i = 0; i < len; i++)
         {
            edFilter = this._filters[i] as IEventDispatcher;
            if(Boolean(edFilter))
            {
               edFilter.removeEventListener(BaseFilter.CHANGE,this.filterChangedHandler);
            }
         }
         var previous:Boolean = this.needsDisplayObject;
         this._filters = value;
         if(previous != this.needsDisplayObject)
         {
            this.invalidateDisplayObjectSharing();
         }
         this._clonedFilters = [];
         for(i = 0; i < newLen; i++)
         {
            if(value[i] is IBitmapFilter)
            {
               edFilter = value[i] as IEventDispatcher;
               if(Boolean(edFilter))
               {
                  edFilter.addEventListener(BaseFilter.CHANGE,this.filterChangedHandler);
               }
               this._clonedFilters.push(IBitmapFilter(value[i]).clone());
            }
            else
            {
               this._clonedFilters.push(value[i]);
            }
         }
         this.filtersChanged = true;
         this.invalidateProperties();
      }
      
      [PercentProxy("percentHeight")]
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get height() : Number
      {
         return this._height;
      }
      
      public function set height(value:Number) : void
      {
         this.explicitHeight = value;
         if(this._height == value)
         {
            return;
         }
         var oldValue:Number = this._height;
         this._height = value;
         this.dispatchPropertyChangeEvent("height",oldValue,value);
         this.invalidateDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get horizontalCenter() : Object
      {
         return this._horizontalCenter;
      }
      
      public function set horizontalCenter(value:Object) : void
      {
         if(this._horizontalCenter == value)
         {
            return;
         }
         this._horizontalCenter = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
      }
      
      [Inspectable(category="General")]
      public function get left() : Object
      {
         return this._left;
      }
      
      public function set left(value:Object) : void
      {
         if(this._left == value)
         {
            return;
         }
         this._left = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get mask() : DisplayObject
      {
         return this._mask;
      }
      
      public function set mask(value:DisplayObject) : void
      {
         if(this._mask == value)
         {
            return;
         }
         var oldMask:UIComponent = this._mask as UIComponent;
         var previous:Boolean = this.needsDisplayObject;
         this._mask = value;
         if(Boolean(oldMask) && oldMask.$parent === this.displayObject)
         {
            if(oldMask.parent is UIComponent)
            {
               UIComponent(oldMask.parent).childRemoved(oldMask);
            }
            oldMask.$parent.removeChild(oldMask);
         }
         if(!this._mask || Boolean(this._mask.parent))
         {
            if(Boolean(this.drawnDisplayObject))
            {
               this.drawnDisplayObject.mask = null;
            }
            if(Boolean(this._drawnDisplayObject))
            {
               if(Boolean(this._drawnDisplayObject.parent))
               {
                  this._drawnDisplayObject.parent.removeChild(this._drawnDisplayObject);
               }
               this._drawnDisplayObject = null;
            }
         }
         this.maskChanged = true;
         this.maskTypeChanged = true;
         if(previous != this.needsDisplayObject)
         {
            this.invalidateDisplayObjectSharing();
         }
         this.invalidateProperties();
         this.invalidateDisplayList();
      }
      
      [Inspectable(category="General",enumeration="clip,alpha,luminosity",defaultValue="clip")]
      public function get maskType() : String
      {
         return this._maskType;
      }
      
      public function set maskType(value:String) : void
      {
         if(this._maskType == value)
         {
            return;
         }
         this._maskType = value;
         this.maskTypeChanged = true;
         this.invalidateProperties();
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
      public function get luminosityInvert() : Boolean
      {
         return this._luminosityInvert;
      }
      
      public function set luminosityInvert(value:Boolean) : void
      {
         if(this._luminosityInvert == value)
         {
            return;
         }
         this._luminosityInvert = value;
         this.luminositySettingsChanged = true;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
      public function get luminosityClip() : Boolean
      {
         return this._luminosityClip;
      }
      
      public function set luminosityClip(value:Boolean) : void
      {
         if(this._luminosityClip == value)
         {
            return;
         }
         this._luminosityClip = value;
         this.luminositySettingsChanged = true;
      }
      
      [Inspectable(category="General")]
      public function get maxHeight() : Number
      {
         return !isNaN(this._maxHeight) ? this._maxHeight : DEFAULT_MAX_HEIGHT;
      }
      
      public function set maxHeight(value:Number) : void
      {
         if(this._maxHeight == value)
         {
            return;
         }
         this._maxHeight = value;
         this.invalidateSize();
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get maxWidth() : Number
      {
         return !isNaN(this._maxWidth) ? this._maxWidth : DEFAULT_MAX_WIDTH;
      }
      
      public function set maxWidth(value:Number) : void
      {
         if(this._maxWidth == value)
         {
            return;
         }
         this._maxWidth = value;
         this.invalidateSize();
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get measuredHeight() : Number
      {
         return this._measuredHeight;
      }
      
      public function set measuredHeight(value:Number) : void
      {
         this._measuredHeight = value;
      }
      
      public function get measuredWidth() : Number
      {
         return this._measuredWidth;
      }
      
      public function set measuredWidth(value:Number) : void
      {
         this._measuredWidth = value;
      }
      
      public function get measuredX() : Number
      {
         return this._measuredX;
      }
      
      public function set measuredX(value:Number) : void
      {
         this._measuredX = value;
      }
      
      public function get measuredY() : Number
      {
         return this._measuredY;
      }
      
      public function set measuredY(value:Number) : void
      {
         this._measuredY = value;
      }
      
      [Inspectable(category="General")]
      public function get minHeight() : Number
      {
         return !isNaN(this._minHeight) ? this._minHeight : DEFAULT_MIN_HEIGHT;
      }
      
      public function set minHeight(value:Number) : void
      {
         if(this._minHeight == value)
         {
            return;
         }
         this._minHeight = value;
         this.invalidateSize();
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get minWidth() : Number
      {
         return !isNaN(this._minWidth) ? this._minWidth : DEFAULT_MIN_WIDTH;
      }
      
      public function set minWidth(value:Number) : void
      {
         if(this._minWidth == value)
         {
            return;
         }
         this._minWidth = value;
         this.invalidateSize();
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get percentHeight() : Number
      {
         return this._percentHeight;
      }
      
      public function set percentHeight(value:Number) : void
      {
         if(this._percentHeight == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this.explicitHeight = NaN;
         }
         this._percentHeight = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get percentWidth() : Number
      {
         return this._percentWidth;
      }
      
      public function set percentWidth(value:Number) : void
      {
         if(this._percentWidth == value)
         {
            return;
         }
         if(!isNaN(value))
         {
            this.explicitWidth = NaN;
         }
         this._percentWidth = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get right() : Object
      {
         return this._right;
      }
      
      public function set right(value:Object) : void
      {
         if(this._right == value)
         {
            return;
         }
         this._right = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get rotationX() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.layoutRotationX);
      }
      
      public function set rotationX(value:Number) : void
      {
         if(this.rotationX == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.layoutRotationX = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      [Inspectable(category="General")]
      public function get rotationY() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.layoutRotationY);
      }
      
      public function set rotationY(value:Number) : void
      {
         if(this.rotationY == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.layoutRotationY = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      [Inspectable(category="General")]
      public function get rotationZ() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.layoutRotationZ);
      }
      
      public function set rotationZ(value:Number) : void
      {
         if(this.rotationZ == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.layoutRotationZ = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      [Inspectable(category="General")]
      public function get rotation() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.layoutRotationZ);
      }
      
      public function set rotation(value:Number) : void
      {
         this.rotationZ = value;
      }
      
      [Inspectable(category="General")]
      public function get scaleX() : Number
      {
         return this.layoutFeatures == null ? 1 : Number(this.layoutFeatures.layoutScaleX);
      }
      
      public function set scaleX(value:Number) : void
      {
         if(this.scaleX == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.layoutScaleX = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      [Inspectable(category="General")]
      public function get scaleY() : Number
      {
         return this.layoutFeatures == null ? 1 : Number(this.layoutFeatures.layoutScaleY);
      }
      
      public function set scaleY(value:Number) : void
      {
         if(this.scaleY == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.layoutScaleY = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      [Inspectable(category="General")]
      public function get scaleZ() : Number
      {
         return this.layoutFeatures == null ? 1 : Number(this.layoutFeatures.layoutScaleZ);
      }
      
      public function set scaleZ(value:Number) : void
      {
         if(this.scaleZ == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.layoutScaleZ = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      [Inspectable(category="General")]
      public function get top() : Object
      {
         return this._top;
      }
      
      public function set top(value:Object) : void
      {
         if(this._top == value)
         {
            return;
         }
         this._top = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get transform() : flash.geom.Transform
      {
         if(!this._transform)
         {
            this.setTransform(new mx.geom.Transform());
         }
         return this._transform;
      }
      
      public function set transform(value:flash.geom.Transform) : void
      {
         var matrix:Matrix = Boolean(value) && Boolean(value.matrix) ? value.matrix.clone() : null;
         var matrix3D:Matrix3D = Boolean(value) && Boolean(value.matrix3D) ? value.matrix3D.clone() : null;
         var colorTransform:ColorTransform = Boolean(value) ? value.colorTransform : null;
         var mxTransform:mx.geom.Transform = value as mx.geom.Transform;
         if(Boolean(mxTransform))
         {
            if(!mxTransform.applyMatrix)
            {
               matrix = null;
            }
            if(!mxTransform.applyMatrix3D)
            {
               matrix3D = null;
            }
         }
         this.setTransform(value);
         var previous:Boolean = this.needsDisplayObject;
         if(Boolean(this._transform))
         {
            this.allocateLayoutFeatures();
            if(matrix != null)
            {
               this.layoutFeatures.layoutMatrix = matrix;
            }
            else if(matrix3D != null)
            {
               this.layoutFeatures.layoutMatrix3D = matrix3D;
            }
         }
         this.applyColorTransform(colorTransform,Boolean(mxTransform) && Boolean(mxTransform.applyColorTransformAlpha));
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      private function setTransform(value:flash.geom.Transform) : void
      {
         var oldTransform:mx.geom.Transform = this._transform as mx.geom.Transform;
         if(Boolean(oldTransform))
         {
            oldTransform.target = null;
         }
         var newTransform:mx.geom.Transform = value as mx.geom.Transform;
         if(Boolean(newTransform))
         {
            newTransform.target = this;
         }
         this._transform = value;
      }
      
      public function setColorTransform(value:ColorTransform) : void
      {
         this.applyColorTransform(value,true);
      }
      
      private function applyColorTransform(value:ColorTransform, updateAlpha:Boolean) : void
      {
         var previous:Boolean = false;
         if(this._colorTransform != value)
         {
            previous = this.needsDisplayObject;
            this._colorTransform = new ColorTransform(value.redMultiplier,value.greenMultiplier,value.blueMultiplier,value.alphaMultiplier,value.redOffset,value.greenOffset,value.blueOffset,value.alphaOffset);
            if(updateAlpha)
            {
               this._alpha = value.alphaMultiplier;
               this._effectiveAlpha = this._alpha;
            }
            if(Boolean(this.displayObject) && this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
            {
               this.displayObject.transform.colorTransform = this._colorTransform;
            }
            else
            {
               this.colorTransformChanged = true;
               this.invalidateProperties();
               if(previous != this.needsDisplayObject)
               {
                  this.invalidateDisplayObjectSharing();
               }
            }
         }
      }
      
      private function isAIMBlendMode(value:String) : Boolean
      {
         if(value == "colordodge" || value == "colorburn" || value == "exclusion" || value == "softlight" || value == "hue" || value == "saturation" || value == "color" || value == "luminosity")
         {
            return true;
         }
         return false;
      }
      
      public function transformAround(transformCenter:Vector3D, scale:Vector3D = null, rotation:Vector3D = null, translation:Vector3D = null, postLayoutScale:Vector3D = null, postLayoutRotation:Vector3D = null, postLayoutTranslation:Vector3D = null, invalidateLayout:Boolean = true) : void
      {
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         var prevX:Number = Number(this.layoutFeatures.layoutX);
         var prevY:Number = Number(this.layoutFeatures.layoutY);
         var prevZ:Number = Number(this.layoutFeatures.layoutZ);
         this.layoutFeatures.transformAround(transformCenter,scale,rotation,translation,postLayoutScale,postLayoutRotation,postLayoutTranslation);
         this.invalidateTransform(previous != this.needsDisplayObject,invalidateLayout);
         if(prevX != this.layoutFeatures.layoutX)
         {
            this.dispatchPropertyChangeEvent("x",prevX,this.layoutFeatures.layoutX);
         }
         if(prevY != this.layoutFeatures.layoutY)
         {
            this.dispatchPropertyChangeEvent("y",prevY,this.layoutFeatures.layoutY);
         }
         if(prevZ != this.layoutFeatures.layoutZ)
         {
            this.dispatchPropertyChangeEvent("z",prevZ,this.layoutFeatures.layoutZ);
         }
      }
      
      public function transformPointToParent(localPosition:Vector3D, position:Vector3D, postLayoutPosition:Vector3D) : void
      {
         var xformPt:Point = null;
         if(this.layoutFeatures != null)
         {
            this.layoutFeatures.transformPointToParent(true,localPosition,position,postLayoutPosition);
         }
         else
         {
            xformPt = new Point();
            if(Boolean(localPosition))
            {
               xformPt.x = localPosition.x;
               xformPt.y = localPosition.y;
            }
            if(position != null)
            {
               position.x = xformPt.x + this._x;
               position.y = xformPt.y + this._y;
               position.z = 0;
            }
            if(postLayoutPosition != null)
            {
               postLayoutPosition.x = xformPt.x + this._x;
               postLayoutPosition.y = xformPt.y + this._y;
               postLayoutPosition.z = 0;
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get transformX() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.transformX);
      }
      
      public function set transformX(value:Number) : void
      {
         if(this.transformX == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         this.layoutFeatures.transformX = value;
         this.invalidateTransform(false);
      }
      
      [Inspectable(category="General")]
      public function get transformY() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.transformY);
      }
      
      public function set transformY(value:Number) : void
      {
         if(this.transformY == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         this.layoutFeatures.transformY = value;
         this.invalidateTransform(false);
      }
      
      [Inspectable(category="General")]
      public function get transformZ() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.transformZ);
      }
      
      public function set transformZ(value:Number) : void
      {
         if(this.transformZ == value)
         {
            return;
         }
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.transformZ = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
      }
      
      [Inspectable(category="General")]
      public function get verticalCenter() : Object
      {
         return this._verticalCenter;
      }
      
      public function set verticalCenter(value:Object) : void
      {
         if(this._verticalCenter == value)
         {
            return;
         }
         this._verticalCenter = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      [PercentProxy("percentWidth")]
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(value:Number) : void
      {
         this.explicitWidth = value;
         if(this._width == value)
         {
            return;
         }
         var oldValue:Number = this._width;
         this._width = value;
         if(Boolean(this.layoutFeatures))
         {
            this.layoutFeatures.layoutWidth = value;
            this.invalidateTransform();
         }
         this.dispatchPropertyChangeEvent("width",oldValue,value);
         this.invalidateDisplayList();
      }
      
      public function get depth() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.depth);
      }
      
      public function set depth(value:Number) : void
      {
         if(value == this.depth)
         {
            return;
         }
         this.allocateLayoutFeatures();
         this.layoutFeatures.depth = value;
         if(this._parent is UIComponent)
         {
            UIComponent(this._parent).invalidateLayering();
         }
         this.invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get x() : Number
      {
         return this.layoutFeatures == null ? this._x : Number(this.layoutFeatures.layoutX);
      }
      
      public function set x(value:Number) : void
      {
         var oldValue:Number = this.x;
         if(oldValue == value)
         {
            return;
         }
         if(this.layoutFeatures != null)
         {
            this.layoutFeatures.layoutX = value;
         }
         else
         {
            this._x = value;
         }
         this.dispatchPropertyChangeEvent("x",oldValue,value);
         this.invalidateTransform(false);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get y() : Number
      {
         return this.layoutFeatures == null ? this._y : Number(this.layoutFeatures.layoutY);
      }
      
      public function set y(value:Number) : void
      {
         var oldValue:Number = this.y;
         if(oldValue == value)
         {
            return;
         }
         if(this.layoutFeatures != null)
         {
            this.layoutFeatures.layoutY = value;
         }
         else
         {
            this._y = value;
         }
         this.dispatchPropertyChangeEvent("y",oldValue,value);
         this.invalidateTransform(false);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get z() : Number
      {
         return this.layoutFeatures == null ? 0 : Number(this.layoutFeatures.layoutZ);
      }
      
      public function set z(value:Number) : void
      {
         if(this.z == value)
         {
            return;
         }
         var oldValue:Number = this.z;
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         this.layoutFeatures.layoutZ = value;
         this.invalidateTransform(previous != this.needsDisplayObject);
         this.dispatchPropertyChangeEvent("z",oldValue,value);
      }
      
      [Inspectable(category="General")]
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         this._visible = value;
         if(Boolean(this.designLayer) && !this.designLayer.effectiveVisibility)
         {
            value = false;
         }
         if(this._effectiveVisibility == value)
         {
            return;
         }
         this._effectiveVisibility = value;
         this.visibleChanged = true;
         this.invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get displayObject() : DisplayObject
      {
         return this._displayObject;
      }
      
      protected function setDisplayObject(value:DisplayObject) : void
      {
         if(this._displayObject == value)
         {
            return;
         }
         var oldValue:DisplayObject = this._displayObject;
         if(Boolean(oldValue) && this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
         {
            oldValue.transform.matrix3D = null;
         }
         this._displayObject = value;
         this.dispatchPropertyChangeEvent("displayObject",oldValue,value);
         this.displayObjectChanged = true;
         this.invalidateProperties();
      }
      
      protected function get drawX() : Number
      {
         if(this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
         {
            return 0;
         }
         if(this.layoutFeatures != null && this.layoutFeatures.postLayoutTransformOffsets != null)
         {
            return this.x + this.layoutFeatures.postLayoutTransformOffsets.x;
         }
         return this.x;
      }
      
      protected function get drawY() : Number
      {
         if(this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
         {
            return 0;
         }
         if(this.layoutFeatures != null && this.layoutFeatures.postLayoutTransformOffsets != null)
         {
            return this.y + this.layoutFeatures.postLayoutTransformOffsets.y;
         }
         return this.y;
      }
      
      protected function get hasComplexLayoutMatrix() : Boolean
      {
         return this.layoutFeatures == null ? false : !MatrixUtil.isDeltaIdentity(this.layoutFeatures.layoutMatrix);
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get includeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function set includeInLayout(value:Boolean) : void
      {
         if(this._includeInLayout == value)
         {
            return;
         }
         this._includeInLayout = true;
         this.invalidateParentSizeAndDisplayList();
         this._includeInLayout = value;
      }
      
      [Inspectable(category="General",enumeration="ownsUnsharedObject,ownsSharedObject,usesSharedObject")]
      public function set displayObjectSharingMode(value:String) : void
      {
         if(value == this._displayObjectSharingMode)
         {
            return;
         }
         if(value != DisplayObjectSharingMode.USES_SHARED_OBJECT || this._displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT)
         {
            this.displayObjectChanged = true;
            this.invalidateProperties();
         }
         this._displayObjectSharingMode = value;
      }
      
      public function get displayObjectSharingMode() : String
      {
         return this._displayObjectSharingMode;
      }
      
      [Inspectable(category="General",enumeration="ltr,rtl")]
      public function get layoutDirection() : String
      {
         if(this._layoutDirection != null)
         {
            return this._layoutDirection;
         }
         var parentElt:ILayoutDirectionElement = this.parent as ILayoutDirectionElement;
         return Boolean(parentElt) ? parentElt.layoutDirection : LayoutDirection.LTR;
      }
      
      public function set layoutDirection(value:String) : void
      {
         if(this._layoutDirection == value)
         {
            return;
         }
         this._layoutDirection = value;
         this.invalidateLayoutDirection();
      }
      
      public function invalidateLayoutDirection() : void
      {
         var previous:Boolean = false;
         var parentElt:ILayoutDirectionElement = this.parent as ILayoutDirectionElement;
         if(!parentElt)
         {
            return;
         }
         var mirror:Boolean = parentElt.layoutDirection != null && this._layoutDirection != null && this._layoutDirection != parentElt.layoutDirection;
         if(Boolean(this.layoutFeatures) ? mirror != this.layoutFeatures.mirror : mirror)
         {
            if(this.layoutFeatures == null)
            {
               this.allocateLayoutFeatures();
            }
            previous = this.needsDisplayObject;
            this.layoutFeatures.mirror = mirror;
            this.invalidateTransform(previous != this.needsDisplayObject);
         }
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
      }
      
      public function localToGlobal(point:Point) : Point
      {
         if(!this.displayObject || !this.displayObject.parent)
         {
            return new Point(this.x,this.y);
         }
         var returnVal:Point = this.displayObject.localToGlobal(point);
         if(!this.needsDisplayObject)
         {
            returnVal.x += this.drawX;
            returnVal.y += this.drawY;
         }
         return returnVal;
      }
      
      public function createDisplayObject() : DisplayObject
      {
         this.setDisplayObject(new InvalidatingSprite());
         return this.displayObject;
      }
      
      protected function get needsDisplayObject() : Boolean
      {
         var o:TransformOffsets = null;
         var result:Boolean = this.alwaysCreateDisplayObject || this._filters && this._filters.length > 0 || this._blendMode != BlendMode.NORMAL && this._blendMode != "auto" || this._mask || this.layoutFeatures != null && (this.layoutFeatures.layoutScaleX != 1 || this.layoutFeatures.layoutScaleY != 1 || this.layoutFeatures.layoutScaleZ != 1 || this.layoutFeatures.layoutRotationX != 0 || this.layoutFeatures.layoutRotationY != 0 || this.layoutFeatures.layoutRotationZ != 0 || this.layoutFeatures.layoutZ != 0 || this.layoutFeatures.mirror) || this._colorTransform != null || this._effectiveAlpha != 1;
         if(this.layoutFeatures != null && this.layoutFeatures.postLayoutTransformOffsets != null)
         {
            o = this.layoutFeatures.postLayoutTransformOffsets;
            result ||= o.scaleX != 1 || o.scaleY != 1 || o.scaleZ != 1 || o.rotationX != 0 || o.rotationY != 0 || o.rotationZ != 0 || o.z != 0;
         }
         return result;
      }
      
      public function setSharedDisplayObject(sharedDisplayObject:DisplayObject) : Boolean
      {
         if(!(sharedDisplayObject is Sprite) || this._alwaysCreateDisplayObject || this.needsDisplayObject)
         {
            return false;
         }
         this.setDisplayObject(sharedDisplayObject);
         return true;
      }
      
      public function canShareWithPrevious(element:IGraphicElement) : Boolean
      {
         return element is GraphicElement;
      }
      
      public function canShareWithNext(element:IGraphicElement) : Boolean
      {
         return element is GraphicElement && !this._alwaysCreateDisplayObject && !this.needsDisplayObject;
      }
      
      protected function get drawnDisplayObject() : DisplayObject
      {
         return Boolean(this._drawnDisplayObject) ? this._drawnDisplayObject : this.displayObject;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function captureBitmapData(transparent:Boolean = true, fillColor:uint = 4294967295, useLocalSpace:Boolean = true, clipRect:Rectangle = null) : BitmapData
      {
         var restoreDisplayObject:Boolean = false;
         var oldDisplayObject:DisplayObject = null;
         var topLevel:Sprite = null;
         var rectBounds:Rectangle = null;
         var bitmapData:BitmapData = null;
         var m:Matrix = null;
         if(!this.layoutFeatures || !this.layoutFeatures.is3D)
         {
            restoreDisplayObject = false;
            if(!this.displayObject || this.displayObjectSharingMode != DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
            {
               restoreDisplayObject = true;
               oldDisplayObject = this.displayObject;
               this.setDisplayObject(new InvalidatingSprite());
               if(this.parent is UIComponent)
               {
                  UIComponent(this.parent).$addChild(this.displayObject);
               }
               else
               {
                  this.parent.addChild(this.displayObject);
               }
               this.invalidateDisplayList();
               this.validateDisplayList();
            }
            topLevel = Sprite(IUIComponent(this.parent).systemManager.getSandboxRoot());
            rectBounds = useLocalSpace ? new Rectangle(this.getLayoutBoundsX(),this.getLayoutBoundsY(),this.getLayoutBoundsWidth(),this.getLayoutBoundsHeight()) : this.displayObject.getBounds(topLevel);
            if(rectBounds.width == 0 || rectBounds.height == 0)
            {
               return null;
            }
            bitmapData = new BitmapData(Math.ceil(rectBounds.width),Math.ceil(rectBounds.height),transparent,fillColor);
            m = useLocalSpace ? this.displayObject.transform.matrix : MatrixUtil.getConcatenatedMatrix(this.displayObject,null);
            if(Boolean(m))
            {
               m.translate(-rectBounds.x,-rectBounds.y);
            }
            bitmapData.draw(this.displayObject,m,null,null,clipRect);
            if(restoreDisplayObject)
            {
               if(this.parent is UIComponent)
               {
                  UIComponent(this.parent).$removeChild(this.displayObject);
               }
               else
               {
                  this.parent.removeChild(this.displayObject);
               }
               this.setDisplayObject(oldDisplayObject);
            }
            return bitmapData;
         }
         return this.get3DSnapshot(transparent,fillColor,useLocalSpace);
      }
      
      private function get3DSnapshot(transparent:Boolean = true, fillColor:uint = 4294967295, useLocalSpace:Boolean = true) : BitmapData
      {
         var topLevel:Sprite = Sprite(IUIComponent(this.parent).systemManager);
         var dispObjParent:DisplayObjectContainer = this.displayObject.parent;
         var drawSprite:Sprite = new Sprite();
         var topLevelRect:Rectangle = this.displayObject.getBounds(topLevel);
         var displayObjectRect:Rectangle = this.displayObject.getBounds(dispObjParent);
         var oldMat3D:Matrix3D = this.displayObject.transform.matrix3D.clone();
         var globalMat3D:Matrix3D = this.displayObject.transform.getRelativeMatrix3D(topLevel);
         var newMat3D:Matrix3D = oldMat3D.clone();
         var displayObjectIndex:int = this.parent.getChildIndex(this.displayObject);
         if(this.parent is UIComponent)
         {
            UIComponent(this.parent).$removeChild(this.displayObject);
         }
         else
         {
            this.parent.removeChild(this.displayObject);
         }
         topLevel.addChild(drawSprite);
         drawSprite.addChild(this.displayObject);
         if(useLocalSpace)
         {
            newMat3D.position = globalMat3D.position;
            this.displayObject.transform.matrix3D = newMat3D;
         }
         else
         {
            this.displayObject.transform.matrix3D = globalMat3D;
         }
         var m:Matrix = new Matrix();
         m.translate(-topLevelRect.left,-topLevelRect.top);
         var snapshot:BitmapData = new BitmapData(topLevelRect.width,topLevelRect.height,transparent,fillColor);
         snapshot.draw(drawSprite,m,null,null,null,true);
         drawSprite.removeChild(this.displayObject);
         topLevel.removeChild(drawSprite);
         if(this.parent is UIComponent)
         {
            UIComponent(this.parent).$addChildAt(this.displayObject,displayObjectIndex);
         }
         else
         {
            this.parent.addChildAt(this.displayObject,displayObjectIndex);
         }
         this.displayObject.transform.matrix3D = oldMat3D;
         return snapshot;
      }
      
      protected function layer_PropertyChange(event:PropertyChangeEvent) : void
      {
         var newValue:Boolean = false;
         var newAlpha:Number = NaN;
         var mxTransform:mx.geom.Transform = null;
         switch(event.property)
         {
            case "effectiveVisibility":
               newValue = Boolean(event.newValue) && this._visible;
               if(newValue != this._effectiveVisibility)
               {
                  this._effectiveVisibility = newValue;
                  this.visibleChanged = true;
                  this.invalidateProperties();
               }
               break;
            case "effectiveAlpha":
               newAlpha = Number(event.newValue) * this._alpha;
               if(newAlpha != this._effectiveAlpha)
               {
                  this._effectiveAlpha = newAlpha;
                  this.alphaChanged = true;
                  mxTransform = this._transform as mx.geom.Transform;
                  if(Boolean(mxTransform))
                  {
                     mxTransform.applyColorTransformAlpha = false;
                  }
                  this.invalidateDisplayObjectSharing();
                  this.invalidateProperties();
               }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchPropertyChangeEvent(prop:String, oldValue:*, value:*) : void
      {
         if(hasEventListener("propertyChange"))
         {
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,prop,oldValue,value));
         }
      }
      
      protected function invalidateDisplayObjectSharing() : void
      {
         if(Boolean(this.parent))
         {
            IGraphicElementContainer(this.parent).invalidateGraphicElementSharing(this);
         }
      }
      
      public function invalidateProperties() : void
      {
         if(this.invalidatePropertiesFlag)
         {
            return;
         }
         this.invalidatePropertiesFlag = true;
         if(Boolean(this.parent))
         {
            IGraphicElementContainer(this.parent).invalidateGraphicElementProperties(this);
         }
      }
      
      public function invalidateSize() : void
      {
         if(this.invalidateSizeFlag)
         {
            return;
         }
         this.invalidateSizeFlag = true;
         if(Boolean(this.parent))
         {
            IGraphicElementContainer(this.parent).invalidateGraphicElementSize(this);
         }
      }
      
      protected function invalidateParentSizeAndDisplayList() : void
      {
         if(!this.includeInLayout)
         {
            return;
         }
         if(Boolean(this.parent) && this.parent is IInvalidating)
         {
            IInvalidating(this.parent).invalidateSize();
            IInvalidating(this.parent).invalidateDisplayList();
         }
      }
      
      public function invalidateDisplayList() : void
      {
         if(this.invalidateDisplayListFlag)
         {
            return;
         }
         this.invalidateDisplayListFlag = true;
         if(Boolean(this.parent))
         {
            IGraphicElementContainer(this.parent).invalidateGraphicElementDisplayList(this);
         }
      }
      
      public function validateNow() : void
      {
         if(Boolean(this.parent))
         {
            UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(this.parent));
         }
      }
      
      public function validateProperties() : void
      {
         if(!this.invalidatePropertiesFlag)
         {
            return;
         }
         this.commitProperties();
         this.invalidatePropertiesFlag = false;
         if(!this.invalidatePropertiesFlag && !this.invalidateSizeFlag && !this.invalidateDisplayListFlag)
         {
            this.dispatchUpdateComplete();
         }
      }
      
      protected function commitProperties() : void
      {
         var mxTransform:mx.geom.Transform = null;
         var updateTransform:Boolean = false;
         if(this.displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT && Boolean(this.displayObject))
         {
            if(this.colorTransformChanged || this.displayObjectChanged)
            {
               this.colorTransformChanged = false;
               if(Boolean(this._colorTransform))
               {
                  this.displayObject.transform.colorTransform = this._colorTransform;
               }
            }
            if(this.alphaChanged || this.displayObjectChanged)
            {
               this.alphaChanged = false;
               mxTransform = this._transform as mx.geom.Transform;
               if(!mxTransform || !mxTransform.applyColorTransformAlpha)
               {
                  this.displayObject.alpha = this._effectiveAlpha;
               }
            }
            if(this.blendModeChanged || this.displayObjectChanged)
            {
               this.blendModeChanged = false;
               if(this._blendMode == "auto")
               {
                  if(this.alpha == 0 || this.alpha == 1)
                  {
                     this.displayObject.blendMode = BlendMode.NORMAL;
                  }
                  else
                  {
                     this.displayObject.blendMode = BlendMode.LAYER;
                  }
               }
               else if(!this.isAIMBlendMode(this._blendMode))
               {
                  this.displayObject.blendMode = this._blendMode;
               }
               else
               {
                  this.displayObject.blendMode = "normal";
               }
               if(this.blendShaderChanged)
               {
                  this.blendShaderChanged = false;
                  switch(this._blendMode)
                  {
                     case "color":
                        this.displayObject.blendShader = new ColorShader();
                        break;
                     case "colordodge":
                        this.displayObject.blendShader = new ColorDodgeShader();
                        break;
                     case "colorburn":
                        this.displayObject.blendShader = new ColorBurnShader();
                        break;
                     case "exclusion":
                        this.displayObject.blendShader = new ExclusionShader();
                        break;
                     case "hue":
                        this.displayObject.blendShader = new HueShader();
                        break;
                     case "luminosity":
                        this.displayObject.blendShader = new LuminosityShader();
                        break;
                     case "saturation":
                        this.displayObject.blendShader = new SaturationShader();
                        break;
                     case "softlight":
                        this.displayObject.blendShader = new SoftLightShader();
                  }
               }
            }
            if(this.filtersChanged || this.displayObjectChanged)
            {
               this.filtersChanged = false;
               if(this.filtersChanged || Boolean(this._clonedFilters))
               {
                  this.displayObject.filters = this._clonedFilters;
               }
            }
            if(this.maskChanged || this.displayObjectChanged)
            {
               this.maskChanged = false;
               if(Boolean(this._mask))
               {
                  if(!this._mask.parent)
                  {
                     Sprite(this.displayObject).addChild(this._mask);
                     MaskUtil.applyMask(this._mask,this.parent);
                     if(!this._drawnDisplayObject)
                     {
                        if(this.displayObject is Sprite)
                        {
                           Sprite(this.displayObject).graphics.clear();
                        }
                        else if(this.displayObject is Shape)
                        {
                           Shape(this.displayObject).graphics.clear();
                        }
                        this._drawnDisplayObject = new InvalidatingSprite();
                        Sprite(this.displayObject).addChild(this._drawnDisplayObject);
                     }
                  }
                  this.drawnDisplayObject.mask = this._mask;
               }
            }
            if(this.luminositySettingsChanged)
            {
               this.luminositySettingsChanged = false;
               MaskUtil.applyLuminositySettings(this._mask,this._maskType,this._luminosityInvert,this._luminosityClip);
            }
            if(this.maskTypeChanged || this.displayObjectChanged)
            {
               this.maskTypeChanged = false;
               MaskUtil.applyMaskType(this._mask,this._maskType,this._luminosityInvert,this._luminosityClip,this.drawnDisplayObject);
            }
            if(this.displayObjectChanged)
            {
               this.displayObject.visible = this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT ? this._effectiveVisibility : true;
            }
            updateTransform = true;
            this.displayObjectChanged = false;
         }
         if(this.visibleChanged)
         {
            this.visibleChanged = false;
            if(this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
            {
               this.displayObject.visible = this._effectiveVisibility;
            }
            else
            {
               this.invalidateDisplayList();
            }
         }
         if(this.layoutFeatures == null || Boolean(this.layoutFeatures.updatePending) || updateTransform)
         {
            this.applyComputedTransform();
         }
      }
      
      public function validateSize() : void
      {
         if(!this.invalidateSizeFlag)
         {
            return;
         }
         this.invalidateSizeFlag = false;
         var sizeChanging:Boolean = this.measureSizes();
         if(!sizeChanging || !this.includeInLayout)
         {
            if(!this.invalidatePropertiesFlag && !this.invalidateSizeFlag && !this.invalidateDisplayListFlag)
            {
               this.dispatchUpdateComplete();
            }
            return;
         }
         this.invalidateParentSizeAndDisplayList();
      }
      
      protected function canSkipMeasurement() : Boolean
      {
         return !isNaN(this.explicitWidth) && !isNaN(this.explicitHeight);
      }
      
      private function measureSizes() : Boolean
      {
         var oldWidth:Number = this.preferredWidthPreTransform();
         var oldHeight:Number = this.preferredHeightPreTransform();
         var oldX:Number = this.measuredX;
         var oldY:Number = this.measuredY;
         if(!this.canSkipMeasurement())
         {
            this.measure();
         }
         if(!isNaN(this.explicitMinWidth) && this.measuredWidth < this.explicitMinWidth)
         {
            this.measuredWidth = this.explicitMinWidth;
         }
         if(!isNaN(this.explicitMaxWidth) && this.measuredWidth > this.explicitMaxWidth)
         {
            this.measuredWidth = this.explicitMaxWidth;
         }
         if(!isNaN(this.explicitMinHeight) && this.measuredHeight < this.explicitMinHeight)
         {
            this.measuredHeight = this.explicitMinHeight;
         }
         if(!isNaN(this.explicitMaxHeight) && this.measuredHeight > this.explicitMaxHeight)
         {
            this.measuredHeight = this.explicitMaxHeight;
         }
         if(oldWidth != this.preferredWidthPreTransform() || oldHeight != this.preferredHeightPreTransform() || oldX != this.measuredX || oldY != this.measuredY)
         {
            return true;
         }
         return false;
      }
      
      protected function measure() : void
      {
         this.measuredWidth = 0;
         this.measuredHeight = 0;
         this.measuredX = 0;
         this.measuredY = 0;
      }
      
      public function validateDisplayList() : void
      {
         var wasInvalid:Boolean = this.invalidateDisplayListFlag;
         this.invalidateDisplayListFlag = false;
         if(this.layoutFeatures == null || Boolean(this.layoutFeatures.updatePending))
         {
            this.applyComputedTransform();
         }
         if(this.displayObjectSharingMode != DisplayObjectSharingMode.USES_SHARED_OBJECT)
         {
            if(this.drawnDisplayObject is Sprite)
            {
               Sprite(this.drawnDisplayObject).graphics.clear();
            }
         }
         this.doUpdateDisplayList();
         if(!this.invalidatePropertiesFlag && !this.invalidateSizeFlag && !this.invalidateDisplayListFlag && wasInvalid)
         {
            this.dispatchUpdateComplete();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function doUpdateDisplayList() : void
      {
         if(this._effectiveVisibility || this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
         {
            this.updateDisplayList(this._width,this._height);
         }
      }
      
      protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
      
      private function dispatchUpdateComplete() : void
      {
         if(hasEventListener(FlexEvent.UPDATE_COMPLETE))
         {
            dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
         }
      }
      
      public function getMaxBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformWidthForLayout(this.maxWidth,this.maxHeight,postLayoutTransform);
      }
      
      public function getMaxBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformHeightForLayout(this.maxWidth,this.maxHeight,postLayoutTransform);
      }
      
      public function getMinBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformWidthForLayout(this.minWidth,this.minHeight,postLayoutTransform);
      }
      
      public function getMinBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformHeightForLayout(this.minWidth,this.minHeight,postLayoutTransform);
      }
      
      public function getPreferredBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformWidthForLayout(this.preferredWidthPreTransform(),this.preferredHeightPreTransform(),postLayoutTransform);
      }
      
      public function getPreferredBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformHeightForLayout(this.preferredWidthPreTransform(),this.preferredHeightPreTransform(),postLayoutTransform);
      }
      
      public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var strokeExtents:Rectangle = this.getStrokeExtents(postLayoutTransform);
         var m:Matrix = this.getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            return strokeExtents.left + this.measuredX + this.x;
         }
         if(!isNaN(width))
         {
            width -= strokeExtents.width;
         }
         if(!isNaN(height))
         {
            height -= strokeExtents.height;
         }
         var newSize:Point = MatrixUtil.fitBounds(width,height,m,this.explicitWidth,this.explicitHeight,this.preferredWidthPreTransform(),this.preferredHeightPreTransform(),this.minWidth,this.minHeight,this.maxWidth,this.maxHeight);
         if(!newSize)
         {
            newSize = new Point(this.minWidth,this.minHeight);
         }
         var topLeft:Point = new Point(this.measuredX,this.measuredY);
         MatrixUtil.transformBounds(newSize.x,newSize.y,m,topLeft);
         return strokeExtents.left + topLeft.x;
      }
      
      public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var strokeExtents:Rectangle = this.getStrokeExtents(postLayoutTransform);
         var m:Matrix = this.getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            return strokeExtents.top + this.measuredY + this.y;
         }
         if(!isNaN(width))
         {
            width -= strokeExtents.width;
         }
         if(!isNaN(height))
         {
            height -= strokeExtents.height;
         }
         var newSize:Point = MatrixUtil.fitBounds(width,height,m,this.explicitWidth,this.explicitHeight,this.preferredWidthPreTransform(),this.preferredHeightPreTransform(),this.minWidth,this.minHeight,this.maxWidth,this.maxHeight);
         if(!newSize)
         {
            newSize = new Point(this.minWidth,this.minHeight);
         }
         var topLeft:Point = new Point(this.measuredX,this.measuredY);
         MatrixUtil.transformBounds(newSize.x,newSize.y,m,topLeft);
         return strokeExtents.top + topLeft.y;
      }
      
      public function getLayoutBoundsX(postLayoutTransform:Boolean = true) : Number
      {
         var stroke:Number = this.getStrokeExtents(postLayoutTransform).left;
         var m:Matrix = this.getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            return stroke + this.measuredX + this.x;
         }
         var topLeft:Point = new Point(this.measuredX,this.measuredY);
         MatrixUtil.transformBounds(this._width,this._height,m,topLeft);
         return stroke + topLeft.x;
      }
      
      public function getLayoutBoundsY(postLayoutTransform:Boolean = true) : Number
      {
         var stroke:Number = this.getStrokeExtents(postLayoutTransform).top;
         var m:Matrix = this.getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            return stroke + this.measuredY + this.y;
         }
         var topLeft:Point = new Point(this.measuredX,this.measuredY);
         MatrixUtil.transformBounds(this._width,this._height,m,topLeft);
         return stroke + topLeft.y;
      }
      
      public function getLayoutBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformWidthForLayout(this._width,this._height,postLayoutTransform);
      }
      
      public function getLayoutBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformHeightForLayout(this._width,this._height,postLayoutTransform);
      }
      
      protected function transformWidthForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         if(postLayoutTransform && this.hasComplexLayoutMatrix)
         {
            width = Number(MatrixUtil.transformSize(width,height,this.layoutFeatures.layoutMatrix).x);
         }
         return width + this.getStrokeExtents(postLayoutTransform).width;
      }
      
      protected function transformHeightForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         if(postLayoutTransform && this.hasComplexLayoutMatrix)
         {
            height = Number(MatrixUtil.transformSize(width,height,this.layoutFeatures.layoutMatrix).y);
         }
         return height + this.getStrokeExtents(postLayoutTransform).height;
      }
      
      protected function preferredWidthPreTransform() : Number
      {
         return isNaN(this.explicitWidth) ? this.measuredWidth : this.explicitWidth;
      }
      
      protected function preferredHeightPreTransform() : Number
      {
         return isNaN(this.explicitHeight) ? this.measuredHeight : this.explicitHeight;
      }
      
      public function setLayoutBoundsPosition(newBoundsX:Number, newBoundsY:Number, postLayoutTransform:Boolean = true) : void
      {
         var currentBoundsX:Number = this.getLayoutBoundsX(postLayoutTransform);
         var currentBoundsY:Number = this.getLayoutBoundsY(postLayoutTransform);
         var currentX:Number = this.x;
         var currentY:Number = this.y;
         var newX:Number = currentX + newBoundsX - currentBoundsX;
         var newY:Number = currentY + newBoundsY - currentBoundsY;
         if(newX != currentX || newY != currentY)
         {
            if(this.layoutFeatures != null)
            {
               this.layoutFeatures.layoutX = newX;
               this.layoutFeatures.layoutY = newY;
               this.layoutFeatures.updatePending = true;
            }
            else
            {
               this._x = newX;
               this._y = newY;
            }
            if(newX != currentX)
            {
               this.dispatchPropertyChangeEvent("x",currentX,newX);
            }
            if(newY != currentY)
            {
               this.dispatchPropertyChangeEvent("y",currentY,newY);
            }
            this.invalidateDisplayList();
         }
      }
      
      public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         var m:Matrix = null;
         var strokeExtents:Rectangle = null;
         var newSize:Point = null;
         if(!isNaN(width) || !isNaN(height))
         {
            strokeExtents = this.getStrokeExtents(postLayoutTransform);
            if(!isNaN(width))
            {
               width -= strokeExtents.width;
            }
            if(!isNaN(height))
            {
               height -= strokeExtents.height;
            }
         }
         if(postLayoutTransform && this.hasComplexLayoutMatrix)
         {
            m = this.layoutFeatures.layoutMatrix;
         }
         if(!m)
         {
            if(isNaN(width))
            {
               width = this.preferredWidthPreTransform();
            }
            if(isNaN(height))
            {
               height = this.preferredHeightPreTransform();
            }
         }
         else
         {
            newSize = MatrixUtil.fitBounds(width,height,m,this.explicitWidth,this.explicitHeight,this.preferredWidthPreTransform(),this.preferredHeightPreTransform(),this.minWidth,this.minHeight,this.maxWidth,this.maxHeight);
            if(Boolean(newSize))
            {
               width = newSize.x;
               height = newSize.y;
            }
            else
            {
               width = this.minWidth;
               height = this.minHeight;
            }
         }
         this.setActualSize(width,height);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setActualSize(width:Number, height:Number) : void
      {
         var oldWidth:Number = NaN;
         var oldHeight:Number = NaN;
         if(this._width != width || this._height != height)
         {
            oldWidth = this._width;
            oldHeight = this._height;
            this._width = width;
            this._height = height;
            if(Boolean(this.layoutFeatures))
            {
               this.layoutFeatures.layoutWidth = width;
               this.invalidateTransform(false,false);
            }
            if(width != oldWidth)
            {
               this.dispatchPropertyChangeEvent("width",oldWidth,width);
            }
            if(height != oldHeight)
            {
               this.dispatchPropertyChangeEvent("height",oldHeight,height);
            }
            this.invalidateDisplayList();
         }
      }
      
      public function getLayoutMatrix() : Matrix
      {
         if(this.layoutFeatures != null)
         {
            return this.layoutFeatures.layoutMatrix.clone();
         }
         var m:Matrix = new Matrix();
         m.translate(this._x,this._y);
         return m;
      }
      
      public function setLayoutMatrix(value:Matrix, invalidateLayout:Boolean) : void
      {
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         if(MatrixUtil.isEqual(this.layoutFeatures.layoutMatrix,value))
         {
            return;
         }
         this.layoutFeatures.layoutMatrix = value;
         this.invalidateTransform(previous != this.needsDisplayObject,invalidateLayout);
      }
      
      public function get hasLayoutMatrix3D() : Boolean
      {
         return Boolean(this.layoutFeatures) ? Boolean(this.layoutFeatures.layoutIs3D) : false;
      }
      
      public function get is3D() : Boolean
      {
         return Boolean(this.layoutFeatures) ? Boolean(this.layoutFeatures.is3D) : false;
      }
      
      public function getLayoutMatrix3D() : Matrix3D
      {
         if(this.layoutFeatures != null)
         {
            return this.layoutFeatures.layoutMatrix3D.clone();
         }
         var m:Matrix3D = new Matrix3D();
         m.appendTranslation(this._x,this._y,0);
         return m;
      }
      
      public function setLayoutMatrix3D(value:Matrix3D, invalidateLayout:Boolean) : void
      {
         this.allocateLayoutFeatures();
         var previous:Boolean = this.needsDisplayObject;
         if(MatrixUtil.isEqual3D(this.layoutFeatures.layoutMatrix3D,value))
         {
            return;
         }
         this.layoutFeatures.layoutMatrix3D = value;
         this.invalidateTransform(previous != this.needsDisplayObject,invalidateLayout);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyComputedTransform() : void
      {
         var m:Matrix = null;
         if(this.layoutFeatures != null)
         {
            this.layoutFeatures.updatePending = false;
         }
         if(this.displayObjectSharingMode == DisplayObjectSharingMode.USES_SHARED_OBJECT || !this.displayObject)
         {
            return;
         }
         if(this.layoutFeatures != null)
         {
            if(this.layoutFeatures.is3D)
            {
               this.displayObject.transform.matrix3D = this.layoutFeatures.computedMatrix3D;
            }
            else
            {
               m = this.layoutFeatures.computedMatrix.clone();
               if(this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_SHARED_OBJECT)
               {
                  m.tx = 0;
                  m.ty = 0;
               }
               this.displayObject.transform.matrix = m;
            }
         }
         else if(this.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_SHARED_OBJECT)
         {
            this.displayObject.x = 0;
            this.displayObject.y = 0;
         }
         else
         {
            this.displayObject.x = this._x;
            this.displayObject.y = this._y;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getComplexMatrix(performCheck:Boolean) : Matrix
      {
         return performCheck && this.hasComplexLayoutMatrix ? this.layoutFeatures.layoutMatrix : null;
      }
      
      protected function getStrokeExtents(postLayoutTransform:Boolean = true) : Rectangle
      {
         _strokeExtents.x = 0;
         _strokeExtents.y = 0;
         _strokeExtents.width = 0;
         _strokeExtents.height = 0;
         return _strokeExtents;
      }
      
      private function filterChangedHandler(event:Event) : void
      {
         this.filters = this._filters;
      }
   }
}

