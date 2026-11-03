package mx.charts.styles
{
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class HaloDefaults
   {
      
      [Inspectable(environment="none")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var chartBaseChartSeriesStyles:Array;
      
      [Inspectable(environment="none")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var pointStroke:IStroke;
      
      [Inspectable(environment="none")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var emptyStroke:IStroke;
      
      private static var inited:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var defaultColors:Array = [14976769,10861646,1807833,13290142,6722480,15752743,8835556,15006112,16766226,7712768,418480,15591622,13382400,13754343,5428426,12968029,15188340,16775063,12973711,12448230,10393725,15440013,9554405,9690186,16759040,10402765,38807,897730];
      
      [Inspectable(environment="none")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var defaultFills:Array = [];
      
      public function HaloDefaults()
      {
         super();
      }
      
      public static function init() : void
      {
         var seriesStyleCount:int;
         var i:int;
         var f:Function = null;
         var styleName:String = null;
         var o:CSSStyleDeclaration = null;
         if(inited)
         {
            return;
         }
         seriesStyleCount = int(defaultColors.length);
         for(i = 0; i < seriesStyleCount; i++)
         {
            defaultFills[i] = new SolidColor(defaultColors[i]);
         }
         pointStroke = new Stroke(0,0,0.5);
         emptyStroke = new Stroke(0,0,0);
         chartBaseChartSeriesStyles = [];
         for(i = 0; i < seriesStyleCount; i++)
         {
            styleName = "haloSeries" + i;
            chartBaseChartSeriesStyles[i] = styleName;
            o = HaloDefaults.createSelector("." + styleName);
            f = function(o:CSSStyleDeclaration, defaultFill:IFill, defaultStroke:IStroke):void
            {
               o.defaultFactory = function():void
               {
                  this.fill = defaultFill;
                  this.areaFill = defaultFill;
                  this.areaStroke = emptyStroke;
                  this.lineStroke = defaultStroke;
               };
            };
            f(o,HaloDefaults.defaultFills[i],new Stroke(defaultColors[i],3,1));
         }
      }
      
      public static function createSelector(selectorName:String) : CSSStyleDeclaration
      {
         var selector:CSSStyleDeclaration = StyleManager.getStyleDeclaration(selectorName);
         if(!selector)
         {
            selector = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(selectorName,selector,false);
         }
         return selector;
      }
   }
}

