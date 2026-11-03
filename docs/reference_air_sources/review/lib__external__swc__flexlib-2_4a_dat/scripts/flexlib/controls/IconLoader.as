package flexlib.controls
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flexlib.controls.iconLoaderClasses.IIconParser;
   import flexlib.controls.iconLoaderClasses.IconParserFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.skins.halo.BrokenImageBorderSkin;
   import mx.styles.ISimpleStyleClient;
   
   [Style(name="brokenImageSkin",type="Class",inherit="no")]
   [Style(name="brokenImageBorderSkin",type="Class",inherit="no")]
   public class IconLoader extends UIComponent
   {
      
      [Embed(source="iconLoaderClasses/assets/Assets.swf",symbol="__brokenImage")]
      private static var _brokenImageSkin:Class = IconLoader__brokenImageSkin;
      
      private var _brokenImage:Boolean = false;
      
      private var _source:Object;
      
      private var _parser:IIconParser;
      
      private var _scaleContent:Boolean = false;
      
      public function IconLoader()
      {
         super();
      }
      
      [Bindable("sourceChange")]
      public function get source() : Object
      {
         return _source;
      }
      
      public function set source(val:Object) : void
      {
         var inst:Object = null;
         if(_source != val)
         {
            _source = val;
            if(_source is Class)
            {
               inst = new _source();
               if(inst is ByteArray)
               {
                  parseIcon(inst as ByteArray);
                  invalidateSize();
                  invalidateDisplayList();
               }
            }
            else if(_source is String)
            {
               loadImageUrl(_source as String);
            }
            dispatchEvent(new Event("sourceChange"));
         }
      }
      
      private function onLoaderSecurityError(e:SecurityErrorEvent) : void
      {
         trace("Security error loading icon: " + e.text);
         _parser = null;
         _brokenImage = true;
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function loadImageUrl(url:String) : void
      {
         var req:URLRequest = null;
         var loader:URLLoader = null;
         req = new URLRequest(url);
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(Event.COMPLETE,onLoaderComplete);
         loader.addEventListener(IOErrorEvent.IO_ERROR,onLoaderIOError);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoaderSecurityError);
         loader.load(req);
      }
      
      override protected function measure() : void
      {
         var s:int = 0;
         super.measure();
         if(_parser != null && _parser.validIcon && _parser.sizes.length > 0)
         {
            s = int(_parser.sizes[0]);
            measuredHeight = s;
            measuredWidth = s;
         }
      }
      
      private function onLoaderIOError(e:IOErrorEvent) : void
      {
         trace("IO error loading icon: " + e.text);
         _parser = null;
         _brokenImage = true;
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function parseIcon(ba:ByteArray) : void
      {
         _parser = IconParserFactory.newParser(ba);
         if(_parser != null)
         {
            _parser.data = ba;
            _parser.parse();
         }
         if(_parser == null || !_parser.validIcon || _parser.sizes.length == 0)
         {
            _brokenImage = true;
         }
         else
         {
            _brokenImage = false;
         }
      }
      
      private function onLoaderComplete(e:Event) : void
      {
         parseIcon(e.target.data as ByteArray);
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         mask = new Sprite();
         addChild(mask);
      }
      
      public function set scaleContent(val:Boolean) : void
      {
         if(_scaleContent != val)
         {
            _scaleContent = val;
            invalidateDisplayList();
            dispatchEvent(new Event("scaleContentSchange"));
         }
      }
      
      [Bindable("scaleContentSchange")]
      public function get scaleContent() : Boolean
      {
         return _scaleContent;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var g:Graphics = null;
         var child:DisplayObject = null;
         var brokenImageSkin:Class = null;
         var brokenImageBorderSkin:Class = null;
         var brokenImage:IFlexDisplayObject = null;
         var border:IFlexDisplayObject = null;
         var s:int = 0;
         var bmd:BitmapData = null;
         var bm:Bitmap = null;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var sizes:Array = null;
         var targetS:int = 0;
         var newS:int = 0;
         var scaleRatio:Number = NaN;
         super.updateDisplayList(w,h);
         g = (mask as Sprite).graphics;
         g.clear();
         g.beginFill(0,0);
         g.drawRect(0,0,w + 1,h + 1);
         g.endFill();
         child = getChildByName("iconImage");
         if(child != null)
         {
            removeChild(child);
         }
         child = getChildByName("brokenImageBorder");
         if(child != null)
         {
            removeChild(child);
         }
         if(_brokenImage)
         {
            brokenImageSkin = getStyle("brokenImageSkin");
            brokenImageBorderSkin = getStyle("brokenImageBorderSkin");
            if(brokenImageSkin == null)
            {
               brokenImageSkin = _brokenImageSkin;
            }
            if(brokenImageBorderSkin == null)
            {
               brokenImageBorderSkin = BrokenImageBorderSkin;
            }
            brokenImage = new brokenImageSkin() as IFlexDisplayObject;
            if(brokenImage is ISimpleStyleClient)
            {
               (brokenImage as ISimpleStyleClient).styleName = this;
            }
            brokenImage.name = "iconImage";
            addChild(brokenImage as DisplayObject);
            border = new brokenImageBorderSkin() as IFlexDisplayObject;
            if(border is ISimpleStyleClient)
            {
               (border as ISimpleStyleClient).styleName = this;
            }
            border.setActualSize(w,h);
            border.name = "brokenImageBorder";
            addChild(border as DisplayObject);
         }
         else if(_parser != null)
         {
            s = Math.min(w,h);
            if(scaleContent)
            {
               sizes = _parser.sizes;
               targetS = s;
               for each(newS in sizes)
               {
                  if(newS < targetS)
                  {
                     break;
                  }
                  s = newS;
               }
            }
            bmd = _parser.getIconForSize(s);
            bm = new Bitmap(bmd);
            bm.smoothing = true;
            bm.name = "iconImage";
            xPos = 0;
            yPos = 0;
            if(scaleContent)
            {
               scaleRatio = Math.min(w / bm.width,h / bm.height);
               bm.scaleX = scaleRatio;
               bm.scaleY = scaleRatio;
            }
            else
            {
               yPos = Math.max(0,(h - bm.height) / 2);
               xPos = Math.max(0,(w - bm.width) / 2);
            }
            bm.x = xPos;
            bm.y = yPos;
            addChild(bm);
         }
      }
   }
}

