package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.resource.RentedChampionStatusText;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.controllers.game.utils.ChampionImages;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.game.TeamColors;
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
   import mx.controls.Label;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   public class ChampionTooltip extends Canvas implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _483785606championDescLabel:Label;
      
      private var _732564288championNameLabel:Label;
      
      public var _text:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _204468622championImage:Image;
      
      private var _638460423championStatusLabel:Label;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function ChampionTooltip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"championImage",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":2.5,
                        "y":2.5,
                        "autoLoad":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "stylesFactory":function():void
                  {
                     this.left = "0";
                     this.right = "0";
                     this.bottom = "0";
                     this.backgroundAlpha = 0.25;
                     this.backgroundColor = 0;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "height":80,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Label,
                           "id":"championNameLabel",
                           "stylesFactory":function():void
                           {
                              this.top = "0";
                              this.horizontalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"championTooltipText"};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"championDescLabel",
                           "stylesFactory":function():void
                           {
                              this.verticalCenter = "0";
                              this.horizontalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"championTooltipText"};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"championStatusLabel",
                           "stylesFactory":function():void
                           {
                              this.bottom = "0";
                              this.horizontalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"championTooltipText"};
                           }
                        })]
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
            this.backgroundAlpha = 1;
            this.backgroundColor = 0;
            this.borderStyle = "solid";
            this.borderColor = 11184810;
            this.cornerRadius = 6;
            this.borderThickness = 1;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.alpha = 0;
         this.addEventListener("creationComplete",this.___ChampionTooltip_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionTooltip._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get championNameLabel() : Label
      {
         return this._732564288championNameLabel;
      }
      
      public function set championDescLabel(param1:Label) : void
      {
         var _loc2_:Object = this._483785606championDescLabel;
         if(_loc2_ !== param1)
         {
            this._483785606championDescLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championDescLabel",_loc2_,param1));
         }
      }
      
      public function set championNameLabel(param1:Label) : void
      {
         var _loc2_:Object = this._732564288championNameLabel;
         if(_loc2_ !== param1)
         {
            this._732564288championNameLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championNameLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championStatusLabel() : Label
      {
         return this._638460423championStatusLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get championDescLabel() : Label
      {
         return this._483785606championDescLabel;
      }
      
      private function _ChampionTooltip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return getWidth();
         },function(param1:Number):void
         {
            this.width = param1;
         },"this.width");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return getHeight();
         },function(param1:Number):void
         {
            this.height = param1;
         },"this.height");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return getImageWidth();
         },function(param1:Number):void
         {
            championImage.width = param1;
         },"championImage.width");
         result[2] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionTooltip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionTooltip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionTooltipWatcherSetupUtil");
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
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(!data)
         {
            return;
         }
         var _loc1_:ParticipantChampionSelection = this.data as ParticipantChampionSelection;
         var _loc2_:Champion = this.data.champion as Champion;
         if(Boolean(_loc1_) && Boolean(_loc2_) && Boolean(this.championImage))
         {
            this.championImage.source = ChampionImages.getImagePath(_loc2_.skinName,_loc2_.getCurrentChampionSkin().skinIndex);
            this.championNameLabel.htmlText = _loc2_.displayName;
            this.championDescLabel.htmlText = _loc2_.description;
            if(_loc1_.participant == null)
            {
               if(_loc2_.active == false)
               {
                  this.championStatusLabel.htmlText = ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_disabled");
                  if(this.championStatusLabel.htmlText == null || this.championStatusLabel.htmlText == "")
                  {
                     this.championStatusLabel.htmlText = "**Disabled";
                  }
                  this.championStatusLabel.setStyle("color",TeamColors.ENEMY_TEAM_COLOR);
               }
               else if(_loc1_.banned == true)
               {
                  this.championStatusLabel.htmlText = ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_banned");
                  if(this.championStatusLabel.htmlText == null || this.championStatusLabel.htmlText == "")
                  {
                     this.championStatusLabel.htmlText = "**Banned";
                  }
                  this.championStatusLabel.setStyle("color",TeamColors.ENEMY_TEAM_COLOR);
               }
               else if(_loc2_.freeToPlay == true || Boolean(_loc2_.freeToPlayReward))
               {
                  this.championStatusLabel.htmlText = ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_freeToPlay");
                  this.championStatusLabel.setStyle("color",TeamColors.FRIENDLY_TEAM_COLOR);
               }
               else if(_loc2_.isRented())
               {
                  this.championStatusLabel.htmlText = RentedChampionStatusText.GetHTMLText(_loc2_);
                  this.championStatusLabel.setStyle("color","#FF771C");
               }
               else
               {
                  this.championStatusLabel.htmlText = "";
               }
            }
            else if(_loc1_.participant.isMe)
            {
               this.championStatusLabel.htmlText = ResourceManager.getInstance().getString("resources","summonerProfile_championsInfo_summoned_self");
               if(this.championStatusLabel.htmlText == null || this.championStatusLabel.htmlText == "")
               {
                  this.championStatusLabel.htmlText = "**Summoned";
               }
               this.championStatusLabel.setStyle("color","#FF771C");
            }
            else
            {
               this.championStatusLabel.htmlText = _loc1_.participant.summonerName;
               this.championStatusLabel.setStyle("color",TeamColors.ENEMY_TEAM_COLOR);
            }
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         invalidateProperties();
      }
      
      public function set text(param1:String) : void
      {
      }
      
      protected function getHeight() : Number
      {
         return 435.44 * ApplicationUtil.application.scaleY;
      }
      
      protected function getWidth() : Number
      {
         return 240 * ApplicationUtil.application.scaleX;
      }
      
      protected function getImageWidth() : Number
      {
         return 235 * ApplicationUtil.application.scaleX;
      }
      
      private function _ChampionTooltip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.getWidth();
         _loc1_ = this.getHeight();
         _loc1_ = this.getImageWidth();
      }
      
      public function set championImage(param1:Image) : void
      {
         var _loc2_:Object = this._204468622championImage;
         if(_loc2_ !== param1)
         {
            this._204468622championImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championImage",_loc2_,param1));
         }
      }
      
      public function ___ChampionTooltip_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      private function onCreationComplete() : void
      {
         invalidateProperties();
         var _loc1_:Fade = new Fade(this);
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 250;
         _loc1_.play();
      }
      
      public function set championStatusLabel(param1:Label) : void
      {
         var _loc2_:Object = this._638460423championStatusLabel;
         if(_loc2_ !== param1)
         {
            this._638460423championStatusLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championStatusLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championImage() : Image
      {
         return this._204468622championImage;
      }
   }
}

