package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.gameclient.controllers.game.event.ChampionSelectionEvent;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionTrade;
   import com.riotgames.platform.gameclient.controllers.game.utils.ChampionImages;
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
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.Button;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import mx.states.State;
   import mx.styles.*;
   
   public class TradeRequestPanel extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const LOADING_SPINNER:Class = TradeRequestPanel_LOADING_SPINNER;
      
      private static const TRADE_INITIATOR:String = "TRADE_INITIATOR";
      
      private static const TRADE_TARGET:String = "TRADE_TARGET";
      
      private var _648321563pending_champ_img:Image;
      
      public var _TradeRequestPanel_Button2:Button;
      
      private var _1493011999selected_champ_img:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":327,
               "height":167,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":cs_tradeMenu,
                  "id":"tradeMenu"
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"_TradeRequestPanel_Button1",
                  "events":{"click":"___TradeRequestPanel_Button1_click"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "5";
                     this.right = "leftCol:-10";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"s1FormButton"};
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"_TradeRequestPanel_Button2",
                  "events":{"click":"___TradeRequestPanel_Button2_click"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "5";
                     this.left = "rightCol:10";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"s1FormButton"};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"championsSpinnerBackground",
                  "stylesFactory":function():void
                  {
                     this.bottom = "10";
                     this.horizontalCenter = "10";
                  }
               }),new UIComponentDescriptor({
                  "type":cs_championItem,
                  "id":"leftImage",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":65,
                        "y":35,
                        "content":_TradeRequestPanel_Image2_i()
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":cs_championItem,
                  "id":"rightImage",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":215,
                        "y":35,
                        "content":_TradeRequestPanel_Image3_i()
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"_TradeRequestPanel_Label1",
                  "stylesFactory":function():void
                  {
                     this.textAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":65,
                        "y":103,
                        "width":70,
                        "styleName":"tradeText"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"_TradeRequestPanel_Label2",
                  "stylesFactory":function():void
                  {
                     this.textAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":215,
                        "y":103,
                        "width":70,
                        "styleName":"tradeText"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"_TradeRequestPanel_Label3",
                  "stylesFactory":function():void
                  {
                     this.top = "4";
                     this.horizontalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"tradeTitle",
                        "selectable":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"cancel_btn",
                  "events":{"click":"__cancel_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "5";
                     this.right = "5";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"styleName":"s1FormButton"};
                  }
               })]
            };
         }
      });
      
      private var _504377593summonerName:String = "";
      
      private var _1721435540leftImage:cs_championItem;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      public var _TradeRequestPanel_Label1:Label;
      
      public var _TradeRequestPanel_Label2:Label;
      
      public var _TradeRequestPanel_Label3:Label;
      
      public var _TradeRequestPanel_State1:State;
      
      public var _TradeRequestPanel_State2:State;
      
      private var _1408178017rightImage:cs_championItem;
      
      private var _1888947991cancel_btn:Button;
      
      private var _1436106300rightCol:ConstraintColumn;
      
      private var _1499252765championsSpinnerBackground:Image;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _55416825leftCol:ConstraintColumn;
      
      private var _752691427tradeMenu:cs_tradeMenu;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      public var _TradeRequestPanel_Button1:Button;
      
      private var _championTrade:ChampionTrade;
      
      public function TradeRequestPanel()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.width = 327;
         this.height = 167;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.states = [this._TradeRequestPanel_State1_i(),this._TradeRequestPanel_State2_i()];
         this.constraintColumns = [this._TradeRequestPanel_ConstraintColumn1_i(),this._TradeRequestPanel_ConstraintColumn2_i()];
         this.addEventListener("creationComplete",this.___TradeRequestPanel_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TradeRequestPanel._watcherSetupUtil = param1;
      }
      
      public function set summonerName(param1:String) : void
      {
         var _loc2_:Object = this._504377593summonerName;
         if(_loc2_ !== param1)
         {
            this._504377593summonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName",_loc2_,param1));
         }
      }
      
      private function _TradeRequestPanel_Image2_i() : Image
      {
         var _loc1_:Image = new Image();
         this.pending_champ_img = _loc1_;
         _loc1_.id = "pending_champ_img";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onNoClicked() : void
      {
         if(this.currentState == TRADE_TARGET)
         {
            this.currentState = TRADE_INITIATOR;
            this.dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.TRADE_REFUSED,null,true));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TradeRequestPanel = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TradeRequestPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_TradeRequestPanelWatcherSetupUtil");
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
      public function get summonerName() : String
      {
         return this._504377593summonerName;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftImage() : cs_championItem
      {
         return this._1721435540leftImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get tradeMenu() : cs_tradeMenu
      {
         return this._752691427tradeMenu;
      }
      
      [Bindable(event="propertyChange")]
      public function get championsSpinnerBackground() : Image
      {
         return this._1499252765championsSpinnerBackground;
      }
      
      private function _TradeRequestPanel_State2_i() : State
      {
         var _loc1_:State = new State();
         this._TradeRequestPanel_State2 = _loc1_;
         BindingManager.executeBindings(this,"_TradeRequestPanel_State2",this._TradeRequestPanel_State2);
         return _loc1_;
      }
      
      private function onTradeCancelClicked() : void
      {
         this.dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.TRADE_CANCELED,null,true));
      }
      
      public function set leftImage(param1:cs_championItem) : void
      {
         var _loc2_:Object = this._1721435540leftImage;
         if(_loc2_ !== param1)
         {
            this._1721435540leftImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftImage",_loc2_,param1));
         }
      }
      
      public function ___TradeRequestPanel_Button2_click(param1:MouseEvent) : void
      {
         this.onNoClicked();
      }
      
      public function set cancel_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1888947991cancel_btn;
         if(_loc2_ !== param1)
         {
            this._1888947991cancel_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cancel_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cancel_btn() : Button
      {
         return this._1888947991cancel_btn;
      }
      
      private function _TradeRequestPanel_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = TRADE_INITIATOR;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeRequestPanel_State1.name = param1;
         },"_TradeRequestPanel_State1.name");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = TRADE_TARGET;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeRequestPanel_State2.name = param1;
         },"_TradeRequestPanel_State2.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","common_button_yes");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeRequestPanel_Button1.label = param1;
         },"_TradeRequestPanel_Button1.label");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == TRADE_TARGET;
         },function(param1:Boolean):void
         {
            _TradeRequestPanel_Button1.visible = param1;
         },"_TradeRequestPanel_Button1.visible");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","common_button_no");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeRequestPanel_Button2.label = param1;
         },"_TradeRequestPanel_Button2.label");
         result[4] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == TRADE_TARGET;
         },function(param1:Boolean):void
         {
            _TradeRequestPanel_Button2.visible = param1;
         },"_TradeRequestPanel_Button2.visible");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return this.currentState == TRADE_INITIATOR ? LOADING_SPINNER : null;
         },function(param1:Object):void
         {
            championsSpinnerBackground.source = param1;
         },"championsSpinnerBackground.source");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == TRADE_INITIATOR;
         },function(param1:Boolean):void
         {
            championsSpinnerBackground.visible = param1;
         },"championsSpinnerBackground.visible");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","champion_trading_trade_recieving");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeRequestPanel_Label1.text = param1;
         },"_TradeRequestPanel_Label1.text");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","champion_trading_trade_giving");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeRequestPanel_Label2.text = param1;
         },"_TradeRequestPanel_Label2.text");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.currentState == TRADE_INITIATOR ? ResourceManager.getInstance().getString("resources","champion_trading_pending_trade_title") : ResourceManager.getInstance().getString("resources","champion_trading_requested_trade_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TradeRequestPanel_Label3.text = param1;
         },"_TradeRequestPanel_Label3.text");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","common_button_cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            cancel_btn.label = param1;
         },"cancel_btn.label");
         result[11] = binding;
         return result;
      }
      
      private function onTradeCancellableChanged(param1:Event) : void
      {
         if(this.cancel_btn)
         {
            this.cancel_btn.visible = this.championTrade.tradeCancellable;
         }
      }
      
      public function set rightCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1436106300rightCol;
         if(_loc2_ !== param1)
         {
            this._1436106300rightCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightCol",_loc2_,param1));
         }
      }
      
      private function _TradeRequestPanel_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = TRADE_INITIATOR;
         _loc1_ = TRADE_TARGET;
         _loc1_ = ResourceManager.getInstance().getString("resources","common_button_yes");
         _loc1_ = this.currentState == TRADE_TARGET;
         _loc1_ = ResourceManager.getInstance().getString("resources","common_button_no");
         _loc1_ = this.currentState == TRADE_TARGET;
         _loc1_ = this.currentState == TRADE_INITIATOR ? LOADING_SPINNER : null;
         _loc1_ = this.currentState == TRADE_INITIATOR;
         _loc1_ = ResourceManager.getInstance().getString("resources","champion_trading_trade_recieving");
         _loc1_ = ResourceManager.getInstance().getString("resources","champion_trading_trade_giving");
         _loc1_ = this.currentState == TRADE_INITIATOR ? ResourceManager.getInstance().getString("resources","champion_trading_pending_trade_title") : ResourceManager.getInstance().getString("resources","champion_trading_requested_trade_title");
         _loc1_ = ResourceManager.getInstance().getString("resources","common_button_cancel");
      }
      
      private function onCreationComplete() : void
      {
         this.setChampionTrade();
      }
      
      protected function setChampionTrade() : void
      {
         if(this.championTrade == null)
         {
            return;
         }
         this.currentState = this.championTrade.tradeHost ? TRADE_INITIATOR : TRADE_TARGET;
         if(Boolean(this.pending_champ_img) && Boolean(this.championTrade.pendingChampion))
         {
            this.pending_champ_img.source = ChampionImages.getIconPath(this.championTrade.pendingChampion.skinName);
         }
         if(Boolean(this.selected_champ_img) && Boolean(this.championTrade.selectedChampion))
         {
            this.selected_champ_img.source = ChampionImages.getIconPath(this.championTrade.selectedChampion.skinName);
         }
         if(this.cancel_btn)
         {
            this.cancel_btn.visible = this.championTrade.tradeCancellable;
         }
         this.championTrade.addEventListener("tradeCancellableChanged",this.onTradeCancellableChanged);
      }
      
      public function set championsSpinnerBackground(param1:Image) : void
      {
         var _loc2_:Object = this._1499252765championsSpinnerBackground;
         if(_loc2_ !== param1)
         {
            this._1499252765championsSpinnerBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championsSpinnerBackground",_loc2_,param1));
         }
      }
      
      private function _TradeRequestPanel_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftCol = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"leftCol");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get pending_champ_img() : Image
      {
         return this._648321563pending_champ_img;
      }
      
      public function set rightImage(param1:cs_championItem) : void
      {
         var _loc2_:Object = this._1408178017rightImage;
         if(_loc2_ !== param1)
         {
            this._1408178017rightImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightImage",_loc2_,param1));
         }
      }
      
      public function __cancel_btn_click(param1:MouseEvent) : void
      {
         this.onTradeCancelClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get rightImage() : cs_championItem
      {
         return this._1408178017rightImage;
      }
      
      private function _TradeRequestPanel_Image3_i() : Image
      {
         var _loc1_:Image = new Image();
         this.selected_champ_img = _loc1_;
         _loc1_.id = "selected_champ_img";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function update() : void
      {
         if(this.championTrade == null)
         {
            return;
         }
         if(this.pending_champ_img)
         {
            this.pending_champ_img.source = ChampionImages.getIconPath(this.championTrade.pendingChampion.skinName);
         }
         if(this.selected_champ_img)
         {
            this.selected_champ_img.source = ChampionImages.getIconPath(this.championTrade.selectedChampion.skinName);
         }
         if(this.cancel_btn)
         {
            this.cancel_btn.visible = this.championTrade.tradeCancellable;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightCol() : ConstraintColumn
      {
         return this._1436106300rightCol;
      }
      
      public function set pending_champ_img(param1:Image) : void
      {
         var _loc2_:Object = this._648321563pending_champ_img;
         if(_loc2_ !== param1)
         {
            this._648321563pending_champ_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pending_champ_img",_loc2_,param1));
         }
      }
      
      private function _TradeRequestPanel_State1_i() : State
      {
         var _loc1_:State = new State();
         this._TradeRequestPanel_State1 = _loc1_;
         BindingManager.executeBindings(this,"_TradeRequestPanel_State1",this._TradeRequestPanel_State1);
         return _loc1_;
      }
      
      public function ___TradeRequestPanel_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function set selected_champ_img(param1:Image) : void
      {
         var _loc2_:Object = this._1493011999selected_champ_img;
         if(_loc2_ !== param1)
         {
            this._1493011999selected_champ_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selected_champ_img",_loc2_,param1));
         }
      }
      
      protected function removeChampionTrade() : void
      {
         if(this.championTrade == null)
         {
            return;
         }
         this.currentState = TRADE_INITIATOR;
         if(this.pending_champ_img)
         {
            this.pending_champ_img.source = null;
         }
         if(this.selected_champ_img)
         {
            this.selected_champ_img.source = null;
         }
         if(this.cancel_btn)
         {
            this.cancel_btn.visible = false;
         }
         this.championTrade.removeEventListener("tradeCancellableChanged",this.onTradeCancellableChanged);
      }
      
      public function set tradeMenu(param1:cs_tradeMenu) : void
      {
         var _loc2_:Object = this._752691427tradeMenu;
         if(_loc2_ !== param1)
         {
            this._752691427tradeMenu = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tradeMenu",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selected_champ_img() : Image
      {
         return this._1493011999selected_champ_img;
      }
      
      public function ___TradeRequestPanel_Button1_click(param1:MouseEvent) : void
      {
         this.onYesClicked();
      }
      
      private function _TradeRequestPanel_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightCol = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"rightCol");
         return _loc1_;
      }
      
      public function set leftCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._55416825leftCol;
         if(_loc2_ !== param1)
         {
            this._55416825leftCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftCol",_loc2_,param1));
         }
      }
      
      public function set championTrade(param1:ChampionTrade) : void
      {
         if(this._championTrade == param1)
         {
            return;
         }
         this.removeChampionTrade();
         this._championTrade = param1;
         this.setChampionTrade();
      }
      
      [Bindable(event="propertyChange")]
      public function get leftCol() : ConstraintColumn
      {
         return this._55416825leftCol;
      }
      
      public function get championTrade() : ChampionTrade
      {
         return this._championTrade;
      }
      
      private function onYesClicked() : void
      {
         if(this.currentState == TRADE_TARGET)
         {
            this.currentState = TRADE_INITIATOR;
            this.dispatchEvent(new ChampionSelectionEvent(ChampionSelectionEvent.TRADE_ACCEPTED,null,true));
         }
      }
   }
}

