package com.riotgames.platform.gameclient.controllers.game.views
{
   import blix.signals.ISignal;
   import com.riotgames.platform.common.module.championdetail.ChampionDetailContext;
   import com.riotgames.platform.common.provider.ChampionDetailProviderProxy;
   import com.riotgames.platform.common.provider.IChampionDetailProvider;
   import com.riotgames.platform.common.resource.RentedChampionStatusText;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
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
   import mx.collections.Sort;
   import mx.containers.Canvas;
   import mx.controls.HScrollBar;
   import mx.controls.Text;
   import mx.core.IDataRenderer;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ScrollEvent;
   import mx.styles.*;
   import mx.utils.ObjectUtil;
   
   public class ChampionSkinSelector extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      protected var _195285075championSkins:ArrayCollection;
      
      private var renderers:Array;
      
      private var _621071059championSkinDisabled_txt:Text;
      
      private var _1261026587championSkinUnlock_txt:Text;
      
      private var _1754128692selected_txt:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      private var _playerSelection:PlayerSelection;
      
      private var _33968542championSkinName_txt:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      private var _1116990188previous_btn:SoundEffectButton;
      
      private var _417793574scrollbar:HScrollBar;
      
      private var _202312817skinsCoverFlow:SkinFlow;
      
      private var _672824249skinNameContainer:Canvas;
      
      private var _1424721680next_btn:SoundEffectButton;
      
      protected var selectedSkinChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _championSelectionModel:ChampionSelectionModel;
      
      protected var selectedChampionChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function ChampionSkinSelector()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"skinNameContainer",
                  "stylesFactory":function():void
                  {
                     this.backgroundAlpha = 0.5;
                     this.backgroundColor = 0;
                     this.left = "0";
                     this.right = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "verticalScrollPolicy":"off",
                        "horizontalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Text,
                           "id":"championSkinName_txt",
                           "stylesFactory":function():void
                           {
                              this.top = "2";
                              this.horizontalCenter = "0";
                              this.textAlign = "center";
                              this.fontSize = 14;
                              this.color = 16777215;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"championSelectionBody",
                                 "width":150,
                                 "selectable":false,
                                 "mouseChildren":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"selected_txt",
                           "stylesFactory":function():void
                           {
                              this.textAlign = "center";
                              this.fontSize = 14;
                              this.color = 16742172;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"championSelectionBody",
                                 "percentWidth":100,
                                 "selectable":false,
                                 "visible":false,
                                 "mouseChildren":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"championSkinUnlock_txt",
                           "events":{"click":"__championSkinUnlock_txt_click"},
                           "stylesFactory":function():void
                           {
                              this.textAlign = "center";
                              this.fontSize = 14;
                              this.color = 16711680;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"championSelectionBody",
                                 "percentWidth":100,
                                 "useHandCursor":true,
                                 "buttonMode":true,
                                 "selectable":false,
                                 "visible":false,
                                 "mouseChildren":false
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Text,
                           "id":"championSkinDisabled_txt",
                           "stylesFactory":function():void
                           {
                              this.textAlign = "center";
                              this.fontSize = 14;
                              this.color = 16711680;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "styleName":"championSelectionBody",
                                 "percentWidth":100,
                                 "selectable":false,
                                 "visible":false,
                                 "mouseChildren":false
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"previous_btn",
                  "events":{"click":"__previous_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.left = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "useHandCursor":true,
                        "buttonMode":true,
                        "styleName":"arrowLeftBlue"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"next_btn",
                  "events":{"click":"__next_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.right = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "useHandCursor":true,
                        "buttonMode":true,
                        "styleName":"arrowRightBlue"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":HScrollBar,
                  "id":"scrollbar",
                  "events":{"scroll":"__scrollbar_scroll"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "5";
                     this.horizontalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"blueGlassScrollBar",
                        "percentWidth":100,
                        "pageSize":1
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
            this.disabledOverlayAlpha = 0;
         };
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this.addEventListener("creationComplete",this.___ChampionSkinSelector_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSkinSelector._watcherSetupUtil = param1;
      }
      
      private function _ChampionSkinSelector_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = scrollbar.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            skinNameContainer.setStyle("bottom",param1);
         },"skinNameContainer.bottom");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return championSkinUnlock_txt.y + championSkinUnlock_txt.height + 5;
         },function(param1:Number):void
         {
            skinNameContainer.height = param1;
         },"skinNameContainer.height");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = championSkinName_txt.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            selected_txt.setStyle("top",param1);
         },"selected_txt.top");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_skinBrowser_selected_skin","**Selected");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            selected_txt.htmlText = param1;
         },"selected_txt.htmlText");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = championSkinName_txt.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championSkinUnlock_txt.setStyle("top",param1);
         },"championSkinUnlock_txt.top");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_skinBrowser_champion_unlock","**Click To Unlock");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championSkinUnlock_txt.htmlText = param1;
         },"championSkinUnlock_txt.htmlText");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = championSkinName_txt.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championSkinDisabled_txt.setStyle("top",param1);
         },"championSkinDisabled_txt.top");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("championSelection_skinBrowser_disabled_skin","**Selected");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championSkinDisabled_txt.htmlText = param1;
         },"championSkinDisabled_txt.htmlText");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return this.championSkins.length - 1;
         },function(param1:Number):void
         {
            scrollbar.maxScrollPosition = param1;
         },"scrollbar.maxScrollPosition");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return skinsCoverFlow.selectedIndex;
         },function(param1:Number):void
         {
            scrollbar.scrollPosition = param1;
         },"scrollbar.scrollPosition");
         result[9] = binding;
         return result;
      }
      
      private function addModelListeners() : void
      {
         if(Boolean(this._championSelectionModel))
         {
            this._championSelectionModel.addEventListener("isGameQueuedToStartChanged",this.onGameQueuedToStartChanged,false,0,true);
            this._championSelectionModel.teamSkinRentalChanged.add(this.onAllSkinsRentalUnlocked);
         }
      }
      
      protected function onSkinChanged(param1:Event) : void
      {
         this.updateSkin();
         this.selectSkin();
         this.setSkinName();
         this.updateOwnedText();
         this.updateButtons();
      }
      
      [Bindable(event="propertyChange")]
      public function get championSkinUnlock_txt() : Text
      {
         return this._1261026587championSkinUnlock_txt;
      }
      
      private function set skinsCoverFlow(param1:SkinFlow) : void
      {
         var _loc2_:Object = this._202312817skinsCoverFlow;
         if(_loc2_ !== param1)
         {
            this._202312817skinsCoverFlow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinsCoverFlow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get next_btn() : SoundEffectButton
      {
         return this._1424721680next_btn;
      }
      
      [Bindable(event="propertyChange")]
      public function get previous_btn() : SoundEffectButton
      {
         return this._1116990188previous_btn;
      }
      
      public function set next_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1424721680next_btn;
         if(_loc2_ !== param1)
         {
            this._1424721680next_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"next_btn",_loc2_,param1));
         }
      }
      
      private function setSkinName() : void
      {
         if(!(Boolean(this.skinsCoverFlow) && Boolean(this.skinsCoverFlow.selectedChild) && IDataRenderer(this.skinsCoverFlow.selectedChild).data))
         {
            return;
         }
         var _loc1_:ChampionSkin = IDataRenderer(this.skinsCoverFlow.selectedChild).data as ChampionSkin;
         var _loc2_:String = RiotResourceLoader.getChampionResourceString("name",_loc1_.getChampion().skinName,_loc1_.getChampion().skinName);
         var _loc3_:String = _loc2_;
         if(_loc1_.skinIndex == 0)
         {
            _loc3_ = RiotResourceLoader.getString("championSelection_skinBrowser_champion_classic","Classic");
         }
         else
         {
            _loc3_ = RiotResourceLoader.getChampionSkinResourceString("name",_loc1_.championSkinName,_loc1_.skinIndex,_loc2_);
         }
         if(Boolean(this.championSkinName_txt))
         {
            this.championSkinName_txt.htmlText = _loc3_;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get scrollbar() : HScrollBar
      {
         return this._417793574scrollbar;
      }
      
      public function set previous_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1116990188previous_btn;
         if(_loc2_ !== param1)
         {
            this._1116990188previous_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previous_btn",_loc2_,param1));
         }
      }
      
      public function set championSkinUnlock_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1261026587championSkinUnlock_txt;
         if(_loc2_ !== param1)
         {
            this._1261026587championSkinUnlock_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSkinUnlock_txt",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.setSelectedSkin();
         this.updateOwnedText();
         this.setSkinName();
         this.updateButtons();
      }
      
      public function ___ChampionSkinSelector_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function onPreviousButtonClicked() : void
      {
         if(this.skinsCoverFlow.selectedIndex > 0)
         {
            --this.skinsCoverFlow.selectedIndex;
            this.updateSkin();
            this.setSkinName();
            this.updateOwnedText();
            this.updateButtons();
         }
      }
      
      private function setSelectedSkin() : void
      {
         if(this.championSkins == null || this.skinsCoverFlow == null)
         {
            return;
         }
         if(this.playerSelection.selectedSkin == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.championSkins.length)
         {
            if(this.championSkins[_loc1_].skinId == this.playerSelection.selectedSkin.skinId)
            {
               if(this.skinsCoverFlow.selectedIndex != _loc1_)
               {
                  this.skinsCoverFlow.selectedIndex = _loc1_;
                  this.updateSkin();
               }
               break;
            }
            _loc1_++;
         }
      }
      
      private function onNextButtonClicked() : void
      {
         if(this.skinsCoverFlow.selectedIndex < this.skinsCoverFlow.numChildren - 1)
         {
            ++this.skinsCoverFlow.selectedIndex;
            this.updateSkin();
            this.setSkinName();
            this.updateOwnedText();
            this.updateButtons();
         }
      }
      
      public function __championSkinUnlock_txt_click(param1:MouseEvent) : void
      {
         this.onUnlockButtonClicked();
      }
      
      public function set scrollbar(param1:HScrollBar) : void
      {
         var _loc2_:Object = this._417793574scrollbar;
         if(_loc2_ !== param1)
         {
            this._417793574scrollbar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scrollbar",_loc2_,param1));
         }
      }
      
      private function onUnlockButtonClicked() : void
      {
         var _loc3_:Champion = null;
         if(Boolean(this.playerSelection) && this.playerSelection.champion != null)
         {
            _loc3_ = this.playerSelection.champion;
         }
         var _loc1_:ChampionSkin = IDataRenderer(this.skinsCoverFlow.selectedChild).data as ChampionSkin;
         var _loc2_:IChampionDetailProvider = ChampionDetailProviderProxy.instance;
         _loc2_.displayChampionDetailView(ChampionDetailContext.CHAMPION_SELECT,_loc3_,_loc1_.skinId,true);
      }
      
      public function set playerSelection(param1:PlayerSelection) : void
      {
         if(this._playerSelection == param1)
         {
            return;
         }
         this.removePlayerSelection();
         this._playerSelection = param1;
         this.setPlayerSelection();
         invalidateProperties();
      }
      
      protected function set championSkins(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._195285075championSkins;
         if(_loc2_ !== param1)
         {
            this._195285075championSkins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSkins",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championSkinName_txt() : Text
      {
         return this._33968542championSkinName_txt;
      }
      
      private function destroySkinFlow() : void
      {
         if(!this.skinsCoverFlow)
         {
            return;
         }
         this.removeChild(this.skinsCoverFlow);
         this.skinsCoverFlow.removeEventListener(Event.CHANGE,this.onSkinChanged);
         this.skinsCoverFlow = null;
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      private function createSkinFlow() : void
      {
         this.skinsCoverFlow = new SkinFlow();
         this.skinsCoverFlow.setStyle("horizontalCenter",0);
         this.skinsCoverFlow.y = -15;
         this.skinsCoverFlow.width = 600;
         this.skinsCoverFlow.height = 300;
         this.skinsCoverFlow.reflectionEnabled = false;
         this.skinsCoverFlow.rotationAngle = 50;
         this.skinsCoverFlow.setStyle("horizontalSpacing",165);
         this.skinsCoverFlow.setStyle("disabledOverlayAlpha",0);
         this.skinsCoverFlow.addEventListener(Event.CHANGE,this.onSkinChanged);
         this.addChildAt(this.skinsCoverFlow,0);
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      private function onGameQueuedToStartChanged(param1:Event) : void
      {
         this.updateButtons();
      }
      
      public function set skinNameContainer(param1:Canvas) : void
      {
         var _loc2_:Object = this._672824249skinNameContainer;
         if(_loc2_ !== param1)
         {
            this._672824249skinNameContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinNameContainer",_loc2_,param1));
         }
      }
      
      private function _ChampionSkinSelector_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.scrollbar.height;
         _loc1_ = this.championSkinUnlock_txt.y + this.championSkinUnlock_txt.height + 5;
         _loc1_ = this.championSkinName_txt.height;
         _loc1_ = RiotResourceLoader.getString("championSelection_skinBrowser_selected_skin","**Selected");
         _loc1_ = this.championSkinName_txt.height;
         _loc1_ = RiotResourceLoader.getString("championSelection_skinBrowser_champion_unlock","**Click To Unlock");
         _loc1_ = this.championSkinName_txt.height;
         _loc1_ = RiotResourceLoader.getString("championSelection_skinBrowser_disabled_skin","**Selected");
         _loc1_ = this.championSkins.length - 1;
         _loc1_ = this.skinsCoverFlow.selectedIndex;
      }
      
      private function createSkinRenderers() : void
      {
         var _loc2_:CoverFlowChampionSkinRenderer = null;
         if(this.renderers == null)
         {
            this.renderers = new Array();
         }
         if(!this.championSkins)
         {
            return;
         }
         var _loc1_:int = 0;
         _loc1_ = int(this.renderers.length);
         while(_loc1_ < this.championSkins.length)
         {
            _loc2_ = new CoverFlowChampionSkinRenderer();
            _loc2_.width = 160;
            _loc2_.height = 288;
            this.renderers.push(_loc2_);
            this.skinsCoverFlow.addChild(_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.championSkins.length)
         {
            _loc2_ = this.renderers[_loc1_] as CoverFlowChampionSkinRenderer;
            _loc2_.data = this.championSkins.getItemAt(_loc1_);
            _loc2_.setChampionSelectionModel(this._championSelectionModel);
            if(Boolean(_loc2_) && _loc2_.parent != this.skinsCoverFlow)
            {
               this.skinsCoverFlow.addChild(this.renderers[_loc1_]);
            }
            _loc1_++;
         }
         if(this.championSkins.length == 0)
         {
            return;
         }
         _loc1_ = int(this.championSkins.length);
         while(_loc1_ < this.renderers.length)
         {
            _loc2_ = this.renderers[_loc1_] as CoverFlowChampionSkinRenderer;
            if(Boolean(_loc2_) && _loc2_.parent == this.skinsCoverFlow)
            {
               this.skinsCoverFlow.removeChild(this.renderers[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      private function updateButtons() : void
      {
         if(Boolean(this.championSelectionModel) && this.championSelectionModel.isGameQueuedToStart)
         {
            enabled = false;
         }
         else
         {
            enabled = true;
         }
         if(Boolean(this.previous_btn && this.next_btn) && Boolean(this.championSelectionModel) && this.championSelectionModel.isGameQueuedToStart)
         {
            this.previous_btn.enabled = false;
            this.next_btn.enabled = false;
         }
         else
         {
            if(Boolean(this.previous_btn) && Boolean(this.skinsCoverFlow))
            {
               this.previous_btn.enabled = this.skinsCoverFlow.selectedIndex > 0;
            }
            else if(Boolean(this.previous_btn))
            {
               this.previous_btn.enabled = false;
            }
            if(Boolean(this.next_btn) && Boolean(this.skinsCoverFlow))
            {
               this.next_btn.enabled = this.skinsCoverFlow.selectedIndex < this.championSkins.length - 1;
            }
            else if(Boolean(this.next_btn))
            {
               this.next_btn.enabled = false;
            }
         }
      }
      
      public function __next_btn_click(param1:MouseEvent) : void
      {
         this.onNextButtonClicked();
      }
      
      public function __previous_btn_click(param1:MouseEvent) : void
      {
         this.onPreviousButtonClicked();
      }
      
      private function onSelectedSkinChanged(param1:Event) : void
      {
         this.selectedSkinChanged = true;
         invalidateProperties();
      }
      
      protected function removePlayerSelection() : void
      {
         if(!this._playerSelection)
         {
            return;
         }
         this.playerSelection.removeEventListener("championChanged",this.onSummonedChampionChanged);
         this.playerSelection.removeEventListener("selectedSkinChanged",this.onSelectedSkinChanged);
         this.destroySkinProvider();
      }
      
      public function set championSelectionModel(param1:ChampionSelectionModel) : void
      {
         if(this._championSelectionModel == param1)
         {
            return;
         }
         this.removeModelListeners();
         this._championSelectionModel = param1;
         this.addModelListeners();
      }
      
      [Bindable(event="propertyChange")]
      private function get skinsCoverFlow() : SkinFlow
      {
         return this._202312817skinsCoverFlow;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSkinSelector = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSkinSelector_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionSkinSelectorWatcherSetupUtil");
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
      
      private function selectSkin() : void
      {
         if(!this.skinsCoverFlow || !this.skinsCoverFlow.selectedChild)
         {
            return;
         }
         var _loc1_:PlayerSelection = new PlayerSelection(this.playerSelection.participant);
         _loc1_.selectedSkin = IDataRenderer(this.skinsCoverFlow.selectedChild).data as ChampionSkin;
         if(this.playerSelection.champion != null && !this.playerSelection.champion.isWildCardChampion() && !this.playerSelection.champion.isRandomChampion())
         {
            dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.SKIN_SELECTED,_loc1_));
         }
      }
      
      private function onSkinsCoverFlowCreationComplete(param1:FlexEvent) : void
      {
         this.setSelectedSkin();
         this.setSkinName();
         this.updateButtons();
      }
      
      public function set selected_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1754128692selected_txt;
         if(_loc2_ !== param1)
         {
            this._1754128692selected_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selected_txt",_loc2_,param1));
         }
      }
      
      private function destroySkinProvider() : void
      {
         this.championSkins = null;
      }
      
      private function updateOwnedText() : void
      {
         if(!this.skinsCoverFlow || !this.skinsCoverFlow.selectedChild || !this.championSkinUnlock_txt || !this.selected_txt)
         {
            return;
         }
         var _loc1_:ChampionSkin = IDataRenderer(this.skinsCoverFlow.selectedChild).data as ChampionSkin;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Boolean = Boolean(this._championSelectionModel) && this._championSelectionModel.allSkinsRentalUnlock;
         this.selected_txt.visible = false;
         this.championSkinDisabled_txt.visible = false;
         this.championSkinUnlock_txt.visible = !_loc1_.isAvailable() && !_loc2_ && !_loc1_.skinDisabled;
         if(_loc1_.lastSelected)
         {
            this.championSkinUnlock_txt.visible = false;
            this.selected_txt.visible = true;
            if(_loc1_.isRented())
            {
               this.selected_txt.htmlText = RentedChampionStatusText.GetHTMLText(_loc1_);
            }
            else
            {
               this.selected_txt.htmlText = RiotResourceLoader.getString("championSelection_skinBrowser_selected_skin","Selected");
            }
         }
         else if(_loc2_ && !_loc1_.isAvailable())
         {
            this.selected_txt.visible = true;
            this.selected_txt.htmlText = RiotResourceLoader.getString("skinUnlock_skinBrowser_unlockedSkin");
         }
         else if(_loc1_.skinDisabled)
         {
            this.championSkinDisabled_txt.visible = true;
         }
      }
      
      public function get playerSelection() : PlayerSelection
      {
         return this._playerSelection;
      }
      
      public function set championSkinDisabled_txt(param1:Text) : void
      {
         var _loc2_:Object = this._621071059championSkinDisabled_txt;
         if(_loc2_ !== param1)
         {
            this._621071059championSkinDisabled_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSkinDisabled_txt",_loc2_,param1));
         }
      }
      
      private function createSkinProvider() : void
      {
         var _loc3_:Champion = null;
         var _loc4_:ChampionSkin = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         if(Boolean(this.playerSelection) && this.playerSelection.champion != null)
         {
            _loc3_ = this.playerSelection.champion;
            _loc1_.addItem(_loc3_.defaultSkin);
            for each(_loc4_ in _loc3_.championSkins)
            {
               if((Boolean(_loc4_.stillObtainable) || Boolean(_loc4_.isAvailable())) && _loc4_.skinId != _loc3_.defaultSkin.skinId)
               {
                  _loc1_.addItem(_loc4_);
               }
            }
         }
         var _loc2_:Sort = new Sort();
         _loc2_.compareFunction = this.compareSkins;
         _loc1_.sort = _loc2_;
         _loc1_.refresh();
         this.championSkins = _loc1_;
         _loc1_.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSkinListCollectionChange,false,0,true);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.updateOwnedText();
      }
      
      [Bindable(event="propertyChange")]
      public function get skinNameContainer() : Canvas
      {
         return this._672824249skinNameContainer;
      }
      
      private function removeModelListeners() : void
      {
         if(Boolean(this._championSelectionModel))
         {
            this._championSelectionModel.removeEventListener("isGameQueuedToStartChanged",this.onGameQueuedToStartChanged);
            this._championSelectionModel.teamSkinRentalChanged.remove(this.onAllSkinsRentalUnlocked);
         }
      }
      
      private function onAllSkinsRentalUnlocked(param1:ISignal, param2:*) : void
      {
         var _loc3_:ChampionSkin = null;
         this.updateOwnedText();
         if(Boolean(param2) && Boolean(this.skinsCoverFlow) && Boolean(this.skinsCoverFlow.selectedChild))
         {
            _loc3_ = IDataRenderer(this.skinsCoverFlow.selectedChild).data as ChampionSkin;
            if(!_loc3_.lastSelected)
            {
               this.selectSkin();
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get championSkins() : ArrayCollection
      {
         return this._195285075championSkins;
      }
      
      private function compareSkins(param1:ChampionSkin, param2:ChampionSkin, param3:Array = null) : int
      {
         if(param1.skinId == param2.skinId)
         {
            return 0;
         }
         if(param1.skinIndex == 0)
         {
            return -1;
         }
         if(param2.skinIndex == 0)
         {
            return 1;
         }
         if(Boolean(param1.owned) && !param2.owned)
         {
            return -1;
         }
         if(!param1.owned && Boolean(param2.owned))
         {
            return 1;
         }
         return ObjectUtil.numericCompare(param1.skinIndex,param2.skinIndex);
      }
      
      public function set championSkinName_txt(param1:Text) : void
      {
         var _loc2_:Object = this._33968542championSkinName_txt;
         if(_loc2_ !== param1)
         {
            this._33968542championSkinName_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSkinName_txt",_loc2_,param1));
         }
      }
      
      public function get championSelectionModel() : ChampionSelectionModel
      {
         return this._championSelectionModel;
      }
      
      protected function onSkinListCollectionChange(param1:Event) : void
      {
         this.updateSkin();
         this.selectSkin();
         this.setSkinName();
         this.updateOwnedText();
         this.updateButtons();
      }
      
      [Bindable(event="propertyChange")]
      public function get selected_txt() : Text
      {
         return this._1754128692selected_txt;
      }
      
      override protected function commitProperties() : void
      {
         if(this.selectedChampionChanged)
         {
            if(!this.skinsCoverFlow)
            {
               this.createSkinFlow();
            }
            this.createSkinRenderers();
            this.setSelectedSkin();
            this.updateOwnedText();
            this.setSkinName();
            this.updateButtons();
            this.selectedChampionChanged = false;
            this.invalidateSize();
            this.invalidateDisplayList();
         }
         if(this.selectedSkinChanged)
         {
            this.updateOwnedText();
            this.selectedSkinChanged = false;
         }
         super.commitProperties();
      }
      
      private function onSummonedChampionChanged(param1:Event) : void
      {
         this.createSkinProvider();
         this.selectedChampionChanged = true;
         invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function get championSkinDisabled_txt() : Text
      {
         return this._621071059championSkinDisabled_txt;
      }
      
      private function updateSkin() : void
      {
         var _loc2_:CoverFlowChampionSkinRenderer = null;
         if(this.skinsCoverFlow == null || this.skinsCoverFlow.selectedChild == null)
         {
            return;
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this.skinsCoverFlow.numChildren)
         {
            _loc2_ = this.skinsCoverFlow.getChildAt(_loc1_) as CoverFlowChampionSkinRenderer;
            if(Boolean(_loc2_))
            {
               _loc2_.setFocused(_loc2_ == this.skinsCoverFlow.selectedChild);
            }
            _loc1_++;
         }
      }
      
      protected function setPlayerSelection() : void
      {
         if(!this.playerSelection)
         {
            return;
         }
         this.playerSelection.addEventListener("championChanged",this.onSummonedChampionChanged,false,0,true);
         this.playerSelection.addEventListener("selectedSkinChanged",this.onSelectedSkinChanged,false,0,true);
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.createSkinProvider();
         this.selectedChampionChanged = true;
         this.selectedSkinChanged = true;
         invalidateProperties();
      }
      
      public function __scrollbar_scroll(param1:ScrollEvent) : void
      {
         this.skinsCoverFlow.selectedIndex = Math.round(this.scrollbar.scrollPosition);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
   }
}

