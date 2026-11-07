package mx.charts.effects.effectClasses
{
   import flash.geom.Rectangle;
   
   public class SeriesSlideInstance extends SeriesEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _horizontal:Boolean;
      
      private var _slideDistance:Number;
      
      private var _startingBounds:Array;
      
      private var seriesRenderData:Object;
      
      [Inspectable(category="General",enumeration="left,right,up,down",defaultValue="left")]
      public var direction:String = "left";
      
      public function SeriesSlideInstance(target:Object)
      {
         super(target);
      }
      
      override public function onTweenEnd(value:Object) : void
      {
         super.onTweenEnd(value);
         targetSeries.transitionRenderData = null;
      }
      
      override public function play() : void
      {
         var i:int = 0;
         var v:Rectangle = null;
         seriesRenderData = targetSeries.getRenderDataForTransition(type);
         targetSeries.getElementBounds(seriesRenderData);
         var startingBounds:Array = seriesRenderData.elementBounds;
         var visibleRegion:Rectangle = seriesRenderData.visibleRegion;
         if(!visibleRegion)
         {
            visibleRegion = new Rectangle(0,0,targetSeries.width / Math.abs(targetSeries.scaleX),targetSeries.height / Math.abs(targetSeries.scaleY));
         }
         if(Boolean(seriesRenderData.bounds))
         {
            if(type == "show")
            {
               switch(direction)
               {
                  case "right":
                     _slideDistance = seriesRenderData.bounds.right;
                     _horizontal = true;
                     break;
                  case "left":
                     _slideDistance = -(visibleRegion.right - seriesRenderData.bounds.left);
                     _horizontal = true;
                     break;
                  case "down":
                     _slideDistance = seriesRenderData.bounds.bottom;
                     _horizontal = false;
                     break;
                  case "up":
                     _slideDistance = -(visibleRegion.bottom - seriesRenderData.bounds.top);
                     _horizontal = false;
               }
            }
            else
            {
               switch(direction)
               {
                  case "left":
                     _slideDistance = -seriesRenderData.bounds.right;
                     _horizontal = true;
                     break;
                  case "right":
                     _slideDistance = visibleRegion.right - seriesRenderData.bounds.left;
                     _horizontal = true;
                     break;
                  case "up":
                     _slideDistance = -seriesRenderData.bounds.bottom;
                     _horizontal = false;
                     break;
                  case "down":
                     _slideDistance = visibleRegion.bottom - seriesRenderData.bounds.top;
                     _horizontal = false;
               }
            }
         }
         var activeBounds:Array = [];
         startingBounds = seriesRenderData.elementBounds;
         var n:int = int(startingBounds.length);
         if(type == "show")
         {
            if(_horizontal)
            {
               for(i = 0; i < n; i++)
               {
                  v = startingBounds[i];
                  activeBounds[i] = new Rectangle(v.left - _slideDistance,v.top,v.width,v.height);
               }
            }
            else
            {
               for(i = 0; i < n; i++)
               {
                  v = startingBounds[i];
                  activeBounds[i] = new Rectangle(v.left,v.top - _slideDistance,v.width,v.height);
               }
            }
         }
         else
         {
            for(i = 0; i < n; i++)
            {
               activeBounds[i] = startingBounds[i].clone();
            }
         }
         seriesRenderData.elementBounds = activeBounds;
         targetSeries.transitionRenderData = seriesRenderData;
         _startingBounds = startingBounds;
         beginTween(n);
      }
      
      override public function onTweenUpdate(value:Object) : void
      {
         var i:int = 0;
         var interpolation:Number = NaN;
         var v:Rectangle = null;
         var a:Rectangle = null;
         super.onTweenUpdate(value);
         var startingBounds:Array = _startingBounds;
         var activeBounds:Array = seriesRenderData.elementBounds;
         var n:int = int(startingBounds.length);
         if(type == "show")
         {
            if(_horizontal)
            {
               for(i = 0; i < n; i++)
               {
                  interpolation = 1 - interpolationValues[i];
                  v = startingBounds[i];
                  a = activeBounds[i];
                  a.left = v.left - interpolation * _slideDistance;
                  a.right = v.right - interpolation * _slideDistance;
                  a.top = v.top;
                  a.bottom = v.bottom;
               }
            }
            else
            {
               for(i = 0; i < n; i++)
               {
                  interpolation = 1 - interpolationValues[i];
                  v = startingBounds[i];
                  a = activeBounds[i];
                  a.top = v.top - interpolation * _slideDistance;
                  a.bottom = v.bottom - interpolation * _slideDistance;
                  a.left = v.left;
                  a.right = v.right;
               }
            }
         }
         else if(_horizontal)
         {
            for(i = 0; i < n; i++)
            {
               interpolation = Number(interpolationValues[i]);
               v = startingBounds[i];
               a = activeBounds[i];
               a.left = v.left + interpolation * _slideDistance;
               a.right = v.right + interpolation * _slideDistance;
               a.top = v.top;
               a.bottom = v.bottom;
            }
         }
         else
         {
            for(i = 0; i < n; i++)
            {
               interpolation = Number(interpolationValues[i]);
               v = startingBounds[i];
               a = activeBounds[i];
               a.top = v.top + interpolation * _slideDistance;
               a.bottom = v.bottom + interpolation * _slideDistance;
               a.left = v.left;
               a.right = v.right;
            }
         }
         targetSeries.invalidateDisplayList();
      }
   }
}

