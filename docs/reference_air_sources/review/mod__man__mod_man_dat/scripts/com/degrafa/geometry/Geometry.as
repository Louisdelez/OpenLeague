package com.degrafa.geometry
{
   import com.degrafa.IGeometryComposition;
   import com.degrafa.IGraphic;
   import com.degrafa.core.DegrafaObject;
   import com.degrafa.core.IDegrafaObject;
   import com.degrafa.core.IGraphicSkin;
   import com.degrafa.core.IGraphicsFill;
   import com.degrafa.core.IGraphicsStroke;
   import com.degrafa.core.ITransformablePaint;
   import com.degrafa.core.collections.DecoratorCollection;
   import com.degrafa.core.collections.DisplayObjectCollection;
   import com.degrafa.core.collections.FilterCollection;
   import com.degrafa.core.collections.GeometryCollection;
   import com.degrafa.events.DegrafaEvent;
   import com.degrafa.geometry.command.CommandStack;
   import com.degrafa.geometry.layout.LayoutConstraint;
   import com.degrafa.states.IDegrafaStateClient;
   import com.degrafa.states.State;
   import com.degrafa.states.StateManager;
   import com.degrafa.transform.ITransform;
   import com.degrafa.triggers.ITrigger;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.binding.utils.ChangeWatcher;
   import mx.core.IUIComponent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.ISimpleStyleClient;
   
   [Bindable(event="propertyChange")]
   public class Geometry extends DegrafaObject implements IDegrafaObject, IGeometryComposition, IDegrafaStateClient, ISimpleStyleClient
   {
      
      private var _IGraphicParent:IGraphic;
      
      private var _maskSpace:String;
      
      private var _graphicsTarget:DisplayObjectCollection;
      
      private var _maskMode:String;
      
      public var hasFilters:Boolean;
      
      private var _stateEvent:String;
      
      private var _autoClearGraphicsTarget:Boolean = true;
      
      private var _clippingRectangle:Rectangle = null;
      
      private var _styleName:Object;
      
      private var _alpha:Number;
      
      protected var _fill:IGraphicsFill;
      
      public var hasLayout:Boolean;
      
      public var hasTriggers:Boolean;
      
      private var _currentState:String = "";
      
      private var _data:Object;
      
      private var methodQueue:Array = [];
      
      private var _filters:FilterCollection;
      
      private var _invalidated:Boolean;
      
      public var _currentGraphicsTarget:Sprite;
      
      private var _transformContext:Matrix;
      
      private var targetDictionary:Dictionary = new Dictionary(true);
      
      private var _inheritStroke:Boolean = true;
      
      protected var _layoutConstraint:LayoutConstraint;
      
      private var _triggers:Array = [];
      
      private var _states:Array = [];
      
      protected var _layoutRectangle:Rectangle;
      
      private var _visible:Boolean = true;
      
      private var _decorators:DecoratorCollection;
      
      public var hasStates:Boolean;
      
      protected var _stroke:IGraphicsStroke;
      
      private var _inheritFill:Boolean = true;
      
      private var _scaleOnLayout:Boolean = true;
      
      public var _layoutMatrix:Matrix;
      
      private var _state:String;
      
      private var _mask:IGeometryComposition;
      
      private var _geometry:GeometryCollection;
      
      public var hasDecorators:Boolean;
      
      private var stateManager:StateManager;
      
      private var _isRootGeometry:Boolean = false;
      
      private var _commandStack:CommandStack;
      
      private var _transform:ITransform;
      
      private var _stage:Stage;
      
      public function Geometry()
      {
         super();
      }
      
      public function set commandStack(param1:CommandStack) : void
      {
         _commandStack = param1;
      }
      
      public function get states() : Array
      {
         return _states;
      }
      
      private function onTargetRender(param1:Event) : void
      {
         if(!_stage)
         {
            _stage = param1.currentTarget.stage;
         }
         if(_stage)
         {
            param1.currentTarget.removeEventListener(Event.RENDER,onTargetRender);
            param1.currentTarget.removeEventListener(Event.ADDED_TO_STAGE,onTargetRender);
            if(param1.currentTarget is IUIComponent)
            {
               param1.currentTarget.removeEventListener(FlexEvent.UPDATE_COMPLETE,onTargetRender);
            }
            if(param1.currentTarget is IUIComponent)
            {
               initLayoutChangeWatcher(param1.currentTarget as IUIComponent);
            }
            initDrawQueue();
            queueDraw(param1.currentTarget,param1.currentTarget.graphics,null);
            return;
         }
      }
      
      public function get left() : Number
      {
         return hasLayout ? layoutConstraint.left : NaN;
      }
      
      public function set states(param1:Array) : void
      {
         var _loc2_:State = null;
         _states = param1;
         if(param1)
         {
            if(!stateManager)
            {
               stateManager = new StateManager(this);
               for each(_loc2_ in _states)
               {
                  _loc2_.stateManager = stateManager;
               }
            }
         }
         else
         {
            stateManager = null;
         }
         if(Boolean(param1) && param1.length != 0)
         {
            hasStates = true;
         }
         else
         {
            hasStates = false;
         }
      }
      
      public function get maintainAspectRatio() : Boolean
      {
         return hasLayout ? layoutConstraint.maintainAspectRatio : false;
      }
      
      public function set left(param1:Number) : void
      {
         layoutConstraint.left = param1;
      }
      
      public function set maintainAspectRatio(param1:Boolean) : void
      {
         layoutConstraint.maintainAspectRatio = param1;
      }
      
      public function get minHeight() : Number
      {
         return hasLayout ? layoutConstraint.minHeight : NaN;
      }
      
      public function get right() : Number
      {
         return hasLayout ? layoutConstraint.right : NaN;
      }
      
      private function onTargetChange(param1:Event) : void
      {
         var _loc3_:Array = null;
         var _loc4_:ChangeWatcher = null;
         var _loc5_:IUIComponent = null;
         var _loc6_:Rectangle = null;
         var _loc2_:Object = requestTarget(param1.currentTarget as IUIComponent);
         if(_loc2_)
         {
            _loc3_ = _loc2_.data.watchers;
         }
         if(_loc2_)
         {
            if(!hasLayout)
            {
               for each(_loc4_ in _loc3_)
               {
                  _loc4_.unwatch();
               }
               removeTarget(param1.currentTarget as IUIComponent);
               return;
            }
         }
         if(_loc2_)
         {
            _loc5_ = param1.currentTarget as IUIComponent;
            _loc6_ = new Rectangle(_loc5_.x,_loc5_.y,_loc5_.width,_loc5_.height);
            if(!_loc6_.equals(_loc2_.data.oldbounds))
            {
               addUpdateTarget(_loc5_,{
                  "oldbounds":_loc6_,
                  "watchers":_loc3_
               });
               queueDraw(_loc5_,Sprite(_loc5_).graphics,null);
            }
         }
      }
      
      public function set inheritStroke(param1:Boolean) : void
      {
         _inheritStroke = param1;
      }
      
      public function get bottom() : Number
      {
         return hasLayout ? layoutConstraint.bottom : NaN;
      }
      
      public function calculateLayout(param1:Rectangle = null) : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Geometry = null;
         var _loc4_:Geometry = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Rectangle = null;
         if(_layoutConstraint)
         {
            if(!param1)
            {
               param1 = new Rectangle(0,0,1,1);
            }
            if(Boolean(parent) && parent is Geometry)
            {
               _loc3_ = Geometry(parent);
               while(Boolean(_loc3_) && !_loc2_)
               {
                  if(!Geometry(parent).layoutRectangle.isEmpty())
                  {
                     _loc2_ = _loc3_.layoutRectangle;
                  }
                  else
                  {
                     _loc4_ = _loc3_;
                     _loc3_ = _loc3_.parent as Geometry;
                  }
               }
            }
            if(Boolean(_loc4_) && !_loc2_)
            {
               if(!_loc4_._currentGraphicsTarget)
               {
                  if(_loc4_.IGraphicParent)
                  {
                     _loc5_ = _loc4_.IGraphicParent as DisplayObject;
                     _loc6_ = _loc5_.getRect(_loc5_);
                     if(_loc6_.isEmpty())
                     {
                        if(_loc5_.width != 0 || _loc5_.height != 0)
                        {
                           _loc6_.x = _loc5_.x;
                           _loc6_.y = _loc5_.y;
                           _loc6_.width = _loc5_.width;
                           _loc6_.height = _loc5_.height;
                        }
                     }
                     if(!_loc6_.isEmpty())
                     {
                        _loc2_ = _loc6_.clone();
                     }
                  }
               }
            }
            if(Boolean(_currentGraphicsTarget) && !_loc2_)
            {
               _loc7_ = _currentGraphicsTarget.getRect(_currentGraphicsTarget);
               if(_loc7_.isEmpty())
               {
                  if(_currentGraphicsTarget.width != 0 || _currentGraphicsTarget.height != 0)
                  {
                     _loc7_.x = _currentGraphicsTarget.x;
                     _loc7_.y = _currentGraphicsTarget.y;
                     _loc7_.width = _currentGraphicsTarget.width;
                     _loc7_.height = _currentGraphicsTarget.height;
                  }
               }
               if(_loc7_)
               {
                  _loc2_ = _loc7_.clone();
               }
            }
            if(!_loc2_)
            {
               _loc8_ = new Rectangle();
               if(_loc4_)
               {
                  if(_loc4_.graphicsTarget.length != 0)
                  {
                     if(_loc4_.graphicsTarget[0] is IGraphicSkin)
                     {
                        _loc8_.x = _loc4_.graphicsTarget[0].x;
                        _loc8_.y = _loc4_.graphicsTarget[0].y;
                        _loc8_.width = _loc4_.graphicsTarget[0].width;
                        _loc8_.height = _loc4_.graphicsTarget[0].height;
                     }
                     if(_loc8_)
                     {
                        _loc2_ = _loc8_.clone();
                     }
                  }
               }
               else if(graphicsTarget.length != 0)
               {
                  if(graphicsTarget[0] is IGraphicSkin)
                  {
                     _loc8_.x = graphicsTarget[0].x;
                     _loc8_.y = graphicsTarget[0].y;
                     _loc8_.width = graphicsTarget[0].width;
                     _loc8_.height = graphicsTarget[0].height;
                  }
                  if(_loc8_)
                  {
                     _loc2_ = _loc8_.clone();
                  }
               }
            }
            if(Boolean(document) && !_loc2_)
            {
               _loc2_ = new Rectangle(document.x,document.y,document.width,document.height);
            }
            _layoutConstraint.computeLayoutRectangle(param1,_loc2_);
         }
      }
      
      public function set minHeight(param1:Number) : void
      {
         layoutConstraint.minHeight = param1;
      }
      
      public function get stroke() : IGraphicsStroke
      {
         return _stroke;
      }
      
      public function set inheritFill(param1:Boolean) : void
      {
         _inheritFill = param1;
      }
      
      public function get minX() : Number
      {
         return hasLayout ? layoutConstraint.minX : NaN;
      }
      
      public function get minY() : Number
      {
         return hasLayout ? layoutConstraint.minY : NaN;
      }
      
      public function set height(param1:Number) : void
      {
         layoutConstraint.height = param1;
      }
      
      public function set right(param1:Number) : void
      {
         layoutConstraint.right = param1;
      }
      
      public function set bottom(param1:Number) : void
      {
         layoutConstraint.bottom = param1;
      }
      
      public function angleAt(param1:Number) : Number
      {
         return commandStack.pathAngleAt(param1);
      }
      
      public function set stroke(param1:IGraphicsStroke) : void
      {
         var _loc2_:Object = null;
         if(_stroke != param1)
         {
            _loc2_ = _stroke;
            if(_stroke)
            {
               if(_stroke.hasEventManager)
               {
                  _stroke.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
               }
            }
            _stroke = param1;
            if(enableEvents && Boolean(_stroke))
            {
               _stroke.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler,false,0,true);
            }
            initChange("stroke",_loc2_,_stroke,this);
         }
      }
      
      public function get x() : Number
      {
         return hasLayout ? layoutConstraint.x : NaN;
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      public function get y() : Number
      {
         return hasLayout ? layoutConstraint.y : NaN;
      }
      
      public function get geometry() : Array
      {
         initGeometryCollection();
         return _geometry.items;
      }
      
      public function get geometricLength() : Number
      {
         return commandStack.pathLength;
      }
      
      public function get percentWidth() : Number
      {
         return hasLayout ? layoutConstraint.percentWidth : NaN;
      }
      
      public function set minX(param1:Number) : void
      {
         layoutConstraint.minX = param1;
      }
      
      public function preDraw() : void
      {
      }
      
      public function get invalidated() : Boolean
      {
         return _invalidated;
      }
      
      public function get state() : String
      {
         return _state;
      }
      
      public function get minWidth() : Number
      {
         return hasLayout ? layoutConstraint.minWidth : NaN;
      }
      
      public function set minY(param1:Number) : void
      {
         layoutConstraint.minY = param1;
      }
      
      [Bindable("currentStateChange")]
      public function get currentState() : String
      {
         return stateManager ? stateManager.currentState : "";
      }
      
      public function get targetCoordinateSpace() : DisplayObject
      {
         return hasLayout ? layoutConstraint.targetCoordinateSpace : null;
      }
      
      public function get stateEvent() : String
      {
         return _stateEvent;
      }
      
      public function get transformContext() : Matrix
      {
         return _transformContext;
      }
      
      public function set scaleOnLayout(param1:Boolean) : void
      {
         _scaleOnLayout = param1;
      }
      
      public function get layoutConstraint() : LayoutConstraint
      {
         if(!_layoutConstraint)
         {
            layoutConstraint = new LayoutConstraint();
         }
         return _layoutConstraint;
      }
      
      public function set top(param1:Number) : void
      {
         layoutConstraint.top = param1;
      }
      
      public function get maskMode() : String
      {
         return _maskMode ? _maskMode : "clip";
      }
      
      public function initFill(param1:Graphics, param2:Rectangle) : void
      {
         if(parent)
         {
            if(inheritFill && !_fill && parent is Geometry)
            {
               _fill = Geometry(parent).fill;
            }
         }
         if(_fill)
         {
            if(_fill is ITransformablePaint)
            {
               (_fill as ITransformablePaint).requester = this;
            }
            _fill.begin(param1,param2 ? param2 : null);
            CommandStack.currentFill = _fill;
         }
         else
         {
            CommandStack.currentFill = null;
         }
      }
      
      public function get bounds() : Rectangle
      {
         return commandStack.bounds;
      }
      
      public function get geometryCollection() : GeometryCollection
      {
         initGeometryCollection();
         return _geometry;
      }
      
      private function processMethodQueue(param1:Event) : void
      {
         if(methodQueue.length == 0)
         {
            return;
         }
         var _loc2_:Array = methodQueue;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_[_loc4_].method.apply(null,[_loc2_[_loc4_].args[0]]);
            _loc4_++;
         }
         methodQueue.length = 0;
         _loc2_.length = 0;
         if(methodQueue.length == 0 && Boolean(_stage))
         {
            _stage.removeEventListener(Event.ENTER_FRAME,processMethodQueue);
         }
      }
      
      public function get maxWidth() : Number
      {
         return hasLayout ? layoutConstraint.maxWidth : NaN;
      }
      
      public function endDraw(param1:Graphics) : void
      {
         var _loc2_:IGeometryComposition = null;
         if(fill)
         {
            param1.lineStyle.apply(param1,null);
            fill.end(param1);
         }
         if(Boolean(stroke) && !fill)
         {
            param1.moveTo.call(param1,null,null);
         }
         if(_geometry)
         {
            for each(_loc2_ in geometry)
            {
               _loc2_.draw(param1,null);
            }
         }
         CommandStack.unstackAlpha();
         dispatchEvent(new DegrafaEvent(DegrafaEvent.RENDER));
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 != _alpha)
         {
            initChange("alpha",alpha,_alpha = param1,this);
         }
      }
      
      public function get clippingRectangle() : Rectangle
      {
         return _clippingRectangle;
      }
      
      public function set transform(param1:ITransform) : void
      {
         var _loc2_:Object = null;
         if(Boolean(parent) && Boolean((parent as Geometry).transform))
         {
            _transformContext = (parent as Geometry).transform.getTransformFor(parent as Geometry);
         }
         if(_transform != param1)
         {
            _loc2_ = _transform;
            if(_transform)
            {
               if(_transform.hasEventManager)
               {
                  _transform.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
               }
            }
            _transform = param1;
            if(enableEvents && Boolean(_transform))
            {
               _transform.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler,false,0,true);
            }
            initChange("transform",_loc2_,_transform,this);
         }
      }
      
      public function set verticalCenter(param1:Number) : void
      {
         layoutConstraint.verticalCenter = param1;
      }
      
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(_visible != param1)
         {
            _loc2_ = _visible;
            _visible = param1;
            initChange("visible",_loc2_,_visible,this);
         }
      }
      
      public function set maxX(param1:Number) : void
      {
         layoutConstraint.maxX = param1;
      }
      
      public function set geometry(param1:Array) : void
      {
         initGeometryCollection();
         _geometry.items = param1;
      }
      
      public function get mask() : IGeometryComposition
      {
         return _mask;
      }
      
      public function set x(param1:Number) : void
      {
         layoutConstraint.x = param1;
      }
      
      private function initGraphicsTargetCollection() : void
      {
         if(!_graphicsTarget)
         {
            _graphicsTarget = new DisplayObjectCollection();
            if(enableEvents)
            {
               _graphicsTarget.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
         }
      }
      
      public function set y(param1:Number) : void
      {
         layoutConstraint.y = param1;
      }
      
      public function set autoClearGraphicsTarget(param1:Boolean) : void
      {
         _autoClearGraphicsTarget = param1;
      }
      
      public function set maxY(param1:Number) : void
      {
         layoutConstraint.maxY = param1;
      }
      
      private function addUpdateTarget(param1:IUIComponent, param2:Object) : void
      {
         if(!targetDictionary[param1])
         {
            targetDictionary[param1] = {};
            targetDictionary[param1].data = param2;
         }
         else
         {
            targetDictionary[param1].data = param2;
         }
      }
      
      private function initDrawQueue() : void
      {
         _stage.addEventListener(Event.ENTER_FRAME,processMethodQueue);
      }
      
      public function get isInvalidated() : Boolean
      {
         return _invalidated;
      }
      
      private function requestTarget(param1:IUIComponent) : Object
      {
         return targetDictionary[param1];
      }
      
      public function set maskSpace(param1:String) : void
      {
         if(param1 == "local" || param1 == "global")
         {
            if(_mask)
            {
               initChange("maskSpace",maskSpace,_maskSpace = param1,this);
            }
            else
            {
               _maskSpace = param1;
            }
         }
      }
      
      public function set fill(param1:IGraphicsFill) : void
      {
         var _loc2_:Object = null;
         if(_fill != param1)
         {
            _loc2_ = _fill;
            if(_fill)
            {
               if(_fill.hasEventManager)
               {
                  _fill.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
               }
            }
            _fill = param1;
            if(enableEvents && Boolean(_fill))
            {
               _fill.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler,false,0,true);
            }
            initChange("fill",_loc2_,_fill,this);
         }
      }
      
      public function set percentWidth(param1:Number) : void
      {
         layoutConstraint.percentWidth = param1;
      }
      
      public function get inheritStroke() : Boolean
      {
         return _inheritStroke;
      }
      
      public function set invalidated(param1:Boolean) : void
      {
         if(_invalidated != param1)
         {
            _invalidated = param1;
            if(_invalidated && _isRootGeometry)
            {
               drawToTargets();
            }
         }
      }
      
      public function get inheritFill() : Boolean
      {
         return _inheritFill;
      }
      
      public function set state(param1:String) : void
      {
         _state = param1;
      }
      
      public function drawToTargets() : void
      {
         var _loc1_:Object = null;
         if(_graphicsTarget)
         {
            for each(_loc1_ in _graphicsTarget.items)
            {
               queueDraw(_loc1_,_loc1_.graphics,null);
            }
         }
         _currentGraphicsTarget = null;
      }
      
      public function get height() : Number
      {
         return hasLayout ? layoutConstraint.height : NaN;
      }
      
      public function set minWidth(param1:Number) : void
      {
         layoutConstraint.minWidth = param1;
      }
      
      public function set stateEvent(param1:String) : void
      {
         _stateEvent = param1;
      }
      
      public function set decorators(param1:Array) : void
      {
         initDecoratorsCollection();
         hasDecorators = Boolean(param1) && Boolean(param1.length);
         _decorators.items = param1;
      }
      
      public function set horizontalCenter(param1:Number) : void
      {
         layoutConstraint.horizontalCenter = param1;
      }
      
      private function removeTarget(param1:IUIComponent) : void
      {
         delete targetDictionary[param1];
      }
      
      public function get decoratorCollection() : DecoratorCollection
      {
         initDecoratorsCollection();
         return _decorators;
      }
      
      public function set targetCoordinateSpace(param1:DisplayObject) : void
      {
         layoutConstraint.targetCoordinateSpace = param1;
      }
      
      public function set currentState(param1:String) : void
      {
         stateManager.currentState = param1;
      }
      
      public function get transformBounds() : Rectangle
      {
         return commandStack.transformBounds;
      }
      
      public function draw(param1:Graphics, param2:Rectangle) : void
      {
         if(!visible)
         {
            return;
         }
         CommandStack.stackAlpha(alpha);
         if(!param1)
         {
            return;
         }
         if(!commandStack.draw(param1,param2))
         {
            endDraw(param1);
         }
      }
      
      public function set transformContext(param1:Matrix) : void
      {
         _transformContext = param1;
      }
      
      public function set layoutConstraint(param1:LayoutConstraint) : void
      {
         var _loc2_:Object = null;
         if(_layoutConstraint != param1)
         {
            _loc2_ = _layoutConstraint;
            if(_layoutConstraint)
            {
               if(_layoutConstraint.hasEventManager)
               {
                  _layoutConstraint.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
               }
            }
            _layoutConstraint = param1;
            if(enableEvents)
            {
               _layoutConstraint.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler,false,0,true);
            }
            initChange("layoutConstraint",_loc2_,_layoutConstraint,this);
            hasLayout = true;
         }
      }
      
      private function drawToTarget(param1:Object) : void
      {
         if(param1)
         {
            if(autoClearGraphicsTarget)
            {
               param1.graphics.clear();
            }
            _currentGraphicsTarget = param1 as Sprite;
            draw(param1.graphics,null);
         }
      }
      
      public function get scaleOnLayout() : Boolean
      {
         return _scaleOnLayout;
      }
      
      public function get top() : Number
      {
         return hasLayout ? layoutConstraint.top : NaN;
      }
      
      public function set maxHeight(param1:Number) : void
      {
         layoutConstraint.maxHeight = param1;
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
      }
      
      public function set maskMode(param1:String) : void
      {
         if(param1 == "alpha" || param1 == "clip" || param1 == "svgClip" || param1 == "svgMask" || param1 == "unMask")
         {
            if(_mask)
            {
               initChange("maskMode",maskMode,_maskMode = param1,this);
            }
            else
            {
               _maskMode = param1;
            }
         }
      }
      
      public function get layoutRectangle() : Rectangle
      {
         return _layoutRectangle ? _layoutRectangle : bounds;
      }
      
      private function initFilterCollection() : void
      {
         if(!_filters)
         {
            _filters = new FilterCollection();
            _filters.parent = this;
            if(enableEvents)
            {
               _filters.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
         }
      }
      
      public function initStroke(param1:Graphics, param2:Rectangle) : void
      {
         if(parent)
         {
            if(inheritStroke && !_stroke && parent is Geometry)
            {
               _stroke = Geometry(parent).stroke;
            }
         }
         if(_stroke)
         {
            if(_stroke is ITransformablePaint)
            {
               (_stroke as ITransformablePaint).requester = this;
            }
            _stroke.apply(param1,param2 ? param2 : null);
            CommandStack.currentStroke = _stroke;
         }
         else
         {
            param1.lineStyle();
            CommandStack.currentStroke = null;
         }
      }
      
      public function get verticalCenter() : Number
      {
         return hasLayout ? layoutConstraint.verticalCenter : NaN;
      }
      
      public function get transform() : ITransform
      {
         return _transform;
      }
      
      public function get alpha() : Number
      {
         return isNaN(_alpha) ? 1 : _alpha;
      }
      
      public function get maxX() : Number
      {
         return hasLayout ? layoutConstraint.maxX : NaN;
      }
      
      public function get maxY() : Number
      {
         return hasLayout ? layoutConstraint.maxY : NaN;
      }
      
      public function set triggers(param1:Array) : void
      {
         var _loc2_:ITrigger = null;
         _triggers = param1;
         if(_triggers)
         {
            for each(_loc2_ in _triggers)
            {
               _loc2_.triggerParent = this;
            }
         }
         if(Boolean(param1) && param1.length != 0)
         {
            hasTriggers = true;
         }
         else
         {
            hasTriggers = false;
         }
      }
      
      public function get autoClearGraphicsTarget() : Boolean
      {
         return _autoClearGraphicsTarget;
      }
      
      public function get maskSpace() : String
      {
         return _maskSpace ? _maskSpace : "local";
      }
      
      public function get fill() : IGraphicsFill
      {
         return _fill;
      }
      
      public function set maxWidth(param1:Number) : void
      {
         layoutConstraint.maxWidth = param1;
      }
      
      private function initDecoratorsCollection() : void
      {
         if(!_decorators)
         {
            _decorators = new DecoratorCollection();
            if(enableEvents)
            {
               _decorators.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler,false,0,true);
            }
         }
      }
      
      public function set width(param1:Number) : void
      {
         layoutConstraint.width = param1;
      }
      
      public function get decorators() : Array
      {
         initDecoratorsCollection();
         return _decorators.items;
      }
      
      public function get horizontalCenter() : Number
      {
         return hasLayout ? layoutConstraint.horizontalCenter : NaN;
      }
      
      public function set clippingRectangle(param1:Rectangle) : void
      {
         var _loc2_:Rectangle = null;
         if(_clippingRectangle != param1)
         {
            _loc2_ = _clippingRectangle;
            _clippingRectangle = param1;
            initChange("clippingRectangle",_loc2_,_clippingRectangle,this);
         }
      }
      
      public function set percentHeight(param1:Number) : void
      {
         layoutConstraint.percentHeight = param1;
      }
      
      protected function propertyChangeHandler(param1:PropertyChangeEvent) : void
      {
         if(!parent)
         {
            dispatchEvent(param1);
            drawToTargets();
         }
         else
         {
            dispatchEvent(param1);
         }
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function get maxHeight() : Number
      {
         return hasLayout ? layoutConstraint.maxHeight : NaN;
      }
      
      private function initLayoutChangeWatcher(param1:IUIComponent) : void
      {
         var _loc2_:Rectangle = new Rectangle(param1.x,param1.y,param1.width,param1.height);
         var _loc3_:Array = [];
         _loc3_.push(ChangeWatcher.watch(param1,"width",onTargetChange,true));
         _loc3_.push(ChangeWatcher.watch(param1,"height",onTargetChange,true));
         _loc3_.push(ChangeWatcher.watch(param1,"x",onTargetChange,true));
         _loc3_.push(ChangeWatcher.watch(param1,"y",onTargetChange,true));
         if(!requestTarget(param1))
         {
            addUpdateTarget(param1,{
               "oldbounds":_loc2_,
               "watchers":_loc3_
            });
         }
      }
      
      public function get triggers() : Array
      {
         return _triggers;
      }
      
      public function get isRootGeometry() : Boolean
      {
         return _isRootGeometry;
      }
      
      public function get graphicsTargetCollection() : DisplayObjectCollection
      {
         initGraphicsTargetCollection();
         return _graphicsTarget;
      }
      
      public function styleChanged(param1:String) : void
      {
      }
      
      public function get width() : Number
      {
         return hasLayout ? _layoutConstraint.width : NaN;
      }
      
      public function set styleName(param1:Object) : void
      {
         _styleName = param1;
      }
      
      public function get percentHeight() : Number
      {
         return hasLayout ? layoutConstraint.percentHeight : NaN;
      }
      
      public function set IGraphicParent(param1:IGraphic) : void
      {
         if(parent == null)
         {
            if(_IGraphicParent != param1)
            {
               _IGraphicParent = param1;
            }
         }
      }
      
      public function set mask(param1:IGeometryComposition) : void
      {
         var _loc2_:IGeometryComposition = null;
         if(_mask != param1 && param1 != this)
         {
            if(_mask)
            {
               Geometry(_mask).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
            _loc2_ = _mask;
            _mask = param1;
            if(enableEvents && Boolean(_mask))
            {
               Geometry(_mask).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
            initChange("mask",_loc2_,_mask,this);
         }
      }
      
      private function initGeometryCollection() : void
      {
         if(!_geometry)
         {
            _geometry = new GeometryCollection();
            _geometry.parent = this;
            if(enableEvents)
            {
               _geometry.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
         }
      }
      
      public function get IGraphicParent() : IGraphic
      {
         return _IGraphicParent;
      }
      
      public function pointAt(param1:Number) : Point
      {
         return commandStack.pathPointAt(param1);
      }
      
      public function get styleName() : Object
      {
         return _styleName;
      }
      
      public function clearGraphicsTargets() : void
      {
         var _loc1_:Object = null;
         if(graphicsTarget)
         {
            for each(_loc1_ in graphicsTarget)
            {
               if(_loc1_)
               {
                  _loc1_.graphics.clear();
               }
            }
         }
      }
      
      private function queueDraw(... rest) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DisplayObject = null;
         for each(_loc2_ in methodQueue)
         {
            if(_loc2_.args[0] == rest[0])
            {
               return;
            }
         }
         methodQueue.push({
            "method":drawToTarget,
            "args":rest
         });
         if(_stage)
         {
            _stage.addEventListener(Event.ENTER_FRAME,processMethodQueue,false,0,true);
         }
         else if(graphicsTarget.length)
         {
            for each(_loc3_ in graphicsTarget)
            {
               if(_loc3_.stage)
               {
                  _stage = _loc3_.stage;
                  _stage.addEventListener(Event.ENTER_FRAME,processMethodQueue,false,0,true);
                  break;
               }
            }
         }
      }
      
      public function set filters(param1:Array) : void
      {
         var _loc2_:Array = null;
         initFilterCollection();
         if(_filters.items != param1)
         {
            _loc2_ = _filters.items;
            _filters.items = param1;
            initChange("filters",_loc2_,_filters.items,this);
         }
         if(Boolean(param1) && param1.length != 0)
         {
            hasFilters = true;
         }
         else
         {
            hasFilters = false;
         }
      }
      
      public function set graphicsTarget(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:DisplayObject = null;
         if(!param1)
         {
            _graphicsTarget.items = [];
            methodQueue.length = 0;
            return;
         }
         for each(_loc2_ in param1)
         {
            if(!_loc2_)
            {
               return;
            }
         }
         initGraphicsTargetCollection();
         _graphicsTarget.items = param1;
         for each(_loc3_ in _graphicsTarget.items)
         {
            if(!(_loc3_ is IGraphicSkin))
            {
               _loc3_.addEventListener(Event.RENDER,onTargetRender);
               _loc3_.addEventListener(Event.ADDED_TO_STAGE,onTargetRender);
               if(_loc3_ is IUIComponent)
               {
                  _loc3_.addEventListener(FlexEvent.UPDATE_COMPLETE,onTargetRender);
               }
            }
         }
         _isRootGeometry = true;
      }
      
      public function get filters() : Array
      {
         initFilterCollection();
         return _filters.items;
      }
      
      public function get graphicsTarget() : Array
      {
         initGraphicsTargetCollection();
         return _graphicsTarget.items;
      }
      
      public function get commandStack() : CommandStack
      {
         if(!_commandStack)
         {
            _commandStack = new CommandStack(this);
         }
         return _commandStack;
      }
   }
}

