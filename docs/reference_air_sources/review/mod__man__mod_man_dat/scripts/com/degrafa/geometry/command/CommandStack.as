package com.degrafa.geometry.command
{
   import com.degrafa.GeometryComposition;
   import com.degrafa.core.IGraphicsFill;
   import com.degrafa.core.IGraphicsStroke;
   import com.degrafa.core.collections.DegrafaCursor;
   import com.degrafa.decorators.IDecorator;
   import com.degrafa.decorators.IRenderDecorator;
   import com.degrafa.geometry.Geometry;
   import com.degrafa.geometry.display.IDisplayObjectProxy;
   import com.degrafa.geometry.utilities.GeometryUtils;
   import com.degrafa.transform.TransformBase;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.registerClassAlias;
   
   public final class CommandStack
   {
      
      public static var currentStroke:IGraphicsStroke;
      
      private static var svgClipMode:Array;
      
      public static var currentFill:IGraphicsFill;
      
      public static var currentContext:Graphics;
      
      public static const IS_REGISTERED:Boolean = !registerClassAlias("com.degrafa.geometry.command.CommandStack",CommandStack);
      
      public static var transMatrix:Matrix = new Matrix();
      
      public static var currentLayoutMatrix:Matrix = new Matrix();
      
      public static var currentTransformMatrix:Matrix = new Matrix();
      
      private static var transXY:Point = new Point();
      
      private static var transCP:Point = new Point();
      
      private static var alphaStack:Array = [];
      
      private static const _maskFilt:Array = [new ColorMatrixFilter([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.2125,0.7154,0.0721,0,0])];
      
      private static var _cacheable:Array = ["alphaStack","currentContext","currentFill","currentLayoutMatrix","currentStroke","currentTransformMatrix","transMatrix"];
      
      private var hasmask:Boolean;
      
      private var _container:Sprite;
      
      private var lineTo:Function;
      
      private var _pathLength:Number = 0;
      
      public var source:Array = [];
      
      private var hasRenderDecoration:Boolean;
      
      private var hasfilters:Boolean;
      
      public var parent:CommandStackItem;
      
      private var moveTo:Function;
      
      private var _fxShape:Shape;
      
      private var _original:Sprite;
      
      public var owner:Geometry;
      
      private var _maskRender:Shape;
      
      private var _globalRenderDelegateStart:Array;
      
      private var curveTo:Function;
      
      private var _mask:Sprite;
      
      private var _invalidated:Boolean = true;
      
      private var _transformedPathLength:Number = 0;
      
      private var isComp:Boolean;
      
      private var _bounds:Rectangle = new Rectangle();
      
      private var _lengthInvalidated:Boolean = true;
      
      private var _cursor:DegrafaCursor;
      
      private var _globalRenderDelegateEnd:Array;
      
      public function CommandStack(param1:Geometry = null)
      {
         super();
         this.owner = param1;
      }
      
      public static function stackAlpha(param1:Number) : void
      {
         if(!alphaStack.length)
         {
            alphaStack.push(param1);
         }
         else
         {
            alphaStack.push(param1 * alphaStack[alphaStack.length - 1]);
         }
      }
      
      public static function unstackAlpha() : void
      {
         if(!alphaStack.length)
         {
            trace("error: unmatched unstackAlpha calls");
            return;
         }
         --alphaStack.length;
      }
      
      public static function get currentAlpha() : Number
      {
         if(!alphaStack.length)
         {
            return 1;
         }
         return alphaStack[alphaStack.length - 1];
      }
      
      public static function getSettingsCache() : Object
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:Object = {};
         for each(_loc2_ in _cacheable)
         {
            _loc3_ = CommandStack[_loc2_];
            if(_loc3_ is Array)
            {
               _loc1_[_loc2_] = (_loc3_ as Array).concat();
            }
            else if(_loc3_ is Matrix)
            {
               _loc1_[_loc2_] = (_loc3_ as Matrix).clone();
            }
            else
            {
               _loc1_[_loc2_] = CommandStack[_loc2_];
            }
         }
         return _loc1_;
      }
      
      public static function resetCacheValues(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            CommandStack[_loc2_] = param1[_loc2_];
         }
      }
      
      public static function removeContextualSettings() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         for each(_loc1_ in _cacheable)
         {
            _loc2_ = CommandStack[_loc1_];
            if(_loc2_ is Array)
            {
               (_loc2_ as Array).length = 0;
            }
            if(_loc2_ is Matrix)
            {
               (_loc2_ as Matrix).identity();
            }
         }
      }
      
      public function pathAngleAt(param1:Number) : Number
      {
         var n:Number;
         var tLength:Number;
         var lastLength:Number;
         var curLength:Number = NaN;
         var item:CommandStackItem = null;
         var firstSegment:CommandStackItem = null;
         var t:Number = param1;
         if(!source.length)
         {
            return 0;
         }
         t = cleant(t);
         curLength = 0;
         if(t == 0)
         {
            firstSegment = firstSegmentWithLength;
            curLength = firstSegment.segmentLength;
            return firstSegment.segmentAngleAt(t);
         }
         if(t == 1)
         {
            return lastSegmentWithLength.segmentAngleAt(t);
         }
         tLength = t * pathLength;
         lastLength = 0;
         n = source.length;
         for each(item in source)
         {
            var _loc5_:CommandStackItem = item;
            with(_loc5_)
            {
               
               if(type != 0)
               {
                  curLength += segmentLength;
                  if(tLength <= curLength)
                  {
                     return segmentAngleAt((tLength - lastLength) / segmentLength);
                  }
               }
               lastLength = curLength;
            }
            else
            {
            }
         }
      }
      return 0;
   }
   
   public function addCubicBezierTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:int = 1) : void
   {
      GeometryUtils.cubicToQuadratic(param1,param2,param3,param4,param5,param6,param7,param8,1,this);
   }
   
   public function pathPointAt(param1:Number) : Point
   {
      var n:Number;
      var tLength:Number;
      var lastLength:Number;
      var curLength:Number = NaN;
      var item:CommandStackItem = null;
      var firstSegment:CommandStackItem = null;
      var t:Number = param1;
      if(!source.length)
      {
         return new Point(0,0);
      }
      t = cleant(t);
      curLength = 0;
      if(t == 0)
      {
         firstSegment = firstSegmentWithLength;
         curLength = firstSegment.segmentLength;
         return adjustPointToLayoutAndTransform(firstSegment.segmentPointAt(t));
      }
      if(t == 1)
      {
         return adjustPointToLayoutAndTransform(lastSegmentWithLength.segmentPointAt(t));
      }
      tLength = t * pathLength;
      lastLength = 0;
      n = source.length;
      for each(item in source)
      {
         var _loc5_:CommandStackItem = item;
         with(_loc5_)
         {
            
            if(type != 0)
            {
               curLength += segmentLength;
               if(tLength <= curLength)
               {
                  return adjustPointToLayoutAndTransform(segmentPointAt((tLength - lastLength) / segmentLength));
               }
            }
            lastLength = curLength;
         }
         else
         {
         }
      }
   }
   return new Point(0,0);
}

