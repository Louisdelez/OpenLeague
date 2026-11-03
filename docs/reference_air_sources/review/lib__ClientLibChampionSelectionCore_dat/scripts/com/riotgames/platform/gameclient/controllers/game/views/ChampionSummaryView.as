package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.game.views.itemRenderers.ChampionAbilityItemRenderer;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.game.ChampionAbility;
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
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.controls.HorizontalList;
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChampionSummaryView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1904717613fadeEffect:Fade;
      
      private var _710477343searchTags:String;
      
      private var _1658381128abilities:ArrayCollection;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _1639521861championName_txt:Text;
      
      private var _1961538924attackRank:String;
      
      private var _1177365930abilities_lst:HorizontalList;
      
      private var _13610857separator_img:Image;
      
      private var _986191789description_txt:Text;
      
      private var _champion:Champion;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _1834327417difficultyRank:String;
      
      private var _2128464761magicRank:String;
      
      private var _1724546052description:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _955036121championIdInfo_hb:HBox;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _907752616healthRank:String;
      
      private var _270636692championName:String;
      
      public function ChampionSummaryView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":HBox,
                  "id":"championIdInfo_hb",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.horizontalAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "y":0,
                        "percentWidth":100,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Text,
                           "id":"championName_txt",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 14;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"championSelectionHeader"};
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"description_txt",
                           "stylesFactory":function():void
                           {
                              this.fontSize = 14;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"championSelectionBody"};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"separator_img",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":HorizontalList,
                  "id":"abilities_lst",
                  "stylesFactory":function():void
                  {
                     this.bottom = "0";
                     this.backgroundAlpha = 0;
                     this.borderStyle = "none";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "itemRenderer":_ChampionSummaryView_ClassFactory1_c(),
                        "rowHeight":190,
                        "columnWidth":315
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
            this.fontSize = 12;
         };
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._ChampionSummaryView_Fade1_i();
         this.addEventListener("initialize",this.___ChampionSummaryView_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___ChampionSummaryView_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSummaryView._watcherSetupUtil = param1;
      }
      
      private function set magicRank(param1:String) : void
      {
         var _loc2_:Object = this._2128464761magicRank;
         if(_loc2_ !== param1)
         {
            this._2128464761magicRank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"magicRank",_loc2_,param1));
         }
      }
      
      private function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      public function set championName_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1639521861championName_txt;
         if(_loc2_ !== param1)
         {
            this._1639521861championName_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championName_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get difficultyRank() : String
      {
         return this._1834327417difficultyRank;
      }
      
      private function resetView() : void
      {
         this.championName = "";
         this.description = null;
         this.searchTags = null;
         this.healthRank = null;
         this.attackRank = null;
         this.magicRank = null;
         this.difficultyRank = null;
         this.abilities = null;
      }
      
      private function set difficultyRank(param1:String) : void
      {
         var _loc2_:Object = this._1834327417difficultyRank;
         if(_loc2_ !== param1)
         {
            this._1834327417difficultyRank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"difficultyRank",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSummaryView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSummaryView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionSummaryViewWatcherSetupUtil");
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
      private function get abilities() : ArrayCollection
      {
         return this._1658381128abilities;
      }
      
      [Bindable(event="propertyChange")]
      private function get championName() : String
      {
         return this._270636692championName;
      }
      
      private function _ChampionSummaryView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ChampionAbilityItemRenderer;
         return _loc1_;
      }
      
      private function set championName(param1:String) : void
      {
         var _loc2_:Object = this._270636692championName;
         if(_loc2_ !== param1)
         {
            this._270636692championName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description_txt() : Text
      {
         return this._986191789description_txt;
      }
      
      [Bindable(event="propertyChange")]
      private function get healthRank() : String
      {
         return this._907752616healthRank;
      }
      
      private function set abilities(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1658381128abilities;
         if(_loc2_ !== param1)
         {
            this._1658381128abilities = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilities",_loc2_,param1));
         }
      }
      
      private function _ChampionSummaryView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():*
         {
            return fadeEffect;
         },function(param1:*):void
         {
            this.setStyle("showEffect",param1);
         },"this.showEffect");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.championName + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championName_txt.htmlText = param1;
         },"championName_txt.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.description;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            description_txt.htmlText = param1;
         },"description_txt.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_championQuickViewSeparator");
         },function(param1:Object):void
         {
            separator_img.source = param1;
         },"separator_img.source");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return this.championIdInfo_hb.y + this.championIdInfo_hb.height - 2;
         },function(param1:Number):void
         {
            separator_img.y = param1;
         },"separator_img.y");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.separator_img.y + this.separator_img.height + 3;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            abilities_lst.setStyle("top",param1);
         },"abilities_lst.top");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return this.abilities;
         },function(param1:Object):void
         {
            abilities_lst.dataProvider = param1;
         },"abilities_lst.dataProvider");
         result[6] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeEffect() : Fade
      {
         return this._1904717613fadeEffect;
      }
      
      [Bindable(event="propertyChange")]
      public function get championIdInfo_hb() : HBox
      {
         return this._955036121championIdInfo_hb;
      }
      
      private function onCreationComplete() : void
      {
      }
      
      private function set attackRank(param1:String) : void
      {
         var _loc2_:Object = this._1961538924attackRank;
         if(_loc2_ !== param1)
         {
            this._1961538924attackRank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attackRank",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get attackRank() : String
      {
         return this._1961538924attackRank;
      }
      
      private function set _1431766121champion(param1:Champion) : void
      {
         if(param1 == null || param1.skinName == "Random")
         {
            this._champion = null;
            this.resetView();
         }
         else
         {
            this._champion = param1;
            this.initializeView();
         }
      }
      
      private function set searchTags(param1:String) : void
      {
         var _loc2_:Object = this._710477343searchTags;
         if(_loc2_ !== param1)
         {
            this._710477343searchTags = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"searchTags",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
      }
      
      public function ___ChampionSummaryView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get championName_txt() : Text
      {
         return this._1639521861championName_txt;
      }
      
      private function initializeView() : void
      {
         var _loc6_:String = null;
         var _loc7_:Class = null;
         var _loc8_:Boolean = false;
         this.championName = RiotResourceLoader.getChampionResourceString("name",this.champion.skinName,"");
         var _loc1_:String = RiotResourceLoader.getChampionResourceString("desc",this.champion.skinName,"");
         var _loc2_:String = " - ";
         var _loc3_:int = _loc1_.indexOf(_loc2_);
         this.description = _loc3_ >= 0 ? _loc1_.substring(_loc3_ + _loc2_.length) : _loc1_;
         var _loc4_:ChampionAbility = null;
         var _loc5_:ArrayCollection = new ArrayCollection();
         _loc3_ = 1;
         while(_loc3_ <= 4)
         {
            _loc4_ = new ChampionAbility();
            _loc4_.name = RiotResourceLoader.getChampionResourceString("ability" + _loc3_.toString() + "name",this.champion.skinName,"");
            _loc4_.description = RiotResourceLoader.getChampionResourceString("ability" + _loc3_.toString() + "description",this.champion.skinName,"");
            _loc6_ = this.champion["abilityIcon" + _loc3_.toString()] as String;
            _loc6_ = _loc6_ == null ? "Teemo_PoisonedDart.dds" : _loc6_;
            _loc6_ = _loc6_.replace(".dds",".png");
            _loc7_ = resourceManager.getClass("images",_loc6_.toLowerCase());
            _loc8_ = _loc7_ != null;
            _loc4_.iconSource = _loc8_ ? _loc7_ : "/assets/images/abilities/" + _loc6_;
            _loc5_.addItem(_loc4_);
            _loc3_++;
         }
         this.abilities = _loc5_;
      }
      
      [Bindable(event="propertyChange")]
      public function get abilities_lst() : HorizontalList
      {
         return this._1177365930abilities_lst;
      }
      
      private function set healthRank(param1:String) : void
      {
         var _loc2_:Object = this._907752616healthRank;
         if(_loc2_ !== param1)
         {
            this._907752616healthRank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"healthRank",_loc2_,param1));
         }
      }
      
      public function set abilities_lst(param1:HorizontalList) : void
      {
         var _loc2_:Object = this._1177365930abilities_lst;
         if(_loc2_ !== param1)
         {
            this._1177365930abilities_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilities_lst",_loc2_,param1));
         }
      }
      
      public function set championIdInfo_hb(param1:HBox) : void
      {
         var _loc2_:Object = this._955036121championIdInfo_hb;
         if(_loc2_ !== param1)
         {
            this._955036121championIdInfo_hb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championIdInfo_hb",_loc2_,param1));
         }
      }
      
      public function set description_txt(param1:Text) : void
      {
         var _loc2_:Object = this._986191789description_txt;
         if(_loc2_ !== param1)
         {
            this._986191789description_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get searchTags() : String
      {
         return this._710477343searchTags;
      }
      
      public function get champion() : Champion
      {
         return this._champion;
      }
      
      private function _ChampionSummaryView_Fade1_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         this.fadeEffect = _loc1_;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 150;
         return _loc1_;
      }
      
      public function set fadeEffect(param1:Fade) : void
      {
         var _loc2_:Object = this._1904717613fadeEffect;
         if(_loc2_ !== param1)
         {
            this._1904717613fadeEffect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeEffect",_loc2_,param1));
         }
      }
      
      public function set separator_img(param1:Image) : void
      {
         var _loc2_:Object = this._13610857separator_img;
         if(_loc2_ !== param1)
         {
            this._13610857separator_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"separator_img",_loc2_,param1));
         }
      }
      
      private function _ChampionSummaryView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.fadeEffect;
         _loc1_ = this.championName + ":";
         _loc1_ = this.description;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_championQuickViewSeparator");
         _loc1_ = this.championIdInfo_hb.y + this.championIdInfo_hb.height - 2;
         _loc1_ = this.separator_img.y + this.separator_img.height + 3;
         _loc1_ = this.abilities;
      }
      
      [Bindable(event="propertyChange")]
      public function get separator_img() : Image
      {
         return this._13610857separator_img;
      }
      
      [Bindable(event="propertyChange")]
      private function get magicRank() : String
      {
         return this._2128464761magicRank;
      }
      
      public function ___ChampionSummaryView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      private function get description() : String
      {
         return this._1724546052description;
      }
      
      [Bindable(event="propertyChange")]
      public function set champion(param1:Champion) : void
      {
         var _loc2_:Object = this.champion;
         if(_loc2_ !== param1)
         {
            this._1431766121champion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champion",_loc2_,param1));
         }
      }
   }
}

