package mx.charts
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import mx.charts.chartClasses.AxisBase;
   import mx.charts.chartClasses.AxisLabelSet;
   import mx.charts.chartClasses.ChartBase;
   import mx.charts.chartClasses.ChartLabel;
   import mx.charts.chartClasses.ChartState;
   import mx.charts.chartClasses.DualStyleObject;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.IAxisRenderer;
   import mx.charts.chartClasses.InstanceCache;
   import mx.charts.styles.HaloDefaults;
   import mx.core.ContextualClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.UITextFormat;
   import mx.graphics.IStroke;
   import mx.graphics.Stroke;
   import mx.managers.ILayoutManagerClient;
   import mx.managers.ISystemManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   
   [ResourceBundle("charts")]
   [Style(name="verticalAxisTitleAlignment",type="String",enumeration="flippedVertical, vertical",inherit="no")]
   [Style(name="tickStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="tickPlacement",type="String",enumeration="inside,outside,cross,none",inherit="no")]
   [Style(name="tickLength",type="Number",format="Length",inherit="no")]
   [Style(name="showLine",type="Boolean",inherit="no")]
   [Style(name="showLabels",type="Boolean",inherit="no")]
   [Style(name="minorTickStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="minorTickPlacement",type="String",enumeration="inside,outside,cross,none",inherit="no")]
   [Style(name="minorTickLength",type="Number",format="Length",inherit="no")]
   [Style(name="labelRotation",type="Number",inherit="no")]
   [Style(name="labelGap",type="Number",format="Length",inherit="no")]
   [Style(name="labelAlign",type="String",enumeration="left,top,right,bottom,center",inherit="no")]
   [Style(name="canStagger",type="Boolean",inherit="no")]
   [Style(name="canDropLabels",type="Boolean",inherit="no")]
   [Style(name="axisTitleStyleName",type="String",inherit="yes")]
   [Style(name="axisStroke",type="mx.graphics.IStroke",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   public class AxisRenderer extends DualStyleObject implements IAxisRenderer
   {
      
      private static var textFieldFactory:ContextualClassFactory;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _cacheDirty:Boolean = true;
      
      private var _supressInvalidations:int = 0;
      
      private var _heightLimit:Number;
      
      private var _labels:Array = [];
      
      private var _titleField:UIComponent;
      
      private var _measuringField:DisplayObject;
      
      private var _titleRenderer:IFactory = null;
      
      private var _forceLabelUpdate:Boolean = false;
      
      private var _titleFieldChanged:Boolean;
      
      private var _inverted:Boolean = false;
      
      private var _maxLabelHeight:Number;
      
      private var _highlightElements:Boolean = false;
      
      private var _minorTicks:Array = [];
      
      private var _placement:String = "";
      
      private var _axisLabelSet:AxisLabelSet;
      
      private var _gutters:Rectangle = new Rectangle();
      
      private var _ticks:Array = [];
      
      private var _labelPlacement:Object;
      
      private var _axis:IAxis = null;
      
      private var _labelCache:InstanceCache;
      
      private var _labelFormatCache:TextFormat;
      
      private var _maxRotatedLabelHeight:Number;
      
      private var _maxLabelWidth:Number;
      
      private var _horizontal:Boolean;
      
      private var _canRotate:Boolean;
      
      private var _otherAxes:Array;
      
      private var _labelRenderer:IFactory = null;
      
      private var _bGuttersAdjusted:Boolean = false;
      
      private var _labelFunction:Function = null;
      
      public function AxisRenderer()
      {
         super();
         textFieldFactory = new ContextualClassFactory(UITextField,moduleFactory);
         _labelCache = new InstanceCache(UITextField,this);
         _labelCache.discard = true;
         _labelCache.remove = true;
         updateRotation();
         super.showInAutomationHierarchy = false;
      }
      
      private static function initStyles() : Boolean
      {
         var blockNumeric:CSSStyleDeclaration;
         var blockCategory:CSSStyleDeclaration;
         var axisRendererStyle:CSSStyleDeclaration;
         var dashedCategory:CSSStyleDeclaration;
         var hangingCategory:CSSStyleDeclaration;
         var vaxisRendererStyle:CSSStyleDeclaration;
         var dashedNumeric:CSSStyleDeclaration;
         var linedNumeric:CSSStyleDeclaration;
         var o:CSSStyleDeclaration = null;
         HaloDefaults.init();
         axisRendererStyle = HaloDefaults.createSelector("AxisRenderer");
         axisRendererStyle.defaultFactory = function():void
         {
            this.axisStroke = new Stroke(0,0,1);
            this.canDropLabels = null;
            this.canStagger = true;
            this.labelGap = 3;
            this.labelRotation = NaN;
            this.minorTickLength = 0;
            this.minorTickPlacement = "none";
            this.minorTickStroke = new Stroke(0,0,1);
            this.showLabels = true;
            this.showLine = true;
            this.tickLength = 3;
            this.tickPlacement = "outside";
            this.tickStroke = new Stroke(0,0,1);
            this.labelAlign = "center";
            this.verticalAxisTitleAlignment = "flippedVertical";
         };
         vaxisRendererStyle = HaloDefaults.createSelector(".verticalAxisStyle");
         vaxisRendererStyle.defaultFactory = function():void
         {
            this.minorTickLength = 2;
            this.minorTickPlacement = "outside";
            this.tickLength = 5;
         };
         blockNumeric = HaloDefaults.createSelector(".blockNumericAxis");
         blockNumeric.defaultFactory = function():void
         {
            this.axisStroke = new Stroke(12307677,8,1,false,"normal","none");
            this.minorTickLength = 0;
            this.minorTickPlacement = "cross";
            this.minorTickStroke = new Stroke(16777215,1,1,false,"normal","none");
            this.tickLength = 8;
            this.tickStroke = new Stroke(12307677,1,1,false,"normal","none");
         };
         linedNumeric = HaloDefaults.createSelector(".linedNumericAxis");
         linedNumeric.defaultFactory = function():void
         {
            this.axisStroke = new Stroke(12307677,1,1,false,"normal","none");
            this.minorTickLength = 4;
            this.minorTickPlacement = "outside";
            this.minorTickStroke = new Stroke(12307677,1,1,false,"normal","none");
            this.tickLength = 8;
            this.tickStroke = new Stroke(12307677,1,1,false,"normal","none");
         };
         dashedNumeric = HaloDefaults.createSelector(".dashedNumericAxis");
         dashedNumeric.defaultFactory = function():void
         {
            this.minorTickLength = 4;
            this.minorTickPlacement = "outside";
            this.minorTickStroke = new Stroke(12307677,1,1,false,"normal","none");
            this.showLine = false;
            this.tickLength = 8;
            this.tickStroke = new Stroke(12307677,1,1,false,"normal","none");
         };
         blockCategory = HaloDefaults.createSelector(".blockCategoryAxis");
         blockCategory.defaultFactory = function():void
         {
            this.axisStroke = new Stroke(12307677,8,1,false,"normal","none");
            this.minorTickLength = 0;
            this.minorTickPlacement = "none";
            this.tickLength = 0;
            this.tickPlacement = "cross";
            this.tickStroke = new Stroke(16777215,2,1,false,"normal","none");
         };
         hangingCategory = HaloDefaults.createSelector(".hangingCategoryAxis");
         hangingCategory.defaultFactory = function():void
         {
            this.axisStroke = new Stroke(12307677,1,1,false,"normal","none");
            this.minorTickLength = 0;
            this.minorTickPlacement = "cross";
            this.minorTickStroke = new Stroke(0,0,0);
            this.tickLength = 4;
            this.tickStroke = new Stroke(12307677,1,1,false,"normal","none");
         };
         dashedCategory = HaloDefaults.createSelector(".dashedCategoryAxis");
         dashedCategory.defaultFactory = function():void
         {
            this.axisStroke = new Stroke(12307677,1,1,false,"normal","none");
            this.minorTickPlacement = "none";
            this.tickLength = 0;
            this.tickPlacement = "cross";
            this.tickStroke = new Stroke(16777215,2,1,false,"normal","none");
         };
         return true;
      }
      
      private function titleChangeHandler(event:Event) : void
      {
         if(Boolean(chart))
         {
            chart.invalidateDisplayList();
         }
         invalidateDisplayList();
      }
      
      private function calcStaggeredSpacing(width:Number, horizontalGutterData:Object, targetHeight:Number, firstLabel:ARLabelData, lastLabel:ARLabelData, canDropLabels:Boolean, adjustable:Object) : Object
      {
         var staggeredScale:Number = NaN;
         var thisLabel:ARLabelData = null;
         var spaceBetween:Number = NaN;
         var requiredSpace:Number = NaN;
         var staggeredleftGutter:Number = Number(horizontalGutterData.horizontalleftGutter);
         var staggeredrightGutter:Number = Number(horizontalGutterData.horizontalrightGutter);
         var axisLength:Number = width - staggeredleftGutter - staggeredrightGutter;
         if(!isNaN(targetHeight))
         {
            staggeredScale = Math.min(1,targetHeight / (2 * _maxLabelHeight));
         }
         else
         {
            staggeredScale = 1;
         }
         var skipLabel:ARLabelData = firstLabel;
         lastLabel = _labels[1];
         if(adjustable.left == false)
         {
            staggeredScale = Math.min(staggeredScale,staggeredleftGutter / (firstLabel.width / 2));
         }
         if(adjustable.right == false)
         {
            staggeredScale = Math.min(staggeredScale,staggeredrightGutter / (lastLabel.width / 2));
         }
         for(var i:int = 2; i < _labels.length; i++)
         {
            thisLabel = _labels[i];
            spaceBetween = (thisLabel.position - skipLabel.position) * axisLength;
            requiredSpace = (thisLabel.width + skipLabel.width) / 2;
            staggeredScale = Math.min(staggeredScale,spaceBetween / requiredSpace);
            skipLabel = lastLabel;
            lastLabel = thisLabel;
         }
         return {
            "rotation":0,
            "left":staggeredleftGutter,
            "right":staggeredrightGutter,
            "scale":Math.max(0,staggeredScale),
            "staggered":true
         };
      }
      
      private function drawAxis(showLine:Boolean) : void
      {
         var w:Number = NaN;
         var baseline:Number = NaN;
         var leftJoin:Number = NaN;
         var rightJoin:Number = NaN;
         var i:int = 0;
         var otherAxis:IAxisRenderer = null;
         var otherLineStyle:IStroke = null;
         var otherShowLine:Boolean = false;
         var placement:String = null;
         var axisStroke:IStroke = getStyle("axisStroke");
         if(showLine == true)
         {
            w = Number(axisStroke.weight == 0 ? 1 : axisStroke.weight);
            baseline = Number(_inverted ? _gutters.top - w : unscaledHeight - _gutters.bottom);
            graphics.lineStyle(0,0,0);
            leftJoin = 0;
            rightJoin = 0;
            if(_horizontal && Boolean(_otherAxes))
            {
               for(i = 0; i < _otherAxes.length; i++)
               {
                  otherAxis = _otherAxes[i];
                  if(otherAxis is AxisRenderer)
                  {
                     otherLineStyle = AxisRenderer(otherAxis).getStyle("axisStroke");
                     otherShowLine = Boolean(AxisRenderer(otherAxis).getStyle("showLine"));
                  }
                  placement = otherAxis.placement;
                  if(Boolean(otherLineStyle) && otherShowLine)
                  {
                     if(placement == "right" || placement == "top")
                     {
                        rightJoin += otherLineStyle.weight;
                     }
                     else
                     {
                        leftJoin += otherLineStyle.weight;
                     }
                  }
               }
            }
            graphics.moveTo(_gutters.left - leftJoin,baseline + w / 2);
            axisStroke.apply(graphics);
            graphics.lineTo(unscaledWidth - _gutters.right + rightJoin,baseline + w / 2);
         }
      }
      
      private function reduceLabels(intervalStart:AxisLabel, intervalEnd:AxisLabel) : Boolean
      {
         var newLabelData:AxisLabelSet = _axis.reduceLabels(intervalStart,intervalEnd);
         if(!newLabelData || newLabelData == _axisLabelSet || newLabelData.labels.length >= _axisLabelSet.labels.length)
         {
            return false;
         }
         processAxisLabels(newLabelData);
         _axisLabelSet = newLabelData;
         return true;
      }
      
      [Inspectable(category="General")]
      public function get horizontal() : Boolean
      {
         return _horizontal;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getAxisLabelSet() : AxisLabelSet
      {
         return _axisLabelSet;
      }
      
      public function adjustGutters(workingGutters:Rectangle, adjustable:Object) : Rectangle
      {
         var tmpGutter:Number = NaN;
         var targetHeight:Number = NaN;
         var rotatedGutters:Rectangle = null;
         var label:ARLabelData = null;
         var lcount:int = 0;
         var c:Number = NaN;
         var s:Number = NaN;
         var heightContribution:Number = NaN;
         var labelHeight:Number = NaN;
         var i:int = 0;
         var ldi:ARLabelData = null;
         var rotatedHeight:Number = NaN;
         _bGuttersAdjusted = true;
         var axisStroke:IStroke = getStyle("axisStroke");
         updateCaches();
         var width:Number = Number(unscaledWidth);
         var height:Number = Number(unscaledHeight);
         var scale:Number = 1;
         if(_horizontal == false)
         {
            rotatedGutters = new Rectangle(workingGutters.top,workingGutters.right,0,0);
            rotatedGutters.right = workingGutters.bottom;
            rotatedGutters.bottom = workingGutters.left;
            _gutters = workingGutters = rotatedGutters;
            adjustable = {
               "left":adjustable.top,
               "top":adjustable.right,
               "right":adjustable.bottom,
               "bottom":adjustable.left
            };
         }
         else
         {
            _gutters = workingGutters = workingGutters.clone();
         }
         if(_inverted)
         {
            tmpGutter = workingGutters.top;
            workingGutters.top = workingGutters.bottom;
            workingGutters.bottom = tmpGutter;
         }
         var calcSize:Number = 0;
         var showLabelsStyle:Object = getStyle("showLabels");
         var showLabels:Boolean = showLabelsStyle != false && showLabelsStyle != "false";
         var showLineStyle:Object = getStyle("showLine");
         var showLine:Boolean = showLineStyle != false && showLineStyle != "false";
         calcSize += tickSize(showLine);
         calcSize += getStyle("labelGap");
         calcSize += Number(showLine == true && Boolean(axisStroke) ? axisStroke.weight : 0);
         var titleHeight:Number = 0;
         var titleScale:Number = 1;
         var titleSize:Point = measureTitle();
         titleHeight = titleSize.y;
         calcSize += titleHeight * titleScale;
         if(adjustable.bottom == false)
         {
            targetHeight = Math.max(0,workingGutters.bottom - calcSize);
         }
         else if(!isNaN(heightLimit))
         {
            targetHeight = Math.max(0,heightLimit - calcSize);
         }
         var tickStroke:IStroke = getStyle("tickStroke");
         if(Boolean(tickStroke))
         {
            workingGutters.left = Math.max(workingGutters.left,tickStroke.weight / 2);
            workingGutters.right = Math.max(workingGutters.right,tickStroke.weight / 2);
         }
         tickStroke = getStyle("minorTickStroke");
         if(Boolean(tickStroke))
         {
            workingGutters.left = Math.max(workingGutters.left,tickStroke.weight / 2);
            workingGutters.right = Math.max(workingGutters.right,tickStroke.weight / 2);
         }
         if(showLabels)
         {
            _labelPlacement = calcRotationAndSpacing(width,height,targetHeight,workingGutters,adjustable);
            label = _labels[0];
            lcount = int(_labels.length);
            if(_labelPlacement.rotation == 0)
            {
               if(Boolean(_labelPlacement.staggered))
               {
                  calcSize += 2 * label.height * _labelPlacement.scale;
               }
               else
               {
                  calcSize += _maxLabelHeight * _labelPlacement.scale;
               }
            }
            else
            {
               c = Math.cos(Math.abs(_labelPlacement.rotation));
               s = Math.sin(Math.abs(_labelPlacement.rotation));
               heightContribution = 1 - this.labelAlignOffset;
               labelHeight = 0;
               scale = Number(_labelPlacement.scale);
               for(i = 0; i < lcount; i++)
               {
                  ldi = _labels[i];
                  rotatedHeight = c * ldi.height * heightContribution * scale + s * ldi.width * scale;
                  labelHeight = Math.max(rotatedHeight,labelHeight);
               }
               _maxRotatedLabelHeight = labelHeight;
               calcSize += labelHeight;
            }
         }
         else
         {
            measureLabels(false,width);
            _labelPlacement = {
               "rotation":0,
               "left":0,
               "right":0,
               "scale":1,
               "staggered":false
            };
         }
         var wmLeft:Number = Math.max(workingGutters.left,_labelPlacement.left);
         workingGutters = new Rectangle(wmLeft,workingGutters.top,Math.max(workingGutters.right,_labelPlacement.right) - wmLeft,Math.max(workingGutters.bottom,calcSize) - workingGutters.top);
         if(_inverted)
         {
            tmpGutter = workingGutters.top;
            workingGutters.top = workingGutters.bottom;
            workingGutters.bottom = tmpGutter;
         }
         _gutters = workingGutters;
         invalidateDisplayList();
         return gutters;
      }
      
      private function renderLabels() : void
      {
         var i:int = 0;
         var labelData:ARLabelData = null;
         var len:int = 0;
         var visCount:int = 0;
         var showLabelsStyle:Object = getStyle("showLabels");
         var showLabels:Boolean = showLabelsStyle != false && showLabelsStyle != "false";
         if(showLabels == false)
         {
            _labelCache.count = 0;
         }
         else
         {
            _labelCache.count = _labels.length;
            len = int(_labels.length);
            if(!_labelRenderer)
            {
               _labelCache.format = determineTextFormatFromStyles();
               for(i = 0; i < len; i++)
               {
                  labelData = _labels[i];
                  labelData.instance = _labelCache.instances[visCount++];
                  (labelData.instance as IUITextField).htmlText = labelData.text;
                  labelData.instance.width = labelData.width;
                  labelData.instance.height = labelData.height;
               }
            }
            else
            {
               while(i < len)
               {
                  labelData = _labels[i];
                  labelData.instance = _labelCache.instances[visCount++];
                  (labelData.instance as IDataRenderer).data = labelData.value;
                  (labelData.instance as IFlexDisplayObject).setActualSize(labelData.width * _labelPlacement.scale,labelData.height * _labelPlacement.scale);
                  i++;
               }
            }
         }
      }
      
      private function measureHorizontalGutters(width:Number, leftGutter:Number, rightGutter:Number, firstLabel:ARLabelData, lastLabel:ARLabelData, adjustable:Object) : Object
      {
         var lhm:Number = NaN;
         var rhm:Number = NaN;
         var labelAlignOffset:Number = this.labelAlignOffset;
         var axisLength:Number = width - leftGutter - rightGutter;
         var LS:Number = firstLabel.width * labelAlignOffset;
         var RS:Number = lastLabel.width * (1 - labelAlignOffset);
         var P1:Number = firstLabel.position;
         var P2:Number = 1 - lastLabel.position;
         var leftOverlaps:Boolean = adjustable.left != false && LS > leftGutter + P1 * axisLength;
         var rightOverlaps:Boolean = adjustable.right != false && RS > rightGutter + P2 * axisLength;
         if(leftOverlaps == false && rightOverlaps == false)
         {
            lhm = leftGutter;
            rhm = rightGutter;
         }
         else if(leftOverlaps == true && rightOverlaps == false)
         {
            axisLength = (width - rightGutter - LS) / (1 - P1);
            lhm = width - rightGutter - axisLength;
            rhm = rightGutter;
            rightOverlaps = RS > rhm + P2 * axisLength;
         }
         else if(leftOverlaps == false && rightOverlaps == true)
         {
            axisLength = (width - leftGutter - RS) / (1 - P2);
            lhm = leftGutter;
            rhm = width - leftGutter - axisLength;
            leftOverlaps = LS > lhm + P1 * axisLength;
         }
         if(leftOverlaps && rightOverlaps)
         {
            axisLength = (width - LS - RS) / (1 - P1 - P2);
            lhm = LS - P1 * axisLength;
            rhm = RS - P2 * axisLength;
         }
         return {
            "horizontalleftGutter":lhm,
            "horizontalrightGutter":rhm,
            "minimumAxisLength":width - lhm - rhm
         };
      }
      
      [Inspectable(category="General")]
      public function get titleRenderer() : IFactory
      {
         return _titleRenderer;
      }
      
      public function set horizontal(value:Boolean) : void
      {
         _horizontal = value;
         updateRotation();
      }
      
      public function set axis(value:IAxis) : void
      {
         if(Boolean(_axis))
         {
            _axis.removeEventListener("axisChange",axisChangeHandler,false);
            _axis.removeEventListener("titleChange",titleChangeHandler,false);
         }
         _axis = value;
         value.addEventListener("axisChange",axisChangeHandler,false,0,true);
         value.addEventListener("titleChange",titleChangeHandler,false,0,true);
      }
      
      override public function invalidateDisplayList() : void
      {
         if(_supressInvalidations == 0)
         {
            super.invalidateDisplayList();
         }
      }
      
      private function calcVerticalGutters(width:Number, leftGutter:Number, rightGutter:Number, firstLabel:ARLabelData, lastLabel:ARLabelData, adjustable:Object) : Object
      {
         var lhm:Number = NaN;
         var rhm:Number = NaN;
         var labelAlignOffset:Number = this.labelAlignOffset;
         var axisLength:Number = width - leftGutter - rightGutter;
         var LS:Number = firstLabel.height * labelAlignOffset;
         var RS:Number = firstLabel.height * (1 - labelAlignOffset);
         var P1:Number = firstLabel.position;
         var P2:Number = 1 - lastLabel.position;
         var leftOverlaps:Boolean = adjustable.left != false && LS > leftGutter + P1 * axisLength;
         var rightOverlaps:Boolean = adjustable.right != false && RS > rightGutter + P2 * axisLength;
         if(leftOverlaps == false && rightOverlaps == false)
         {
            lhm = leftGutter;
            rhm = rightGutter;
         }
         else if(leftOverlaps == true && rightOverlaps == false)
         {
            axisLength = (width - rightGutter - LS) / (1 - P1);
            lhm = width - rightGutter - axisLength;
            rhm = rightGutter;
            rightOverlaps = RS > rhm + P2 * axisLength;
         }
         else if(leftOverlaps == false && rightOverlaps == true)
         {
            axisLength = (width - leftGutter - RS) / (1 - P2);
            lhm = leftGutter;
            rhm = width - leftGutter - axisLength;
            leftOverlaps = LS > lhm + P1 * axisLength;
         }
         if(leftOverlaps && rightOverlaps)
         {
            axisLength = (width - LS - RS) / (1 - P1 - P2);
            lhm = LS - P1 * axisLength;
            rhm = RS - P2 * axisLength;
         }
         return {
            "hlm":lhm,
            "hrm":rhm,
            "minimumAxisLength":width - lhm - rhm
         };
      }
      
      private function axisChangeHandler(event:Event) : void
      {
         if(Boolean(chart))
         {
            chart.invalidateDisplayList();
         }
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var calcSize:Number = 0;
         var showLabelsStyle:Object = getStyle("showLabels");
         var showLabels:Boolean = showLabelsStyle != false && showLabelsStyle != "false";
         var showLineStyle:Object = getStyle("showLine");
         var showLine:Boolean = showLineStyle != false && showLineStyle != "false";
         var axisStroke:IStroke = getStyle("axisStroke");
         calcSize += tickSize(showLine);
         calcSize += getStyle("labelGap");
         calcSize += Number(showLine == true && Boolean(axisStroke) ? axisStroke.weight : 0);
         var titleHeight:Number = 0;
         var titleScale:Number = 1;
         var titleSize:Point = measureTitle();
         titleHeight = titleSize.y;
         calcSize += titleHeight;
         if(_horizontal)
         {
            measuredMinHeight = calcSize;
         }
         else
         {
            measuredMinWidth = calcSize;
         }
      }
      
      private function updateCaches() : void
      {
         var sm:ISystemManager = null;
         var embedFonts:Boolean = false;
         if(_cacheDirty)
         {
            _labelFormatCache = determineTextFormatFromStyles();
            sm = systemManager as ISystemManager;
            embedFonts = _canRotate = sm.isFontFaceEmbedded(_labelFormatCache);
            if(!_labelRenderer)
            {
               _labelCache.properties = {
                  "embedFonts":embedFonts,
                  "selectable":false,
                  "styleName":this,
                  "autoSize":"left"
               };
            }
            else
            {
               _labelCache.properties = {};
            }
            _cacheDirty = false;
         }
      }
      
      private function renderTitle() : void
      {
         var styleName:Object = null;
         if(Boolean(_titleField))
         {
            removeChild(_titleField);
         }
         if(Boolean(_titleRenderer))
         {
            _titleField = _titleRenderer.newInstance();
         }
         else
         {
            _titleField = new ChartLabel();
         }
         _titleField.visible = false;
         addChild(_titleField);
         _titleFieldChanged = true;
         if(_titleFieldChanged)
         {
            _titleFieldChanged = false;
            styleName = getStyle("axisTitleStyleName");
            if(styleName != null)
            {
               _titleField.styleName = styleName;
            }
            else
            {
               _titleField.styleName = this;
            }
         }
      }
      
      private function drawLabels(showLine:Boolean) : Number
      {
         var labelBottom:Number = NaN;
         var labelY:Number = NaN;
         var xAdjustment:Number = NaN;
         var ldi:ARLabelData = null;
         var r:Number = NaN;
         var baseline:Number = NaN;
         var oddLabelYOffset:Number = NaN;
         var staggerCount:int = 0;
         var thisLabel:ARLabelData = null;
         var c:Number = NaN;
         var s:Number = NaN;
         var axisStroke:IStroke = getStyle("axisStroke");
         renderLabels();
         var firstLabel:ARLabelData = _labels[0];
         if(_inverted)
         {
            baseline = _gutters.top - Number(showLine == true ? axisStroke.weight : 0) - tickSize(showLine);
         }
         else
         {
            baseline = unscaledHeight - _gutters.bottom + Number(showLine == true ? axisStroke.weight : 0) + tickSize(showLine);
         }
         var scale:Number = Number(_labelPlacement.scale);
         var lcount:int = int(_labels.length);
         var showLabelsStyle:Object = getStyle("showLabels");
         var showLabels:Boolean = showLabelsStyle != false && showLabelsStyle != "false";
         if(showLabels == false)
         {
            return baseline;
         }
         var hscale:Number = scale;
         for(var i:int = 0; i < lcount; i++)
         {
            ldi = _labels[i];
            ldi.instance.scaleX = ldi.instance.scaleY = hscale;
         }
         var axisWidth:Number = unscaledWidth - _gutters.left - _gutters.right;
         var labelGap:Number = Number(getStyle("labelGap"));
         var alignOffset:Number = this.labelAlignOffset;
         if(_labelPlacement.rotation == 0)
         {
            oddLabelYOffset = 0;
            if(Boolean(_labelPlacement.staggered))
            {
               oddLabelYOffset = scale * _maxLabelHeight * Number(_inverted ? -1 : 1);
            }
            if(_inverted)
            {
               labelY = baseline - labelGap - _maxLabelHeight * scale;
               labelBottom = labelY - oddLabelYOffset;
            }
            else
            {
               labelY = baseline + labelGap;
               labelBottom = labelY + _maxLabelHeight * scale + oddLabelYOffset;
            }
            staggerCount = 0;
            for(i = 0; i < lcount; i++)
            {
               thisLabel = _labels[i];
               thisLabel.instance.rotation = 0;
               thisLabel.instance.x = _gutters.left + axisWidth * thisLabel.position - thisLabel.width * scale * alignOffset;
               thisLabel.instance.y = labelY + staggerCount * oddLabelYOffset;
               staggerCount = 1 - staggerCount;
            }
         }
         else if(_labelPlacement.rotation > 0)
         {
            xAdjustment = 2 + Math.sin(_labelPlacement.rotation) * firstLabel.height * scale / 2;
            if(_inverted)
            {
               labelY = baseline - labelGap;
               if(_horizontal)
               {
                  r = _labelPlacement.rotation / Math.PI * 180;
                  c = Math.cos(Math.abs(_labelPlacement.rotation));
                  s = Math.sin(Math.abs(_labelPlacement.rotation));
                  alignOffset = 1 - alignOffset;
                  for(i = 0; i < lcount; i++)
                  {
                     ldi = _labels[i];
                     ldi.instance.rotation = r;
                     ldi.instance.x = _gutters.left + axisWidth * ldi.position - ldi.width * scale * c + ldi.height * alignOffset * scale * s;
                     ldi.instance.y = labelY - ldi.width * scale * s - ldi.height * alignOffset * scale * c;
                  }
                  labelBottom = labelY - _maxRotatedLabelHeight;
               }
               else
               {
                  r = -90 - (90 - _labelPlacement.rotation / Math.PI * 180);
                  c = Math.cos(Math.abs(_labelPlacement.rotation));
                  s = Math.sin(Math.abs(_labelPlacement.rotation));
                  for(i = 0; i < lcount; i++)
                  {
                     ldi = _labels[i];
                     ldi.instance.rotation = r;
                     ldi.instance.x = _gutters.left + axisWidth * ldi.position - ldi.height * alignOffset * scale * s;
                     ldi.instance.y = labelY + ldi.height * alignOffset * scale * c;
                  }
                  labelBottom = labelY - _maxRotatedLabelHeight;
               }
            }
            else
            {
               c = Math.cos(Math.abs(_labelPlacement.rotation));
               s = Math.sin(Math.abs(_labelPlacement.rotation));
               r = -_labelPlacement.rotation / Math.PI * 180;
               labelY = baseline + labelGap;
               for(i = 0; i < lcount; i++)
               {
                  ldi = _labels[i];
                  ldi.instance.rotation = r;
                  ldi.instance.x = _gutters.left + axisWidth * ldi.position - ldi.width * scale * c - ldi.height * alignOffset * scale * s;
                  ldi.instance.y = labelY + ldi.width * scale * s - ldi.height * alignOffset * scale * c;
               }
               labelBottom = labelY + _maxRotatedLabelHeight;
            }
         }
         else if(_inverted)
         {
            if(_horizontal)
            {
               r = _labelPlacement.rotation / Math.PI * 180;
               c = Math.cos(Math.abs(_labelPlacement.rotation));
               s = Math.sin(Math.abs(_labelPlacement.rotation));
               labelY = baseline - labelGap;
               for(i = 0; i < lcount; i++)
               {
                  ldi = _labels[i];
                  ldi.instance.rotation = r;
                  ldi.instance.x = _gutters.left + axisWidth * ldi.position - ldi.height * alignOffset * scale * s;
                  ldi.instance.y = labelY - ldi.height * alignOffset * scale * c;
               }
               labelBottom = labelY + _maxRotatedLabelHeight;
            }
            else
            {
               r = _labelPlacement.rotation / Math.PI * 180;
               c = Math.cos(Math.abs(_labelPlacement.rotation));
               s = Math.sin(Math.abs(_labelPlacement.rotation));
               labelY = baseline - labelGap;
               for(i = 0; i < lcount; i++)
               {
                  ldi = _labels[i];
                  ldi.instance.rotation = r;
                  ldi.instance.x = _gutters.left + axisWidth * ldi.position - ldi.height * alignOffset * scale * s;
                  ldi.instance.y = labelY - ldi.height * alignOffset * scale * c;
               }
            }
         }
         else if(_horizontal)
         {
            r = -_labelPlacement.rotation / Math.PI * 180;
            c = Math.cos(Math.abs(_labelPlacement.rotation));
            s = Math.sin(Math.abs(_labelPlacement.rotation));
            labelY = baseline + labelGap;
            for(i = 0; i < lcount; i++)
            {
               ldi = _labels[i];
               ldi.instance.rotation = r;
               ldi.instance.x = _gutters.left + axisWidth * ldi.position + s * ldi.height * scale * alignOffset;
               ldi.instance.y = labelY - c * ldi.height * scale * alignOffset;
            }
            labelBottom = labelY + _maxRotatedLabelHeight;
         }
         else
         {
            r = -180 - _labelPlacement.rotation / Math.PI * 180;
            c = Math.cos(Math.abs(_labelPlacement.rotation + Math.PI / 2));
            s = Math.sin(Math.abs(_labelPlacement.rotation + Math.PI / 2));
            labelY = baseline + labelGap;
            for(i = 0; i < lcount; i++)
            {
               ldi = _labels[i];
               ldi.instance.rotation = r;
               ldi.instance.x = _gutters.left + axisWidth * ldi.position - ldi.height * alignOffset * scale * c + ldi.width * scale * s;
               ldi.instance.y = labelY + ldi.height * alignOffset * scale * s + ldi.width * scale * c;
            }
            labelBottom = labelY + _maxRotatedLabelHeight;
         }
         return labelBottom;
      }
      
      private function get labelAlignOffset() : Number
      {
         var result:Number = NaN;
         var labelAlign:String = getStyle("labelAlign");
         switch(labelAlign)
         {
            case "left":
            case "top":
               result = 1;
               break;
            case "right":
            case "bottom":
               result = 0;
               break;
            case "center":
            default:
               result = 0.5;
         }
         return result;
      }
      
      private function updateRotation() : void
      {
         rotation = Number(_horizontal ? 0 : 90);
      }
      
      private function tickSize(showLine:Boolean) : Number
      {
         var tickLength:Number = Number(getStyle("tickLength"));
         var tickPlacement:String = getStyle("tickPlacement");
         var axisStroke:IStroke = getStyle("axisStroke");
         var rv:Number = 0;
         switch(tickPlacement)
         {
            case "cross":
               if(showLine)
               {
                  rv = tickLength + axisStroke.weight;
               }
               else
               {
                  rv = tickLength;
               }
               break;
            case "inside":
               rv = 0;
               break;
            case "none":
               rv = 0;
               break;
            default:
            case "outside":
               rv = tickLength;
         }
         return rv;
      }
      
      public function set gutters(value:Rectangle) : void
      {
         var correctedGutters:Rectangle = value;
         if(Boolean(_gutters && _gutters.left == correctedGutters.left && _gutters.right == correctedGutters.right) && Boolean(_gutters.top == correctedGutters.top) && _gutters.bottom == correctedGutters.bottom)
         {
            _gutters = correctedGutters;
            return;
         }
         adjustGutters(value,{
            "left":false,
            "top":false,
            "right":false,
            "bottom":false
         });
      }
      
      private function drawTitle(labelBottom:Number) : void
      {
         if(_axis.title == "")
         {
            if(Boolean(_titleField))
            {
               _titleField.visible = false;
            }
            return;
         }
         _titleField.visible = true;
         _titleField.setActualSize(_titleField.measuredWidth,_titleField.measuredHeight);
         var m:Matrix = _titleField.transform.matrix;
         m.a = Math.min(1,(unscaledWidth - _gutters.left - _gutters.right) / _titleField.measuredWidth);
         if(m.a < 0)
         {
            m.a = 0;
         }
         m.d = Math.min(1,1.3 * m.a);
         _titleField.transform.matrix = m;
         _titleField.y = Number(_inverted ? labelBottom - _titleField.measuredHeight : labelBottom);
         _titleField.x = _gutters.left + (unscaledWidth - _gutters.left - _gutters.right - _titleField.measuredWidth * m.a) / 2;
      }
      
      public function set titleRenderer(value:IFactory) : void
      {
         var oldTR:IFactory = _titleRenderer;
         _titleRenderer = value;
         if(oldTR == value)
         {
            return;
         }
         if(Boolean(chart))
         {
            chart.invalidateDisplayList();
         }
         invalidateDisplayList();
      }
      
      [Inspectable(environment="none")]
      public function get ticks() : Array
      {
         return _ticks;
      }
      
      private function drawTicks(showLine:Boolean) : Number
      {
         var w:Number = NaN;
         var a:Number = NaN;
         var left:Number = NaN;
         var right:Number = NaN;
         var axisStart:Number = NaN;
         var axisLength:Number = NaN;
         var tickStart:Number = NaN;
         var tickEnd:Number = NaN;
         var oldWeight:Number = NaN;
         var i:int = 0;
         var minorTicks:Array = null;
         var axisStroke:IStroke = getStyle("axisStroke");
         var axisWeight:Number = Number(showLine == true ? axisStroke.weight : 0);
         var baseline:Number = Number(_inverted ? _gutters.top : unscaledHeight - _gutters.bottom);
         var tickLen:Number = Number(getStyle("tickLength"));
         var tickPlacement:String = getStyle("tickPlacement");
         if(_inverted)
         {
            tickLen *= -1;
            axisWeight *= -1;
         }
         var tickStroke:IStroke = getStyle("tickStroke");
         switch(tickPlacement)
         {
            case "inside":
               tickStart = baseline - tickLen;
               tickEnd = baseline;
               break;
            case "outside":
            default:
               tickStart = baseline + axisWeight;
               tickEnd = baseline + axisWeight + tickLen;
               break;
            case "cross":
               tickStart = baseline - tickLen;
               tickEnd = baseline + axisWeight + tickLen;
               break;
            case "none":
               tickStart = 0;
               tickEnd = 0;
         }
         var tickCount:int = int(_ticks.length);
         axisStart = _gutters.left;
         axisLength = unscaledWidth - _gutters.left - _gutters.right;
         var g:Graphics = graphics;
         if(tickStart != tickEnd)
         {
            oldWeight = Number(tickStroke.weight);
            tickStroke.weight = _labelPlacement.scale * Number(tickStroke.weight == 0 ? 1 : tickStroke.weight);
            tickStroke.apply(g);
            tickStroke.weight = oldWeight;
            for(i = 0; i < tickCount; i++)
            {
               left = axisStart + axisLength * _ticks[i];
               g.moveTo(left,tickStart);
               g.lineTo(left,tickEnd);
            }
         }
         var minorTickStroke:IStroke = getStyle("minorTickStroke");
         axisStart = _gutters.left;
         axisLength = unscaledWidth - _gutters.left - _gutters.right;
         tickLen = Number(getStyle("minorTickLength"));
         tickPlacement = getStyle("minorTickPlacement");
         tickStart = tickEnd = 0;
         if(_inverted)
         {
            tickLen *= -1;
         }
         switch(tickPlacement)
         {
            case "inside":
               tickStart = baseline - tickLen;
               tickEnd = baseline;
               break;
            case "outside":
            default:
               tickStart = baseline + axisWeight;
               tickEnd = baseline + axisWeight + tickLen;
               break;
            case "cross":
               tickStart = baseline - tickLen;
               tickEnd = baseline + axisWeight + tickLen;
               break;
            case "none":
               tickStart = 0;
               tickEnd = 0;
         }
         if(tickStart != tickEnd)
         {
            minorTicks = _minorTicks;
            tickCount = Boolean(minorTicks) ? int(minorTicks.length) : 0;
            oldWeight = Number(minorTickStroke.weight);
            minorTickStroke.weight = _labelPlacement.scale * Number(minorTickStroke.weight == 0 ? 1 : minorTickStroke.weight);
            minorTickStroke.apply(g);
            minorTickStroke.weight = oldWeight;
            for(i = 0; i < tickCount; i++)
            {
               left = axisStart + axisLength * minorTicks[i];
               g.moveTo(left,tickStart);
               g.lineTo(left,tickEnd);
            }
         }
         return baseline + tickEnd;
      }
      
      private function measureTitle() : Point
      {
         if(!_axis || !_axis.title || _axis.title.length == 0)
         {
            return new Point(0,0);
         }
         renderTitle();
         ++_supressInvalidations;
         (_titleField as IDataRenderer).data = Boolean(_axis) ? _axis.title : "";
         _titleField.validateProperties();
         _titleField.validateSize(true);
         --_supressInvalidations;
         return new Point(_titleField.measuredWidth,_titleField.measuredHeight);
      }
      
      public function set highlightElements(value:Boolean) : void
      {
         if(value == _highlightElements)
         {
            return;
         }
         _highlightElements = value;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      public function get axis() : IAxis
      {
         return _axis;
      }
      
      public function set otherAxes(value:Array) : void
      {
         _otherAxes = value;
      }
      
      public function set labelRenderer(value:IFactory) : void
      {
         var oldLR:IFactory = _labelRenderer;
         _labelRenderer = value;
         if(oldLR == value)
         {
            return;
         }
         if(Boolean(_measuringField))
         {
            removeChild(_measuringField);
            _measuringField = null;
         }
         _labelCache.discard = true;
         _labelCache.count = 0;
         _labelCache.discard = false;
         if(!value)
         {
            _labelCache.factory = textFieldFactory;
         }
         else
         {
            _labelCache.factory = _labelRenderer;
         }
         if(Boolean(chart))
         {
            chart.invalidateDisplayList();
         }
         _forceLabelUpdate = true;
         _cacheDirty = true;
         invalidateDisplayList();
      }
      
      public function set heightLimit(value:Number) : void
      {
         _heightLimit = value;
      }
      
      [Inspectable(category="General")]
      public function get gutters() : Rectangle
      {
         if(_horizontal == false)
         {
            return new Rectangle(_gutters.bottom,_gutters.left,-_gutters.height,_gutters.width);
         }
         return _gutters;
      }
      
      private function calcHorizontalSpacing(width:Number, horizontalGutterData:Object, targetHeight:Number, firstLabel:ARLabelData, lastLabel:ARLabelData, canDropLabels:Boolean, adjustable:Object, minimumAxisLength:Number) : Object
      {
         var thisLabel:ARLabelData = null;
         var spaceBetween:Number = NaN;
         var requiredSpace:Number = NaN;
         var base:int = 0;
         var dir:int = 0;
         var maxSkipCount:int = 0;
         var bLabelsReduced:Boolean = false;
         var bSkipRequired:Boolean = false;
         var skipCount:* = undefined;
         var firstIntervalLabel:* = undefined;
         var lastIntervalLabel:* = undefined;
         var i:* = undefined;
         var horizontalleftGutter:Number = Number(horizontalGutterData.horizontalleftGutter);
         var horizontalrightGutter:Number = Number(horizontalGutterData.horizontalrightGutter);
         var horizontalScale:Number = 1;
         if(!isNaN(targetHeight))
         {
            horizontalScale = Math.min(1,targetHeight / _maxLabelHeight);
         }
         var prevLabel:ARLabelData = firstLabel;
         var len:int = int(_labels.length);
         var axisLength:Number = width - horizontalleftGutter - horizontalrightGutter;
         var scalingRequired:Boolean = true;
         if(canDropLabels)
         {
            maxSkipCount = 0;
            bSkipRequired = true;
            do
            {
               maxSkipCount = 0;
               skipCount = 0;
               if(_horizontal)
               {
                  if(_labels.length > 0)
                  {
                     prevLabel = _labels[0];
                  }
                  base = 0;
                  dir = 1;
               }
               else
               {
                  if(_labels.length > 0)
                  {
                     prevLabel = _labels[_labels.length - 1];
                  }
                  base = _labels.length - 1;
                  dir = -1;
               }
               for(i = 1; i < _labels.length; i++)
               {
                  thisLabel = _labels[base + dir * i];
                  spaceBetween = Math.abs(thisLabel.position - prevLabel.position) * axisLength;
                  requiredSpace = (thisLabel.width + prevLabel.width) / 2;
                  if(requiredSpace > spaceBetween)
                  {
                     skipCount++;
                  }
                  else
                  {
                     if(skipCount > maxSkipCount)
                     {
                        maxSkipCount = skipCount;
                        firstIntervalLabel = prevLabel;
                        lastIntervalLabel = _labels[base + dir * (i - 1)];
                     }
                     skipCount = 0;
                     prevLabel = thisLabel;
                  }
               }
               if(skipCount > maxSkipCount)
               {
                  maxSkipCount = skipCount;
                  firstIntervalLabel = prevLabel;
                  lastIntervalLabel = _labels[base + dir * (i - 1)];
               }
               if(Boolean(maxSkipCount))
               {
                  bLabelsReduced = reduceLabels(firstIntervalLabel.value,lastIntervalLabel.value);
               }
               else
               {
                  bSkipRequired = false;
                  scalingRequired = false;
               }
            }
            while(bSkipRequired && bLabelsReduced);
         }
         if(scalingRequired)
         {
            if(adjustable.left == false)
            {
               horizontalScale = Math.min(horizontalScale,(horizontalleftGutter + firstLabel.position * axisLength) / (firstLabel.width / 2));
            }
            if(adjustable.right == false)
            {
               horizontalScale = Math.min(horizontalScale,(horizontalrightGutter + (1 - lastLabel.position) * axisLength) / (lastLabel.width / 2));
            }
            prevLabel = _labels[0];
            len = int(_labels.length);
            for(i = 1; i < len; i++)
            {
               thisLabel = _labels[i];
               spaceBetween = (thisLabel.position - prevLabel.position) * axisLength;
               requiredSpace = (thisLabel.width + prevLabel.width) / 2;
               horizontalScale = Math.min(horizontalScale,spaceBetween / requiredSpace);
               prevLabel = thisLabel;
            }
         }
         return {
            "rotation":0,
            "left":horizontalleftGutter,
            "right":horizontalrightGutter,
            "scale":Math.max(0,horizontalScale),
            "staggered":false
         };
      }
      
      private function calcAngledSpacing(angledGutterData:Object) : Object
      {
         var halfMaxStackedHeight:Number = angledGutterData.sint * angledGutterData.minDist * angledGutterData.minimumAxisLength;
         angledGutterData.scale = Math.max(0,Math.min(angledGutterData.scale,halfMaxStackedHeight / _maxLabelHeight));
         return angledGutterData;
      }
      
      public function get minorTicks() : Array
      {
         return _minorTicks;
      }
      
      override public function setActualSize(w:Number, h:Number) : void
      {
         var oldX:Number = NaN;
         if(_horizontal)
         {
            super.setActualSize(w,h);
         }
         else
         {
            oldX = x - unscaledHeight;
            super.setActualSize(h,w);
            move(oldX + w,y);
         }
      }
      
      [Inspectable(category="General",defaltValue="false")]
      public function get highlightElements() : Boolean
      {
         return _highlightElements;
      }
      
      private function calcRotationAndSpacing(width:Number, height:Number, targetHeight:Number, workingGutters:Rectangle, adjustable:Object) : Object
      {
         var canDropLabels:Boolean = false;
         var verticalData:Object = null;
         var horizontalGutterData:Object = null;
         var angledGutterData:Object = null;
         var angledSpacingData:Object = null;
         var horizontalSpacingData:Object = null;
         var staggeredSpacingData:Object = null;
         updateCaches();
         var leftGutter:Number = workingGutters.left;
         var rightGutter:Number = workingGutters.right;
         var bEstimateIsAccurate:Boolean = measureLabels(true,0);
         if(_labels.length == 0)
         {
            return {
               "rotation":0,
               "left":leftGutter,
               "right":rightGutter,
               "scale":1,
               "staggered":false
            };
         }
         var firstLabel:ARLabelData = _labels[0];
         var lastLabel:ARLabelData = _labels[_labels.length - 1];
         var labelRotation:Number = Number(getStyle("labelRotation"));
         if(labelRotation > 90)
         {
            labelRotation = 0 / 0;
         }
         if(_horizontal == false)
         {
            if(isNaN(labelRotation))
            {
               labelRotation = 0;
            }
            if(labelRotation >= 0)
            {
               labelRotation = 90 - labelRotation;
            }
            else
            {
               labelRotation = -(90 + labelRotation);
            }
         }
         var canDropLabelsStyle:Object = getStyle("canDropLabels");
         if(canDropLabelsStyle == null)
         {
            canDropLabels = Boolean(_axis.preferDropLabels());
         }
         else
         {
            canDropLabels = canDropLabelsStyle != false && canDropLabelsStyle != "false";
         }
         var mustLayoutVertical:Boolean = _horizontal && _canRotate && labelRotation == 90 || _horizontal == false && (isNaN(labelRotation) || labelRotation == 90 || _canRotate == false);
         var canLayoutHorizontal:Boolean = mustLayoutVertical == false && (isNaN(labelRotation) && _horizontal == true || labelRotation == 0 || _canRotate == false);
         var horizontalScale:Number = 0;
         var canStaggerStyle:Object = getStyle("canStagger");
         var canStagger:Boolean = canStaggerStyle == null || canStaggerStyle != false && canStaggerStyle != "false";
         var canLayoutStaggered:Boolean = mustLayoutVertical == false && (canDropLabels == false && canLayoutHorizontal && false != canStaggerStyle);
         var staggeredScale:Number = 0;
         var canLayoutAngled:Boolean = mustLayoutVertical == false && (_canRotate == true && labelRotation != 0 && (canDropLabels == false || !isNaN(labelRotation)));
         var angledScale:Number = 0;
         var minimumAxisLength:Number = width - leftGutter - rightGutter;
         if(bEstimateIsAccurate)
         {
            if(mustLayoutVertical)
            {
               verticalData = calcVerticalGutters(width,leftGutter,rightGutter,firstLabel,lastLabel,adjustable);
               return calcVerticalSpacing(width,verticalData,targetHeight,firstLabel,lastLabel,canDropLabels);
            }
            if(canLayoutHorizontal || canLayoutStaggered)
            {
               horizontalGutterData = measureHorizontalGutters(width,leftGutter,rightGutter,firstLabel,lastLabel,adjustable);
               horizontalSpacingData = calcHorizontalSpacing(width,horizontalGutterData,targetHeight,firstLabel,lastLabel,canDropLabels,adjustable,minimumAxisLength);
               horizontalScale = Number(horizontalSpacingData.scale);
               if(horizontalScale != 1 && canLayoutStaggered)
               {
                  staggeredSpacingData = calcStaggeredSpacing(width,horizontalGutterData,targetHeight,firstLabel,lastLabel,canDropLabels,adjustable);
                  staggeredScale = Number(staggeredSpacingData.scale);
               }
            }
            if(horizontalScale != 1 && staggeredScale != 1 && canLayoutAngled)
            {
               angledGutterData = measureAngledGutters(width,labelRotation,targetHeight,firstLabel,leftGutter,rightGutter,adjustable);
               angledSpacingData = calcAngledSpacing(angledGutterData);
               angledScale = Number(angledSpacingData.scale);
            }
            if(horizontalScale >= staggeredScale && horizontalScale >= angledScale)
            {
               if(horizontalSpacingData != null)
               {
                  return horizontalSpacingData;
               }
               return angledSpacingData;
            }
            if(staggeredScale >= angledScale)
            {
               if(staggeredSpacingData != null)
               {
                  return staggeredSpacingData;
               }
               return angledSpacingData;
            }
            return angledSpacingData;
         }
         if(mustLayoutVertical)
         {
            verticalData = calcVerticalGutters(width,leftGutter,rightGutter,firstLabel,lastLabel,adjustable);
            minimumAxisLength = Math.min(minimumAxisLength,verticalData.minimumAxisLength);
         }
         if(canLayoutHorizontal || canLayoutStaggered)
         {
            horizontalGutterData = measureHorizontalGutters(width,leftGutter,rightGutter,firstLabel,lastLabel,adjustable);
            minimumAxisLength = Math.min(minimumAxisLength,horizontalGutterData.minimumAxisLength);
         }
         if(canLayoutAngled)
         {
            angledGutterData = measureAngledGutters(width,labelRotation,targetHeight,firstLabel,leftGutter,rightGutter,adjustable);
            minimumAxisLength = Math.min(minimumAxisLength,angledGutterData.minimumAxisLength);
         }
         measureLabels(false,minimumAxisLength);
         if(_labels.length == 0)
         {
            return {
               "rotation":0,
               "left":leftGutter,
               "right":rightGutter,
               "scale":1,
               "staggered":false
            };
         }
         if(mustLayoutVertical)
         {
            return calcVerticalSpacing(width,verticalData,targetHeight,firstLabel,lastLabel,canDropLabels);
         }
         if(canLayoutHorizontal)
         {
            horizontalSpacingData = calcHorizontalSpacing(width,horizontalGutterData,targetHeight,firstLabel,lastLabel,canDropLabels,adjustable,minimumAxisLength);
            horizontalScale = Number(horizontalSpacingData.scale);
         }
         if(canLayoutStaggered)
         {
            staggeredSpacingData = calcStaggeredSpacing(width,horizontalGutterData,targetHeight,firstLabel,lastLabel,canDropLabels,adjustable);
            staggeredScale = Number(staggeredSpacingData.scale);
         }
         if(canLayoutAngled)
         {
            angledSpacingData = calcAngledSpacing(angledGutterData);
            angledScale = Number(angledSpacingData.scale);
         }
         if(horizontalScale >= staggeredScale && horizontalScale >= angledScale)
         {
            if(horizontalSpacingData != null)
            {
               return horizontalSpacingData;
            }
            return angledSpacingData;
         }
         if(staggeredScale >= angledScale)
         {
            if(staggeredSpacingData != null)
            {
               return staggeredSpacingData;
            }
            return angledSpacingData;
         }
         return angledSpacingData;
      }
      
      private function processAxisLabels(newLabelData:AxisLabelSet) : Boolean
      {
         var len:int = 0;
         var i:int = 0;
         var ltext:AxisLabel = null;
         var labelData:ARLabelData = null;
         var systemManager:ISystemManager = null;
         var measuringField:IUITextField = null;
         var tf:UITextFormat = null;
         var measuringLabel:IUIComponent = null;
         var ilcMeasuringLabel:ILayoutManagerClient = null;
         var doMeasuringLabel:IDataRenderer = null;
         var base:int = 0;
         var forwardTicks:Array = null;
         var labelValues:Array = [];
         var bUseRenderer:Boolean = _labelRenderer != null;
         ++_supressInvalidations;
         len = int(newLabelData.labels.length);
         _labels = [];
         for(i = 0; i < len; i++)
         {
            labelValues.push(newLabelData.labels[i].text);
         }
         if(newLabelData != _axisLabelSet)
         {
            if(_labelFunction != null)
            {
               labelValues = [];
               for(i = 0; i < len; i++)
               {
                  labelValues.push(_labelFunction(this,newLabelData.labels[i].text));
               }
            }
         }
         var maxLabelWidth:Number = 0;
         var maxLabelHeight:Number = 0;
         if(!bUseRenderer)
         {
            systemManager = systemManager as ISystemManager;
            measuringField = _measuringField as IUITextField;
            if(!_measuringField)
            {
               measuringField = IUITextField(createInFontContext(UITextField));
               _measuringField = DisplayObject(measuringField);
            }
            tf = determineTextFormatFromStyles();
            measuringField.defaultTextFormat = tf;
            measuringField.setTextFormat(tf);
            measuringField.multiline = true;
            measuringField.antiAliasType = tf.antiAliasType;
            measuringField.gridFitType = tf.gridFitType;
            measuringField.sharpness = tf.sharpness;
            measuringField.thickness = tf.thickness;
            measuringField.autoSize = "left";
            measuringField.embedFonts = Boolean(systemManager) && Boolean(systemManager.isFontFaceEmbedded(tf));
         }
         else
         {
            measuringLabel = _measuringField as IUIComponent;
            if(!measuringLabel)
            {
               measuringLabel = _labelRenderer.newInstance();
               _measuringField = measuringLabel as DisplayObject;
               if(measuringLabel is ISimpleStyleClient)
               {
                  (measuringLabel as ISimpleStyleClient).styleName = this;
               }
               measuringLabel.visible = false;
               addChild(DisplayObject(measuringLabel));
            }
            ilcMeasuringLabel = measuringLabel as ILayoutManagerClient;
            doMeasuringLabel = measuringLabel as IDataRenderer;
         }
         if(_horizontal)
         {
            for(i = 0; i < len; i++)
            {
               ltext = newLabelData.labels[i];
               labelData = new ARLabelData(ltext,ltext.position,labelValues[i]);
               if(!bUseRenderer)
               {
                  measuringField.htmlText = labelValues[i];
                  labelData.width = measuringField.width;
                  labelData.height = measuringField.height;
               }
               else
               {
                  doMeasuringLabel.data = ltext;
                  if(Boolean(ilcMeasuringLabel))
                  {
                     ilcMeasuringLabel.validateSize(true);
                  }
                  labelData.width = measuringLabel.measuredWidth;
                  labelData.height = measuringLabel.measuredHeight;
               }
               maxLabelWidth = Math.max(maxLabelWidth,labelData.width);
               maxLabelHeight = Math.max(maxLabelHeight,labelData.height);
               _labels[i] = labelData;
            }
            _ticks = newLabelData.ticks == null ? [] : newLabelData.ticks;
            _minorTicks = newLabelData.minorTicks == null ? [] : newLabelData.minorTicks;
         }
         else
         {
            base = len - 1;
            for(i = 0; i < len; i++)
            {
               ltext = newLabelData.labels[i];
               labelData = new ARLabelData(ltext,1 - ltext.position,labelValues[i]);
               if(!bUseRenderer)
               {
                  measuringField.htmlText = labelValues[i];
                  labelData.width = measuringField.width;
                  labelData.height = measuringField.height;
               }
               else
               {
                  doMeasuringLabel.data = ltext;
                  if(Boolean(ilcMeasuringLabel))
                  {
                     ilcMeasuringLabel.validateSize(true);
                  }
                  labelData.width = measuringLabel.measuredWidth;
                  labelData.height = measuringLabel.measuredHeight;
               }
               maxLabelWidth = Math.max(maxLabelWidth,labelData.width);
               maxLabelHeight = Math.max(maxLabelHeight,labelData.height);
               _labels[base - i] = labelData;
            }
            _ticks = [];
            if(Boolean(newLabelData.ticks))
            {
               forwardTicks = newLabelData.ticks;
               len = int(forwardTicks.length);
               for(i = len - 1; i >= 0; i--)
               {
                  _ticks.push(1 - forwardTicks[i]);
               }
            }
            _minorTicks = [];
            if(Boolean(newLabelData.minorTicks))
            {
               forwardTicks = newLabelData.minorTicks;
               len = int(forwardTicks.length);
               for(i = len - 1; i >= 0; i--)
               {
                  _minorTicks.push(1 - forwardTicks[i]);
               }
            }
         }
         _maxLabelWidth = maxLabelWidth;
         _maxLabelHeight = maxLabelHeight;
         _forceLabelUpdate = false;
         --_supressInvalidations;
         return newLabelData.accurate == true;
      }
      
      private function measureAngledGutters(width:Number, labelRotation:Number, targetHeight:Number, firstLabel:ARLabelData, leftGutter:Number, rightGutter:Number, adjustable:Object) : Object
      {
         var sint:Number = NaN;
         var cost:Number = NaN;
         var angle:Number = NaN;
         var axisLength:Number = NaN;
         var sigLabel:ARLabelData = null;
         var maxPosition:Number = NaN;
         var preferredPosition:Number = NaN;
         var minPosition:Number = NaN;
         var i:int = 0;
         var thisLabel:ARLabelData = null;
         var bOutsideBounds:Boolean = false;
         var upperBound:Number = NaN;
         var lowerBound:Number = NaN;
         var currentPosition:* = undefined;
         var actualDistance:* = undefined;
         var stackedDistance:* = undefined;
         var diff:* = undefined;
         var angledleftGutter:Number = leftGutter;
         var angledrightGutter:Number = rightGutter;
         var angledScale:Number = 1;
         var minDist:Number = 1;
         var lastLabel:ARLabelData = _labels[0];
         var len:int = int(_labels.length);
         for(i = 1; i < len; i++)
         {
            thisLabel = _labels[i];
            minDist = Math.min(minDist,thisLabel.position - lastLabel.position);
            lastLabel = thisLabel;
         }
         if(!isNaN(labelRotation))
         {
            angle = labelRotation / 180 * Math.PI;
         }
         else if(_horizontal == false)
         {
            angle = Math.PI / 2;
         }
         if(adjustable.left == false && (labelRotation >= 0 || isNaN(labelRotation)))
         {
            axisLength = width - angledleftGutter - angledrightGutter;
            if(isNaN(angle))
            {
               sint = _maxLabelHeight / (minDist * axisLength);
               if(sint >= 1)
               {
                  angle = Math.PI / 2;
                  sint = 1;
                  angledScale = Math.min(angledScale,(firstLabel.position * axisLength + angledleftGutter) / (firstLabel.height / 2));
               }
               else
               {
                  angle = Math.asin(sint);
                  if(Math.cos(angle) * firstLabel.width > firstLabel.position * axisLength + angledleftGutter)
                  {
                     angle = Math.acos((firstLabel.position * axisLength + angledleftGutter) / firstLabel.width);
                     sint = Math.sin(angle);
                  }
               }
            }
            else
            {
               sint = Math.sin(angle);
               if(sint < 1)
               {
                  angledScale = Math.min(angledScale,(firstLabel.position * axisLength + angledleftGutter) / (Math.cos(angle) * firstLabel.width));
               }
               else
               {
                  angledScale = Math.min(angledScale,(firstLabel.position * axisLength + angledleftGutter) / (firstLabel.height / 2));
               }
            }
            if(!isNaN(targetHeight))
            {
               angledScale = Math.min(angledScale,targetHeight / (_maxLabelWidth * sint + _maxLabelHeight * Math.cos(angle)));
            }
         }
         else if(adjustable.right == false && labelRotation < 0)
         {
            axisLength = width - angledleftGutter - angledrightGutter;
            sint = Math.sin(-angle);
            if(sint < 1)
            {
               angledScale = Math.min(angledScale,((1 - lastLabel.position) * axisLength + angledrightGutter) / (Math.cos(angle) * lastLabel.width));
            }
            else
            {
               angledScale = Math.min(angledScale,((1 - lastLabel.position) * axisLength + angledrightGutter) / (firstLabel.height / 2));
            }
            if(!isNaN(targetHeight))
            {
               angledScale = Math.min(angledScale,targetHeight / (_maxLabelWidth * sint + _maxLabelHeight * Math.cos(-angle)));
            }
         }
         else if(angle > 0)
         {
            sint = Math.sin(angle);
            cost = Math.cos(angle);
            sigLabel = firstLabel;
            if(!isNaN(targetHeight))
            {
               angledScale = Math.min(1,targetHeight / (_maxLabelWidth * sint));
            }
            if(adjustable.right != false)
            {
               angledrightGutter = Math.max(angledrightGutter,_labels[len - 1].height / 2 * angledScale);
            }
            axisLength = width - angledleftGutter - angledrightGutter;
            for(i = 0; i < len; i++)
            {
               sigLabel = _labels[i];
               minPosition = cost * sigLabel.width * angledScale + sigLabel.height / 2 * angledScale * sint;
               preferredPosition = angledleftGutter + axisLength * sigLabel.position;
               if(minPosition > preferredPosition)
               {
                  axisLength = (width - angledrightGutter - minPosition) / (1 - sigLabel.position);
                  angledleftGutter = width - axisLength - angledrightGutter;
               }
            }
         }
         else if(angle < 0)
         {
            sint = Math.sin(-angle);
            cost = Math.cos(-angle);
            sigLabel = lastLabel;
            if(!isNaN(targetHeight))
            {
               angledScale = Math.min(1,targetHeight / (_maxLabelWidth * sint));
            }
            if(adjustable.left != false)
            {
               angledleftGutter = Math.max(angledleftGutter,_labels[0].height / 2 * angledScale);
            }
            axisLength = width - angledleftGutter - angledrightGutter;
            for(i = len - 1; i >= 0; i--)
            {
               sigLabel = _labels[i];
               maxPosition = width - cost * sigLabel.width * angledScale - sint * sigLabel.height / 2 * angledScale;
               preferredPosition = angledleftGutter + axisLength * sigLabel.position;
               if(maxPosition < preferredPosition)
               {
                  axisLength = (maxPosition - angledleftGutter) / sigLabel.position;
                  angledrightGutter = width - axisLength - angledleftGutter;
               }
            }
         }
         else
         {
            angledrightGutter = rightGutter;
            angledleftGutter = leftGutter;
            for(i = 0; i < _labels.length; i++)
            {
               sigLabel = _labels[i];
               bOutsideBounds = true;
               if(!isNaN(angle))
               {
                  bOutsideBounds = sigLabel.width * cost > angledleftGutter + axisLength * sigLabel.position;
               }
               if(bOutsideBounds)
               {
                  upperBound = Math.PI / 2;
                  lowerBound = 0;
                  angle = upperBound;
                  do
                  {
                     sint = Math.sin(angle);
                     cost = Math.cos(angle);
                     if(!isNaN(targetHeight))
                     {
                        angledScale = Math.min(1,targetHeight / (_maxLabelWidth * sint + _maxLabelHeight * cost));
                     }
                     minPosition = cost * sigLabel.width * angledScale;
                     currentPosition = Math.max(minPosition,leftGutter + (width - leftGutter - rightGutter) * sigLabel.position);
                     axisLength = (width - angledrightGutter - currentPosition) / (1 - sigLabel.position);
                     angledleftGutter = Math.max(leftGutter,width - axisLength - angledrightGutter);
                     actualDistance = minDist * axisLength;
                     stackedDistance = _maxLabelHeight * angledScale / sint;
                     diff = actualDistance - stackedDistance;
                     if(diff > 0 && diff < 1)
                     {
                        break;
                     }
                     if(actualDistance > stackedDistance)
                     {
                        if(lowerBound >= angle)
                        {
                           break;
                        }
                        upperBound = angle;
                     }
                     else
                     {
                        if(upperBound <= angle)
                        {
                           break;
                        }
                        lowerBound = angle;
                     }
                     if(upperBound - lowerBound < 0.00001)
                     {
                        break;
                     }
                     angle = lowerBound + (upperBound - lowerBound) / 2;
                  }
                  while(Boolean(1));
               }
            }
         }
         return {
            "minimumAxisLength":width - angledleftGutter - angledrightGutter,
            "left":angledleftGutter,
            "right":angledrightGutter,
            "scale":angledScale,
            "rotation":angle,
            "sint":sint,
            "minDist":minDist
         };
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(!labelRenderer && !_labelCache.factory)
         {
            _labelCache.factory = textFieldFactory;
         }
         setupMouseDispatching();
      }
      
      [Inspectable(category="General")]
      public function get labelRenderer() : IFactory
      {
         return _labelRenderer;
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         if(Boolean(chart))
         {
            chart.invalidateDisplayList();
         }
         _forceLabelUpdate = true;
         _cacheDirty = true;
         _axisLabelSet = null;
         invalidateDisplayList();
      }
      
      public function set placement(value:String) : void
      {
         _placement = value;
         _inverted = value == "right" || value == "top";
         if(Boolean(chart))
         {
            dispatchEvent(new Event("axisPlacementChange",true));
         }
         _forceLabelUpdate = true;
         _cacheDirty = true;
         invalidateDisplayList();
      }
      
      [Inspectable(category="Size")]
      public function get heightLimit() : Number
      {
         return _heightLimit;
      }
      
      [Inspectable(environment="none")]
      protected function get chart() : ChartBase
      {
         var p:DisplayObject = parent;
         while(!(p is ChartBase) && Boolean(p))
         {
            p = p.parent;
         }
         return p as ChartBase;
      }
      
      public function chartStateChanged(oldState:uint, newState:uint) : void
      {
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",enumeration="left,top,right,bottom")]
      public function get placement() : String
      {
         return _placement;
      }
      
      [Inspectable(environment="none")]
      public function get length() : Number
      {
         return unscaledWidth - _gutters.left - _gutters.right;
      }
      
      private function calcVerticalSpacing(width:Number, verticalData:Object, targetHeight:Number, firstLabel:ARLabelData, lastLabel:ARLabelData, canDropLabels:Boolean) : Object
      {
         var scale:Number = NaN;
         var thisLabel:ARLabelData = null;
         var spaceBetween:Number = NaN;
         var requiredSpace:Number = NaN;
         var base:int = 0;
         var dir:int = 0;
         var maxSkipCount:int = 0;
         var bLabelsReduced:Boolean = false;
         var bSkipRequired:Boolean = false;
         var skipCount:* = undefined;
         var firstIntervalLabel:* = undefined;
         var lastIntervalLabel:* = undefined;
         var i:* = undefined;
         var axisLength:Number = width - verticalData.hlm - verticalData.hrm;
         if(!isNaN(targetHeight))
         {
            scale = Math.min(1,targetHeight / _maxLabelWidth);
         }
         else
         {
            scale = 1;
         }
         var prevLabel:ARLabelData = firstLabel;
         var scalingRequired:Boolean = true;
         if(canDropLabels)
         {
            maxSkipCount = 0;
            bSkipRequired = true;
            do
            {
               maxSkipCount = 0;
               skipCount = 0;
               if(_horizontal)
               {
                  if(_labels.length > 0)
                  {
                     prevLabel = _labels[0];
                  }
                  base = 0;
                  dir = 1;
               }
               else
               {
                  if(_labels.length > 0)
                  {
                     prevLabel = _labels[_labels.length - 1];
                  }
                  base = _labels.length - 1;
                  dir = -1;
               }
               for(i = 1; i < _labels.length; i++)
               {
                  thisLabel = _labels[base + dir * i];
                  spaceBetween = Math.abs(thisLabel.position - prevLabel.position) * axisLength;
                  requiredSpace = (thisLabel.height + prevLabel.height) / 2;
                  if(requiredSpace <= spaceBetween)
                  {
                     if(skipCount > maxSkipCount)
                     {
                        maxSkipCount = skipCount;
                        firstIntervalLabel = prevLabel;
                        lastIntervalLabel = _labels[base + dir * (i - 1)];
                     }
                     break;
                  }
                  skipCount++;
               }
               if(skipCount > maxSkipCount)
               {
                  maxSkipCount = skipCount;
                  firstIntervalLabel = prevLabel;
                  lastIntervalLabel = _labels[base + dir * (i - 1)];
               }
               if(Boolean(maxSkipCount))
               {
                  bLabelsReduced = reduceLabels(firstIntervalLabel.value,lastIntervalLabel.value);
               }
               else
               {
                  bSkipRequired = false;
                  scalingRequired = false;
               }
            }
            while(bSkipRequired && bLabelsReduced);
         }
         if(scalingRequired)
         {
            prevLabel = _labels[0];
            for(i = 1; i < _labels.length; i++)
            {
               thisLabel = _labels[i];
               spaceBetween = (thisLabel.position - prevLabel.position) * axisLength;
               requiredSpace = (thisLabel.height + prevLabel.height) / 2;
               scale = Math.min(scale,spaceBetween / requiredSpace);
               prevLabel = thisLabel;
            }
         }
         return {
            "rotation":Math.PI / 2,
            "left":verticalData.hlm,
            "right":verticalData.hrm,
            "scale":Math.max(0,scale),
            "staggered":false
         };
      }
      
      override public function move(x:Number, y:Number) : void
      {
         if(_horizontal)
         {
            super.move(x,y);
         }
         else
         {
            super.move(x + unscaledHeight,y);
         }
      }
      
      override public function invalidateSize() : void
      {
         if(_supressInvalidations == 0)
         {
            super.invalidateSize();
         }
      }
      
      [Inspectable(category="General")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      private function setupMouseDispatching() : void
      {
         if(_highlightElements)
         {
            addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
            addEventListener(MouseEvent.MOUSE_MOVE,mouseOverHandler);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE,mouseOverHandler);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || styleProp == "axisTitleStyleName")
         {
            _titleFieldChanged = true;
         }
         if(Boolean(chart))
         {
            chart.invalidateDisplayList();
         }
         _axisLabelSet = null;
         _forceLabelUpdate = true;
         _cacheDirty = true;
         invalidateDisplayList();
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         AxisBase(_axis).highlightElements(true);
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         AxisBase(_axis).highlightElements(false);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var lineVisible:Boolean = false;
         var labelBottom:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         ++_supressInvalidations;
         var chart:ChartBase = this.chart;
         if(_bGuttersAdjusted == true && chart.chartState != ChartState.PREPARING_TO_HIDE_DATA && chart.chartState != ChartState.HIDING_DATA)
         {
            updateCaches();
            graphics.clear();
            lineVisible = Boolean(getStyle("showLine"));
            labelBottom = drawLabels(lineVisible);
            drawTitle(labelBottom);
            drawAxis(lineVisible);
            drawTicks(lineVisible);
         }
         --_supressInvalidations;
      }
      
      private function measureLabels(bEstimate:Boolean, minimumAxisLength:Number) : Boolean
      {
         var newLabelData:AxisLabelSet = null;
         if(!_axis)
         {
            throw new Error(resourceManager.getString("charts","noAxisSet"));
         }
         if(bEstimate)
         {
            newLabelData = _axis.getLabelEstimate();
         }
         else
         {
            newLabelData = _axis.getLabels(minimumAxisLength);
         }
         if(newLabelData == _axisLabelSet && _forceLabelUpdate == false)
         {
            return newLabelData.accurate;
         }
         var bResult:Boolean = processAxisLabels(newLabelData);
         _axisLabelSet = newLabelData;
         return bResult;
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
   }
}

import flash.display.DisplayObject;
import mx.charts.AxisLabel;

class ARLabelData
{
   
   public var width:Number;
   
   public var height:Number;
   
   public var position:Number;
   
   public var text:String;
   
   public var value:AxisLabel;
   
   public var instance:DisplayObject;
   
   public function ARLabelData(value:AxisLabel, position:Number, text:String)
   {
      super();
      this.value = value;
      this.position = position;
      this.text = text;
   }
}