public function set globalRenderDelegateStart(param1:Array) : void
{
   if(_globalRenderDelegateStart != param1)
   {
      _globalRenderDelegateStart = param1;
      invalidated = true;
   }
}

public function set lengthInvalidated(param1:Boolean) : void
{
   if(_lengthInvalidated != param1)
   {
      _lengthInvalidated = param1;
   }
}

public function get invalidated() : Boolean
{
   return _invalidated;
}

public function set invalidated(param1:Boolean) : void
{
   if(_invalidated != param1)
   {
      _invalidated = param1;
      if(_invalidated)
      {
         lengthInvalidated = true;
      }
   }
}

private function updateToFilterRectangle(param1:Rectangle, param2:DisplayObject) : Rectangle
{
   var filter:BitmapFilter = null;
   var bitmapData:BitmapData = null;
   var filterRect:Rectangle = param1;
   var source:DisplayObject = param2;
   try
   {
      bitmapData = new BitmapData(filterRect.width,filterRect.height,true,0);
   }
   catch(e:Error)
   {
      trace(e + ":" + filterRect);
      return filterRect;
   }
   for each(filter in owner.filters)
   {
      filterRect = filterRect.union(bitmapData.generateFilterRect(filterRect,filter));
   }
   return filterRect;
}

public function getItem(param1:int) : CommandStackItem
{
   return source[param1];
}

public function addLineTo(param1:Number, param2:Number) : CommandStackItem
{
   var _loc3_:int = source.push(new CommandStackItem(CommandStackItem.LINE_TO,param1,param2,NaN,NaN,NaN,NaN)) - 1;
   updateItemRelations(source[_loc3_],_loc3_);
   source[_loc3_].indexInParent = _loc3_;
   source[_loc3_].parent = this;
   invalidated = true;
   return source[_loc3_];
}

