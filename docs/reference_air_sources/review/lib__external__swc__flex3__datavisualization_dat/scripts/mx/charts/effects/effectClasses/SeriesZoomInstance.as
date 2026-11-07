package mx.charts.effects.effectClasses
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SeriesZoomInstance extends SeriesEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var BOTH:uint = 0;
      
      private static var HORIZONTAL:uint = 1;
      
      private static var VERTICAL:uint = 2;
      
      private var _direction:uint;
      
      [Inspectable(category="General",enumeration="top,center,bottom")]
      public var verticalFocus:String;
      
      private var _slideDistance:Number;
      
      private var _elementBounds:Array;
      
      [Inspectable(category="General",enumeration="left,center,right")]
      public var horizontalFocus:String;
      
      private var _zoomPoints:Array;
      
      [Inspectable(category="General",enumeration="series,chart",defaultValue="series")]
      public var relativeTo:String = "series";
      
      private var seriesRenderData:Object;
      
      public function SeriesZoomInstance(target:Object)
      {
         super(target);
      }
      
      private function loadSeriesRelativePoints(zoomPoints:Array, elementBounds:Array) : void
      {
         var i:int = 0;
         var v:Rectangle = null;
         var pt:Point = null;
         var n:int = int(elementBounds.length);
         switch(horizontalFocus)
         {
            case "left":
               switch(verticalFocus)
               {
                  case "top":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.left,v.top);
                     }
                     break;
                  case "center":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.left,(v.top + v.bottom) / 2);
                     }
                     break;
                  case "bottom":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.left,v.bottom);
                     }
                     break;
                  default:
                     _direction = HORIZONTAL;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.left,NaN);
                     }
               }
               break;
            case "right":
               switch(verticalFocus)
               {
                  case "top":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.right,v.top);
                     }
                     break;
                  case "center":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.right,(v.top + v.bottom) / 2);
                     }
                     break;
                  case "bottom":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.right,v.bottom);
                     }
                     break;
                  default:
                     _direction = HORIZONTAL;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(v.right,NaN);
                     }
               }
               break;
            case "center":
               switch(verticalFocus)
               {
                  case "top":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point((v.left + v.right) / 2,v.top);
                     }
                     break;
                  case "center":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point((v.left + v.right) / 2,(v.top + v.bottom) / 2);
                     }
                     break;
                  case "bottom":
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point((v.left + v.right) / 2,v.bottom);
                     }
                     break;
                  default:
                     _direction = HORIZONTAL;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point((v.right + v.left) / 2,NaN);
                     }
               }
               break;
            default:
               switch(verticalFocus)
               {
                  case "top":
                     _direction = VERTICAL;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(NaN,v.top);
                     }
                     break;
                  case "center":
                     _direction = VERTICAL;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(NaN,(v.top + v.bottom) / 2);
                     }
                     break;
                  case "bottom":
                     _direction = VERTICAL;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point(NaN,v.bottom);
                     }
                     break;
                  default:
                     _direction = BOTH;
                     for(i = 0; i < n; i++)
                     {
                        v = elementBounds[i];
                        zoomPoints[i] = new Point((v.left + v.right) / 2,(v.top + v.bottom) / 2);
                     }
               }
         }
      }
      
      override public function play() : void
      {
         var i:int = 0;
         var pt:Point = null;
         var v:Rectangle = null;
         seriesRenderData = targetSeries.getRenderDataForTransition(type);
         targetSeries.getElementBounds(seriesRenderData);
         var elementBounds:Array = _elementBounds = seriesRenderData.elementBounds;
         var activeBounds:Array = [];
         var zoomPoints:Array = [];
         var n:int = int(elementBounds.length);
         if(relativeTo == "series")
         {
            loadSeriesRelativePoints(zoomPoints,elementBounds);
         }
         else
         {
            loadChartRelativePoints(zoomPoints,elementBounds,seriesRenderData.visibleRegion);
         }
         if(type == "show")
         {
            switch(_direction)
            {
               case BOTH:
                  for(i = 0; i < n; i++)
                  {
                     pt = zoomPoints[i];
                     activeBounds[i] = new Rectangle(pt.x,pt.y,0,0);
                  }
                  break;
               case HORIZONTAL:
                  for(i = 0; i < n; i++)
                  {
                     pt = zoomPoints[i];
                     v = elementBounds[i];
                     activeBounds[i] = new Rectangle(pt.x,v.top,0,v.height);
                  }
                  break;
               case VERTICAL:
                  for(i = 0; i < n; i++)
                  {
                     pt = zoomPoints[i];
                     v = elementBounds[i];
                     activeBounds[i] = new Rectangle(v.left,pt.y,v.width,0);
                  }
            }
         }
         else
         {
            for(i = 0; i < n; i++)
            {
               v = elementBounds[i];
               activeBounds[i] = elementBounds[i].clone();
            }
         }
         seriesRenderData.elementBounds = activeBounds;
         targetSeries.transitionRenderData = seriesRenderData;
         _zoomPoints = zoomPoints;
         beginTween(n);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         var i:int = 0;
         var v:Rectangle = null;
         var pt:Point = null;
         var interpolation:Number = NaN;
         super.onTweenUpdate(value);
         var elementBounds:Array = _elementBounds;
         var activeBounds:Array = seriesRenderData.elementBounds;
         var zoomPoints:Array = _zoomPoints;
         var n:int = int(elementBounds.length);
         var base:Number = 0;
         var scale:Number = 1;
         if(type == "hide")
         {
            base = 1;
            scale = -1;
         }
         switch(_direction)
         {
            case BOTH:
               for(i = 0; i < n; i++)
               {
                  interpolation = base + scale * interpolationValues[i];
                  v = elementBounds[i];
                  pt = zoomPoints[i];
                  activeBounds[i] = new Rectangle(pt.x + (v.left - pt.x) * interpolation,pt.y + (v.top - pt.y) * interpolation,v.width * interpolation,v.height * interpolation);
               }
               break;
            case HORIZONTAL:
               for(i = 0; i < n; i++)
               {
                  interpolation = base + scale * interpolationValues[i];
                  v = elementBounds[i];
                  pt = zoomPoints[i];
                  activeBounds[i] = new Rectangle(pt.x + (v.left - pt.x) * interpolation,v.top,v.width * interpolation,v.height);
               }
               break;
            case VERTICAL:
               for(i = 0; i < n; i++)
               {
                  interpolation = base + scale * interpolationValues[i];
                  v = elementBounds[i];
                  pt = zoomPoints[i];
                  activeBounds[i] = new Rectangle(v.left,pt.y + (v.top - pt.y) * interpolation,v.width,v.height * interpolation);
               }
         }
         targetSeries.invalidateDisplayList();
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         super.onTweenEnd(value);
         targetSeries.transitionRenderData = null;
      }
      
      private function loadChartRelativePoints(zoomPoints:Array, elementBounds:Array, visibleRegion:Rectangle) : void
      {
         var i:int = 0;
         var pt:Point = null;
         var n:int = int(elementBounds.length);
         if(!visibleRegion)
         {
            visibleRegion = new Rectangle(0,0,targetSeries.width / Math.abs(targetSeries.scaleX),targetSeries.height / Math.abs(targetSeries.scaleY));
         }
         switch(horizontalFocus)
         {
            case "left":
               switch(verticalFocus)
               {
                  case "top":
                     _direction = BOTH;
                     pt = visibleRegion.topLeft;
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "center":
                     _direction = BOTH;
                     pt = new Point(visibleRegion.left,visibleRegion.top + visibleRegion.height / 2);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "bottom":
                     _direction = BOTH;
                     pt = new Point(visibleRegion.left,visibleRegion.bottom);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  default:
                     _direction = HORIZONTAL;
                     pt = new Point(visibleRegion.left,NaN);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
               }
               break;
            case "right":
               switch(verticalFocus)
               {
                  case "top":
                     _direction = BOTH;
                     pt = new Point(visibleRegion.right,visibleRegion.top);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "center":
                     _direction = BOTH;
                     pt = new Point(visibleRegion.right,visibleRegion.top + visibleRegion.height / 2);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "bottom":
                     _direction = BOTH;
                     pt = visibleRegion.bottomRight;
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  default:
                     _direction = HORIZONTAL;
                     pt = new Point(visibleRegion.right,NaN);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
               }
               break;
            case "center":
               switch(verticalFocus)
               {
                  case "top":
                     _direction = BOTH;
                     pt = new Point(visibleRegion.left + visibleRegion.width / 2,visibleRegion.top);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "center":
                     _direction = BOTH;
                     pt = new Point(visibleRegion.left + visibleRegion.width / 2,visibleRegion.top + visibleRegion.height / 2);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "bottom":
                     _direction = BOTH;
                     pt = new Point(visibleRegion.left + visibleRegion.width / 2,visibleRegion.bottom);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  default:
                     _direction = HORIZONTAL;
                     pt = new Point(visibleRegion.left + visibleRegion.width / 2,NaN);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
               }
               break;
            default:
               switch(verticalFocus)
               {
                  case "top":
                     _direction = VERTICAL;
                     pt = new Point(NaN,visibleRegion.top);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "center":
                     _direction = VERTICAL;
                     pt = new Point(NaN,visibleRegion.top + visibleRegion.height / 2);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  case "bottom":
                     _direction = VERTICAL;
                     pt = new Point(NaN,visibleRegion.bottom);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
                     break;
                  default:
                     _direction = BOTH;
                     pt = new Point(visibleRegion.left + visibleRegion.width / 2,visibleRegion.top + visibleRegion.height / 2);
                     for(i = 0; i < n; i++)
                     {
                        zoomPoints[i] = pt;
                     }
               }
         }
      }
   }
}

