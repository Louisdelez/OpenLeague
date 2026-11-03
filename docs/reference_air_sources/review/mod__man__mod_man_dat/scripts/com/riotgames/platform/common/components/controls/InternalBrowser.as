package com.riotgames.platform.common.components.controls
{
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.controls.Button;
   import mx.controls.HTML;
   import mx.controls.Image;
   import mx.controls.TextInput;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.styles.*;
   import mx.utils.URLUtil;
   
   use namespace mx_internal;
   
   public class InternalBrowser extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const LOADING_SPINNER:Class = InternalBrowser_LOADING_SPINNER;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      mx_internal var _watchers:Array = [];
      
      public var showBrowserBarByDefault:Boolean = false;
      
      public var _InternalBrowser_TextInput1:TextInput;
      
      public var _InternalBrowser_Image1:Image;
      
      private var _1430521512showBrowserBar:Boolean = false;
      
      public var closeBrowserOnLocationChange:Array = [];
      
      private var _90947722_html:HTML;
      
      private var _232239807isSecure:Boolean = true;
      
      private var _1726336317loadingSpinner:Image;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindings:Array = [];
      
      public var showBrowserBarForDomains:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "stylesFactory":function():void
               {
                  this.left = "20";
                  this.right = "20";
                  this.top = "35";
                  this.bottom = "40";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100,
                     "styleName":"browser",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"browserBar",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100,
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Button,
                                 "events":{"click":"___InternalBrowser_Button1_click"},
                                 "stylesFactory":function():void
                                 {
                                    this.left = "3";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "y":4,
                                       "styleName":"browserBack"
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "events":{"click":"___InternalBrowser_Button2_click"},
                                 "stylesFactory":function():void
                                 {
                                    this.left = "34";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "y":4,
                                       "styleName":"browserForward"
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "events":{"click":"___InternalBrowser_Button3_click"},
                                 "stylesFactory":function():void
                                 {
                                    this.left = "65";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "y":4,
                                       "styleName":"browserRefresh"
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Image,
                                 "id":"_InternalBrowser_Image1",
                                 "stylesFactory":function():void
                                 {
                                    this.left = "96";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "y":7,
                                       "source":_embed_mxml________ClientAssets_imageEmbeds_buttons_secure_png_281542736
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"_InternalBrowser_TextInput1",
                                 "stylesFactory":function():void
                                 {
                                    this.right = "66";
                                    this.left = "122";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "y":6,
                                       "editable":false,
                                       "enabled":false,
                                       "styleName":"browserUrlBar"
                                    };
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"loadingSpinner",
                        "stylesFactory":function():void
                        {
                           this.right = "35";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":4,
                              "scaleX":0.6,
                              "scaleY":0.6
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Button,
                        "events":{"click":"___InternalBrowser_Button4_click"},
                        "stylesFactory":function():void
                        {
                           this.right = "3";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":4,
                              "styleName":"browserClose"
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":HTML,
                        "id":"_html",
                        "events":{
                           "htmlDOMInitialize":"___html_htmlDOMInitialize",
                           "complete":"___html_complete",
                           "locationChange":"___html_locationChange"
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "x":0,
                              "y":40,
                              "percentWidth":100,
                              "percentHeight":100
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      private var _163567669browserBar:Canvas;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_buttons_secure_png_281542736:Class = InternalBrowser__embed_mxml________ClientAssets_imageEmbeds_buttons_secure_png_281542736;
      
      public function InternalBrowser()
      {
         super();
         mx_internal::_document = this;
         this.percentWidth = 100;
         this.percentHeight = 100;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         InternalBrowser._watcherSetupUtil = param1;
      }
      
      public function ___html_locationChange(param1:Event) : void
      {
         this.onLocationChanged();
      }
      
      public function set isSecure(param1:Boolean) : void
      {
         var _loc2_:Object = this._232239807isSecure;
         if(_loc2_ !== param1)
         {
            this._232239807isSecure = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSecure",_loc2_,param1));
         }
      }
      
      public function closeWindow() : void
      {
         this._html.cancelLoad();
         this._html.location = "";
         this._html.htmlText = "";
         this.dispatchEvent(new BrowserEvent(BrowserEvent.CLOSE_REQUESTED));
      }
      
      [Bindable(event="propertyChange")]
      public function get _html() : HTML
      {
         return this._90947722_html;
      }
      
      private function onCloseClicked() : void
      {
         this.closeWindow();
      }
      
      public function ___InternalBrowser_Button1_click(param1:MouseEvent) : void
      {
         this.onBackClicked();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:InternalBrowser = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._InternalBrowser_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_common_components_controls_InternalBrowserWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      public function set _html(param1:HTML) : void
      {
         var _loc2_:Object = this._90947722_html;
         if(_loc2_ !== param1)
         {
            this._90947722_html = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_html",_loc2_,param1));
         }
      }
      
      public function set loadingSpinner(param1:Image) : void
      {
         var _loc2_:Object = this._1726336317loadingSpinner;
         if(_loc2_ !== param1)
         {
            this._1726336317loadingSpinner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loadingSpinner",_loc2_,param1));
         }
      }
      
      public function set browserBar(param1:Canvas) : void
      {
         var _loc2_:Object = this._163567669browserBar;
         if(_loc2_ !== param1)
         {
            this._163567669browserBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"browserBar",_loc2_,param1));
         }
      }
      
      protected function initializeCallbacks() : void
      {
         if(Boolean(this._html && this._html.domWindow) && Boolean(this._html.location) && this._html.location != "about:blank")
         {
            this._html.domWindow.openExternalURL = this.openExternalURL;
            this._html.domWindow.closeWindow = this.closeWindow;
         }
      }
      
      public function ___InternalBrowser_Button3_click(param1:MouseEvent) : void
      {
         this.onReloadClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get showBrowserBar() : Boolean
      {
         return this._1430521512showBrowserBar;
      }
      
      private function _InternalBrowser_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.showBrowserBar;
         _loc1_ = this.isSecure;
         _loc1_ = this._html.location;
      }
      
      public function ___html_complete(param1:Event) : void
      {
         this.onLoadComplete();
      }
      
      private function onReloadClicked() : void
      {
         this._html.reload();
      }
      
      public function ___html_htmlDOMInitialize(param1:Event) : void
      {
         this.initializeCallbacks();
      }
      
      [Bindable(event="propertyChange")]
      public function get loadingSpinner() : Image
      {
         return this._1726336317loadingSpinner;
      }
      
      private function onLoadComplete() : void
      {
         this.loadingSpinner.source = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get isSecure() : Boolean
      {
         return this._232239807isSecure;
      }
      
      [Bindable(event="propertyChange")]
      public function get browserBar() : Canvas
      {
         return this._163567669browserBar;
      }
      
      public function navigateTo(param1:String) : void
      {
         this._html.location = param1;
      }
      
      public function set showBrowserBar(param1:Boolean) : void
      {
         var _loc2_:Object = this._1430521512showBrowserBar;
         if(_loc2_ !== param1)
         {
            this._1430521512showBrowserBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showBrowserBar",_loc2_,param1));
         }
      }
      
      public function ___InternalBrowser_Button2_click(param1:MouseEvent) : void
      {
         this.onForwardClicked();
      }
      
      public function ___InternalBrowser_Button4_click(param1:MouseEvent) : void
      {
         this.onCloseClicked();
      }
      
      private function onLocationChanged() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         this.loadingSpinner.source = LOADING_SPINNER;
         this.isSecure = URLUtil.isHttpsURL(this._html.location);
         if(!this.showBrowserBarByDefault)
         {
            _loc2_ = URLUtil.getServerName(this._html.location);
            for each(_loc1_ in this.showBrowserBarForDomains)
            {
               if(_loc2_.indexOf(_loc1_) != -1)
               {
                  this.showBrowserBar = true;
                  return;
               }
            }
            this.showBrowserBar = false;
         }
         if(this.closeBrowserOnLocationChange != null)
         {
            for each(_loc1_ in this.closeBrowserOnLocationChange)
            {
               if(this._html.location.indexOf(_loc1_) != -1)
               {
                  this.closeWindow();
                  break;
               }
            }
         }
      }
      
      private function onBackClicked() : void
      {
         this._html.historyBack();
      }
      
      private function _InternalBrowser_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return showBrowserBar;
         },function(param1:Boolean):void
         {
            browserBar.visible = param1;
         },"browserBar.visible");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return isSecure;
         },function(param1:Boolean):void
         {
            _InternalBrowser_Image1.visible = param1;
         },"_InternalBrowser_Image1.visible");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this._html.location;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InternalBrowser_TextInput1.text = param1;
         },"_InternalBrowser_TextInput1.text");
         result[2] = binding;
         return result;
      }
      
      private function onForwardClicked() : void
      {
         this._html.historyForward();
      }
      
      private function openExternalURL(param1:String) : void
      {
         navigateToURL(new URLRequest(param1),"_blank");
      }
   }
}