private function processDelegateArray(param1:Array, param2:CommandStackItem, param3:Graphics, param4:int) : CommandStackItem
{
   var _loc5_:Function = null;
   for each(_loc5_ in param1)
   {
      param2 = _loc5_(this,param2,param3,param4);
   }
   return param2;
}

public function get lastNonCommandStackItem() : CommandStackItem
{
   var _loc1_:int = source.length - 1;
   if(_loc1_ <= 0)
   {
      return source[0];
   }
   if(source[_loc1_].type != CommandStackItem.COMMAND_STACK)
   {
      return source[_loc1_];
   }
   return CommandStackItem(source[_loc1_]).commandStack.lastNonCommandStackItem;
}

public function addMoveTo(param1:Number, param2:Number) : CommandStackItem
{
   var _loc3_:int = source.push(new CommandStackItem(CommandStackItem.MOVE_TO,param1,param2,NaN,NaN,NaN,NaN)) - 1;
   updateItemRelations(source[_loc3_],_loc3_);
   source[_loc3_].indexInParent = _loc3_;
   return source[_loc3_];
}

private function delegateGraphicsCall(param1:String, param2:Graphics, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0) : *
{
   var _loc9_:IRenderDecorator = null;
   for each(_loc9_ in owner.decorators)
   {
      if(!_loc9_.isValid)
      {
         continue;
      }
      switch(param1)
      {
         case "moveTo":
            return _loc9_.moveTo(param3,param4,param2);
         case "lineTo":
            return _loc9_.lineTo(param3,param4,param2);
         case "curveTo":
            return _loc9_.curveTo(param5,param6,param7,param8,param2);
      }
   }
}

public function get firstSegmentWithLength() : CommandStackItem
{
   var _loc1_:CommandStackItem = null;
   for each(_loc1_ in source)
   {
      switch(_loc1_.type)
      {
         case 1:
         case 2:
            return _loc1_;
         case 4:
            return _loc1_.commandStack.firstSegmentWithLength;
      }
   }
   return source[0];
}

private function renderCommandStack(param1:Graphics, param2:Rectangle, param3:DegrafaCursor = null) : void
{
   var item:CommandStackItem = null;
   var graphics:Graphics = param1;
   var rc:Rectangle = param2;
   var cursor:DegrafaCursor = param3;
   while(cursor.moveNext())
   {
      item = cursor.current;
      if(item.renderDelegateStart)
      {
         item = processDelegateArray(item.renderDelegateStart,item,graphics,cursor.currentIndex);
      }
      if(_globalRenderDelegateStart)
      {
         item = processDelegateArray(_globalRenderDelegateStart,item,graphics,cursor.currentIndex);
      }
      if(!item.skip)
      {
         with(item)
         {
            
            switch(type)
            {
               case CommandStackItem.MOVE_TO:
                  if(transMatrix)
                  {
                     transXY.x = x;
                     transXY.y = y;
                     transXY = transMatrix.transformPoint(transXY);
                     if(hasRenderDecoration)
                     {
                        delegateGraphicsCall("moveTo",graphics,transXY.x,transXY.y);
                     }
                     else
                     {
                        moveTo(transXY.x,transXY.y);
                     }
                  }
                  else if(hasRenderDecoration)
                  {
                     delegateGraphicsCall("moveTo",graphics,x,y);
                  }
                  else
                  {
                     moveTo(x,y);
                  }
                  break;
               case CommandStackItem.LINE_TO:
                  if(transMatrix)
                  {
                     transXY.x = x;
                     transXY.y = y;
                     transXY = transMatrix.transformPoint(transXY);
                     if(hasRenderDecoration)
                     {
                        delegateGraphicsCall("lineTo",graphics,transXY.x,transXY.y);
                     }
                     else
                     {
                        lineTo(transXY.x,transXY.y);
                     }
                  }
                  else if(hasRenderDecoration)
                  {
                     delegateGraphicsCall("lineTo",graphics,x,y);
                  }
                  else
                  {
                     lineTo(x,y);
                  }
                  break;
               case CommandStackItem.CURVE_TO:
                  if(transMatrix)
                  {
                     transXY.x = x1;
                     transXY.y = y1;
                     transCP.x = cx;
                     transCP.y = cy;
                     transXY = transMatrix.transformPoint(transXY);
                     transCP = transMatrix.transformPoint(transCP);
                     if(hasRenderDecoration)
                     {
                        delegateGraphicsCall("curveTo",graphics,0,0,transCP.x,transCP.y,transXY.x,transXY.y);
                     }
                     else
                     {
                        curveTo(transCP.x,transCP.y,transXY.x,transXY.y);
                     }
                  }
                  else if(hasRenderDecoration)
                  {
                     delegateGraphicsCall("curveTo",graphics,0,0,cx,cy,x1,y1);
                  }
                  else
                  {
                     curveTo(cx,cy,x1,y1);
                  }
                  break;
               case CommandStackItem.DELEGATE_TO:
                  item.delegate(this,item,graphics,cursor.currentIndex);
                  break;
               case CommandStackItem.COMMAND_STACK:
                  renderCommandStack(graphics,rc,new DegrafaCursor(commandStack.source));
            }
         }
         if(item.renderDelegateEnd)
         {
            item = processDelegateArray(item.renderDelegateEnd,item,graphics,cursor.currentIndex);
         }
         if(_globalRenderDelegateEnd)
         {
            item = processDelegateArray(_globalRenderDelegateEnd,item,graphics,cursor.currentIndex);
         }
      }
   }
}

