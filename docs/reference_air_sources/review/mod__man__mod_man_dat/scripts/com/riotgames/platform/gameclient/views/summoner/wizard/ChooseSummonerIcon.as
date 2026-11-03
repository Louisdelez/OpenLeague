package com.riotgames.platform.gameclient.views.summoner.wizard
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.buddyImages.SummonerIconData;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import com.riotgames.pvpnet.accountcreation.model.ChooseIconModel;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
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
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.controls.TextArea;
   import mx.controls.TileList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFactory;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.states.AddChild;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ChooseSummonerIcon extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const LOADING_SPINNER:Class = ChooseSummonerIcon_LOADING_SPINNER;
      
      public static const STATE_NONE:String = "NONE";
      
      public static const STATE_LOADED:String = "LOADED";
      
      public static const STATE_LOADING:String = "LOADING";
      
      public var _ChooseSummonerIcon_State1:State;
      
      public var _ChooseSummonerIcon_State2:State;
      
      private var iContextAlertProvider:Object;
      
      public var _ChooseSummonerIcon_State3:State;
      
      private var lastSelectedItem:SummonerIconData;
      
      public var _ChooseSummonerIcon_AddChild1:AddChild;
      
      public var _ChooseSummonerIcon_AddChild2:AddChild;
      
      mx_internal var _watchers:Array = [];
      
      public var _ChooseSummonerIcon_TextArea1:TextArea;
      
      private var _106433028panel:Canvas;
      
      private var onClosed:Signal = new Signal();
      
      private var _213292952header_lb:Label;
      
      private var tempIconsIdx:Dictionary = null;
      
      private var _1638774782icon_tl:TileList;
      
      private var _1888947991cancel_btn:SoundEffectButton;
      
      private var _1424721680next_btn:SoundEffectButton;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var chooseIconModel:ChooseIconModel;
      
      private var _816711803iconHolder:Canvas;
      
      private var hasOrdered:Number = NaN;
      
      private var _1506094686userIconList:ArrayCollection;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"panel",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
                  this.verticalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "width":792,
                     "height":348,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Label,
                        "id":"header_lb",
                        "stylesFactory":function():void
                        {
                           this.left = "13";
                           this.top = "13";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"s1FormHeader",
                              "width":392
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"_ChooseSummonerIcon_Image2",
                        "stylesFactory":function():void
                        {
                           this.left = "15";
                           this.top = "54";
                        }
                     }),new UIComponentDescriptor({
                        "type":HBox,
                        "stylesFactory":function():void
                        {
                           this.left = "23";
                           this.top = "44";
                           this.right = "13";
                           this.horizontalGap = 10;
                           this.verticalAlign = "middle";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "height":254,
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Canvas,
                                 "id":"iconHolder",
                                 "events":{"creationComplete":"__iconHolder_creationComplete"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "width":394,
                                       "height":224
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Spacer,
                                 "propertiesFactory":function():Object
                                 {
                                    return {"width":6};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":TextArea,
                                 "id":"_ChooseSummonerIcon_TextArea1",
                                 "stylesFactory":function():void
                                 {
                                    this.verticalScrollBarStyleName = "summonerIconScrollBar";
                                    this.fontSize = 15;
                                    this.textAlign = "left";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "styleName":"s1FormMessage",
                                       "selectable":false,
                                       "editable":false,
                                       "width":325,
                                       "height":226
                                    };
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":HBox,
                        "stylesFactory":function():void
                        {
                           this.bottom = "11";
                           this.right = "11";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"childDescriptors":[new UIComponentDescriptor({
                              "type":SoundEffectButton,
                              "id":"cancel_btn",
                              "events":{"click":"__cancel_btn_click"},
                              "stylesFactory":function():void
                              {
                                 this.bottom = "5";
                                 this.right = "5";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"s1FormButton",
                                    "enabled":true
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":SoundEffectButton,
                              "id":"next_btn",
                              "events":{"click":"__next_btn_click"},
                              "stylesFactory":function():void
                              {
                                 this.bottom = "5";
                                 this.right = "5";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {"styleName":"s1FormButton"};
                              }
                           })]};
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      public var _ChooseSummonerIcon_Image1:Image;
      
      public var _ChooseSummonerIcon_Image2:Image;
      
      mx_internal var _bindings:Array = [];
      
      public function ChooseSummonerIcon()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.states = [this._ChooseSummonerIcon_State1_i(),this._ChooseSummonerIcon_State2_i(),this._ChooseSummonerIcon_State3_i()];
         this.addEventListener("show",this.___ChooseSummonerIcon_Canvas1_show);
         this.addEventListener("hide",this.___ChooseSummonerIcon_Canvas1_hide);
         this.addEventListener("keyDown",this.___ChooseSummonerIcon_Canvas1_keyDown);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChooseSummonerIcon._watcherSetupUtil = param1;
      }
      
      public function __next_btn_click(param1:MouseEvent) : void
      {
         this.closeChooseIconDialog();
      }
      
      [Bindable(event="propertyChange")]
      public function get iconHolder() : Canvas
      {
         return this._816711803iconHolder;
      }
      
      public function ___ChooseSummonerIcon_Canvas1_hide(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get icon_tl() : TileList
      {
         return this._1638774782icon_tl;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChooseSummonerIcon = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChooseSummonerIcon_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_wizard_ChooseSummonerIconWatcherSetupUtil");
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
      
      public function set iconHolder(param1:Canvas) : void
      {
         var _loc2_:Object = this._816711803iconHolder;
         if(_loc2_ !== param1)
         {
            this._816711803iconHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iconHolder",_loc2_,param1));
         }
      }
      
      private function tileList_selectHandler(param1:ListEvent) : void
      {
         this.clearSelection();
         this.lastSelectedItem = this.icon_tl.selectedItem as SummonerIconData;
         this.lastSelectedItem.selected = true;
         this.chooseIconModel.setPendingIcon(this.lastSelectedItem.iconId);
         this.onIconSelected(this.lastSelectedItem.iconId);
         this.next_btn.enabled = !this.lastSelectedItem.restrictedFromUse;
      }
      
      [Bindable(event="propertyChange")]
      public function get cancel_btn() : SoundEffectButton
      {
         return this._1888947991cancel_btn;
      }
      
      private function reorderSpecialIconsForVisibility(param1:ArrayCollection) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:IResourceManager = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         if(this.hasOrdered != param1.length)
         {
            _loc2_ = new Dictionary();
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = _loc3_.getString("resources","summonerProfile_iconsIdsToSortAtFront");
            if(_loc4_ != null)
            {
               _loc7_ = _loc4_.split(",");
               for each(_loc8_ in _loc7_)
               {
                  _loc2_[Number(_loc8_)] = true;
               }
            }
            _loc5_ = new Array();
            _loc6_ = new Array();
            while(param1.length > 0)
            {
               _loc9_ = param1.removeItemAt(0);
               if(_loc2_[_loc9_.iconId])
               {
                  _loc6_.push(_loc9_);
               }
               else
               {
                  _loc5_.push(_loc9_);
               }
            }
            if(_loc5_.length > 0)
            {
               _loc5_.sortOn("iconId",Array.NUMERIC);
            }
            if(_loc6_.length > 0)
            {
               _loc6_.sortOn("iconId",Array.NUMERIC);
            }
            while(_loc5_.length > 0)
            {
               param1.addItemAt(_loc5_.shift(),0);
            }
            while(_loc6_.length > 0)
            {
               param1.addItemAt(_loc6_.shift(),0);
            }
            this.hasOrdered = param1.length;
         }
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
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      [Bindable(event="propertyChange")]
      private function get userIconList() : ArrayCollection
      {
         return this._1506094686userIconList;
      }
      
      [Bindable(event="propertyChange")]
      public function get panel() : Canvas
      {
         return this._106433028panel;
      }
      
      public function set icon_tl(param1:TileList) : void
      {
         var _loc2_:Object = this._1638774782icon_tl;
         if(_loc2_ !== param1)
         {
            this._1638774782icon_tl = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon_tl",_loc2_,param1));
         }
      }
      
      private function _ChooseSummonerIcon_State2_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseSummonerIcon_State2 = _loc1_;
         _loc1_.overrides = [this._ChooseSummonerIcon_AddChild1_i()];
         BindingManager.executeBindings(this,"_ChooseSummonerIcon_State2",this._ChooseSummonerIcon_State2);
         return _loc1_;
      }
      
      public function set cancel_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1888947991cancel_btn;
         if(_loc2_ !== param1)
         {
            this._1888947991cancel_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cancel_btn",_loc2_,param1));
         }
      }
      
      private function closeChooseIconDialog() : void
      {
         var _loc1_:Object = null;
         if(this.icon_tl != null)
         {
            _loc1_ = this.icon_tl.selectedItem;
            if(_loc1_ != null)
            {
               this.chooseIconModel.setChosenIcon(_loc1_.iconId,_loc1_.iconSource);
            }
            else
            {
               this.chooseIconModel.setChosenIcon(-1);
            }
         }
         this.clearSelection();
         this.onClosed.dispatch(this.onClosed);
      }
      
      private function _ChooseSummonerIcon_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = STATE_NONE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.currentState = param1;
         },"this.currentState");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = STATE_NONE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseSummonerIcon_State1.name = param1;
         },"_ChooseSummonerIcon_State1.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = STATE_LOADED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseSummonerIcon_State2.name = param1;
         },"_ChooseSummonerIcon_State2.name");
         result[2] = binding;
         binding = new Binding(this,function():UIComponent
         {
            return iconHolder;
         },function(param1:UIComponent):void
         {
            _ChooseSummonerIcon_AddChild1.relativeTo = param1;
         },"_ChooseSummonerIcon_AddChild1.relativeTo");
         result[3] = binding;
         binding = new Binding(this,function():IFactory
         {
            return new ClassFactory(ChooseIconRenderer);
         },function(param1:IFactory):void
         {
            icon_tl.itemRenderer = param1;
         },"icon_tl.itemRenderer");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return userIconList;
         },function(param1:Object):void
         {
            icon_tl.dataProvider = param1;
         },"icon_tl.dataProvider");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = STATE_LOADING;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseSummonerIcon_State3.name = param1;
         },"_ChooseSummonerIcon_State3.name");
         result[6] = binding;
         binding = new Binding(this,function():UIComponent
         {
            return iconHolder;
         },function(param1:UIComponent):void
         {
            _ChooseSummonerIcon_AddChild2.relativeTo = param1;
         },"_ChooseSummonerIcon_AddChild2.relativeTo");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return LOADING_SPINNER;
         },function(param1:Object):void
         {
            _ChooseSummonerIcon_Image1.source = param1;
         },"_ChooseSummonerIcon_Image1.source");
         result[8] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_chooseIcon_menuBg");
         },function(param1:Object):void
         {
            panel.setStyle("backgroundImage",param1);
         },"panel.backgroundImage");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerProfile_chooseIcon");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            header_lb.htmlText = param1;
         },"header_lb.htmlText");
         result[10] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_chooseIcon_iconArea");
         },function(param1:Object):void
         {
            _ChooseSummonerIcon_Image2.source = param1;
         },"_ChooseSummonerIcon_Image2.source");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerProfile_chooseIconInstructions");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ChooseSummonerIcon_TextArea1.htmlText = param1;
         },"_ChooseSummonerIcon_TextArea1.htmlText");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            cancel_btn.label = param1;
         },"cancel_btn.label");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_ok");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            next_btn.label = param1;
         },"next_btn.label");
         result[14] = binding;
         return result;
      }
      
      public function set panel(param1:Canvas) : void
      {
         var _loc2_:Object = this._106433028panel;
         if(_loc2_ !== param1)
         {
            this._106433028panel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"panel",_loc2_,param1));
         }
      }
      
      private function onUserIconListAvailable(param1:ArrayCollection) : void
      {
         this.currentState = STATE_LOADED;
         this.reorderSpecialIconsForVisibility(param1);
         this.userIconList = param1;
      }
      
      private function iconHolder_creationCompleteHandler() : void
      {
         this.userIconList = null;
         this.currentState = STATE_LOADING;
         this.chooseIconModel.getUserIconListObtained().add(this.onUserIconListAvailable);
         if(this.chooseIconModel.userIconList != null)
         {
            this.onUserIconListAvailable(this.chooseIconModel.userIconList);
         }
      }
      
      private function onIconSelected(param1:Number) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:AlertAction = null;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         if(this.tempIconsIdx == null)
         {
            _loc3_ = _loc2_.getString("resources","summonerProfile_temporaryIconsIds");
            if(_loc3_ != null)
            {
               this.tempIconsIdx = new Dictionary();
               _loc4_ = _loc3_.split(",");
               for each(_loc5_ in _loc4_)
               {
                  this.tempIconsIdx[Number(_loc5_)] = true;
               }
            }
         }
         if(this.tempIconsIdx != null && Boolean(this.tempIconsIdx[param1]))
         {
            _loc6_ = new AlertAction(_loc2_.getString("resources","summonerProfile_TemporaryIconTitle"),_loc2_.getString("resources","summonerProfile_justChoseATemporaryIconInstructions"));
            _loc6_.showNegative = false;
            _loc6_.setOkCancelLabels();
            _loc6_.add();
         }
      }
      
      private function _ChooseSummonerIcon_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = STATE_NONE;
         _loc1_ = STATE_NONE;
         _loc1_ = STATE_LOADED;
         _loc1_ = this.iconHolder;
         _loc1_ = new ClassFactory(ChooseIconRenderer);
         _loc1_ = this.userIconList;
         _loc1_ = STATE_LOADING;
         _loc1_ = this.iconHolder;
         _loc1_ = LOADING_SPINNER;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_chooseIcon_menuBg");
         _loc1_ = resourceManager.getString("resources","summonerProfile_chooseIcon");
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_chooseIcon_iconArea");
         _loc1_ = resourceManager.getString("resources","summonerProfile_chooseIconInstructions");
         _loc1_ = resourceManager.getString("resources","common_button_cancel");
         _loc1_ = resourceManager.getString("resources","common_button_ok");
      }
      
      [Bindable(event="propertyChange")]
      public function get next_btn() : SoundEffectButton
      {
         return this._1424721680next_btn;
      }
      
      public function __cancel_btn_click(param1:MouseEvent) : void
      {
         this.closeWithoutSaving();
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER && Boolean(this.next_btn.enabled))
         {
            this.next_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      private function set userIconList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1506094686userIconList;
         if(_loc2_ !== param1)
         {
            this._1506094686userIconList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userIconList",_loc2_,param1));
         }
      }
      
      public function ___ChooseSummonerIcon_Canvas1_show(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeInEffect(this);
      }
      
      private function clearSelection() : void
      {
         if(this.lastSelectedItem != null)
         {
            this.lastSelectedItem.selected = false;
         }
         this.lastSelectedItem = null;
      }
      
      private function closeWithoutSaving() : void
      {
         this.chooseIconModel.cancelChooseIcon();
         this.clearSelection();
         this.onClosed.dispatch(this.onClosed);
      }
      
      public function __iconHolder_creationComplete(param1:FlexEvent) : void
      {
         this.iconHolder_creationCompleteHandler();
      }
      
      private function _ChooseSummonerIcon_AddChild2_i() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         this._ChooseSummonerIcon_AddChild2 = _loc1_;
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._ChooseSummonerIcon_Image1_i);
         BindingManager.executeBindings(this,"_ChooseSummonerIcon_AddChild2",this._ChooseSummonerIcon_AddChild2);
         return _loc1_;
      }
      
      public function set header_lb(param1:Label) : void
      {
         var _loc2_:Object = this._213292952header_lb;
         if(_loc2_ !== param1)
         {
            this._213292952header_lb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_lb",_loc2_,param1));
         }
      }
      
      public function ___ChooseSummonerIcon_Canvas1_keyDown(param1:KeyboardEvent) : void
      {
         this.onKeyDown(param1);
      }
      
      private function _ChooseSummonerIcon_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         this._ChooseSummonerIcon_Image1 = _loc1_;
         _loc1_.scaleX = 1;
         _loc1_.scaleY = 1;
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.setStyle("verticalCenter","0");
         _loc1_.id = "_ChooseSummonerIcon_Image1";
         BindingManager.executeBindings(this,"_ChooseSummonerIcon_Image1",this._ChooseSummonerIcon_Image1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChooseSummonerIcon_TileList1_i() : TileList
      {
         var _loc1_:TileList = new TileList();
         this.icon_tl = _loc1_;
         _loc1_.columnCount = 5;
         _loc1_.rowHeight = 74.8;
         _loc1_.columnWidth = 74.8;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "summonerIconTileList";
         _loc1_.variableRowHeight = true;
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.setStyle("useRollOver",false);
         _loc1_.setStyle("verticalScrollBarStyleName","summonerIconScrollBar");
         _loc1_.addEventListener("change",this.__icon_tl_change);
         _loc1_.id = "icon_tl";
         BindingManager.executeBindings(this,"icon_tl",this.icon_tl);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_lb() : Label
      {
         return this._213292952header_lb;
      }
      
      public function __icon_tl_change(param1:ListEvent) : void
      {
         this.tileList_selectHandler(param1);
      }
      
      private function _ChooseSummonerIcon_State3_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseSummonerIcon_State3 = _loc1_;
         _loc1_.overrides = [this._ChooseSummonerIcon_AddChild2_i()];
         BindingManager.executeBindings(this,"_ChooseSummonerIcon_State3",this._ChooseSummonerIcon_State3);
         return _loc1_;
      }
      
      private function _ChooseSummonerIcon_State1_i() : State
      {
         var _loc1_:State = new State();
         this._ChooseSummonerIcon_State1 = _loc1_;
         BindingManager.executeBindings(this,"_ChooseSummonerIcon_State1",this._ChooseSummonerIcon_State1);
         return _loc1_;
      }
      
      private function _ChooseSummonerIcon_AddChild1_i() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         this._ChooseSummonerIcon_AddChild1 = _loc1_;
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._ChooseSummonerIcon_TileList1_i);
         BindingManager.executeBindings(this,"_ChooseSummonerIcon_AddChild1",this._ChooseSummonerIcon_AddChild1);
         return _loc1_;
      }
   }
}

