package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
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
   import mx.containers.HBox;
   import mx.controls.Image;
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.formatters.NumberFormatter;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class KDAView extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _KDAView_Text1:Text;
      
      public var _KDAView_Text2:Text;
      
      public var _KDAView_Text3:Text;
      
      mx_internal var _watchers:Array;
      
      public var _KDAView_Image1:Image;
      
      public var _KDAView_Image2:Image;
      
      public var _KDAView_Image3:Image;
      
      private var _864274100kdaImageSize:Number = 19;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _102052053kills:Number;
      
      private var _1811591370formatter:NumberFormatter;
      
      private var _1335772033deaths:Number;
      
      mx_internal var _bindings:Array;
      
      private var _704656598assists:Number;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1376177026precision:Number = 0;
      
      public function KDAView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":HBox,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"_KDAView_Image1",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"_KDAView_Text1",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "selectable":false,
                        "styleName":"summonerStatsTextSmall"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Spacer,
                  "propertiesFactory":function():Object
                  {
                     return {"width":10};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"_KDAView_Image2",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"_KDAView_Text2",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "selectable":false,
                        "styleName":"summonerStatsTextSmall"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Spacer,
                  "propertiesFactory":function():Object
                  {
                     return {"width":10};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"_KDAView_Image3",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"_KDAView_Text3",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "selectable":false,
                        "styleName":"summonerStatsTextSmall"
                     };
                  }
               })]};
            }
         });
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
            this.horizontalAlign = "right";
            this.verticalAlign = "middle";
            this.horizontalGap = -2;
         };
         this._KDAView_NumberFormatter1_i();
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         KDAView._watcherSetupUtil = param1;
      }
      
      public function set deaths(param1:Number) : void
      {
         var _loc2_:Object = this._1335772033deaths;
         if(_loc2_ !== param1)
         {
            this._1335772033deaths = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deaths",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:KDAView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._KDAView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_KDAViewWatcherSetupUtil");
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
      
      private function _KDAView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("decimal_seperator",".");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            formatter.decimalSeparatorTo = param1;
         },"formatter.decimalSeparatorTo");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("thousands_seperator",",");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            formatter.thousandsSeparatorTo = param1;
         },"formatter.thousandsSeparatorTo");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return this.precision;
         },function(param1:Object):void
         {
            formatter.precision = param1;
         },"formatter.precision");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return kdaImageSize;
         },function(param1:Number):void
         {
            _KDAView_Image1.width = param1;
         },"_KDAView_Image1.width");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return kdaImageSize;
         },function(param1:Number):void
         {
            _KDAView_Image1.height = param1;
         },"_KDAView_Image1.height");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_killsHeader");
         },function(param1:Object):void
         {
            _KDAView_Image1.source = param1;
         },"_KDAView_Image1.source");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getStatResourceString("CHAMPIONS_KILLED","**Kills");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _KDAView_Image1.toolTip = param1;
         },"_KDAView_Image1.toolTip");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = formatter.format(this.kills) + " ";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _KDAView_Text1.htmlText = param1;
         },"_KDAView_Text1.htmlText");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_deathsHeader");
         },function(param1:Object):void
         {
            _KDAView_Image2.source = param1;
         },"_KDAView_Image2.source");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return kdaImageSize;
         },function(param1:Number):void
         {
            _KDAView_Image2.width = param1;
         },"_KDAView_Image2.width");
         result[9] = binding;
         binding = new Binding(this,function():Number
         {
            return kdaImageSize;
         },function(param1:Number):void
         {
            _KDAView_Image2.height = param1;
         },"_KDAView_Image2.height");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getStatResourceString("NUM_DEATHS","**Deaths");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _KDAView_Image2.toolTip = param1;
         },"_KDAView_Image2.toolTip");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = formatter.format(this.deaths) + " ";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _KDAView_Text2.htmlText = param1;
         },"_KDAView_Text2.htmlText");
         result[12] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_assistsHeader");
         },function(param1:Object):void
         {
            _KDAView_Image3.source = param1;
         },"_KDAView_Image3.source");
         result[13] = binding;
         binding = new Binding(this,function():Number
         {
            return kdaImageSize;
         },function(param1:Number):void
         {
            _KDAView_Image3.width = param1;
         },"_KDAView_Image3.width");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return kdaImageSize;
         },function(param1:Number):void
         {
            _KDAView_Image3.height = param1;
         },"_KDAView_Image3.height");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getStatResourceString("ASSISTS","**Assists");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _KDAView_Image3.toolTip = param1;
         },"_KDAView_Image3.toolTip");
         result[16] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = formatter.format(this.assists);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _KDAView_Text3.htmlText = param1;
         },"_KDAView_Text3.htmlText");
         result[17] = binding;
         return result;
      }
      
      public function set formatter(param1:NumberFormatter) : void
      {
         var _loc2_:Object = this._1811591370formatter;
         if(_loc2_ !== param1)
         {
            this._1811591370formatter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"formatter",_loc2_,param1));
         }
      }
      
      public function set kills(param1:Number) : void
      {
         var _loc2_:Object = this._102052053kills;
         if(_loc2_ !== param1)
         {
            this._102052053kills = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kills",_loc2_,param1));
         }
      }
      
      private function _KDAView_NumberFormatter1_i() : NumberFormatter
      {
         var _loc1_:NumberFormatter = new NumberFormatter();
         this.formatter = _loc1_;
         _loc1_.rounding = "nearest";
         _loc1_.useNegativeSign = true;
         BindingManager.executeBindings(this,"formatter",this.formatter);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get kdaImageSize() : Number
      {
         return this._864274100kdaImageSize;
      }
      
      [Bindable(event="propertyChange")]
      public function get assists() : Number
      {
         return this._704656598assists;
      }
      
      private function _KDAView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getString("decimal_seperator",".");
         _loc1_ = RiotResourceLoader.getString("thousands_seperator",",");
         _loc1_ = this.precision;
         _loc1_ = this.kdaImageSize;
         _loc1_ = this.kdaImageSize;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_killsHeader");
         _loc1_ = RiotResourceLoader.getStatResourceString("CHAMPIONS_KILLED","**Kills");
         _loc1_ = this.formatter.format(this.kills) + " ";
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_deathsHeader");
         _loc1_ = this.kdaImageSize;
         _loc1_ = this.kdaImageSize;
         _loc1_ = RiotResourceLoader.getStatResourceString("NUM_DEATHS","**Deaths");
         _loc1_ = this.formatter.format(this.deaths) + " ";
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_assistsHeader");
         _loc1_ = this.kdaImageSize;
         _loc1_ = this.kdaImageSize;
         _loc1_ = RiotResourceLoader.getStatResourceString("ASSISTS","**Assists");
         _loc1_ = this.formatter.format(this.assists);
      }
      
      public function set assists(param1:Number) : void
      {
         var _loc2_:Object = this._704656598assists;
         if(_loc2_ !== param1)
         {
            this._704656598assists = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"assists",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get kills() : Number
      {
         return this._102052053kills;
      }
      
      [Bindable(event="propertyChange")]
      public function get formatter() : NumberFormatter
      {
         return this._1811591370formatter;
      }
      
      public function set kdaImageSize(param1:Number) : void
      {
         var _loc2_:Object = this._864274100kdaImageSize;
         if(_loc2_ !== param1)
         {
            this._864274100kdaImageSize = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kdaImageSize",_loc2_,param1));
         }
      }
      
      public function set precision(param1:Number) : void
      {
         var _loc2_:Object = this._1376177026precision;
         if(_loc2_ !== param1)
         {
            this._1376177026precision = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"precision",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get precision() : Number
      {
         return this._1376177026precision;
      }
      
      [Bindable(event="propertyChange")]
      public function get deaths() : Number
      {
         return this._1335772033deaths;
      }
   }
}