public function get bounds() : Rectangle
{
   var _loc1_:CommandStackItem = null;
   if(!invalidated)
   {
      return _bounds;
   }
   _bounds.setEmpty();
   for each(_loc1_ in source)
   {
      if(_loc1_.bounds)
      {
         _bounds = _bounds.union(_loc1_.bounds);
      }
   }
   invalidated = false;
   if(_bounds.height != 0.0001 && _bounds.height != int(_bounds.height))
   {
      _bounds.height = int(_bounds.height * 10000) / 10000;
   }
   if(_bounds.width != 0.0001 && _bounds.width != int(_bounds.width))
   {
      _bounds.width = int(_bounds.width * 10000) / 10000;
   }
   if(_bounds.isEmpty())
   {
      invalidated = true;
   }
   return _bounds;
}

public function get globalRenderDelegateEnd() : Array
{
   return _globalRenderDelegateEnd ? _globalRenderDelegateEnd : null;
}

public function addCommandStack(param1:CommandStack) : CommandStackItem
{
   var _loc2_:int = source.push(new CommandStackItem(CommandStackItem.COMMAND_STACK,NaN,NaN,NaN,NaN,NaN,NaN,param1)) - 1;
   updateItemRelations(source[_loc2_],_loc2_);
   source[_loc2_].indexInParent = _loc2_;
   source[_loc2_].parent = this;
   invalidated = true;
   return source[_loc2_];
}

public function addItemAt(param1:CommandStackItem, param2:int = -1) : CommandStackItem
{
   var _loc3_:int = param2;
   if(_loc3_ == -1)
   {
      _loc3_ = source.push(param1) - 1;
   }
   else
   {
      source.splice(_loc3_,0,param1);
      _loc3_ += -1;
   }
   updateItemRelations(source[_loc3_],_loc3_);
   param1.indexInParent = _loc3_;
   param1.parent = this;
   invalidated = true;
   return source[_loc3_];
}

public function get lengthInvalidated() : Boolean
{
   return _lengthInvalidated;
}

