package mx.charts.chartClasses
{
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.LinearGradient;
   import mx.graphics.RadialGradient;
   import mx.graphics.SolidColor;
   
   public class GraphicsUtilities
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var LINE_FORM:Object = {
         "segment":0,
         "step":1,
         "vertical":2,
         "horizontal":3,
         "reverseStep":4,
         "curve":5
      };
      
      public function GraphicsUtilities()
      {
         super();
      }
      
      public static function fillFromStyle(v:Object) : IFill
      {
         if(v is IFill)
         {
            return IFill(v);
         }
         if(v != null)
         {
            return IFill(new SolidColor(uint(v)));
         }
         return null;
      }
      
      public static function drawPolyLine(g:Graphics, pts:Array, start:int, end:int, hProp:String, vProp:String, stroke:IStroke, form:Object, moveToStart:Boolean = true) : void
      {
         var len:Number = NaN;
         var incr:int = 0;
         var i:int = 0;
         var w:Number = NaN;
         var c:Number = NaN;
         var a:Number = NaN;
         var innerEnd:int = 0;
         var tanLeft:Point = null;
         var tanRight:Point = null;
         var tangentLengthPercent:Number = NaN;
         var j:int = 0;
         var v1:Point = null;
         var v2:Point = null;
         var tan:Point = null;
         var p1:Point = null;
         var p2:Point = null;
         var mp:Point = null;
         var tanLenFactor:Number = NaN;
         var prevNonCoincidentPt:Object = null;
         var tanlen:Number = NaN;
         if(start == end)
         {
            return;
         }
         var originalStart:int = start;
         form = convertForm(form);
         if(Boolean(stroke))
         {
            stroke.apply(g);
         }
         var reverse:Boolean = start > end;
         if(reverse)
         {
            incr = -1;
         }
         else
         {
            incr = 1;
         }
         if(moveToStart)
         {
            g.moveTo(pts[start][hProp],pts[start][vProp]);
         }
         else
         {
            g.lineTo(pts[start][hProp],pts[start][vProp]);
         }
         start += incr;
         if(form == LINE_FORM.segment)
         {
            for(i = start; i != end; i += incr)
            {
               g.lineTo(pts[i][hProp],pts[i][vProp]);
            }
         }
         else if(form == LINE_FORM.step)
         {
            for(i = start; i != end; i += incr)
            {
               g.lineTo(pts[i][hProp],pts[i - incr][vProp]);
               g.lineTo(pts[i][hProp],pts[i][vProp]);
            }
         }
         else if(form == LINE_FORM.reverseStep)
         {
            for(i = start; i != end; i += incr)
            {
               g.lineTo(pts[i - incr][hProp],pts[i][vProp]);
               g.lineTo(pts[i][hProp],pts[i][vProp]);
            }
         }
         else if(form == LINE_FORM.horizontal)
         {
            if(reverse)
            {
               for(i = start; i != end; i += incr)
               {
                  g.lineStyle(0,0,0);
                  g.lineTo(pts[i - incr][hProp],pts[i][vProp]);
                  if(Boolean(stroke))
                  {
                     stroke.apply(g);
                  }
                  g.lineTo(pts[i][hProp],pts[i][vProp]);
               }
            }
            else
            {
               for(i = start; i != end; i += incr)
               {
                  g.lineStyle(0,0,0);
                  g.lineTo(pts[i - incr][hProp],pts[i - incr][vProp]);
                  if(Boolean(stroke))
                  {
                     stroke.apply(g);
                  }
                  g.lineTo(pts[i][hProp],pts[i - incr][vProp]);
               }
            }
         }
         else if(form == LINE_FORM.vertical)
         {
            if(reverse)
            {
               for(i = start; i != end; i += incr)
               {
                  g.lineStyle(0,0,0);
                  g.lineTo(pts[i - incr][hProp],pts[i][vProp]);
                  if(Boolean(stroke))
                  {
                     stroke.apply(g);
                  }
                  g.lineTo(pts[i][hProp],pts[i][vProp]);
               }
            }
            else
            {
               for(i = start; i != end; i += incr)
               {
                  g.lineStyle(0,0,0);
                  g.lineTo(pts[i][hProp],pts[i - incr][vProp]);
                  if(Boolean(stroke))
                  {
                     stroke.apply(g);
                  }
                  g.lineTo(pts[i][hProp],pts[i][vProp]);
               }
            }
         }
         else if(form == LINE_FORM.curve)
         {
            start = originalStart;
            innerEnd = end - incr;
            while(start != end)
            {
               if(pts[start + incr][hProp] != pts[start][hProp] || pts[start + incr][vProp] != pts[start][vProp])
               {
                  break;
               }
               start += incr;
            }
            if(start == end || start + incr == end)
            {
               return;
            }
            if(Math.abs(end - start) == 2)
            {
               g.lineTo(pts[start + incr][hProp],pts[start + incr][vProp]);
               return;
            }
            tanLeft = new Point();
            tanRight = new Point();
            tangentLengthPercent = 0.25;
            if(reverse)
            {
               tangentLengthPercent *= -1;
            }
            j = start;
            v1 = new Point();
            v2 = new Point(pts[j + incr][hProp] - pts[j][hProp],pts[j + incr][vProp] - pts[j][vProp]);
            tan = new Point();
            p1 = new Point();
            p2 = new Point();
            mp = new Point();
            len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
            v2.x /= len;
            v2.y /= len;
            tanLenFactor = pts[j + incr][hProp] - pts[j][hProp];
            prevNonCoincidentPt = pts[j];
            for(j += incr; j != innerEnd; j += incr)
            {
               if(!(pts[j + incr][hProp] == pts[j][hProp] && pts[j + incr][vProp] == pts[j][vProp]))
               {
                  v1.x = -v2.x;
                  v1.y = -v2.y;
                  v2.x = pts[j + incr][hProp] - pts[j][hProp];
                  v2.y = pts[j + incr][vProp] - pts[j][vProp];
                  len = Math.sqrt(v2.x * v2.x + v2.y * v2.y);
                  v2.x /= len;
                  v2.y /= len;
                  tan.x = v2.x - v1.x;
                  tan.y = v2.y - v1.y;
                  tanlen = Math.sqrt(tan.x * tan.x + tan.y * tan.y);
                  tan.x /= tanlen;
                  tan.y /= tanlen;
                  if(v1.y * v2.y >= 0)
                  {
                     tan = new Point(1,0);
                  }
                  tanLeft.x = -tan.x * tanLenFactor * tangentLengthPercent;
                  tanLeft.y = -tan.y * tanLenFactor * tangentLengthPercent;
                  if(j == incr + start)
                  {
                     g.curveTo(pts[j][hProp] + tanLeft.x,pts[j][vProp] + tanLeft.y,pts[j][hProp],pts[j][vProp]);
                  }
                  else
                  {
                     p1.x = prevNonCoincidentPt[hProp] + tanRight.x;
                     p1.y = prevNonCoincidentPt[vProp] + tanRight.y;
                     p2.x = pts[j][hProp] + tanLeft.x;
                     p2.y = pts[j][vProp] + tanLeft.y;
                     mp.x = (p1.x + p2.x) / 2;
                     mp.y = (p1.y + p2.y) / 2;
                     g.curveTo(p1.x,p1.y,mp.x,mp.y);
                     g.curveTo(p2.x,p2.y,pts[j][hProp],pts[j][vProp]);
                  }
                  tanLenFactor = pts[j + incr][hProp] - pts[j][hProp];
                  tanRight.x = tan.x * tanLenFactor * tangentLengthPercent;
                  tanRight.y = tan.y * tanLenFactor * tangentLengthPercent;
                  prevNonCoincidentPt = pts[j];
               }
            }
            g.curveTo(prevNonCoincidentPt[hProp] + tanRight.x,prevNonCoincidentPt[vProp] + tanRight.y,pts[j][hProp],pts[j][vProp]);
         }
      }
      
      public static function drawArc(g:Graphics, x:Number, y:Number, startAngle:Number, arc:Number, radius:Number, yRadius:Number = NaN, continueFlag:Boolean = false) : void
      {
         var segAngle:Number = NaN;
         var theta:Number = NaN;
         var angle:Number = NaN;
         var angleMid:Number = NaN;
         var segs:Number = NaN;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var i:uint = 0;
         if(isNaN(yRadius))
         {
            yRadius = radius;
         }
         if(Math.abs(arc) > 2 * Math.PI)
         {
            arc = 2 * Math.PI;
         }
         segs = Math.ceil(Math.abs(arc) / (Math.PI / 4));
         segAngle = arc / segs;
         theta = -segAngle;
         angle = -startAngle;
         if(segs > 0)
         {
            ax = x + Math.cos(startAngle) * radius;
            ay = y + Math.sin(-startAngle) * yRadius;
            if(continueFlag == true)
            {
               g.lineTo(ax,ay);
            }
            else
            {
               g.moveTo(ax,ay);
            }
            for(i = 0; i < segs; i++)
            {
               angle += theta;
               angleMid = angle - theta / 2;
               bx = x + Math.cos(angle) * radius;
               by = y + Math.sin(angle) * yRadius;
               cx = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
               cy = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
               g.curveTo(cx,cy,bx,by);
            }
         }
      }
      
      private static function convertForm(v:Object) : Number
      {
         if(typeof v == "number")
         {
            return Number(v);
         }
         switch(v)
         {
            case "segment":
               break;
            case "curve":
               return LINE_FORM.curve;
            case "step":
               return LINE_FORM.step;
            case "horizontal":
               return LINE_FORM.horizontal;
            case "vertical":
               return LINE_FORM.vertical;
            case "reverseStep":
               return LINE_FORM.reverseStep;
         }
         return LINE_FORM.segment;
      }
      
      public static function fillRect(g:Graphics, left:Number, top:Number, right:Number, bottom:Number, fill:Object = null, ls:Object = null) : void
      {
         var fillIsColor:Boolean = false;
         g.moveTo(left,top);
         if(fill != null)
         {
            if(fill is IFill)
            {
               fillIsColor = false;
               fill.begin(g,new Rectangle(left,top,right - left,bottom - top));
            }
            else
            {
               fillIsColor = true;
               g.beginFill(uint(fill));
            }
         }
         if(ls != null)
         {
            ls.apply(g);
         }
         g.lineTo(right,top);
         g.lineTo(right,bottom);
         g.lineTo(left,bottom);
         g.lineTo(left,top);
         if(fill != null)
         {
            g.endFill();
         }
      }
      
      public static function setLineStyle(g:Graphics, ls:IStroke) : void
      {
         if(!ls)
         {
            g.lineStyle(0,0,0);
         }
         else
         {
            ls.apply(g);
         }
      }
      
      public static function colorFromFill(f:Object) : uint
      {
         var color:uint = 0;
         if(f != null)
         {
            if(f is SolidColor)
            {
               color = uint(SolidColor(f).color);
            }
            else if(f is LinearGradient && LinearGradient(f).entries.length > 0)
            {
               color = uint(LinearGradient(f).entries[0].color);
            }
            else if(f is RadialGradient && RadialGradient(f).entries.length > 0)
            {
               color = uint(RadialGradient(f).entries[0].color);
            }
            else if(f is Number || f is uint || f is int)
            {
               color = uint(f);
            }
         }
         return color;
      }
   }
}

