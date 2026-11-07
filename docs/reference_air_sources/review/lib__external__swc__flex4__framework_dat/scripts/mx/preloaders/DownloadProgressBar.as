package mx.preloaders
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.RSLEvent;
   import mx.geom.RoundedRectangle;
   import mx.graphics.RectangularDropShadow;
   
   use namespace mx_internal;
   
   public class DownloadProgressBar extends Sprite implements IPreloaderDisplay
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var _initializingLabel:String = "Initializing";
      
      protected var MINIMUM_DISPLAY_TIME:uint = 0;
      
      protected var DOWNLOAD_PERCENTAGE:uint = 60;
      
      private var _showProgressBar:Boolean = true;
      
      private var _labelRect:Rectangle;
      
      private var _percentRect:Rectangle;
      
      private var _borderRect:RoundedRectangle;
      
      private var _barFrameRect:RoundedRectangle;
      
      private var _barRect:RoundedRectangle;
      
      private var _xOffset:Number = 20;
      
      private var _yOffset:Number = 20;
      
      private var _maximum:Number = 0;
      
      private var _value:Number = 0;
      
      private var _barSprite:Sprite;
      
      private var _barFrameSprite:Sprite;
      
      private var _labelObj:TextField;
      
      private var _percentObj:TextField;
      
      private var _startTime:int;
      
      private var _displayTime:int;
      
      private var _startedLoading:Boolean = false;
      
      private var _startedInit:Boolean = false;
      
      private var _showingDisplay:Boolean = false;
      
      private var _displayStartCount:uint = 0;
      
      private var _initProgressCount:uint = 0;
      
      protected var initProgressTotal:uint = 6;
      
      private var _visible:Boolean = false;
      
      private var _backgroundAlpha:Number = 1;
      
      private var _backgroundColor:uint;
      
      private var _backgroundImage:Object;
      
      private var _backgroundSize:String = "";
      
      private var _preloader:Sprite;
      
      private var _stageHeight:Number = 375;
      
      private var _stageWidth:Number = 500;
      
      private var _downloadingLabel:String = "Loading";
      
      private var _label:String = "";
      
      private var _showLabel:Boolean = true;
      
      private var _showPercentage:Boolean = false;
      
      public function DownloadProgressBar()
      {
         this._labelRect = this.labelRect;
         this._percentRect = this.percentRect;
         this._borderRect = this.borderRect;
         this._barFrameRect = this.barFrameRect;
         this._barRect = this.barRect;
         super();
      }
      
      public static function get initializingLabel() : String
      {
         return _initializingLabel;
      }
      
      public static function set initializingLabel(value:String) : void
      {
         _initializingLabel = value;
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(!this._visible && value)
         {
            this.show();
         }
         else if(this._visible && !value)
         {
            this.hide();
         }
         this._visible = value;
      }
      
      public function get backgroundAlpha() : Number
      {
         if(!isNaN(this._backgroundAlpha))
         {
            return this._backgroundAlpha;
         }
         return 1;
      }
      
      public function set backgroundAlpha(value:Number) : void
      {
         this._backgroundAlpha = value;
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(value:uint) : void
      {
         this._backgroundColor = value;
      }
      
      public function get backgroundImage() : Object
      {
         return this._backgroundImage;
      }
      
      public function set backgroundImage(value:Object) : void
      {
         this._backgroundImage = value;
      }
      
      public function get backgroundSize() : String
      {
         return this._backgroundSize;
      }
      
      public function set backgroundSize(value:String) : void
      {
         this._backgroundSize = value;
      }
      
      public function set preloader(value:Sprite) : void
      {
         this._preloader = value;
         value.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         value.addEventListener(Event.COMPLETE,this.completeHandler);
         value.addEventListener(RSLEvent.RSL_PROGRESS,this.rslProgressHandler);
         value.addEventListener(RSLEvent.RSL_COMPLETE,this.rslCompleteHandler);
         value.addEventListener(RSLEvent.RSL_ERROR,this.rslErrorHandler);
         value.addEventListener(FlexEvent.INIT_PROGRESS,this.initProgressHandler);
         value.addEventListener(FlexEvent.INIT_COMPLETE,this.initCompleteHandler);
      }
      
      public function get stageHeight() : Number
      {
         return this._stageHeight;
      }
      
      public function set stageHeight(value:Number) : void
      {
         this._stageHeight = value;
      }
      
      public function get stageWidth() : Number
      {
         return this._stageWidth;
      }
      
      public function set stageWidth(value:Number) : void
      {
         this._stageWidth = value;
      }
      
      protected function get barFrameRect() : RoundedRectangle
      {
         return new RoundedRectangle(14,40,154,4);
      }
      
      protected function get barRect() : RoundedRectangle
      {
         return new RoundedRectangle(14,39,154,6,0);
      }
      
      protected function get borderRect() : RoundedRectangle
      {
         return new RoundedRectangle(0,0,182,60,4);
      }
      
      protected function get downloadingLabel() : String
      {
         return this._downloadingLabel;
      }
      
      protected function set downloadingLabel(value:String) : void
      {
         this._downloadingLabel = value;
      }
      
      protected function get label() : String
      {
         return this._label;
      }
      
      protected function set label(value:String) : void
      {
         if(!(value is Function))
         {
            this._label = value;
         }
         this.draw();
      }
      
      protected function get labelFormat() : TextFormat
      {
         var tf:TextFormat = new TextFormat();
         tf.color = 3355443;
         tf.font = "Verdana";
         tf.size = 10;
         return tf;
      }
      
      protected function get labelRect() : Rectangle
      {
         return new Rectangle(14,17,100,16);
      }
      
      protected function get percentFormat() : TextFormat
      {
         var tf:TextFormat = new TextFormat();
         tf.align = "right";
         tf.color = 0;
         tf.font = "Verdana";
         tf.size = 10;
         return tf;
      }
      
      protected function get percentRect() : Rectangle
      {
         return new Rectangle(108,4,34,16);
      }
      
      protected function get showLabel() : Boolean
      {
         return this._showLabel;
      }
      
      protected function set showLabel(value:Boolean) : void
      {
         this._showLabel = value;
         this.draw();
      }
      
      protected function get showPercentage() : Boolean
      {
         return this._showPercentage;
      }
      
      protected function set showPercentage(value:Boolean) : void
      {
         this._showPercentage = value;
         this.draw();
      }
      
      public function initialize() : void
      {
         this._startTime = getTimer();
         this.center(this.stageWidth,this.stageHeight);
      }
      
      protected function center(width:Number, height:Number) : void
      {
         this._xOffset = Math.floor((width - this._borderRect.width) / 2);
         this._yOffset = Math.floor((height - this._borderRect.height) / 2);
      }
      
      private function draw() : void
      {
         var percentage:Number = NaN;
         if(this._startedLoading)
         {
            if(!this._startedInit)
            {
               percentage = Math.round(this.getPercentLoaded(this._value,this._maximum) * this.DOWNLOAD_PERCENTAGE / 100);
            }
            else
            {
               percentage = Math.round(this.getPercentLoaded(this._value,this._maximum) * (100 - this.DOWNLOAD_PERCENTAGE) / 100 + this.DOWNLOAD_PERCENTAGE);
            }
         }
         else
         {
            percentage = this.getPercentLoaded(this._value,this._maximum);
         }
         if(Boolean(this._labelObj))
         {
            this._labelObj.text = this._label;
         }
         if(Boolean(this._percentObj))
         {
            if(!this._showPercentage)
            {
               this._percentObj.visible = false;
               this._percentObj.text = "";
            }
            else
            {
               this._percentObj.text = String(percentage) + "%";
            }
         }
         if(Boolean(this._barSprite) && Boolean(this._barFrameSprite))
         {
            if(!this._showProgressBar)
            {
               this._barSprite.visible = false;
               this._barFrameSprite.visible = false;
            }
            else
            {
               this.drawProgressBar(percentage);
            }
         }
      }
      
      protected function createChildren() : void
      {
         var labelObj:TextField = null;
         var percentObj:TextField = null;
         var g:Graphics = graphics;
         if(this.backgroundColor != 4294967295)
         {
            g.beginFill(this.backgroundColor,this.backgroundAlpha);
            g.drawRect(0,0,this.stageWidth,this.stageHeight);
         }
         if(this.backgroundImage != null)
         {
            this.loadBackgroundImage(this.backgroundImage);
         }
         this._barFrameSprite = new Sprite();
         this._barSprite = new Sprite();
         addChild(this._barFrameSprite);
         addChild(this._barSprite);
         g.beginFill(13421772,0.4);
         g.drawRoundRect(this.calcX(this._borderRect.x),this.calcY(this._borderRect.y),this._borderRect.width,this._borderRect.height,this._borderRect.cornerRadius * 2,this._borderRect.cornerRadius * 2);
         g.drawRoundRect(this.calcX(this._borderRect.x + 1),this.calcY(this._borderRect.y + 1),this._borderRect.width - 2,this._borderRect.height - 2,this._borderRect.cornerRadius - 1 * 2,this._borderRect.cornerRadius - 1 * 2);
         g.endFill();
         g.beginFill(13421772,0.4);
         g.drawRoundRect(this.calcX(this._borderRect.x + 1),this.calcY(this._borderRect.y + 1),this._borderRect.width - 2,this._borderRect.height - 2,this._borderRect.cornerRadius - 1 * 2,this._borderRect.cornerRadius - 1 * 2);
         g.endFill();
         var frame_g:Graphics = this._barFrameSprite.graphics;
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(this._barFrameRect.width,this._barFrameRect.height,Math.PI / 2,this.calcX(this._barFrameRect.x),this.calcY(this._barFrameRect.y));
         frame_g.beginGradientFill(GradientType.LINEAR,[6054502,11909306],[1,1],[0,255],matrix);
         frame_g.drawRoundRect(this.calcX(this._barFrameRect.x),this.calcY(this._barFrameRect.y),this._barFrameRect.width,this._barFrameRect.height,this._barFrameRect.cornerRadius * 2,this._barFrameRect.cornerRadius * 2);
         frame_g.drawRoundRect(this.calcX(this._barFrameRect.x + 1),this.calcY(this._barFrameRect.y + 1),this._barFrameRect.width - 2,this._barFrameRect.height - 2,this._barFrameRect.cornerRadius * 2,this._barFrameRect.cornerRadius * 2);
         frame_g.endFill();
         this._labelObj = new TextField();
         this._labelObj.x = this.calcX(this._labelRect.x);
         this._labelObj.y = this.calcY(this._labelRect.y);
         this._labelObj.width = this._labelRect.width;
         this._labelObj.height = this._labelRect.height;
         this._labelObj.selectable = false;
         this._labelObj.defaultTextFormat = this.labelFormat;
         addChild(this._labelObj);
         this._percentObj = new TextField();
         this._percentObj.x = this.calcX(this._percentRect.x);
         this._percentObj.y = this.calcY(this._percentRect.y);
         this._percentObj.width = this._percentRect.width;
         this._percentObj.height = this._percentRect.height;
         this._percentObj.selectable = false;
         this._percentObj.defaultTextFormat = this.percentFormat;
         addChild(this._percentObj);
         var ds:RectangularDropShadow = new RectangularDropShadow();
         ds.color = 0;
         ds.angle = 90;
         ds.alpha = 0.6;
         ds.distance = 2;
         ds.tlRadius = ds.trRadius = ds.blRadius = ds.brRadius = this._borderRect.cornerRadius;
         ds.drawShadow(g,this.calcX(this._borderRect.x),this.calcY(this._borderRect.y),this._borderRect.width,this._borderRect.height);
         g.lineStyle(1,16777215,0.3);
         g.moveTo(this.calcX(this._borderRect.x) + this._borderRect.cornerRadius,this.calcY(this._borderRect.y));
         g.lineTo(this.calcX(this._borderRect.x) - this._borderRect.cornerRadius + this._borderRect.width,this.calcY(this._borderRect.y));
      }
      
      private function drawProgressBar(percentage:Number) : void
      {
         var barY2:Number = NaN;
         var g:Graphics = this._barSprite.graphics;
         g.clear();
         var colors:Array = [16777215,16777215];
         var ratios:Array = [0,255];
         var matrix:Matrix = new Matrix();
         var barWidth:Number = this._barRect.width * percentage / 100;
         var barWidthSplit:Number = barWidth / 2;
         var barHeight:Number = this._barRect.height - 4;
         var barX:Number = this.calcX(this._barRect.x);
         var barY:Number = this.calcY(this._barRect.y) + 2;
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.39,0.85],ratios,matrix);
         g.drawRect(barX,barY,barWidthSplit,barHeight);
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX + barWidthSplit,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.85,1],ratios,matrix);
         g.drawRect(barX + barWidthSplit,barY,barWidthSplit,barHeight);
         barWidthSplit = barWidth / 3;
         barHeight = this._barRect.height;
         barY = this.calcY(this._barRect.y);
         barY2 = barY + barHeight - 1;
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.05,0.15],ratios,matrix);
         g.drawRect(barX,barY,barWidthSplit,1);
         g.drawRect(barX,barY2,barWidthSplit,1);
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX + barWidthSplit,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.15,0.25],ratios,matrix);
         g.drawRect(barX + barWidthSplit,barY,barWidthSplit,1);
         g.drawRect(barX + barWidthSplit,barY2,barWidthSplit,1);
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX + barWidthSplit * 2,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.25,0.1],ratios,matrix);
         g.drawRect(barX + barWidthSplit * 2,barY,barWidthSplit,1);
         g.drawRect(barX + barWidthSplit * 2,barY2,barWidthSplit,1);
         barWidthSplit = barWidth / 3;
         barHeight = this._barRect.height;
         barY = this.calcY(this._barRect.y) + 1;
         barY2 = this.calcY(this._barRect.y) + barHeight - 2;
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.15,0.3],ratios,matrix);
         g.drawRect(barX,barY,barWidthSplit,1);
         g.drawRect(barX,barY2,barWidthSplit,1);
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX + barWidthSplit,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.3,0.4],ratios,matrix);
         g.drawRect(barX + barWidthSplit,barY,barWidthSplit,1);
         g.drawRect(barX + barWidthSplit,barY2,barWidthSplit,1);
         matrix.createGradientBox(barWidthSplit,barHeight,0,barX + barWidthSplit * 2,barY);
         g.beginGradientFill(GradientType.LINEAR,colors,[0.4,0.25],ratios,matrix);
         g.drawRect(barX + barWidthSplit * 2,barY,barWidthSplit,1);
         g.drawRect(barX + barWidthSplit * 2,barY2,barWidthSplit,1);
      }
      
      protected function setProgress(completed:Number, total:Number) : void
      {
         if(!isNaN(completed) && !isNaN(total) && completed >= 0 && total > 0)
         {
            this._value = Number(completed);
            this._maximum = Number(total);
            this.draw();
         }
      }
      
      protected function getPercentLoaded(loaded:Number, total:Number) : Number
      {
         var perc:Number = NaN;
         if(loaded == 0 || total == 0 || isNaN(total) || isNaN(loaded))
         {
            return 0;
         }
         perc = 100 * loaded / total;
         if(isNaN(perc) || perc <= 0)
         {
            return 0;
         }
         if(perc > 99)
         {
            return 99;
         }
         return Math.round(perc);
      }
      
      private function show() : void
      {
         this._showingDisplay = true;
         this.calcScale();
         this.draw();
         this._displayTime = getTimer();
      }
      
      private function hide() : void
      {
      }
      
      private function calcX(base:Number) : Number
      {
         return base + this._xOffset;
      }
      
      private function calcY(base:Number) : Number
      {
         return base + this._yOffset;
      }
      
      private function calcScale() : void
      {
         var scale:Number = NaN;
         if(this.stageWidth < 160 || this.stageHeight < 120)
         {
            scaleX = 1;
            scaleY = 1;
         }
         else if(this.stageWidth < 240 || this.stageHeight < 150)
         {
            this.createChildren();
            scale = Math.min(this.stageWidth / 240,this.stageHeight / 150);
            scaleX = scale;
            scaleY = scale;
         }
         else
         {
            this.createChildren();
         }
      }
      
      protected function showDisplayForDownloading(elapsedTime:int, event:ProgressEvent) : Boolean
      {
         return elapsedTime > 700 && event.bytesLoaded < event.bytesTotal / 2;
      }
      
      protected function showDisplayForInit(elapsedTime:int, count:int) : Boolean
      {
         return elapsedTime > 300 && count == 2;
      }
      
      private function loadBackgroundImage(classOrString:Object) : void
      {
         var cls:Class = null;
         var newStyleObj:DisplayObject = null;
         var loader:Loader = null;
         var loaderContext:LoaderContext = null;
         if(Boolean(classOrString) && Boolean(classOrString as Class))
         {
            cls = Class(classOrString);
            this.initBackgroundImage(new cls());
         }
         else if(Boolean(classOrString) && classOrString is String)
         {
            try
            {
               cls = Class(getDefinitionByName(String(classOrString)));
            }
            catch(e:Error)
            {
            }
            if(Boolean(cls))
            {
               newStyleObj = new cls();
               this.initBackgroundImage(newStyleObj);
            }
            else
            {
               loader = new Loader();
               loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loader_completeHandler);
               loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loader_ioErrorHandler);
               loaderContext = new LoaderContext();
               loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
               loader.load(new URLRequest(String(classOrString)),loaderContext);
            }
         }
      }
      
      private function initBackgroundImage(image:DisplayObject) : void
      {
         var sX:Number = NaN;
         var sY:Number = NaN;
         var scale:Number = NaN;
         addChildAt(image,0);
         var backgroundImageWidth:Number = image.width;
         var backgroundImageHeight:Number = image.height;
         var percentage:Number = this.calcBackgroundSize();
         if(isNaN(percentage))
         {
            sX = 1;
            sY = 1;
         }
         else
         {
            scale = percentage * 0.01;
            sX = scale * this.stageWidth / backgroundImageWidth;
            sY = scale * this.stageHeight / backgroundImageHeight;
         }
         image.scaleX = sX;
         image.scaleY = sY;
         var offsetX:Number = Math.round(0.5 * (this.stageWidth - backgroundImageWidth * sX));
         var offsetY:Number = Math.round(0.5 * (this.stageHeight - backgroundImageHeight * sY));
         image.x = offsetX;
         image.y = offsetY;
         if(!isNaN(this.backgroundAlpha))
         {
            image.alpha = this.backgroundAlpha;
         }
      }
      
      private function calcBackgroundSize() : Number
      {
         var index:int = 0;
         var percentage:Number = NaN;
         if(Boolean(this.backgroundSize))
         {
            index = this.backgroundSize.indexOf("%");
            if(index != -1)
            {
               percentage = Number(this.backgroundSize.substr(0,index));
            }
         }
         return percentage;
      }
      
      protected function progressHandler(event:ProgressEvent) : void
      {
         var loaded:uint = event.bytesLoaded;
         var total:uint = event.bytesTotal;
         var elapsedTime:int = getTimer() - this._startTime;
         if(this._showingDisplay || this.showDisplayForDownloading(elapsedTime,event))
         {
            if(!this._startedLoading)
            {
               this.show();
               this.label = this.downloadingLabel;
               this._startedLoading = true;
            }
            this.setProgress(event.bytesLoaded,event.bytesTotal);
         }
      }
      
      protected function completeHandler(event:Event) : void
      {
      }
      
      protected function rslProgressHandler(event:RSLEvent) : void
      {
      }
      
      protected function rslCompleteHandler(event:RSLEvent) : void
      {
         var word:String = "library";
         if(event.isResourceModule)
         {
            word = "module";
         }
         this.label = "Loaded " + word + " " + event.rslIndex + " of " + event.rslTotal;
      }
      
      protected function rslErrorHandler(event:RSLEvent) : void
      {
         this._preloader.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this._preloader.removeEventListener(Event.COMPLETE,this.completeHandler);
         this._preloader.removeEventListener(RSLEvent.RSL_PROGRESS,this.rslProgressHandler);
         this._preloader.removeEventListener(RSLEvent.RSL_COMPLETE,this.rslCompleteHandler);
         this._preloader.removeEventListener(RSLEvent.RSL_ERROR,this.rslErrorHandler);
         this._preloader.removeEventListener(FlexEvent.INIT_PROGRESS,this.initProgressHandler);
         this._preloader.removeEventListener(FlexEvent.INIT_COMPLETE,this.initCompleteHandler);
         if(!this._showingDisplay)
         {
            this.show();
            this._showingDisplay = true;
         }
         this.label = "RSL Error " + (event.rslIndex + 1) + " of " + event.rslTotal;
         var errorField:ErrorField = new ErrorField(this);
         errorField.show(event.errorText);
      }
      
      private function timerHandler(event:Event = null) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function initProgressHandler(event:Event) : void
      {
         var loaded:Number = NaN;
         var elapsedTime:int = getTimer() - this._startTime;
         ++this._initProgressCount;
         if(!this._showingDisplay && this.showDisplayForInit(elapsedTime,this._initProgressCount))
         {
            this._displayStartCount = this._initProgressCount;
            this.show();
         }
         if(this._showingDisplay)
         {
            if(!this._startedInit)
            {
               this._startedInit = true;
               this.label = initializingLabel;
            }
            loaded = 100 * this._initProgressCount / (this.initProgressTotal - this._displayStartCount);
            this.setProgress(Math.min(loaded,100),100);
         }
      }
      
      protected function initCompleteHandler(event:Event) : void
      {
         var timer:Timer = null;
         var elapsedTime:int = getTimer() - this._displayTime;
         if(this._showingDisplay && elapsedTime < this.MINIMUM_DISPLAY_TIME)
         {
            timer = new Timer(this.MINIMUM_DISPLAY_TIME - elapsedTime,1);
            timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
            timer.start();
         }
         else
         {
            this.timerHandler();
         }
      }
      
      private function loader_completeHandler(event:Event) : void
      {
         var target:DisplayObject = DisplayObject(LoaderInfo(event.target).loader);
         this.initBackgroundImage(target);
      }
      
      private function loader_ioErrorHandler(event:IOErrorEvent) : void
      {
      }
   }
}