public function draw(param1:Graphics, param2:Rectangle) : Boolean
{
   var _loc3_:DisplayObject = null;
   var _loc4_:DisplayObject = null;
   var _loc5_:Matrix = null;
   var _loc6_:Object = null;
   var _loc7_:Rectangle = null;
   var _loc8_:BitmapData = null;
   var _loc9_:Matrix = null;
   if(!(isComp = owner is GeometryComposition && (owner.hasFilters || Boolean(owner.mask))))
   {
      if(source.length == 0 && !(owner is IDisplayObjectProxy))
      {
         return false;
      }
   }
   currentContext = param1;
   predraw();
   if(owner is IDisplayObjectProxy)
   {
      if(!IDisplayObjectProxy(owner).displayObject)
      {
         return false;
      }
      _loc3_ = IDisplayObjectProxy(owner).displayObject;
      if(owner.hasFilters)
      {
         _loc3_.filters = owner.filters;
      }
      else if(_loc3_.filters.length)
      {
         _loc3_.filters = [];
      }
      if(Boolean(transMatrix) && (Boolean(IDisplayObjectProxy(owner).transformBeforeRender) || Boolean(owner._layoutMatrix && IDisplayObjectProxy(owner).layoutMode == "scale")))
      {
         if(Sprite(_loc3_).numChildren != 0)
         {
            _loc4_ = Sprite(_loc3_).getChildAt(0);
            if(!IDisplayObjectProxy(owner).transformBeforeRender)
            {
               _loc4_.transform.matrix = CommandStack.currentLayoutMatrix;
            }
            else if(IDisplayObjectProxy(owner).layoutMode == "scale")
            {
               _loc4_.transform.matrix = CommandStack.transMatrix;
            }
            else if(owner._layoutMatrix)
            {
               _loc5_ = owner._layoutMatrix.clone();
               _loc5_.a = 1;
               _loc5_.d = 1;
               _loc5_.concat(CommandStack.currentTransformMatrix);
               _loc4_.transform.matrix = _loc5_;
            }
            else
            {
               _loc4_.transform.matrix = CommandStack.currentTransformMatrix;
            }
         }
      }
      if(!svgClipMode)
      {
         owner.initFill(param1,param2);
      }
      if(!svgClipMode)
      {
         owner.initStroke(param1,param2);
      }
      renderBitmapDatatoContext(IDisplayObjectProxy(owner).displayObject,param1,!IDisplayObjectProxy(owner).transformBeforeRender,param2);
      return false;
   }
   _cursor = new DegrafaCursor(source);
   hasmask = owner.mask != null;
   hasfilters = owner.hasFilters;
   if(hasfilters || hasmask)
   {
      if(!_fxShape)
      {
         _fxShape = new Shape();
         _container = new Sprite();
         _original = new Sprite();
         _original.addChild(_fxShape);
         _container.addChild(_original);
      }
      else
      {
         _fxShape.graphics.clear();
      }
      if(hasmask)
      {
         if(!_maskRender)
         {
            _mask = new Sprite();
            _maskRender = new Shape();
            _mask.addChild(_maskRender);
            _container.addChild(_mask);
         }
         _maskRender.graphics.clear();
         _mask.graphics.clear();
         if(owner.maskSpace == "local" && Boolean(transMatrix))
         {
            _mask.transform.matrix = transMatrix;
         }
         else
         {
            _mask.transform.matrix = new Matrix();
         }
         _loc6_ = getSettingsCache();
         if(owner.maskMode == "svgClip" || owner.maskMode == "clip")
         {
            if(owner.maskMode == "svgClip")
            {
               _maskRender.graphics.lineStyle();
               _maskRender.graphics.beginFill(0,1);
            }
            _original.cacheAsBitmap = _mask.cacheAsBitmap = false;
            if(_maskRender.filters.length)
            {
               _maskRender.filters = [];
               _maskRender.blendMode = "normal";
            }
            removeContextualSettings();
            svgClipMode = svgClipMode ? svgClipMode.concat(true) : (owner.maskMode == "svgClip" ? [true] : null);
            if(Geometry(owner.mask).invalidated)
            {
               owner.mask.preDraw();
            }
            owner.mask.draw(_maskRender.graphics,owner.mask.bounds);
            if(svgClipMode)
            {
               --svgClipMode.length;
               if(!svgClipMode.length)
               {
                  svgClipMode = null;
               }
            }
            resetCacheValues(_loc6_);
         }
         else
         {
            removeContextualSettings();
            if(Geometry(owner.mask).invalidated)
            {
               owner.mask.preDraw();
            }
            owner.mask.draw(_maskRender.graphics,owner.mask.bounds);
            if(owner.maskMode == "svgMask")
            {
               _loc7_ = _maskRender.getBounds(_maskRender);
               _loc8_ = new BitmapData(_loc7_.width,_loc7_.height,true,0);
               _loc9_ = new Matrix(1,0,0,1,-_loc7_.x,-_loc7_.y);
               if(_maskRender.filters.length)
               {
                  _maskRender.filters = [];
               }
               _loc8_.draw(_maskRender,_loc9_,null,null,null,true);
               _loc9_.invert();
               _mask.graphics.beginBitmapFill(_loc8_,_loc9_,false,true);
               _mask.graphics.drawRect(_loc7_.x,_loc7_.y,_loc7_.width,_loc7_.height);
               _mask.graphics.endFill();
               _maskRender.filters = _maskFilt;
               _maskRender.blendMode = "alpha";
            }
            else if(_maskRender.filters.length)
            {
               _maskRender.filters = [];
               _maskRender.blendMode = "normal";
            }
            _original.cacheAsBitmap = _mask.cacheAsBitmap = true;
         }
         resetCacheValues(_loc6_);
         if(hasfilters)
         {
            hasfilters = false;
            if(!svgClipMode)
            {
               _fxShape.filters = owner.filters;
            }
            else
            {
               _fxShape.filters = [];
            }
         }
         else if(_fxShape.filters.length)
         {
            _fxShape.filters = [];
         }
         if(owner.maskMode != "unMask")
         {
            _original.mask = _mask;
         }
         else
         {
            _original.mask = null;
         }
      }
      else
      {
         if(_maskRender)
         {
            _mask.cacheAsBitmap = false;
            _maskRender.graphics.clear();
         }
         _original.cacheAsBitmap = false;
         if(_fxShape.mask)
         {
            _fxShape.mask = null;
         }
         if(_fxShape.filters.length)
         {
            _fxShape.filters = [];
         }
      }
      if(!svgClipMode)
      {
         owner.initFill(_fxShape.graphics,param2);
      }
      else
      {
         _fxShape.graphics.beginFill(0,1);
      }
      if(!svgClipMode)
      {
         owner.initStroke(_fxShape.graphics,param2);
      }
      if(owner.hasDecorators)
      {
         initDecorators();
      }
      else
      {
         hasRenderDecoration = false;
      }
      lineTo = _fxShape.graphics.lineTo;
      curveTo = _fxShape.graphics.curveTo;
      moveTo = _fxShape.graphics.moveTo;
      if(!isComp)
      {
         renderCommandStack(_fxShape.graphics,param2,_cursor);
      }
      else
      {
         owner.endDraw(_fxShape.graphics);
      }
      if(owner.hasDecorators)
      {
         endDecorators();
      }
      renderBitmapDatatoContext(_container,param1);
      return isComp;
   }
   if(!svgClipMode)
   {
      owner.initStroke(param1,param2);
   }
   if(!svgClipMode)
   {
      owner.initFill(param1,param2);
   }
   else
   {
      param1.beginFill(0,1);
   }
   if(owner.hasDecorators)
   {
      initDecorators();
   }
   else
   {
      hasRenderDecoration = false;
   }
   lineTo = param1.lineTo;
   curveTo = param1.curveTo;
   moveTo = param1.moveTo;
   renderCommandStack(param1,param2,_cursor);
   if(owner.hasDecorators)
   {
      endDecorators();
   }
   return false;
}

