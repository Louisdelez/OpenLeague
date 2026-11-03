package spark.core
{
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   import flash.geom.Vector3D;
   import mx.core.AdvancedLayoutFeatures;
   import mx.core.DesignLayer;
   import mx.core.FlexSprite;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.IInvalidating;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IMXMLObject;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.IVisualElement;
   import mx.core.LayoutDirection;
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
   import mx.utils.TransformUtil;
   import spark.components.ResizeMode;
   import spark.utils.MaskUtil;
   
   public class SpriteVisualElement extends FlexSprite implements IVisualElement, IMXMLObject, IFlexModule
   {
      
      private static const DEFAULT_MAX_WIDTH:Number = 10000;
      
      private static const DEFAULT_MAX_HEIGHT:Number = 10000;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var nestedSpriteVisualElement:Boolean;
      
      private var naturalWidth:Number;
      
      private var naturalHeight:Number;
      
      private var _layoutFeatures:AdvancedLayoutFeatures;
      
      private var hasDeltaIdentityTransform:Boolean = true;
      
      private var _transform:flash.geom.Transform;
      
      private var _alpha:Number = 1;
      
      private var _effectiveAlpha:Number = 1;
      
      private var _baseline:Object;
      
      private var _blendMode:String = "auto";
      
      private var _bottom:Object;
      
      private var _filters:Array;
      
      private var _explicitHeight:Number = NaN;
      
      private var _height:Number = 0;
      
      private var _explicitMinHeight:Number = NaN;
      
      private var _explicitMaxHeight:Number = NaN;
      
      private var _horizontalCenter:Object;
      
      private var _includeInLayout:Boolean = true;
      
      private var _depth:Number = 0;
      
      private var _left:Object;
      
      private var _id:String;
      
      private var _luminosityInvert:Boolean = false;
      
      private var _luminosityClip:Boolean = false;
      
      private var _moduleFactory:IFlexModuleFactory;
      
      private var _owner:DisplayObjectContainer;
      
      private var _designLayer:DesignLayer;
      
      private var _mask:DisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var maskChanged:Boolean;
      
      private var _maskType:String = "clip";
      
      private var maskTypeChanged:Boolean;
      
      private var originalMaskFilters:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _percentHeight:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _percentWidth:Number;
      
      private var _right:Object;
      
      private var _top:Object;
      
      private var _verticalCenter:Object;
      
      private var _visible:Boolean = true;
      
      private var _explicitWidth:Number = NaN;
      
      private var _width:Number = 0;
      
      private var _explicitMinWidth:Number = NaN;
      
      private var _explicitMaxWidth:Number = NaN;
      
      private var _viewWidth:Number = NaN;
      
      private var _viewHeight:Number = NaN;
      
      private var _resizeMode:String = "scale";
      
      private var _layoutDirection:String = null;
      
      public function SpriteVisualElement()
      {
         super();
         this.measure();
      }
      
      private function initAdvancedLayoutFeatures() : AdvancedLayoutFeatures
      {
         var features:AdvancedLayoutFeatures = new AdvancedLayoutFeatures();
         this.hasDeltaIdentityTransform = false;
         features.layoutScaleX = this.scaleX;
         features.layoutScaleY = this.scaleY;
         features.layoutScaleZ = this.scaleZ;
         features.layoutRotationX = this.rotationX;
         features.layoutRotationY = this.rotationY;
         features.layoutRotationZ = this.rotation;
         features.layoutX = this.x;
         features.layoutY = this.y;
         features.layoutZ = this.z;
         features.layoutWidth = this._width;
         this._layoutFeatures = features;
         this.invalidateTransform();
         return features;
      }
      
      private function invalidateTransform() : void
      {
         if(Boolean(this._layoutFeatures) && this._layoutFeatures.updatePending == false)
         {
            this._layoutFeatures.updatePending = true;
            this.applyComputedMatrix();
         }
      }
      
      private function applyComputedMatrix() : void
      {
         this._layoutFeatures.updatePending = false;
         if(this._layoutFeatures.is3D)
         {
            super.transform.matrix3D = this._layoutFeatures.computedMatrix3D;
         }
         else
         {
            super.transform.matrix = this._layoutFeatures.computedMatrix;
         }
      }
      
      protected function nonDeltaLayoutMatrix() : Matrix
      {
         if(this.hasDeltaIdentityTransform)
         {
            return null;
         }
         if(this._layoutFeatures != null)
         {
            return this._layoutFeatures.layoutMatrix;
         }
         return MatrixUtil.composeMatrix(this.x,this.y,1,1,this.rotation,0,0);
      }
      
      private function setActualSize(width:Number, height:Number) : void
      {
         var measuredWidth:Number = NaN;
         var measuredHeight:Number = NaN;
         var sx:Number = NaN;
         var sy:Number = NaN;
         if(this._width != width && Boolean(this._layoutFeatures))
         {
            this._layoutFeatures.layoutWidth = width;
            this.invalidateTransform();
         }
         this._width = width;
         this._height = height;
         if(this.resizeMode == ResizeMode.NO_SCALE)
         {
            if(Boolean(this._layoutFeatures))
            {
               this._layoutFeatures.stretchX = 1;
               this._layoutFeatures.stretchY = 1;
               this.invalidateTransform();
            }
         }
         else
         {
            measuredWidth = isNaN(this._viewWidth) ? this.naturalWidth : this._viewWidth;
            measuredHeight = isNaN(this._viewHeight) ? this.naturalHeight : this._viewHeight;
            sx = measuredWidth != 0 ? this._width / measuredWidth : 1;
            sy = measuredHeight != 0 ? this._height / measuredHeight : 1;
            if(sx != 1 || sy != 1 || Boolean(this._layoutFeatures))
            {
               if(this._layoutFeatures == null)
               {
                  this.initAdvancedLayoutFeatures();
               }
               this._layoutFeatures.stretchX = sx;
               this._layoutFeatures.stretchY = sy;
               this.invalidateTransform();
            }
         }
      }
      
      private function move(x:Number, y:Number) : void
      {
         if(this._layoutFeatures == null)
         {
            super.x = x;
            super.y = y;
         }
         else
         {
            this._layoutFeatures.layoutX = x;
            this._layoutFeatures.layoutY = y;
            this.invalidateTransform();
         }
      }
      
      private function measure() : void
      {
         var bounds:Rectangle = getBounds(this);
         this.naturalWidth = Math.max(0,bounds.right);
         this.naturalHeight = Math.max(0,bounds.bottom);
         if(isNaN(this._explicitWidth))
         {
            this._width = this.naturalWidth;
         }
         if(isNaN(this._explicitHeight))
         {
            this._height = this.naturalHeight;
         }
      }
      
      protected function invalidateSize() : void
      {
         var parent:DisplayObjectContainer = null;
         var curWidth:Number = this.naturalWidth;
         var curHeight:Number = this.naturalHeight;
         this.measure();
         if(curWidth != this.naturalWidth || curHeight != this.naturalHeight)
         {
            parent = this.parent;
            while(this.nestedSpriteVisualElement)
            {
               if(parent is SpriteVisualElement || parent == null || parent.parent == null)
               {
                  break;
               }
               parent = parent.parent;
            }
            if(parent is SpriteVisualElement)
            {
               SpriteVisualElement(parent).invalidateSize();
            }
            else
            {
               this.invalidateParentSizeAndDisplayList();
            }
         }
      }
      
      public function get postLayoutTransformOffsets() : TransformOffsets
      {
         return this._layoutFeatures == null ? null : this._layoutFeatures.postLayoutTransformOffsets;
      }
      
      public function set postLayoutTransformOffsets(value:TransformOffsets) : void
      {
         if(value != null && this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         if(this._layoutFeatures.postLayoutTransformOffsets != null)
         {
            this._layoutFeatures.postLayoutTransformOffsets.removeEventListener(Event.CHANGE,this.transformOffsetsChangedHandler);
         }
         this._layoutFeatures.postLayoutTransformOffsets = value;
         if(this._layoutFeatures.postLayoutTransformOffsets != null)
         {
            this._layoutFeatures.postLayoutTransformOffsets.addEventListener(Event.CHANGE,this.transformOffsetsChangedHandler);
         }
      }
      
      override public function get alpha() : Number
      {
         return int(this._alpha * 256) / 256;
      }
      
      override public function set alpha(value:Number) : void
      {
         if(this._alpha != value)
         {
            this._alpha = value;
            if(Boolean(this.designLayer))
            {
               value *= this.designLayer.effectiveAlpha;
            }
            super.alpha = value;
            if(this._blendMode == "auto")
            {
               if(value > 0 && value < 1 && (this._effectiveAlpha == 0 || this._effectiveAlpha == 1))
               {
                  super.blendMode = BlendMode.LAYER;
               }
               else if((value == 0 || value == 1) && (this._effectiveAlpha > 0 && this._effectiveAlpha < 1))
               {
                  super.blendMode = BlendMode.NORMAL;
               }
            }
            this._effectiveAlpha = value;
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
         return 0;
      }
      
      [Inspectable(category="General",enumeration="auto,add,alpha,darken,difference,erase,hardlight,invert,layer,lighten,multiply,normal,subtract,screen,overlay,colordodge,colorburn,exclusion,softlight,hue,saturation,color,luminosity",defaultValue="auto")]
      override public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      override public function set blendMode(value:String) : void
      {
         if(value == this._blendMode)
         {
            return;
         }
         this._blendMode = value;
         if(value == "color")
         {
            blendShader = new ColorShader();
         }
         else if(value == "colordodge")
         {
            blendShader = new ColorDodgeShader();
         }
         else if(value == "colorburn")
         {
            blendShader = new ColorBurnShader();
         }
         else if(value == "exclusion")
         {
            blendShader = new ExclusionShader();
         }
         else if(value == "hue")
         {
            blendShader = new HueShader();
         }
         else if(value == "luminosity")
         {
            blendShader = new LuminosityShader();
         }
         else if(value == "saturation")
         {
            blendShader = new SaturationShader();
         }
         else if(value == "softlight")
         {
            blendShader = new SoftLightShader();
         }
         else if(value == "auto")
         {
            if(this.alpha == 0 || this.alpha == 1)
            {
               super.blendMode = BlendMode.NORMAL;
            }
            else
            {
               super.blendMode = BlendMode.LAYER;
            }
         }
         else
         {
            super.blendMode = value;
         }
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
      
      override public function get filters() : Array
      {
         return Boolean(this._filters) ? this._filters : super.filters;
      }
      
      override public function set filters(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         var e:IEventDispatcher = null;
         if(Boolean(this._filters))
         {
            n = int(this._filters.length);
            for(i = 0; i < n; i++)
            {
               e = this._filters[i] as IEventDispatcher;
               if(Boolean(e))
               {
                  e.removeEventListener(BaseFilter.CHANGE,this.filterChangeHandler);
               }
            }
         }
         this._filters = value;
         var clonedFilters:Array = [];
         if(Boolean(this._filters))
         {
            n = int(this._filters.length);
            for(i = 0; i < n; i++)
            {
               if(this._filters[i] is IBitmapFilter)
               {
                  e = this._filters[i] as IEventDispatcher;
                  if(Boolean(e))
                  {
                     e.addEventListener(BaseFilter.CHANGE,this.filterChangeHandler);
                  }
                  clonedFilters.push(IBitmapFilter(this._filters[i]).clone());
               }
               else
               {
                  clonedFilters.push(this._filters[i]);
               }
            }
         }
         super.filters = clonedFilters;
      }
      
      [PercentProxy("percentHeight")]
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(value:Number) : void
      {
         this._height = value;
         this.setActualSize(this._width,this._height);
         if(this._explicitHeight == value)
         {
            return;
         }
         this._explicitHeight = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get minHeight() : Number
      {
         if(!isNaN(this._explicitMinHeight))
         {
            return this._explicitMinHeight;
         }
         return this.resizeMode == ResizeMode.SCALE ? 0 : this.preferredHeight;
      }
      
      public function set minHeight(value:Number) : void
      {
         if(this._explicitMinHeight == value)
         {
            return;
         }
         this._explicitMinHeight = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get maxHeight() : Number
      {
         if(!isNaN(this._explicitMaxHeight))
         {
            return this._explicitMaxHeight;
         }
         return DEFAULT_MAX_HEIGHT;
      }
      
      public function set maxHeight(value:Number) : void
      {
         if(this._explicitMaxHeight == value)
         {
            return;
         }
         this._explicitMaxHeight = value;
         this.invalidateParentSizeAndDisplayList();
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
         this._includeInLayout = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get depth() : Number
      {
         return this._depth;
      }
      
      public function set depth(value:Number) : void
      {
         if(value == this._depth)
         {
            return;
         }
         this._depth = value;
         if(parent != null && "invalidateLayering" in parent && parent["invalidateLayering"] is Function)
         {
            parent["invalidateLayering"]();
         }
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
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
      public function get luminosityInvert() : Boolean
      {
         return this._luminosityInvert;
      }
      
      public function set luminosityInvert(value:Boolean) : void
      {
         this._luminosityInvert = value;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
      public function get luminosityClip() : Boolean
      {
         return this._luminosityClip;
      }
      
      public function set luminosityClip(value:Boolean) : void
      {
         this._luminosityClip = value;
      }
      
      [Inspectable(environment="none")]
      public function get moduleFactory() : IFlexModuleFactory
      {
         return this._moduleFactory;
      }
      
      public function set moduleFactory(factory:IFlexModuleFactory) : void
      {
         this.setModuleFactoryInChildrenOf(this,factory);
         this._moduleFactory = factory;
      }
      
      private function setModuleFactoryInChildrenOf(container:DisplayObjectContainer, factory:IFlexModuleFactory) : void
      {
         var child:DisplayObject = null;
         var fmChild:IFlexModule = null;
         var n:int = container.numChildren;
         for(var i:int = 0; i < n; i++)
         {
            child = container.getChildAt(i);
            if(child is IFlexModule)
            {
               fmChild = IFlexModule(child);
               if(fmChild.moduleFactory == null || fmChild.moduleFactory == this._moduleFactory)
               {
                  fmChild.moduleFactory = factory;
               }
            }
            else if(child is DisplayObjectContainer)
            {
               this.setModuleFactoryInChildrenOf(DisplayObjectContainer(child),factory);
            }
         }
      }
      
      public function get owner() : DisplayObjectContainer
      {
         return Boolean(this._owner) ? this._owner : parent;
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
         super.alpha = Boolean(this._designLayer) ? this._alpha * this._designLayer.effectiveAlpha : this._alpha;
         super.visible = Boolean(this._designLayer) ? this._visible && Boolean(this._designLayer.effectiveVisibility) : this._visible;
      }
      
      [Inspectable(category="General")]
      override public function get mask() : DisplayObject
      {
         return this._mask;
      }
      
      override public function set mask(value:DisplayObject) : void
      {
         if(this._mask !== value)
         {
            if(Boolean(this._mask) && this._mask.parent === this)
            {
               removeChild(this._mask);
            }
            this._mask = value;
            this.maskChanged = true;
            this.applyMask();
         }
         super.mask = value;
      }
      
      [Inspectable(category="General",enumeration="clip,alpha,luminosity",defaultValue="clip")]
      [Bindable("propertyChange")]
      public function get maskType() : String
      {
         return this._maskType;
      }
      
      public function set maskType(value:String) : void
      {
         if(this._maskType != value)
         {
            this._maskType = value;
            this.maskTypeChanged = true;
            this.applyMask();
         }
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
      
      override public function get x() : Number
      {
         return this._layoutFeatures == null ? super.x : Number(this._layoutFeatures.layoutX);
      }
      
      override public function set x(value:Number) : void
      {
         if(this.x == value)
         {
            return;
         }
         this.move(value,this.y);
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get y() : Number
      {
         return this._layoutFeatures == null ? super.y : Number(this._layoutFeatures.layoutY);
      }
      
      override public function set y(value:Number) : void
      {
         if(this.y == value)
         {
            return;
         }
         this.move(this.x,value);
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get z() : Number
      {
         return this._layoutFeatures == null ? super.z : Number(this._layoutFeatures.layoutZ);
      }
      
      override public function set z(value:Number) : void
      {
         if(this.z == value)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this.hasDeltaIdentityTransform = false;
         this._layoutFeatures.layoutZ = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get rotation() : Number
      {
         return this._layoutFeatures == null ? super.rotation : Number(this._layoutFeatures.layoutRotationZ);
      }
      
      override public function set rotation(value:Number) : void
      {
         if(this.rotation == value)
         {
            return;
         }
         this.hasDeltaIdentityTransform = false;
         if(this._layoutFeatures == null)
         {
            super.rotation = MatrixUtil.clampRotation(value);
         }
         else
         {
            this._layoutFeatures.layoutRotationZ = value;
         }
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get rotationX() : Number
      {
         return this._layoutFeatures == null ? super.rotationX : Number(this._layoutFeatures.layoutRotationX);
      }
      
      override public function set rotationX(value:Number) : void
      {
         if(this.rotationX == value)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this._layoutFeatures.layoutRotationX = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get rotationY() : Number
      {
         return this._layoutFeatures == null ? super.rotationY : Number(this._layoutFeatures.layoutRotationY);
      }
      
      override public function set rotationY(value:Number) : void
      {
         if(this.rotationY == value)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this._layoutFeatures.layoutRotationY = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get rotationZ() : Number
      {
         return this.rotation;
      }
      
      override public function set rotationZ(value:Number) : void
      {
         this.rotation = value;
      }
      
      override public function get scaleX() : Number
      {
         return this._layoutFeatures == null ? 1 : Number(this._layoutFeatures.layoutScaleX);
      }
      
      override public function set scaleX(value:Number) : void
      {
         if(value == this.scaleX)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this.hasDeltaIdentityTransform = false;
         this._layoutFeatures.layoutScaleX = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get scaleY() : Number
      {
         return this._layoutFeatures == null ? 1 : Number(this._layoutFeatures.layoutScaleY);
      }
      
      override public function set scaleY(value:Number) : void
      {
         if(value == this.scaleY)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this.hasDeltaIdentityTransform = false;
         this._layoutFeatures.layoutScaleY = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      override public function get scaleZ() : Number
      {
         return this._layoutFeatures == null ? super.scaleZ : Number(this._layoutFeatures.layoutScaleZ);
      }
      
      override public function set scaleZ(value:Number) : void
      {
         if(this.scaleZ == value)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this.hasDeltaIdentityTransform = false;
         this._layoutFeatures.layoutScaleZ = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
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
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      override public function set visible(value:Boolean) : void
      {
         this._visible = value;
         if(Boolean(this.designLayer) && !this.designLayer.effectiveVisibility)
         {
            value = false;
         }
         if(super.visible == value)
         {
            return;
         }
         super.visible = value;
      }
      
      [PercentProxy("percentWidth")]
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(value:Number) : void
      {
         this._width = value;
         this.setActualSize(this._width,this._height);
         if(this._explicitWidth == value)
         {
            return;
         }
         this._explicitWidth = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get minWidth() : Number
      {
         if(!isNaN(this._explicitMinWidth))
         {
            return this._explicitMinWidth;
         }
         return this.resizeMode == ResizeMode.SCALE ? 0 : this.preferredWidth;
      }
      
      public function set minWidth(value:Number) : void
      {
         if(this._explicitMinWidth == value)
         {
            return;
         }
         this._explicitMinWidth = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get maxWidth() : Number
      {
         if(!isNaN(this._explicitMaxWidth))
         {
            return this._explicitMaxWidth;
         }
         return DEFAULT_MAX_WIDTH;
      }
      
      public function set maxWidth(value:Number) : void
      {
         if(this._explicitMaxWidth == value)
         {
            return;
         }
         this._explicitMaxWidth = value;
         this.invalidateParentSizeAndDisplayList();
      }
      
      protected function set viewWidth(value:Number) : void
      {
         this._viewWidth = value;
      }
      
      protected function set viewHeight(value:Number) : void
      {
         this._viewHeight = value;
      }
      
      public function get resizeMode() : String
      {
         return this._resizeMode;
      }
      
      public function set resizeMode(value:String) : void
      {
         if(this._resizeMode == value)
         {
            return;
         }
         this._resizeMode = value;
         this.setActualSize(this._width,this._height);
      }
      
      override public function get transform() : flash.geom.Transform
      {
         if(this._transform == null)
         {
            this.setTransform(new mx.geom.Transform(this));
         }
         return this._transform;
      }
      
      override public function set transform(value:flash.geom.Transform) : void
      {
         var m:Matrix = value.matrix;
         var m3:Matrix3D = value.matrix3D;
         var ct:ColorTransform = value.colorTransform;
         var pp:PerspectiveProjection = value.perspectiveProjection;
         var mxTransform:mx.geom.Transform = value as mx.geom.Transform;
         if(Boolean(mxTransform))
         {
            if(!mxTransform.applyMatrix)
            {
               m = null;
            }
            if(!mxTransform.applyMatrix3D)
            {
               m3 = null;
            }
         }
         this.setTransform(value);
         if(m != null)
         {
            this.setLayoutMatrix(m.clone(),true);
         }
         else if(m3 != null)
         {
            this.setLayoutMatrix3D(m3.clone(),true);
         }
         super.transform.colorTransform = ct;
         super.transform.perspectiveProjection = pp;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get $transform() : flash.geom.Transform
      {
         return super.transform;
      }
      
      public function get transformX() : Number
      {
         return this._layoutFeatures == null ? 0 : Number(this._layoutFeatures.transformX);
      }
      
      public function set transformX(value:Number) : void
      {
         if(this.transformX == value)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this._layoutFeatures.transformX = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get transformY() : Number
      {
         return this._layoutFeatures == null ? 0 : Number(this._layoutFeatures.transformY);
      }
      
      public function set transformY(value:Number) : void
      {
         if(this.transformY == value)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this._layoutFeatures.transformY = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get transformZ() : Number
      {
         return this._layoutFeatures == null ? 0 : Number(this._layoutFeatures.transformZ);
      }
      
      public function set transformZ(value:Number) : void
      {
         if(this.transformZ == value)
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this._layoutFeatures.transformZ = value;
         this.invalidateTransform();
         this.invalidateParentSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="ltr,rtl")]
      public function get layoutDirection() : String
      {
         if(this._layoutDirection != null)
         {
            return this._layoutDirection;
         }
         var parentElt:ILayoutDirectionElement = parent as ILayoutDirectionElement;
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
         var parentElt:ILayoutDirectionElement = parent as ILayoutDirectionElement;
         if(!parentElt)
         {
            return;
         }
         var mirror:Boolean = parentElt.layoutDirection != null && this._layoutDirection != null && this._layoutDirection != parentElt.layoutDirection;
         if(Boolean(this._layoutFeatures) ? mirror != this._layoutFeatures.mirror : mirror)
         {
            if(this._layoutFeatures == null)
            {
               this.initAdvancedLayoutFeatures();
            }
            this._layoutFeatures.mirror = mirror;
            this.invalidateTransform();
            this.invalidateParentSizeAndDisplayList();
         }
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         this.addingChild(child);
         super.addChild(child);
         this.childAdded(child);
         return child;
      }
      
      override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         this.addingChild(child);
         super.addChildAt(child,index);
         this.childAdded(child);
         return child;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addingChild(child:DisplayObject) : void
      {
         if(child is IUIComponent)
         {
            IUIComponent(child).parentChanged(this);
         }
         if(child is ILayoutManagerClient)
         {
            ILayoutManagerClient(child).nestLevel = 2;
         }
         else if(child is IUITextField)
         {
            IUITextField(child).nestLevel = 2;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childAdded(child:DisplayObject) : void
      {
         if(child is IUIComponent)
         {
            IUIComponent(child).initialize();
         }
      }
      
      override public function globalToLocal(point:Point) : Point
      {
         var sX:Number = NaN;
         var sY:Number = NaN;
         var p:Point = null;
         if(this.resizeMode == ResizeMode.SCALE && this._layoutFeatures != null)
         {
            sX = Number(this._layoutFeatures.stretchX);
            sY = Number(this._layoutFeatures.stretchY);
            this._layoutFeatures.stretchX = 1;
            this._layoutFeatures.stretchY = 1;
            this.applyComputedMatrix();
            p = super.globalToLocal(point);
            this._layoutFeatures.stretchX = sX;
            this._layoutFeatures.stretchY = sY;
            this.applyComputedMatrix();
            return p;
         }
         return super.globalToLocal(point);
      }
      
      override public function localToGlobal(point:Point) : Point
      {
         var sX:Number = NaN;
         var sY:Number = NaN;
         var p:Point = null;
         if(this.resizeMode == ResizeMode.SCALE && this._layoutFeatures != null)
         {
            sX = Number(this._layoutFeatures.stretchX);
            sY = Number(this._layoutFeatures.stretchY);
            this._layoutFeatures.stretchX = 1;
            this._layoutFeatures.stretchY = 1;
            this.applyComputedMatrix();
            p = super.localToGlobal(point);
            this._layoutFeatures.stretchX = sX;
            this._layoutFeatures.stretchY = sY;
            this.applyComputedMatrix();
            return p;
         }
         return super.localToGlobal(point);
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.id = id;
      }
      
      private function transformOffsetsChangedHandler(e:Event) : void
      {
         this.invalidateTransform();
      }
      
      private function get preferredWidth() : Number
      {
         if(!isNaN(this._explicitWidth))
         {
            return this._explicitWidth;
         }
         if(!isNaN(this._viewWidth))
         {
            return this._viewWidth;
         }
         return this.naturalWidth;
      }
      
      private function get preferredHeight() : Number
      {
         if(!isNaN(this._explicitHeight))
         {
            return this._explicitHeight;
         }
         if(!isNaN(this._viewHeight))
         {
            return this._viewHeight;
         }
         return this.naturalHeight;
      }
      
      protected function layer_PropertyChange(event:PropertyChangeEvent) : void
      {
         var newValue:Boolean = false;
         var newAlpha:Number = NaN;
         switch(event.property)
         {
            case "effectiveVisibility":
               newValue = Boolean(event.newValue) && this._visible;
               if(newValue != super.visible)
               {
                  super.visible = newValue;
               }
               break;
            case "effectiveAlpha":
               newAlpha = Number(event.newValue) * this._alpha;
               if(newAlpha != super.alpha)
               {
                  super.alpha = newAlpha;
               }
         }
      }
      
      private function filterChangeHandler(event:Event) : void
      {
         this.filters = this._filters;
      }
      
      public function getLayoutBoundsX(postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = postLayoutTransform ? this.nonDeltaLayoutMatrix() : null;
         if(!m)
         {
            return this.x;
         }
         var topLeft:Point = new Point(0,0);
         MatrixUtil.transformBounds(this.width,this.height,m,topLeft);
         return topLeft.x;
      }
      
      public function getLayoutBoundsY(postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = postLayoutTransform ? this.nonDeltaLayoutMatrix() : null;
         if(!m)
         {
            return this.y;
         }
         var topLeft:Point = new Point(0,0);
         MatrixUtil.transformBounds(this.width,this.height,m,topLeft);
         return topLeft.y;
      }
      
      public function getLayoutBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformWidthForLayout(this.width,this.height,postLayoutTransform);
      }
      
      public function getLayoutBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformHeightForLayout(this.width,this.height,postLayoutTransform);
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
         return this.transformWidthForLayout(this.preferredWidth,this.preferredHeight,postLayoutTransform);
      }
      
      public function getPreferredBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return this.transformHeightForLayout(this.preferredWidth,this.preferredHeight,postLayoutTransform);
      }
      
      public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = postLayoutTransform ? this.nonDeltaLayoutMatrix() : null;
         if(!m)
         {
            return this.x;
         }
         var topLeft:Point = new Point(0,0);
         MatrixUtil.transformBounds(this.preferredWidth,this.preferredHeight,m,topLeft);
         return topLeft.x;
      }
      
      public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = postLayoutTransform ? this.nonDeltaLayoutMatrix() : null;
         if(!m)
         {
            return this.y;
         }
         var topLeft:Point = new Point(0,0);
         MatrixUtil.transformBounds(this.preferredWidth,this.preferredHeight,m,topLeft);
         return topLeft.y;
      }
      
      protected function invalidateParentSizeAndDisplayList() : void
      {
         if(!this.includeInLayout)
         {
            return;
         }
         var p:IInvalidating = parent as IInvalidating;
         if(!p)
         {
            return;
         }
         p.invalidateSize();
         p.invalidateDisplayList();
      }
      
      public function setLayoutBoundsPosition(newBoundsX:Number, newBoundsY:Number, postLayoutTransform:Boolean = true) : void
      {
         var currentBoundsX:Number = this.getLayoutBoundsX(postLayoutTransform);
         var currentBoundsY:Number = this.getLayoutBoundsY(postLayoutTransform);
         var xOffset:Number = newBoundsX - currentBoundsX;
         var yOffset:Number = newBoundsY - currentBoundsY;
         if(xOffset != 0 || yOffset != 0)
         {
            this.move(this.x + xOffset,this.y + yOffset);
         }
      }
      
      public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         var m:Matrix = postLayoutTransform ? this.nonDeltaLayoutMatrix() : null;
         if(!m)
         {
            if(isNaN(width))
            {
               width = this.preferredWidth;
            }
            if(isNaN(height))
            {
               height = this.preferredHeight;
            }
            this.setActualSize(width,height);
            return;
         }
         var fitSize:Point = MatrixUtil.fitBounds(width,height,m,this._explicitWidth,this._explicitHeight,this.preferredWidth,this.preferredHeight,this.minWidth,this.minHeight,this.maxWidth,this.maxHeight);
         if(!fitSize)
         {
            this.setActualSize(this.preferredWidth,this.preferredHeight);
         }
         else
         {
            this.setActualSize(fitSize.x,fitSize.y);
         }
      }
      
      public function getLayoutMatrix() : Matrix
      {
         if(this._layoutFeatures != null || super.transform.matrix == null)
         {
            if(this._layoutFeatures == null)
            {
               this.initAdvancedLayoutFeatures();
            }
            return this._layoutFeatures.layoutMatrix.clone();
         }
         return super.transform.matrix;
      }
      
      public function setLayoutMatrix(value:Matrix, invalidateLayout:Boolean) : void
      {
         this.hasDeltaIdentityTransform = false;
         var previousMatrix:Matrix = Boolean(this._layoutFeatures) ? this._layoutFeatures.layoutMatrix : super.transform.matrix;
         if(this._layoutFeatures == null)
         {
            super.transform.matrix = value;
         }
         else
         {
            this._layoutFeatures.layoutMatrix = value;
            this.invalidateTransform();
         }
         if(MatrixUtil.isEqual(previousMatrix,Boolean(this._layoutFeatures) ? this._layoutFeatures.layoutMatrix : super.transform.matrix))
         {
            return;
         }
         if(invalidateLayout)
         {
            this.invalidateParentSizeAndDisplayList();
         }
      }
      
      public function get hasLayoutMatrix3D() : Boolean
      {
         return Boolean(this._layoutFeatures) ? Boolean(this._layoutFeatures.layoutIs3D) : false;
      }
      
      public function get is3D() : Boolean
      {
         return Boolean(this._layoutFeatures) ? Boolean(this._layoutFeatures.is3D) : false;
      }
      
      public function getLayoutMatrix3D() : Matrix3D
      {
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         return this._layoutFeatures.layoutMatrix3D.clone();
      }
      
      public function setLayoutMatrix3D(value:Matrix3D, invalidateLayout:Boolean) : void
      {
         if(Boolean(this._layoutFeatures) && Boolean(MatrixUtil.isEqual3D(this._layoutFeatures.layoutMatrix3D,value)))
         {
            return;
         }
         if(this._layoutFeatures == null)
         {
            this.initAdvancedLayoutFeatures();
         }
         this._layoutFeatures.layoutMatrix3D = value;
         this.invalidateTransform();
         if(invalidateLayout)
         {
            this.invalidateParentSizeAndDisplayList();
         }
      }
      
      public function transformAround(transformCenter:Vector3D, scale:Vector3D = null, rotation:Vector3D = null, translation:Vector3D = null, postLayoutScale:Vector3D = null, postLayoutRotation:Vector3D = null, postLayoutTranslation:Vector3D = null, invalidateLayout:Boolean = true) : void
      {
         var oldIncludeInLayout:Boolean = false;
         if(!invalidateLayout)
         {
            oldIncludeInLayout = this._includeInLayout;
            this._includeInLayout = false;
         }
         TransformUtil.transformAround(this,transformCenter,scale,rotation,translation,postLayoutScale,postLayoutRotation,postLayoutTranslation,this._layoutFeatures,this.initAdvancedLayoutFeatures);
         if(this._layoutFeatures != null)
         {
            this.invalidateTransform();
            this.invalidateParentSizeAndDisplayList();
         }
         if(!invalidateLayout)
         {
            this._includeInLayout = oldIncludeInLayout;
         }
      }
      
      public function transformPointToParent(localPosition:Vector3D, position:Vector3D, postLayoutPosition:Vector3D) : void
      {
         TransformUtil.transformPointToParent(this,localPosition,position,postLayoutPosition,this._layoutFeatures);
      }
      
      protected function transformWidthForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = null;
         if(postLayoutTransform)
         {
            m = this.nonDeltaLayoutMatrix();
            if(Boolean(m))
            {
               width = Number(MatrixUtil.transformSize(width,height,m).x);
            }
         }
         return width;
      }
      
      protected function transformHeightForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = null;
         if(postLayoutTransform)
         {
            m = this.nonDeltaLayoutMatrix();
            if(Boolean(m))
            {
               height = Number(MatrixUtil.transformSize(width,height,m).y);
            }
         }
         return height;
      }
      
      private function applyMask() : void
      {
         if(this.maskChanged)
         {
            this.maskChanged = false;
            if(Boolean(this._mask))
            {
               this.maskTypeChanged = true;
               if(!this._mask.parent)
               {
                  this.addChild(this._mask);
                  MaskUtil.applyMask(this._mask,null);
               }
            }
         }
         if(this.maskTypeChanged)
         {
            this.maskTypeChanged = false;
            if(Boolean(this._mask))
            {
               MaskUtil.applyMaskType(this._mask,this._maskType,this.luminosityInvert,this.luminosityClip,this);
            }
         }
      }
   }
}

