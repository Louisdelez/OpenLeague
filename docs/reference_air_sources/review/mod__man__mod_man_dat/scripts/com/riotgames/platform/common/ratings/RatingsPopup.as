package com.riotgames.platform.common.ratings
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
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
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.IFocusManagerContainer;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class RatingsPopup extends Canvas implements IBindingClient, IFocusManagerContainer
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var fadeIn:Fade;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _39891285ratingsContainer:GradientCanvas;
      
      private const DISPLAY_DURATION:Number = 5000;
      
      private var delayTimer:Timer;
      
      private const FADE_IN_OUT_DURATION:Number = 500;
      
      private var _217337989ratingsImage:Image;
      
      private var onClosed:Signal;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      private var _422973635ratingsText:Text;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var fadeOut:Fade;
      
      public function RatingsPopup()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "id":"ratingsContainer",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "percentHeight":100,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "styleName":"serverPopupCanvas",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "id":"ratingsImage",
                           "stylesFactory":function():void
                           {
                              this.right = "15";
                              this.top = "15";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"visible":true};
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"ratingsText",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 57;
                              this.top = "160";
                              this.horizontalCenter = "0";
                              this.textAlign = "center";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"loginQueueNextUpdateLabel",
                                 "percentWidth":95,
                                 "selectable":false
                              };
                           }
                        })]
                     };
                  }
               })]};
            }
         });
         this.onClosed = new Signal();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.verticalCenter = "0";
            this.horizontalCenter = "0";
         };
         this.cacheAsBitmap = true;
         this.minWidth = 1000;
         this.minHeight = 600;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("creationComplete",this.___RatingsPopup_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         RatingsPopup._watcherSetupUtil = param1;
      }
      
      private function _RatingsPopup_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_koreanRatings");
         _loc1_ = RiotResourceLoader.getString("login_ratings_message");
      }
      
      [Bindable(event="propertyChange")]
      public function get ratingsImage() : Image
      {
         return this._217337989ratingsImage;
      }
      
      public function set ratingsText(param1:Text) : void
      {
         var _loc2_:Object = this._422973635ratingsText;
         if(_loc2_ !== param1)
         {
            this._422973635ratingsText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ratingsText",_loc2_,param1));
         }
      }
      
      private function onDelayTimer(param1:TimerEvent) : void
      {
         this.fadeOut.play([this.ratingsContainer]);
      }
      
      [Bindable(event="propertyChange")]
      public function get ratingsContainer() : GradientCanvas
      {
         return this._39891285ratingsContainer;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:RatingsPopup = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._RatingsPopup_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_common_ratings_RatingsPopupWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function get ratingsText() : Text
      {
         return this._422973635ratingsText;
      }
      
      public function set ratingsImage(param1:Image) : void
      {
         var _loc2_:Object = this._217337989ratingsImage;
         if(_loc2_ !== param1)
         {
            this._217337989ratingsImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ratingsImage",_loc2_,param1));
         }
      }
      
      public function ___RatingsPopup_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function _RatingsPopup_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_koreanRatings");
         },function(param1:Object):void
         {
            ratingsImage.source = param1;
         },"ratingsImage.source");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("login_ratings_message");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            ratingsText.htmlText = param1;
         },"ratingsText.htmlText");
         result[1] = binding;
         return result;
      }
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      public function set ratingsContainer(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._39891285ratingsContainer;
         if(_loc2_ !== param1)
         {
            this._39891285ratingsContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ratingsContainer",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.fadeIn = new Fade();
         this.fadeIn.alphaFrom = 0;
         this.fadeIn.alphaTo = 1;
         this.fadeIn.duration = this.FADE_IN_OUT_DURATION;
         this.fadeIn.addEventListener(EffectEvent.EFFECT_END,this.onFadeInCompleted,false,0,true);
         this.fadeOut = new Fade();
         this.fadeOut.alphaFrom = 1;
         this.fadeOut.alphaTo = 0;
         this.fadeOut.duration = this.FADE_IN_OUT_DURATION;
         this.fadeOut.addEventListener(EffectEvent.EFFECT_END,this.onFadeOutCompleted,false,0,true);
         this.delayTimer = new Timer(this.DISPLAY_DURATION,0);
         this.fadeIn.play([this.ratingsContainer]);
      }
      
      private function onFadeInCompleted(param1:EffectEvent) : void
      {
         this.delayTimer.addEventListener(TimerEvent.TIMER,this.onDelayTimer);
         this.delayTimer.start();
      }
      
      private function onFadeOutCompleted(param1:EffectEvent) : void
      {
         this.onClosed.dispatch(this.onClosed);
      }
   }
}