public function addDelegate(param1:Function) : CommandStackItem
{
   var _loc2_:int = source.push(new CommandStackItem(CommandStackItem.DELEGATE_TO)) - 1;
   source[_loc2_].delegate = param1;
   updateItemRelations(source[_loc2_],_loc2_);
   source[_loc2_].indexInParent = _loc2_;
   source[_loc2_].parent = this;
   return source[_loc2_];
}

private function initDecorators() : void
{
   var _loc1_:IDecorator = null;
   hasRenderDecoration = false;
   for each(_loc1_ in owner.decorators)
   {
      _loc1_.initialize(this);
      if(_loc1_ is IRenderDecorator)
      {
         hasRenderDecoration = true;
      }
   }
}

public function set length(param1:int) : void
{
   source.length = param1;
   invalidated = true;
}

public function get firstNonCommandStackItem() : CommandStackItem
{
   var _loc1_:int = source.length - 1;
   if(_loc1_ >= source.length - 1)
   {
      return null;
   }
   if(source[_loc1_].type != CommandStackItem.COMMAND_STACK)
   {
      return source[_loc1_];
   }
   return CommandStackItem(source[_loc1_]).commandStack.firstNonCommandStackItem;
}

public function get transformBounds() : Rectangle
{
   if(transMatrix)
   {
      return TransformBase.transformBounds(_bounds.clone(),transMatrix);
   }
   return _bounds;
}

private function cleant(param1:Number, param2:Number = NaN) : Number
{
   if(isNaN(param1))
   {
      param1 = param2;
   }
   else if(param1 < 0 || param1 > 1)
   {
      param1 %= 1;
      if(param1 == 0)
      {
         param1 = param2;
      }
      else if(param1 < 0)
      {
         param1 += 1;
      }
   }
   return param1;
}

private function endDecorators() : void
{
   var _loc1_:IDecorator = null;
   hasRenderDecoration = false;
   for each(_loc1_ in owner.decorators)
   {
      _loc1_.end(this);
      if(_loc1_ is IRenderDecorator)
      {
         hasRenderDecoration = true;
      }
   }
}

public function get cursor() : DegrafaCursor
{
   if(!_cursor)
   {
      _cursor = new DegrafaCursor(source);
   }
   return _cursor;
}

private function updateItemRelations(param1:CommandStackItem, param2:int) : void
{
   param1.previous = param2 > 0 ? source[param2 - 1] : null;
   if(param1.previous)
   {
      if(param1.previous.type == CommandStackItem.COMMAND_STACK)
      {
         param1.previous = param1.previous.commandStack.lastNonCommandStackItem;
      }
      param1.previous.next = param1.type == CommandStackItem.COMMAND_STACK ? param1.commandStack.firstNonCommandStackItem : param1;
   }
}