import flash.display.Sprite;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import mx.preloaders.DownloadProgressBar;

class ErrorField extends Sprite
{
   
   private var downloadProgressBar:DownloadProgressBar;
   
   private const MIN_WIDTH_INCHES:int = 2;
   
   private const MAX_WIDTH_INCHES:int = 6;
   
   private const TEXT_MARGIN_PX:int = 10;
   
   public function ErrorField(downloadProgressBar:DownloadProgressBar)
   {
      super();
      this.downloadProgressBar = downloadProgressBar;
   }
   
   protected function get labelFormat() : TextFormat
   {
      var tf:TextFormat = new TextFormat();
      tf.color = 0;
      tf.font = "Verdana";
      tf.size = 10;
      return tf;
   }
   
   public function show(errorText:String) : void
   {
      if(errorText == null || errorText.length == 0)
      {
         return;
      }
      var screenWidth:Number = Number(this.downloadProgressBar.stageWidth);
      var screenHeight:Number = Number(this.downloadProgressBar.stageHeight);
      var textField:TextField = new TextField();
      textField.autoSize = TextFieldAutoSize.LEFT;
      textField.multiline = true;
      textField.wordWrap = true;
      textField.background = true;
      textField.defaultTextFormat = this.labelFormat;
      textField.text = errorText;
      textField.width = Math.max(this.MIN_WIDTH_INCHES * Capabilities.screenDPI,screenWidth - this.TEXT_MARGIN_PX * 2);
      textField.width = Math.min(this.MAX_WIDTH_INCHES * Capabilities.screenDPI,textField.width);
      textField.y = Math.max(0,screenHeight - this.TEXT_MARGIN_PX - textField.height);
      textField.x = (screenWidth - textField.width) / 2;
      this.downloadProgressBar.parent.addChild(this);
      this.addChild(textField);
   }
}
