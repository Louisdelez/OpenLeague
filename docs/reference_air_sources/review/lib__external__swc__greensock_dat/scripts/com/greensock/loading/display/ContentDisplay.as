package com.greensock.loading.display
{
   import com.greensock.loading.core.LoaderItem;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.media.Video;
   
   public class ContentDisplay extends Sprite
   {
      
      protected static var _transformProps:Object = {
         "x":1,
         "y":1,
         "z":1,
         "rotationX":1,
         "rotationY":1,
         "rotationZ":1,
         "scaleX":1,
         "scaleY":1,
         "rotation":1,
         "alpha":1,
         "visible":true,
         "blendMode":"normal",
         "centerRegistration":false,
         "crop":false,
         "scaleMode":"stretch",
         "hAlign":"center",
         "vAlign":"center"
      };
      
      protected var _scaleMode:String = "stretch";
      
      protected var _fitWidth:Number;
      
      protected var _hAlign:String = "center";
      
      protected var _fitHeight:Number;
      
      public var data:*;
      
      protected var _nativeRect:Rectangle;
      
      protected var _loader:LoaderItem;
      
      protected var _centerRegistration:Boolean;
      
      protected var _vAlign:String = "center";
      
      protected var _rawContent:DisplayObject;
      
      protected var _cropContainer:Sprite;
      
      public var gcProtect:*;
      
      protected var _bgAlpha:Number = 0;
      
      protected var _bgColor:uint;
      
      protected var _crop:Boolean;
      
      public function ContentDisplay(loader:LoaderItem)
      {
         super();
         this.loader = loader;
      }
      
      public function get scaleMode() : String
      {
         return _scaleMode;
      }
      
      public function get crop() : Boolean
      {
         return _crop;
      }
      
      public function get loader() : LoaderItem
      {
         return _loader;
      }
      
      public function get fitHeight() : Number
      {
         return _fitHeight;
      }
      
      public function get bgAlpha() : Number
      {
         return _bgAlpha;
      }
      
      public function get bgColor() : uint
      {
         return _bgColor;
      }
      
      public function dispose(unloadLoader:Boolean = true, disposeLoader:Boolean = true) : void
      {
         this.rawContent = null;
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
         this.gcProtect = null;
         if(_loader != null)
         {
            if(unloadLoader)
            {
               _loader.unload();
            }
            if(disposeLoader)
            {
               _loader.dispose(false);
               _loader = null;
            }
         }
      }
      
      public function set scaleMode(value:String) : void
      {
         if(_rawContent != null)
         {
            _rawContent.scaleX = _rawContent.scaleY = 1;
         }
         _scaleMode = value;
         _update();
      }
      
      public function set loader(value:LoaderItem) : void
      {
         var type:String = null;
         var p:String = null;
         _loader = value;
         if(_loader == null)
         {
            return;
         }
         if(!_loader.hasOwnProperty("setContentDisplay"))
         {
            throw new Error("Incompatible loader used for a ContentDisplay");
         }
         this.name = _loader.name;
         for(p in _transformProps)
         {
            if(p in _loader.vars)
            {
               type = typeof _transformProps[p];
               this[p] = type == "number" ? Number(_loader.vars[p]) : (type == "string" ? String(_loader.vars[p]) : Boolean(_loader.vars[p]));
            }
         }
         _bgColor = uint(_loader.vars.bgColor);
         _bgAlpha = "bgAlpha" in _loader.vars ? Number(_loader.vars.bgAlpha) : ("bgColor" in _loader.vars ? 1 : 0);
         _fitWidth = "fitWidth" in _loader.vars ? Number(_loader.vars.fitWidth) : Number(_loader.vars.width);
         _fitHeight = "fitHeight" in _loader.vars ? Number(_loader.vars.fitHeight) : Number(_loader.vars.height);
         _update();
         if(_loader.vars.container is DisplayObjectContainer)
         {
            (_loader.vars.container as DisplayObjectContainer).addChild(this);
         }
         if(_loader.content != this)
         {
            (_loader as Object).setContentDisplay(this);
         }
         this.rawContent = (_loader as Object).rawContent;
      }
      
      public function get centerRegistration() : Boolean
      {
         return _centerRegistration;
      }
      
      public function set crop(value:Boolean) : void
      {
         _crop = value;
         _update();
      }
      
      public function set fitHeight(value:Number) : void
      {
         _fitHeight = value;
         _update();
      }
      
      public function get rawContent() : *
      {
         return _rawContent;
      }
      
      public function set bgAlpha(value:Number) : void
      {
         _bgAlpha = value;
         _update();
      }
      
      public function get fitWidth() : Number
      {
         return _fitWidth;
      }
      
      public function get vAlign() : String
      {
         return _vAlign;
      }
      
      public function set bgColor(value:uint) : void
      {
         _bgColor = value;
         _update();
      }
      
      public function set centerRegistration(value:Boolean) : void
      {
         _centerRegistration = value;
         _update();
      }
      
      public function set rawContent(value:*) : void
      {
         if(_rawContent != null && _rawContent != value)
         {
            if(_rawContent.parent == this)
            {
               removeChild(_rawContent);
            }
            else if(_cropContainer != null && _rawContent.parent == _cropContainer)
            {
               _cropContainer.removeChild(_rawContent);
               removeChild(_cropContainer);
               _cropContainer = null;
            }
         }
         _rawContent = value as DisplayObject;
         if(_rawContent == null)
         {
            return;
         }
         if(_rawContent.parent == null || _rawContent.parent != this && _rawContent.parent != _cropContainer)
         {
            addChildAt(_rawContent as DisplayObject,0);
         }
         _nativeRect = new Rectangle(0,0,_rawContent.width,_rawContent.height);
         _update();
      }
      
      public function set vAlign(value:String) : void
      {
         _vAlign = value;
         _update();
      }
      
      protected function _update() : void
      {
         var m:Matrix;
         var mc:DisplayObject = null;
         var nativeBounds:Object = null;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         var wGap:Number = NaN;
         var hGap:Number = NaN;
         var displayRatio:Number = NaN;
         var contentRatio:Number = NaN;
         var left:Number = _centerRegistration && _fitWidth > 0 ? _fitWidth / -2 : 0;
         var top:Number = _centerRegistration && _fitHeight > 0 ? _fitHeight / -2 : 0;
         graphics.clear();
         if(_fitWidth > 0 && _fitHeight > 0)
         {
            graphics.beginFill(_bgColor,_bgAlpha);
            graphics.drawRect(left,top,_fitWidth,_fitHeight);
            graphics.endFill();
         }
         if(_rawContent == null)
         {
            return;
         }
         mc = _rawContent;
         m = mc.transform.matrix;
         if(mc is Video)
         {
            nativeBounds = _nativeRect;
            contentWidth = mc.width;
            contentHeight = mc.height;
         }
         else
         {
            if(mc is Loader)
            {
               nativeBounds = Loader(mc).contentLoaderInfo;
            }
            else if(_loader != null && _loader.hasOwnProperty("getClass"))
            {
               nativeBounds = mc.loaderInfo;
            }
            else
            {
               nativeBounds = mc.getBounds(mc);
            }
            if(nativeBounds is LoaderInfo && _loader != null && _loader.progress < 1)
            {
               try
               {
                  contentWidth = Number(nativeBounds.width);
               }
               catch(error:Error)
               {
                  nativeBounds = mc.getBounds(mc);
               }
            }
            contentWidth = nativeBounds.width * Math.abs(m.a) + nativeBounds.height * Math.abs(m.b);
            contentHeight = nativeBounds.width * Math.abs(m.c) + nativeBounds.height * Math.abs(m.d);
         }
         if(_fitWidth > 0 && _fitHeight > 0)
         {
            w = _fitWidth;
            h = _fitHeight;
            wGap = w - contentWidth;
            hGap = h - contentHeight;
            if(_scaleMode != "none")
            {
               displayRatio = w / h;
               contentRatio = nativeBounds.width / nativeBounds.height;
               if(contentRatio < displayRatio && _scaleMode == "proportionalInside" || contentRatio > displayRatio && _scaleMode == "proportionalOutside")
               {
                  w = h * contentRatio;
               }
               if(contentRatio > displayRatio && _scaleMode == "proportionalInside" || contentRatio < displayRatio && _scaleMode == "proportionalOutside")
               {
                  h = w / contentRatio;
               }
               if(_scaleMode != "heightOnly")
               {
                  mc.width *= w / contentWidth;
                  wGap = _fitWidth - w;
               }
               if(_scaleMode != "widthOnly")
               {
                  mc.height *= h / contentHeight;
                  hGap = _fitHeight - h;
               }
            }
            if(_hAlign == "left")
            {
               wGap = 0;
            }
            else if(_hAlign != "right")
            {
               wGap /= 2;
            }
            if(_vAlign == "top")
            {
               hGap = 0;
            }
            else if(_vAlign != "bottom")
            {
               hGap /= 2;
            }
            if(_crop)
            {
               if(_cropContainer == null || mc.parent != _cropContainer)
               {
                  _cropContainer = new Sprite();
                  this.addChildAt(_cropContainer,this.getChildIndex(mc));
                  _cropContainer.addChild(mc);
               }
               _cropContainer.x = left;
               _cropContainer.y = top;
               _cropContainer.scrollRect = new Rectangle(0,0,_fitWidth,_fitHeight);
               mc.x = wGap;
               mc.y = hGap;
            }
            else
            {
               if(_cropContainer != null)
               {
                  this.addChildAt(mc,this.getChildIndex(_cropContainer));
                  _cropContainer = null;
               }
               mc.x = left + wGap;
               mc.y = top + hGap;
            }
         }
         else
         {
            mc.x = _centerRegistration ? contentWidth / -2 : 0;
            mc.y = _centerRegistration ? contentHeight / -2 : 0;
         }
      }
      
      public function set fitWidth(value:Number) : void
      {
         _fitWidth = value;
         _update();
      }
      
      public function set hAlign(value:String) : void
      {
         _hAlign = value;
         _update();
      }
      
      public function get hAlign() : String
      {
         return _hAlign;
      }
   }
}

