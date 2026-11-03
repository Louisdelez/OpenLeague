package mx.preloaders
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.RSLEvent;
   import mx.graphics.RectangularDropShadow;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   public class SparkDownloadProgressBar extends Sprite implements IPreloaderDisplay
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const DEFAULT_COLOR:uint = 13421772;
      
      private static const DEFAULT_COLOR_VALUE:uint = 204;
      
      private var _barWidth:Number;
      
      private var _bgSprite:Sprite;
      
      private var _barSprite:Sprite;
      
      private var _barFrameSprite:Sprite;
      
      private var _startTime:int;
      
      private var _showingDisplay:Boolean = false;
      
      private var _downloadComplete:Boolean = false;
      
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
      
      private var lastBarWidth:Number = 0;
      
      public function SparkDownloadProgressBar()
      {
         super();
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
      
      public function initialize() : void
      {
         this._startTime = getTimer();
      }
      
      protected function createChildren() : void
      {
         var colorTransform:ColorTransform = null;
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
         var totalWidth:Number = Math.min(this.stageWidth - 10,207);
         var totalHeight:Number = 19;
         var startX:Number = Math.round((this.stageWidth - totalWidth) / 2);
         var startY:Number = Math.round((this.stageHeight - totalHeight) / 2);
         this._barWidth = totalWidth - 10;
         this._bgSprite = new Sprite();
         this._barFrameSprite = new Sprite();
         this._barSprite = new Sprite();
         addChild(this._bgSprite);
         addChild(this._barFrameSprite);
         addChild(this._barSprite);
         this._barFrameSprite.x = this._barSprite.x = startX + 5;
         this._barFrameSprite.y = this._barSprite.y = startY + 5;
         g = this._bgSprite.graphics;
         g.lineStyle(1,6513507);
         g.beginFill(15263976);
         g.drawRect(startX,startY,totalWidth,totalHeight);
         g.endFill();
         g.lineStyle();
         g = graphics;
         var ds:RectangularDropShadow = new RectangularDropShadow();
         ds.color = 0;
         ds.angle = 90;
         ds.alpha = 0.6;
         ds.distance = 2;
         ds.drawShadow(g,startX,startY,totalWidth,totalHeight);
         var chromeColor:uint = this.getPreloaderChromeColor();
         if(chromeColor != DEFAULT_COLOR)
         {
            colorTransform = new ColorTransform();
            colorTransform.redOffset = ((chromeColor & 255 << 16) >> 16) - DEFAULT_COLOR_VALUE;
            colorTransform.greenOffset = ((chromeColor & 255 << 8) >> 8) - DEFAULT_COLOR_VALUE;
            colorTransform.blueOffset = (chromeColor & 0xFF) - DEFAULT_COLOR_VALUE;
            this._bgSprite.transform.colorTransform = colorTransform;
            this._barFrameSprite.transform.colorTransform = colorTransform;
            this._barSprite.transform.colorTransform = colorTransform;
         }
      }
      
      private function getPreloaderChromeColor() : uint
      {
         var sm:ISystemManager = null;
         sm = parent.parent as ISystemManager;
         var valueObject:Object = Boolean(sm) ? sm.info()["preloaderChromeColor"] : null;
         var valueString:String = valueObject as String;
         if(Boolean(valueString) && valueString.charAt(0) == "#")
         {
            valueString = "0x" + valueString.substring(1);
         }
         return Boolean(valueString) ? uint(valueString) : DEFAULT_COLOR;
      }
      
      protected function setDownloadProgress(completed:Number, total:Number) : void
      {
         if(!this._barFrameSprite)
         {
            return;
         }
         var outerHighlightColors:Array = [16777215,16777215];
         var outerHighlightAlphas:Array = [0.12,0.8];
         var fillColors:Array = [11119017,12434877];
         var fillAlphas:Array = [1,1];
         var ratios:Array = [0,255];
         var w:Number = Math.round(this._barWidth * Math.min(completed / total,1));
         var h:Number = 9;
         var g:Graphics = this._barFrameSprite.graphics;
         var m:Matrix = new Matrix();
         w = Math.max(w,this.lastBarWidth);
         this.lastBarWidth = w;
         m.createGradientBox(w,h,90);
         g.clear();
         g.lineStyle(1);
         g.lineGradientStyle("linear",outerHighlightColors,outerHighlightAlphas,ratios,m);
         g.drawRect(0,0,w,h);
         g.lineStyle(1,6513507);
         g.beginGradientFill("linear",fillColors,fillAlphas,ratios,m);
         g.drawRect(1,1,w - 2,h - 2);
         g.endFill();
         g.lineStyle(1,0,0.12);
         g.moveTo(2,h - 1);
         g.lineTo(2,2);
         g.lineTo(w - 2,2);
         g.lineTo(w - 2,h - 1);
         if(completed == total)
         {
            this._downloadComplete = true;
         }
      }
      
      protected function setInitProgress(completed:Number, total:Number) : void
      {
         var highlightColors:Array = [16777215,15395562];
         var fillColors:Array = [16777215,14211288];
         var alphas:Array = [1,1];
         var ratios:Array = [0,255];
         var w:Number = Math.round(this._barWidth * Math.min(completed / total,1));
         var h:Number = 9;
         var g:Graphics = this._barSprite.graphics;
         var m:Matrix = new Matrix();
         m.createGradientBox(w - 6,h - 2,90,2,2);
         g.clear();
         g.lineStyle(1);
         g.lineGradientStyle("linear",highlightColors,alphas,ratios,m);
         g.beginGradientFill("linear",fillColors,alphas,ratios,m);
         g.drawRect(2,2,w - 4,h - 4);
         g.endFill();
         g.lineStyle(1,0,0.55);
         g.moveTo(w - 1,2);
         g.lineTo(w - 1,h - 1);
      }
      
      private function show() : void
      {
         if(this.stageWidth == 0 && this.stageHeight == 0)
         {
            try
            {
               this.stageWidth = stage.stageWidth;
               this.stageHeight = stage.stageHeight;
            }
            catch(e:Error)
            {
               stageWidth = loaderInfo.width;
               stageHeight = loaderInfo.height;
            }
            if(this.stageWidth == 0 && this.stageHeight == 0)
            {
               return;
            }
         }
         this._showingDisplay = true;
         this.createChildren();
      }
      
      private function hide() : void
      {
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
         if(!this._showingDisplay && this.showDisplayForDownloading(elapsedTime,event))
         {
            this.show();
         }
         if(this._showingDisplay)
         {
            this.setDownloadProgress(event.bytesLoaded,event.bytesTotal);
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
            this.setDownloadProgress(100,100);
         }
         var errorField:ErrorField = new ErrorField(this);
         errorField.show(event.errorText);
      }
      
      protected function initProgressHandler(event:Event) : void
      {
         if(this._initProgressCount == 0)
         {
            this._startTime = getTimer();
         }
         var elapsedTime:int = getTimer() - this._startTime;
         ++this._initProgressCount;
         if(!this._showingDisplay && this.showDisplayForInit(elapsedTime,this._initProgressCount))
         {
            this._displayStartCount = this._initProgressCount;
            this.show();
            this.setDownloadProgress(100,100);
         }
         if(this._showingDisplay)
         {
            if(!this._downloadComplete)
            {
               this.setDownloadProgress(100,100);
            }
            this.setInitProgress(this._initProgressCount,this.initProgressTotal);
         }
      }
      
      protected function initCompleteHandler(event:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
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
import mx.preloaders.SparkDownloadProgressBar;

class ErrorField extends Sprite
{
   
   private var downloadProgressBar:SparkDownloadProgressBar;
   
   private const MIN_WIDTH_INCHES:int = 2;
   
   private const MAX_WIDTH_INCHES:int = 6;
   
   private const TEXT_MARGIN_PX:int = 10;
   
   public function ErrorField(downloadProgressBar:SparkDownloadProgressBar)
   {
      super();
      this.downloadProgressBar = downloadProgressBar;
   }
   
   protected function get labelFormat() : TextFormat
   {
      var tf:TextFormat = new TextFormat();
      tf.color = 0;
      tf.font = "Arial";
      tf.size = 12;
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
