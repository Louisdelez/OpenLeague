package flash.html
{
   import flash.display.*;
   import flash.geom.*;
   
   [API("661")]
   [native(cls="HTMLHostClass",instance="HTMLHostObject",methods="auto",construct="check")]
   public class HTMLHost
   {
      
      private static const kInvalidParamError:uint = 2004;
      
      private var _htmlLoader:HTMLLoader;
      
      private var _defaultBehaviors:Boolean;
      
      private var _titlePrefix:String;
      
      public function HTMLHost(defaultBehaviors:Boolean = true)
      {
         super();
         this._defaultBehaviors = defaultBehaviors;
      }
      
      private static native function samePageGroup(param1:HTMLLoader, param2:HTMLLoader) : void;
      
      internal function setHTMLControl(htmlLoader:HTMLLoader) : void
      {
         var unused:Error = null;
         if(Boolean(htmlLoader) && Boolean(this._htmlLoader))
         {
            Error.throwError(ArgumentError,kInvalidParamError);
         }
         this._htmlLoader = htmlLoader;
      }
      
      public function get htmlLoader() : HTMLLoader
      {
         return this._htmlLoader;
      }
      
      private function get window() : NativeWindow
      {
         if(Boolean(this._htmlLoader) && Boolean(this._htmlLoader.stage))
         {
            return this._htmlLoader.stage.nativeWindow;
         }
         return null;
      }
      
      public function get windowRect() : Rectangle
      {
         if(!this._defaultBehaviors)
         {
            return null;
         }
         if(Boolean(this.window) && !this.window.closed)
         {
            return this.window.bounds;
         }
         return null;
      }
      
      public function set windowRect(value:Rectangle) : void
      {
         if(!this._defaultBehaviors)
         {
            return;
         }
         if(Boolean(this.window) && !this.window.closed)
         {
            this.window.bounds = value;
         }
      }
      
      public function windowFocus() : void
      {
         if(!this._defaultBehaviors)
         {
            return;
         }
         if(Boolean(this.window) && !this.window.closed)
         {
            this.window.activate();
         }
      }
      
      public function windowBlur() : void
      {
         if(!this._defaultBehaviors)
         {
            return;
         }
         if(Boolean(this.window) && !this.window.closed)
         {
            this.window.orderToBack();
         }
      }
      
      public function updateLocation(locationURL:String) : void
      {
      }
      
      public function updateStatus(status:String) : void
      {
      }
      
      public function updateTitle(title:String) : void
      {
         var loc:* = undefined;
         if(!this._defaultBehaviors)
         {
            return;
         }
         if(Boolean(this.window) && !this.window.closed)
         {
            loc = this._htmlLoader.location;
            if(!loc || loc.toLowerCase().indexOf("app:") != 0)
            {
               if(Boolean(this._titlePrefix))
               {
                  title = this._titlePrefix + title;
               }
            }
            this.window.title = title;
         }
      }
      
      public function createWindow(windowCreateOptions:HTMLWindowCreateOptions) : HTMLLoader
      {
         if(!this._defaultBehaviors)
         {
            return null;
         }
         var windowInitOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
         windowInitOptions.resizable = windowCreateOptions.resizable;
         var bounds:Rectangle = new Rectangle(windowCreateOptions.x,windowCreateOptions.y,windowCreateOptions.width,windowCreateOptions.height);
         var newHTMLControl:HTMLLoader = HTMLLoader.createRootWindow(true,windowInitOptions,windowCreateOptions.scrollBarsVisible,bounds);
         if(!newHTMLControl)
         {
            return null;
         }
         if(Boolean(this.htmlLoader))
         {
            newHTMLControl.runtimeApplicationDomain = this.htmlLoader.runtimeApplicationDomain;
            newHTMLControl.paintsDefaultBackground = this.htmlLoader.paintsDefaultBackground;
            newHTMLControl.userAgent = this.htmlLoader.userAgent;
            newHTMLControl.manageCookies = this.htmlLoader.manageCookies;
            newHTMLControl.useCache = this.htmlLoader.useCache;
            newHTMLControl.cacheResponse = this.htmlLoader.cacheResponse;
            if(this.htmlLoader.hasOwnProperty("idleTimeout"))
            {
               newHTMLControl.idleTimeout = this.htmlLoader.idleTimeout;
            }
            newHTMLControl.authenticate = this.htmlLoader.authenticate;
            samePageGroup(this.htmlLoader,newHTMLControl);
         }
         if(Boolean(newHTMLControl.htmlHost))
         {
            if(Boolean(this._titlePrefix))
            {
               newHTMLControl.htmlHost._titlePrefix = this._titlePrefix;
            }
            else if(Boolean(this.window))
            {
               newHTMLControl.htmlHost._titlePrefix = this.window.title + ": ";
            }
            newHTMLControl.htmlHost.updateTitle("");
         }
         return newHTMLControl;
      }
      
      public function windowClose() : void
      {
         if(!this._defaultBehaviors)
         {
            return;
         }
         if(Boolean(this.window) && !this.window.closed)
         {
            this.window.close();
         }
      }
   }
}