public function get globalRenderDelegateStart() : Array
{
   return _globalRenderDelegateStart ? _globalRenderDelegateStart : null;
}

public function get transformedPathLength() : Number
{
   var _loc1_:CommandStackItem = null;
   _transformedPathLength = 0;
   for each(_loc1_ in source)
   {
      _transformedPathLength += _loc1_.transformedLength;
   }
   return _transformedPathLength;
}

public function adjustPointToLayoutAndTransform(param1:Point) : Point
{
   if(!owner)
   {
      return param1;
   }
   if(transMatrix)
   {
      return transMatrix.transformPoint(param1);
   }
   return param1;
}

public function resetBounds() : void
{
   if(_bounds)
   {
      _bounds.setEmpty();
      invalidated = true;
   }
}

private function renderBitmapDatatoContext(param1:DisplayObject, param2:Graphics, param3:Boolean = false, param4:Rectangle = null) : void
{
   var _loc7_:BitmapData = null;
   var _loc9_:Matrix = null;
   var _loc10_:Matrix = null;
   var _loc11_:Matrix = null;
   if(!param1)
   {
      return;
   }
   var _loc5_:Rectangle = param1.getBounds(param1);
   if(_loc5_.isEmpty())
   {
      return;
   }
   var _loc6_:Rectangle = _loc5_.clone();
   if(hasfilters)
   {
      param1.filters = owner.filters;
      _loc6_.x = _loc6_.y = 0;
      _loc6_.width = Math.ceil(_loc6_.width);
      _loc6_.height = Math.ceil(_loc6_.height);
      if(!_loc6_.width || !_loc6_.height)
      {
         return;
      }
      _loc6_ = updateToFilterRectangle(_loc6_,param1);
      _loc6_.offset(_loc5_.x,_loc5_.y);
   }
   var _loc8_:Rectangle = owner.clippingRectangle ? owner.clippingRectangle : null;
   if(_loc6_.width < 1 || _loc6_.height < 1)
   {
      return;
   }
   _loc6_.width = Math.ceil(_loc6_.width + (_loc6_.x - (_loc6_.x = Math.floor(_loc6_.x))));
   _loc6_.height = Math.ceil(_loc6_.height + (_loc6_.y - (_loc6_.y = Math.floor(_loc6_.y))));
   if(_loc6_.width > 2880 || _loc6_.height > 2880)
   {
      return;
   }
   if(owner is IDisplayObjectProxy)
   {
      _loc7_ = new BitmapData(_loc6_.width + 4,_loc6_.height + 4,true,0);
      _loc9_ = new Matrix(1,0,0,1,2 - _loc6_.x,2 - _loc6_.y);
   }
   else
   {
      _loc7_ = new BitmapData(_loc6_.width,_loc6_.height,true,0);
      _loc9_ = new Matrix(1,0,0,1,-_loc6_.x,-_loc6_.y);
   }
   _loc7_.draw(param1,_loc9_,null,null,_loc8_,true);
   _loc9_.invert();
   if(!param3)
   {
      if(owner.hasFilters && !_loc5_.equals(_loc6_) && owner is IDisplayObjectProxy)
      {
         _loc9_ = new Matrix(_loc5_.width / _loc6_.width,0,0,_loc5_.height / _loc6_.height,_loc9_.tx,_loc9_.ty);
         param2.lineStyle();
         param2.beginBitmapFill(_loc7_,_loc9_,false,true);
         param2.drawRect(Math.floor(_loc5_.x),Math.floor(_loc5_.y),Math.ceil(_loc5_.width),Math.ceil(_loc5_.height));
         param2.endFill();
      }
      else
      {
         param2.lineStyle();
         param2.beginBitmapFill(_loc7_,_loc9_,false,true);
         param2.drawRect(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
         param2.endFill();
      }
   }
   else
   {
      if(transMatrix)
      {
         if(owner is IDisplayObjectProxy)
         {
            if(Boolean(owner._layoutMatrix) && IDisplayObjectProxy(owner).layoutMode == "scale")
            {
               _loc9_.concat(CommandStack.currentTransformMatrix);
            }
            else
            {
               _loc9_.concat(currentTransformMatrix);
               transMatrix = currentTransformMatrix;
            }
         }
         else
         {
            _loc9_.concat(transMatrix);
         }
      }
      param2.beginBitmapFill(_loc7_,_loc9_,false,true);
      lineTo = param2.lineTo;
      curveTo = param2.curveTo;
      moveTo = param2.moveTo;
      renderCommandStack(param2,param4,new DegrafaCursor(this.source));
   }
}

public function simpleRender(param1:Graphics, param2:Rectangle) : void
{
   lineTo = param1.lineTo;
   curveTo = param1.curveTo;
   moveTo = param1.moveTo;
   renderCommandStack(param1,param2,new DegrafaCursor(this.source));
}

public function addCurveTo(param1:Number, param2:Number, param3:Number, param4:Number) : CommandStackItem
{
   var _loc5_:int = source.push(new CommandStackItem(CommandStackItem.CURVE_TO,NaN,NaN,param3,param4,param1,param2)) - 1;
   updateItemRelations(source[_loc5_],_loc5_);
   source[_loc5_].indexInParent = _loc5_;
   source[_loc5_].parent = this;
   invalidated = true;
   return source[_loc5_];
}

public function get pathLength() : Number
{
   var _loc1_:CommandStackItem = null;
   if(lengthInvalidated)
   {
      lengthInvalidated = false;
      _pathLength = 0;
      for each(_loc1_ in source)
      {
         _pathLength += _loc1_.segmentLength;
      }
   }
   return _pathLength;
}

public function addItem(param1:CommandStackItem) : CommandStackItem
{
   var _loc2_:int = source.push(param1) - 1;
   updateItemRelations(source[_loc2_],_loc2_);
   param1.indexInParent = _loc2_;
   param1.parent = this;
   invalidated = true;
   return source[_loc2_];
}

public function get length() : int
{
   return source.length;
}

private function predraw() : void
{
   var _loc4_:Rectangle = null;
   var _loc5_:Rectangle = null;
   var _loc1_:Geometry = owner;
   while(_loc1_.parent)
   {
      _loc1_ = _loc1_.parent as Geometry;
      if(_loc1_.transform)
      {
         owner.transformContext = _loc1_.transform.getTransformFor(_loc1_);
         break;
      }
   }
   var _loc2_:Boolean = owner.hasLayout;
   transMatrix = null;
   currentLayoutMatrix.identity();
   if(_loc2_)
   {
      _loc4_ = owner is IDisplayObjectProxy ? owner.bounds : bounds;
      _loc5_ = owner.layoutRectangle;
      if(!_loc4_.equals(_loc5_))
      {
         if(_loc5_.width != _loc4_.width || _loc5_.height != _loc4_.width)
         {
            currentLayoutMatrix.translate(-_loc4_.x,-_loc4_.y);
            if(owner.scaleOnLayout)
            {
               currentLayoutMatrix.scale(_loc5_.width / _loc4_.width,_loc5_.height / _loc4_.height);
            }
            currentLayoutMatrix.translate(_loc5_.x,_loc5_.y);
         }
         else
         {
            currentLayoutMatrix.translate(_loc5_.x - _loc4_.x,_loc5_.y - _loc4_.y);
         }
         owner._layoutMatrix = currentLayoutMatrix.clone();
         transMatrix = currentLayoutMatrix.clone();
      }
      else
      {
         _loc2_ = false;
         owner._layoutMatrix = null;
         currentLayoutMatrix.identity();
      }
   }
   else if(owner._layoutMatrix)
   {
      owner._layoutMatrix = null;
   }
   var _loc3_:Boolean = Boolean(owner.transformContext) || Boolean(owner.transform) && !owner.transform.isIdentity;
   if(_loc3_)
   {
      currentTransformMatrix = owner.transform ? owner.transform.getTransformFor(owner) : owner.transformContext;
      if(!_loc2_)
      {
         transMatrix = owner.transform ? owner.transform.getTransformFor(owner) : owner.transformContext;
      }
      else
      {
         transMatrix.concat(owner.transform ? owner.transform.getTransformFor(owner) : owner.transformContext);
      }
   }
   else
   {
      currentTransformMatrix.identity();
      if(!_loc2_)
      {
         transMatrix = null;
      }
   }
}

public function get lastSegmentWithLength() : CommandStackItem
{
   var _loc1_:* = int(source.length - 1);
   while(_loc1_ > 0)
   {
      if(source[_loc1_].type == 1 || source[_loc1_].type == 2)
      {
         return source[_loc1_];
      }
      if(source[_loc1_].type == 4)
      {
         return source[_loc1_].commandStack.lastSegmentWithLength;
      }
      _loc1_--;
   }
   return source[length - 1];
}

public function set globalRenderDelegateEnd(param1:Array) : void
{
   if(_globalRenderDelegateEnd != param1)
   {
      _globalRenderDelegateEnd = param1;
      invalidated = true;
   }
}
}
}

